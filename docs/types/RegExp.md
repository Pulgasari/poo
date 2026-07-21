# RegExp

A `RegExp` (or `Pattern`) represents a compiled regular expression used for text matching, extraction, and pattern replacement.

```poo
val pattern = RegExp("^[a-z]+$", "i");
```

---

## Methods

[`bytesize`](#bytesize) ·
[`has`](#has) ·
[`match`](#match) ·
[`match_all`](#match_all) ·
[`replace`](#replace) ·
[`split`](#split) ·
[`to_string`](#to_string)

> [!NOTE]
> All methods could be used with both snake-case and pascal-case.

---

## bytesize

Returns the total memory size occupied by the compiled regex pattern in bytes.

```poo
RegExp("[0-9]+").bytesize();
```

## has

Checks whether a given string satisfies or contains a match for the regex pattern.

```poo
val digits = RegExp("[0-9]+");
digits.has("User 42"); // true
```

## match

Searches a target string and returns the first match details (including captures and match indices) or `nil` if no match is found.

```poo
val email_pattern = RegExp("([a-z]+)@([a-z]+)");
val result = email_pattern.match("contact: user@example.com");
// Returns tuple/record with full match and capture groups
```

## match_all

Searches a target string and returns an array/list of all match occurrences found.

```poo
val pattern = RegExp("[0-9]+");
pattern.match_all("a 10 b 20 c 30"); // ["10", "20", "30"]
```

## replace

Replaces matches of the regex pattern within a target string using a replacement string or a transformer callback.

```poo
val pattern = RegExp("[0-9]+");
pattern.replace("item 123", "XXX"); // "item XXX"
```

## split

Splits a target string into an array/list of substrings using the regex pattern as a delimiter.

```poo
val pattern = RegExp("\\s*,\\s*");
pattern.split("apple , banana,cherry"); // ["apple", "banana", "cherry"]
```

## to_string

Returns the original regular expression source string pattern.

```poo
RegExp("^[a-z]+$", "i").to_string(); // "^[a-z]+$"
```
