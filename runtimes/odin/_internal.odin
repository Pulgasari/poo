/ runtimes/odin/poo.odin
package runtime

import "core:mem"
import "core:fmt"
import "core:strings"
import "core:slice"


// ============================================================
// 1. METHODEN-REGISTRIERUNG (DER BOILERPLATE-KILLER)
// ============================================================

make_method :: proc(
  p: proc(env:^Object, args:[]Value)->Value,
  allocator: mem.Allocator,
  prototype: ^Object = nil,
) -> Value {
  return Value{
    type = .Function,
    data = {function = make_function(allocator, prototype, nil, p)},
  }
}

// Setzt eine einzelne Methode in einem Objekt (für Prototypen)
set_method :: proc(
  obj: ^Object, 
  name: string, 
  proc_ptr: proc(
    env: ^Object, 
    args: []Value
  ) -> Value, allocator: mem.Allocator) {
    obj.properties[name] = Value{
        type = .Function,
        data = {function = make_function(allocator, nil, nil, proc_ptr)}
    }
}

// Wie oben, aber mit Allocator aus dem Kontext
set_method_ctx :: proc(obj: ^Object, name: string, proc_ptr: proc(env: ^Object, args: []Value) -> Value) {
  allocator := context.allocator
  set_method (obj, name, proc_ptr, allocator);
}

Method_Def :: struct {
    name: string,
    proc: proc(env: ^Object, args: []Value) -> Value,
}

// Registriert eine Liste von Methoden in einer Map
register_methods :: proc(methods: map[string]Value, defs: []Method_Def, allocator: mem.Allocator) {
    for def in defs {
        methods[def.name] = Value{
            type = .Function,
            data = {function = make_function(allocator, nil, nil, def.proc)}
        }
    }
}

// Wie oben, aber mit einem zusätzlichen Prototyp für die Function-Objekte
register_methods_with_prototype :: proc(
    methods   : map[string]Value, 
    defs      : []Method_Def, 
    prototype : ^Object,
    allocator : mem.Allocator,
) {
    for def in defs {
        methods[def.name] = Value{
            type = .Function,
            data = {function = make_function(allocator, prototype, nil, def.proc)}
        }
    }
}
