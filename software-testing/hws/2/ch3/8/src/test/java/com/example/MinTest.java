package com.example;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.Arrays;
import java.util.Collection;
import java.util.List;

import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.MethodSource;

public class MinTest {

	static Collection<Object[]> data() {
		return Arrays.asList(new Object[][] {
				// Test cases with Integer values
				{ Arrays.asList(3, 1, 4, 1, 5, 9, 2, 6, 5, 3), 1 }, { Arrays.asList(5, 2, 8, 1, 7), 1 },
				{ Arrays.asList(10, 20, 30, 40, 50), 10 },

				// Test cases with String values
				{ Arrays.asList("apple", "banana", "orange", "grape", "kiwi"), "apple" },
				{ Arrays.asList("dog", "cat", "elephant", "lion"), "cat" },
				{ Arrays.asList("java", "python", "ruby", "javascript"), "java" } });
	}

	@ParameterizedTest
	@MethodSource("data")
	public void testMin(List<? extends Comparable<?>> inputList, Comparable<?> expectedResult) {
		Comparable<?> result = Min.min(inputList);
		assertEquals(expectedResult, result);
	}
}
