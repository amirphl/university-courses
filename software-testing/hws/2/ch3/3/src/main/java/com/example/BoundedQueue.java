// Introduction to Software Testing
// Authors: Paul Ammann & Jeff Offutt
// Chapter 3, page ??
// See BoundedQueueTest.java for JUnit tests. (Instructor only)
package com.example;

public class BoundedQueue {
	// Overview: a BoundedQueue is a mutable, bounded FIFO data structure
	// of fixed size , with size being set in the constructor
	// A typical Queue is [], [o1], or [o1, o2], where neither o1 nor o2
	// are ever null. Older elements are listed before newer ones.

	private final Object[] elements;
	private int size, front, back;
	private final int capacity;

	public BoundedQueue(int capacity) {
		if (capacity < 0)
			throw new IllegalArgumentException("BoundedQueue.constructor");
		this.capacity = capacity;
		elements = new Object[capacity];
		size = 0;
		front = 0;
		back = 0;
	}

	// Modifies: this
	// Effects: If argument is null
	// throw NullPointerException
	// else if this is full, throw
	// IllegalStateException,
	// else make o the newest
	// element of this
	public void enQueue(Object o) throws NullPointerException, IllegalStateException {
		if (o == null)
			throw new NullPointerException("BoundedQueue.enQueue");
		else if (size == capacity)
			throw new IllegalStateException("BoundedQueue.enQueue");
		else {
			size++;
			elements[back] = o;
			back = (back + 1) % capacity;
		}
	}

	// Modifies: this
	// Effects: If queue is empty, throw IllegalStateException,
	// else remove and return oldest element of this
	public Object deQueue() throws IllegalStateException {

		if (size == 0)
			throw new IllegalStateException("BoundedQueue.deQueue");
		else {
			size--;
			Object o = elements[(front % capacity)];
			elements[front] = null;
			front = (front + 1) % capacity;
			return o;
		}
	}

	public boolean isEmpty() {
		return (size == 0);
	}

	public boolean isFull() {
		return (size == capacity);
	}

	public int size() {
		return size;
	}

	public String toString() {
		String result = "[";
		for (int i = 0; i < size; i++) {
			result += elements[(front + i) % capacity].toString();
			if (i < size - 1) {
				result += ", ";
			}
		}
		result += "]";
		return result;
	}

}
