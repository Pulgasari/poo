// runtimes/odin/stdlib/io.odin
package runtime

import "core:mem"
import "core:slice"
import "core:strings"

// ---------- BUFFER (IN-MEMORY STREAM) ----------
IoBuffer :: struct {
    data: []u8,
    pos: int,
    allocator: mem.Allocator,
}

// ---------- IO-FUNKTIONEN ----------

io_new_buffer :: proc(env: ^Object, args: []Value) -> Value {
    allocator := env.allocator
    buf := new(IoBuffer, allocator)
    buf.allocator = allocator
    buf.pos = 0

    if len(args) >= 1 {
        if str, ok := unwrap_string(args[0]); ok {
            buf.data = make([]u8, len(str), allocator)
            copy(buf.data, transmute([]u8)str)
        } else {
            buf.data = make([]u8, 0, allocator)
        }
    } else {
        buf.data = make([]u8, 0, allocator)
    }

    // Buffer als Objekt verpacken
    obj := make_object(allocator, env)
    obj.properties["__ptr"] = from_int(i64(uintptr(buf)))
    obj.properties["length"] = from_int(i64(len(buf.data)))
    obj.properties["position"] = from_int(i64(buf.pos))

    // Methoden direkt im Objekt (oder im Prototyp)
    obj.properties["read"] = Value{
        type = .Function,
        data = {function = make_function(allocator, nil, nil, io_buffer_read)}
    }
    obj.properties["write"] = Value{
        type = .Function,
        data = {function = make_function(allocator, nil, nil, io_buffer_write)}
    }
    obj.properties["toString"] = Value{
        type = .Function,
        data = {function = make_function(allocator, nil, nil, io_buffer_to_string)}
    }
    obj.properties["reset"] = Value{
        type = .Function,
        data = {function = make_function(allocator, nil, nil, io_buffer_reset)}
    }

    return Value{type = .Object, data = {object = obj}}
}

io_buffer_read :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 1 {
        return runtime_error("buffer.read: zu wenige Argumente", "io")
    }
    obj, ok := args[0].(Value)
    if !ok { return type_error("Object", args[0].type, "buffer.read") }
    buffer_obj, ok2 := unwrap_object(obj)
    if !ok2 { return type_error("Buffer-Object", obj.type, "buffer.read") }

    ptr_raw, ok3 := buffer_obj.properties["__ptr"]
    if !ok3 { return runtime_error("buffer.read: ungültiges Buffer-Objekt", "io") }
    if ptr_raw.type != .Int { return type_error("int", ptr_raw.type, "buffer.read") }
    ptr := uintptr(ptr_raw.data.(i64))
    buf := cast(^IoBuffer)ptr

    size := 1024
    if len(args) >= 2 {
        if s, ok := unwrap_int(args[1]); ok {
            size = int(s)
        }
    }

    if buf.pos >= len(buf.data) {
        return wrap_string("", env.allocator) // EOF
    }

    n := min(size, len(buf.data) - buf.pos)
    result := make([]u8, n, env.allocator)
    copy(result, buf.data[buf.pos:buf.pos+n])
    buf.pos += n

    // Position im Objekt aktualisieren
    buffer_obj.properties["position"] = from_int(i64(buf.pos))

    return wrap_string(string(result), env.allocator)
}

io_buffer_write :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 2 {
        return runtime_error("buffer.write: zu wenige Argumente", "io")
    }
    obj, ok := args[0].(Value)
    if !ok { return type_error("Object", args[0].type, "buffer.write") }
    buffer_obj, ok2 := unwrap_object(obj)
    if !ok2 { return type_error("Buffer-Object", obj.type, "buffer.write") }

    data_str, ok3 := unwrap_string(args[1])
    if !ok3 { return type_error("string", args[1].type, "buffer.write") }

    ptr_raw, ok4 := buffer_obj.properties["__ptr"]
    if !ok4 { return runtime_error("buffer.write: ungültiges Buffer-Objekt", "io") }
    if ptr_raw.type != .Int { return type_error("int", ptr_raw.type, "buffer.write") }
    ptr := uintptr(ptr_raw.data.(i64))
    buf := cast(^IoBuffer)ptr

    // Schreiben (append)
    data := transmute([]u8)data_str
    new_data := slice.append(buf.data, data, buf.allocator)
    buf.data = new_data
    buf.pos = len(buf.data) // Am Ende positionieren

    // Länge im Objekt aktualisieren
    buffer_obj.properties["length"] = from_int(i64(len(buf.data)))
    buffer_obj.properties["position"] = from_int(i64(buf.pos))

    return wrap_int(i64(len(data)))
}

io_buffer_to_string :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 1 {
        return runtime_error("buffer.toString: zu wenige Argumente", "io")
    }
    obj, ok := args[0].(Value)
    if !ok { return type_error("Object", args[0].type, "buffer.toString") }
    buffer_obj, ok2 := unwrap_object(obj)
    if !ok2 { return type_error("Buffer-Object", obj.type, "buffer.toString") }

    ptr_raw, ok3 := buffer_obj.properties["__ptr"]
    if !ok3 { return runtime_error("buffer.toString: ungültiges Buffer-Objekt", "io") }
    if ptr_raw.type != .Int { return type_error("int", ptr_raw.type, "buffer.toString") }
    ptr := uintptr(ptr_raw.data.(i64))
    buf := cast(^IoBuffer)ptr

    return wrap_string(string(buf.data), env.allocator)
}

io_buffer_reset :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 1 {
        return runtime_error("buffer.reset: zu wenige Argumente", "io")
    }
    obj, ok := args[0].(Value)
    if !ok { return type_error("Object", args[0].type, "buffer.reset") }
    buffer_obj, ok2 := unwrap_object(obj)
    if !ok2 { return type_error("Buffer-Object", obj.type, "buffer.reset") }

    ptr_raw, ok3 := buffer_obj.properties["__ptr"]
    if !ok3 { return runtime_error("buffer.reset: ungültiges Buffer-Objekt", "io") }
    if ptr_raw.type != .Int { return type_error("int", ptr_raw.type, "buffer.reset") }
    ptr := uintptr(ptr_raw.data.(i64))
    buf := cast(^IoBuffer)ptr

    buf.pos = 0
    buffer_obj.properties["position"] = from_int(0)
    return wrap_bool(true)
}

// ---------- IO-METHODEN-REGISTRIERUNG ----------
get_io_methods :: proc(allocator: mem.Allocator) -> map[string]Value {
    methods := make(map[string]Value, allocator)
    register_methods(methods, []Method_Def{
        {"newBuffer", io_new_buffer},
    }, allocator)
    return methods
}
