# Functions

Functions are first-class citizens in Poo. Poo provides three specialized function types depending on your needs: Standard (`fn`), Generator (`fn*`), and Pure Curried (`fn^`).

---

## Quick Syntax Overview

```poo
// 1. Standard Functions (fn)
fn greet      => print("moin!");           // No args, single expression
fn sum = a, b => a + b;                    // Positional args (optional parens/commas)
fn calc(a, b) { return a + b; }            // Classic block syntax

// Standard Function Calling
call();                                    // 0 args: Parens enforced
call "hello";                              // 1 arg: Parens optional
call(100, "hello");                        // Multi args (optional commas: call(100 "hello"))
call(b: "hello", a: 100);                  // Named/lexical arguments

// 2. Generator Functions (fn*)
fn* range = (max) => { yield 1; };         // Lazy iterator function

// Generator Calling
val gen = range(5);
gen.next();                                // Advance generator

// 3. Pure Curried Functions (fn^)
fn^ add = a, b => a + b;                   // Pure, auto-curried, no outer parens

// Pure Curried Calling
val addFive = add 5;                       // Partial application
addFive 10;                                // Evaluates to 15
```

---

## `fn` – Standard Functions

Standard functions are general-purpose functions that support side effects, flexible argument syntax, block bodies, and named arguments.

### 1.1 Declarations

#### Arrow Functions
When declaring functions with arrow expressions, parentheses around parameter lists are optional. For zero-argument functions, empty parentheses `()` can also be omitted entirely.

```poo
// Zero arguments
fn doSomething = () => print("moin!");
fn doSomething      => print("moin!");

// With arguments (parentheses and commas are optional)
fn sum = (a, b) => print(a * b);
fn sum =  a, b  => print(a * b);
fn sum =  a  b  => print(a * b);
```

#### Classic Block Notation
For multi-statement logic or imperative blocks, use traditional function signature syntax with curly braces:

```poo
fn oldieStyle(a, b) {
  val result = a * b;
  print(result);
  return result;
}
```

---

### 1.2 Function Calling in Detail

Invocation syntax for standard functions scales from ultrashort single-argument calls to explicit lexical calls.

#### Zero Arguments (Parens Enforced)
Calling a function with no arguments **requires** explicit parentheses to distinguish execution from referencing the function object.

```poo
callSth(); // Executes callSth
```

#### Single Argument (Optional Parens)
When passing exactly one argument, parentheses are optional:

```poo
callSth("i hate compilers"); // Standard call
callSth "i hate compilers";   // Omitted parentheses
```

#### Multiple Arguments (Positional)
When passing multiple arguments positionally, commas between arguments are optional:

```poo
callSth(100, "moin!"); // Standard positional call
callSth(100 "moin!");  // Positional call with omitted commas
```

#### Named / Lexical Arguments
Arguments can be passed by parameter name using `name: value`. Named argument calls allow passing values in any order:

```poo
callSth(b: "moin!", a: 100); // Lexical call
```

---

## `fn*` – Generator Functions

Generator functions are marked with `fn*` and allow execution to be paused and resumed, producing a stream of values lazily using `yield`.

### Declarations & `yield`

Generators use the `fn*` keyword and can contain one or more `yield` statements:

```poo
fn* count_up = (limit) => {
  val current = 0;
  while (current < limit) {
    yield current;
    current = current + 1;
  }
};
```

### Generator Calling & Iteration

Calling a generator function does not immediately execute its body. Instead, it returns a **Generator Iterator** object.

```poo
// 1. Instantiation
val counter = count_up(3);

// 2. Manual iteration via .next()
counter.next(); // Yields 0
counter.next(); // Yields 1
counter.next(); // Yields 2

// 3. Loop integration
count_up(5).loop(num => print(num));
```

---

## `fn^` – Pure Curried Functions

The `fn^` keyword declares a **pure, curried function**. Every parameter is treated as a distinct sequential argument step, side effects are strictly forbidden by the compiler, and named arguments are disabled.

### Declarations & Syntax Rules

```poo
// Syntax Grammar
fn^ <identifier> = <param_list> => <expression>;
```

* **Parameter List:** One or more parameter identifiers separated by optional commas.
* **Syntax Constraint:** Parentheses around the parameter list are **strictly forbidden** (produces a syntax error).

```poo
// Valid Pure Curried Declarations
fn^ add = a, b => a + b;
fn^ greet = first, last => "Hello " + first + " " + last;
fn^ map = callback, list => ...;

// Invalid Syntax
fn^ add = (a, b) => a + b;   // ERROR: Parentheses not allowed
fn^ bad = (a: 5) => a + 1;   // ERROR: Default/named params not allowed
```

### Curried Calling & Partial Application

`fn^` functions are automatically curried. Calling an `fn^` function with fewer arguments than declared returns a partially applied function expecting the remaining arguments.

```poo
fn^ multiply = a, b => a * b;

// Partial Application
val double = multiply 2; // Returns a function: b => 2 * b
double 10;               // Evaluates to 20

// Full Immediate Application
multiply 3 4;            // Evaluates to 12
```

> [!NOTE]
> Passing arguments via tuples `(a, b)` or using named arguments `(a: 1)` is forbidden for `fn^` calls to preserve strict positional currying order.

---

### Enforced Purity & Compiler Optimizations

The compiler statically verifies the body of any `fn^` function.

#### Forbidden Operations
* Input/Output calls (e.g. `print()`, file access).
* Impure built-in functions (e.g. `Math.random()`, `Date.now()`).
* Mutation of external state.
* Invoking standard (impure) `fn` functions.

#### Compiler Authorizations
Because purity guarantees zero side effects, the Poo compiler performs:
1. **Constant Folding:** Compile-time pre-evaluation of constant parameters.
2. **Subexpression Elimination:** Caching identical deterministic calls.
3. **Pipeline Fusion:** Merging sequential pipeline passes (`|>`) into a single loop pass.

---

## Function Comparison

| Feature | Standard `fn` | Generator `fn*` | Pure Curried `fn^` |
| :--- | :--- | :--- | :--- |
| **Primary Use Case** | Imperative logic & UI | Lazy sequences & streams | Functional pipelines & math |
| **Argument Style** | Positional or Named | Positional or Named | Curried Chain (Sequential) |
| **Partial Application** | ❌ | ❌ | ✅ Built-in |
| **Named Arguments** | ✅ Allowed | ✅ Allowed | ❌ Forbidden |
| **Side Effects** | ✅ Allowed | ✅ Allowed | ❌ Strictly Forbidden |
| **Optimization Level** | Standard | Standard | Aggressive (Folding, Fusion) |
