# Pattern Matching

Pattern Matching allows testing values against structural patterns, types, ranges, and regular expressions using the soft match operator (`~=`) and deep match operator (`~==` / `~~=`).

---

## Quick Syntax Overview

```poo
// 1. Soft / Structural Match (~=)
val is_valid = response ~= #{ status: 200 };        // Checks if response contains status: 200

// 2. Deep / Strict Match (~== or ~~=)
val is_exact = data ~~= #[1, 2, 3];                 // Checks for exact type, shape, and value equality

// 3. Switch-Case Integration
switch (input) {
  case #/[0-9]+/: print("Numeric String");
  case Int:       print("Pure Integer");
  case 1..10:     print("In Range 1-10");
  default:        print("Other");
}
```

---

## 1. Pattern Match Operators

| Operator | Name | Behavior |
| :--- | :--- | :--- |
| `~=` | **Soft / Structural Match** | Returns `true` if value satisfies or contains the pattern, type, range, or sub-structure. |
| `~==` / `~~=` | **Deep / Strict Match** | Returns `true` only if value strictly matches exact shape, types, element count, and values recursively. |

---

## 2. Soft / Structural Matching (`~=`)

The `~=` operator tests whether a target value satisfies a pattern, type, or partial structure without requiring exact full-object equality.

### 2.1 Type & Primitive Matching
```poo
42 ~= Int;                      // true
"hello" ~= String;              // true
```

### 2.2 Regular Expression & Range Matching
```poo
"user_123" ~= #/user_\d+/;      // true
15 ~= 1..100;                   // true (Range inclusion)
```

### 2.3 Partial Structural Matching
Matches if the target contains at least the specified keys or elements (extra fields are ignored):

```poo
val res = #{ status: 200, payload: "data", latency: 45 };

res ~= #{ status: 200 };        // true (Ignores payload and latency)
```

---

## 3. Deep / Strict Matching (`~==` / `~~=`)

The `~==` (or `~~=`) operator requires an **exact match** in structure, element count, types, and nested values.

```poo
val list = [1, 2, 3];

list ~= [1, 2];                 // true  (Soft match: structural match)
list ~~= [1, 2];                // false (Deep match: element count differs)
list ~~= [1, 2, 3];             // true  (Exact deep match)
```

---

## 4. Switch & Case Integration

Pattern matching is built directly into `switch` statements. Each `case` implicitly evaluates using the soft match operator (`~=`) against the switch subject.

```poo
val input = "2026-07-23";

switch (input) {
  case #/^\d{4}-\d{2}-\d{2}$/: {
    print("Matches YYYY-MM-DD Date format");
  }
  case String: {
    print("Generic string");
  }
  default: {
    print("Unknown format");
  }
}
```

### Advanced Case Matching with Guards
Cases can combine structural patterns with additional boolean conditions (`if` guards):

```poo
switch (user) {
  case #{ role: "admin", active: true }: {
    print("Active Administrator");
  }
  case #{ age } if (age >= 18): {
    print("Adult User");
  }
  default: {
    print("Guest or Minor");
  }
}
```
