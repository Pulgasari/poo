# Int

An `Int` represents an explicit fixed-width or standard integer number value. 

Width variants include `Int8`, `Int16`, `Int32`, `Int64`, `Uint8`, `Uint16`, `Uint32`, and `Uint64`.

```poo
val count = Int(42);
val age = Int32(25);
```

---

## Methods

[`abs`](#abs) ·
[`bytesize`](#bytesize) ·
[`is_even`](#is_even) ·
[`is_odd`](#is_odd) ·
[`to_float`](#to_float) ·
[`to_number`](#to_number) ·
[`to_string`](#to_string)

> [!NOTE]
> All methods could be used with both snake-case and pascal-case.

---

## abs

Returns the absolute value of the integer in-place or as copy.

```poo
Int(-10).abs(); // 10
```

## bytesize

Returns the memory size allocated for the integer in bytes (e.g., 4 bytes for `Int32`).

```poo
Int32(100).bytesize(); // 4
```

## is_even

Returns `true` if the integer is divisible by 2.

```poo
Int(4).is_even(); // true
```

## is_odd

Returns `true` if the integer is not divisible by 2.

```poo
Int(3).is_odd(); // true
```

## to_float

Explicitly converts integer to a floating point number.

```poo
Int(42).to_float(); // 42.0
```

## to_number

Promotes explicit integer to a generic flexible `Number`.

```poo
Int32(10).to_number();
```

## to_string

Converts integer to string representation.

```poo
Int(100).to_string(); // "100"
```
