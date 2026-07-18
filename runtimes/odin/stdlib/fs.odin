package runtime

import "core:os"
import "core:io"

// Öffnet eine Datei und gibt ein File-Objekt zurück
fs_open :: proc(env: ^Object, args: []Value) -> Value {
    path, ok := unwrap_string(args[0])
    if !ok { return from_nil() }
    
    // Odins OS-API aufrufen
    file, err := os.open(path, os.O_RDWR)
    if err != nil { return from_nil() }
    
    // Ein "File"-Objekt in deiner Sprache erstellen
    file_obj := make_object(env, file_prototype)
    file_obj.properties["_handle"] = from_int(i64(uintptr(file))) // Handle speichern
    file_obj.properties["read"] = Value{type = .Function, data = {function = make_function(..., file_read)}}
    file_obj.properties["write"] = Value{type = .Function, data = {function = make_function(..., file_write)}}
    return Value{type = .Object, data = {object = file_obj}}
}
