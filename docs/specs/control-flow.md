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
