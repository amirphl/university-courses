package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	var p, g, a, b int64
	fmt.Scan(&p, &g, &a, &b)
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Scan()
	m := scanner.Text()
	pubA := mul(g, a, p)
	pubB := mul(g, b, p)
	fmt.Println(pubA)
	fmt.Println(pubB)
	key := mul(pubA, b, p)
	cipherText := encryptMessage(key, m)
	fmt.Println(cipherText)
	fmt.Println(m)
}

func encryptMessage(key int64, message string) string {
	cipherText := make([]rune, 0)
	for _, c := range message {
		cipherText = append(cipherText, rune(int64(c)+key))
	}

	return string(cipherText)
}

func mul(g, a, p int64) int64 {
	if a <= 0 {
		return 1
	}
	i := int64(1)
	res := g
	for ; i*i < a; i *= 2 {
		res = (res * res) % p
	}
	return (res * mul(g, a-i, p)) % p
}
