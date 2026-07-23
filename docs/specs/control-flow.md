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
if <condExpr> do <expr> or do <statment>;
if <condExpr> do <expr> or <condExpr> do <statment>;
```

### `switch`

`switch`
`switch!`

```cpp
// implicit comparing against 'true'
switch {
  a  do bark();
  b  do meow();
  c  do woof();
  or do cry();
};

// implicit comparing against 'false'
switch! {
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


# Control Flow

This document specifies the syntax and execution semantics for conditional branching (`if` / `or`), multi-branch matching (`switch` / `switch!`), and iteration constructs (`loop` / `loop!`) in Poo.

---

## 1. Branching (`if` and `or`)

Conditional branching consists of an initial `if` clause followed by zero or more `or` clauses.

* **`if <condition>`**: Evaluates `<condition>`. If truthy, the associated block or statement executes.
* **`or <condition>`**: Evaluates `<condition>` if preceding branches were falsy (equivalent to `else if`).
* **`or`**: Executes if all preceding conditions were falsy (equivalent to `else`).

### 1.1 Block Syntax

A block branch is enclosed in curly braces (`{ ... }`) and terminated with a semicolon.

```poo
if condition {
  // Executed if condition is truthy
} or secondary_condition {
  // Executed if condition is falsy and secondary_condition is truthy
} or {
  // Executed if all preceding conditions are falsy
};
```

### 1.2 Statement Syntax (`do`)

For single-statement branches, the `do` keyword replaces block braces:

```poo
// Single branch
if condition do statement;

// Binary branch
if condition do statement_a or do statement_b;

// Chained branch
if condition_a do statement_a or condition_b do statement_b or do default_statement;
```

---

## 2. Multi-Condition Matching (`switch` and `switch!`)

The `switch` family evaluates a sequence of expressions until a match condition is satisfied.

### 2.1 Standard Switch (`switch`)

Evaluates case expressions sequentially and executes the statement associated with the first expression that yields `true`.

```poo
switch {
  condition_a do action_a();
  condition_b do action_b();
  or          do default_action();
};
```

### 2.2 Inverted Switch (`switch!`)

Evaluates case expressions sequentially and executes the statement associated with the first expression that yields `false` or `nil`.

```poo
switch! {
  condition_a do action_a();
  condition_b do action_b();
  or          do default_action();
};
```

---

## 3. Iteration (`loop` and `loop!`)

Iteration is declared using `loop` or `loop!`, supporting collection traversal and condition-based execution.

### 3.1 Collection Traversal (`as`)

Iterates over elements of a collection binding each item via the `as` keyword.

```poo
val animals = ["bird", "cat", "dog"];

// Block syntax
loop (animals as @animal) {
  helloPet(@animal);
};

// Inline statement syntax
loop animals as animal do helloPet(animal);
```

### 3.2 Conditional Loops

Condition evaluation occurs at the start of each cycle:

* **`loop (<condition>)`**: Executes the body while `<condition>` evaluates to `true`.
* **`loop! (<condition>)`**: Executes the body while `<condition>` evaluates to `false` or `nil` (terminates when `<condition>` becomes `true`).

```poo
// Loop while condition is true
loop (count < 5) {
  count += 1;
};

// Loop until condition is true
loop! (ready) {
  ready = check_status();
};
```

---

## 4. Execution Control

* **`break`**: Immediately terminates the innermost loop execution.
* **`continue`**: Terminates the current iteration cycle and evaluates the loop condition for the next cycle.
* **`skip`**: Skips the remainder of the current element processing or iteration step.
