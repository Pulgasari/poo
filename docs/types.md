# Data-Types

This document provides an overview about all built-in datatypes.

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
[`Record`](#record)
[`RegExp`](#regexp)
[`Set`](#set)
[`Stack`](#stack)
[`String`](#string)
[`Store`](#store)
[`Symbol`](#symbol)
[`Tree`](#tree) 
[`Tuple`](#tuple) 
[`Union`](#union)

> [!IMPORTANT]
> For extended infos about each datatype, its methods etc. move to [/types](/docs/types) directory.

---

## Array

<details>
<summary><b>Example Code</b></summary>

```js
val pets = new Array;
val pets = ['bird', 'cat', 'dog', 'fish'];
val nums = [1, 2, 3];
```
</details>

<details>
<summary><b>Methods</b></summary>

  <details>
  <summary><b>checks</b></summary>
    
    ...
  </details>
  <details>
  <summary><b>mutating</b></summary>

    ...
  </details>
  <details>
  <summary><b>die andern</b></summary>

    ...
  </details>
  <details>
  <summary><b>static</b></summary>

    ...
  </details>

</details>


## Blob

Manages raw binary chunks, bytearrays, and data stream payloads.

<details>
<summary><b>Example Code</b></summary>

```js

```
</details>

## Bool

A logical boolean value that can only inhabit one of two states: `true` or `false`.

<details>
<summary><b>Example Code</b></summary>

```js
val maybe = true;
val never = false;
```
</details>

## Char

Represents a single, isolated textual character token.

<details>
<summary><b>Example Code</b></summary>

```js scala
val letter = 'c';
```
</details>

## Color

Standardized type to represent system colors, HEX formats, or alpha color values natively.

<details>
<summary><b>Example Code</b></summary>
  
```js

```
</details>

## Date

Manages time-series data, high-resolution calendars, and system timestamps.

<details>
<summary><b>Example Code</b></summary>
  
```js

```
</details>

## Enum

Used to define closed collections of named, immutable state constants.

<details>
<summary><b>Example Code</b></summary>

```js

```
</details>

## Generator

Stateful, lazy-evaluated iterable streams created using the generator syntax identifier `fn*`.

<details>
<summary><b>Example Code</b></summary>

```js
fn*
```
</details>

## List

A **List** is a special form of an [Array](#array) with:
- identical typed values

```c
val pets = new List;
val pets = #['bird', 'cat', 'dog', 'fish'];
val nums = #[1, 2, 3];
```

A **List** has all the builtin methods of **Array** *(outer type)* and depending on the type of it's values *(inner type)* one could use all those methods in combination.

<details>
<summary><b>Example Code</b></summary>

```c
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
</details>

## Map

<details>
<summary><b>Example Code</b></summary>

```js

```
</details>

## Number

Represents all numerical data, including both integers ([`Int`](#int)) and floating-point decimals ([`Float`](#float)). 

To improve readability when working with massive numbers, digit separating underscores (`_`) can be placed freely within the literal representation.

<details>
<summary><b>Example Code</b></summary>

```scala
val num = 60;
val dec = 10.5;
val big = 10_000_000; // 10000000
```
</details>

## Pattern

Formal structural layouts utilized directly during conditional type assertions and robust pattern matching rules (`~=`).

<details>
<summary><b>Example Code</b></summary>

```js

```
</details>

## Queue

High-performance, built-in structural options providing out-of-the-box FIFO and LIFO mechanics.

<details>
<summary><b>Example Code</b></summary>

```js

```
</details>

## Record

A structurally rigid set of key-value assignments (`key: value`), initialized by utilizing the object rigidity descriptor `#{...}`. It provides optimized compile-time static maps.

<details>
<summary><b>Example Code</b></summary>

```js
val userRecord = #{name: "Udo", age: 60};
```
</details>

## RegExp

Pattern sequences built for fast text extraction and character matching evaluations.

<details>
<summary><b>Example Code</b></summary>

```js

```
</details>

## Set

Highly performant collections storing entirely unique values, safely ignoring duplication events.

<details>
<summary><b>Example Code</b></summary>

```js

```
</details>

## Stack

High-performance, built-in structural options providing out-of-the-box FIFO and LIFO mechanics.

<details>
<summary><b>Example Code</b></summary>

```js

```
</details>

## Store

Containers built for handling observable, reactive global state changes or event listeners seamlessly.

<details>
<summary><b>Example Code</b></summary>

```js

```
</details>

## String

A sequential array of text characters. Poo natively supports single quotes (`'...'`), double quotes (`"..."`) featuring runtime variable expansion via the `$` token, and backticks (`` `...` ``) for complex template string injection using `${expression}` syntax.

<details>
<summary><b>Example Code</b></summary>

```scala
val name = "Udo";
val text = "Coding sucks.";
val greeting = `Hello ${name}!`;
```
</details>

## Symbol

Fully unique and completely unalterable internal tokens, ideal for isolating internal object metadata keys.

<details>
<summary><b>Example Code</b></summary>

```js

```
</details>

## Tree

Native branch layouts built to construct and maneuver hierarchical nested branch data models.

<details>
<summary><b>Example Code</b></summary>

```js

```
</details>

## Tuple

A fixed-size, heterogeneous collection containing predefined value sequences wrapped inside `#(...)`. Each index is rigidly locked to a specific type footprint upon declaration. Index elements can be updated, but only if the incoming modification strictly conforms to the expected type signature of that slot.

<details>
<summary><b>Example Code</b></summary>

```js
val userTuple = #("Udo", 60, true); // Strict schema slot layout: (String, Number, Bool)
```
</details>

## Union

Multi-faceted type definitions that allow a variable footprint to seamlessly accept values matching multiple distinct structural footprints.

<details>
<summary><b>Example Code</b></summary>

```js

```
</details>




