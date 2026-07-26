// poo/runtime/types/array.js

// poo's Array literal ([a, b, c]) maps directly onto a native JS array -
// no wrapper type needed, unlike Record/Tuple/List, which all need their
// own identity to stay distinguishable from each other and from a plain
// object/array at runtime.

export function makeArray (elements = []) {
  return [...elements];
}
