// @poo/runtimes/browser/runtime.js

// ---------- Typ-Enum ----------
export const ValueType = Object.freeze({
  Array    : 'Array',
  Bool     : 'Bool',
  Class    : 'Class',
  Float    : 'Float',
  Function : 'Function',
  Int      : 'Int',
  List     : 'List',
  Null     : 'Nulll',
  Object   : 'Object',
  String   : 'String',
  Tuple    : 'Tuple',
});

// ---------- Value Wrapper ----------
export class Value {
  constructor (type, data) {
    this.data = data; // Kann bool, number, string, oder Objekt-Zeiger sein
    this.type = type;
  }
  
  static bool   (b) { return new Value(ValueType.Bool,   b);         }
  static float  (f) { return new Value(ValueType.Float,  Number(f)); }
  static int    (i) { return new Value(ValueType.Int,    Number(i)); }
  static null   ( ) { return new Value(ValueType.Null,   null);      }
  static string (s) { return new Value(ValueType.String, s);         }
}

// ---------- Das Ur-Objekt (Root-Prototyp) ----------
export const GLOBAL_PROTOTYPE = new (class RootObject {})();

// ---------- MyObject (Basis aller komplexen Dinge) ----------
export class PooObject {
  constructor(prototype = GLOBAL_PROTOTYPE) {
    this.properties = new Map;
    this.prototype  = prototype;
  }
  get (key)      { return this.properties.get(key);      }
  set (key, val) {        this.properties.set(key, val); }
}

// ---------- MyArray (Indexable, dynamisch) ----------
export class PooArray extends PooObject {
  constructor (prototype = GLOBAL_PROTOTYPE) {
    super(prototype);
    this.items = [];
  }
  push (val)        { this.items.push(val); }
  get  (index)      { return this.items[index] || Value.null(); }
  set  (index, val) {        this.items[index] = val; }
  get  length ()    { return this.items.length; }
}

// ---------- MyList (Typsicher, flach, unveränderliche Länge) ----------
export class PooList extends PooObject {
  constructor (itemType, initialItems = [], prototype = GLOBAL_PROTOTYPE) {
    super(prototype);
    this.itemType = itemType;
    this.items = [...initialItems];
    // Typprüfung
    for (const v of this.items) {
      if (v.type !== itemType) throw new Error(`TypeError: List erwartet ${itemType}, bekam ${v.type}`);
    }
  }
  push (val) {
    if (val.type !== this.itemType) throw new Error(`TypeError: List erwartet ${this.itemType}, bekam ${val.type}`);
    this.items.push(val);
  }
  get (index)   { return this.items[index] || Value.null(); }
  get length () { return this.items.length; }
}

// ---------- MyTuple (Unveränderlich, feste Länge) ----------
export class PooTuple {
  constructor(values) {
    this.items  = [...values]; // Kopie, unveränderlich
    this.length = this.items.length;
    Object.freeze(this.items); // Schützt vor Mutation
  }
  get (index) { return this.items[index] || Value.null(); }
}

// ---------- MyFunction (Callable mit Closure) ----------
export class PooFunction extends PooObject {
  constructor (procPtr, env = GLOBAL_PROTOTYPE, prototype = GLOBAL_PROTOTYPE) {
    super(prototype);
    this.env     = env;
    this.procPtr = procPtr;
  }
  call (args) {
    return this.procPtr(this.env, args);
  }
}

// ---------- MyClass (Bauplan für Objekte) ----------
export class PooClass extends PooObject {
  constructor (name, constructorFn, prototype = GLOBAL_PROTOTYPE) {
    super(prototype);
    this.name              = name;
    this.constructorFn     = constructorFn;
    this.instancePrototype = prototype; // Der Prototyp für neue Instanzen
  }
  new (args) {
    return this.constructorFn(this.instancePrototype, args);
  }
}

// ---------- Factory-Helfer (für generierten Code) ----------
export function makeObject (prototype = GLOBAL_PROTOTYPE) {
  return new PooObject(prototype);
}
export function makeArray (prototype = GLOBAL_PROTOTYPE) {
  return new PooArray(prototype);
}
export function makeList (itemType, initialItems = [], prototype = GLOBAL_PROTOTYPE) {
  return new PooList(itemType, initialItems, prototype);
}
export function makeTuple (values) {
  return new PooTuple(values);
}
export function makeFunction (procPtr, env = GLOBAL_PROTOTYPE, prototype = GLOBAL_PROTOTYPE) {
  return new PooFunction(procPtr, env, prototype);
}
export function makeClass (name, constructorFn, prototype = GLOBAL_PROTOTYPE) {
  return new PooClass(name, constructorFn, prototype);
}

// Primitives als Values
export const fromBool   = Value.bool;
export const fromInt    = Value.int;
export const fromFloat  = Value.float;
export const fromString = Value.string;
export const fromNull   = Value.null;




// runtime.js (Erweiterung)

// String-Prototyp (kein JS-Prototyp, sondern dein eigenes System)
const stringPrototype = new PooObject (GLOBAL_PROTOTYPE);

// Methoden definieren
stringPrototype.set ('length', new PooFunction((env, args) => {
  const str = args[0]?.data || '';
  return fromInt(str.length);
}));

stringPrototype.set('trim', new PooFunction ((env, args) => {
  const str = args[0]?.data || '';
  return fromString(str.trim());
}));

// Autoboxing für Strings
function boxString (str) {
  const obj = new MyObject(stringPrototype);
  obj.set('__value', fromString(str));
  return obj;
}

// Methodenaufruf auf geboxtem Wert
function callMethod(obj, methodName, args) {
    const method = obj.get(methodName);
    if (!method || method.type !== ValueType.Function) {
        throw new Error(`Method ${methodName} not found`);
    }
    const raw = obj.get('__value');
    return method.call([raw, ...args]);
}

