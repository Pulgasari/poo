# Pool

A `Pool` is an unordered collection of unique elements. Duplicate values are automatically deduplicated upon insertion.

```poo
val tags = Pool("poo", "lang", "poo"); // Results in Pool("poo", "lang")
```

---

## Methods

[`add`](#add) ·
[`bytesize`](#bytesize) ·
[`clear`](#clear) ·
[`filter`](#filter) ·
[`fold`](#fold) ·
[`has`](#has) ·
[`is_empty`](#is_empty) ·
[`loop`](#loop) ·
[`morph`](#morph) ·
[`remove`](#remove) ·
[`size`](#size) ·
[`to_filter`](#to_filter) ·
[`to_morph`](#to_morph)

> [!NOTE]
> All methods could be used with both snake-case and pascal-case.

---

## add

Adds a unique value to the pool in-place. If the value already exists, the operation is ignored.

```poo
val p = Pool(1, 2);
p.add(3); // Pool(1, 2, 3)
p.add(2); // Pool(1, 2, 3)
```

## bytesize

Returns the total memory size occupied by the pool in bytes.

```poo
val p = Pool("a", "b");
p.bytesize();
```

## clear

Removes all elements from the pool in-place.

```poo
val p = Pool(1, 2, 3);
p.clear(); // Pool()
```

## filter

Filters the pool elements in-place based on a predicate function.

```poo
val numbers = Pool(1, 2, 3, 4);
numbers.filter(x => x % 2 == 0); // Pool(2, 4)
```

## fold

Aggregates all elements in the pool into a single value starting with an initial accumulator value.

```poo
val total = Pool(10, 20, 30).fold((acc, x) => acc + x, 0); // 60
```

## has

Checks whether a specific value exists in the pool.

```poo
val p = Pool("apple", "banana");
p.has("apple"); // true
```

## is_empty

Returns `true` if the pool contains no elements (`size == 0`).

```poo
Pool().is_empty(); // true
```

## loop

Iterates through all elements in the pool executing a callback function.

```poo
val p = Pool(1, 2, 3);
p.loop(item => print(item));
```

## morph

Transforms elements in-place using a callback function. Resulting duplicate values are automatically unified.

```poo
val p = Pool(1, 2, 3);
p.morph(x => x * 0); // Pool(0)
```

## remove

Removes a specific value from the pool in-place *(Tentative)*.

```poo
val p = Pool("a", "b", "c");
p.remove("b"); // Pool("a", "c")
```

## size

Returns the total count of unique items contained in the pool.

```poo
val p = Pool(10, 20, 30);
p.size(); // 3
```

## to_filter

Returns a new filtered pool leaving the original pool unmodified (pure/copy).

```poo
val numbers = Pool(1, 2, 3, 4);
val evens = numbers.to_filter(x => x % 2 == 0);
```

## to_morph

Returns a new transformed pool leaving the original pool unmodified (pure/copy).

```poo
val numbers = Pool(1, 2, 3);
val doubled = numbers.to_morph(x => x * 2);
```
