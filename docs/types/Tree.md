# Tree

A `Tree` represents a hierarchical node structure containing a value and optional child tree nodes.

```poo
val root = Tree("root_node");
root.add(Tree("child_1"));
```

---

## Methods

[`add`](#add) ·
[`bytesize`](#bytesize) ·
[`clear`](#clear) ·
[`depth`](#depth) ·
[`has`](#has) ·
[`is_empty`](#is_empty) ·
[`is_leaf`](#is_leaf) ·
[`loop`](#loop) ·
[`morph`](#morph) ·
[`size`](#size) ·
[`to_morph`](#to_morph) ·
[`value`](#value)

> [!NOTE]
> All methods could be used with both snake-case and pascal-case.

---

## add

Adds a child tree node to the current tree node in-place.

```poo
val parent = Tree("parent");
parent.add(Tree("child"));
```

## bytesize

Returns the memory size occupied by the node and all its descendants in bytes.

```poo
val t = Tree("node");
t.bytesize();
```

## clear

Removes all child nodes from the current node in-place.

```poo
val parent = Tree("parent");
parent.clear();
```

## depth

Calculates and returns the maximum depth/height of the tree hierarchy.

```poo
val root = Tree("root");
root.depth(); // 1
```

## has

Searches the tree hierarchy to check if a specific value exists.

```poo
val root = Tree("a");
root.has("a"); // true
```

## is_empty

Returns `true` if the root node has no value and no children.

```poo
val t = Tree();
t.is_empty();
```

## is_leaf

Returns `true` if the node has zero children.

```poo
val leaf = Tree("leaf");
leaf.is_leaf(); // true
```

## loop

Iterates through the node and its sub-nodes (depth-first traversal).

```poo
val root = Tree("root");
root.loop(node => print(node.value()));
```

## morph

Transforms values of all nodes in the tree hierarchy in-place.

```poo
val root = Tree(10);
root.morph(val => val * 2);
```

## size

Returns the total count of nodes within the tree hierarchy (including root).

```poo
val root = Tree("root");
root.size(); // 1
```

## to_morph

Returns a new tree with transformed values for all nodes (pure/copy).

```poo
val root = Tree(10);
val doubled = root.to_morph(val => val * 2);
```

## value

Retrieves or sets the value stored in the current node.

```poo
val node = Tree("data");
val val = node.value(); // "data"
node.value("new_data"); // In-place update
```
