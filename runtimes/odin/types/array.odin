package types

Array :: struct {
  prototype : ^Object,
  items     : [dynamic]Value, // Sieht die Value-Union aus value.odin!
}

make_array :: proc(allocator := context.allocator) -> ^Array {
  arr := new(Array, allocator)
  arr.items = make([dynamic]Value, allocator)
  return arr
}
