# Queue

A `Queue` is a First-In-First-Out (FIFO) collection optimized for sequential insertion and removal.

```poo
val q = Queue();
q.add(10);
q.add(20);
```

---

## Methods

[`add`](#add) ·
[`bytesize`](#bytesize) ·
[`clear`](#clear) ·
[`has`](#has) ·
[`is_empty`](#is_empty) ·
[`loop`](#loop) ·
[`peek`](#peek) ·
[`pop`](#pop) ·
[`size`](#size)

> [!NOTE]
> All methods could be used with both snake-case and pascal-case.

---

## add

Enqueues a new item to the back of the queue in-place.

```poo
val q = Queue();
q.add("first");
q.add("second");
```

## bytesize

Returns the total memory size occupied by the queue in bytes.

```poo
val q = Queue();
q.bytesize();
```

## clear

Removes all elements from the queue in-place.

```poo
val q = Queue();
q.clear();
```

## has

Checks whether a value exists within the queue.

```poo
val q = Queue();
q.add(42);
q.has(42); // true
```

## is_empty

Returns `true` if the queue contains no elements.

```poo
val q = Queue();
q.is_empty(); // true
```

## loop

Iterates through elements from head to tail executing a callback function.

```poo
val q = Queue();
q.loop(item => print(item));
```

## peek

Returns the front item of the queue without removing it. Returns `nil` if empty.

```poo
val q = Queue();
q.add("next");
val item = q.peek(); // "next"
```

## pop

Dequeues and returns the front item of the queue in-place. Returns `nil` if empty.

```poo
val q = Queue();
q.add("a");
q.add("b");
val first = q.pop(); // "a"
```

## size

Returns the number of elements in the queue.

```poo
val q = Queue();
q.size(); // 0
```
