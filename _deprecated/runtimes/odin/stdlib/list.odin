// runtimes/odin/stdlib/array.odin
package runtime

import "core:mem"
import "core:fmt"
import "core:slice"

// ---------- HILFSFUNKTIONEN (intern) ----------

unwrap_list :: proc (v: Value) -> (^List, bool) {
  if v.type != .List { return nil, false }
  return v.data.(^List), true
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
