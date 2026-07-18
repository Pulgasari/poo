// runtimes/odin/stdlib/io.odin
package runtime

import "core:mem"
import "core:slice"
import "core:strings"
import "core:fmt"

// ---------- IO-TYPEN ----------

IoReader :: struct {
    // Die tatsächliche Lese-Funktion (wird von konkreten Implementierungen gesetzt)
    read_proc: proc(self: ^Object, buf: []u8) -> (int, bool),
}

IoWriter :: struct {
    // Die tatsächliche Schreib-Funktion
    write_proc: proc(self: ^Object, data: []u8) -> bool,
}

IoBuffer :: struct {
    data: []u8,           // Interner Puffer
    pos:  int,            // Aktuelle Lese-Position
    allocator: mem.Allocator,
}

// ---------- BUFFER-IMPLEMENTIERUNG (In-Memory-Stream) ----------

// Erstellt einen neuen Buffer (für In-Memory-IO)
make_buffer :: proc(allocator: mem.Allocator, initial_data: []u8 = nil) -> ^IoBuffer {
    buf := new(IoBuffer, allocator)
    buf.allocator = allocator
    buf.pos = 0
    if initial_data != nil {
        buf.data = make([]u8, len(initial_data))
        copy(buf.data, initial_data)
    } else {
        buf.data = make([]u8, 0)
    }
    return buf
}

// Buffer: Lese-Funktion (implementiert IoReader)
buffer_read :: proc(self: ^Object, buf: []u8) -> (int, bool) {
    // Hole den Buffer aus dem Objekt
    raw, ok := self.properties["__buffer"]
    if !ok { return 0, false }
    if raw.type != .Object { return 0, false }
    buffer_obj := raw.data.(^Object)
    
    // Hole die eigentlichen Daten
    data_raw, ok2 := buffer_obj.properties["data"]
    if !ok2 { return 0, false }
    if data_raw.type != .Object { return 0, false } // Wir speichern []u8 als Objekt
    
    // Hier müssten wir die []u8 aus dem Value holen
    // Da wir []u8 nicht direkt in Value speichern können, nutzen wir einen Trick:
    // Wir speichern einen Zeiger auf den Buffer im Object
    buf_ptr_raw, ok3 := buffer_obj.properties["__ptr"]
    if !ok3 { return 0, false }
    if buf_ptr_raw.type != .Int { return 0, false }
    
    // Zeiger wiederherstellen (Achtung: Unsicher, aber für Demo okay)
    ptr := uintptr(buf_ptr_raw.data.(i64))
    buffer := cast(^IoBuffer)ptr
    
    // Leseoperation
    if buffer.pos >= len(buffer.data) {
        return 0, true // EOF
    }
    
    n := min(len(buf), len(buffer.data) - buffer.pos)
    copy(buf[:n], buffer.data[buffer.pos:buffer.pos+n])
    buffer.pos += n
    return n, true
}

// Buffer: Schreib-Funktion (implementiert IoWriter)
buffer_write :: proc(self: ^Object, data: []u8) -> bool {
    // Hole den Buffer (gleicher Mechanismus wie oben)
    buf_ptr_raw, ok := self.properties["__ptr"]
    if !ok { return false }
    if buf_ptr_raw.type != .Int { return false }
    ptr := uintptr(buf_ptr_raw.data.(i64))
    buffer := cast(^IoBuffer)ptr
    
    // Schreiben (append)
    new_data := slice.append(buffer.data, data, buffer.allocator)
    buffer.data = new_data
    return true
}

// Buffer: Aktuelle Größe
buffer_size :: proc(self: ^Object) -> int {
    buf_ptr_raw, ok := self.properties["__ptr"]
    if !ok { return 0 }
    if buf_ptr_raw.type != .Int { return 0 }
    ptr := uintptr(buf_ptr_raw.data.(i64))
    buffer := cast(^IoBuffer)ptr
    return len(buffer.data)
}

// Buffer: In String umwandeln
buffer_to_string :: proc(self: ^Object) -> string {
    buf_ptr_raw, ok := self.properties["__ptr"]
    if !ok { return "" }
    if buf_ptr_raw.type != .Int { return "" }
    ptr := uintptr(buf_ptr_raw.data.(i64))
    buffer := cast(^IoBuffer)ptr
    return string(buffer.data)
}

// ---------- IO-OBJEKTE FÜR DEINE SPRACHE ----------

// Erstellt ein Reader-Objekt aus einer Lese-Funktion
make_reader :: proc(allocator: mem.Allocator, read_proc: proc(self: ^Object, buf: []u8) -> (int, bool), prototype: ^Object) -> ^Object {
    obj := make_object(allocator, prototype)
    obj.properties["read"] = Value{
        type = .Function,
        data = {function = make_function(allocator, nil, nil, 
            proc(env: ^Object, args: []Value) -> Value {
                if len(args) < 1 { return from_nil() }
                // args[0] ist das Reader-Objekt selbst
                // args[1] ist der Buffer (als Object mit []u8)
                // ... hier müsste die eigentliche Logik hin
                // Für dieses Beispiel vereinfacht:
                return from_nil()
            }
        )}
    }
    return obj
}

// Erstellt ein Writer-Objekt aus einer Schreib-Funktion
make_writer :: proc(allocator: mem.Allocator, write_proc: proc(self: ^Object, data: []u8) -> bool, prototype: ^Object) -> ^Object {
    obj := make_object(allocator, prototype)
    obj.properties["write"] = Value{
        type = .Function,
        data = {function = make_function(allocator, nil, nil,
            proc(env: ^Object, args: []Value) -> Value {
                if len(args) < 2 { return from_bool(false) }
                // args[0] = Writer-Objekt
                // args[1] = String oder Buffer
                // ... vereinfacht:
                return from_bool(false)
            }
        )}
    }
    return obj
}

// ---------- GLOBALE IO-FUNKTIONEN (für deine Sprache) ----------

// Erstellt einen neuen leeren Buffer
io_new_buffer :: proc(env: ^Object, args: []Value) -> Value {
    allocator := env.allocator // Achtung: env ist das globale Objekt
    buf := make_buffer(allocator)
    
    // Buffer als Objekt in deiner Sprache verpacken
    obj := make_object(allocator, env)
    obj.properties["__ptr"] = from_int(i64(uintptr(buf)))
    obj.properties["data"] = Value{type = .Object, data = {object = obj}} // Self-Referenz
    
    // Methoden hinzufügen (als Funktionen im Prototyp)
    // In der Praxis würdest du diese in den Buffer-Prototypen einhängen
    obj.properties["read"] = Value{
        type = .Function,
        data = {function = make_function(allocator, nil, nil, 
            proc(env2: ^Object, args: []Value) -> Value {
                // args[0] = Buffer-Objekt
                // args[1] = Anzahl Bytes (optional)
                // ... Implementierung weggelassen für Kürze
                return from_nil()
            }
        )}
    }
    obj.properties["write"] = Value{
        type = .Function,
        data = {function = make_function(allocator, nil, nil,
            proc(env2: ^Object, args: []Value) -> Value {
                // args[0] = Buffer-Objekt
                // args[1] = String oder Bytes
                if len(args) < 2 { return from_bool(false) }
                // Konvertiere args[1] zu []u8 (falls String)
                // ... Implementierung weggelassen
                return from_bool(true)
            }
        )}
    }
    obj.properties["toString"] = Value{
        type = .Function,
        data = {function = make_function(allocator, nil, nil,
            proc(env2: ^Object, args: []Value) -> Value {
                if len(args) < 1 { return from_string("") }
                // args[0] ist Buffer-Objekt
                raw_ptr, ok := args[0].data.(^Object).properties["__ptr"]
                if !ok { return from_string("") }
                if raw_ptr.type != .Int { return from_string("") }
                ptr := uintptr(raw_ptr.data.(i64))
                buf := cast(^IoBuffer)ptr
                return from_string(string(buf.data))
            }
        )}
    }
    
    return Value{type = .Object, data = {object = obj}}
}

// ---------- IO-METHODEN-REGISTRIERUNG ----------
get_io_methods :: proc(allocator: mem.Allocator) -> map[string]Value {
    methods := make(map[string]Value, allocator)
    methods["newBuffer"] = Value{
        type = .Function,
        data = {function = make_function(allocator, nil, nil, io_new_buffer)}
    }
    return methods
}
