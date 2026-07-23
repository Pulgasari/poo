// runtimes/odin/_internal.odin
package runtime

import "core:mem"
import "core:fmt"
import "core:strings"
import "core:slice"

// Helpers to reduce Odin Boilerplate

// Angenommene Strukturen basierend auf deinem Code
Value :: struct {
    type: Type_Enum,
    data: Value_Data,
}

Type_Enum :: enum {
    Function,
    // ... andere Typen
}

Value_Data :: struct #raw_union {
    function: ^Function_Obj, // oder wie auch immer deine Struktur heißt
}

Object :: struct {
    properties: map[string]Value,
}
