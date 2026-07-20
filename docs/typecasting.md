# Typecasting

​Explicit typecasting is handled via the `as` and `as?` operators.

## Context-Aware Return Types

...

## ​Symmetrical Cast Failbacks

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

## Implicit Optimization (Zero-Allocation Casts)

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
