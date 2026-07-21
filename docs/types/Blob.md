# Blob

A `Blob` represents raw binary data or a contiguous byte buffer.

```poo
val data = Blob([0x48, 0x65, 0x6c, 0x6c, 0x6f]);
```

---

## Methods

[`bytesize`](#bytesize) ·
[`clear`](#clear) ·
[`has`](#has) ·
[`is_empty`](#is_empty) ·
[`loop`](#loop) ·
[`morph`](#morph) ·
[`slice`](#slice) ·
[`to_base64`](#to_base64) ·
[`to_hex`](#to_hex) ·
[`to_morph`](#to_morph) ·
[`to_string`](#to_string)

> [!NOTE]
> All methods could be used with both snake-case and pascal-case.

---

## bytesize

Returns the total size of the byte buffer in bytes.

```poo
val b = Blob([0x01, 0x02, 0x03]);
b.bytesize(); // 3
```

## clear

Clears the binary buffer in-place, reducing its size to 0.

```poo
val b = Blob([0xff, 0x00]);
b.clear(); // Empty Blob
```

## has

Checks whether a specific byte value or sequence exists within the binary buffer.

```poo
val b = Blob([0x01, 0x02, 0x03]);
b.has(0x02); // true
```

## is_empty

Returns `true` if the binary buffer contains zero bytes.

```poo
Blob([]).is_empty(); // true
```

## loop

Iterates through raw byte values in the buffer executing a callback function.

```poo
val b = Blob([0x41, 0x42]);
b.loop(byte => print(byte));
```

## morph

Transforms each byte value in the buffer in-place using a callback function.

```poo
val b = Blob([0x01, 0x02]);
b.morph(byte => byte * 2);
```

## slice

Extracts a section of the binary buffer between start and end byte offset indices.

```poo
val b = Blob([0x00, 0x11, 0x22, 0x33]);
val sub = b.slice(1, 3); // Blob([0x11, 0x22])
```

## to_base64

Encodes the binary data into a Base64 string representation.

```poo
val b = Blob([0x48, 0x65, 0x6c, 0x6c, 0x6f]);
b.to_base64(); // "SGVsbG8="
```

## to_hex

Encodes the binary data into a hexadecimal string representation.

```poo
val b = Blob([0xff, 0x00]);
b.to_hex(); // "ff00"
```

## to_morph

Returns a new binary buffer with transformed bytes leaving the original unmodified (pure/copy).

```poo
val b = Blob([0x01, 0x02]);
val doubled = b.to_morph(byte => byte * 2);
```

## to_string

Decodes the binary data into a UTF-8 string (or using a specified character encoding).

```poo
val b = Blob([0x50, 0x6f, 0x6f]);
b.to_string(); // "Poo"
```
