package main

import (
	"crypto/rand"
	"crypto/rsa"
	"crypto/sha256"
	"crypto/x509"
	"encoding/base64"
	"encoding/pem"
	"fmt"
	"log"
)

const privatePemString = `-----BEGIN PRIVATE KEY-----
MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC1Z2jVrc/TiJfS
cHnJqGh8mhCOTX2Pu5ChAs4/5bvfA5tnrTS+KsxhDauyCqNegvsX2zXL+sTnq1Ly
B6QjmzqsTqLehtCMCEwdnQzvm7EbP+sh2DBqnjal85n2mqV69xmeyCEvniFPm8vk
ophNkW5VE3AaZj73YUuHlQMdOZ4zi0vjRhnfVvaMWVB4x7j0h7Wc8D7JVR05Lp5+
lmhj/NflDQuAXCXYfIHvQS/5GKQ6PNoEkqYLVfw1UjUWH9ttmpF/kjT9CAwR0XwW
mTorDqvSX6LUiKDy29IcPx6oYfm6mF2agwdRQKcutR1Y26m6cgn/WZvHLPo2Fo3S
X9CfpowPAgMBAAECggEADE0hDqMU6EnSIyWYb08vGAqp278v0rrhPGHrKD8acILs
m2kN82VbQFZD0d98ePDAjpDBbah+3hzqk4S8IeP+ubzdY4yt1gkhVugVqVFGqcvk
VIJgtMzaH4J3lYGi03Cv4+oQrLYi7nnop4OfzgbHfhfC2YTHI/xiOaVRCul41mgw
R82Vi9rglqqQYCxdOR54s84pH2+/8UlSolYC90j7yotjhu0oEbl1v+r8pVwEZx9d
WI0AhQK5mZriRPDbd1cQ9/OFzuIot9GKFABWgGUbdHF3qdqb8vdY/24+AROXimqp
WAOIuszVDODIE1IrmLqEChwv0IORIVz3XSi+xdL7YQKBgQDq5kh1+EK8Ao/a3WJn
0o8LZS0YJDqxQPeDAAuvTH0hBNEiBo34rD6cnL4DTjPsBLCWNjh6gOeZy8I/Jnej
PBVZTlm1JVuuZfWwW+7AT1KmihxhqeQ3kmnTLoUMlI3mP4sLveYYz/S+SCWlWVOw
snjTLsMjkTaDgMzRR4C1xCCl7wKBgQDFsvL7j0RIbYOVdS5g766KFAlpi8FfoXfZ
THJ5ROS3xtlqU5WcJyvFdwdwMopfVoUpiLpTXQGabpqE3Fy5ykiELhTxadM7nomN
rZq2L0g+/RNGMq5yLRgC72wDCzOYZoYeZHfyGvDir8As3hjofsFXprTekgeclihG
YXK/MlOb4QKBgQCp5HR0HmLl6FRzT7tkq/2ZmEvNMibhHMPnk5jf6Mp3nyxDF8qH
GM0QKK2lZmJXSe0ON5kRwTnBGoYbdo8BGOu389seES8GK+hO7a74mGaG3U05tc7C
ArtXakYAm1EmPr8qduZ8+6tgFH5l4P2OxwZsd13b06NB6V453yVQUdHrMQKBgBdR
fhtx0IoCcMzGH4xLePjMWDfcxhgzgWFeBPqMx7VtfONvrGvYqu8FlRkEvRF1sQsv
F1sR00iV1x/opf87/sWoccvvwXx8vJi7a04l0Y2saAOVosHQ08400zagsZs+LH+V
NhiWWOdD95TTNXjmyoM+JINEEiXECEgU4mXu17HBAoGBANIjbcxBOcR32iZwo80R
AxvpbyTwFKao/xZ2N1j6dt2VTbgUD0YcoFLKgIfnY1W/vl941dTiKuEkoDismBcy
bZC6aCbDFdEibJnIDcUkHyd1wy+mnO2qPRPJU8ABOut9oc5U2ybqJriBAff9uR8B
4qtoY+SpIFZF2MUncAD+vwih
-----END PRIVATE KEY-----`

const publicPemString = `-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtWdo1a3P04iX0nB5yaho
fJoQjk19j7uQoQLOP+W73wObZ600virMYQ2rsgqjXoL7F9s1y/rE56tS8gekI5s6
rE6i3obQjAhMHZ0M75uxGz/rIdgwap42pfOZ9pqlevcZnsghL54hT5vL5KKYTZFu
VRNwGmY+92FLh5UDHTmeM4tL40YZ31b2jFlQeMe49Ie1nPA+yVUdOS6efpZoY/zX
5Q0LgFwl2HyB70Ev+RikOjzaBJKmC1X8NVI1Fh/bbZqRf5I0/QgMEdF8Fpk6Kw6r
0l+i1Iig8tvSHD8eqGH5uphdmoMHUUCnLrUdWNupunIJ/1mbxyz6NhaN0l/Qn6aM
DwIDAQAB
-----END PUBLIC KEY-----`

const sampleCipherText = "RsdnPS51icNeUoRT6X4y5ex3uHr4GBl9ynCx2+aTAxRm/0q47HO/+4QXm3AlQqEy8ZWMYvQ+65qzf2TwYLAFN/g+FJPFIByfBtcKLale85uMVJXKn8pRsUrvAFxAUsj8G81gXvKVZDHgy8lU0piec5vH6RXQlEPakXPWyPCft414fUnCzJdhG+S20WwLODBiEz7ov9XsP/BEb7y02VC3CYuMHaPrHiSRKmB8zFM2OigpKXpHauZy/ANq9KPu68pJb+YDfAuExtjmIDrnOl7cTw0itd8HXUYzuKiRClBEJ/jDYRaJRizq5SO4yzkXsPOd/IzHMcAS7/CH/O57lZ56Pw=="

func main() {
	key := LoadKey()
	// base64CipherText := sampleCipherText
	var base64CipherText string
	fmt.Scanln(&base64CipherText)
	cipherText, _ := base64.StdEncoding.DecodeString(base64CipherText)
	plainText := DecryptWithPrivateKey([]byte(cipherText), key)
	fmt.Printf("Decrypted message: %s\n", string(plainText))
}

func LoadKey() *rsa.PrivateKey {
	privPem, _ := pem.Decode([]byte(privatePemString))
	parsedKey, _ := x509.ParsePKCS8PrivateKey(privPem.Bytes)
	privateKey := parsedKey.(*rsa.PrivateKey)
	pubPem, _ := pem.Decode([]byte(publicPemString))
	parsedKey, _ = x509.ParsePKIXPublicKey(pubPem.Bytes)
	pubKey, _ := parsedKey.(*rsa.PublicKey)
	privateKey.PublicKey = *pubKey
	return privateKey
}

func EncryptWithPublicKey(msg []byte, pub *rsa.PublicKey) []byte {
	hash := sha256.New()
	ciphertext, err := rsa.EncryptOAEP(hash, rand.Reader, pub, msg, nil)

	if err != nil {
		log.Println(err)
	}

	return ciphertext
}

func DecryptWithPrivateKey(ciphertext []byte, priv *rsa.PrivateKey) []byte {
	hash := sha256.New()
	plaintext, err := rsa.DecryptOAEP(hash, rand.Reader, priv, ciphertext, nil)
	if err != nil {
		log.Println(err)
	}
	return plaintext
}
