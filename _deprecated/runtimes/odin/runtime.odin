// runtimes/odin/runtime.odin
package runtime

import "core:mem"
import "core:fmt"

// 1. Typdefinitionen einbinden
// (Deine types.odin – am besten als separate Datei, aber hier als Platzhalter)
// Du kannst es entweder per #include machen oder alles in eine Datei packen.
// Für Odin: #include "types.odin" (geht aber nicht direkt)
// Besser: types.odin und runtime.odin im selben Package – siehe vorherige Antwort.

// 2. Standardbibliothek einbinden
// (Die Prozeduren aus string.odin und core.odin sind im selben Package sichtbar)

// ---------- INITIALISIERUNG DER RUNTIME ----------
// Diese Funktion wird von deinem generierten main.odin aufgerufen
init_runtime :: proc(allocator: mem.Allocator) -> ^Object {
    // 1. Das Ur-Objekt erstellen (Root-Prototyp)
    root := create_base_object(allocator)

    // 2. Den globalen String-Prototypen erstellen (erbt von root)
    string_proto := make_object(allocator, root)
    
    // 3. String-Methoden in den Prototyp einhängen
    string_methods := get_string_methods(allocator)
    for key, val in string_methods {
        string_proto.properties[key] = val
    }
    // (Die Methoden-Map bleibt im Speicher, könnte man auch freigeben)

    // 4. String-Prototyp in root einhängen (für späteren Zugriff)
    root.properties["_string_prototype"] = Value{
        type = .Object,
        data = {object = string_proto}
    }

    // 5. Globale Funktionen in root einhängen
    globals := get_global_functions(allocator)
    for key, val in globals {
        root.properties[key] = val
    }

    // 6. Primitive-Wrapper für Strings bereitstellen (damit Autoboxing funktioniert)
    // Wenn jemand "hallo".length() aufruft, wird der String kurz in ein Objekt verpackt
    // mit diesem Prototypen. Das macht dein Compiler oder deine Runtime automatisch.
    root.properties["__string_prototype"] = Value{
        type = .Object,
        data = {object = string_proto}
    }

    return root
}

// ---------- AUTOBOXING (für Methodenaufrufe auf Primitives) ----------
// Diese Funktion nimmt einen primitiven String und gibt ein temporäres
// Objekt mit dem String-Prototyp zurück (für Methodenaufrufe)
box_string :: proc(s: string, prototype: ^Object, allocator: mem.Allocator) -> ^Object {
    obj := make_object(allocator, prototype)
    // Speichere den rohen String als spezielle Property
    obj.properties["__value"] = from_string(s)
    return obj
}

// Methode auf einem geboxten String aufrufen
call_string_method :: proc(obj: ^Object, method_name: string, args: []Value) -> Value {
    // 1. Methode aus den Properties holen
    method_val, ok := obj.properties[method_name]
    if !ok {
        return from_nil()
    }
    if method_val.type != .Function {
        return from_nil()
    }

    // 2. Funktion ausführen
    fn := method_val.data.(^Function)
    // Die Funktion erwartet als erstes Argument den String-Wert
    // Wir holen den rohen String aus der "__value"-Property
    raw_val, ok2 := obj.properties["__value"]
    if !ok2 {
        return from_nil()
    }

    // Args vorbereiten: [string_value, ...rest]
    new_args := make([]Value, len(args) + 1)
    new_args[0] = raw_val
    copy(new_args[1:], args)
    defer delete(new_args)

    return fn.proc_ptr(fn.env, new_args)
}

// runtimes/odin/runtime.odin (Erweitert)
package runtime

import "core:mem"
import "core:fmt"

// ---------- INITIALISIERUNG DER RUNTIME ----------

init_runtime :: proc(allocator: mem.Allocator) -> ^Object {
    // 1. Das Ur-Objekt erstellen (Root-Prototyp)
    root := create_base_object(allocator)

    // 2. String-Prototypen erstellen (aus stdlib/string.odin)
    string_proto := make_object(allocator, root)
    string_methods := get_string_methods(allocator)
    for key, val in string_methods {
        string_proto.properties[key] = val
    }
    root.properties["_string_prototype"] = Value{type = .Object, data = {object = string_proto}}

    // 3. Array-Prototypen erstellen (aus stdlib/array.odin)
    array_proto := make_object(allocator, root)
    array_methods := get_array_methods(allocator)
    for key, val in array_methods {
        array_proto.properties[key] = val
    }
    root.properties["_array_prototype"] = Value{type = .Object, data = {object = array_proto}}

    // 4. List-Prototypen erstellen (erbt von Array-Prototyp)
    list_proto := make_object(allocator, array_proto)
    // List-Methoden sind bereits in array_methods enthalten
    // Wir fügen noch spezifische hinzu, falls nötig
    root.properties["_list_prototype"] = Value{type = .Object, data = {object = list_proto}}

    // 5. Globale Funktionen (aus stdlib/core.odin)
    globals := get_global_functions(allocator)
    for key, val in globals {
        root.properties[key] = val
    }

    // 6. Spezielle globale Funktion für Arrays (schneller Zugriff)
    root.properties["Array"] = Value{
        type = .Function,
        data = {function = make_function(allocator, nil, nil, proc(env: ^Object, args: []Value) -> Value {
            // Array-Konstruktor: Erstellt ein Array aus den Argumenten
            arr := make_array(env, env) // env ist hier der Array-Prototyp
            for arg in args {
                append(&arr.items, arg)
            }
            return Value{type = .Array, data = {array = arr}}
        })}
    }

    // 7. Spezielle globale Funktion für Listen
    root.properties["List"] = Value{
        type = .Function,
        data = {function = make_function(allocator, nil, nil, proc(env: ^Object, args: []Value) -> Value {
            if len(args) < 1 {
                return from_nil()
            }
            // Erster Parameter ist der Typ (als Value_Type)
            // Zweiter Parameter ist das initiale Array (optional)
            return from_nil() // Wird später implementiert
        })}
    }

    return root
}






// runtimes/odin/runtime.odin
package runtime

import "core:mem"

init_runtime :: proc(allocator: mem.Allocator) -> ^Object {
    root := create_base_object(allocator)

    // --- Prototypen erstellen ---
    string_proto := make_object(allocator, root)
    array_proto := make_object(allocator, root)
    file_proto := create_file_prototype(allocator, root)

    // --- Methoden registrieren ---
    string_methods := get_string_methods(allocator)
    for key, val in string_methods {
        string_proto.properties[key] = val
    }

    array_methods := get_array_methods(allocator)
    for key, val in array_methods {
        array_proto.properties[key] = val
    }

    fs_methods := get_fs_methods(allocator)
    for key, val in fs_methods {
        root.properties[key] = val
    }

    io_methods := get_io_methods(allocator)
    for key, val in io_methods {
        root.properties[key] = val
    }

    // --- Globale Funktionen ---
    globals := get_global_functions(allocator)
    for key, val in globals {
        root.properties[key] = val
    }

    // --- Prototypen im Root speichern (für Autoboxing) ---
    root.properties["_string_prototype"] = Value{type = .Object, data = {object = string_proto}}
    root.properties["_array_prototype"] = Value{type = .Object, data = {object = array_proto}}
    root.properties["_file_prototype"] = Value{type = .Object, data = {object = file_proto}}

    // --- Array-Konstruktor ---
    root.properties["Array"] = Value{
        type = .Function,
        data = {function = make_function(allocator, nil, nil, 
            proc(env: ^Object, args: []Value) -> Value {
                arr := make_array(env.allocator, env)
                for arg in args {
                    append(&arr.items, arg)
                }
                return Value{type = .Array, data = {array = arr}}
            }
        )}
    }

    return root
}
