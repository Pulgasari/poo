// @poo/runtime

// Public runtime API. Generated code imports this wholesale:
//   import * as poo from 'poo/runtime';
// (see poo/worker for how the "poo/runtime" specifier gets resolved in
// the browser - via an import map, not by this package itself.)

export { Record, isRecord } from './types/record.js';
export { Tuple, isTuple }   from './types/tuple.js';
export { List, isList }     from './types/list.js';
export { makeArray }        from './types/array.js';
export { makeArrayLike }    from './helpers.js';


//
//export { default as Enum   } from './types/Enum.js';
//export { default as List   } from './types/List.js';
//export { default as Record } from './types/Record.js';
//export { default as Struct } from './types/Struct.js';
//export { default as Tuple  } from './types/Tuple.js';
//export { default as Union  } from './types/Union.js';
