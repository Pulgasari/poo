# poo

Coding sucks.

![Logo](./logo.jpg)

- [Let's code! (Introduction)](#lets-code)
- [Declarations](#declarations)
- [Control Flow](#control-flow)
  - [Conditional](#)
  - [Loops](#loops)

## Let's code!

Write a block of code.

```php
{
  prop name = 'Udo';
  prop pet  = 'cat';

  print("@name has a @pet.");
}
```

Now give it a name and call it.

```rust
{
  prop block = {
    prop name = 'Udo';
    prop pet  = 'cat';

    print("@name has a @pet.");
  }

  block(); // "Udo has a cat."
}
```

Congratulations! You now know how to create [objects](#objects), [functions](#functions), [classes](#classes) and [traits](#traits). ^-^

There is more to learn but one needs to start somewhere.

## Definitions

The `prop` keyword introduces a declaration statement to define a **property** in the current scope.

***Note:** This keyword has also the aliases `pp` and `property`.*

### define a constant

A **constant** is 
- a named value.
- written in `SCREAMING_SNAKE_CASE`.
- not mutable.

```c
prop MY_LITTLE_CONSTANT = 'Moin!';
```

### define a variable

A **variable** is 
- a named value.
- written in `pascalCase` or 'snake_case`.
- mutable (until you seal it).

```c
prop myVariable   = true;
prop my_other_var = 3;
```

### define a object

An **object**
- is a block of code with a name.
- is written in `pascalCase` or 'snake_case`.
- is mutable (until you seal it).
- may contain `def` and `do` statements.

```javascript
pp person = {
  pp name = 'Udo';
  pp age  = 69; 
};
```

### define a function

A **function** 
- is an object.
- has bindable values when calling.
- 

```c
pp helloFoxbuddy = (name, age) => {
  pp pet  = 'fox';

  do print("@name is @age years old and has a @pet.");
};

do helloFoxbuddy('Anne', '23');
// "Anne is 23 years old and has a fox."
```

### the `new` keyword

```c
prop person = {
  prop name = 'Udo';
  prop age  = 60;
  prop printInfo = () => {
    return print('@name is @age years old.');
  };
};

// creates copy/clone/instance of 'person' in its current state
prop inst1 = new person;

person.age = 61;
print(person.age); // 61


prop inst2 = new person;
person.age = 62;

print(person.age); // 62
print(inst1.age);  // 60
print(inst2.age);  // 61
```

```c
def person = (name, age) => {
  def name = 'Udo';
  def age  = 60;
  def printInfo = () => {
    return print('@name is @age years old.');
  };
};

def p1 = new person;
def p2 = new person (age: 61);
def p3 = new person (age: 20, name: 'Stella');

p1.printInfo(); //    Udo is 60 years old.
p2.printInfo(); //    Udo is 61 years old.
p3.printInfo(); // Stella is 20 years old.
```

### the `use` keyword

By the `use` keyword one could apply the value of a ding when defining another one.

```python
prop Person = () => {
  prop name;
  prop age;
  prop country;
  prop whoAmI = () => {
    print('@name is from @country and @age years old.');
  };
};

prop Male = () => {
  use Person;
  prop sex = 'male';
}

prop Female = () => {
  use Person;
  prop sex = 'female';
}

// change the value of a prop on init
prop Hans = new Male   (name: 'Hans', age: 44);
prop Gabi = new Female (name: 'Gabi', age: 30);

// change the value of a prop when calling
Hans(country: 'Austria').whoAmI();
```

### define a class

A **class** is a functional object returning an instance of itself.

```c

```

## Executions





## Control Flow

### `if` | `or`

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
if <condExpr> or <condExpr> do <statment>;
if <condExpr> or <condExpr> or do <statment>;
```

### Loops: `for` | `while` | `until'

#### `for` loop

```c
def animals  = ['bird', 'cat', 'dog' ];
def helloPet = (pet) => print('I love my @pet.');

do for animals as animal {
  helloPet(animal);
}

// oneliner
do for animals as animal helloPet(animal);
```

#### `while` loop

```c
def zustand = 'true';

do while (zustand) {
  
  zustand = false;
}
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

***Note:** If you will ever use this in practice you are a nerd.*

```c
do for $i while ($i < 10) {
    body();
} until (cond);
```



## Types

```c
def myString = "Moin!";
def myNumber = 123;
def myArray  = ['bird', 'cat', 'dog', 'fish'];
def myFn     = (sth) => sth ?> print(sth);
```

## Operators

#### Math / Calculation

Operator | Name    | ...
---------|---------|----
`+`      |         |
`-`      |         |
`?>`     |         |

####

Operator | Name    | ...
---------|---------|----
`??`     | Nullish |
`|>`     | Pipe    |
`?>`     |         | 

