# poo

Coding sucks.

![Logo](./logo.jpg)

## Table of Contents

- [Let's code! (Introduction)](#lets-code)
- [Operators & Keywords](#operators-keywords)
- [Declarations](#declarations)
  - [Value Declaration](#declare-a-value)
  - [Function Declaration](#declare-a-function)
  - [Object Declaration](#declare-an-object)
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
- [Packages](#packages) 
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









#### `loop`

```scala
def animals  = ['bird', 'cat', 'dog' ];
def helloPet = (pet) => print "I love my $pet.";

for (animals as @animal) {
  helloPet @animal;
};

// oneliner
do for animals as animal helloPet(animal);
```


### Number

```c
pp num = 60;
pp dec = 10.5;
pp abc = 10_000_000; // 10000000
```

### String

```c
str name = 'Udo':
str text = 'Coding sucks.';
```

### Arrays

...

```c
pp sth = new Array ();
pp sth = ['abc', 123, true];
```

### List

A **List** is a special form of an array with:
- identical typed values

```c
obj pets = new List ();
obj pets = #['bird', 'cat', 'dog', 'fish'];
obj nums = #[1, 2, 3];
```

A **List** has all the builtin methods of **Array** *(outer type)* and depending on the type of it's values *(inner type)* one could use all those methods in combination.

```c
pp pets = #['bird', 'cat', 'dog', 'fish'];

// #['BIRD', 'CAT', 'DOG', 'FISH']
do pets.map (toUpperCase);

// #['DRIB', 'TAC', 'DOG', 'GOD', 'HSIF']
do pets.map (toUpperCase, reverse);

// #[HSIF, 'GOD', 'TAC', 'DRIB']
do pets.map (toUpperCase, reverse).reverse();
```

### Boundary Control (The Three-Tier Scope Model)

When defining objects, outer scopes are closed off by default. You must explicitly bridge dependencies across object boundaries using one of three keywords:

#### Overview

Keyword | Dependency Type | Prefix in Code | Write Behavior
--------|-----------------|----------------|---------------
`use`   | Static Snapshot | `variable`     | Mutates only the local copy inside the object.
`ref`   | Dynamic View    | `@variable`    | Live-read from outside. Writing creates a local override (Copy-on-Write).
`pnt`   | Direct Pointer  | `&variable`    | Live-read and direct write-through to the external variable.

#### `use`

The `use` keyword introduces a statement to declare an object to be absorbed in its current state (*static snapshot*).

```javascript
prop mood = 'grumpy'; 

prop nerd = {
  use mood;
  prop printMood = () => print("The nerd is $mood.");
};

nerd.printMood();
```

```javascript
prop hurtable #= {
  prop hp = 100;
  prop hurt = (n) => hp -= n ?? 1;
};

prop nerd = {
  use hurtable;
};

do nerd.hurt(5) and print nerd.hp;
```

#### `ref`

The `ref` keyword introduces a statement to ... (*dynamic view*).

The name will be prefixed with an `@`-symbol.

Assigning a new value to does not change the origin's value.

```javascript
prop fishsticks = 'yummy'; 

prop nerd = {
  ref fishsticks;
  prop doYouLikeFishsticks = (b) => @fishsticks = b ? 'yummy' : 'disgusting';
  prop print = () => print("Fishsticks are $@fishsticks.");
};

nerd.print(); // "Fishsticks are yummy."

nerd.doYouLikeFishsticks(false);

nerd.print(); // "Fishsticks are disgusting."
print(fishsticks); // origin is still 'true'
```

#### `pnt`

The `pnt` keyword introduces a statement to ... (*direct pointer*).


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

## Philosophy

### About POO

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

###

```c
prop processPayload = filePath => {
  @text = fs::read(filePath) ?? return "file missing";
  @data = json::parse(text)  ?? return "invalid json structure";

  if (@data ~= object{ id: number, targetUrl: string }) {
    @safeUrl = @data.targetUrl |> url::decode |> html::escape;
    print "Processing safe target: $@safeUrl";
  }
  
  or return "payload fields are garbage";
};

```

- [Context-Aware Return Types](#context-aware-return-types)
- [Typecasting](#typecasting)


## Declarations & Memory Management

Variable States

​The keyword `prop` introduces a declaration statement to define a named *value* or *block of code*.

​The `#` prefix defines a ***compile-time constant***. Casing rules are not enforced; the prefix is the sole indicator of immutability.

​The `#=` operator makes it possible to seal a variable on runtime so it becomes immutable. They assign a value and freeze the variable recursively (deep-freeze).

```javascript
prop #compilerState = "broken"; // compile-time constant

prop cat = 'miau';
cat += '!!!'; // allowed

cat #= 'wuff'; // assigned and sealed permanently
cat = 'meow';  // compile-time error: variable is sealed.
```


## Types & Structures

​The `#` symbol acts as the universal indicator for structural rigidity.

```javascript
prop dynamicList = [1, "garbage", true]; // Standard dynamic array
prop strictList = #[1, 2, 3];            // Homogeneous strict list (frozen type)
prop userTuple = #("Udo", 60);           // Strict heterogenous tuple (fixed size/types)
```

* Lists (#[...]): Elements must share the exact same type. Under the hood, this compiles to contiguous, unboxed memory blocks for cache friendliness.
* ​Tuples (#(...)): Fixed size and fixed type per index. Values can be updated as long as they respect the declared type at that position.
* ​Ranges: Defined using ... (inclusive) or ..< (exclusive). Useful for loops, slicing, and pattern matching.

```javascript
// Inclusive Loop
do for 1...5 as @i {
  print("Line @i: This is garbage.");
}

// Exclusive Slicing
prop list = ['a', 'b', 'c', 'd'];
prop slice = list[1..<3]; // ['b', 'c']
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

## Typecasting & Context-Aware Return Types

​Explicit typecasting is handled via the `as` and `as?` operators.

### ​Symmetrical Cast Failbacks

* ​In `strict` directory mode, `as` crashes or throws a compiler error on failure.
* ​In `relaxed` directory mode, `as` falls back to the target type's default value (`0`, `false`, `""`).
* ​In both modes, `as?` returns `null` on failure, allowing seamless coalescing chains.

```c
prop rawInput = "not_a_number";

// Explicit cast with falsy fallback
prop age1 = rawInput as number ?! 123; // Result: 123 (fails to 0, which is falsy, triggers ?!)

// Explicit safe cast with nullish fallback (preserves valid 0 values)
prop age2 = rawInput as? number ?? 123; // Result: 123 (fails to null, triggers ??)
```

### Implicit Optimization (Zero-Allocation Casts)

​Object-level `as` casting handlers look like runtime converters, but the compiler optimizes them into direct conditional branches.

```javascript
prop getErrors = () => {
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

```
first class function
higher order function
pattern matching
list comprehension
generator expression
```

## Operators

#### Math / Calculation

Operator | Name      | ...
---------|-----------|----
`+`      | Add       |
`-`      | Substract |
`*`      | Multiply  |
`/`      | Divide    |

####

Operator | Name    | ...
---------|---------|----
`??`     | Nullish |
`\|>`    | Pipe    |
`?>`     |         | 

#### Comparison

Operator | Name    | ...
---------|---------|----
`\|\|`   | Or      |
`&&`     | And     |
`~=`     | Pattern | Pattern Matching

#### Assignment

Operator | Name    | ...
---------|---------|----
`=`      |         |
`#=`     | Seal    | seal an value or object
`+=`     |         |
`-=`     |         |
`*=`     |         |
`/=`     |         |

