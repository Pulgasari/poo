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

