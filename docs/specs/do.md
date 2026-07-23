## `do`

The `do` keyword is most likely the awkward operator of the language because it's kinda overloaded (not really in the end but...) because it's related to lots of behaviour.

On an statement introduced by `do` the keywords `and`, `of`, `on` and `or` became also avaible which could only be used in this context (except `or`).

```poo
val sth = [];
loop (animals as animal) do sth += animal or break;
loop (animals as animal) do sth += animal or break and doSthElse();

val sth = [] >>> @ += animals |> to_lowercase;

val sth = animals.to_lowercase();
```

- ohne klammern kommt `or`vor `and` bzw ist höherstufiger



## as a line guard

...

## as an expression guard

...

## as an human-readable code

Let's assume we have sth. like this:

```poo
obj Hurtable #= {
  val hp = 100;
  val hurt = (n) => hp -= n ?? 1;
};

obj Nerd = {
  use hurtable;
};

val nerd = new Nerd;
```

Now we could obviously do sth. like this:

```poo
nerd.hurt(5); print(nerd.hp); //
nerd.hurt 5; print nerd.hp; // alternative
```

However the `do` keyword enables `on` (to reference a function call on an object) and `of` (to reference a property of an object) in combination with alternative syntax this results in the ability have this semantics:

```poo
do hurt (5) on nerd and print hp of nerd;
do hurt  5  on nerd and print hp of nerd;
```
