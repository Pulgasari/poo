# Values & Immutability

All value bindings are declared using the `val` keyword. 

Mutability and immutability are controlled explicitly via the compile-time constant prefix (`#`) and the runtime sealing operator (`#=`).

---

## Quick Syntax Overview

```poo
// 1. Standard Value Binding (Mutable / Reassignable)
val num = 123;
num = 456; // allowed

// 2. Sealed Value Binding (Immutable at Declaration)
val str #= "moin!";
str = "hello"; // error: Value is sealed

// 3. Compile-Time Constant (Evaluated at Compile-Time)
val #compilerState = "broken"; // Compile-time constant
```

---

## 1. Value Declaration (`val`)

The `val` keyword is the sole declaration keyword in Poo. By default, a standard `val` declaration creates a binding that can be reassigned or mutated later in code execution.

```poo
val cat = "miau";
cat += "!!!";                  // Allowed: Modifies or reassigns value
cat = "purr";                  // Allowed: Reassigns binding
```

---

## 2. Compile-Time Constants (`val #name`)

Adding the `#` prefix directly to the identifier name converts the declaration into a **compile-time constant**.

### Syntax
```poo
val #<identifier> = <expression>;
```

### Semantics & Rules
* **Compile-Time Evaluation:** The expression assigned to a compile-time constant must be determinable during compilation.
* **Strict Immutability:** Once compiled, the constant cannot be reassigned or mutated anywhere in the program.
* **Global / Module Safety:** Ideal for configuration values, fixed math values, or environment flags.

```poo
val #MAX_CONNECTIONS = 100;
val #API_KEY = "poo_live_123456";

// #MAX_CONNECTIONS = 200;     // Compile-time Error: Cannot reassign compile-time constant
```

---

## 3. Sealing Values (`#=`)

The `#=` operator seals (freezes) a value recursively (deep-freeze) so that it becomes permanently immutable.

### 3.1 Sealing on Declaration
A value can be sealed directly when it is declared by substituting `=` with `#=`:

```poo
val exbf #= "you can't change me!";
// exbf = "new value";         // Error: Variable is sealed
```

When used on complex data structures (such as `Array`, `Map`, or `Tree`), `#=` performs a **deep-freeze**, making all nested properties, elements, and sub-structures recursively immutable as well.

### 3.2 Late Sealing (Sealing at Runtime)
The `#=` operator can also be used as an assignment operator at any later point in execution. This allows a value to be built dynamically and then locked down permanently.

```poo
val cat = "miau";
cat += "!!!";                  // Allowed: 'cat' is currently "miau!!!"

cat #= "wuff";                 // Assigned "wuff" and sealed permanently
cat = "meow";                  // Error: Variable is sealed
```

---

## 4. Reassignment & Sealing Error Behavior

| Declaration / State | Reassignment (`=`) | Mutation (`+=`, `.add()`, etc.) | Sealing (`#=`) |
| :--- | :--- | :--- | :--- |
| **Standard Value (`val x = ...`)** | ✅ Allowed | ✅ Allowed | ✅ Allowed (locks variable) |
| **Sealed Value (`val x #= ...`)** | ❌ Error | ❌ Error | ❌ Error (already sealed) |
| **Constant (`val #x = ...`)** | ❌ Error | ❌ Error | ❌ Error |

Attempting to assign or mutate a sealed variable or compile-time constant throws a **Compiler/Runtime Error**:
```text
Error: Cannot reassign or mutate sealed value 'cat'.
```

---

## 5. Scope & Lifecycle

Bindings declared with `val` are **lexically scoped** to the block (`{ ... }`) in which they are defined.

### 5.1 Block Scoping
```poo
{
  val temp = "inside block";
  print(temp);                 // "inside block"
}
// print(temp);                // Error: 'temp' is not defined in this scope
```

### 5.2 Variable Shadowing
Declaring a new `val` with the same name inside an inner block shadows the outer binding without modifying it:

```poo
val score = 10;

{
  val score = 99;              // Shadows outer 'score' within this block
  print(score);                // 99
}

print(score);                  // 10 (Outer score remains unchanged)
```

---

## 6. Contextual & Temporary Bindings *(Tentative / Future Spec)*

> [!NOTE]
> Poo supports contextual or temporary value bindings (such as pattern match bindings, loop iterators, or inline callback identifiers) that are declared implicitly without the explicit `val` keyword.
> These will be fully specified alongside Control Flow and Pattern Matching documentation.

```poo
// Example concept (To be detailed in Control Flow spec):
for (item in list) {           // 'item' is a contextual binding
  print(item);
}
```
