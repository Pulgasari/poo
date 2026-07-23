# poo

Coding sucks.

![Logo](docs/logo.svg)

---

## Basics & Overviews

[`Functions`](functions.md)
[`Keywords`](keywords.md)
[`Literals`](literals.md)
[`Objects`](objects.md)
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

---

## Philosophy

The language sees itself as an *weird bastard like JavaScript* but with more time to intensionally become like that.

It's compiling to ODIN.

But it could compile to Vanilla JavaScript live in the Browser as well.




