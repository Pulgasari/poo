// runtimes/odin/_internal_helpers_for_methods.odin
package runtime

import "core:mem"
import "core:fmt"
import "core:strings"
import "core:slice"

Method_Def :: struct {
    name: string,
    proc: proc(env: ^Object, args: []Value) -> Value,
}

// Erstellt ein Function-Value mit optionalem Prototyp
make_method :: proc(
    p         :  proc(env: ^Object, args: []Value) -> Value,
    allocator := context.allocator,
    prototype :  ^Object = nil,
) -> Value {
    return Value{
        type = .Function,
        data = { function = make_function (allocator, prototype, nil, p) },
    }
}

// Setzt eine einzelne Methode direkt auf ein Objekt (nutzt standardmäßig context.allocator)
set_method :: proc (
  obj       : ^Object,
  name      : string, 
  proc_ptr  : proc (env: ^Object, args: []Value) -> Value, 
  allocator := context.allocator
) {
    if obj.properties == nil {
        obj.properties = make(map[string]Value, allocator)
    }
    obj.properties[name] = make_method(proc_ptr, allocator)
}

// Registriert eine Liste von Methoden in einer bestehenden Map (per Pointer)
register_methods :: proc(
    methods   :  ^map[string]Value, 
    defs      :  []Method_Def, 
    prototype :  ^Object = nil, 
    allocator := context.allocator
) {
    if methods^ == nil {
        methods^ = make (map[string]Value, allocator)
    }
    
    for def in defs {
        methods[def.name] = make_method(def.proc, allocator, prototype)
    }
}
