# poo

Coding sucks.

## Write a block of code

```php
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

```javascript
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

Would run at least once until post-block-condition becomes `false` if pre-block-condition were `true`.

```c
do for $i while ($i < 10) {
    body();
} until (cond);
```

### `if` | `or`

```c
if <condExpr> {

}

// oneliner
if <condExpr> do <statment>;
```

```c
//
if <condExpr> {...}
or <condExpr> {...}  // like 'else if'
or            {...}; // like `else'

// oneliners
if <condExpr> or <condExpr> do <statment>;
if <condExpr> or <condExpr> or do <statment>;
```

## Types

```c

```
