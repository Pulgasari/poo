# poo

Coding sucks.

![Logo](./logo.jpg)

## Table of Contents

- [Let's code! (Introduction)](#lets-code)
- [Declarations](#declarations)
- [Control Flow](#control-flow)
  - [Conditional](#cond)
  - [Switch](#switch)
  - [Loops](#loops)
- [Keywords](#keywords)
- [Operators](#operators)
- [Types](#types)
  - [Data-Types](#data-types)
  - [Context-Aware Return Types](#context-aware-return-types)
  - [Typecasting](#typecasting)
- [Philosophy](#philosophy)

---

## Let's code!

A lot of people do like **JavaScript** ...

```javascript
// javascript original
const whileLoop = (cond) => decorateCombinator (p => {
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
fn whileLoop = cond => decorateCombinator (
  p => #[] |> (p ~= fn && !cond.many)
    ? loop (cond p) do @ += p.next()
    : loop          do @ += runWithBacktrack(p, cond) or break
);
```

## Data-Types

[`Array`](#array) 
[`Blob`](#blob) 
[`Bool`](#bool) [`Char`](#char) [`Color`](#color) [`Date`](#date) [`Enum`](#enum) [`Generator`](#generator) [`List`](#list) [`Map`](#map) [`Number`](#number) [`Queue`](#queue) [`Pattern`](#pattern) [`Record`](#record) [`RegExp`](#regexp) [`Set`](#set) [`Stack`](#stack) [`String`](#string) [`Store`](#store) [`Symbol`](#symbol) [`Tree`](#tree) [`Tuple`](#tuple) [`Type`](#type)

### Array

#### Static Methods

#### Instance Methods

### Color

### String

#### Methods

Name | ...
-----|----
[`toCamelCase`](#toCamelCase)       | 
[`toConstantCase`](#toConstantCase) | 
[`toKebabCase`](#toKebabCase)       | 
[`toPascalCase`](#toPascalCase)     |
[`toSnakeCase`](#toSnakeCase)       | 
[`toTitleCase`](#toTitleCase)       | 

##### `toCamelCase`

##### `toKebabCase`

##### `toPascalCase`

##### `toTitleCase`

## Keywords

#### Expression Level

[`as`](#as)
[`new`](#new)

#### Statement Level

[`and`](#and) 
[`break`](#break)
[`catch`](#catch)
[`continue`](#continue)
[`do`](#do)
[`if`](#if) 
[`kill`](#kill) 
[`loop`](#loop) 
[`or`](#or) 
[`return`](#return) 
[`switch`](#switch) 

#### Declaration Statement Introducers

[`fn`](#fn)
[`obj`](#obj)
[`pkg`](#pkg)
[`use`](#use)
[`val`](#val)

## Operators

#### Assignment

[`=`](#) [`=#`](#) [`+=`](#) [`-=`](#) [`*=`](#)

#### Comparison

[`~=`](#) [`==`](#) [`===`](#) [`!=`](#) [`!==`](#) [`<`](#) [`>`](#) [`>=`](#) [`=<`](#) [`||`](#) [`&&`](#)

#### Pipe

[`|>`](#) [`!>`](#) [`?!>`](#) [`??>`](#)

## Packages

[`audio`](#audio) [`db`](#db) [`fs`](#fs) [`img`](#img) [`io`](#io) [`md`](#md) [`url`](#url) [`video`](#video)

