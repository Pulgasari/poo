// runtimes/odin/poo.odin
package runtime

import "core:mem"
import "core:fmt"
import "core:strings"
import "core:slice"


// ============================================================
// 1. METHODEN-REGISTRIERUNG (DER BOILERPLATE-KILLER)
// ============================================================

make_method :: proc(
  p: proc(env:^Object, args:[]Value)->Value,
  allocator: mem.Allocator,
  prototype: ^Object = nil,
) -> Value {
  return Value{
    type = .Function,
    data = {function = make_function(allocator, prototype, nil, p)},
  }
}

// Setzt eine einzelne Methode in einem Objekt (für Prototypen)
set_method :: proc(
  obj: ^Object, 
  name: string, 
  proc_ptr: proc(
    env: ^Object, 
    args: []Value
  ) -> Value, allocator: mem.Allocator) {
    obj.properties[name] = Value{
        type = .Function,
        data = {function = make_function(allocator, nil, nil, proc_ptr)}
    }
}

// Wie oben, aber mit Allocator aus dem Kontext
set_method_ctx :: proc(obj: ^Object, name: string, proc_ptr: proc(env: ^Object, args: []Value) -> Value) {
  allocator := context.allocator
  set_method (obj, name, proc_ptr, allocator);
}

Method_Def :: struct {
    name: string,
    proc: proc(env: ^Object, args: []Value) -> Value,
}

// Registriert eine Liste von Methoden in einer Map
register_methods :: proc(methods: map[string]Value, defs: []Method_Def, allocator: mem.Allocator) {
    for def in defs {
        methods[def.name] = Value{
            type = .Function,
            data = {function = make_function(allocator, nil, nil, def.proc)}
        }
    }
}

// Wie oben, aber mit einem zusätzlichen Prototyp für die Function-Objekte
register_methods_with_prototype :: proc(
    methods   : map[string]Value, 
    defs      : []Method_Def, 
    prototype : ^Object,
    allocator : mem.Allocator,
) {
    for def in defs {
        methods[def.name] = Value{
            type = .Function,
            data = {function = make_function(allocator, prototype, nil, def.proc)}
        }
    }
}

// ============================================================
// 2. VALUE-HELFER (TYPSICHERER ZUGRIFF)
// ============================================================

unwrap_string :: proc (v: Value) -> (string, bool) {
  if v.type != .String { return "", false }
  return v.data.(string), true
}

unwrap_array :: proc (v: Value) -> (^Array, bool) {
  if v.type != .Array { return nil, false }
  return v.data.(^Array), true
}

unwrap_list :: proc (v: Value) -> (^List, bool) {
  if v.type != .List { return nil, false }
  return v.data.(^List), true
}

unwrap_object :: proc (v: Value) -> (^Object, bool) {
  if v.type != .Object { return nil, false }
  return v.data.(^Object), true
}

unwrap_function :: proc (v: Value) -> (^Function, bool) {
  if v.type != .Function { return nil, false }
  return v.data.(^Function), true
}

unwrap_int :: proc (v: Value) -> (i64, bool) {
  if v.type != .Int { return 0, false }
  return v.data.(i64), true
}

unwrap_float :: proc (v: Value) -> (f64, bool) {
  if v.type != .Float { return 0.0, false }
  return v.data.(f64), true
}

unwrap_bool :: proc (v: Value) -> (bool, bool) {
  if v.type != .Bool { return false, false }
  return v.data.(bool), true
}

// ============================================================
// 3. VALUE-KONVERTIERUNGEN (FÜR METHODEN)
// ============================================================

// Konvertiert einen Odin-String zu einem String-Value (mit Kopie)
wrap_string :: proc(s: string, allocator: mem.Allocator) -> Value {
    copy := strings.clone(s, allocator)
    return from_string(copy)
}

wrap_bool  :: proc (b: bool) -> Value { return from_bool  (b) } // Konvertiert einen Odin-Bool zu einem Bool-Value
wrap_float :: proc (f: f64)  -> Value { return from_float (f) } // Konvertiert einen Odin-Float zu einem Float-Value
wrap_int   :: proc (i: i64)  -> Value { return from_int   (i) } // Konvertiert einen Odin-Int zu einem Int-Value



// Konvertiert ein Value zu einem String (für Debug/Join)
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

// ============================================================
// 4. WERTE-VERGLEICH (FÜR CONTAINS, INDEXOF, SORT)
// ============================================================

// Prüft, ob zwei Values gleich sind (für primitive Typen)
values_equal :: proc (a, b: Value) -> bool {
  if a.type != b.type { return false }
    
  switch a.type {
    case .Nil    : return true
    case .Bool   : return a.data.(bool)   == b.data.(bool)
    case .Int    : return a.data.(i64)    == b.data.(i64)
    case .Float  : return a.data.(f64)    == b.data.(f64)
    case .String : return a.data.(string) == b.data.(string)
    case         : return false // Objekte werden nicht verglichen
  }
}

// Vergleich für Sortierung (gibt -1, 0, 1 zurück)
compare_values :: proc(a, b: Value) -> int {
  if a.type != b.type { return int(a.type) - int(b.type) }

  switch a.type {
    case .Nil  : return 0
    case .Bool : return int(a.data.(bool)) - int(b.data.(bool))
    case .Int  : return int(a.data.(i64) - b.data.(i64))
    case .Float: 
        if a.data.(f64) < b.data.(f64) { return -1 }
        if a.data.(f64) > b.data.(f64) { return  1 }
        return 0
    case .String:
        if a.data.(string) < b.data.(string) { return -1 }
        if a.data.(string) > b.data.(string) { return  1 }
        return 0
    case: return 0
  }
}

// ============================================================
// 5. OBJEKT-HELFER (FÜR PROTOTYPEN & PROPERTIES)
// ============================================================

// Holt eine Property aus einem Objekt (mit Fallback auf Prototyp)
get_property :: proc(obj: ^Object, key: string) -> (Value, bool) {
    // 1. Eigene Properties durchsuchen
    if val, ok := obj.properties[key]; ok {
        return val, true
    }
    // 2. Prototyp-Kette durchgehen
    if obj.prototype != nil {
        return get_property(obj.prototype, key)
    }
    return Value{type = .Nil}, false
}

// Setzt eine Property in einem Objekt (überschreibt, falls vorhanden)
set_property :: proc(obj: ^Object, key: string, val: Value) {
    obj.properties[key] = val
}

// Erstellt ein neues Objekt mit einem bestimmten Prototyp
new_object_with_prototype :: proc(prototype: ^Object, allocator: mem.Allocator) -> ^Object {
    obj := make_object(allocator, prototype)
    return obj
}

// ============================================================
// 6. ARRAY-HELFER (FÜR METHODEN, DIE ARRAYS MODIFIZIEREN)
// ============================================================

// Kopiert ein Array (flache Kopie)
copy_array :: proc(arr: ^Array, allocator: mem.Allocator) -> ^Array {
    new_arr := make_array(allocator, arr.prototype)
    for item in arr.items {
        append(&new_arr.items, item)
    }
    return new_arr
}

// Konvertiert ein Array von Values zu einem Slice von Strings (für Join)
array_to_strings :: proc(arr: ^Array, allocator: mem.Allocator) -> []string {
    result := make([]string, len(arr.items), allocator)
    for i, item in arr.items {
        result[i] = value_to_string(item)
    }
    return result
}

// ============================================================
// 7. FEHLERBEHANDLUNG (FÜR KONSISTENTE RETURNS)
// ============================================================

// Prüft, ob ein Value ein Nil ist (für Fehlererkennung)
is_error :: proc(v: Value) -> bool {
  return v.type == .Nil
}

// Gibt einen Runtime-Fehler als Nil zurück
runtime_error :: proc(msg: string, loc: string = "") -> Value {
  if loc != "" { fmt.eprintf("[%s] RuntimeError: %s\n", loc, msg) } 
  else { fmt.eprintf("RuntimeError: %s\n", msg) }
  return from_nil()
}

// Gibt einen TypeError als Nil zurück (mit Log)
type_error :: proc(expected: string, got: Value_Type, loc: string = "") -> Value {
  if loc != "" { fmt.eprintf("[%s] TypeError: erwartet %s, bekam %v\n", loc, expected, got) } 
  else { fmt.eprintf("TypeError: erwartet %s, bekam %v\n", expected, got) }
  return from_nil()
}

// ============================================================
// 8. SPEICHERVERWALTUNG (FÜR CLEANUP)
// ============================================================

// Zerstört ein Objekt und alle seine Properties (rekursiv)
destroy_object_recursive :: proc(obj: ^Object, allocator: mem.Allocator) {
    // Properties rekursiv zerstören (nur wenn sie Objekte sind)
    for _, val in obj.properties {
        if val.type == .Object {
            destroy_object_recursive(val.data.(^Object), allocator)
        }
    }
    // Map und Objekt freigeben
    delete(obj.properties)
    free(obj, allocator)
}

// Zerstört ein Array und seine Items (nicht-rekursiv für Items)
destroy_array :: proc (arr: ^Array, allocator: mem.Allocator) {
    delete(arr.items)
    free(arr, allocator)
}
destroy_list :: proc (lst: ^List, allocator: mem.Allocator) {
    delete(lst.items)
    free(lst, allocator)
}
