# Declarations

Declaration Statements are introduced by the keywords: `val` `fn` `obj`

---

[Value Declaration](#value-declaration)
[Function Declaration](#function-declaration)
[Object Declaration](#object-declaration)

---

## Value Declaration

```go
val num   = 123; // value (mutable)
val str  #= "moin!"; // sealed value (immutable)
val #fix  = "constant!"; // real constant (compile-time)
```

<details>
<summary><b>Declare a Constant</b></summary>

​The `#` prefix on the name (*identifier*) of a value defines a ***compile-time constant***.

```javascript
val #compilerState = "broken"; // compile-time constant
```
</details>

<details>
<summary><b>Seal a Value</b></summary>

​The `#=` operator makes it possible to seal (*freeze*) a value on runtime so it becomes immutable recursively (*deep-freeze*).

```javascript
val exbf #= 'you can't change me!';
```

This operator could also be used to make an value immutable at any later point.

```javascript
val cat = 'miau';
cat += '!!!'; // allowed

cat #= 'wuff'; // assigned and sealed permanently
cat  = 'meow';  // compile-time error: variable is sealed.
```
</details>

## Function Declaration

```poo
// functions with no arguments
fn doSomething = () => print "moin!";
fn doSomething      => print "moin!";

// with arguments
fn sum = (a, b) => print (a * b);
fn sum =  a, b  => print (a * b); // parens are optional
fn sum =  a  b  => print (a * b); // commas are optional

// classic notation
fn oldieStyle (a, b) { ... }
```

```poo
// no arguments = enforced parens
callSth ();

// exactly 1 argument = optional parens
callSth ("i hate compilers");
callSth "i hate compilers";

// multiple arguments
callSth (100, "moin!"); // positional call
callSth (100 "moin!"); // positional call = optional commas
callSth (b: "moin!", a: 100); // lexical call ("named arguments")
```

## Object Declaration

The `obj` keyword is used to declare a **new type of object**.

```js
obj Cat = {
  val color  = "black";
  val mood  #= "grumpy"; // grumpy forever >.<

  fn makeNoise = () => print "meow!";
};
```

> [!CAUTION]
> For declaration of *key-value-pairs* see the [Data-Types](#data-types) section.
