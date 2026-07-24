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




