// runtimes/odin/stdlib/core.odin
package runtime

import "core:fmt"
import "core:mem"

// ---------- GLOBALE FUNKTIONEN ----------
// print: Gibt einen Wert aus (simple Implementierung)
  
global_print :: proc (env: ^Object, args: []Value) -> Value {
  for arg in args {
    switch arg.type {
      case .String : fmt.print(arg.data.(string))
      case .Int    : fmt.print(arg.data.(i64))
      case .Float  : fmt.print(arg.data.(f64))
      case .Bool   : fmt.print(arg.data.(bool))
      case .Nil    : fmt.print("nil")
      case .Array  : fmt.print("[Array]")
      case .Object : fmt.print("{Object}")
      case         : fmt.print("?")
    }
  }
  
  fmt.println()
  return from_nil()
}

// len: Gibt die Länge von Strings, Arrays, Lists oder Tuples zurück
global_len :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 1 {
        return from_int(-1)
    }
    v := args[0]
    switch v.type {
    case .String:
        return from_int(i64(len(v.data.(string))))
    case .Array:
        arr := v.data.(^Array)
        return from_int(i64(len(arr.items)))
    case .List:
        lst := v.data.(^List)
        return from_int(i64(len(lst.items)))
    case .Tuple:
        tup := v.data.(^Tuple)
        return from_int(i64(len(tup.items)))
    case:
        return from_int(-1)
    }
}

// type_name: Gibt den Typnamen als String zurück
global_type :: proc (env: ^Object, args: []Value) -> Value {
  if len (args) < 1 { return from_string("unknown") }
  
  type_str := ""
    
  switch args[0].type {
    case .Nil:      type_str = "Nil"
    case .Bool:     type_str = "Bool"
    case .Int:      type_str = "Int"
    case .Float:    type_str = "Float"
    case .String:   type_str = "String"
    case .Object:   type_str = "Object"
    case .Array:    type_str = "Array"
    case .List:     type_str = "List"
    case .Tuple:    type_str = "Tuple"
    case .Function: type_str = "Function"
    case .Class:    type_str = "Class"
  }
  
  return from_string(type_str)
}

// ---------- EXPORT: Globale Funktionen ----------
// Werden in das globale Umgebungsobjekt eingetragen

get_global_functions :: proc (allocator: mem.Allocator) -> map[string]Value {
  globals := make (map[string]Value, allocator)

  globals["print"] = Value { type = .Function, data = {function = make_function(allocator, nil, nil, global_print )}}
  globals["len"]   = Value { type = .Function, data = {function = make_function(allocator, nil, nil, global_len )}}
  globals["type"]  = Value { type = .Function, data = {function = make_function(allocator, nil, nil, global_type )}}  

  return globals
}
