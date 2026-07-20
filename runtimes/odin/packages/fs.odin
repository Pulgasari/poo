package fs

import "core:os"
import "../../types"

// === native function bindings ===

// reads a file path string and returns POO string payload
native_read_file :: proc (env: ^types.Object, args: []types.Value) -> types.Value {
  if (len(args) < 1) { return types.Value(types.Null{}) }
  
  path, ok := args[0].(string)
  if (!ok) { return types.Value(types.Null{}) }

  data, read_ok := os.read_entire_file(path, context.allocator)
  if (!read_ok) { return types.Value(types.Null{}) }
  
  return types.Value(string(data))
}

// === package bootstrap ===

init_package :: proc (allocator := context.allocator) -> ^types.Object {
  pkg := new(types.Object, allocator)
  pkg.properties = make(map[string]types.Value, allocator)

  // define native routing bindings
  pkg.properties["readFile"] = types.Value(new_native_func(native_read_file, allocator))

  return pkg
}

// === helpers ===

new_native_func :: proc (p: proc(^types.Object, []types.Value) -> types.Value, allocator := context.allocator) -> ^types.Function {
  fn := new(types.Function, allocator)
  fn.proc_ptr = p
  return fn
}
