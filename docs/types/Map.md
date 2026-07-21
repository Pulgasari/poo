# Map

A `Map` is a dynamic dictionary holding key-value pairs. Keys can be of any data type.

```poo
val config = { "host": "localhost", port: 8080 };
```

---

## Methods

[`add`](#add) ·
[`bytesize`](#bytesize) ·
[`clear`](#clear) ·
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
[`remove`](#remove) ·
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

## add

Adds or updates a key-value pair in-place.

```poo
val map = { "a": 1 };
map.add("b", 2);
```

## bytesize

Returns the memory size of the map in bytes.

```poo
{ "a": 1 }.bytesize();
```

## clear

Removes all entries from the map in-place.

```poo
val map = { "a": 1 };
map.clear();
```

## diff

Modifies the map in-place to contain only the key-value differences found in another map.

```poo
val a = { "x": 1, "y": 2 };
a.diff({ "x": 1, "y": 99 }); { "y": 99 }
```

## entries

Returns a list/array of tuples representing `#(key, value)` pairs.

```poo
{ "a": 1 }.entries(); [ #("a", 1) ]
```

## filter

Filters map entries in-place.

```poo
val scores = { "alice": 80, "bob": 40 };
scores.filter((val, key) => val >= 50);
```

## fold

Aggregates entries into a single target value.

```poo
val total = { "a": 10, "b": 20 }.fold((acc, val, key) => acc + val, 0);
```

## get

Retrieves a value associated with the given key. Returns `nil` if missing.

```poo
val map = { "host": "localhost" }
map.get("host"); "localhost"
```

## has

Checks whether a key exists in the map.

```poo
{ "a": 1 }.has("a"); // true
```

## is_empty

Returns `true` if the map contains no entries.

```poo
{}.is_empty(); // true
```

## keys

Returns a list/array containing all keys.

```poo
{ "a": 1, "b": 2 }.keys(); ["a", "b"]
```

## loop

Iterates through all entries executing a callback.

```poo
{ "a": 1 }.loop((val, key) => print(key, val));
```

## merge

Merges another map into the current map in-place, **overwriting** existing keys.

```poo
val cfg = { "theme": "dark", "volume": 50 };
cfg.merge({ "theme": "light" }) # { "theme": "light", "volume": 50 };
```

## morph

Transforms map values in-place.

```poo
val map = { "a": 1, "b": 2 };
map.morph((val, key) => val * 10);
```

## patch

Merges another map into the current map in-place, **filling only missing keys** without overwriting existing ones.

```poo
val user = { "theme": "light" };
user.patch({ "theme": "dark", "volume": 80 }) # { "theme": "light", "volume": 80 };
```

## remove

Removes an entry by key in-place.

```poo
val map = { "a": 1, "b": 2 };
map.remove("a");
```

## set

Sets a value for a key in-place.

```poo
val map = {};
map.set("key", "value");
```

## size

Returns the number of entries in the map.

```poo
{ "a": 1, "b": 2 }.size(); // 2
```

## to_diff

Returns a new map containing only the differences between two maps (copy).

```poo
val a = { "x": 1, "y": 2 };
val changes = a.to_diff({ "x": 1, "y": 99 });
```

## to_filter

Returns a new filtered map (copy).

```poo
val scores = { "alice": 80, "bob": 40 };
val passed = scores.to_filter((val, key) => val >= 50);
```

## to_merge

Returns a new map merged with another, overwriting matching keys (copy).

```poo
val cfg = { "theme": "dark" };
val updated = cfg.to_merge({ "theme": "light" });
```

## to_morph

Returns a new map with transformed values (copy).

```poo
val map = { "a": 1 };
val new_map = map.to_morph((val, key) => val * 10);
```

## to_patch

Returns a new map patched with default/fallback entries (copy).

```poo
val user = { "theme": "light" }:
val final_cfg = user.to_patch({ "theme": "dark", "volume": 80 });
```

## values

Returns a list/array containing all values.

```poo
{ "a": 1, "b": 2 }.values(); [1, 2]
```
