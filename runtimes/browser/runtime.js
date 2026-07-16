// runtime.js
// Reine ES-Module – läuft im Browser und im Worker.

// ---------- Typ-Enum ----------
export const ValueType = Object.freeze({
    Nil: 'Nil',
    Bool: 'Bool',
    Int: 'Int',
    Float: 'Float',
    String: 'String',
    Object: 'Object',
    Array: 'Array',
    List: 'List',
    Tuple: 'Tuple',
    Function: 'Function',
    Class: 'Class',
});

// ---------- Value Wrapper ----------
export class Value {
    constructor(type, data) {
        this.type = type;
        this.data = data; // Kann bool, number, string, oder Objekt-Zeiger sein
    }
    static nil    ( ) { return new Value(ValueType.Nil, null); }
    static bool   (b) { return new Value(ValueType.Bool, b); }
    static int    (i) { return new Value(ValueType.Int, Number(i)); }
    static float  (f) { return new Value(ValueType.Float, Number(f)); }
    static string (s) { return new Value(ValueType.String, s); }
}

// ---------- Das Ur-Objekt (Root-Prototyp) ----------
export const GLOBAL_PROTOTYPE = new (class RootObject {})();

// ---------- MyObject (Basis aller komplexen Dinge) ----------
export class MyObject {
    constructor(prototype = GLOBAL_PROTOTYPE) {
        this.prototype = prototype;
        this.properties = new Map();
    }
    get(key) { return this.properties.get(key); }
    set(key, val) { this.properties.set(key, val); }
}

// ---------- MyArray (Indexable, dynamisch) ----------
export class MyArray extends MyObject {
    constructor(prototype = GLOBAL_PROTOTYPE) {
        super(prototype);
        this.items = [];
    }
    push(val) { this.items.push(val); }
    get(index) { return this.items[index] || Value.nil(); }
    set(index, val) { this.items[index] = val; }
    get length() { return this.items.length; }
}

// ---------- MyList (Typsicher, flach, unveränderliche Länge) ----------
export class MyList extends MyObject {
    constructor(itemType, initialItems = [], prototype = GLOBAL_PROTOTYPE) {
        super(prototype);
        this.itemType = itemType;
        this.items = [...initialItems];
        // Typprüfung
        for (const v of this.items) {
            if (v.type !== itemType) throw new Error(`TypeError: List erwartet ${itemType}, bekam ${v.type}`);
        }
    }
    push(val) {
        if (val.type !== this.itemType) throw new Error(`TypeError: List erwartet ${this.itemType}, bekam ${val.type}`);
        this.items.push(val);
    }
    get(index) { return this.items[index] || Value.nil(); }
    get length() { return this.items.length; }
}

// ---------- MyTuple (Unveränderlich, feste Länge) ----------
export class MyTuple {
    constructor(values) {
        this.items = [...values]; // Kopie, unveränderlich
        this.length = this.items.length;
        Object.freeze(this.items); // Schützt vor Mutation
    }
    get(index) { return this.items[index] || Value.nil(); }
}

// ---------- MyFunction (Callable mit Closure) ----------
export class MyFunction extends MyObject {
    constructor(procPtr, env = GLOBAL_PROTOTYPE, prototype = GLOBAL_PROTOTYPE) {
        super(prototype);
        this.env = env;
        this.procPtr = procPtr;
    }
    call(args) {
        return this.procPtr(this.env, args);
    }
}

// ---------- MyClass (Bauplan für Objekte) ----------
export class MyClass extends MyObject {
    constructor(name, constructorFn, prototype = GLOBAL_PROTOTYPE) {
        super(prototype);
        this.name = name;
        this.constructorFn = constructorFn;
        this.instancePrototype = prototype; // Der Prototyp für neue Instanzen
    }
    new(args) {
        return this.constructorFn(this.instancePrototype, args);
    }
}

// ---------- Factory-Helfer (für generierten Code) ----------
export function makeObject(prototype = GLOBAL_PROTOTYPE) {
    return new MyObject(prototype);
}
export function makeArray(prototype = GLOBAL_PROTOTYPE) {
    return new MyArray(prototype);
}
export function makeList(itemType, initialItems = [], prototype = GLOBAL_PROTOTYPE) {
    return new MyList(itemType, initialItems, prototype);
}
export function makeTuple(values) {
    return new MyTuple(values);
}
export function makeFunction(procPtr, env = GLOBAL_PROTOTYPE, prototype = GLOBAL_PROTOTYPE) {
    return new MyFunction(procPtr, env, prototype);
}
export function makeClass(name, constructorFn, prototype = GLOBAL_PROTOTYPE) {
    return new MyClass(name, constructorFn, prototype);
}

// Primitives als Values
export const fromBool   = Value.bool;
export const fromInt    = Value.int;
export const fromFloat  = Value.float;
export const fromString = Value.string;
export const fromNil    = Value.nil;

