# RegExp

A `RegExp` represents a compiled regular expression used for pattern matching, text extraction, search indexing, and replacements.

```poo
// Literal Syntax
val pattern = #/[a-z]+/i;

// Constructor Syntax
val dynamic_pattern = RegExp("^[0-9]+$", "g");
```

---

## Methods

[`bytesize`](#bytesize) ·
[`escape`](#escape) ·
[`has`](#has) ·
[`loop`](#loop) ·
[`match`](#match) ·
[`match_all`](#match_all) ·
[`replace`](#replace) ·
[`search`](#search) ·
[`split`](#split) ·
[`to_string`](#to_string)

> [!NOTE]
> All methods could be used with both snake-case and pascal-case.

---

## bytesize

Returns the total memory size occupied by the compiled regex pattern in bytes.

```poo
#/[0-9]+/.bytesize();
```

## escape

Static helper that escapes special regex characters in a raw string to make it safe for dynamic pattern creation.

```poo
val safe_text = RegExp.escape("user.name?"); // "user\.name\?"
val pattern = RegExp(safe_text);
```

## has

Checks whether a target string satisfies or contains a match for the regex pattern (returns `Bool`).

```poo
val digits = #/[0-9]+/;
digits.has("User 42"); // true
```

## loop

Iterates through all match occurrences within a target string executing a callback for each match.

```poo
val digits = #/[0-9]+/;
digits.loop("item 10, item 20", match => print(match.value()));
```

## match

Searches a target string and returns match details (full match string, capture index, and named groups as a Record) or `nil` if no match is found.

```poo
val pattern = #/(?<word>[a-z]+)@(?<domain>[a-z]+)/;
val result = pattern.match("user@poo");
print(result.groups.domain); // "poo"
```

## match_all

Searches a target string and returns an array/list of all match occurrences or capture results.

```poo
val pattern = #/[0-9]+/;
pattern.match_all("a 10 b 20 c 30"); // ["10", "20", "30"]
```

## replace

Replaces matches of the regex pattern within a target string using a replacement string or a transformer callback.

```poo
val pattern = #/[0-9]+/;
pattern.replace("item 123", "XXX"); // "item XXX"
```

## search

Searches a target string and returns the starting character index of the first match (returns `Int`), or `nil` if not found.

```poo
val pattern = #/world/i;
pattern.search("Hello World!"); // 6
```

## split

Splits a target string into an array/list of substrings using the regex pattern as a delimiter.

```poo
val pattern = #/\s*,\s*/;
pattern.split("apple , banana,cherry"); // ["apple", "banana", "cherry"]
```

## to_string

Returns the original regular expression source pattern as a string.

```poo
#/[a-z]+/i.to_string(); // "[a-z]+"
```
