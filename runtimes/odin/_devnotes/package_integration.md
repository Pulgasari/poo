# POO Language Architecture: FFI & Package Integration Blueprint

This document serves as a technical reference blueprint for the POO programming language architecture, detailing how the language interfaces with foreign ecosystems (Odin and C) using either an interpreted or a compiled (transpiled) model.

---

## 1. The Core Challenge of FFI
A Foreign Function Interface (FFI) bridges two different execution worlds. The primary challenges when bridging a custom language with native compiled code (C/Odin) are:
* **Compilation Barrier:** Native code is compiled into machine instructions. An execution engine must know how to locate and invoke these raw memory addresses.
* **Data Layout (Marshalling):** Custom dynamic types (like the POO `Value` union) must be translated into flat, raw CPU primitives (like standard `i32` or `cstring`) and vice-versa.

---

## 2. Scenario A: The Interpreted Approach
If POO runs as an interactive runtime interpreter (like Node.js or Python), it evaluates source files line-by-line at runtime. To connect external packages, it must use one of two methods:

### Method 1: Static Bridges (AOT Bindings)
The runtime creator manually writes wrappers inside the interpreter source code.
* **Mechanism:** You import the C or Odin package directly into your Odin runtime, wrap the logic inside a standard POO host function signature, and recompile the interpreter executable.
* **Trade-off:** Extremely fast and secure, but rigid. End-users cannot add custom libraries without modifying the interpreter's core source code.

### Method 2: Dynamic Bridges (Plugins / Shared Libraries)
The interpreter loads pre-compiled binaries (`.dll`, `.so`, `.dylib`) dynamically during execution.
* **Mechanism:** The runtime uses dynamic loading mechanics to map system symbols and translate types on the fly.
* **Odin Implementation Example:**
```odin
package runtime

import "core:dynlib"
import "types"

C_Library :: struct {
  handle   : dynlib.Library,
  lib_path : string,
}

// load compiled native binary at runtime
load_plugin :: proc (path: string) -> (C_Library, bool) {
  lib, ok := dynlib.load_library(path)
  if (!ok) { return C_Library{}, false }
  return C_Library{ handle = lib, lib_path = path }, true
}

// resolve symbol and execute with dynamic unboxing
call_native_add :: proc (lib: C_Library, symbol: string, a: i64, b: i64) -> i64 {
  proc_ptr := dynlib.symbol_address(lib.handle, symbol)
  if (proc_ptr == nil) { return 0 }

  // cast to native c convention signature
  c_func := cast(proc "c" (c_a: i32, c_b: i32) -> i32)proc_ptr
  return i64(c_func(i32(a), i32(b)))
}
```

---

## 3. Scenario B: The Compiled / Transpiled Approach
When POO acts as a transcompiler, it translates `.poo` source code into valid `.odin` text files. The actual machine compilation is offloaded to the native Odin compiler (`odin build`). This eliminates all runtime FFI costs.

### Mechanism 1: Mirroring Imports
When the POO compiler encounters an import statement, it writes the corresponding target import block directly into the output file.
* **POO Source:**
  ```poo
  import pkg::odin("core:fmt")
  import pkg::c("header:sqlite3", "lib:sqlite3.lib")
  ```
* **Generated Odin Output:**
  ```odin
  package main

  import "core:fmt"

  foreign import sqlite3 "lib:sqlite3.lib"
  foreign sqlite3 {
    sqlite3_open :: proc(filename: cstring, ppDb: ^^sqlite3_ctx) -> i32 ---
  }
  ```

### Mechanism 2: Zero-Cost Function Delegation
Calls are converted directly into native instructions. There is no boxing or unboxing inside an evaluation loop.
* **POO Source:** `fmt.println("hello")`
* **Generated Odin Output:** `fmt.println("hello")`

### Mechanism 3: Compile-Time Marshalling
Instead of evaluating types at runtime, the POO compiler generates the structural conversion code into the output stream during the compilation phase.
* **POO Transpiler Implementation Example:**
```odin
package compiler

import "core:fmt"
import "core:strings"

// translate print statement to native target code
compile_print :: proc (var_name: string, sb: ^strings.Builder) {
  fmt.sbprintf(sb, "  fmt.println(%s)\n", var_name)
}

// generate type conversion code at compile time
compile_c_string_call :: proc (func: string, arg: string, sb: ^strings.Builder) {
  fmt.sbprintf(sb, "  %s(strings.clone_to_cstring(%s))\n", func, arg)
}
```

---

## 4. Architectural Comparison Matrix

| Feature | Interpreted Runtime | Compiled (Transpiled) Runtime |
| :--- | :--- | :--- |
| **Execution Performance** | Slower (runtime tag checks & virtual loops) | Maximum Native (compiled to machine code) |
| **FFI Calling Overhead** | High (requires data unboxing and libffi) | Zero (direct CPU branch instruction) |
| **Development Workflow** | Interactive (instant scripting / repl) | Ahead-of-Time (requires a compile step) |
| **System Dependencies** | Standalone interpreter binary | Requires target compiler (`odin`) on system |
| **Type Validation** | Runtime assertions | Type-checked during code generation |

---

## 5. Conclusion & Recommendation for POO
For a modern language emphasizing rigid types, high performance, and deep integration, **The Compiled (Transpiler) Approach** is highly superior:
1. It bypasses the complexity of building a custom dynamic JIT or FFI engine.
2. It allows POO developers to seamlessly treat any existing C or Odin library as a first-class citizen with absolute zero runtime performance cost.
3. It leverages Odins highly optimized backend compiler for code generation, optimization, and platform targeting.
