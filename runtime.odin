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
    
    // ::: Complex (as Pointer so the Union hast fixed Size)
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

