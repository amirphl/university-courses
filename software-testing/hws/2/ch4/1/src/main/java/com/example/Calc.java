package com.example;

public class Calc {
	static public int add(int a, int b) {
		return a + b;
	}

	static public int subtract(int a, int b) {
		return a - b;
	}

	static public int multiply(int a, int b) {
		return a * b;
	}

	static public int divide(int a, int b) {
		if (b == 0) {
			throw new IllegalArgumentException("Cannot divide by zero");
		}
		return a / b;
	}
}
