package com.example;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class PrimeNumbersTest {
	@Test
	void doesntReachTheFault() {
		PrimeNumbers pn = new PrimeNumbers();
		pn.computePrimes(0);
		assertSame("[]", pn.toString());
	}

	@Test
	void doesntInfect() {
		PrimeNumbers pn = new PrimeNumbers();
		pn.computePrimes(1);
		assertEquals("[2]", pn.toString());
	}

	// Consider program counter (PC), so there is an infection here but no failure.
	@Test
	void doesntPropagate() {
		PrimeNumbers pn = new PrimeNumbers();
		pn.computePrimes(1);
		assertEquals("[2]", pn.toString());
	}

	// Reveals the fault.
	@Test
	void noPrimeNumbersShouldBeMissed() {
		PrimeNumbers pn = new PrimeNumbers();
		pn.computePrimes(10);
		assertEquals("[2, 3, 5, 7, 11, 13, 17, 19, 23, 29]", pn.toString());
	}
}
