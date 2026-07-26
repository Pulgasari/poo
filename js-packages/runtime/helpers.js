// poo/runtime/helpers.js

// Entry points generated code calls directly. makeArrayLike() is the
// single dispatcher ArrayLikeLiteral's "kind" tag ("Record"/"Tuple"/
// "List"/"Array") routes through, so codegen.js only needs to emit one
// call shape regardless of which literal form was written.

import { makeArray } from './types/array.js';

import List   from './types/list.js';
import Record from './types/record.js';
import Tuple  from './types/tuple.js';


export function makeArrayLike (kind, elements) {
  switch (kind) {
    case 'Record' : return new Record(elements); // elements is already a plain object (from codegen's NamedArgsList -> "{...}")
    case 'Tuple'  : return new Tuple(elements);
    case 'List'   : return new List(elements);
    case 'Array'  : return makeArray(elements);
    default       : throw new Error(`[poo/runtime] Unknown array-like kind: "${kind}"`);
  }
}
