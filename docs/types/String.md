# String

A `String` is a sequence of UTF-8 encoded characters.

```poo
val greeting = "Hello Poo!";
```

---

## Methods

[`append`](#append) ·
[`bytesize`](#bytesize) ·
[`has`](#has) ·
[`invert_case`](#invert_case) ·
[`is_case`](#is_case) ·
[`is_empty`](#is_empty) ·
[`join`](#join) ·
[`loop`](#loop) ·
[`morph`](#morph) ·
[`prefix`](#prefix) ·
[`prepend`](#prepend) ·
[`replace`](#replace) ·
[`size`](#size) ·
[`slice`](#slice) ·
[`slugify`](#slugify) ·
[`split`](#split) ·
[`suffix`](#suffix) ·
[`switch_case`](#switch_case) ·
[`to_camel_case`](#to_camel_case) ·
[`to_case`](#to_case) ·
[`to_constant_case`](#to_constant_case) ·
[`to_flat_case`](#to_flat_case) ·
[`to_kebab_case`](#to_kebab_case) ·
[`to_lower_case`](#to_lower_case) ·
[`to_mocking_case`](#to_mocking_case) ·
[`to_morph`](#to_morph) ·
[`to_number`](#to_number) ·
[`to_pascal_case`](#to_pascal_case) ·
[`to_slug_case`](#to_slug_case) ·
[`to_snake_case`](#to_snake_case) ·
[`to_title_case`](#to_title_case) ·
[`to_upper_case`](#to_upper_case) ·
[`to_upper_kebab_case`](#to_upper_kebab_case) ·
[`to_words`](#to_words) ·
[`trim`](#trim) ·
[`unprefix`](#unprefix) ·
[`unsuffix`](#unsuffix)

> [!NOTE]
> All methods could be used with both snake-case and pascal-case.

---

## append

Appends a substring to the end of the current string in-place.

```poo
val text = "Hello";
text.append(" World"); // "Hello World"
```

## bytesize

Returns the total memory size occupied by the string in bytes.

```poo
"Hello".bytesize(); // 5
```

## has

Checks whether a substring exists within the string.

```poo
"Poo Language".has("Poo"); // true
```

## invert_case

Inverts the case of every letter in the string (lowercase becomes uppercase, uppercase becomes lowercase).

```poo
"Hello World".invert_case(); // "hELLO wORLD"
```

## is_case

Checks whether the string matches a specific casing style (e.g. `:camel`, `:pascal`, `:snake`, `:kebab`, `:upper`, `:lower`).

```poo
"helloWorld".is_case(:camel); // true
"hello_world".is_case(:pascal); // false
```

## is_empty

Returns `true` if the string contains zero characters.

```poo
"".is_empty(); // true
```

## join

Concatenates elements of a collection into a single string using the current string as a delimiter.

```poo
", ".join(["apple", "banana", "cherry"]); // "apple, banana, cherry"
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
text.morph(c => c.to_upper_case()); // "ABC"
```

## prefix

Ensures the string starts with the given prefix. Adds the prefix (with an optional separator) only if it is not already present.

```poo
"user".prefix("api", "/");     // "api/user"
"api/user".prefix("api", "/"); // "api/user"
"file".prefix("lib");          // "libfile"
```

## prepend

Prepends a substring to the beginning of the current string in-place.

```poo
val text = "World";
text.prepend("Hello "); // "Hello World"
```

## replace

Replaces occurrences of a target substring with a new replacement string.

```poo
val text = "Hello World";
text.replace("World", "Poo"); // "Hello Poo"
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

## slugify

Converts the string into a URL-friendly slug with customizable parameters (such as separator, case preservation, or accent stripping options).

Defaults to standard [`to_slug_case`](#to_slug_case) behavior if no options are passed.

```poo
"Hello World!".slugify(); // "hello-world"
"Hello World!".slugify(#{ separator: "_" }); // "hello_world"
```

## split

Splits the string into an array/list of substrings using a specified delimiter.

```poo
"a,b,c".split(","); // ["a", "b", "c"]
```

## suffix

Ensures the string ends with the given suffix. Adds the suffix (with an optional separator) only if it is not already present.

```poo
"document".suffix("pdf", ".");     // "document.pdf"
"document.pdf".suffix("pdf", "."); // "document.pdf"
"index".suffix("html");           // "indexhtml"
```

## switch_case

Cycles the string's casing to the next case variant in a provided sequence of case names/symbols. If the string matches one case in the list, it transforms to the next case in order.

```poo
val text = "hello_world";
text.switch_case(:camel, :pascal, :snake); // Converts to "helloWorld"
text.switch_case(:camel, :pascal, :snake); // Converts to "HelloWorld"
```

## to_camel_case

Converts string to `camelCase`.

```poo
"hello world".to_camel_case(); // "helloWorld"
```

## to_case

Converts string to a target casing style specified dynamically via parameter (e.g. `:lower`, `:upper`, `:pascal`, `:camel`, `:snake`, `:kebab`, `:title`).

```poo
"hello world".to_case(:pascal); // "HelloWorld"
"hello world".to_case(:snake);  // "hello_world"
```

## to_constant_case

Converts string to `CONSTANT_CASE` (screaming snake case).

```poo
"hello world".to_constant_case(); // "HELLO_WORLD"
```

## to_flat_case

Converts string to `flatcase` (all lowercase with all delimiters removed).

```poo
"hello world".to_flat_case(); // "helloworld"
```

## to_kebab_case

Converts string to `kebab-case`.

```poo
"hello world".to_kebab_case(); // "hello-world"
```

## to_lower_case

Converts all characters in the string to lowercase.

```poo
"POO".to_lower_case(); // "poo"
```

## to_mocking_case

Converts string to alternating `mOcKiNgCAsE`.

```poo
"hello world".to_mocking_case(); // "hElLo WoRlD"
```

## to_morph

Returns a new string with transformed characters (pure/copy).

```poo
val text = "abc";
val upper = text.to_morph(c => c.to_upper_case()); // "ABC"
```

## to_number

Parses the string into a `Number` type. Returns `nil` if parsing fails.

```poo
"42.5".to_number(); // 42.5
```

## to_pascal_case

Converts string to `PascalCase`.

```poo
"hello world".to_pascal_case(); // "HelloWorld"
```

## to_slug_case

Converts string into a standard URL-friendly `slug-case` (lowercased, accents normalized, non-alphanumeric characters replaced with hyphens).

If configuration is needed the [`slugify`](#slugify) method could be used.

```poo
"Hello World & Poo!".to_slug_case(); // "hello-world-and-poo"
```

## to_snake_case

Converts string to `snake_case`.

```poo
"hello world".to_snake_case(); // "hello_world"
```

## to_title_case

Converts string to `Title Case`.

```poo
"hello world".to_title_case(); // "Hello World"
```

## to_upper_case

Converts all characters in the string to uppercase.

```poo
"poo".to_upper_case(); // "POO"
```

## to_upper_kebab_case

Converts string to `UPPER-KEBAB-CASE` (COBOL-CASE).

```poo
"hello world".to_upper_kebab_case(); // "HELLO-WORLD"
```

## to_words

Splits the string into an array/list of words based on spaces, punctuation, or case transitions.

```poo
"helloWorld_test".to_words(); // ["hello", "World", "test"]
```

## trim

Removes leading and trailing whitespace characters in-place.

```poo
val raw = "  hello  ";
raw.trim(); // "hello"
```

## unprefix

Removes a specified prefix from the beginning of the string if it is present.

```poo
"api/user".unprefix("api/"); // "user"
"user".unprefix("api/");     // "user"
```

## unsuffix

Removes a specified suffix from the end of the string if it is present.

```poo
"file.txt".unsuffix(".txt"); // "file"
"file".unsuffix(".txt");     // "file"
```
