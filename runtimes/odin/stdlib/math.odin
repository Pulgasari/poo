// runtimes/odin/stdlib/math.odin
package runtime

import "core:math"

// Globale Mathematik-Funktionen
math_sin :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 1 { return from_float(0.0) }
    val, ok := args[0].(Value)
    if !ok || val.type != .Float { return from_float(0.0) }
    return from_float(math.sin(val.data.(f64)))
}

math_cos :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 1 { return from_float(0.0) }
    val, ok := args[0].(Value)
    if !ok || val.type != .Float { return from_float(0.0) }
    return from_float(math.cos(val.data.(f64)))
}

get_math_functions :: proc(allocator: mem.Allocator) -> map[string]Value {
    methods := make(map[string]Value, allocator)
    methods["sin"] = Value{type = .Function, data = {function = make_function(allocator, nil, nil, math_sin)}}
    methods["cos"] = Value{type = .Function, data = {function = make_function(allocator, nil, nil, math_cos)}}
    return methods
}
