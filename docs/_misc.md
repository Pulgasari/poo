#

---

## Types & Structures

​The `#` symbol acts as the universal indicator for structural rigidity.

```javascript
val dynamicList = [1, "garbage", true]; // Standard dynamic array
val strictList = #[1, 2, 3];            // Homogeneous strict list (frozen type)
val userTuple = #("Udo", 60);           // Strict heterogenous tuple (fixed size/types)
```

* Lists (#[...]): Elements must share the exact same type. Under the hood, this compiles to contiguous, unboxed memory blocks for cache friendliness.
* ​Tuples (#(...)): Fixed size and fixed type per index. Values can be updated as long as they respect the declared type at that position.
* ​Ranges: Defined using ... (inclusive) or ..< (exclusive). Useful for loops, slicing, and pattern matching.

```javascript
// Inclusive Loop
loop 1...5 as @i {
  print("Line @i: This is garbage.");
}

// Exclusive Slicing
val list = ['a', 'b', 'c', 'd'];
val slice = list[1..<3]; // ['b', 'c']
```

-–-
