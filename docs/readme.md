# poo

Coding sucks.

![Logo](logo.jpg)

---

## Basics & Overviews

[`Functions`](functions.md)
[`Keywords`](keywords.md)
[`Literals`](literals.md)
[`Operators`](operators.md)
[`Types`](types.md)
[`Values`](values.md)

## [Data-Types](types.md)

[`Array`](types/Array.md)
[`Blob`](types/Blob.md) 
[`Bool`](types/Bool.md)
[`Char`](types/Char.md)
[`Color`](types/Color.md)
[`Date`](types/Date.md)
[`Enum`](types/Enum.md)
[`Generator`](types/Generator.md)
[`List`](types/List.md)
[`Map`](types/Map.md)
[`Number`](types/Number.md) 
[`Pattern`](types/Pattern.md)
[`Pool`](types/Pool.md)
[`Queue`](types/Queue.md)
[`Record`](types/Record.md)
[`RegExp`](types/RegExp.md)
[`Stack`](types/Stack.md)
[`String`](types/String.md)
[`Store`](types/Store.md)
[`Symbol`](types/Symbol.md)
[`Tree`](types/Tree.md) 
[`Tuple`](types/Tuple.md) 
[`Union`](types/Union.md)

## Keywords & Operators

[`as`](#as)
[`and`](#and) 
[`break`](#break)
[`catch`](#catch)
[`continue`](#continue)
[`cpy`](#cpy)
[`do`](#do)
[`fail`](#fail)
[`fn`](#fn)
[`if`](#if) 
[`kill`](#kill) 
[`loop`](#loop)
[`new`](#new)
[`obj`](#obj)
[`or`](#or)
[`pkg`](#pkg)
[`ref`](#ref)
[`return`](#return)
[`skip`](#skip)
[`static`](#static)
[`switch`](#switch)
[`use`](#use)
[`val`](#val)
[`yield`](#yield)

[`=`](#)
[`=#`](#)
[`+=`](#)
[`-=`](#)
[`*=`](#)
[`+`](#)
[`-`](#)
[`*`](#)
[`/`](#)
[`%`](#)
[`~=`](#)
[`~==`](#)
[`==`](#)
[`===`](#)
[`!=`](#)
[`!==`](#)
[`>`](#)
[`<`](#)
[`>=`](#)
[`=<`](#) 
[`<=>`](#)
[`||`](#)
[`&&`](#)
[`>>`](#)
[`>>>`](#)
[`!>>`](#)
[`?!>`](#)
[`??>`](#)
[`|?`](#filter-operator)
[`|>`](#map-operator)
[`| `](#reduce-operator)
[`|.`](#pluck-operator)

## Packages

[`audio`](/docs/pkg/.md)
[`db`](/docs/pkg/db.md)
[`fs`](/docs/pkg/fs.md)
[`img`](/docs/pkg/.md)
[`io`](/docs/pkg/io.md)
[`md`](/docs/pkg/md.md)
[`url`](/docs/pkg/url.md)
[`video`](/docs/pkg/video.md)

## Concepts

- [Control Flow](specs/control-flow.md)
- [Do](specs/do.md)
- [Declarations](specs/declarations.md)
- [Destructuring](specs/destructuring.md)
- [Pattern Matching](specs/pattern-matching.md)
- [Typecasting](specs/typecasting.md)

---

## Let's code!

A lot of people do like **JavaScript** ...

```javascript
// javascript original
const whileLoop = cond => decorate (p => {
  const results = [];
  if (typeof p === 'function' && !cond.many) {
    while (cond(p)) results.push(p.next());
    return results;
  }
  while (true) {
    const result = runWithBacktrack(p, cond);
    if (result === null) break;
    results.push(result);
  }
  return results;
});
```

... but some people do like **poo**. ^-^

```php
fn whileLoop = cond => decorate (
  p => #[] >>> (p ~= fn && !cond.many)
    ? loop (cond p) do @ += p.next()
    : loop          do @ += runWithBacktrack(p, cond) or break
);
```




### the `new` keyword

<details>
<summary><b>Example Code</b></summary>

```scala
obj person = {
  val name = 'Udo';
  val age  = 60;
  
  fn printInfo = () => print "$name is $age years old.";
};

// creates copy/clone/instance of 'person' in its current state
obj inst1 = new person;

person.age = 61;
print(person.age); // 61


obj inst2 = new person;
person.age = 62;

print person.age; // 62
print inst1.age;  // 60
print inst2.age;  // 61
```

```javascript
obj person = (name, age) => {
  val name = 'Udo';
  val age  = 60;
  
  fn printInfo = () => print('@name is @age years old.');
};

obj p1 = new person;
obj p2 = new person (age: 61);
obj p3 = new person (age: 20, name: 'Stella');

p1.printInfo(); //    Udo is 60 years old.
p2.printInfo(); //    Udo is 61 years old.
p3.printInfo(); // Stella is 20 years old.
```
</details>

### the `use` keyword

By the `use` keyword one could apply the value of a ding when defining another one.

<details>
<summary><b>Example Code</b></summary>

```python
obj Person = () => {
  val name;
  val age;
  val country;

  fn whoAmI = () => print "$name is from $country and $age years old.";
};

obj Male = () => {
  use Person;
  val sex = 'male';
}

obj Female = () => {
  use Person;
  val sex = 'female';
}

// change the value of a prop on init
obj Hans = new Male   (name: 'Hans', age: 44);
obj Gabi = new Female (name: 'Gabi', age: 30);

// change the value of a prop when calling
Hans(country: 'Austria').whoAmI();
```
</details>





---

## Philosophy

The language sees itself as an *weird bastard like JavaScript* but with more time to intensionally become like that.

It's compiling to ODIN.

But it could compile to Vanilla JavaScript live in the Browser as well.




