## Chat System Using ECDH (Elliptic-curve Diffie–Hellman) and AES (Advanced Encryption Standard)
This is a chat system that uses ECDH and AES for encryption. You can watch intro.mkv to see how it works.
To receive a message from a contact, you must send a public key request (contact's public key) to the server. If the contact has previously sent their public key, the server will respond. Otherwise, if you receive a message from that contact, you won't be able to decrypt it because decryption requires a symmetric key that is formed by both communication sides' public key. Public keys are sent without encryption. There is no CA.

## Scenario
To run the server, execute:
```
go run main.go server
```
The server will listen on port `9000`. Make sure it's free before running the command.
To run `client 1`:
```
go run main.go client client_1.txt
```
To see the messages send to `client_1`:
```
tail -f client_1.txt
```
To run `client 2`:
```
go run main.go client client_2.txt
```
To see the messages send to `client_2`:
```
tail -f client_2.txt
```
You can run more clients like the above.


## Public Key Exchange
- If the client needs someone's public key, they can simply send an `async` request to the server. The server will respond later only if the target user has already registered the public key.
- If the client wants to publish their public key, they can simply send an `async` request to the server.


## Building Symmetric Secret Key from One Side's Public Key and the Other Side's Private Key
```
    var (
    	x *big.Int = new(big.Int)
    	y *big.Int = new(big.Int)

    x.SetBytes(rev.Pubkey.X)
    y.SetBytes(rev.Pubkey.Y)
    a, _ := elliptic.P256().ScalarMult(x, y, myPrivkey.D.Bytes())
    symmetricKeys[rev.UserID] = sha256.Sum256(a.Bytes())
```

## AES Encryption
```
func PKCS5Padding(cipherText []byte, blockSize int, after int) []byte {
	padding := (blockSize - len(cipherText)%blockSize)
	padtext := bytes.Repeat([]byte{byte(padding)}, padding)

	return append(cipherText, padtext...)
}

func encrypt(plainText []byte, symmetricKey [32]byte) []byte {
	padded := PKCS5Padding(plainText, aes.BlockSize, len(plainText))
	block, _ := aes.NewCipher(symmetricKey[:])
	cipherText := make([]byte, len(padded))
	mode := cipher.NewCBCEncrypter(block, _iv)
	mode.CryptBlocks(cipherText, padded)

	return cipherText
}
```

## AES Decryption
```
func PKCS5UnPadding(src []byte) []byte {
	length := len(src)
	unpadding := int(src[length-1])

	return src[:(length - unpadding)]
}

func decrypt(cipherText []byte, symmetricKey [32]byte) []byte {
	block, _ := aes.NewCipher(symmetricKey[:])
	plainText := make([]byte, len(cipherText))
	mode := cipher.NewCBCDecrypter(block, _iv)
	mode.CryptBlocks(plainText, cipherText)
	padded := PKCS5UnPadding(plainText)

	return padded
}
```

## References
- https://asecuritysite.com/encryption/goecdh
