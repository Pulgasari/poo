# poo

Coding sucks.

![Logo](./logo.jpg)


---

## Definitions

The `prop` keyword introduces a declaration statement to define a **property** in the current scope.

***Note:** This keyword has also the aliases `pp` and `property`.*

### define a constant

A **constant** is 
- a named value.
- not mutable.
- created on compile time.
- globally accessable.

```scala
val #konstante = 'Moin!';
```

### define a variable

A **variable** is 
- a named value.
- written in `pascalCase` or `snake_case`.
- mutable (until you seal it).

```scala
val myVariable   = true;
val my_other_var = 3;
```

### define a object

An **object**
- is a block of code with a name.
- is written in `pascalCase` or 'snake_case`.
- is mutable (until you seal it).
- may contain `def` and `do` statements.

```scala
obj person = {
  val name = 'Udo';
  val age  = 69; 
};
```

### define a function

A **function** 
- is an object.
- has bindable values when calling.
- 

```scala
fn helloFoxbuddy = (name, age) => {
  val pet  = 'fox';

  do print "$name is $age years old and has a $pet.";
};

do helloFoxbuddy('Anne', '23');
// "Anne is 23 years old and has a fox."
```



```
first class function
higher order function
pattern matching
list comprehension
generator expression
```












