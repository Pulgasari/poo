# List

A `List` is a homogeneous, typed, dynamically-sized, and mutable collection. All elements must share the exact same type.

```poo
val numbers = #[1, 2, 3];
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

Appends a new element in-place. Throws a type error if the element's type does not match the list schema.

```poo
val list = #[1, 2];

list.add(3);
list += 3;
```

## bytesize

Returns the contiguous memory size of the list in bytes.

```poo
#[1, 2, 3].bytesize();
```

## clear

Removes all items from the list in-place.

```poo
val list = #[1, 2, 3];
list.clear();
```

## filter

Filters elements in-place based on a predicate function.

```poo
val list = #[10, 15, 20];
list.filter(x => x > 12); // #[15, 20]
```

## fold

Combines elements into a single value starting with an initial accumulator value.

```poo
val total = #[10, 20, 30].fold((acc, x) => acc + x, 0); // 60
```

## has

Checks whether the value exists in the list.

```poo
#[1, 2, 3].has(2); // true
```

## is_empty

Returns `true` if the list has zero elements.

```poo
#[].is_empty(); true
```

## loop

Iterates through elements for side-effects.

```poo
#[1, 2, 3].loop(x => print(x)):
```

## morph

Transforms elements in-place using the transformation callback.

```poo
val list = #[1, 2, 3]|
list.morph(x => x * 10); #[10, 20, 30]
```

## remove

Removes the specified value from the list in-place *(Tentative)*.

```poo
val list = #[10, 20, 30];
list.remove(20);
```

## size

Returns the element count of the list.

```poo
#[1, 2, 3].size(); // 3
```

## to_filter

Returns a new filtered list leaving the original unmodified.

```poo
val list = #[10, 15, 20];
val big = list.to_filter(x => x > 12);
```

## to_morph

Returns a new transformed list leaving the original unmodified.

```poo
val list = #[1, 2, 3];
val scaled = list.to_morph(x => x * 10);
```
