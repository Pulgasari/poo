
# Operators

This document specifies all built-in operators in Poo, categorized by their execution role.

---

## Overview

### Assignment
[`=`](#--assign-operator) ·
[`#=`](#--seal-operator) ·
[`+=`](#--add-assign-operator) ·
[`-=`](#--subtract-assign-operator) ·
[`*=`](#--multiply-assign-operator) ·
[`/=`](#--divide-assign-operator)

### Calculation / Math
[`+`](#---addition-operator) ·
[`-`](#---subtraction-operator) ·
[`*`](#---multiplication-operator) ·
[`/`](#---division-operator) ·
[`%`](#---modulo-operator)

### Comparison & Logic
[`==`](#--equal-operator) ·
[`===`](#--strict-equal-operator) ·
[`!=`](#--not-equal-operator) ·
[`!==`](#--strict-not-equal-operator) ·
[`<`](#--less-than-operator) ·
[`>`](#--greater-than-operator) ·
[`=<`](#--less-or-equal-operator) ·
[`>=`](#--greater-or-equal-operator) ·
[`<=>`](#--spaceship-operator) ·
[`~=`](#--soft-match-operator) ·
[`~==`](#--deep-match-operator) ·
[`&&`](#--logical-and-operator) ·
[`||`](#--logical-or-operator)

### Collection Pipelines
[`|>`](#--map-operator) ·
[`|?`](#--filter-operator) ·
[`|*`](#--reduce-operator) ·
[`|.`](#--pluck-operator)

### Execution Pipelines
[`>>`](#--forward-pipe-operator) ·
[`>>>`](#--deep-pipe-operator) ·
[`?>>`](#--nullish-safe-pipe-operator) ·
[`!>>`](#--falsy-safe-pipe-operator)

### Miscellaneous
[`>=<`](#--swap-operator) ·
[`..`](#--range--rest-operator)

---

## 1. Assignment Operators

| Operator | Name | Description |
| :--- | :--- | :--- |
| [`=`](#--assign-operator) | Assign | Binds or reassigns a value to an identifier |
| [`#=`](#--seal-operator) | Seal | Deep-freezes a variable or object at runtime |
| [`+=`](#--add-assign-operator) | Add-Assign | Adds or appends right operand to variable |
| [`-=`](#--subtract-assign-operator) | Subtract-Assign | Subtracts or removes right operand from variable |
| [`*=`](#--multiply-assign-operator) | Multiply-Assign | Multiplies variable by right operand |
| [`/=`](#--divide-assign-operator) | Divide-Assign | Divides variable by right operand |

---

### `=` – Assign Operator

Binds a new value or reassigns an existing non-sealed identifier.

```poo
val name = "Alice";
name = "Bob";
```

### `#=` – Seal Operator

Permanently seals (deep-freezes) a variable binding or complex data structure at runtime, rendering it recursively immutable.

```poo
// Seal on declaration
val config #= { "host": "localhost", "port": 8080 };

// Late sealing
val animals = #['bird', 'cat', 'dog'];
animals #= true; // Permanently locked

// Attempting mutation throws a runtime error
// animals += 'hamster'; // Error: Variable is sealed
```

### `+=` – Add-Assign Operator

Appends or adds the right operand to the target variable in-place.

```poo
// Numerical addition
var score = 100;
score += 50; // 150

// Collection appending
val animals = #['bird', 'cat', 'dog'];
animals += 'hamster'; // #['bird', 'cat', 'dog', 'hamster']

// String concatenation
val msg = "Hello";
msg += " World!"; // "Hello World!"
```

### `-=` – Subtract-Assign Operator

Subtracts the right operand or removes matching elements from a collection.

```poo
// Numerical subtraction
var hp = 100;
hp -= 20; // 80

// Item removal from collection
val pets = #['bird', 'cat', 'dog'];
pets -= 'cat'; // #['bird', 'dog']
```

### `*=` – Multiply-Assign Operator

Multiplies the variable by the right operand.

```poo
var factor = 5;
factor *= 3; // 15
```

### `/=` – Divide-Assign Operator

Divides the variable by the right operand.

```poo
var balance = 100;
balance /= 4; // 25
```

---

## 2. Calculation / Math Operators

| Operator | Name | Description |
| :--- | :--- | :--- |
| [`+`](#---addition-operator) | Addition | Calculates the sum of two numbers |
| [`-`](#---subtraction-operator) | Subtraction | Calculates difference or negates a value |
| [`*`](#---multiplication-operator) | Multiplication | Multiplies two numerical expressions |
| [`/`](#---division-operator) | Division | Divides left operand by right operand |
| [`%`](#---modulo-operator) | Modulo | Returns remainder of integer division |

---

### `+` – Addition Operator

Calculates the arithmetic sum of two numbers.

```poo
val sum = 10 + 20; // 30
val total = 1.5 + 2.25; // 3.75
```

### `-` – Subtraction Operator

Calculates the difference between two numbers or negates a value.

```poo
val diff = 100 - 45; // 55
val inverted = -10;
```

### `*` – Multiplication Operator

Multiplies two numerical expressions.

```poo
val area = 10 * 5; // 50
```

### `/` – Division Operator

Divides the dividend by the divisor.

```poo
val ratio = 10 / 4; // 2.5
```

### `%` – Modulo Operator

Returns the remainder of integer division.

```poo
val remainder = 10 % 3; // 1
val is_even = (num % 2) == 0;
```

---

## 3. Comparison & Logic Operators

| Operator | Name | Description |
| :--- | :--- | :--- |
| [`==`](#--equal-operator) | Equal | Evaluates structural or value equality |
| [`===`](#--strict-equal-operator) | Strict Equal | Evaluates exact reference and type identity |
| [`!=`](#--not-equal-operator) | Not Equal | Evaluates value inequality |
| [`!==`](#--strict-not-equal-operator) | Strict Not Equal | Evaluates strict reference or type inequality |
| [`<`](#--less-than-operator) | Less Than | True if left operand is smaller than right |
| [`>`](#--greater-than-operator) | Greater Than | True if left operand is larger than right |
| [`=<`](#--less-or-equal-operator) | Less or Equal | True if left operand is smaller or equal to right |
| [`>=`](#--greater-or-equal-operator) | Greater or Equal | True if left operand is larger or equal to right |
| [`<=>`](#--spaceship-operator) | Spaceship | Returns -1 (smaller), 0 (equal), or 1 (larger) |
| [`~=`](#--soft-match-operator) | Soft Match | Soft or structural pattern match |
| [`~==`](#--deep-match-operator) | Deep Match | Strict or deep structural pattern match |
| [`&&`](#--logical-and-operator) | Logical AND | True if both boolean operands are true |
| [`\|\|`](#--logical-or-operator) | Logical OR | True if at least one boolean operand is true |

---

### `==` – Equal Operator

Evaluates structural or value equality.

```poo
10 == 10; // true
"abc" == "abc"; // true
[1, 2] == [1, 2]; // true (Structural equality)
```

### `===` – Strict Equal Operator

Evaluates strict reference identity and exact type match.

```poo
val a = [1, 2];
val b = [1, 2];

a ==  b;  // true  (Same values)
a === b; // false (Different object references in memory)
```

### `!=` – Not Equal Operator

Evaluates value inequality.

```poo
10 != 20; // true
```

### `!==` – Strict Not Equal Operator

Evaluates strict reference or type inequality.

```poo
val a = [1, 2];
val b = [1, 2];

a !== b; // true (Different references)
```

### `<` – Less Than Operator

Returns `true` if the left operand is strictly smaller than the right operand.

```poo
5 < 10; // true
```

### `>` – Greater Than Operator

Returns `true` if the left operand is strictly larger than the right operand.

```poo
10 > 5; // true
```

### `=<` – Less or Equal Operator

Returns `true` if the left operand is smaller than or equal to the right operand.

```poo
5 =< 5; // true
3 =< 5; // true
```

### `>=` – Greater or Equal Operator

Returns `true` if the left operand is larger than or equal to the right operand.

```poo
5  >= 5; // true
10 >= 5; // true
```

### `<=>` – Spaceship Operator

Comparison operator. Returns `-1` if left is smaller, `0` if equal, and `1` if left is larger.

```poo
 5 <=> 10; // -1
 5 <=>  5; //  0
10 <=>  5; //  1

// Custom sorting comparator
items.sort( (a,b) => a.score <=> b.score );
```

### `~=` – Soft Match Operator

Soft / Structural Pattern Match operator. Tests if a value conforms to a type, pattern, regex, or partial structure.

```poo
"user_123" ~= #/user_\d+/; // true (RegExp match)
42 ~= Int;                 // true (Type match)

val response = #{ status: 200, payload: "ok", latency: 12 };
response ~= #{ status: 200 }; // true (Partial structure match)
```

### `~==` – Deep Match Operator

Deep / Strict Pattern Match operator. Requires exact structural match, including element count and type signatures.

```poo
val list = [1, 2, 3];

list ~=  [1, 2]; // true  (Soft match)
list ~== [1, 2]; // false (Deep match: length mismatch)
```

### `&&` – Logical AND Operator

Evaluates logical AND between boolean expressions.

```poo
val valid = (age >= 18) && has_ticket;
```

### `||` – Logical OR Operator

Evaluates logical OR between boolean expressions.

```poo
val access = is_admin || is_owner;
```

---

## 4. Collection Pipelines

| Operator | Name | Description |
| :--- | :--- | :--- |
| [`\|>`](#--map-operator) | Map | Maps every element through a callback function |
| [`\|?`](#--filter-operator) | Filter | Filters elements matching a predicate condition |
| [`\|*`](#--reduce-operator) | Reduce | Reduces collection to an aggregated single value |
| [`\|.`](#--pluck-operator) | Pluck | Extracts a specific property key from all items |

---

### `|>` – Map Operator

Maps every element in a collection through a transformation callback.

```poo
val nums    = [1, 2, 3];
val doubled = nums |> (x => x * 2); // [2, 4, 6]

// Chaining method references
val tags = #['bird', 'cat'] |> toUpperCase; // #['BIRD', 'CAT']
```

### `|?` – Filter Operator

Filters elements in a collection based on a predicate condition.

```poo
val nums  = [1, 2, 3, 4, 5, 6];
val evens = nums |? (x => x % 2 == 0); // [2, 4, 6]
```

### `|*` – Reduce Operator

Reduces / folds a collection into a single aggregated value.

```poo
val nums = [1, 2, 3, 4];
val sum  = nums |* ((acc, x) => acc + x); // 10
```

### `|.` – Pluck Operator

Plucks a specific key or property from all items in a structured collection.

```poo
val users = [
  #{ id: 1, name: "Alice" },
  #{ id: 2, name: "Bob" }
];

val names = users |. "name"; // ["Alice", "Bob"]
```

---

## 5. Execution Pipelines

| Operator | Name | Description |
| :--- | :--- | :--- |
| [`>>`](#--forward-pipe-operator) | Forward Pipe | Passes left result as input to right function |
| [`>>>`](#--deep-pipe-operator) | Deep Pipe | Unwraps/resolves async values before passing |
| [`?>>`](#--nullish-safe-pipe-operator) | Nullish-Safe Pipe | Short-circuits and returns `nil` if value is `nil` |
| [`!>>`](#--falsy-safe-pipe-operator) | Falsy-Safe Pipe | Short-circuits if value evaluates to falsy |

---

### `>>` – Forward Pipe Operator

Forwards the left-hand expression result as the input argument to the right-hand function call.

```poo
fn double = x => x * 2;
fn addTen = x => x + 10;

val result = 5 >> double >> addTen; // 20

// Explicit placement via '@' placeholder
val formatted = "hello" >> string.prefix(@, ">>> "); // ">>> hello"
```

### `>>>` – Deep Pipe Operator

Deep/Async pipe that unwraps or resolves pending asynchronous values before passing them to the next stage.

```poo
val result = fetch_user_async(id) >>> parse_json >>> save_db;
```

### `?>>` – Nullish-Safe Pipe Operator

Nullish-safe pipeline operator. Short-circuits the pipeline and returns `nil` if the left-hand evaluation yields `nil`.

```poo
val user_city = fetch_user(id) ?>> get_address ?>> get_city;
```

### `!>>` – Falsy-Safe Pipe Operator

Falsy-safe pipeline operator. Short-circuits the pipeline if the left-hand evaluation yields a falsy value (`false`, `nil`, `0`, `""`).

```poo
val contacts = load_profile() !>> validate_active !>> fetch_contacts;
```

---

## 6. Miscellaneous Operators

| Operator | Name | Description |
| :--- | :--- | :--- |
| [`>=<`](#--swap-operator) | Swap | Swaps values bound to two variables in-place |
| [`..`](#--range--rest-operator) | Range / Rest | Constructs a range sequence or ignores rest in destructuring |

---

### `>=<` – Swap Operator

Swaps the values bound to two variables in-place.

```poo
val a = "first";
val b = "second";

a >=< b;

print(a); // "second"
print(b); // "first"
```

### `..` – Range / Rest Operator

Constructs a range sequence or represents ignored rest parameters in destructuring.

```poo
// Range generation
val numbers = 1..5; // Range [1, 2, 3, 4, 5]

// Destructuring ignore rest
val #(head, ..) = #(10, 20, 30, 40); // head = 10
```

