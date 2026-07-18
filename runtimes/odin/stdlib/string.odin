// runtimes/odin/stdlib/string.odin
package runtime

import "core:strings"
import "core:mem"

// ---------- HILFSFUNKTIONEN (intern) ----------
// Extrahiert den rohen Odin-String aus einem Value
unwrap_string :: proc (v: Value) -> (string, bool) {
  if v.type != .String { return "", false }
  return v.data.(string), true
}

// Erstellt einen neuen String-Value aus Odin-String
wrap_string :: proc (s: string, allocator: mem.Allocator) -> Value {
  // Kopie anlegen, damit der String nicht vom GC gefressen wird
  copy := strings.clone(s, allocator)
  return from_string(copy)
}

// ---------- METHODEN (werden als normale Prozeduren definiert) ----------

// Gibt die Länge eines Strings zurück (als Int-Value)
string_length :: proc(env: ^Object, args: []Value) -> Value {
  if len (args) < 1 { return from_int(-1) }
  str, ok := unwrap_string(args[0])
  if !ok { return from_int(-1) }
  
  return from_int(i64(len(str)))
}

// Teilt einen String an einem Trennzeichen und gibt ein Array zurück
string_split :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 2 { return from_nil() }
    
    str, ok := unwrap_string (args[0])
    if !ok { return from_nil() }
    
    sep, ok2 := unwrap_string(args[1])
    if !ok2 { return from_nil() }

    // Odins split-Funktion
    parts := strings.split(str, sep)
    defer delete(parts) // Odin-Slice freigeben, nachdem wir kopiert haben

    // Array erstellen
    arr := make_array(env, nil) // env ist hier der Prototyp (oder nil)
    for part in parts {
        append(&arr.items, wrap_string(part, env.allocator))
    }
    return Value{type = .Array, data = {array = arr}}
}

// Entfernt Leerzeichen am Anfang und Ende
string_trim :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 1 {
        return from_nil()
    }
    str, ok := unwrap_string(args[0])
    if !ok {
        return from_nil()
    }
    trimmed := strings.trim_space(str)
    // Achtung: trimmed ist ein Substring von str, wir müssen kopieren!
    return wrap_string(trimmed, env.allocator)
}

// Ersetzt alle Vorkommen eines Substrings
string_replace :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 3 { return from_nil() }
    str, ok := unwrap_string(args[0])
    if !ok { return from_nil() }
    old, ok2 := unwrap_string(args[1])
    if !ok2 { return from_nil() }
    new, ok3 := unwrap_string(args[2])
    if !ok3 { return from_nil() }

    result := strings.replace_all(str, old, new)
    return wrap_string(result, env.allocator)
}

// Prüft, ob String mit Substring beginnt
string_starts_with :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 2 {
        return from_bool(false)
    }
    str, ok := unwrap_string(args[0])
    if !ok { return from_bool(false) }
    prefix, ok2 := unwrap_string(args[1])
    if !ok2 { return from_bool(false) }
    return from_bool(strings.starts_with(str, prefix))
}

// Konvertiert zu Großbuchstaben (nur ASCII in diesem Beispiel)
string_to_upper :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 1 { return from_nil() }
    str, ok := unwrap_string(args[0])
    if !ok { return from_nil() }
    upper := strings.to_upper(str)
    return wrap_string(upper, env.allocator)
}

// ---------- EXPORT: Liste aller String-Methoden ----------
// Diese Map wird in den String-Prototypen eingetragen

get_string_methods :: proc (allocator: mem.Allocator) -> map[string]Value {
  methods := make(map[string]Value, allocator)

  // Jede Methode wird als Function-Value in die Map gepackt
  methods["length"]     = Value { type = .Function, data = { function = make_function( allocator, nil, nil, string_length      )}}
  methods["split"]      = Value { type = .Function, data = { function = make_function( allocator, nil, nil, string_split       )}}
  methods["trim"]       = Value { type = .Function, data = { function = make_function( allocator, nil, nil, string_trim        )}}
  methods["replace"]    = Value { type = .Function, data = { function = make_function( allocator, nil, nil, string_replace     )}}
  methods["startsWith"] = Value { type = .Function, data = { function = make_function( allocator, nil, nil, string_starts_with )}} 
  methods["toUpper"]    = Value { type = .Function, data = { function = make_function( allocator, nil, nil, string_to_upper    )}}   

  return methods
}


