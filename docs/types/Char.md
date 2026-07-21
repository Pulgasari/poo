# Char

A `Char` represents a single UTF-8 encoded character value.

```poo
val letter = 'A';
```

---

## Methods

[`bytesize`](#bytesize) ·
[`code`](#code) ·
[`is_digit`](#is_digit) ·
[`is_letter`](#is_letter) ·
[`is_whitespace`](#is_whitespace) ·
[`to_lower`](#to_lower) ·
[`to_string`](#to_string) ·
[`to_upper`](#to_upper)

> [!NOTE]
> All methods could be used with both snake-case and pascal-case.

---

## bytesize

Returns the memory size of the character in bytes.

```poo
'A'.bytesize(); // 1
```

## code

Returns the Unicode code point / ASCII integer value of the character.

```poo
'A'.code(); // 65
```

## is_digit

Returns `true` if the character is a numeric digit ('0'-'9').

```poo
'5'.is_digit(); // true
```

## is_letter

Returns `true` if the character is an alphabetic character.

```poo
'a'.is_letter(); // true
```

## is_whitespace

Returns `true` if the character is a space, tab, or newline.

```poo
' '.is_whitespace(); // true
```

## to_lower

Converts character to lowercase.

```poo
'A'.to_lower(); // 'a'
```

## to_string

Converts character to a string of length 1.

```poo
'A'.to_string(); // "A"
```

## to_upper

Converts character to uppercase.

```poo
'a'.to_upper(); // 'A'
```
