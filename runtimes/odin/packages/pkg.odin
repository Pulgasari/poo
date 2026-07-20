package pkg

import "../types"
import "./audio"
import "./db"
import "./fs"
import "./img"
import "./io"
import "./md"
import "./url"
import "./video"

// === stdlib registration ===

register_stdlib :: proc (global_scope: ^types.Object, allocator := context.allocator) {
  global_scope.properties["audio"] = types.Value( audio.init_package(allocator))
  global_scope.properties["db"]    = types.Value(    db.init_package(allocator))
  global_scope.properties["fs"]    = types.Value(    fs.init_package(allocator))
  global_scope.properties["img"]   = types.Value(   img.init_package(allocator))
  global_scope.properties["io"]    = types.Value(    io.init_package(allocator))
  global_scope.properties["md"]    = types.Value(    md.init_package(allocator))
  global_scope.properties["url"]   = types.Value(   url.init_package(allocator))
  global_scope.properties["video"] = types.Value( video.init_package(allocator))
}
