# Operators

## Overview

### Assignment

[`=`](#) [`=#`](#) [`+=`](#) [`-=`](#) [`*=`](#)

### Calculation

[`+`](#) [`-`](#) [`*`](#) [`/`](#) [`%`](#)

### Comparison

[`~=`](#) [`~==`](#) [`==`](#) [`===`](#) [`!=`](#) [`!==`](#) [`>`](#) [`<`](#) [`>=`](#) [`=<`](#) [`<=>`](#) [`||`](#) [`&&`](#)

### Pipe

[`>>`](#) [`>>>`](#) [`!>>`](#) [`?!>`](#) [`??>`](#)

### ...

[`|?`](#filter-operator)
[`|>`](#map-operator)
[`| `](#reduce-operator)
[`|.`](#pluck-operator)

`=+` `<+` `+>` `~>` `==>` `<>` `>=<` `|~` `|=` `|#` `..`

---

## Assignment

Operator | Name    | ...
---------|---------|----
`=`      |         |
`#=`     | seal    | seal an value or object
`+=`     |         |
`-=`     |         |
`*=`     |         |
`/=`     |         |

## Calculation / Math

Operator | Name      | ...
---------|-----------|----
`+`      | Add       |
`-`      | Substract |
`*`      | Multiply  |
`/`      | Divide    |
`%`      |           |

## Comparison

Operator | Name    | ...
---------|---------|----
`==`     | 
`===`    | 
`!=`     | 
`!==`    | 
`&&`     | and
`||`     | or
`<`      | 
`>`      | 
`=<`     | 
`>=`     | 
`<=>`    | 
`~=`     | pattern matching
`~==`    | 

## ....

Operator | Name    | ...
---------|---------|----
`\|?`    | [filter](#value)
`\|>`    | [map](#map-operator)
`\|*`    | [reduce](#reduce-operator)
`\|.`    | [pluck](#pluck-operator)

## Misc

Operator | Name    | ...
---------|---------|----
`>>`     | pipe
`>>>`    | deep pipe
`>=<`    | swap

### Symmetric Pipelines

​Pipelines allow sequence chaining. Conditional pipes prevent runtime crashes by short-circuiting on empty states.

#### `>>`

The `​|>` Standard Pipe: Forwards the left-hand value to the right-hand function call. Supports implicit function reference `(val |> fn)` and explicit positioning via the `@` placeholder (val |> fn(1, @)).

#### `?>>`

​The `??>` Nullish-Safe Pipe: Halts evaluation and returns `null` if the pipeline value evaluates to *nullish* (`null` or `undefined`).

#### `!>>`

​The `?!>` Falsy-Safe Pipe: Halts evaluation and returns the falsy value if the pipeline value is *falsy*.

```javascript
prop contacts = fetchUser(id) ??> parseProfile() ?!> getContacts();
```

#### `>>>`

...

---




# Operators

This document specifies all built-in operators in Poo, categorized by their execution role.

---

## Overview

### Assignment
[`=`](#assignment) ·
[`#=`](#assignment) ·
[`+=`](#assignment) ·
[`-=`](#assignment) ·
[`*=`](#assignment) ·
[`/=`](#assignment)

### Calculation / Math
[`+`](#calculation--math) ·
[`-`](#calculation--math) ·
[`*`](#calculation--math) ·
[`/`](#calculation--math) ·
[`%`](#calculation--math)

### Comparison & Logic
[`==`](#comparison--logic) ·
[`===`](#comparison--logic) ·
[`!=`](#comparison--logic) ·
[`!==`](#comparison--logic) ·
[`<`](#comparison--logic) ·
[`>`](#comparison--logic) ·
[`=<`](#comparison--logic) ·
[`>=`](#comparison--logic) ·
[`<=>`](#comparison--logic) ·
[`~=`](#comparison--logic) ·
[`~==`](#comparison--logic) ·
[`&&`](#comparison--logic) ·
[`||`](#comparison--logic)

### Collection Pipelines
[`|>`](#collection-pipelines) ·
[`|?`](#collection-pipelines) ·
[`|*`](#collection-pipelines) ·
[`|.`](#collection-pipelines)

### Execution Pipelines
[`>>`](#execution-pipelines) ·
[`>>>`](#execution-pipelines) ·
[`?>>`](#execution-pipelines) ·
[`!>>`](#execution-pipelines)

### Miscellaneous
[`>=<`](#miscellaneous) ·
[`..`](#miscellaneous)

---

## 1. Assignment

Assignment operators set or modify the value bound to an identifier.

| Operator | Name | Description | Example |
| :--- | :--- | :--- | :--- |
| `=` | Assign | Binds or reassigns a value to a identifier. | `val x = 10;` |
| `#=` | Seal | Permanently deep-freezes a variable or object at runtime. | `config #= true;` |
| `+=` | Add-Assign | Adds right operand to variable. | `count += 1;` |
| `-=` | Subtract-Assign | Subtracts right operand from variable. | `count -= 1;` |
| `*=` | Multiply-Assign | Multiplies variable by right operand. | `total *= 2;` |
| `/=` | Divide-Assign | Divides variable by right operand. | `total /= 2;` |

---

## 2. Calculation / Math

Arithmetic operators perform numerical transformations on numbers.

| Operator | Name | Description | Example |
| :--- | :--- | :--- | :--- |
| `+` | Addition | Sums two numerical operands. | `5 + 3` // `8` |
| `-` | Subtraction | Subtracts right operand from left operand. | `10 - 4` // `6` |
| `*` | Multiplication | Multiplies two numerical operands. | `4 * 2` // `8` |
| `/` | Division | Divides left operand by right operand. | `20 / 4` // `5` |
| `%` | Modulo | Returns remainder of integer division. | `10 % 3` // `1` |

---

## 3. Comparison & Logic

Comparison operators evaluate conditions and return boolean values (`true` or `false`).

| Operator | Name | Description | Example |
| :--- | :--- | :--- | :--- |
| `==` | Equal | Evaluates structural or value equality. | `a == b` |
| `===` | Strict Equal | Evaluates exact reference and type identity. | `a === b` |
| `!=` | Not Equal | Evaluates value inequality. | `a != b` |
| `!==` | Strict Not Equal | Evaluates strict reference/type inequality. | `a !== b` |
| `<` | Less Than | Evaluates if left is smaller than right. | `a < b` |
| `>` | Greater Than | Evaluates if left is larger than right. | `a > b` |
| `=<` | Less or Equal | Evaluates if left is smaller or equal to right. | `a =< b` |
| `>=` | Greater or Equal | Evaluates if left is larger or equal to right. | `a >= b` |
| `<=>` | Spaceship | Returns `-1` (smaller), `0` (equal), or `1` (larger). | `a <=> b` |
| `~=` | Soft Match | Pattern matching operator (structural / soft). | `val ~= Pattern` |
| `~==` | Deep Match | Pattern matching operator (strict / deep). | `val ~== Pattern` |
| `&&` | Logical AND | Returns `true` if both operands evaluate to true. | `condA && condB` |
| `||` | Logical OR | Returns `true` if at least one operand evaluates to true. | `condA \|\| condB` |

---

## 4. Collection Pipelines

Collection pipeline operators operate over iterable data structures (such as `Array` or `List`) to perform functional data transformations.

| Operator | Name | Description | Example |
| :--- | :--- | :--- | :--- |
| `\|>` | Map | Applies a transformation function to each element. | `list \|> (x => x * 2)` |
| `\|?` | Filter | Filters collection, keeping elements matching predicate. | `list \|? (x => x > 5)` |
| `\|*` | Reduce / Fold | Aggregates collection elements into a single value. | `list \|* ((acc, x) => acc + x)` |
| `\|.` | Pluck | Extracts a specific property key from all collection items. | `users \|. "name"` |

```poo
val users = [#{ name: "Alice", age: 30 }, #{ name: "Bob", age: 17 }];

// Extract names of adult users
val adult_names = users
  |? (u => u.age >= 18)
  |. "name";
```

---

## 5. Execution Pipelines

Execution pipelines forward scalar values or evaluation contexts through sequential function chains.

| Operator | Name | Description | Example |
| :--- | :--- | :--- | :--- |
| `>>` | Forward Pipe | Passes left-hand value as first argument to right-hand function. | `data >> parse` |
| `>>>` | Deep / Async Pipe | Awaits or unwraps nested pipeline promises before forwarding. | `fetchData() >>> parse` |
| `?>>` | Nullish-Safe Pipe | Short-circuits pipeline evaluation if left value is `nil`. | `res ?>> extractPayload` |
| `!>>` | Falsy-Safe Pipe | Short-circuits pipeline evaluation if left value is falsy. | `res !>> validate` |

### Pipeline Positioning (`@`)

By default, `>>` passes the left operand as the first argument. The `@` token can be used to explicitly define argument placement:

```poo
// Explicit argument positioning using @
val formatted = "hello" >> string.prefix(@, ">>> ");
```

---

## 6. Miscellaneous

Specialized utility operators.

| Operator | Name | Description | Example |
| :--- | :--- | :--- | :--- |
| `>=<` | Swap | Swaps the values bound to two variables in place. | `a >=< b;` |
| `..` | Range / Rest | Constructs a range sequence or represents rest in destructuring. | `1..10` or `[head, ..]` |

```poo
// Value swapping
var x = 1;
var y = 2;
x >=< y; // x is now 2, y is now 1
```


# Operators

This document specifies all built-in operators in Poo, categorized by their execution role.

---

## Overview

### Assignment
[`=`](#=) ·
[`#=`](#=-1) ·
[`+=`](#+=) ·
[`-=`](#-=) ·
[`*=`](#*=) ·
[`/=`](#/=)

### Calculation / Math
[`+`](#+) ·
[`-`](#-) ·
[`*`](#*) ·
[`/`](#/) ·
[`%`](#%)

### Comparison & Logic
[`==`](#==) ·
[`===`](#===) ·
[`!=`](#!=) ·
[`!==`](#!==) ·
[`<`](#<) ·
[`>`](#>) ·
[`=<`](#=<) ·
[`>=`](#>=) ·
[`<=>`](#<=>) ·
[`~=`](#~=) ·
[`~==`](#~==) ·
[`&&`](#&&) ·
[`||`](#||)

### Collection Pipelines
[`|>`](#|>) ·
[`|?`](#|?) ·
[`|*`](#|*) ·
[`|.`](#|.)

### Execution Pipelines
[`>>`](#>>) ·
[`>>>`](#>>>) ·
[`?>>`](#?>>) ·
[`!>>`](#!>>)

### Miscellaneous
[`>=<`](#>=<) ·
[`..`](#..)

---

## 1. Assignment Operators

| Operator | Name |
| :--- | :--- |
| `=` | Assign |
| `#=` | Seal |
| `+=` | Add-Assign |
| `-=` | Subtract-Assign |
| `*=` | Multiply-Assign |
| `/=` | Divide-Assign |

---

### `=`

Binds a new value or reassigns an existing non-sealed identifier.

```poo
val name = "Alice";
name = "Bob";
```

### `#=`

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

### `+=`

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

### `-=`

Subtracts the right operand or removes matching elements from a collection.

```poo
// Numerical subtraction
var hp = 100;
hp -= 20; // 80

// Item removal from collection
val pets = #['bird', 'cat', 'dog'];
pets -= 'cat'; // #['bird', 'dog']
```

### `*=`

Multiplies the variable by the right operand.

```poo
var factor = 5;
factor *= 3; // 15
```

### `/=`

Divides the variable by the right operand.

```poo
var balance = 100;
balance /= 4; // 25
```

---

## 2. Calculation / Math Operators

| Operator | Name |
| :--- | :--- |
| `+` | Addition |
| `-` | Subtraction |
| `*` | Multiplication |
| `/` | Division |
| `%` | Modulo |

---

### `+`

Calculates the arithmetic sum of two numbers.

```poo
val sum = 10 + 20; // 30
val total = 1.5 + 2.25; // 3.75
```

### `-`

Calculates the difference between two numbers or negates a value.

```poo
val diff = 100 - 45; // 55
val inverted = -10;
```

### `*`

Multiplies two numerical expressions.

```poo
val area = 10 * 5; // 50
```

### `/`

Divides the dividend by the divisor.

```poo
val ratio = 10 / 4; // 2.5
```

### `%`

Returns the remainder of integer division.

```poo
val remainder = 10 % 3; // 1
val is_even = (num % 2) == 0;
```

---

## 3. Comparison & Logic Operators

| Operator | Name |
| :--- | :--- |
| `==` | Equal |
| `===` | Strict Equal |
| `!=` | Not Equal |
| `!==` | Strict Not Equal |
| `<` | Less Than |
| `>` | Greater Than |
| `=<` | Less or Equal |
| `>=` | Greater or Equal |
| `<=>` | Spaceship |
| `~=` | Soft Match |
| `~==` | Deep Match |
| `&&` | Logical AND |
| `||` | Logical OR |

---

### `==`

Evaluates structural or value equality.

```poo
10 == 10; // true
"abc" == "abc"; // true
[1, 2] == [1, 2]; // true (Structural equality)
```

### `===`

Evaluates strict reference identity and exact type match.

```poo
val a = [1, 2];
val b = [1, 2];

a == b;  // true  (Same values)
a === b; // false (Different object references in memory)
```

### `!=`

Evaluates value inequality.

```poo
10 != 20; // true
```

### `!==`

Evaluates strict reference or type inequality.

```poo
val a = [1, 2];
val b = [1, 2];

a !== b; // true (Different references)
```

### `<`

Returns `true` if the left operand is strictly smaller than the right operand.

```poo
5 < 10; // true
```

### `>`

Returns `true` if the left operand is strictly larger than the right operand.

```poo
10 > 5; // true
```

### `=<`

Returns `true` if the left operand is smaller than or equal to the right operand.

```poo
5 =< 5; // true
3 =< 5; // true
```

### `>=`

Returns `true` if the left operand is larger than or equal to the right operand.

```poo
5 >= 5; // true
10 >= 5; // true
```

### `<=>`

Comparison operator (Spaceship). Returns `-1` if left is smaller, `0` if equal, and `1` if left is larger.

```poo
5 <=> 10; // -1
5 <=> 5;  // 0
10 <=> 5; // 1

// Custom sorting comparator
items.sort((a, b) => a.score <=> b.score);
```

### `~=`

Soft / Structural Pattern Match operator. Tests if a value conforms to a type, pattern, regex, or partial structure.

```poo
"user_123" ~= #/user_\d+/; // true (RegExp match)
42 ~= Int;                 // true (Type match)

val response = #{ status: 200, payload: "ok", latency: 12 };
response ~= #{ status: 200 }; // true (Partial structure match)
```

### `~==`

Deep / Strict Pattern Match operator. Requires exact structural match, including element count and type signatures.

```poo
val list = [1, 2, 3];

list ~= [1, 2];  // true  (Soft match)
list ~== [1, 2]; // false (Deep match: length mismatch)
```

### `&&`

Evaluates logical AND between boolean expressions.

```poo
val valid = (age >= 18) && has_ticket;
```

### `||`

Evaluates logical OR between boolean expressions.

```poo
val access = is_admin || is_owner;
```

---

## 4. Collection Pipelines

| Operator | Name |
| :--- | :--- |
| `\|>` | Map |
| `\|?` | Filter |
| `\|*` | Reduce / Fold |
| `\|.` | Pluck |

---

### `|>`

Maps every element in a collection through a transformation callback.

```poo
val nums = [1, 2, 3];
val doubled = nums |> (x => x * 2); // [2, 4, 6]

// Chaining method references
val tags = #['bird', 'cat'] |> toUpperCase; // #['BIRD', 'CAT']
```

### `|?`

Filters elements in a collection based on a predicate condition.

```poo
val nums = [1, 2, 3, 4, 5, 6];
val evens = nums |? (x => x % 2 == 0); // [2, 4, 6]
```

### `|*`

Reduces / folds a collection into a single aggregated value.

```poo
val nums = [1, 2, 3, 4];
val sum = nums |* ((acc, x) => acc + x); // 10
```

### `|.`

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

| Operator | Name |
| :--- | :--- |
| `>>` | Forward Pipe |
| `>>>` | Deep Pipe |
| `?>>` | Nullish-Safe Pipe |
| `!>>` | Falsy-Safe Pipe |

---

### `>>`

Forwards the left-hand expression result as the input argument to the right-hand function call.

```poo
fn double = x => x * 2;
fn addTen = x => x + 10;

val result = 5 >> double >> addTen; // 20

// Explicit placement via '@' placeholder
val formatted = "hello" >> string.prefix(@, ">>> "); // ">>> hello"
```

### `>>>`

Deep/Async pipe that unwraps or resolves pending asynchronous values before passing them to the next stage.

```poo
val result = fetch_user_async(id) >>> parse_json >>> save_db;
```

### `?>>`

Nullish-safe pipeline operator. Short-circuits the pipeline and returns `nil` if the left-hand evaluation yields `nil`.

```poo
val user_city = fetch_user(id) ?>> get_address ?>> get_city;
```

### `!>>`

Falsy-safe pipeline operator. Short-circuits the pipeline if the left-hand evaluation yields a falsy value (`false`, `nil`, `0`, `""`).

```poo
val contacts = load_profile() !>> validate_active !>> fetch_contacts;
```

---

## 6. Miscellaneous Operators

| Operator | Name |
| :--- | :--- |
| `>=<` | Swap |
| `..` | Range / Rest |

---

### `>=<`

Swaps the values bound to two variables in-place.

```poo
var a = "first";
var b = "second";

a >=< b;

print(a); // "second"
print(b); // "first"
```

### `..`

Constructs a range sequence or represents ignored rest parameters in destructuring.

```poo
// Range generation
val numbers = 1..5; // Range [1, 2, 3, 4, 5]

// Destructuring ignore rest
val #(head, ..) = #(10, 20, 30, 40); // head = 10
```


