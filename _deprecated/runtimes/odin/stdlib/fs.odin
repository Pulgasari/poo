    // runtimes/odin/stdlib/fs.odin
package runtime

import "core:os"
import "core:mem"
import "core:strings"
import "core:time"

// ---------- DATEI-HANDLE ----------
FileHandle :: struct {
    handle: os.Handle,
    path: string,
    mode: os.Open_Mode,
    allocator: mem.Allocator,
}

// ---------- FS-FUNKTIONEN ----------

fs_open :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 2 {
        return runtime_error("fs.open: zu wenige Argumente", "fs")
    }
    path, ok := unwrap_string(args[0])
    if !ok {
        return type_error("string", args[0].type, "fs.open")
    }
    mode_str, ok2 := unwrap_string(args[1])
    if !ok2 {
        return type_error("string", args[1].type, "fs.open")
    }

    mode := os.O_RDONLY
    switch mode_str {
    case "r":   mode = os.O_RDONLY
    case "w":   mode = os.O_WRONLY | os.O_CREATE | os.O_TRUNC
    case "a":   mode = os.O_WRONLY | os.O_CREATE | os.O_APPEND
    case "r+":  mode = os.O_RDWR
    case "w+":  mode = os.O_RDWR | os.O_CREATE | os.O_TRUNC
    case:       return runtime_error("fs.open: unbekannter Modus '"+mode_str+"'", "fs")
    }

    handle, err := os.open(path, mode)
    if err != os.ERROR_NONE {
        return runtime_error("fs.open: konnte Datei nicht öffnen: "+path, "fs")
    }

    file_handle := new(FileHandle, env.allocator)
    file_handle.handle    = handle
    file_handle.path      = strings.clone(path, env.allocator)
    file_handle.mode      = mode
    file_handle.allocator = env.allocator

    file_obj := make_object(env.allocator, env)
    file_obj.properties["__handle"] = from_int(i64(uintptr(file_handle)))
    file_obj.properties["path"] = from_string(file_handle.path)

    return Value{type = .Object, data = {object = file_obj}}
}

fs_read :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 1 {
        return runtime_error("fs.read: zu wenige Argumente", "fs")
    }
    file_obj, ok := args[0].(Value)
    if !ok { return type_error("Object", args[0].type, "fs.read") }
    file, ok2 := unwrap_object(file_obj)
    if !ok2 { return type_error("File-Object", file_obj.type, "fs.read") }

    // Handle aus dem Object holen
    handle_raw, ok3 := file.properties["__handle"]
    if !ok3 { return runtime_error("fs.read: ungültiges File-Objekt", "fs") }
    if handle_raw.type != .Int { return type_error("int", handle_raw.type, "fs.read") }
    ptr := uintptr(handle_raw.data.(i64))
    fh := cast(^FileHandle)ptr

    size := 4096
    if len(args) >= 2 {
        if s, ok := unwrap_int(args[1]); ok {
            size = int(s)
        }
    }

    buf := make([]u8, size, env.allocator)
    defer delete(buf)

    n, err := os.read(fh.handle, buf)
    if err != os.ERROR_NONE {
        return runtime_error("fs.read: lesen fehlgeschlagen", "fs")
    }

    return wrap_string(string(buf[:n]), env.allocator)
}

fs_write :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 2 {
        return runtime_error("fs.write: zu wenige Argumente", "fs")
    }
    file_obj, ok := args[0].(Value)
    if !ok { return type_error("Object", args[0].type, "fs.write") }
    file, ok2 := unwrap_object(file_obj)
    if !ok2 { return type_error("File-Object", file_obj.type, "fs.write") }

    data_str, ok3 := unwrap_string(args[1])
    if !ok3 { return type_error("string", args[1].type, "fs.write") }

    handle_raw, ok4 := file.properties["__handle"]
    if !ok4 { return runtime_error("fs.write: ungültiges File-Objekt", "fs") }
    if handle_raw.type != .Int { return type_error("int", handle_raw.type, "fs.write") }
    ptr := uintptr(handle_raw.data.(i64))
    fh := cast(^FileHandle)ptr

    data := transmute([]u8)data_str
    n, err := os.write(fh.handle, data)
    if err != os.ERROR_NONE {
        return runtime_error("fs.write: schreiben fehlgeschlagen", "fs")
    }

    return wrap_int(i64(n))
}

fs_close :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 1 {
        return runtime_error("fs.close: zu wenige Argumente", "fs")
    }
    file_obj, ok := args[0].(Value)
    if !ok { return type_error("Object", args[0].type, "fs.close") }
    file, ok2 := unwrap_object(file_obj)
    if !ok2 { return type_error("File-Object", file_obj.type, "fs.close") }

    handle_raw, ok3 := file.properties["__handle"]
    if !ok3 { return runtime_error("fs.close: ungültiges File-Objekt", "fs") }
    if handle_raw.type != .Int { return type_error("int", handle_raw.type, "fs.close") }
    ptr := uintptr(handle_raw.data.(i64))
    fh := cast(^FileHandle)ptr

    err := os.close(fh.handle)
    if err != os.ERROR_NONE {
        return runtime_error("fs.close: schließen fehlgeschlagen", "fs")
    }

    // Speicher freigeben
    free(fh, fh.allocator)
    return wrap_bool(true)
}

fs_read_file :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 1 {
        return runtime_error("fs.readFile: zu wenige Argumente", "fs")
    }
    path, ok := unwrap_string(args[0])
    if !ok { return type_error("string", args[0].type, "fs.readFile") }

    data, err := os.read_entire_file(path, env.allocator)
    if err != os.ERROR_NONE {
        return runtime_error("fs.readFile: konnte Datei nicht lesen: "+path, "fs")
    }
    defer delete(data)

    return wrap_string(string(data), env.allocator)
}

fs_write_file :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 2 {
        return runtime_error("fs.writeFile: zu wenige Argumente", "fs")
    }
    path, ok := unwrap_string(args[0])
    if !ok { return type_error("string", args[0].type, "fs.writeFile") }
    content, ok2 := unwrap_string(args[1])
    if !ok2 { return type_error("string", args[1].type, "fs.writeFile") }

    data := transmute([]u8)content
    err := os.write_entire_file(path, data)
    if err != os.ERROR_NONE {
        return runtime_error("fs.writeFile: konnte Datei nicht schreiben: "+path, "fs")
    }
    return wrap_bool(true)
}

fs_mkdir :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 1 {
        return runtime_error("fs.mkdir: zu wenige Argumente", "fs")
    }
    path, ok := unwrap_string(args[0])
    if !ok { return type_error("string", args[0].type, "fs.mkdir") }

    err := os.make_directory(path)
    if err != os.ERROR_NONE {
        return runtime_error("fs.mkdir: konnte Verzeichnis nicht erstellen: "+path, "fs")
    }
    return wrap_bool(true)
}

fs_read_dir :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 1 {
        return runtime_error("fs.readDir: zu wenige Argumente", "fs")
    }
    path, ok := unwrap_string(args[0])
    if !ok { return type_error("string", args[0].type, "fs.readDir") }

    dir, err := os.open_directory(path)
    if err != os.ERROR_NONE {
        return runtime_error("fs.readDir: konnte Verzeichnis nicht öffnen: "+path, "fs")
    }
    defer os.close(dir)

    entries: []os.Dir_Entry
    for {
        entry, err2 := os.read_dir(dir, 100)
        if err2 == os.ERROR_EOF || len(entry) == 0 {
            break
        }
        if err2 != os.ERROR_NONE {
            break
        }
        entries = slice.concat(entries, entry[:])
    }

    arr := make_array(env.allocator, env)
    for entry in entries {
        entry_obj := make_object(env.allocator, env)
        entry_obj.properties["name"] = wrap_string(entry.name, env.allocator)
        entry_obj.properties["is_dir"] = wrap_bool(entry.is_dir)
        entry_obj.properties["size"] = wrap_int(i64(entry.size))
        append(&arr.items, Value{type = .Object, data = {object = entry_obj}})
    }

    return Value{type = .Array, data = {array = arr}}
}

fs_exists :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 1 {
        return runtime_error("fs.exists: zu wenige Argumente", "fs")
    }
    path, ok := unwrap_string(args[0])
    if !ok { return type_error("string", args[0].type, "fs.exists") }

    info, err := os.stat(path)
    return wrap_bool(err == os.ERROR_NONE)
}

fs_remove :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 1 {
        return runtime_error("fs.remove: zu wenige Argumente", "fs")
    }
    path, ok := unwrap_string(args[0])
    if !ok { return type_error("string", args[0].type, "fs.remove") }

    err := os.remove(path)
    if err != os.ERROR_NONE {
        return runtime_error("fs.remove: konnte Datei nicht löschen: "+path, "fs")
    }
    return wrap_bool(true)
}

// ---------- FS-METHODEN-REGISTRIERUNG (KOMPAKT) ----------
get_fs_methods :: proc(allocator: mem.Allocator) -> map[string]Value {
    methods := make(map[string]Value, allocator)
    register_methods(methods, []Method_Def{
        {"open", fs_open},
        {"read", fs_read},           // Datei-Objekt-Methoden
        {"write", fs_write},         // Datei-Objekt-Methoden
        {"close", fs_close},         // Datei-Objekt-Methoden
        {"readFile", fs_read_file},
        {"writeFile", fs_write_file},
        {"mkdir", fs_mkdir},
        {"readDir", fs_read_dir},
        {"exists", fs_exists},
        {"remove", fs_remove},
    }, allocator)
    return methods
}

// ---------- FILE-PROTOTYP ----------
create_file_prototype :: proc (allocator: mem.Allocator, parent: ^Object) -> ^Object {
  proto := make_object(allocator, parent)
    
  set_method (proto, "close", fs_close, allocator)
  set_method (proto, "read",  fs_read,  allocator)
  set_method (proto, "write", fs_write, allocator)

  return proto
}














