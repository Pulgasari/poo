package types

import "core:time"

// === 1. primitives & basic tags ===

Char :: rune

Color :: struct {
  rgba : u32, // hex and alpha packed into 4 bytes
}

Null :: struct{} // primitive token representing POO null

Symbol :: struct {
  id   : u64,    // unique identifier for immutability
  name : string, // identifier debug name
}

// === 2. blueprints & metadata ===

Enum :: struct {
  name     : string,
  variants : map[string]Value,
}

Pattern :: struct {
  // layout rules for structural pattern matching (~=)
}

Union_Type :: struct {
  allowed_types : [dynamic]typeid, // permitted structural types
}

// === 3. complex heap-allocated structures ===

Array :: struct {
  items     : [dynamic]Value,
  prototype : ^Object,
}

Blob :: struct {
  bytes     : [dynamic]byte, // raw binary payload
  prototype : ^Object,
}

Class :: struct {
  constructor : proc(allocator: mem.Allocator, args: []Value) -> ^Object,
  name        : string,
  prototype   : ^Object, // instantiation prototype blueprint
}

Function :: struct {
  env       : ^Object, // closure capture scope environment
  proc_ptr  : proc(env: ^Object, args: []Value) -> Value,
  prototype : ^Object,
}

Generator :: struct {
  env       : ^Object, // scope variables backup
  prototype : ^Object,
  state     : int,     // yield process execution counter
}

List :: struct {
  item_type : typeid, // freezes type validation upon declaration
  items     : [dynamic]Value,
  prototype : ^Object,
}

Map :: struct {
  entries   : map[string]Value,
  prototype : ^Object,
}

Object :: struct {
  properties : map[string]Value,
  prototype  : ^Object, // the foundational base model pointer
}

Queue :: struct {
  items     : [dynamic]Value, // native ringbuffer layout for fifo mechanics
  prototype : ^Object,
}

Record :: struct {
  fields    : map[string]Value,
  prototype : ^Object, // rigid unalterable compile-time map via #{...}
}

RegExp :: struct {
  pattern   : string, // character matching query string
  prototype : ^Object,
}

Set :: struct {
  items     : map[Value]struct{}, // unique collections discarding duplications
  prototype : ^Object,
}

Stack :: struct {
  items     : [dynamic]Value, // native layout for lifo mechanics
  prototype : ^Object,
}

Store :: struct {
  listeners : [dynamic]Value, // event change callback listeners
  prototype : ^Object,
  state     : ^Object,        // reactive observable global state block
}

Tree :: struct {
  children  : [dynamic]^Tree,
  prototype : ^Object,
  value     : Value,
}

Tuple :: struct {
  items : []Value, // fixed heterogeneous size sealed on creation via #(...)
}

// === 4. universal tagged union ===

Value :: union {
  // primitives
  bool,
  Char,
  Color,
  f64,
  i64, // POO Int mapped to native float calculations dynamically
  Null,
  string,
  Symbol,
  time.Time, // POO Date mapped directly to native time module

  // complex heap-allocated objects
  ^Array,
  ^Blob,
  ^Class,
  ^Enum,
  ^Function,
  ^Generator,
  ^List,
  ^Map,
  ^Object,
  ^Pattern,
  ^Queue,
  ^Record,
  ^RegExp,
  ^Set,
  ^Stack,
  ^Store,
  ^Tree,
  ^Tuple,
  ^Union_Type,
}

// === 5. basic inline factory helpers ===

make_char   :: proc (c: rune)   -> Value { return Value(c) }
make_int    :: proc (i: i64)    -> Value { return Value(i) }
make_null   :: proc ()          -> Value { return Value(Null{}) }
make_string :: proc (s: string) -> Value { return Value(s) }

// === 6. example of compact control flow ===

validate_index :: proc (idx: int, length: int) -> bool {
  if (idx < 0 || idx >= length) { return false }
  return true
}
