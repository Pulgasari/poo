// runtimes/odin/stdlib/array.odin
package runtime

import "core:mem"
import "core:fmt"
import "core:slice"

// ---------- HILFSFUNKTIONEN (intern) ----------

unwrap_array :: proc (v: Value) -> (^Array, bool) {
  if v.type != .Array { return nil, false }
  return v.data.(^Array), true
}

// ---------- ARRAY-METHODEN ----------

// push: Fügt ein Element am Ende hinzu
array_push :: proc(env: ^Object, args: []Value) -> Value {
  if len(args) < 2 { return from_nil() }
  
  arr, ok := unwrap_array(args[0])
  if !ok { return from_nil() }
    
  // Das neue Element ist args[1]
  append(&arr.items, args[1])
  return args[1] // Gibt das hinzugefügte Element zurück
}

// pop: Entfernt das letzte Element und gibt es zurück
array_pop :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 1 { return from_nil() }
    arr, ok := unwrap_array(args[0])
    if !ok { return from_nil() }
    if len (arr.items) == 0 { return from_nil() }
    last := arr.items[len(arr.items) - 1]
    pop(&arr.items)
    return last
}

// shift: Entfernt das erste Element und gibt es zurück
array_shift :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 1 {
        return from_nil()
    }
    arr, ok := unwrap_array(args[0])
    if !ok {
        return from_nil()
    }
    if len(arr.items) == 0 {
        return from_nil()
    }
    first := arr.items[0]
    // Alle Elemente nach links verschieben
    arr.items = arr.items[1:]
    return first
}

// unshift: Fügt ein Element am Anfang hinzu
array_unshift :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 2 {
        return from_nil()
    }
    arr, ok := unwrap_array(args[0])
    if !ok {
        return from_nil()
    }
    // Neues Element vorne einfügen
    new_items := make([dynamic]Value, len(arr.items) + 1)
    append(&new_items, args[1])
    for item in arr.items {
        append(&new_items, item)
    }
    arr.items = new_items
    return args[1]
}

// length: Gibt die Länge des Arrays zurück
array_length :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 1 {
        return from_int(-1)
    }
    arr, ok := unwrap_array(args[0])
    if !ok {
        return from_int(-1)
    }
    return from_int(i64(len(arr.items)))
}

// contains: Prüft, ob ein Element im Array existiert
array_contains :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 2 {
        return from_bool(false)
    }
    arr, ok := unwrap_array(args[0])
    if !ok {
        return from_bool(false)
    }
    target := args[1]
    for item in arr.items {
        // Einfacher Vergleich (für primitive Typen)
        if values_equal(item, target) {
            return from_bool(true)
        }
    }
    return from_bool(false)
}

// indexOf: Gibt den ersten Index eines Elements zurück (-1 wenn nicht gefunden)
array_index_of :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 2 {
        return from_int(-1)
    }
    arr, ok := unwrap_array(args[0])
    if !ok {
        return from_int(-1)
    }
    target := args[1]
    for item, idx in arr.items {
        if values_equal(item, target) {
            return from_int(i64(idx))
        }
    }
    return from_int(-1)
}

// map: Wendet eine Funktion auf jedes Element an und gibt ein neues Array zurück
array_map :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 2 {
        return from_nil()
    }
    arr, ok := unwrap_array(args[0])
    if !ok {
        return from_nil()
    }
    fn_val, ok2 := args[1].(Value) 
    // Achtung: args[1] ist bereits ein Value, das eine Function sein sollte
    if fn_val.type != .Function {
        return from_nil()
    }
    fn := fn_val.data.(^Function)

    // Neues Array für Ergebnisse
    result := make_array(env, nil)
    for item in arr.items {
        // Funktion aufrufen: fn(item) -> neuer Wert
        result_val := fn.proc_ptr(fn.env, []Value{item})
        append(&result.items, result_val)
    }
    return Value{type = .Array, data = {array = result}}
}

// filter: Filtert Elemente mit einer Funktion und gibt ein neues Array zurück
array_filter :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 2 {
        return from_nil()
    }
    arr, ok := unwrap_array(args[0])
    if !ok {
        return from_nil()
    }
    fn_val, ok2 := args[1].(Value)
    if fn_val.type != .Function {
        return from_nil()
    }
    fn := fn_val.data.(^Function)

    result := make_array(env, nil)
    for item in arr.items {
        // Funktion prüft: fn(item) -> bool
        check := fn.proc_ptr(fn.env, []Value{item})
        if check.type == .Bool && check.data.(bool) {
            append(&result.items, item)
        }
    }
    return Value{type = .Array, data = {array = result}}
}

// reduce: Reduziert ein Array auf einen einzelnen Wert
array_reduce :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 3 {
        return from_nil()
    }
    arr, ok := unwrap_array(args[0])
    if !ok {
        return from_nil()
    }
    fn_val, ok2 := args[1].(Value)
    if fn_val.type != .Function {
        return from_nil()
    }
    fn := fn_val.data.(^Function)
    accumulator := args[2] // Startwert

    for item in arr.items {
        // fn(accumulator, item) -> neuer accumulator
        accumulator = fn.proc_ptr(fn.env, []Value{accumulator, item})
    }
    return accumulator
}

// join: Verbindet Array-Elemente zu einem String mit Trennzeichen
array_join :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 1 {
        return from_string("")
    }
    arr, ok := unwrap_array(args[0])
    if !ok {
        return from_string("")
    }
    separator := ""
    if len(args) >= 2 {
        sep_str, ok2 := unwrap_string(args[1])
        if ok2 {
            separator = sep_str
        }
    }

    // Alle Elemente zu Strings konvertieren
    parts := make([dynamic]string)
    defer delete(parts)
    for item in arr.items {
        parts_str := value_to_string(item)
        append(&parts, parts_str)
    }
    result := slice.join(parts[:], separator)
    return from_string(result)
}

// reverse: Kehrt die Reihenfolge der Elemente um (in-place)
array_reverse :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 1 {
        return from_nil()
    }
    arr, ok := unwrap_array(args[0])
    if !ok {
        return from_nil()
    }
    // In-place umkehren
    slice.reverse(arr.items[:])
    return args[0] // Gibt das Array selbst zurück
}

// sort: Sortiert das Array (einfache Sortierung, nur für primitive Typen)
array_sort :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 1 {
        return from_nil()
    }
    arr, ok := unwrap_array(args[0])
    if !ok {
        return from_nil()
    }
    // Odins slice.sort mit benutzerdefiniertem Vergleich
    slice.sort_by(arr.items[:], proc(a, b: Value) -> bool {
        return compare_values(a, b) < 0
    })
    return args[0]
}

// slice: Extrahiert einen Teil des Arrays (start, end)
array_slice :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 3 {
        return from_nil()
    }
    arr, ok := unwrap_array(args[0])
    if !ok {
        return from_nil()
    }
    start, ok2 := args[1].(Value)
    if !ok2 || start.type != .Int {
        return from_nil()
    }
    end, ok3 := args[2].(Value)
    if !ok3 || end.type != .Int {
        return from_nil()
    }
    s := int(start.data.(i64))
    e := int(end.data.(i64))
    if s < 0 || e > len(arr.items) || s > e {
        return from_nil()
    }
    result := make_array(env, nil)
    for i := s; i < e; i += 1 {
        append(&result.items, arr.items[i])
    }
    return Value{type = .Array, data = {array = result}}
}

// ---------- LIST-METHODEN (für typsichere Listen) ----------

// list_push: Fügt Element hinzu (mit Typ-Prüfung)
list_push_method :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 2 {
        return from_nil()
    }
    lst, ok := unwrap_list(args[0])
    if !ok {
        return from_nil()
    }
    val := args[1]
    if val.type != lst.item_type {
        fmt.eprintf("TypeError: List erwartet %v, bekam %v\n", lst.item_type, val.type)
        return from_nil()
    }
    // Dynamisch vergrößern (oder vorher allozieren)
    new_items := slice.append(lst.items, val, lst.allocator)
    lst.items = new_items
    return val
}

// list_get: Holt Element an Index
list_get_method :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 2 {
        return from_nil()
    }
    lst, ok := unwrap_list(args[0])
    if !ok {
        return from_nil()
    }
    idx_val, ok2 := args[1].(Value)
    if !ok2 || idx_val.type != .Int {
        return from_nil()
    }
    idx := int(idx_val.data.(i64))
    if idx < 0 || idx >= len(lst.items) {
        return from_nil()
    }
    return lst.items[idx]
}

// list_length: Länge der Liste
list_length_method :: proc(env: ^Object, args: []Value) -> Value {
    if len(args) < 1 {
        return from_int(-1)
    }
    lst, ok := unwrap_list(args[0])
    if !ok {
        return from_int(-1)
    }
    return from_int(i64(len(lst.items)))
}

// ---------- HILFSFUNKTIONEN FÜR WERTE ----------
// Einfacher Vergleich (für primitive Typen)
values_equal :: proc(a, b: Value) -> bool {
    if a.type != b.type {
        return false
    }
    switch a.type {
    case .Nil:  return true
    case .Bool: return a.data.(bool) == b.data.(bool)
    case .Int:  return a.data.(i64) == b.data.(i64)
    case .Float: return a.data.(f64) == b.data.(f64)
    case .String: return a.data.(string) == b.data.(string)
    case: return false // Objekte werden nicht verglichen
    }
}

// Vergleich für Sortierung (gibt -1, 0, 1 zurück)
compare_values :: proc(a, b: Value) -> int {
    if a.type != b.type {
        return int(a.type) - int(b.type)
    }
    switch a.type {
    case .Nil:  return 0
    case .Bool: return int(a.data.(bool)) - int(b.data.(bool))
    case .Int:  return int(a.data.(i64) - b.data.(i64))
    case .Float: 
        if a.data.(f64) < b.data.(f64) { return -1 }
        if a.data.(f64) > b.data.(f64) { return 1 }
        return 0
    case .String:
        if a.data.(string) < b.data.(string) { return -1 }
        if a.data.(string) > b.data.(string) { return 1 }
        return 0
    case: return 0
    }
}

// Konvertiert Value zu String (für join und Debug)
value_to_string :: proc(v: Value) -> string {
    switch v.type {
    case .Nil:    return "nil"
    case .Bool:   return v.data.(bool) ? "true" : "false"
    case .Int:    return fmt.tprint(v.data.(i64))
    case .Float:  return fmt.tprint(v.data.(f64))
    case .String: return v.data.(string)
    case .Array:  return "[Array]"
    case .Object: return "{Object}"
    case .List:   return "[List]"
    case .Tuple:  return "(Tuple)"
    case .Function: return "<Function>"
    case .Class:  return "<Class>"
    }
    return "?"
}

// ---------- EXPORT: METHODEN-REGISTRIERUNG ----------
get_array_methods :: proc(allocator: mem.Allocator) -> map[string]Value {
    methods := make(map[string]Value, allocator)

    // Array-Methoden
    methods["push"] = Value{type = .Function, data = {function = make_function(allocator, nil, nil, array_push)}}
    methods["pop"] = Value{type = .Function, data = {function = make_function(allocator, nil, nil, array_pop)}}
    methods["shift"] = Value{type = .Function, data = {function = make_function(allocator, nil, nil, array_shift)}}
    methods["unshift"] = Value{type = .Function, data = {function = make_function(allocator, nil, nil, array_unshift)}}
    methods["length"] = Value{type = .Function, data = {function = make_function(allocator, nil, nil, array_length)}}
    methods["contains"] = Value{type = .Function, data = {function = make_function(allocator, nil, nil, array_contains)}}
    methods["indexOf"] = Value{type = .Function, data = {function = make_function(allocator, nil, nil, array_index_of)}}
    methods["map"] = Value{type = .Function, data = {function = make_function(allocator, nil, nil, array_map)}}
    methods["filter"] = Value{type = .Function, data = {function = make_function(allocator, nil, nil, array_filter)}}
    methods["reduce"] = Value{type = .Function, data = {function = make_function(allocator, nil, nil, array_reduce)}}
    methods["join"] = Value{type = .Function, data = {function = make_function(allocator, nil, nil, array_join)}}
    methods["reverse"] = Value{type = .Function, data = {function = make_function(allocator, nil, nil, array_reverse)}}
    methods["sort"] = Value{type = .Function, data = {function = make_function(allocator, nil, nil, array_sort)}}
    methods["slice"] = Value{type = .Function, data = {function = make_function(allocator, nil, nil, array_slice)}}

    // List-Methoden
    methods["list_push"] = Value{type = .Function, data = {function = make_function(allocator, nil, nil, list_push_method)}}
    methods["list_get"] = Value{type = .Function, data = {function = make_function(allocator, nil, nil, list_get_method)}}
    methods["list_length"] = Value{type = .Function, data = {function = make_function(allocator, nil, nil, list_length_method)}}

    return methods
}
