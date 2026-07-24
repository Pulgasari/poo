# Enum

An `Enum` represents a discrete set of named variants/symbols.

```poo
enum Status {
  Active,
  Inactive,
  Pending
};
```

---

## Methods

[`has`](#has) ·
[`values`](#values)

> [!NOTE]
> All methods could be used with both snake-case and pascal-case.

---

## has

Checks whether a value/symbol is a valid variant of the enum.

```poo
Status.has(Status.Active); // true
Status.has("Unknown");     // false
```

## values

Returns a list/array of all defined enum variants.

```poo
Status.values(); // #[Status.Active, Status.Inactive, Status.Pending]
```
