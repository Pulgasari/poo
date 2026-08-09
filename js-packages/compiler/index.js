// poo/compiler

// Public API: compile(source) -> { ast, code }. Everything downstream
// (poo/worker, the playground) only ever needs this one function.
//
// Note the two compiles: this package's returns BOTH the AST and the code,
// because the playground displays the tree alongside the output. Cosmonaut's
// own compiler.compile() returns just the string, and is re-exported below
// under its stage names for anyone who wants one step at a time.

// :::::: IMPORT

import Cosmonaut from '@cosmonaut/compiler';
import target    from './codegen.js';
import spec      from './lsd.js';

// :::::: CONSTRUCT

const compiler = new Cosmonaut ({ spec, target });

// Bound on the instance, so destructuring keeps them working
// - that is how the Service Worker receives just the piece it needs.
const { generate, parse, tokenize } = compiler;

function compile (source) {
  const ast  = parse(source);
  const code = generate(ast);
  return { ast, code };
}

// :::::: EXPORT

export {
  compiler,
  compile,
  generate,
  parse,
  tokenize,
}

export default compile;
