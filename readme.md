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

## Operators

​This language utilizes symmetric, non-overlapping operators to separate expression logic from control flow.



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







---

## Definitions

The `prop` keyword introduces a declaration statement to define a **property** in the current scope.

***Note:** This keyword has also the aliases `pp` and `property`.*

### define a constant

A **constant** is 
- a named value.
- not mutable.
- created on compile time.
- globally accessable.

```scala
val #konstante = 'Moin!';
```

### define a variable

A **variable** is 
- a named value.
- written in `pascalCase` or `snake_case`.
- mutable (until you seal it).

```scala
val myVariable   = true;
val my_other_var = 3;
```

### define a object

An **object**
- is a block of code with a name.
- is written in `pascalCase` or 'snake_case`.
- is mutable (until you seal it).
- may contain `def` and `do` statements.

```scala
obj person = {
  val name = 'Udo';
  val age  = 69; 
};
```

### define a function

A **function** 
- is an object.
- has bindable values when calling.
- 

```scala
fn helloFoxbuddy = (name, age) => {
  val pet  = 'fox';

  do print "$name is $age years old and has a $pet.";
};

do helloFoxbuddy('Anne', '23');
// "Anne is 23 years old and has a fox."
```



```
first class function
higher order function
pattern matching
list comprehension
generator expression
```












