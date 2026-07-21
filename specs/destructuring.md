# Destructuring

Destructuring extracts values from arrays, lists, tuples, maps, and records into local variables. Destructuring patterns define the **target shape**, independent of the source data structure.

```poo
// Positional extraction from a Tuple into a Record
val #{ age: 2, name: 1 } = #("Austria", "Hans", 60);
// name = "Hans", age = 60
```

---

## 1. Sequential Destructuring

Unpacks values by index position (`0`, `1`, `2`, ...). Can be applied to Arrays, Lists, Tuples, or any indexed collection.

```poo
val [a, b] = [10, 20];             // a = 10, b = 20
val #(first, second) = #[100, 200]; // Unpacks List into Tuple variables
```

### Skipping & Ignoring Elements (`_` and `..`)
Use `_` to skip a single position, or `..` to silently ignore all remaining elements without binding them:

```poo
val #(first, _, third) = #(1, 2, 3); // skips index 1
val #(head, ..) = #(1, 2, 3, 4, 5);  // head = 1, ignores remaining elements
```

### Rest Operator (`...`)
Gathers remaining elements into a sub-collection variable:

```poo
val [head, ...tail] = [1, 2, 3, 4]; // head = 1, tail = [2, 3, 4]
```

---

## 2. Key-Based & Index-Mapped Destructuring

Unpacks values by key name or explicit index position.

### Matching by Key Name
Extracts values matching key names from Records or Maps:

```poo
val #{ name, age } = #{ name: "Alice", age: 30 };
val { host, port } = { "host": "localhost", port: 8080 };
```

### Variable Aliasing (`as`)
Assigns extracted keys/indices to custom local variable names using `as`:

```poo
val { "host" as domain, port as port_number } = config;
// domain = "localhost", port_number = 8080
```

### Cross-Type Index Mapping (`:` and `as`)
Extracts elements from sequential collections (Tuples, Lists, Arrays) using index positions. Both `variable: index` and `index as variable` are valid syntax:

```poo
// Map variable names to index positions via `:` or `as`
val #{ country: 0, name: 1, age: 2 } = #("Austria", "Hans", 60);
val #{ 0 as country, 1 as name, 2 as age } = #("Austria", "Hans", 60);
// country = "Austria", name = "Hans", age = 60
```

### Default Values (`=`)
Provides fallback values if an extracted key or index evaluates to `nil`:

```poo
val { host, port = 8080 } = { "host": "localhost" };
// port defaults to 8080
```

### Map/Record Rest (`...` and `..`)
Gather remaining unextracted key-value pairs with `...` or silently ignore them with `..`:

```poo
val { host, ...options } = { "host": "localhost", "timeout": 5000, "debug": true };
// options = { "timeout": 5000, "debug": true }

val { host, .. } = { "host": "localhost", "timeout": 5000, "debug": true };
// ignores remaining keys
```

---

## 3. Nested & Deep Path Destructuring

Deep values can be extracted either via full structural mirroring or concisely using **Dot Path Notation**.

### Option A: Dot Path Notation (Concise)
Extracts deeply nested fields directly without mirror nesting, using `as` for aliasing:

```poo
val #{ payload.user.name } = response;
// Extracts response.payload.user.name into local variable `name`

// With variable aliasing using `as`:
val #{ payload.user.name as user_name, payload.user.id as user_id } = response;
// user_name = "Bob", user_id = 42
```

### Option B: Structural Mirroring
Mirrors the nested structure visually:

```poo
val response = #{
  status: 200,
  payload: #{
    user: #{ id: 42, name: "Bob" }
  }
};

val #{ payload: #{ user: #{ name } } } = response;
// name = "Bob"
```

---

## 4. Function Parameter Destructuring *(Tentative / TBD)*

> [!NOTE]
> Function parameter destructuring is currently under design evaluation.

Extracts arguments directly within function signatures:

```poo
// Destructuring a Tuple parameter
val print_point = #(x, y) => {
  print(x, y);
};

// Destructuring a Record parameter with defaults
val create_user = #{ name, role = "guest" } => {
  print(name, role);
};

print_point(#(10, 20));
create_user(#{ name: "Alice" });
```
