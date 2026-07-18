# poo

Coding sucks.

![Logo](./logo.jpg)

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












