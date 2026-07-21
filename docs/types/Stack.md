# Stack

A `Stack` is a Last-In-First-Out (LIFO) collection where elements are added and removed from the top.

```poo
val s = Stack();
s.add("first");
s.add("second");
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

Pushes a new item onto the top of the stack in-place.

```poo
val s = Stack();
s.add(100);
```

## bytesize

Returns memory size allocated for the stack in bytes.

```poo
val s = Stack();
s.bytesize();
```

## clear

Empties the stack in-place.

```poo
val s = Stack();
s.clear();
```

## has

Checks whether a value exists anywhere in the stack.

```poo
val s = Stack();
s.add("item");
s.has("item"); // true
```

## is_empty

Returns `true` if the stack contains no elements.

```poo
val s = Stack();
s.is_empty(); // true
```

## loop

Iterates over stack items starting from the top down to the bottom.

```poo
val s = Stack();
s.loop(item => print(item));
```

## peek

Returns the top element of the stack without removing it. Returns `nil` if empty.

```poo
val s = Stack();
s.add(5);
val top = s.peek(); // 5
```

## pop

Pops and returns the top element from the stack in-place. Returns `nil` if empty.

```poo
val s = Stack();
s.add(1);
s.add(2);
val top = s.pop(); // 2
```

## size

Returns the total count of items on the stack.

```poo
val s = Stack();
s.size();
```
