// runtimes/odin/stdlib/fs.odin
package runtime

import "core:os"
import "core:mem"
import "core:strings"
import "core:fmt"
import "core:time"

// ---------- DATEI-HANDLE (intern) ----------
FileHandle :: struct {
    handle: os.Handle,
    path: string,
    mode: os.Open_Mode,
    allocator: mem.Allocator,
}

// ---------- HILFSFUNKTIONEN ----------
// Konvertiert Odin-String zu C-String (für OS-API)
// (Odin macht das automatisch, wir müssen nichts tun)

// Extrahiert FileHandle aus Value
unwrap_file :: proc(v: Value) -> (^FileHandle, bool) {
    if v.type != .Object {
        return nil, false
    }
    obj := v.data.(^Object)
    handle_raw, ok := obj.properties["__handle"]
    if !ok { return nil, false }
    if handle_raw.type != .Int { return nil, false }
    ptr := uintptr(handle_raw.data.(i64))
    return cast(^FileHandle)ptr, true
}

// ---------- FS-FUNKTIONEN (für deine Sprache) ----------

// Öffnet eine Datei
fs_open :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 2 {
        return from_nil()
    }
    path, ok := unwrap_string(args[0])
    if !ok {
        return from_nil()
    }
    mode_str, ok2 := unwrap_string(args[1])
    if !ok2 {
        return from_nil()
    }

    // Modus parsen
    mode := os.O_RDONLY
    if mode_str == "r"   { mode = os.O_RDONLY }
    else if mode_str == "w"  { mode = os.O_WRONLY | os.O_CREATE | os.O_TRUNC }
    else if mode_str == "a"  { mode = os.O_WRONLY | os.O_CREATE | os.O_APPEND }
    else if mode_str == "r+" { mode = os.O_RDWR }
    else if mode_str == "w+" { mode = os.O_RDWR | os.O_CREATE | os.O_TRUNC }
    else {
        // Fehler: Unbekannter Modus
        return from_nil()
    }

    // Öffnen
    handle, err := os.open(path, mode)
    if err != os.ERROR_NONE {
        return from_nil()
    }

    // FileHandle-Objekt erstellen
    file_handle := new(FileHandle, env.allocator)
    file_handle.handle = handle
    file_handle.path = strings.clone(path, env.allocator)
    file_handle.mode = mode
    file_handle.allocator = env.allocator

    // File-Objekt in deiner Sprache erstellen
    file_obj := make_object(env, env) // env ist der File-Prototyp
    file_obj.properties["__handle"] = from_int(i64(uintptr(file_handle)))
    file_obj.properties["path"] = from_string(file_handle.path)

    // Methoden hinzufügen (werden eigentlich im Prototyp gehalten)
    // Hier als Demo direkt im Objekt
    file_obj.properties["read"] = Value{
        type = .Function,
        data = {function = make_function(env.allocator, nil, nil, fs_read)}
    }
    file_obj.properties["write"] = Value{
        type = .Function,
        data = {function = make_function(env.allocator, nil, nil, fs_write)}
    }
    file_obj.properties["close"] = Value{
        type = .Function,
        data = {function = make_function(env.allocator, nil, nil, fs_close)}
    }
    file_obj.properties["stat"] = Value{
        type = .Function,
        data = {function = make_function(env.allocator, nil, nil, fs_stat)}
    }

    return Value{type = .Object, data = {object = file_obj}}
}

// Liest aus einer Datei
fs_read :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 2 {
        return from_nil()
    }
    file_obj, ok := args[0].(Value)
    if !ok { return from_nil() }
    file, ok2 := unwrap_file(file_obj)
    if !ok2 { return from_nil() }

    // Lesegröße (optional)
    size := 4096 // Standard
    if len(args) >= 2 {
        size_val, ok3 := args[1].(Value)
        if ok3 && size_val.type == .Int {
            size = int(size_val.data.(i64))
        }
    }

    // Buffer erstellen
    buf := make([]u8, size, env.allocator)
    defer delete(buf)

    // Lesen
    n, err := os.read(file.handle, buf)
    if err != os.ERROR_NONE {
        return from_nil()
    }

    // Gelesene Bytes als String zurückgeben
    return from_string(string(buf[:n]))
}

// Schreibt in eine Datei
fs_write :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 2 {
        return from_bool(false)
    }
    file_obj, ok := args[0].(Value)
    if !ok { return from_bool(false) }
    file, ok2 := unwrap_file(file_obj)
    if !ok2 { return from_bool(false) }

    // Daten zum Schreiben (String oder Bytes)
    data_str, ok3 := unwrap_string(args[1])
    if !ok3 {
        // Versuche als Bytes zu interpretieren
        return from_bool(false)
    }

    // In Bytes umwandeln
    data := transmute([]u8)data_str

    // Schreiben
    n, err := os.write(file.handle, data)
    if err != os.ERROR_NONE {
        return from_bool(false)
    }

    return from_int(i64(n))
}

// Schließt eine Datei
fs_close :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 1 {
        return from_bool(false)
    }
    file_obj, ok := args[0].(Value)
    if !ok { return from_bool(false) }
    file, ok2 := unwrap_file(file_obj)
    if !ok2 { return from_bool(false) }

    err := os.close(file.handle)
    if err != os.ERROR_NONE {
        return from_bool(false)
    }

    // Speicher freigeben (optional)
    // free(file, file.allocator)

    return from_bool(true)
}

// Holt Datei-Informationen (Stat)
fs_stat :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 1 {
        return from_nil()
    }

    // Entweder File-Objekt oder Pfad-String
    var path string
    var file: ^FileHandle

    if args[0].type == .Object {
        file_obj, ok := unwrap_file(args[0])
        if !ok { return from_nil() }
        file = file_obj
        path = file.path
    } else if args[0].type == .String {
        path = args[0].data.(string)
    } else {
        return from_nil()
    }

    // Stat holen (entweder über Handle oder Pfad)
    info: os.File_Info
    err: os.Error
    if file != nil {
        info, err = os.fstat(file.handle)
    } else {
        info, err = os.stat(path)
    }
    if err != os.ERROR_NONE {
        return from_nil()
    }

    // Stat-Objekt erstellen
    stat_obj := make_object(env, env)
    stat_obj.properties["size"] = from_int(i64(info.size))
    stat_obj.properties["is_dir"] = from_bool(info.is_dir)
    stat_obj.properties["mode"] = from_int(i64(info.mode))
    stat_obj.properties["modified"] = from_string(time.to_string(info.modified))

    return Value{type = .Object, data = {object = stat_obj}}
}

// Liest die gesamte Datei (einfache Variante)
fs_read_file :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 1 {
        return from_nil()
    }
    path, ok := unwrap_string(args[0])
    if !ok {
        return from_nil()
    }

    // Datei öffnen
    handle, err := os.open(path, os.O_RDONLY)
    if err != os.ERROR_NONE {
        return from_nil()
    }
    defer os.close(handle)

    // Größe ermitteln
    info, err2 := os.fstat(handle)
    if err2 != os.ERROR_NONE {
        return from_nil()
    }

    // Lesen
    data := make([]u8, info.size)
    _, err3 := os.read(handle, data)
    if err3 != os.ERROR_NONE {
        delete(data)
        return from_nil()
    }

    // Als String zurückgeben
    result := from_string(string(data))
    delete(data) // Speicher freigeben (String hat kopiert)
    return result
}

// Schreibt die gesamte Datei (einfache Variante)
fs_write_file :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 2 {
        return from_bool(false)
    }
    path, ok := unwrap_string(args[0])
    if !ok { return from_bool(false) }
    content, ok2 := unwrap_string(args[1])
    if !ok2 { return from_bool(false) }

    // Datei öffnen (überschreiben)
    handle, err := os.open(path, os.O_WRONLY | os.O_CREATE | os.O_TRUNC)
    if err != os.ERROR_NONE {
        return from_bool(false)
    }
    defer os.close(handle)

    // Schreiben
    data := transmute([]u8)content
    _, err2 := os.write(handle, data)
    if err2 != os.ERROR_NONE {
        return from_bool(false)
    }

    return from_bool(true)
}

// Erstellt ein Verzeichnis
fs_mkdir :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 1 {
        return from_bool(false)
    }
    path, ok := unwrap_string(args[0])
    if !ok { return from_bool(false) }

    err := os.make_directory(path)
    if err != os.ERROR_NONE {
        return from_bool(false)
    }
    return from_bool(true)
}

// Liest ein Verzeichnis aus
fs_read_dir :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 1 {
        return from_nil()
    }
    path, ok := unwrap_string(args[0])
    if !ok { return from_nil() }

    // Verzeichnis öffnen
    dir, err := os.open_directory(path)
    if err != os.ERROR_NONE {
        return from_nil()
    }
    defer os.close(dir)

    // Alle Einträge lesen
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

    // In Array umwandeln (deiner Sprache)
    arr := make_array(env, env)
    for entry in entries {
        // Jeden Eintrag als Objekt
        entry_obj := make_object(env, env)
        entry_obj.properties["name"] = from_string(entry.name)
        entry_obj.properties["is_dir"] = from_bool(entry.is_dir)
        entry_obj.properties["size"] = from_int(i64(entry.size))
        append(&arr.items, Value{type = .Object, data = {object = entry_obj}})
    }

    return Value{type = .Array, data = {array = arr}}
}

// Prüft, ob eine Datei/Verzeichnis existiert
fs_exists :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 1 {
        return from_bool(false)
    }
    path, ok := unwrap_string(args[0])
    if !ok { return from_bool(false) }

    info, err := os.stat(path)
    return from_bool(err == os.ERROR_NONE)
}

// Löscht eine Datei
fs_remove :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 1 {
        return from_bool(false)
    }
    path, ok := unwrap_string(args[0])
    if !ok { return from_bool(false) }

    err := os.remove(path)
    return from_bool(err == os.ERROR_NONE)
}

// ---------- FS-METHODEN-REGISTRIERUNG ----------
get_fs_methods :: proc(allocator: mem.Allocator) -> map[string]Value {
    methods := make(map[string]Value, allocator)

    // Globale FS-Funktionen
    methods["open"] = Value{
        type = .Function,
        data = {function = make_function(allocator, nil, nil, fs_open)}
    }
    methods["readFile"] = Value{
        type = .Function,
        data = {function = make_function(allocator, nil, nil, fs_read_file)}
    }
    methods["writeFile"] = Value{
        type = .Function,
        data = {function = make_function(allocator, nil, nil, fs_write_file)}
    }
    methods["mkdir"] = Value{
        type = .Function,
        data = {function = make_function(allocator, nil, nil, fs_mkdir)}
    }
    methods["readDir"] = Value{
        type = .Function,
        data = {function = make_function(allocator, nil, nil, fs_read_dir)}
    }
    methods["exists"] = Value{
        type = .Function,
        data = {function = make_function(allocator, nil, nil, fs_exists)}
    }
    methods["remove"] = Value{
        type = .Function,
        data = {function = make_function(allocator, nil, nil, fs_remove)}
    }

    // File-Objekt-Methoden (werden im File-Prototyp eingetragen)
    // Diese sind bereits in fs_open eingebunden

    return methods
}

// ---------- FILE-PROTOTYP (für die Runtime-Init) ----------
create_file_prototype :: proc(allocator: mem.Allocator, parent: ^Object) -> ^Object {
    proto := make_object(allocator, parent)

    // Methoden für File-Objekte
    proto.properties["read"] = Value{
        type = .Function,
        data = {function = make_function(allocator, nil, nil, fs_read)}
    }
    proto.properties["write"] = Value{
        type = .Function,
        data = {function = make_function(allocator, nil, nil, fs_write)}
    }
    proto.properties["close"] = Value{
        type = .Function,
        data = {function = make_function(allocator, nil, nil, fs_close)}
    }
    proto.properties["stat"] = Value{
        type = .Function,
        data = {function = make_function(allocator, nil, nil, fs_stat)}
    }  

    return proto
}

