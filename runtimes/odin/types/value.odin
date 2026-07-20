package types

import "core:mem"
import "core:time"

// ======= MAYBE RENAME ======
// Map + Set
// Record
// ===========================

// =============================================================================
// 1. PRIMITIVE DATENTYPEN (Werden direkt wertbasiert in der Union gespeichert)
// =============================================================================

Null   :: struct{} // Der speicherlose Platzhalter für das 'null' aus Poo
Char   :: rune     // In Odin ist 'rune' ein 4-Byte Unicode-Zeichen (perfekt für Char)

Color :: struct {
  rgba : u32,     // Packt HEX/Alpha nativ in 4 Bytes (z.B. 0xFFFF00FF)
}

Symbol :: struct {
  id   : u64,     // Eindeutige ID für die Unveränderlichkeit
  name : string,  // Debug-Name des Symbols
}

// =============================================================================
// 2. REZEPTE & BLUEPRINTS (Metadaten für das Typsystem)
// =============================================================================

Enum :: struct {
  name:     string,
  variants: map[string]Value,
}

Pattern :: struct {
  // Layout-Regeln für das Pattern Matching (~=)
}

Union_Type :: struct {
  allowed_types: [dynamic]typeid, // Welche Odin/Poo-Typen sind erlaubt?
}



// =============================================================================
// 3. KOMPLEXE SPEICHER-STRUKTUREN (Werden als Pointer ^ in der Union verwaltet)
// =============================================================================

// Die Mutter aller Objekte in Poo
Object :: struct {
    prototype:  ^Object,
    properties: map[string]Value,
}

Array :: struct {
    prototype: ^Object,
    items:     [dynamic]Value,
}

List :: struct {
    prototype: ^Object,
    items:     [dynamic]Value,
    item_type: typeid,         // Friert den Typ bei der Erstellung ein
}

Tuple :: struct {
    items: []Value,            // Einmal allokiert, Länge unveränderlich
}

Record :: struct {
    prototype: ^Object,        // rigid/unveränderliche map via #{...}
    fields:    map[string]Value,
}

Map :: struct {
    prototype: ^Object,
    // Da Poo-Keys dynamisch sein können, ist das später oft eine Custom-Struktur.
    // Für den Anfang reicht ein String-Key-Verzeichnis:
    entries:   map[string]Value, 
}

Blob :: struct {
    prototype: ^Object,
    bytes:     [dynamic]byte,  // Rohe Binärdaten
}

// =============================================================================
// 4. DATENSTRUKTUREN & BEHALTEN (Algorithmen)
// =============================================================================

Queue :: struct {
    prototype: ^Object,
    items:     [dynamic]Value, // Ringpuffer oder dynamisches Array für FIFO
}

Stack :: struct {
    prototype: ^Object,
    items:     [dynamic]Value, // LIFO Mechanics
}

Tree :: struct {
    prototype: ^Object,
    value:     Value,
    children:  [dynamic]^Tree,
}

// =============================================================================
// 5. REAKTIVE & STREAMING TYPEN
// =============================================================================

Generator :: struct {
    prototype: ^Object,
    env:       ^Object,        // Scope-Variablen-Sicherung
    state:     int,            // Wo im Yield-Prozess steht er?
}

Store :: struct {
    prototype: ^Object,
    state:     ^Object,        // Der überwachte Zustand
    listeners: [dynamic]Value, // Callback-Funktionen bei Änderungen
}

RegExp :: struct {
    prototype: ^Object,
    pattern:   string,         // Der Regex-Suchstring
}

// =============================================================================
// 6. DIE UNIVERSELLE VALUE-UNION (Das Herz deiner Runtime)
// =============================================================================

Value :: union {
    // Primitiv-Werte (direkt auf dem Stack/in der Union)
    Null,
    bool,
    Char,
    i64,         // Int in Poo (via Number-Logik)
    f64,         // Float in Poo (via Number-Logik)
    Color,
    string,      // In Odin sind Strings 16 Byte groß (Pointer + Länge)
    Symbol,
    time.Time,   // Date wird direkt über Odins natives Time-Modul abgebildet!

    // Pointer auf komplexe Heap-Objekte (Größe immer exakt 8 Byte für den Pointer)
    ^Object,
    ^Array,
    ^List,
    ^Tuple,
    ^Record,
    ^Map,
    ^Blob,
    ^Queue,
    ^Stack,
    ^Tree,
    ^Generator,
    ^Store,
    ^RegExp,
    ^Enum,
    ^Union_Type,
    ^Pattern,
}
