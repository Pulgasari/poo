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

// === 1. allocation & lifecycle ===

array_clear :: proc (arr: ^Array) {
  clear(&arr.items)
}

// === 2. primitive element operations ===

array_get :: proc (arr: ^Array, idx: int) -> Value {
  if (idx < 0 || idx >= len(arr.items)) { return Value(Null{}) }
  return arr.items[idx]
}

array_insert_at :: proc (arr: ^Array, idx: int, val: Value) -> bool {
  if (idx < 0 || idx > len(arr.items)) { return false }
  inject_at(&arr.items, idx, val)
  return true
}

array_len :: proc (arr: ^Array) -> int {
  return len(arr.items)
}

array_pop :: proc (arr: ^Array) -> Value {
  if (len(arr.items) == 0) { return Value(Null{}) }
  return pop(&arr.items)
}

array_push :: proc (arr: ^Array, val: Value) {
  append(&arr.items, val)
}

array_remove_at :: proc (arr: ^Array, idx: int) -> Value {
  if (idx < 0 || idx >= len(arr.items)) { return Value(Null{}) }
  val := arr.items[idx]
  ordered_remove(&arr.items, idx)
  return val
}

array_set :: proc (arr: ^Array, idx: int, val: Value) -> bool {
  if (idx < 0 || idx >= len(arr.items)) { return false }
  arr.items[idx] = val
  return true
}

