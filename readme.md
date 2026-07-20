# poo

Coding sucks.

![Logo](./logo.jpg)

## Table of Contents

- [Let's code! (Introduction)](#lets-code)
- [Operators & Keywords](#operators-keywords)
  - [Keywords](#keywords)
  - [Operators](#operators)
- [Declarations](#declarations)
  - [Value Declaration](#value-declaration)
  - [Function Declaration](#function-declaration)
  - [Object Declaration](#object-declaration)
- [Control Flow](#control-flow)
  - [Conditional](#cond)
  - [Switch](#switch)
  - [Loops](#loops)
- [Do](#do)
- [Pipe](#pipe)
- [Types](#types)
  - [Data-Types](#data-types)
  - [Context-Aware Return Types](#context-aware-return-types)
  - [Typecasting](#typecasting)
- [Packages](#packages)
- [Advanced](#advanced)
  - [Operator Overloading](#operator-overloading)
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

# Operators & Keywords

## Operators

#### Assignment

[`=`](#) [`=#`](#) [`+=`](#) [`-=`](#) [`*=`](#)

### Calculation

[`+`](#) [`-`](#) [`*`](#) [`/`](#) [`%`](#)

#### Comparison

[`~=`](#) [`~==`](#) [`==`](#) [`===`](#) [`!=`](#) [`!==`](#) [`>`](#) [`<`](#) [`>=`](#) [`=<`](#) [`<=>`](#) [`||`](#) [`&&`](#)

#### Pipe

[`>>`](#) [`>>>`](#) [`!>>`](#) [`?!>`](#) [`??>`](#)

#### ...

`=+` `<+` `+>` `~>` `==>` `<>` `>=<`

## Keywords

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
[`yield`](#yield)

#### Declaration Statement Introducers

[`cpy`](#cpy)
[`fn`](#fn)
[`obj`](#obj)
[`pkg`](#pkg)
[`ref`](#ref)
[`use`](#use)
[`val`](#val)

---

# Declarations

Declaration Statements are introduced by the keywords: `val` `fn` `obj`

## Value Declaration

```go
val num   = 123; // mutable
val str  #= "moin!"; // immutable (runtime)
val #fix  = "constant!"; // real constant (compiletime)
```

#### Declare a Constant

​The `#` prefix on the name (*identifier*) of a value defines a ***compile-time constant***.

```javascript
val #compilerState = "broken"; // compile-time constant
```

#### Seal a Value

​The `#=` operator makes it possible to seal (*freeze*) a value on runtime so it becomes immutable recursively (*deep-freeze*).

```javascript
val exbf #= 'you can't change me!';
```

This operator could also be used to make an value immutable at any later point.

```javascript
val cat = 'miau';
cat += '!!!'; // allowed

cat #= 'wuff'; // assigned and sealed permanently
cat  = 'meow';  // compile-time error: variable is sealed.
```

## Function Declaration

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

## Object Declaration

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

# Control Flow

## `if` | `or`

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

### `loop`

```scala
val animals  = ['bird', 'cat', 'dog' ];
val helloPet = (pet) => print "I love my $pet.";

loop (animals as @animal) {
  helloPet @animal;
};

// oneliner
loop animals as animal do helloPet (animal);
loop animals as animal do helloPet animal;
```

## `do`

The `do` keyword is most likely the awkward operator of the language because it's kinda overloaded (not really in the end but...) because it's related to lots of behaviour.

On an statement introduced by `do` more the keywords `and`, `of`, `on` and `or` became also avaible which (except `or`) could only be used in this context.

### 1. `do` as a line guard

### 2. `do` as an expression guard

### 3. `do` as an human-readable code

Let's assume we have sth. like this:

```javascript
obj Hurtable #= {
  val hp = 100;
  val hurt = (n) => hp -= n ?? 1;
};

obj Nerd = {
  use hurtable;
};

val nerd = new Nerd;
```

Now we could obviously do sth. like this:

```scala
nerd.hurt(5); print(nerd.hp); //
nerd.hurt 5; print nerd.hp; // alternative
```

However the `do` keyword enables `on` (to reference a function call on an object) and `of` (to reference a property of an object) in combination with alternative syntax this results in the ability have this semantics:

```java
do hurt (5) on nerd and print hp of nerd;
do hurt 5 on nerd and print hp of nerd;
```

## Boundary Control (The Three-Tier Scope Model)

When defining objects, outer scopes are closed off by default. You must explicitly bridge dependencies across object boundaries using one of three keywords:

#### Overview

Keyword | Dependency Type | Prefix in Code | Write Behavior
--------|-----------------|----------------|---------------
`use`   | Static Snapshot | `variable`     | Mutates only the local copy inside the object.
`ref`   | Dynamic View    | `@variable`    | Live-read from outside. Writing creates a local override (Copy-on-Write).
`pnt`   | Direct Pointer  | `&variable`    | Live-read and direct write-through to the external variable.

#### `use`

The `use` keyword introduces a statement to declare an object or value to be absorbed in its current state (*static snapshot*).

```javascript
val mood = 'grumpy'; 

obj nerd = {
  use mood;
  val printMood = () => print("The nerd is $mood.");
};

nerd.printMood();
```

```javascript
obj hurtable #= {
  val hp = 100;
  val hurt = (n) => hp -= n ?? 1;
};

obj nerd = {
  use hurtable;
};

do nerd.hurt(5) and print nerd.hp;
do hurt (5) on nerd and print hp of nerd;
```

#### `cpy`

The `cpy` keyword introduces a statement to ... (*dynamic view*).

The name will be prefixed with an `@`-symbol.

Assigning a new value to does not change the origin's value.

```javascript
val fishsticks = 'yummy';

obj nerd = {
  ref fishsticks;
  fn doYouLikeFishsticks = (b) => @fishsticks = b ? 'yummy' : 'disgusting';
  fn print = () => print("Fishsticks are $@fishsticks.");
};

nerd.print(); // "Fishsticks are yummy."

nerd.doYouLikeFishsticks(false);

nerd.print(); // "Fishsticks are disgusting."
print(fishsticks); // origin is still 'true'
```

#### `ref`

The `ref` keyword introduces a statement to ... (*direct pointer*).

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

### Blob

### Bool

```js
val maybe = true;
val never = false;
```

### Char

```js

```

### Color

```js

```

### Date

```js

```

### Enum

```js

```

### Generator

```js

```

### List

A **List** is a special form of an array with:
- identical typed values

```c
val pets = new List;
val pets = #['bird', 'cat', 'dog', 'fish'];
val nums = #[1, 2, 3];
```

A **List** has all the builtin methods of **Array** *(outer type)* and depending on the type of it's values *(inner type)* one could use all those methods in combination.

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

### Map

```js

```

### Number

```c
val num = 60;
val dec = 10.5;
val abc = 10_000_000; // 10000000
```

### String

```c
val name = "Udo":
val text = "Coding sucks.";
```

---

## Packages

[`audio`](#audio) [`db`](#db) [`fs`](#fs) [`img`](#img) [`io`](#io) [`md`](#md) [`url`](#url) [`video`](#video)




### the `new` keyword

```scala
obj person = {
  val name = 'Udo';
  val age  = 60;
  
  fn printInfo = () => print "$name is $age years old.";
};

// creates copy/clone/instance of 'person' in its current state
obj inst1 = new person;

person.age = 61;
print(person.age); // 61


obj inst2 = new person;
person.age = 62;

print person.age; // 62
print inst1.age;  // 60
print inst2.age;  // 61
```

```javascript
obj person = (name, age) => {
  val name = 'Udo';
  val age  = 60;
  
  fn printInfo = () => print('@name is @age years old.');
};

obj p1 = new person;
obj p2 = new person (age: 61);
obj p3 = new person (age: 20, name: 'Stella');

p1.printInfo(); //    Udo is 60 years old.
p2.printInfo(); //    Udo is 61 years old.
p3.printInfo(); // Stella is 20 years old.
```

### the `use` keyword

By the `use` keyword one could apply the value of a ding when defining another one.

```python
obj Person = () => {
  val name;
  val age;
  val country;

  fn whoAmI = () => print "$name is from $country and $age years old.";
};

obj Male = () => {
  use Person;
  val sex = 'male';
}

obj Female = () => {
  use Person;
  val sex = 'female';
}

// change the value of a prop on init
obj Hans = new Male   (name: 'Hans', age: 44);
obj Gabi = new Female (name: 'Gabi', age: 30);

// change the value of a prop when calling
Hans(country: 'Austria').whoAmI();
```


```cpp
prop parseToken = token => switch (token.type) {
  "EOF"   => null; //
  "SEMI"  do continue;
  "IDENT" do processIdentifier(token.value);
  or      do print "Unexpected token: $token" and return "error";
};
```



...

###

```javascript
prop globalCounter = 0;
prop configName    = 'dev';
prop baseStats     = { hp: 100 };

prop player = {
  use baseStats;      // Statische Kopie
  ref configName;     // Live-Ansicht (Copy-on-Write)
  pnt globalCounter;  // Aktiver Pointer

  prop tick = () => {
    // 1. Lokaler Zugriff (Kein Präfix)
    print baseStats.hp; 

    // 2. Live-Read-Zugriff (Präfix @)
    print @configName; 

    // 3. Durchschreibender Zugriff (Präfix &)
    &globalCounter += 1; 
  };
};
```











### Symmetric Pipelines

​Pipelines allow sequence chaining. Conditional pipes prevent runtime crashes by short-circuiting on empty states.

#### `|>`

The `​|>` Standard Pipe: Forwards the left-hand value to the right-hand function call. Supports implicit function reference `(val |> fn)` and explicit positioning via the `@` placeholder (val |> fn(1, @)).

#### `??>`

​The `??>` Nullish-Safe Pipe: Halts evaluation and returns `null` if the pipeline value evaluates to *nullish* (`null` or `undefined`).

#### `?!>`

​The `?!>` Falsy-Safe Pipe: Halts evaluation and returns the falsy value if the pipeline value is *falsy*.

```javascript
prop contacts = fetchUser(id) ??> parseProfile() ?!> getContacts();
```

#### `!>`

...



```
first class function
higher order function
pattern matching
list comprehension
generator expression
```


## Misc

## Declarations & Memory Management

Variable States

​The keyword `prop` introduces a declaration statement to define a named *value* or *block of code*.



## Types & Structures

​The `#` symbol acts as the universal indicator for structural rigidity.

```javascript
val dynamicList = [1, "garbage", true]; // Standard dynamic array
val strictList = #[1, 2, 3];            // Homogeneous strict list (frozen type)
val userTuple = #("Udo", 60);           // Strict heterogenous tuple (fixed size/types)
```

* Lists (#[...]): Elements must share the exact same type. Under the hood, this compiles to contiguous, unboxed memory blocks for cache friendliness.
* ​Tuples (#(...)): Fixed size and fixed type per index. Values can be updated as long as they respect the declared type at that position.
* ​Ranges: Defined using ... (inclusive) or ..< (exclusive). Useful for loops, slicing, and pattern matching.

```javascript
// Inclusive Loop
loop 1...5 as @i {
  print("Line @i: This is garbage.");
}

// Exclusive Slicing
val list = ['a', 'b', 'c', 'd'];
val slice = list[1..<3]; // ['b', 'c']
```

## Typecasting & Context-Aware Return Types

​Explicit typecasting is handled via the `as` and `as?` operators.

### ​Symmetrical Cast Failbacks

* ​In `strict` directory mode, `as` crashes or throws a compiler error on failure.
* ​In `relaxed` directory mode, `as` falls back to the target type's default value (`0`, `false`, `""`).
* ​In both modes, `as?` returns `null` on failure, allowing seamless coalescing chains.

```c
prop rawInput = "not_a_number";

// Explicit cast with falsy fallback
val age1 = rawInput as number ?! 123; // Result: 123 (fails to 0, which is falsy, triggers ?!)

// Explicit safe cast with nullish fallback (preserves valid 0 values)
val age2 = rawInput as? number ?? 123; // Result: 123 (fails to null, triggers ??)
```

### Implicit Optimization (Zero-Allocation Casts)

​Object-level `as` casting handlers look like runtime converters, but the compiler optimizes them into direct conditional branches.

```javascript
fn getErrors = () => {
  return {
    prop list = ["syntax error", "compiler crying"];
    
    as number = () => list.len();
    as string = () => list.join(", ");
  };
};

// Compiled directly to getErrors(@as = string)
// Skips object and array allocations entirely.
prop alert = getErrors() as string;
```

---

## Philosophy

The language sees itself as an *weird bastard like JavaScript* but with more time to intensionally become like that.

### About POO




---

> [!NOTE]
> Useful information that users should know, even when skimming content.

> [!TIP]
> Helpful advice for doing things better or more easily.

> [!IMPORTANT]
> Key information users need to know to achieve their goal.

> [!WARNING]
> Urgent info that needs immediate user attention to avoid problems.

> [!CAUTION]
> Advises about risks or negative outcomes of certain actions.


## Examples

###

```c
fn processPayload = filePath => {
  val text = fs::read(filePath) or return "file missing";
  val data = json::parse(text)  or return "invalid json structure";

  if (data ~= obj{ id: Number, targetUrl: String }) {
    safeUrl = data.targetUrl >> url::decode >> html::escape;
    print "Processing safe target: $safeUrl";
  }
  or return "payload fields are garbage";
};

```
