# poo

Coding sucks.

## Write a block of code

```c
{
  def $name = 'Udo';
  def $pet  = 'cat';

  print("$name has a $pet.");
}
```

## Definitions

The `def` keyword introduces a declaration statement.

### define a constant

```c

```

### define a variable

```c

```

### define a object

An object is a block of code with a name.

```c
def theMostEmptyObjectEver = {

};
```

It can contain `def` and `do` statements.

```c
def person = {
  def name = 'Udo';
  def age  = 69;
  def 
};
```

### define a function

A **function** is an object bindable values when calling.

```c
def helloFoxbuddy = (name, age) {
  def pet  = 'fox';

  do print("@name is @age years old and has a @pet.");
};

do helloFoxbuddy('Anne', '23');
// "Anne is 23 years old and has a fox."
```

### define a class

A **class** is a functional object returning an instance of itself.

```c

```

## Executions



```c
do while (cond) {
    body();
} until (cond);
```

## Keywords

### Loops: `for` | `while` | `until'

#### `for` loop

```c

```

#### `while` loop

```c

```

#### `until` loop

The `until` loop runs at least once and stops if the conditions matches `false`.

```c
do {
  ...
} until <condExpression>;
```

#### `for while` loop

```c

```

#### `for until` loop

```c

```

#### `for while until` loop

```c

```

### `if` | `or`

```c

```

## Types

```c

```
