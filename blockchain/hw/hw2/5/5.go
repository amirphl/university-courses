package main

import "fmt"

const MAX = 1000000007

func hash(file string) uint64 {
	sum := uint64(1)
	for _, c := range file {
		sum = sum * uint64(c) % MAX
	}
	return sum
}

func main() {
	var h uint64
	var b, r string
	fmt.Scan(&h)
	fmt.Scan(&b)
	fmt.Scan(&r)

	if len(r) < 8 {
		fmt.Println(b)
		fmt.Println("The random string's length is too short Abbas!")
		return
	}

	var c string
	if b == "H" {
		c = "T"
	} else {
		c = "H"
	}

	if hash(b+r) == h {
		fmt.Println(c)
		fmt.Println("I won Abbas! You ain't get the 100$.")
		return
	}

	if hash(c+r) == h {
		fmt.Println(b)
		fmt.Println("You won Abbas! 100$ is yours")
		return
	}

	fmt.Println(c)
	fmt.Println("Don't cheat Abbas, that's not good!")
}
