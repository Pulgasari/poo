# Bool

A `Bool` represents a logical boolean value: `true` or `false`.

```poo
val karl_marx   = true;
val moonlanding = false;
```

---

## Methods

[`bytesize`](#bytesize) ·
[`not`](#not) ·
[`to_string`](#to_string) ·
[`toggle`](#toggle)

> [!NOTE]
> All methods could be used with both snake-case and pascal-case.

---

## bytesize

Returns the memory size occupied by the boolean in bytes.

```poo
true.bytesize(); // 1
```

## not

Returns the inverted logical boolean value (pure/copy).

```poo
val active   = true;
val inactive = active.not(); // false
```

## to_string

Converts the boolean value into its string representation (`"true"` or `"false"`).

```poo
true.to_string(); // "true"
```

## toggle

Inverts the boolean value in-place.

```poo
val flag = true;
flag.toggle(); // flag is now false
```
