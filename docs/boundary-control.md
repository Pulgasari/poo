# Boundary Control (The Three-Tier Scope Model)

When defining objects, outer scopes are closed off by default. You must explicitly bridge dependencies across object boundaries using one of three keywords:

## Overview

Keyword | Dependency Type | Prefix in Code | Write Behavior
--------|-----------------|----------------|---------------
`use`   | Static Snapshot | `variable`     | Mutates only the local copy inside the object.
`ref`   | Dynamic View    | `@variable`    | Live-read from outside. Writing creates a local override (Copy-on-Write).
`pnt`   | Direct Pointer  | `&variable`    | Live-read and direct write-through to the external variable.

## `use`

The `use` keyword introduces a statement to declare an object or value to be absorbed in its current state (*static snapshot*).

<details>
<summary><b>Example Code</b></summary>

```javascript
val mood = 'grumpy'; 

obj nerd = {
  use mood;
  val printMood = () => print("The nerd is $mood.");
};

nerd.printMood();
```

```javascript
obj hurtable #= {
  val hp = 100;
  val hurt = (n) => hp -= n ?? 1;
};

obj nerd = {
  use hurtable;
};

do nerd.hurt(5) and print nerd.hp;
do hurt (5) on nerd and print hp of nerd;
```
</details>

## `cpy`

The `cpy` keyword introduces a statement to ... (*dynamic view*).

The name will be prefixed with an `@`-symbol.

Assigning a new value to does not change the origin's value.

<details>
<summary><b>Example Code</b></summary>

```javascript
val fishsticks = 'yummy';

obj nerd = {
  ref fishsticks;
  fn doYouLikeFishsticks = (b) => @fishsticks = b ? 'yummy' : 'disgusting';
  fn print = () => print("Fishsticks are $@fishsticks.");
};

nerd.print(); // "Fishsticks are yummy."

nerd.doYouLikeFishsticks(false);

nerd.print(); // "Fishsticks are disgusting."
print(fishsticks); // origin is still 'true'
```
</details>

## `ref`

The `ref` keyword introduces a statement to ... (*direct pointer*).


