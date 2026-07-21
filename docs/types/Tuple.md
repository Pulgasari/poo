# Tuple

A `Tuple` is a heterogeneous, fixed-length, and index-type-invariant sequence. Structural modifications (adding or removing items) are disabled.

```poo
val point = #(10, 20, "label");
```

---

## Methods

[`bytesize`](#bytesize) ·
[`filter`](#filter) ·
[`fold`](#fold) ·
[`has`](#has) ·
[`is_empty`](#is_empty) ·
[`loop`](#loop) ·
[`morph`](#morph) ·
[`size`](#size) ·
[`to_filter`](#to_filter) ·
[`to_morph`](#to_morph)

> [!NOTE]
> All methods could be used with both snake-case and pascal-case.

---

## bytesize

Returns the memory size occupied by the tuple in bytes.

```poo
#(10, "test").bytesize();
```

## filter

Filters elements in-place resulting in a updated tuple structure.

```poo
val t = #(1, 2, 3);
t.filter(x => x > 1);
```

## fold

Aggregates tuple elements into a single value.

```poo
val result = #(10, 20, 30).fold((acc, x) => acc + x, 0);
```

## has

Checks whether a value is present in the tuple.

```poo
#(10, "a").has("a"); true
```

## is_empty

Returns `true` if the tuple contains no items.

```poo
#().is_empty(); true
```

## loop

Iterates over each tuple element.

```poo
#(1, "ok", true).loop(item => print(item));
```

## morph

Transforms elements in-place.

```poo
val t = #(1, 2, 3);
t.morph(x => x * 2);
```

## size

Returns the number of elements in the tuple.

```poo
#(1, 2, 3).size(); // 3
```

## to_filter

Returns a new tuple filtered by predicate.

```poo
val t = #(1, 2, 3);
val filtered = t.to_filter(x => x > 1);
```

## to_morph

Returns a new transformed tuple.

```poo
val t = #(1, 2, 3);
val morphed = t.to_morph(x => x * 2);
```
