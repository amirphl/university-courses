package main

import (
	"fmt"
	"math/big"
)

func OnCurve(p, a, b, x, y *big.Int) bool {
	two := big.NewInt(2)
	three := big.NewInt(3)
	x3 := big.NewInt(0).Exp(x, three, p)
	ax := big.NewInt(0).Mul(x, a)
	ax = ax.Mod(ax, p)
	sum := big.NewInt(0).Add(x3, ax)
	sum = sum.Mod(sum, p)
	sum = sum.Add(sum, b)
	sum = sum.Mod(sum, p)
	y2 := big.NewInt(0).Exp(y, two, p)
	return sum.Cmp(y2) == 0
}

func addPoints(p, a, b, xp, yp, xq, yq *big.Int) {
	if !p.ProbablyPrime(20) {
		fmt.Println("p is not prime")
		return
	}

	if !OnCurve(p, a, b, xp, yp) {
		fmt.Println("P is not on the curve")
		return
	}

	if !OnCurve(p, a, b, xq, yq) {
		fmt.Println("Q is not on the curve")
		return
	}

	zero := big.NewInt(0)
	two := big.NewInt(2)
	three := big.NewInt(3)
	u := big.NewInt(0).Sub(xq, xp)
	v := big.NewInt(0).Sub(yq, yp)

	if u.Cmp(zero) == 0 {
		if v.Cmp(zero) == 0 {
			if yp.Cmp(zero) == 0 {
				fmt.Printf("(%v, %v)\n", 0, 0)
				return
			}
			u = u.Mul(yp, two)
			u = u.ModInverse(u, p)
			v = v.Exp(xp, two, p)
			v = v.Mul(v, three)
			v = v.Mod(v, p)
			v = v.Add(v, a)
			v = v.Mod(v, p)
			v = v.Mul(v, u)
			v = v.Mod(v, p) // delta
		} else {
			fmt.Printf("(%v, %v)\n", 0, 0)
			return
		}
	} else {
		w := big.NewInt(0).ModInverse(u, p)
		v = v.Mul(v, w)
		v = v.Mod(v, p) // delta
	}

	xr := big.NewInt(0).Exp(v, two, p)
	xr = xr.Sub(xr, xp)
	xr = xr.Mod(xr, p)
	xr = xr.Sub(xr, xq)
	xr = xr.Mod(xr, p)
	yr := big.NewInt(0).Sub(xp, xr)
	yr = yr.Mod(yr, p)
	yr = yr.Mul(yr, v)
	yr = yr.Mod(yr, p)
	yr = yr.Sub(yr, yp)
	yr = yr.Mod(yr, p)

	fmt.Printf("(%v, %v)\n", xr.Int64(), yr.Int64())
}

func main() {
	p := new(big.Int)
	a := new(big.Int)
	b := new(big.Int)
	xp := new(big.Int)
	yp := new(big.Int)
	xq := new(big.Int)
	yq := new(big.Int)
	fmt.Scan(p)
	fmt.Scan(a)
	fmt.Scan(b)
	fmt.Scan(xp)
	fmt.Scan(yp)
	fmt.Scan(xq)
	fmt.Scan(yq)
	addPoints(p, a, b, xp, yp, xq, yq)
}
