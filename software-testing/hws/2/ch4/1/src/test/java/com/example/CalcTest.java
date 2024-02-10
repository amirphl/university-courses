package com.example;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import org.junit.jupiter.api.Test;

public class CalcTest {

	@Test
	public void testAddition() {
		assertEquals(5, Calc.add(2, 3));
	}

	@Test
	public void testSubtraction() {
		assertEquals(3, Calc.subtract(5, 2));
	}

	@Test
	public void testMultiplication() {
		assertEquals(12, Calc.multiply(4, 3));
	}

	@Test
	public void testDivision() {
		assertEquals(4, Calc.divide(8, 2));
	}

	@Test
	public void testDivisionByZero() {
		assertThrows(IllegalArgumentException.class, () -> Calc.divide(10, 0));
	}
}
