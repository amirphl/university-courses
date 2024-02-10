package com.example;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class BoundedQueueTest {

	@Test
	void testConstructorWithNegativeCapacity() {
		assertThrows(IllegalArgumentException.class, () -> new BoundedQueue(-1));
	}

	@Test
	void testConstructorWithZeroCapacity() {
		BoundedQueue queue = new BoundedQueue(0);
		assertTrue(queue.isEmpty());
		assertTrue(queue.isFull());
	}

	@Test
	void testConstructorWithPositiveCapacity() {
		BoundedQueue queue = new BoundedQueue(10);
		assertTrue(queue.isEmpty());
		assertFalse(queue.isFull());
	}

	@Test
	void testEnqueueWithNullObject() {
		BoundedQueue queue = new BoundedQueue(10);
		assertThrows(NullPointerException.class, () -> queue.enQueue(null));
	}

	@Test
	void testEnqueueWithFullQueue() {
		BoundedQueue queue = new BoundedQueue(1);
		queue.enQueue(1);
		assertThrows(IllegalStateException.class, () -> queue.enQueue(2));
	}

	@Test
	void testEnqueueWithEmptyQueue() {
		BoundedQueue queue = new BoundedQueue(10);
		queue.enQueue(1);
		assertFalse(queue.isEmpty());
		assertEquals(1, queue.size());
	}

	@Test
	void testDequeueWithEmptyQueue() {
		BoundedQueue queue = new BoundedQueue(10);
		assertThrows(IllegalStateException.class, queue::deQueue);
	}

	@Test
	void testDequeueWithNonEmptyQueue() {
		BoundedQueue queue = new BoundedQueue(10);
		queue.enQueue(1);
		assertEquals(1, queue.deQueue());
		assertTrue(queue.isEmpty());
	}

	@Test
	void testToStringWithEmptyQueue() {
		BoundedQueue queue = new BoundedQueue(10);
		assertEquals("[]", queue.toString());
	}

	@Test
	void testToStringWithNonEmptyQueue() {
		BoundedQueue queue = new BoundedQueue(10);
		queue.enQueue(1);
		queue.enQueue(2);
		assertEquals("[1, 2]", queue.toString());
	}
}
