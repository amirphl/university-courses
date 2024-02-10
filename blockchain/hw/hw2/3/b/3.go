package main

// from https://gist.github.com/xjdrew/9061d47cc39eec8c564ba058ab24130d

import (
	"bufio"
	"crypto/dsa"
	"crypto/rand"
	"crypto/x509"
	"encoding/asn1"
	"encoding/pem"
	"errors"
	"fmt"
	"io"
	"math/big"
	"os"
)

const DSA_PARAMS = `-----BEGIN DSA PARAMETERS-----
MIIBHgKBgQCJ/LcSpeM9HXxOdyAUm56gvHgv07/dRvcNzbrmeFXpcNbQlRBltGQe
PVBRXq3UCOv0+PKVi89EDPaDDhMSNhJ1OiHi+PbRQ97gmaAwLyVrscd8/wZMBpoZ
IWenHtnygUpUowy7HJZ2U7atBgduw2XMFsQpvIHlQ+rr8giAq16hnQIVAMCuOLI6
5H9j+TbHMv1ueXKvXrtTAoGAB45uDOHylIbwXggDkEAOa94Xskzy0E4A5GJAj8nY
ppQ8Qvrt3fxg1rajwIQpMHKiurg2VclgIaieX+iw5S9+7J8qcwwSu1bp2svRIpGC
nyZFo1nTFf4ZZ78YOr4TxzFGa7cQHlgSzWAXrGOSn1cphH6D4c0yApqZZVSM0SKo
9Hc=
-----END DSA PARAMETERS-----`

const DSA_PRIVATE_KEY = `-----BEGIN DSA PRIVATE KEY-----
MIIBugIBAAKBgQCJ/LcSpeM9HXxOdyAUm56gvHgv07/dRvcNzbrmeFXpcNbQlRBl
tGQePVBRXq3UCOv0+PKVi89EDPaDDhMSNhJ1OiHi+PbRQ97gmaAwLyVrscd8/wZM
BpoZIWenHtnygUpUowy7HJZ2U7atBgduw2XMFsQpvIHlQ+rr8giAq16hnQIVAMCu
OLI65H9j+TbHMv1ueXKvXrtTAoGAB45uDOHylIbwXggDkEAOa94Xskzy0E4A5GJA
j8nYppQ8Qvrt3fxg1rajwIQpMHKiurg2VclgIaieX+iw5S9+7J8qcwwSu1bp2svR
IpGCnyZFo1nTFf4ZZ78YOr4TxzFGa7cQHlgSzWAXrGOSn1cphH6D4c0yApqZZVSM
0SKo9HcCgYBAMMeNeTYPqPq387WiVAtfsuhkLmjG8lpqrzAMUXah9Snkr0MHypJT
gKWVdb+q+rMXyq0UU0vQm2pcYxuhakgdJCgmC//wTKASnp2MtRw7SoUfIZyZYH4G
goQdMcwA7Rv5LH391MrGjrXUHiXSX5YzBIRrWP2jhiTqAbhQuPSfkwIUAkxfjZV0
VPGwdaAdcsgZKUEE64k=
-----END DSA PRIVATE KEY-----`

const DSA_PUBLIC_KEY = `-----BEGIN PUBLIC KEY-----
MIIBtjCCASsGByqGSM44BAEwggEeAoGBAIn8txKl4z0dfE53IBSbnqC8eC/Tv91G
9w3NuuZ4Velw1tCVEGW0ZB49UFFerdQI6/T48pWLz0QM9oMOExI2EnU6IeL49tFD
3uCZoDAvJWuxx3z/BkwGmhkhZ6ce2fKBSlSjDLsclnZTtq0GB27DZcwWxCm8geVD
6uvyCICrXqGdAhUAwK44sjrkf2P5Nscy/W55cq9eu1MCgYAHjm4M4fKUhvBeCAOQ
QA5r3heyTPLQTgDkYkCPydimlDxC+u3d/GDWtqPAhCkwcqK6uDZVyWAhqJ5f6LDl
L37snypzDBK7Vunay9EikYKfJkWjWdMV/hlnvxg6vhPHMUZrtxAeWBLNYBesY5Kf
VymEfoPhzTICmpllVIzRIqj0dwOBhAACgYBAMMeNeTYPqPq387WiVAtfsuhkLmjG
8lpqrzAMUXah9Snkr0MHypJTgKWVdb+q+rMXyq0UU0vQm2pcYxuhakgdJCgmC//w
TKASnp2MtRw7SoUfIZyZYH4GgoQdMcwA7Rv5LH391MrGjrXUHiXSX5YzBIRrWP2j
hiTqAbhQuPSfkw==
-----END PUBLIC KEY-----`

type dsaSignature struct {
	R, S, K *big.Int
	_       struct{}
}

type dsaVerify struct {
	W, U1, U2, V *big.Int
	_            struct{}
}

func readFile(file string) ([]byte, error) {
	var (
		out []byte
		err error
	)
	switch file {
	case "params":
		out = []byte(DSA_PARAMS)
	case "pub":
		out = []byte(DSA_PUBLIC_KEY)
	case "priv":
		out = []byte(DSA_PRIVATE_KEY)
	default:
		err = errors.New("file not found")
	}
	return out, err
}

func ParseDSAPrivateKey(der []byte) (*dsa.PrivateKey, error) {
	var k struct {
		Version int
		P       *big.Int
		Q       *big.Int
		G       *big.Int
		Pub     *big.Int
		Priv    *big.Int
	}
	rest, err := asn1.Unmarshal(der, &k)
	if err != nil {
		return nil, errors.New("failed to parse DSA key: " + err.Error())
	}
	if len(rest) > 0 {
		return nil, errors.New("garbage after DSA key")
	}

	return &dsa.PrivateKey{
		PublicKey: dsa.PublicKey{
			Parameters: dsa.Parameters{
				P: k.P,
				Q: k.Q,
				G: k.G,
			},
			Y: k.Pub,
		},
		X: k.Priv,
	}, nil
}

func ParseDSAPublicKey(der []byte) (*dsa.PublicKey, error) {
	pub, err := x509.ParsePKIXPublicKey(der)
	if err != nil {
		return nil, err
	}

	switch pub := pub.(type) {
	case *dsa.PublicKey:
		return pub, nil
	default:
		return nil, errors.New("invalid type of public key")
	}
}

func ParseDSAPrivateKeyFromFile(path string) (*dsa.PrivateKey, error) {
	chunk, err := readFile(path)
	if err != nil {
		return nil, err
	}

	block, _ := pem.Decode(chunk)
	if err != nil {
		return nil, errors.New("failed to parse PEM block")
	}
	return ParseDSAPrivateKey(block.Bytes)
}

func ParseDSAPublicKeyFromFile(path string) (*dsa.PublicKey, error) {
	chunk, err := readFile(path)
	if err != nil {
		return nil, err
	}

	block, _ := pem.Decode(chunk)
	if err != nil {
		return nil, errors.New("failed to parse PEM block")
	}
	return ParseDSAPublicKey(block.Bytes)
}

// func ParseSignatureFromFile(path string) (*big.Int, *big.Int, error) {
// 	chunk, err := readFile(path)
// 	if err != nil {
// 		return nil, nil, err
// 	}
// 	var s dsaSignature

// 	rest, err := asn1.Unmarshal(chunk, &s)
// 	if err != nil {
// 		return nil, nil, errors.New("failed to parse signature: " + err.Error())
// 	}
// 	if len(rest) > 0 {
// 		return nil, nil, errors.New("garbage after signature")
// 	}
// 	return s.R, s.S, nil
// }

const MAX = 1000000007

func hash(file string) uint64 {
	sum := uint64(1)
	for _, c := range file {
		sum = sum * uint64(c) % MAX
	}
	return sum
}

func fermatInverse(k, P *big.Int) *big.Int {
	two := big.NewInt(2)
	pMinus2 := new(big.Int).Sub(P, two)
	return new(big.Int).Exp(k, pMinus2, P)
}

func sign(rand io.Reader, priv *dsa.PrivateKey, hash uint64) (*dsaSignature, error) {
	// randutil.MaybeReadByte(rand)

	// FIPS 186-3, section 4.6

	n := priv.Q.BitLen()
	if priv.Q.Sign() <= 0 || priv.P.Sign() <= 0 || priv.G.Sign() <= 0 || priv.X.Sign() <= 0 || n%8 != 0 {
		return nil, dsa.ErrInvalidPublicKey
	}
	n >>= 3

	k := big.NewInt(0)
	var r, s *big.Int
	var attempts int
	for attempts = 10; attempts > 0; attempts-- {
		buf := make([]byte, n)
		for {
			_, err := io.ReadFull(rand, buf)
			if err != nil {
				return nil, err
			}
			k.SetBytes(buf)
			// priv.Q must be >= 128 because the test above
			// requires it to be > 0 and that
			//    ceil(log_2(Q)) mod 8 = 0
			// Thus this loop will quickly terminate.
			if k.Sign() > 0 && k.Cmp(priv.Q) < 0 {
				break
			}
		}

		kInv := fermatInverse(k, priv.Q)

		r = new(big.Int).Exp(priv.G, k, priv.P)
		r.Mod(r, priv.Q)

		if r.Sign() == 0 {
			continue
		}

		z := new(big.Int).SetUint64(hash)

		s = new(big.Int).Mul(priv.X, r)
		s.Add(s, z)
		s.Mod(s, priv.Q)
		s.Mul(s, kInv)
		s.Mod(s, priv.Q)

		if s.Sign() != 0 {
			break
		}
	}

	// Only degenerate private keys will require more than a handful of
	// attempts.
	if attempts == 0 {
		return nil, dsa.ErrInvalidPublicKey
	}

	return &dsaSignature{R: r, S: s, K: k}, nil
}

func verify(pub *dsa.PublicKey, hash uint64, sig *dsaSignature) (bool, *dsaVerify) {
	// FIPS 186-3, section 4.7

	if pub.P.Sign() == 0 {
		return false, nil
	}

	if sig.R.Sign() < 1 || sig.R.Cmp(pub.Q) >= 0 {
		return false, nil
	}
	if sig.S.Sign() < 1 || sig.S.Cmp(pub.Q) >= 0 {
		return false, nil
	}

	w := new(big.Int).ModInverse(sig.S, pub.Q)
	if w == nil {
		return false, nil
	}

	n := pub.Q.BitLen()
	if n%8 != 0 {
		return false, nil
	}
	z := new(big.Int).SetUint64(hash)

	u1 := new(big.Int).Mul(z, w)
	u1.Mod(u1, pub.Q)
	u2 := new(big.Int).Mul(sig.R, w)
	u2.Mod(u2, pub.Q)
	v := new(big.Int).Exp(pub.G, u1, pub.P)
	t := new(big.Int).Exp(pub.Y, u2, pub.P)
	v.Mul(v, t)
	v.Mod(v, pub.P)
	v.Mod(v, pub.Q)

	b := v.Cmp(sig.R) == 0

	return b, &dsaVerify{
		W:  w,
		U1: u1,
		U2: u2,
		V:  v,
	}
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Scan()
	msg1 := scanner.Text()
	scanner.Scan()
	msg2 := scanner.Text()
	hash1 := hash(msg1)
	hash2 := hash(msg2)
	privKey, _ := ParseDSAPrivateKeyFromFile("priv")
	pubKey, _ := ParseDSAPublicKeyFromFile("pub")
	fmt.Println(privKey.P)
	fmt.Println(privKey.Q)
	fmt.Println(privKey.G)
	fmt.Println(privKey.X)
	fmt.Println(privKey.Y)
	sig, err := sign(rand.Reader, privKey, hash1)
	if err != nil {
		panic(err)
	}
	fmt.Println(sig.K)
	fmt.Println(sig.R)
	fmt.Println(sig.S)
	ok, ver := verify(pubKey, hash2, sig)
	fmt.Println(ver.W)
	fmt.Println(ver.U1)
	fmt.Println(ver.U2)
	fmt.Println(ver.V)
	verified := "False"
	if ok {
		verified = "True"
	}
	fmt.Println(verified)
}
