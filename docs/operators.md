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





