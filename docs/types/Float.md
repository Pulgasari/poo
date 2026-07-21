# Float

A `Float` represents an explicit floating point number. Variants include `Float32` and `Float64`.

```poo
val price = Float(19.99);
val precise = Float64(3.1415926535);
```

---

## Methods

[`abs`](#abs) ·
[`bytesize`](#bytesize) ·
[`ceil`](#ceil) ·
[`floor`](#floor) ·
[`round`](#round) ·
[`to_int`](#to_int) ·
[`to_number`](#to_number) ·
[`to_string`](#to_string)

> [!NOTE]
> All methods could be used with both snake-case and pascal-case.

---

## abs

Returns the absolute value of the floating point number.

```poo
Float(-5.5).abs(); // 5.5
```

## bytesize

Returns the memory size allocated for the float in bytes (e.g., 8 bytes for `Float64`).

```poo
Float64(3.14).bytesize(); // 8
```

## ceil

Rounds the number upwards to the nearest integer.

```poo
Float(3.2).ceil(); // 4.0
```

## floor

Rounds the number downwards to the nearest integer.

```poo
Float(3.8).floor(); // 3.0
```

## round

Rounds the number to the nearest integer or specified decimal precision.

```poo
Float(3.5).round(); // 4.0
```

## to_int

Casts float value to integer (truncating decimals).

```poo
Float(9.99).to_int(); // 9
```

## to_number

Promotes explicit float to a generic flexible `Number`.

```poo
Float32(1.5).to_number();
```

## to_string

Converts float value to string.

```poo
Float(3.14).to_string(); // "3.14"
```
