# Data-Types

This document provides an overview about all built-in datatypes.

> [!IMPORTANT]
> For extended infos about each datatype, its methods etc. move to [/types](/docs/types) directory.

---

[`Array`](#array) 
[`Blob`](#blob) 
[`Bool`](#bool)
[`Char`](#char)
[`Color`](#color)
[`Date`](#date)
[`Enum`](#enum)
[`Generator`](#generator)
[`List`](#list)
[`Map`](#map)
[`Number`](#number)
[`Queue`](#queue) 
[`Pattern`](#pattern)
[`Pool`](#pool)
[`Record`](#record)
[`RegExp`](#regexp)
[`Stack`](#stack)
[`String`](#string)
[`Store`](#store)
[`Symbol`](#symbol)
[`Tree`](#tree) 
[`Tuple`](#tuple) 
[`Union`](#union)

---

## Array

```poo
val pets = new Array;
val pets = ['bird', 'cat', 'dog', 'fish'];
val nums = [1, 2, 3];
```

Read more: [`Array`](types/Array.md)

## Blob

Manages raw binary chunks, bytearrays, and data stream payloads.

```poo
val data = Blob([0x48, 0x65, 0x6c, 0x6c, 0x6f]);
```

Read more: [`Blob`](types/Blob.md)

## Bool

A logical boolean value that can only inhabit one of two states: `true` or `false`.

```poo
val karl_marx   = true;
val moonlanding = false;
```

Read more: [`Bool`](types/Bool.md)

## Char

Represents a single, isolated textual character token.

```poo
val letter = 'c';
```

Read more: [`Char`](types/Char.md)

## Color

Standardized type to represent system colors, HEX formats, or alpha color values natively.
  
```poo
val red = Color("#ff0000");
```

Read more: [`Color`](types/Color.md)

## Date

Manages time-series data, high-resolution calendars, and system timestamps.

```poo
val today = 1917-10-25;
val today = new Date('1917-10-25');
val today = new Date '1917-10-25';
```

Read more: [`Date`](types/Date.md)

## Enum

Used to define closed collections of named, immutable state constants.

```poo
enum Status { Active, Inactive, Pending };
val current = Status.Active;
```

Read more: [`Enum`](types/Enum.md)

## Generator

Stateful, lazy-evaluated iterable streams created using the generator syntax identifier `fn*`.

```poo
fn* count_up = limit => {
  loop (limit > 0 as i) yield i++;
};

val gen = count_up(3);
gen.next(); // 0
```

Read more: [`Generator`](types/Generator.md)

## List

A **List** is a special form of an [Array](#array) with identical typed values and a flat structure.

```poo
val pets = new List;
val pets = #['bird', 'cat', 'dog', 'fish'];
val nums = #[1, 2, 3];
```

A **List** has all the builtin methods of **Array** *(outer type)* and depending on the type of it's values *(inner type)* one could use all those methods in combination.

```poo
val pets = #['bird', 'cat', 'dog', 'fish'];

// #['BIRD', 'CAT', 'DOG', 'FISH']
pets.map (toUpperCase);

// #['DRIB', 'TAC', 'DOG', 'GOD', 'HSIF']
pets.map (toUpperCase, reverse);

// #[HSIF, 'GOD', 'TAC', 'DRIB']
pets.map (toUpperCase, reverse).reverse();

// note: these syntaxes would also be possible:
pets.map (toUpperCase reverse).reverse();
pets.map (toUpperCase reverse) |> @.reverse();
pets.map >> toUpperCase reverse |> @.reverse();
```

Read more: [`List`](types/List.md)

## Map

An unordered collection of key-value pairs stored dynamically using `{ ... }` syntax.

```poo
val config = { "host": "localhost", port: 8080 };
```

Read more: [`Map`](types/Map.md)

## Number

Represents all numerical data, including both integers ([`Int`](#int)) and floating-point decimals ([`Float`](#float)). 

To improve readability when working with massive numbers, digit separating underscores (`_`) can be placed freely within the literal representation.

```poo
val num = 60;
val dec = 10.5;
val big = 10_000_000; // 10000000
```

Read more: [`Number`](types/Number.md)

## Pattern

Formal structural layouts utilized directly during conditional type assertions and pattern matching rules (`~=`).

```poo
val UserPattern = #{ name: String, age: Number };
val is_user = payload ~= UserPattern;
```

Read more: [`Pattern`](types/Pattern.md)

## Pool

Highly performant collections storing entirely unique values, safely ignoring duplication events.

```poo
val unique_ids = Pool([1, 2, 2, 3]); // Contains: 1, 2, 3
```

Read more: [`Pool`](types/Pool.md)

## Queue

High-performance, built-in structural options providing out-of-the-box FIFO (First-In-First-Out) mechanics.

```poo
val q = new Queue;
q.push("first");
q.pop(); // "first"
```

Read more: [`Queue`](types/Queue.md)

## Record

A structurally rigid set of key-value assignments (`key: value`), initialized by utilizing the object rigidity descriptor `#{...}`. It provides optimized compile-time static maps.

```poo
val userRecord = #{name: "Udo", age: 60};
```

Read more: [`Record`](types/Record.md)

## RegExp

Pattern sequences built for fast text extraction and character matching evaluations.

```poo
val digits = #/[0-9]+/i;
val is_match = digits.has("User 42");
```

Read more: [`RegExp`](types/RegExp.md)

## Stack

High-performance, built-in structural options providing out-of-the-box LIFO (Last-In-First-Out) mechanics.

```poo
val s = new Stack;
s.push("bottom");
s.push("top");
s.pop(); // "top"
```

Read more: [`Stack`](types/Stack.md)

## Store

Containers built for handling observable, reactive global state changes or event listeners seamlessly.

```poo
val appState = Store(#{ count: 0, user: "Alice" });
```

Read more: [`Store`](types/Store.md)

## String

A sequential array of text characters. Poo natively supports single quotes (`'...'`), double quotes (`"..."`) featuring runtime variable expansion via the `$` token, and backticks (`` `...` ``) for complex template string injection using `${expression}` syntax.

```poo
val name = "Udo";
val text = "Coding sucks.";
val greeting = `Hello ${name}!`;
```

Read more: [`String`](types/String.md)

## Symbol

Fully unique and completely unalterable internal tokens, ideal for isolating internal object metadata keys.

```poo
val status = :active;
```

Read more: [`Symbol`](types/Symbol.md)

## Tree

Native branch layouts built to construct and maneuver hierarchical nested branch data models.

```poo
val node = Tree(#{ value: 1, children: [] });
```

Read more: [`Tree`](types/Tree.md)

## Tuple

A fixed-size, heterogeneous collection containing predefined value sequences wrapped inside `#(...)`. Each index is rigidly locked to a specific type footprint upon declaration. Index elements can be updated, but only if the incoming modification strictly conforms to the expected type signature of that slot.

```poo
val userTuple = #("Udo", 60, true); // Strict schema slot layout: (String, Number, Bool)
```

Read more: [`Tuple`](types/Tuple.md)

## Union

Multi-faceted type definitions that allow a variable footprint to seamlessly accept values matching multiple distinct structural footprints.

```poo
val ID = Int | String;
val user_id: ID = "usr_1234";
```

Read more: [`Union`](types/Union.md)

---

> [!IMPORTANT]
> For extended infos about each datatype, its methods etc. move to [/types](/docs/types) directory.




