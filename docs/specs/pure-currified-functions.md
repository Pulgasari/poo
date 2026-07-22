# Specification: `fn^` (Pure Curried Functions)

## 1. Overview
The `fn^` keyword introduces a **curried** function definition. Unlike standard `fn` (which accepts a tuple/list of arguments), `fn^` treats every parameter as a distinct, sequential argument. 
Furthermore, `fn^` functions enforce **purity**—they guarantee deterministic outputs with no side effects—and **forbid named arguments** to maintain strict positional semantics.

## 2. Syntax Definition

```
// Grammar
fn^ <identifier> = <param_list> => <expression>;

// <param_list> consists of one or more identifiers, separated by optional commas.
// Parentheses around the parameter list are FORBIDDEN (syntax error).
```

**Valid Examples:**
```text
fn^ add = a, b => a + b;
fn^ greet = first, last => "Hello " + first + " " + last;
fn^ map = fn, list => ...; // Pure higher-order function
```

**Invalid Examples (Syntax Errors):**
```text
fn^ add = (a, b) => a + b;   // ERROR: Parentheses not allowed.
fn^ bad = (a: 5) => a + 1;   // ERROR: Named arguments not allowed.
```

## 3. Core Semantics

### 3.1. Automatic Currying
- Every `fn^` function is automatically curried.
- `fn^ add = a, b => a + b` is internally represented as `a -> (b -> a + b)`.
- The commas are purely syntactic sugar for readability; the parser must treat them as sequential lambda abstractions.

### 3.2. Partial Application
- Calling an `fn^` function with **fewer** arguments than its parameter count returns a new function expecting the remaining arguments.
- Example:
  ```text
  let increment = add 1;   // increment is now a function: b => 1 + b
  increment 5;             // Evaluates to 6.
  ```
- Calling with the **exact** number of arguments executes the function body immediately.

### 3.3. Purity Constraint (Compiler Enforced)
- The compiler **must** statically analyze the body of any `fn^` function.
- The following operations are **strictly forbidden** inside the body:
  - Input/Output operations (e.g., `print`, `readFile`).
  - Impure built-ins (e.g., `Math.random()`, `Date.now()`).
  - Mutation of external state (global variables, mutable object properties).
  - Calling any standard `fn` (non-pure) function.
  - Throwing/catching exceptions (if not handled via a specific pure error monad).
- *Allowed*: Arithmetic, logical comparisons, pure built-ins, recursion, and calls to other `fn^` functions.
- **Violation**: Throws a semantic compiler error: *"Impure expression used inside pure function '<name>'"*.

### 3.4. Named Arguments Prohibition
- Named (lexical) arguments (e.g., `(b: 5, a: 2)`) are **strictly forbidden** for `fn^` calls.
- *Rationale*: Currying relies on strict positional ordering. Allowing named arguments would break partial application, as the compiler cannot determine which slot a partially applied argument fills without complex and ambiguous mapping.

## 4. Compiler Optimizations
Because `fn^` functions are guaranteed pure, the compiler is authorized to perform aggressive optimizations:

- **Constant Folding**: If all arguments are known at compile time (e.g., `add 2 3`), the compiler may evaluate this immediately to `5`.
- **Common Subexpression Elimination (CSE)**: Repeated identical calls with identical arguments can be cached.
- **Loop Fusion**: Multiple `|>` map operations using pure functions can be merged into a single pass.
- **Safe Parallelization**: Pure functions can be safely executed in parallel threads without race conditions.

## 5. Interaction with Existing Operators

`fn^` functions integrate seamlessly with the language's built-in pipeline operators:

| Operator | Name | Behavior with `fn^` |
| :--- | :--- | :--- |
| `|>` | Map | Works normally. Since `fn^` is pure, the compiler can fuse adjacent `|>` maps. |
| `|?` / `|!` | Filter | Works normally. Pure predicates guarantee consistent filtering. |
| `|*` | Fold / Reduce | Works normally. Pure accumulators allow strictness optimizations. |
| `>>` | Sequence | Works normally. However, calling a `fn^` in a `>>` chain is only useful if its result is passed to a subsequent impure function, as `fn^` has no internal side effects. |

## 6. Error Handling & Edge Cases

- **Arity Mismatch**: Unlike standard `fn`, calling `fn^` with *too many* arguments at once is allowed via chaining, as it resolves to nested function calls. However, passing arguments via a tuple `(a, b)` is a syntax error.
- **Recursion**: Pure recursion is allowed, provided the base case is reached. The compiler does not enforce totality (unless a future extension is added).
- **Closures**: `fn^` functions capture variables from the outer scope lexically (closures). However, the outer variables must also be immutable constants or pure values to maintain the purity guarantee of the inner function.

## 7. Summary of Key Differences (`fn` vs. `fn^`)

| Feature | Standard `fn` (Imperative) | `fn^` (Haskell-Style) |
| :--- | :--- | :--- |
| Argument Passing | Tuple / List (fixed arity) | Curried chain (single args) |
| Partial Application | ❌ | ✅ |
| Named Arguments | ✅ Allowed | ❌ Forbidden |
| Side Effects | ✅ Allowed | ❌ Enforced Purity |
| Compiler Optimizations | Standard | Aggressive (Folding, Fusion) |

---

*End of Specification.*
