// Introduction to Software Testing
// Authors: Paul Ammann & Jeff Offutt
// Chapter 1; page ??
// See PointTest.java for JUnit tests
// See also ColorPoint.java
package com.example;

public class ComparablePoint {
	private int x;
	private int y;

	public ComparablePoint(int x, int y) {
		this.x = x;
		this.y = y;
	}

	@Override
	public boolean equals(Object o) {
		// Location A
		if (!(o instanceof ComparablePoint))
			return false;
		ComparablePoint p = (ComparablePoint) o;
		return (p.x == this.x) && (p.y == this.y);
	}

	// Found the solution on the web.
	@Override
	public int hashCode() {
		int result = 17;

		result = 31 * result + x;
		result = 31 * result + y;

		return result;
	}
}
