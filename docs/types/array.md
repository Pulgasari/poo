# Array

An `Array` is a heterogeneous, dynamically-sized, and mutable ordered collection of elements.

```poo
val items = [1, "hello", true]
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

Appends a new element to the end of the array in-place.

```poo
val list = [1, 2]
list.add(3) # [1, 2, 3]
```

## bytesize

Returns the total memory size occupied by the array in bytes.

```poo
[1, 2, 3].bytesize()
```

## clear

Removes all elements from the array in-place.

```poo
val list = [1, 2, 3]
list.clear() # []
```

## filter

Filters the array in-place, keeping only elements that satisfy the predicate function.

```poo
val numbers = [1, 2, 3, 4]
numbers.filter(x => x % 2 == 0) # [2, 4]
```

## fold

Combines/aggregates all elements into a single result starting with an initial accumulator value.

```poo
val sum = [1, 2, 3].fold((acc, x) => acc + x, 0) # 6
```

## has

Checks whether a given value exists in the array.

```poo
[1, "test"].has("test") # true
```

## is_empty

Returns `true` if the array contains no elements (`size == 0`).

```poo
[].is_empty() # true
```

## loop

Iterates over each element executing the callback for side-effects.

```poo
[1, 2, 3].loop(x => print(x))
```

## morph

Transforms every element in-place using the transformation function.

```poo
val numbers = [1, 2, 3]
numbers.morph(x => x * 2) # [2, 4, 6]
```

## remove

Removes the first occurrence of the specified value in-place *(Tentative)*.

```poo
val items = ["a", "b", "c"]
items.remove("b") # ["a", "c"]
```

## size

Returns the number of elements contained in the array.

```poo
[10, 20, 30].size() # 3
```

## to_filter

Returns a new array containing only elements that satisfy the predicate function (pure/copy).

```poo
val numbers = [1, 2, 3, 4]
val evens = numbers.to_filter(x => x % 2 == 0) # [2, 4]
```

## to_morph

Returns a new array with all elements transformed by the callback function (pure/copy).

```poo
val numbers = [1, 2, 3]
val doubled = numbers.to_morph(x => x * 2) # [2, 4, 6]
```
