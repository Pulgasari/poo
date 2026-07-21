# String

A `String` is an immutable or mutable sequence of UTF-8 encoded characters.

```poo
val greeting = "Hello Poo!";
```

---

## Methods

[`bytesize`](#bytesize) ·
[`has`](#has) ·
[`is_empty`](#is_empty) ·
[`loop`](#loop) ·
[`morph`](#morph) ·
[`size`](#size) ·
[`slice`](#slice) ·
[`split`](#split) ·
[`to_lower`](#to_lower) ·
[`to_morph`](#to_morph) ·
[`to_number`](#to_number) ·
[`to_upper`](#to_upper) ·
[`trim`](#trim)

> [!NOTE]
> All methods could be used with both snake-case and pascal-case.

---

## bytesize

Returns the memory size occupied by the string in bytes.

```poo
"Hello".bytesize(); // 5
```

## has

Checks whether a substring exists within the string.

```poo
"Poo Language".has("Poo"); // true
```

## is_empty

Returns `true` if the string contains zero characters.

```poo
"".is_empty(); // true
```

## loop

Iterates through each character in the string executing a callback function.

```poo
"Poo".loop(char => print(char));
```

## morph

Transforms each character in the string in-place using a callback function.

```poo
val text = "abc";
text.morph(c => c.to_upper()); // "ABC"
```

## size

Returns the total count of characters (Unicode code points) in the string.

```poo
"Hello".size(); // 5
```

## slice

Extracts a section of the string between start and end indices.

```poo
"Poo Language".slice(0, 3); // "Poo"
```

## split

Splits the string into an array/list of substrings using a delimiter.

```poo
"a,b,c".split(","); // ["a", "b", "c"]
```

## to_lower

Converts all characters in the string to lowercase in-place or returns a copy.

```poo
val s = "POO";
val lower = s.to_lower(); // "poo"
```

## to_morph

Returns a new string with transformed characters (pure/copy).

```poo
val text = "abc";
val upper = text.to_morph(c => c.to_upper()); // "ABC"
```

## to_number

Parses the string into a `Number` type. Returns `nil` if parsing fails.

```poo
"42.5".to_number(); // 42.5
```

## to_upper

Converts all characters in the string to uppercase.

```poo
"poo".to_upper(); // "POO"
```

## trim

Removes leading and trailing whitespace characters in-place.

```poo
val raw = "  hello  ";
raw.trim(); // "hello"
```
