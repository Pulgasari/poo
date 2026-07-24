# poo/runtimes

**Poo** is designed with a multi-target execution model. High-level standard library features are written directly in Poo (`stdlib/*.poo`), while low-level execution primitives, memory allocation, and OS interfaces are handled by platform-specific runtimes.

---

## Architecture Overview

1. **Core Standard Library (`stdlib/`)**: Defines data type methods, string manipulations, and utility utilities in Poo syntax.
2. **Runtime Binding Layer (`runtimes/`)**: Bridges Poo's object environment (`Object`, `Value`, prototypes) with native hardware or web platforms.

---

## Poo for Native / Desktop (Odin)

The primary native desktop runtime for Poo is built on **Odin** (`runtimes/odin/`). 

* **Performance & Memory:** Leverages Odin's explicit memory management, custom allocators, and fast UTF-8 rune and slice operations.
* **Low-Level Primitives:** Type bindings (e.g., `runtimes/odin/types/string.odin`) provide the underlying memory layout and performance-critical operations.
* **Compilation Pipeline:** Poo code and standard library modules are compiled down to Odin procedures and transpiled directly into standalone native binaries.

```poo
// Native execution model
stdlib/*.poo + user_script.poo  --> Poo Compiler --> Odin Code --> Native Binary
```

---

## Poo for the Web (JavaScript)

The web target enables Poo applications and scripts to execute directly in browser and ECMAScript environments.

* **Target Output:** Transpiles Poo syntax into clean JavaScript code or WebAssembly modules.
* **Web Integration:** Shares the same standard library interfaces (`stdlib/`) as the native target, mapped onto JS runtime primitives.
* **Browser Tooling:** Powers client-side execution, interactive documentation sandboxes, and web playgrounds without backend compilation servers.

---

## Execution Environment Matrix

| Target Platform | Runtime Backend | Output Type | Primary Use Case |
| :--- | :--- | :--- | :--- |
| **Desktop / Server** | Odin (`runtimes/odin/`) | Native Binary | CLI tools, desktop apps, high-performance services |
| **Web / Browser** | JavaScript (`runtimes/js/`) | JS / WASM | Interactive web apps, documentation playgrounds |


