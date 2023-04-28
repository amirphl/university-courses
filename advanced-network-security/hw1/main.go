package main

import (
	"bufio"
	"bytes"
	"crypto/aes"
	"crypto/cipher"
	"crypto/ecdsa"
	"crypto/elliptic"
	"crypto/rand"
	"crypto/sha256"
	"encoding/binary"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"math/big"
	"net"
	"os"
	"sync"
	"time"
)

// TODO Stop goroutines.

const (
	_getPubkey byte = iota + 1
	_postPubkey
	_postMsg
)
const (
	_serverAddress = ":9000"
)

var (
	_iv = []byte("1234567890123456")
)

type UserID int

type Pubkey struct {
	X []byte `json:"x"`
	Y []byte `json:"y"`
}

type User struct {
	id         UserID
	pubkey     Pubkey
	revMsgs    chan *RevMsg
	revPubkeys chan *RevPubkey
}

type RegReq struct {
	userID     UserID
	Pubkey     Pubkey `json:"pubkey"`
	revMsgs    chan *RevMsg
	revPubkeys chan *RevPubkey
}

type MsgReq struct {
	from    UserID
	To      UserID `json:"to"`
	Content []byte `json:"content"`
}

type RevMsg struct {
	From    UserID `json:"from"`
	Content []byte `json:"content"`
}

type PubkeyReq struct {
	from   UserID
	UserID UserID `json:"userId"`
}

type RevPubkey struct {
	UserID UserID `json:"userId"`
	Pubkey Pubkey `json:"pubkey"`
}

func writeProtocol(conn net.Conn, view []byte, command byte) error {
	size := int64(len(view))

	if err := binary.Write(conn, binary.LittleEndian, size); err != nil {
		return err
	}

	if err := binary.Write(conn, binary.LittleEndian, command); err != nil {
		return err
	}

	if _, err := conn.Write(view); err != nil {
		return err
	}

	return nil
}

func readProtocol(conn net.Conn) (byte, []byte, error) {
	var (
		size    int64
		command byte
	)

	if err := binary.Read(conn, binary.LittleEndian, &size); err != nil {
		return 0, nil, fmt.Errorf("size: %v", err)
	}

	if size == 0 {
		return 0, nil, fmt.Errorf("empty message")
	}

	if err := binary.Read(conn, binary.LittleEndian, &command); err != nil {
		return 0, nil, fmt.Errorf("command: %v", err)
	}

	view := make([]byte, size)

	if _, err := io.ReadFull(conn, view); err != nil {
		return 0, nil, fmt.Errorf("view: %v", err)
	}

	return command, view, nil
}

func handleRevMsgsToClient(conn net.Conn, revMsgs chan *RevMsg) {
	for rev := range revMsgs {
		raw, _ := json.Marshal(rev)

		if err := writeProtocol(conn, raw, _postMsg); err != nil {
			log.Printf("server: write message: %v", err)
		}
	}
}
func handleRevPubkeysToClient(conn net.Conn, revPubkeys chan *RevPubkey) {
	for rev := range revPubkeys {
		raw, _ := json.Marshal(rev)

		if err := writeProtocol(conn, raw, _postPubkey); err != nil {
			log.Printf("server: write pubkey: %v", err)
		}
	}
}

func handleClient(
	conn net.Conn,
	regReqs chan *RegReq,
	msgReqs chan *MsgReq,
	pubkeyReqs chan *PubkeyReq,
	userID UserID,
) {
	defer conn.Close()

	revMsgs := make(chan *RevMsg)
	revPubkeys := make(chan *RevPubkey)

	defer close(revMsgs)
	defer close(revPubkeys)

	go handleRevMsgsToClient(conn, revMsgs)
	go handleRevPubkeysToClient(conn, revPubkeys)

	for {
		command, view, err := readProtocol(conn)

		if err != nil {
			log.Printf("server: read protocol: %v", err)
			// TODO Remove user.
			break
		}

		if command == _postMsg {
			req := MsgReq{}

			if err := json.Unmarshal(view, &req); err != nil {
				log.Printf("server: unmarshal new message: %v", err)
				continue
			}

			req.from = userID

			// TODO Recover from panic.
			msgReqs <- &req
		} else if command == _getPubkey {
			req := PubkeyReq{}

			if err := json.Unmarshal(view, &req); err != nil {
				log.Printf("server: unmarshal pubkey req: %v", err)
				continue
			}

			req.from = userID

			// TODO Recover from panic.
			pubkeyReqs <- &req
		} else if command == _postPubkey {
			req := RegReq{}

			if err := json.Unmarshal(view, &req); err != nil {
				log.Printf("server: unmarshal registeration req: : %v", err)
				continue
			}

			req.userID = userID
			req.revMsgs = revMsgs
			req.revPubkeys = revPubkeys

			// TODO Recover from panic.
			regReqs <- &req
		} else {
			log.Printf("server: unsupported protocol: %v", command)
			continue
		}
	}
}

func handleRegReqsFromClients(users map[UserID]*User, regReqs chan *RegReq) {
	for req := range regReqs {
		if _, ok := users[req.userID]; ok {
			log.Printf("server: user registeration: duplicate userId: %v", req.userID)
			continue
		}

		user := &User{
			id:         req.userID,
			pubkey:     req.Pubkey,
			revMsgs:    req.revMsgs,
			revPubkeys: req.revPubkeys,
		}

		users[user.id] = user

		log.Printf("user %v joined.", req.userID)
	}
}

func handleMsgReqsFromClients(users map[UserID]*User, msgReqs chan *MsgReq) {
	for req := range msgReqs {
		to, ok := users[req.To]

		if !ok {
			log.Printf("server: send message: destination userId not found: %v", req.To)
			continue
		}

		func() {
			defer func() {
				if r := recover(); r != nil {
					log.Printf("recovered: server: send message from %v to %v: %v", req.from, req.To, r)
				}
			}()

			to.revMsgs <- &RevMsg{
				From:    req.from,
				Content: req.Content,
			}
		}()
	}
}

func handlePubkeyReqsFromClients(users map[UserID]*User, pubkeyReqs chan *PubkeyReq) {
	for req := range pubkeyReqs {
		from, ok := users[req.from]

		if !ok {
			log.Printf("server: pubkey request: source userId not found: %v", req.from)
			continue
		}

		to, ok := users[req.UserID]

		if !ok {
			log.Printf("server: pubkey request: destination userId not found: %v", req.UserID)
			continue
		}

		func() {
			defer func() {
				if r := recover(); r != nil {
					log.Printf("recovered: server: send pubkey of %v to %v: %v", req.UserID, req.from, r)
				}
			}()

			from.revPubkeys <- &RevPubkey{
				UserID: to.id,
				Pubkey: to.pubkey,
			}
		}()
	}
}

func runServer() {
	var (
		numUsers   int
		users      = make(map[UserID]*User)
		regReqs    = make(chan *RegReq)
		msgReqs    = make(chan *MsgReq)
		pubkeyReqs = make(chan *PubkeyReq)
		mu         sync.Mutex
	)

	defer close(regReqs)
	defer close(msgReqs)
	defer close(pubkeyReqs)

	server, err := net.Listen("tcp", _serverAddress)

	if err != nil {
		log.Printf("server: bind: %v", err)
		return
	}

	defer server.Close()

	go handleRegReqsFromClients(users, regReqs)
	go handleMsgReqsFromClients(users, msgReqs)
	go handlePubkeyReqsFromClients(users, pubkeyReqs)

	for {
		conn, err := server.Accept()

		if err != nil {
			log.Printf("server: accept: %v", err)
			continue
		}

		mu.Lock()
		{
			numUsers++
			userID := numUsers
			go handleClient(
				conn,
				regReqs,
				msgReqs,
				pubkeyReqs,
				UserID(userID),
			)
		}
		mu.Unlock()
	}
}

func sendPubkeyToServer(conn net.Conn, pubkey ecdsa.PublicKey) error {
	req := RegReq{
		Pubkey: Pubkey{
			X: pubkey.X.Bytes(),
			Y: pubkey.Y.Bytes(),
		},
	}

	raw, _ := json.Marshal(req)

	return writeProtocol(conn, raw, _postPubkey)
}

func newKeyPair() (*ecdsa.PrivateKey, ecdsa.PublicKey) {
	privkey, _ := ecdsa.GenerateKey(elliptic.P256(), rand.Reader)
	pubkey := privkey.PublicKey

	return privkey, pubkey
}

func PKCS5Padding(cipherText []byte, blockSize int, after int) []byte {
	padding := (blockSize - len(cipherText)%blockSize)
	padtext := bytes.Repeat([]byte{byte(padding)}, padding)

	return append(cipherText, padtext...)
}

func PKCS5UnPadding(src []byte) []byte {
	length := len(src)
	unpadding := int(src[length-1])

	return src[:(length - unpadding)]
}

func encrypt(plainText []byte, symmetricKey [32]byte) []byte {
	padded := PKCS5Padding(plainText, aes.BlockSize, len(plainText))
	block, _ := aes.NewCipher(symmetricKey[:])
	cipherText := make([]byte, len(padded))
	mode := cipher.NewCBCEncrypter(block, _iv)
	mode.CryptBlocks(cipherText, padded)

	return cipherText
}

func decrypt(cipherText []byte, symmetricKey [32]byte) []byte {
	block, _ := aes.NewCipher(symmetricKey[:])
	plainText := make([]byte, len(cipherText))
	mode := cipher.NewCBCDecrypter(block, _iv)
	mode.CryptBlocks(plainText, cipherText)
	padded := PKCS5UnPadding(plainText)

	return padded
}

func runClient(outputFileName string) {
	f, err := os.Create(outputFileName)

	if err != nil {
		log.Printf("client: file: %v", err)
		return
	}

	conn, err := net.Dial("tcp", _serverAddress)

	if err != nil {
		log.Printf("client: dial: %v", err)
		return
	}

	defer conn.Close()

	myPrivkey, myPubkey := newKeyPair()

	if err := sendPubkeyToServer(conn, myPubkey); err != nil {
		log.Printf("client: send pubkey: %v", err)
		return
	}

	symmetricKeys := make(map[UserID][32]byte)

	msgReqs := make(chan *MsgReq)
	pubkeyReqs := make(chan *PubkeyReq)

	defer close(msgReqs)
	defer close(pubkeyReqs)

	go func() {
		for req := range msgReqs {
			raw, _ := json.Marshal(req)

			if err := writeProtocol(conn, raw, _postMsg); err != nil {
				log.Printf("client: send message: %v", err)
				continue
			}
		}
	}()

	go func() {
		for req := range pubkeyReqs {
			raw, _ := json.Marshal(req)

			if err := writeProtocol(conn, raw, _getPubkey); err != nil {
				log.Printf("client: pubkey request: %v", err)
				continue
			}
		}
	}()

	go func() {
		for {
			command, view, err := readProtocol(conn)

			if err != nil {
				log.Printf("client: read protocol: %v", err)
				// TODO Terminate session.
				break
			}

			if command == _postMsg {
				rev := RevMsg{}

				if err := json.Unmarshal(view, &rev); err != nil {
					log.Printf("client: unmarshal new message: %v", err)
					continue
				}

				symKey, ok := symmetricKeys[rev.From]

				if !ok {
					log.Printf("client: dest pubkey not found: %v", rev.From)
					continue
				}

				plainText := decrypt(rev.Content, symKey)

				f.WriteString(fmt.Sprintf("From: %v\n", rev.From))
				f.WriteString(fmt.Sprintf("Encrypted Message: %v\n", string(rev.Content)))
				f.WriteString(fmt.Sprintf("Decrypted Message: %v\n", string(plainText)))
			} else if command == _postPubkey {
				rev := RevPubkey{}

				if err := json.Unmarshal(view, &rev); err != nil {
					log.Printf("client: unmarshal pubkey: %v", err)
					continue
				}

				// building the symmetric secret key

				var (
					x *big.Int = new(big.Int)
					y *big.Int = new(big.Int)
				)

				x.SetBytes(rev.Pubkey.X)
				y.SetBytes(rev.Pubkey.Y)

				a, _ := elliptic.P256().ScalarMult(x, y, myPrivkey.D.Bytes())
				symmetricKeys[rev.UserID] = sha256.Sum256(a.Bytes())
			} else {
				log.Printf("client: unsupported protocol: %v", command)
				continue
			}
		}
	}()

	for {
		var (
			opt        byte
			destUserID UserID
			in         = bufio.NewReader(os.Stdin)
		)

		fmt.Printf("To send message, enter %v, to receive pubkey, enter %v:", _postMsg, _getPubkey)

		if _, err := fmt.Scanln(&opt); err != nil {
			log.Print(err)
			return
		}

		if opt == _postMsg {
			fmt.Println("Enter destination userId:")

			if _, err := fmt.Scanln(&destUserID); err != nil {
				log.Print(err)
				return
			}

			symKey, ok := symmetricKeys[destUserID]

			if !ok {
				// TODO Recover from panic.
				pubkeyReqs <- &PubkeyReq{
					UserID: destUserID,
				}
			}

			fmt.Println("Enter message:")

			plainText, err := in.ReadString('\n')

			if err != nil {
				log.Print(err)
				return
			}

			for {
				if _, ok := symmetricKeys[destUserID]; ok {
					cipherText := encrypt([]byte(plainText), symKey)

					// TODO Recover from panic.
					msgReqs <- &MsgReq{
						To:      destUserID,
						Content: cipherText,
					}

					fmt.Println("message request sent.")

					break
				}

				fmt.Println("waiting to receive pubkey of destination.")
				time.Sleep(1 * time.Second)
			}
		} else if opt == _getPubkey {
			// TODO duplicate code
			fmt.Println("Enter destination userId:")

			if _, err := fmt.Scanln(&destUserID); err != nil {
				log.Print(err)
				return
			}

			if _, ok := symmetricKeys[destUserID]; !ok {
				// TODO recover from panic.
				pubkeyReqs <- &PubkeyReq{
					UserID: destUserID,
				}
				fmt.Println("pubkey request sent.")
			} else {
				fmt.Println("pubkey already exists.")
			}
		} else {
			fmt.Println("invalid input. try again.")
		}
	}
}

// go run main.go server
// go run main.go client client_1.txt
// go run main.go client client_2.txt

func main() {
	opt := os.Args[1]

	if opt == "server" {
		runServer()
	} else {
		outputFileName := os.Args[2]
		runClient(outputFileName)
	}
}
