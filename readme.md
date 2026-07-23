# poo

Coding sucks.

![Logo](logo.jpg)

---

## Basics & Overviews

[`Functions`](/docs/functions.md)
[`Keywords`](/docs/keywords.md)
[`Literals`](/docs/literals.md)
[`Objects`](/docs/objects.md)
[`Operators`](/docs/operators.md)
[`Types`](/docs/types.md)
[`Values`](/docs/values.md)

## [Data-Types](/docs/types.md)

[`Array`](/docs/types/Array.md)
[`Blob`](/docs/types/Blob.md) 
[`Bool`](/docs/types/Bool.md)
[`Char`](/docs/types/Char.md)
[`Color`](/docs/types/Color.md)
[`Date`](/docs/types/Date.md)
[`Enum`](/docs/types/Enum.md)
[`Generator`](/docs/types/Generator.md)
[`List`](/docs/types/List.md)
[`Map`](/docs/types/Map.md)
[`Number`](/docs/types/Number.md) 
[`Pattern`](/docs/types/Pattern.md)
[`Pool`](/docs/types/Pool.md)
[`Queue`](/docs/types/Queue.md)
[`Record`](/docs/types/Record.md)
[`RegExp`](/docs/types/RegExp.md)
[`Stack`](/docs/types/Stack.md)
[`String`](/docs/types/String.md)
[`Store`](/docs/types/Store.md)
[`Symbol`](/docs/types/Symbol.md)
[`Tree`](/docs/types/Tree.md) 
[`Tuple`](/docs/types/Tuple.md) 
[`Union`](/docs/types/Union.md)

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
[`img`](/docs/pkg/img.md)
[`io`](/docs/pkg/io.md)
[`md`](/docs/pkg/md.md)
[`url`](/docs/pkg/url.md)
[`video`](/docs/pkg/video.md)

## Concepts

- [Control Flow](/docs/specs/control-flow.md)
- [Do](/docs/specs/do.md)
- [Declarations](/docs/specs/declarations.md)
- [Destructuring](/docs/specs/destructuring.md)
- [Pattern Matching](/docs/specs/pattern-matching.md)
- [Typecasting](/docs/specs/typecasting.md)


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

```poo
fn whileLoop = cond => decorate (
  p => #[] >>> (p ~= fn && !cond.many)
    ? loop (cond p) do @ += p.next()
    : loop          do @ += runWithBacktrack(p, cond) or break
);
```
