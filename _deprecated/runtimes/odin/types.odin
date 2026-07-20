package runtime

import "core:mem"
import "core:fmt"
import "core:slice"

// :::::::::::: Built-In Types

Value_Type :: enum {
  Array
  Bool,
  Class,
  Float,
  Function,
  Int,
  List,
  Nil,
  Object,
  String,
  Tuple,
}

// :::::::::::: Forward Declarations (for circular references)

Array    :: struct
Class    :: struct
Function :: struct
List     :: struct
Object   :: struct
Tuple    :: struct

// :::::::::::: Definitions of 'Value'

Value :: struct {
  type: Value_Type,
  data: union {
    nil : struct{},

    // ::: Primitive
    bool   : bool,
    float  : f64,
    int    : i64,
    string : string,
    
    // ::: Complex 
    // ::: (as Pointer so the Union hast fixed Size)
    array    : ^Array,
    class    : ^Class,
    function : ^Function,
    list     : ^List,
    object   : ^Object,
    tuple    : ^Tuple,
  },
}

// :::::::::::: Structure of the Built-Ins

// :::::: The Mother of All Things

Object :: struct {
  prototype  : ^Object,
  properties : map[string]Value,
}

// :::::: Array Like Things 
// :::::: (Indexable Objects)

Array :: struct {
  prototype : ^Object,
  items     : [dynamic]Value,
}

List :: struct {
    prototype : ^Object,
    items     : []Value,       // Slice (fixed size)
    item_type : Value_Type,    // freezes the type once set
    allocator : mem.Allocator, // to be freed
}

Tuple :: struct {
    items: []Value, // seals the length when created
}

// :::::: Function Like Things
// :::::: (Callable Objects with Closure-Environment)
                                      
Function :: struct {
    prototype : ^Object,
    env       : ^Object,  // captured variables (closures)
    proc_ptr  : proc(
      env: ^Object,
      args: []Value
    ) -> Value,
}

// Blueprint for Objects
Class :: struct {
  prototype   : ^Object, // prototype for instances
  name        : string,
  constructor : proc(
    allocator:  mem.Allocator, 
    args     : []Value
  ) -> ^Object,
}

// :::::::::::: The Factories
// :::::::::::: (Helper Methods for Creation of Builtins)

// creates the naked mother object (for the global prototype)
create_base_object :: proc (allocator: mem.Allocator) -> ^Object {
  obj := new (Object, allocator)
  obj.prototype  = nil
  obj.properties = make(map[string]Value, allocator)
  return obj
}

// regular object with prototype
make_object :: proc (allocator: mem.Allocator, prototype: ^Object) -> ^Object {
  obj := new(Object, allocator)
  obj.prototype  = prototype
  obj.properties = make (map[string]Value, allocator)
  return obj
}

// creates
make_array :: proc (allocator: mem.Allocator, prototype: ^Object) -> ^Array {
  arr := new(Array, allocator)
  arr.prototype = prototype
  arr.items = make([dynamic]Value, allocator)
  return arr
}

// LIST // creation (sets type)
make_list :: proc (allocator: mem.Allocator, prototype: ^Object, item_type: Value_Type, initial_capacity: int = 0) -> ^List {
  lst := new (List, allocator)
  lst.prototype = prototype
  lst.item_type = item_type
  lst.allocator = allocator
  lst.items     = make ([]Value, initial_capacity, allocator) // fixed length
  return lst
}

// LIST // assignment (with type check
list_push :: proc(lst: ^List, val: Value) -> bool {
  // type checking
  if val.type != lst.item_type {
    fmt.eprintf("TypeError: List erwartet %v, bekam %v\n", lst.item_type, val.type)
    return false
  }
  // assign items + enlarge slice dynamically
  new_items := slice.append (lst.items, val, lst.allocator) // or via slice.grow ?
  lst.items  = new_items
  return true
}

// LISTE // reading (returns nil on index mismatch)
list_get :: proc (lst: ^List, idx: int) -> Value {
  if idx < 0 || idx >= len(lst.items) { return Value{type = .Nil} }
  return lst.items[idx]
}

// TUPLE // creation (copies values)
make_tuple :: proc (allocator: mem.Allocator, values: []Value) -> ^Tuple {
  tup := new(Tuple, allocator)
  tup.items = make([]Value, len(values), allocator)
  copy (tup.items, values) // copy to prevent change
  return tup
}

// FUNCTION // creation (for closures)
make_function :: proc(
  allocator : mem.Allocator, 
  prototype : ^Object, 
  env       : ^Object, 
  proc_ptr  : proc(
    env  : ^Object, 
    args : []Value
) -> Value ) -> ^Function {
  fn := new (Function, allocator)
  fn.prototype = prototype
  fn.env       = env
  fn.proc_ptr  = proc_ptr
  return fn
}

// CLASS // creation
make_class :: proc(allocator: mem.Allocator, name: string, prototype: ^Object, constructor: proc(allocator: mem.Allocator, args: []Value) -> ^Object) -> ^Class {
  cls := new(Class, allocator)
  cls.name        = name
  cls.prototype   = prototype
  cls.constructor = constructor
  return cls
}

// :::::: Helpers for Primitives

from_bool   :: proc (b: bool)   -> Value { return Value{type = .Bool,   data = {bool   = b}} }
from_int    :: proc (i: i64)    -> Value { return Value{type = .Int,    data = {int    = i}} }
from_float  :: proc (f: f64)    -> Value { return Value{type = .Float,  data = {float  = f}} }
from_string :: proc (s: string) -> Value { return Value{type = .String, data = {string = s}} }
from_nil    :: proc() -> Value { return Value{type = .Nil} }

// :::::: Memory Management

destroy_object :: proc (obj: ^Object, allocator: mem.Allocator) {
  for key, val in obj.properties { delete_key(&obj.properties, key) }
  delete(obj.properties)
  free(obj, allocator)
)

// =============================

// Forward declarations for recursive types

Array    :: struct
Class    :: struct
Function :: struct
List     :: struct
Object   :: struct
Tuple    :: struct

Value :: union {
  // Primitive values
  bool,
  f64,
  i64,
  string,

  // Heap-allocated values
  ^Array,
  ^Class,
  ^Function,
  ^List,
  ^Object,
  ^Tuple,
}

// so konstruiert man dann:

a: Value = true
b: Value = f64(3.14)
c: Value = i64(42)
d: Value = "hello"
e: Value = array_pointer

// und so matcht man

print_value :: proc (value: Value) {
  switch v in value {
    case bool      : fmt.println (v)
    case f64       : fmt.println (v)
    case i64       : fmt.println (v)
    case string    : fmt.println (v)
    case ^Array    : print_array(v)
    case ^Class    : print_class(v)
    case ^Function : print_function(v)
    case ^List     : print_list   (v)
    case ^Object   : print_object (v)
    case ^Tuple    : print_tuple  (v)
    case           : fmt.println ("nil")
  }
}







