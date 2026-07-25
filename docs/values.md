# Values & Immutability

All value bindings are declared using the `val` keyword. 

A compile-time constant could be defined by the `#`-prefix.

---

## Quick Syntax Overview

```poo
val num = 123;

// Constant (Evaluated at Compile-Time)
val #compilerState = "broken"; //compile-time constant
```

---

## Value Declaration (`val`)

The `val` keyword is the sole declaration keyword in Poo.

By **default**, a standard `val` declaration creates a binding that can be reassigned or mutated later in code execution.

```poo
val cat = "miau";
cat += "!!!"; // allowed: modifies or reassigns value
cat =  "purr"; // allowed: reassigns binding
```

---

## Compile-Time Constants (`val #name`)

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

#MAX_CONNECTIONS = 200; // Compile-time Error: Cannot reassign compile-time constant
```

---

## Reassignment & Sealing Error Behavior

| Declaration / State | Reassignment | Mutation | Sealing |
| :--- | :--- | :--- | :--- |
| **Value** | ✅ Allowed | ✅ Allowed | ✅ Allowed (locks variable) |
| **Constant** | ❌ Error | ❌ Error | ❌ Error |

Attempting to assign or mutate a sealed variable or compile-time constant throws a **Compiler/Runtime Error**:

```text
Error: Cannot reassign or mutate sealed value 'cat'.
```

---

## Scope & Lifecycle

Bindings declared with `val` are **lexically scoped** to the block (`{ ... }`) in which they are defined.

### Block Scoping

```poo
{
  val temp = "inside block";
  print(temp); // "inside block"
}
print(temp); // Error: 'temp' is not defined in this scope
```

### Variable Shadowing

Declaring a new `val` with the same name inside an inner block shadows the outer binding without modifying it:

```poo
val score = 10;

{
  val score = 99; // Shadows outer 'score' within this block
  print(score);   // 99
}

print(score); // 10 (Outer score remains unchanged)
```

---

## Contextual & Temporary Bindings *(Tentative / Future Spec)*

> [!NOTE]
> Poo supports contextual or temporary value bindings (such as pattern match bindings, loop iterators, or inline callback identifiers) that are declared implicitly without the explicit `val` keyword.
> These will be fully specified alongside Control Flow and Pattern Matching documentation.

```poo
// Example concept (To be detailed in Control Flow spec):
for (item in list) { // 'item' is a contextual binding
  print(item);
}
```
