# Fingerprint

A `Fingerprint` represents an immutable, fixed-size structural identity or state checksum computed from any data value or object.

```poo
val fp1 = Fingerprint(user_data);
val fp2 = user_data.fingerprint();
```

---

## Methods

[`bytesize`](#bytesize) ·
[`is_match`](#is_match) ·
[`to_hex`](#to_hex) ·
[`to_string`](#to_string)

> [!NOTE]
> All methods could be used with both snake-case and pascal-case.

---

## bytesize

Returns the fixed memory size of the fingerprint in bytes (e.g., 8 bytes for 64-bit or 16 bytes for 128-bit).

```poo
val fp = Fingerprint("test");
fp.bytesize(); // 8
```

## is_match

Checks whether two fingerprints are identical in value.

```poo
val fp1 = Fingerprint([1, 2, 3]);
val fp2 = Fingerprint([1, 2, 3]);
fp1.is_match(fp2); // true
```

## to_hex

Returns the hexadecimal string representation of the fingerprint.

```poo
val fp = Fingerprint("hello");
fp.to_hex(); // "a3f890bc12"
```

## to_string

Returns the standard string representation of the fingerprint.

```poo
val fp = Fingerprint("data");
fp.to_string(); // "Fingerprint(a3f890bc12)"
```
