package com.example;

import java.util.HashSet;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.MethodSource;

import java.util.stream.Stream;

import static org.junit.jupiter.api.Assertions.*;
import static org.junit.jupiter.api.Assumptions.assumeTrue;

class PointTest {
	// answer for section c
	@Test
	void equalsButDifferentHashCodes() {
		Point p1 = new Point(0, 0);
		Point p2 = new Point(0, 0);
		HashSet<Point> hs = new HashSet<Point>();
		hs.add(p1);
		assertFalse(hs.contains(p2));
	}

	@Test
	void equalsAndSameHashCodes() {
		ComparablePoint p1 = new ComparablePoint(0, 0);
		ComparablePoint p2 = new ComparablePoint(0, 0);
		HashSet<ComparablePoint> hs = new HashSet<ComparablePoint>();
		hs.add(p1);
		assertTrue(hs.contains(p2));
	}

	@ParameterizedTest
	@MethodSource("createPoints")
	void testEquals(Object p1, Object p2, boolean expectedResult) {
		assumeTrue(p1 != null && p2 != null);
		assertEquals(expectedResult, p1.equals(p2));
		assertEquals(expectedResult, p2.equals(p1)); // symmetry
	}

	@ParameterizedTest
	@MethodSource("createPoints")
	void testHashCode(Object p1, Object p2, boolean expectedResult) {
		assumeTrue(p1 != null && p2 != null);

		if (expectedResult) {
			assertEquals(p1.hashCode(), p2.hashCode());
		} else {
			assertNotEquals(p1.hashCode(), p2.hashCode());
		}
	}

	static Stream<Object[]> createPoints() {
		return Stream.of(
				// Equal points
				new Object[] { new ComparablePoint(1, 2), new ComparablePoint(1, 2), true },
				new Object[] { new ComparablePoint(0, 0), new ComparablePoint(0, 0), true },
				new Object[] { new ComparablePoint(-1, -1), new ComparablePoint(-1, -1), true },

				// Different points
				new Object[] { new ComparablePoint(1, 2), new ComparablePoint(2, 1), false },
				new Object[] { new ComparablePoint(1, 2), new ComparablePoint(1, 3), false },
				new Object[] { new ComparablePoint(1, 2), new ComparablePoint(3, 2), false },

				new Object[] { null, new ComparablePoint(3, 2), false },
				new Object[] { new ComparablePoint(3, 2), null, false }, new Object[] { null, null, false },
				new Object[] { "abc", null, false }, new Object[] { null, "abs", false },
				new Object[] { "abs", "abs", true }, new Object[] { "abs", "absz", false },
				new Object[] { "abs", new ComparablePoint(3, 2), false },
				new Object[] { new ComparablePoint(3, 2), "abs", false });
	}
}
