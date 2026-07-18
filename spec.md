# poo

Coding sucks.

![Logo](./logo.jpg)

## Table of Contents

- [Let's code! (Introduction)](#lets-code)
- [Declarations](#declarations)
- [Control Flow](#control-flow)
  - [Conditional](#cond)
  - [Switch](#switch)
  - [Loops](#loops)
- [Keywords](#keywords)
- [Operators](#operators)
- [Types](#types)
  - [Data-Types](#data-types)
  - [Context-Aware Return Types](#context-aware-return-types)
  - [Typecasting](#typecasting)
- [Philosophy](#philosophy)

---

## Let's code!

A lot of people do like **JavaScript** ...

```javascript
// javascript original
const whileLoop = (cond) => decorateCombinator (p => {
  const results = [];
  if (typeof p === 'function' && !cond.many) {
    while (cond(p)) results.push(p.next());
    return results;
  }
  while (true) {
    const result = runWithBacktrack(p, cond);
    if (result === null) break;
    results.push(result);
  }
  return results;
});
```

... but some people do like **poo**. ^-^

```php
fn whileLoop = cond => decorateCombinator (
  p => #[] |> (p ~= fn && !cond.many)
    ? loop (cond p) do @ += p.next()
    : loop          do @ += runWithBacktrack(p, cond) or break
);
```

---

## Operators

### ​Expression Operators vs. Statement Operators

​



```javascript
// Valid expression-level logical evaluation
if (isBroken || isCrying) { ... };

// Invalid: logical word operators cannot live in expressions
if (isBroken or isCrying) { ... }; // Compile-time error
```

---

## Operators

Logical operations on the expression level use traditional **symbolic operators**. 

#### Assignment

[`=`](#) [`=#`](#) [`+=`](#) [`-=`](#) [`*=`](#)

#### Comparison

[`~=`](#) [`==`](#) [`===`](#) [`!=`](#) [`!==`](#) [`<`](#) [`>`](#) [`>=`](#) [`=<`](#) [`||`](#) [`&&`](#)

#### Pipe

[`|>`](#) [`!>`](#) [`?!>`](#) [`??>`](#)

### Keywords

Flow control and boundary-breaking logic use **keyword operators**.

#### Expression Level

[`as`](#as)
[`new`](#new)

#### Statement Level

[`and`](#and) 
[`break`](#break)
[`catch`](#catch)
[`continue`](#continue)
[`do`](#do)
[`if`](#if) 
[`kill`](#kill) 
[`loop`](#loop) 
[`or`](#or) 
[`return`](#return) 
[`switch`](#switch) 

#### Declaration Statement Introducers

[`cpy`](#cpy)
[`fn`](#fn)
[`obj`](#obj)
[`pkg`](#pkg)
[`ref`](#ref)
[`use`](#use)
[`val`](#val)

---

## Declarations

Declaration Statements are introduced by the keywords: `val` `fn` `obj`

### Declare a Value

```go
val num  = 123; // mutable
val str #= "moin!"; // immutable
```

### Declare a Function

```java
// functions with no arguments
fn doSomething = () => print "moin!";
fn doSomething      => print "moin"!;

// with arguments
fn sum = (a, b) => print (a * b);
fn sum =  a, b  => print (a * b); // parens are optional
fn sum =  a  b  => print (a * b); // commas are optional
```

#### Call a function

```c#
// no arguments = enforced parens
callSth ();

// exactly 1 argument = optional parens
callSth ("i hate compilers");
callSth "i hate compilers";

// multiple arguments
callSth (100, "moin!"); // positional call
callSth (100 "moin!"); // positional call = optional commas
callSth (b: "moin!", a: 100); // lexical call ("named arguments")
```

### Declare an Object

The `obj` keyword is used to declare a **new type of object**.

```js
obj Cat = {
  val color  = "black";
  val mood  #= "grumpy"; // grumpy forever >.<

  fn makeNoise = () => print "meow!";
};
```

For declaration of *key-value-pairs* see the [Data-Types](#data-types) section.

---

## Control Flow

### `if` | `or`

```c
if <condExpr> {...};

// oneliner
if <condExpr> do <statment>;
```

```c
//
if <condExpr> {...}
or <condExpr> {...}  // like 'else if'
or            {...}; // like `else'

// oneliners
if <condExpr> or <condExpr> do <statment>;
if <condExpr> or <condExpr> or do <statment>;
```

```zig
//
if <condExpr>
&& <condExpr> {...}
or <condExpr> {...}  // like 'else if'
or            {...}; // like `else'
```

### `switch`

...        | ...
-----------|--------
`switch`   | `true`
`?switch`  | *nullish*
`!switch`  | `false`
`?!switch` | *falsy*

```cpp
// implicit comparing against 'true'
switch {
  a  do bark();
  b  do meow();
  c  do woof();
  or do cry();
};

// implicit comparing against 'false'
!switch {
  a  do bark();
  b  do meow();
  c  do woof();
  or do cry();
};

// implicit comparing against nullish values
?switch {
  a  do bark();
  b  do meow();
  c  do woof();
  or do cry();
};

// implicit comparing against falsy values
?!switch {
  a  do bark();
  b  do meow();
  c  do woof();
  or do cry();
};
```

---


---



---

## Data-Types

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
[`Type`](#type)

### Array

#### Static Methods

#### Instance Methods

### Color

### String

#### Methods

Name | ...
-----|----
[`toCamelCase`](#toCamelCase)       | convert a string to camel case
[`toConstantCase`](#toConstantCase) | convert a string to constant case
[`toKebabCase`](#toKebabCase)       | convert a string to kebab case
[`toPascalCase`](#toPascalCase)     | convert a string to pascal case
[`toSnakeCase`](#toSnakeCase)       | convert a string to snake case
[`toTitleCase`](#toTitleCase)       | convert a string to title case

##### `toCamelCase`

##### `toKebabCase`

##### `toPascalCase`

##### `toTitleCase`




## Packages

[`audio`](#audio) [`db`](#db) [`fs`](#fs) [`img`](#img) [`io`](#io) [`md`](#md) [`url`](#url) [`video`](#video)

