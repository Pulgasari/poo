# Number

A `Number` is the high-level, flexible numeric type that automatically manages integers and floating point values seamlessly under the hood.

```poo
val x = 42;    // Managed as integer internally
val y = 3.14;  // Managed as float internally
```

---

## Methods

[`abs`](#abs) ·
[`bytesize`](#bytesize) ·
[`ceil`](#ceil) ·
[`floor`](#floor) ·
[`is_even`](#is_even) ·
[`is_float`](#is_float) ·
[`is_int`](#is_int) ·
[`is_odd`](#is_odd) ·
[`round`](#round) ·
[`to_float`](#to_float) ·
[`to_int`](#to_int) ·
[`to_string`](#to_string)

> [!NOTE]
> All methods could be used with both snake-case and pascal-case.

---

## abs

Returns absolute numeric value.

```poo
(-42).abs(); // 42
```

## bytesize

Returns memory size allocated for the numeric representation.

```poo
42.bytesize();
```

## ceil

Rounds float representation upwards to nearest integer value.

```poo
3.14.ceil(); // 4
```

## floor

Rounds float representation downwards to nearest integer value.

```poo
3.99.floor(); // 3
```

## is_even

Returns `true` if current number is an integer and divisible by 2.

```poo
10.is_even(); // true
```

## is_float

Returns `true` if current number is stored as floating point value.

```poo
3.14.is_float(); // true
```

## is_int

Returns `true` if current number is stored as an integer value.

```poo
42.is_int(); // true
```

## is_odd

Returns `true` if current number is an integer and not divisible by 2.

```poo
7.is_odd(); // true
```

## round

Rounds number to nearest integer or specified decimal places.

```poo
2.718.round(); // 3
```

## to_float

Explicitly converts number to an explicit `Float` type.

```poo
42.to_float(); // Float(42.0)
```

## to_int

Explicitly converts number to an explicit `Int` type.

```poo
3.14.to_int(); // Int(3)
```

## to_string

Converts numeric value to string representation.

```poo
42.to_string(); // "42"
```
