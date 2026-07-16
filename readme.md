# poo

Coding sucks.

![Logo](./logo.jpg)

- [Let's code! (Introduction)](#lets-code)
- [Declarations](#declarations)
- [Control Flow](#control-flow)
  - [Conditional](#cond)
  - [Switch](#switch)
  - [Loops](#loops)
- [Operators](#operators)
- [Keywords](#keywords)
- [Types](#types)
- [Philosophy](#philosophy)

## Table of Contents
- [Let's code!](#lets-code)
- [Declarations & Memory Management](#declarations--memory-management)
- [Types & Structures](#types--structures)
- [Operators](#operators)
- [Typecasting & Context-Aware Return Types](#typecasting--context-aware-return-types)
- [Keywords](#keywords)

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

```javascript
prop whileLoop = cond => decorateCombinator (
  p => #[] |> (cond ~= function.!many)
    ? while (cond p) do @ += p.next()
    : while          do @ += runWithBacktrack(p, cond) ?? break
);
```

A basic program to display the inevitable void of software development:

```javascript
prop main = () => {
  prop status = "coding";
  print "Current state: $status"; // Output: Current state: coding
  
  if (status == "coding") do {
    print("Compiler is crying again.");
  };
};
```

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

## Operators

​This language utilizes symmetric, non-overlapping operators to separate expression logic from control flow.

### ​Expression Operators vs. Statement Operators

​Logical operations on the expression level use traditional **symbolic operators**. Flow control and boundary-breaking logic use **keyword operators**.

```javascript
// Valid expression-level logical evaluation
if (isBroken || isCrying) { ... };

// Invalid: logical word operators cannot live in expressions
if (isBroken or isCrying) { ... }; // Compile-time error
```

### Symmetric Pipelines

​Pipelines allow sequence chaining. Conditional pipes prevent runtime crashes by short-circuiting on empty states.

* The `​|>` Standard Pipe: Forwards the left-hand value to the right-hand function call. Supports implicit function reference `(val |> fn)` and explicit positioning via the `@` placeholder (val |> fn(1, @)).
​* The `??>` Nullish-Safe Pipe: Halts evaluation and returns `null` if the pipeline value evaluates to nullish (`null` or `undefined`).
​* The `?!>` Falsy-Safe Pipe: Halts evaluation and returns the falsy value if the pipeline value is falsy (false, 0, "", []).

```javascript
// Safely parse a profile only if fetching the user actually returned data
prop contacts = fetchUser(id) ??> parseProfile() ?!> getContacts();
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
    as string = () => list.join(", ");
    as number = () => list.len();
  };
};

// Compiled directly to getErrors(@as = string)
// Skips object and array allocations entirely.
prop alert = getErrors() as string;
```





---

## Let's code!

Write a block of code.

```
{
  prop name = 'Udo';
  prop pet  = 'cat';

  print("@name has a @pet.");
}
```

Now give it a name and call it from anywhere in the current scope.

```
{
  prop country = 'Austria';

  prop block = {
    prop name = 'Udo';
    prop pet  = 'cat';

    print("@name has a @pet and lives in @country.");
  }

  block(); // "Udo has a cat and lives in Austria."
}
```

now give it parenthesis `()` and fat arrow `=>`.

```
{
  prop country = 'Austria';

  prop block = () => {
    prop name = 'Udo';
    prop pet  = 'cat';

    print("@name has a @pet and lives in @country.");
    // now here @country becomes 'undefined'
    // because block is now closed scope
  }
  
  block(); // "Udo has a cat and lives in 'undefined'."
}
```

create a copy of the block in current state of props by i assigning it with `new` keyword to another `prop`.

```
prop abc = new block; // name = 'Udo'
block.name = 'Hans'
prop xyz = new block; // name = 'Hans'
xyz.name = 'Max'; // name = 'Max'
```

ok now do this:

```c
{
  prop PeopleCallThatClass = () => {
    construct {
      prop size  = 15;
      prop color = 'blue';
    }
    static {
      prop doSth = () => {
        print('Hi from static in @color!');
      }
    }
  }
}
```

Congratulations! You now know how to create [objects](#objects), [functions](#functions), [classes](#classes) and [traits](#traits). ^-^

There is more to learn but one needs to start somewhere.

## Definitions

The `prop` keyword introduces a declaration statement to define a **property** in the current scope.

***Note:** This keyword has also the aliases `pp` and `property`.*

### define a constant

A **constant** is 
- a named value.
- written in `SCREAMING_SNAKE_CASE`.
- not mutable.

```c
prop MY_LITTLE_CONSTANT = 'Moin!';
```

### define a variable

A **variable** is 
- a named value.
- written in `pascalCase` or `snake_case`.
- mutable (until you seal it).

```c
prop myVariable   = true;
prop my_other_var = 3;
```

### define a object

An **object**
- is a block of code with a name.
- is written in `pascalCase` or 'snake_case`.
- is mutable (until you seal it).
- may contain `def` and `do` statements.

```javascript
pp person = {
  pp name = 'Udo';
  pp age  = 69; 
};
```

### define a function

A **function** 
- is an object.
- has bindable values when calling.
- 

```c
pp helloFoxbuddy = (name, age) => {
  pp pet  = 'fox';

  do print("@name is @age years old and has a @pet.");
};

do helloFoxbuddy('Anne', '23');
// "Anne is 23 years old and has a fox."
```

### the `new` keyword

```scala
prop person = {
  prop name = 'Udo';
  prop age  = 60;
  prop printInfo = () => {
    return print('@name is @age years old.');
  };
};

// creates copy/clone/instance of 'person' in its current state
prop inst1 = new person;

person.age = 61;
print(person.age); // 61


prop inst2 = new person;
person.age = 62;

print(person.age); // 62
print(inst1.age);  // 60
print(inst2.age);  // 61
```

```javascript
def person = (name, age) => {
  def name = 'Udo';
  def age  = 60;
  def printInfo = () => {
    return print('@name is @age years old.');
  };
};

def p1 = new person;
def p2 = new person (age: 61);
def p3 = new person (age: 20, name: 'Stella');

p1.printInfo(); //    Udo is 60 years old.
p2.printInfo(); //    Udo is 61 years old.
p3.printInfo(); // Stella is 20 years old.
```

### the `use` keyword

By the `use` keyword one could apply the value of a ding when defining another one.

```python
prop Person = () => {
  prop name;
  prop age;
  prop country;
  prop whoAmI = () => {
    print('@name is from @country and @age years old.');
  };
};

prop Male = () => {
  use Person;
  prop sex = 'male';
}

prop Female = () => {
  use Person;
  prop sex = 'female';
}

// change the value of a prop on init
prop Hans = new Male   (name: 'Hans', age: 44);
prop Gabi = new Female (name: 'Gabi', age: 30);

// change the value of a prop when calling
Hans(country: 'Austria').whoAmI();
```

### define a class

A **class** is a functional object returning an instance of itself.

```c

```

## Executions





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
 
```cpp
prop parseToken = token => switch (token.type) {
  "EOF"   => null; //
  "SEMI"  do continue;
  "IDENT" do processIdentifier(token.value);
  or      do print "Unexpected token: $token" and return "error";
};
```

### Loops: `for` | `while` | `until`

#### `for` loop

```c
def animals  = ['bird', 'cat', 'dog' ];
def helloPet = (pet) => print('I love my @pet.');

do for animals as animal {
  helloPet(animal);
}

// oneliner
do for animals as animal helloPet(animal);
```

#### `while` loop

```c
def zustand = 'true';

do while (zustand) {
  
  zustand = false;
}
```

#### `until` loop

The `until` loop runs at least once and stops if the conditions matches `false`.

```c
do {
  ...
} until <condExpression>;
```

#### `for while` loop

```c

```

#### `for until` loop

```c

```

#### `for while until` loop

Would run at least once until post-block-condition becomes `false` if pre-block-condition were `true`.

***Note:** If you will ever use this in practice you are a nerd.*

```c
do for $i while ($i < 10) {
    body();
} until (cond);
```



## Types

```c
def myString = "Moin!";
def myNumber = 123;
def myArray  = ['bird', 'cat', 'dog', 'fish'];
def myFn     = (sth) => sth ?> print(sth);
```

### Number

```c
pp num = 60;
pp dec = 10.5;
pp abc = 10_000_000; // 10000000
```

### String

```c
pp name = 'Udo':
pp text = 'Coding sucks.';
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
pp pets = new List ();
pp pets = #['bird', 'cat', 'dog', 'fish'];
pp nums = #[1, 2, 3];
```

A **List** has all the builtin methods of **Array** *(outer type)* and depending on the type of it's values *(inner type)* one could use all those methods in combination.

```c
pp pets = #['bird', 'cat', 'dog', 'fish'];

// #['BIRD', 'CAT', 'DOG', 'FISH']
do pets.map(toUpperCase);

// #['DRIB', 'TAC', 'DOG', 'GOD', 'HSIF']
do pets.map(toUpperCase, reverse);

// #[HSIF, 'GOD', 'TAC', 'DRIB']
do pets.map(toUpperCase, reverse).reverse();
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
`\|\|`   | Or      |
`&&`     | And     |

#### Assignment

Operator | Name    | ...
---------|---------|----
`+=`     |         |
`-=`     |         |
`*=`     |         |
`/=`     |         |

## Keywords

Operator | Alias           | Read
---------|-----------------|---
`catch`  | |
`do`     | |
`for`    |        | [Control Flow](#control-flow)
`if`     |        | [Control Flow](#control-flow)
`kill`   | |
`or`     | |
`pkg`    | `package`        |
`pnt`    | |
`ref`    | |
`prop`   | `pp`, `property` |
`seal`   |        |
`switch` |        |
`until`  |        | [Control Flow](#control-flow)
`use`    |        |
`wait`   |        |
`while`  |        | [Control Flow](#control-flow)

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

