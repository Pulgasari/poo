# Symbol

A `Symbol` is an immutable, unique identifier value used for efficient comparison and memory savings.

```poo
val status = :active;
```

---

## Methods

[`bytesize`](#bytesize) ·
[`name`](#name) ·
[`to_string`](#to_string)

> [!NOTE]
> All methods could be used with both snake-case and pascal-case.

---

## bytesize

Returns the memory size occupied by the symbol reference in bytes.

```poo
:active.bytesize();
```

## name

Returns the string identifier name of the symbol.

```poo
:active.name(); // "active"
```

## to_string

Converts symbol into a string representation.

```poo
:active.to_string(); // "active"
```
