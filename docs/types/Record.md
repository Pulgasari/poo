# Record

A `Record` is a strict schema-enforced map. Keys and value types are fixed at instantiation. Keys cannot be added or removed.

```poo
val user = #{ name: "Alice", age: 30 };
```

---

## Methods

[`bytesize`](#bytesize) ·
[`diff`](#diff) ·
[`entries`](#entries) ·
[`filter`](#filter) ·
[`fold`](#fold) ·
[`get`](#get) ·
[`has`](#has) ·
[`is_empty`](#is_empty) ·
[`keys`](#keys) ·
[`loop`](#loop) ·
[`merge`](#merge) ·
[`morph`](#morph) ·
[`patch`](#patch) ·
[`set`](#set) ·
[`size`](#size) ·
[`to_diff`](#to_diff) ·
[`to_filter`](#to_filter) ·
[`to_merge`](#to_merge) ·
[`to_morph`](#to_morph) ·
[`to_patch`](#to_patch) ·
[`values`](#values)

> [!NOTE]
> All methods could be used with both snake-case and pascal-case.

---

## bytesize

Returns memory size occupied by the record in bytes.

```poo
#{ name: "Poo" }.bytesize();
```

## diff

Calculates differences between records in-place.

```poo
val r = #{ a: 1, b: 2 };
r.diff(#{ a: 1, b: 5 });
```

## entries

Returns an array/list of tuples containing key-value pairs.

```poo
#{ name: "Alice" }.entries();
```

## filter

Filters record entries in-place.

```poo
val r = #{ a: 10, b: 20 };
r.filter((val, key) => val > 15);
```

## fold

Aggregates record entries into a single result.

```poo
val sum = #{ a: 10, b: 20 }.fold((acc, val, key) => acc + val, 0);
```

## get

Retrieves value for a given key.

```poo
val r = #{ name: "Alice" };
r.get("name"); // "Alice"
```

## has

Checks whether a key exists in the record schema.

```poo
#{ age: 30 }.has("age"); // true
```

## is_empty

Returns `true` if the record schema has zero fields.

```poo
#{}.is_empty();
```

## keys

Returns array/list of keys in the record.

```poo
#{ a: 1, b: 2 }.keys();
```

## loop

Iterates through fields for side-effects.

```poo
#{ a: 1 }.loop((val, key) => print(key, val));
```

## merge

Merges matching keys in-place if types match schema.

```poo
val user = #{ name: "Alice", age: 30 };
user.merge(#{ age: 31 });
```

## morph

Transforms record values in-place while keeping field schema intact.

```poo
val r = #{ val: 10 };
r.morph((val, key) => val * 2);
```

## patch

Patches empty fields in-place.

```poo
val user = #{ name: "Alice", age: 30 };
user.patch(#{ age: 20 }); // age remains 30
```

## set

Updates an existing key's value in-place. Type must match existing schema.

```poo
val r = #{ age: 20 }
r.set("age", 21);
```

## size

Returns fixed field count of the record.

```poo
#{ a: 1, b: 2 }.size(); 2
```

## to_diff

Returns a new record containing differences (copy).

```poo
val r = #{ a: 1, b: 2 };
val d = r.to_diff(#{ a: 1, b: 5 });
```

## to_filter

Returns a new filtered record (copy).

```poo
val r = #{ a: 10, b: 20 };
val f = r.to_filter((val, key) => val > 15);
```

## to_merge

Returns a new record merged with updated values (copy).

```poo
val user = #{ age: 30 };
val updated = user.to_merge(#{ age: 31 });
```

## to_morph

Returns a new record with transformed values (copy).

```poo
val r = #{ val: 10 };
val transformed = r.to_morph((val, key) => val * 2);
```

## to_patch

Returns a new record patched with fallback values (copy).

```poo
val user = #{ age: 30 };
val patched = user.to_patch(#{ age: 20 });
```

## values

Returns array/list of record values.

```poo
#{ a: 1, b: 2 }.values();
```
