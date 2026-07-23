// runtimes/odin/types/array.odin
package types

import "core:slice"

Array :: struct {
  prototype : ^Object,
  items     : [dynamic]Value, // Sieht die Value-Union aus value.odin!
}

make_array :: proc(allocator := context.allocator) -> ^Array {
  arr := new(Array, allocator)
  arr.items = make([dynamic]Value, allocator)
  return arr
}

// === 1. native array primitive operations ===

array_get :: proc (arr: ^Array, idx: int) -> Value {
  if (idx < 0 || idx >= len(arr.items)) { return Value(Null{}) }
  return arr.items[idx]
}

array_pop :: proc (arr: ^Array) -> Value {
  if (len(arr.items) == 0) { return Value(Null{}) }
  val := pop(&arr.items)
  return val
}

array_push :: proc (arr: ^Array, val: Value) {
  append(&arr.items, val)
}

array_set :: proc (arr: ^Array, idx: int, val: Value) -> bool {
  if (idx < 0 || idx >= len(arr.items)) { return false }
  arr.items[idx] = val
  return true
}
