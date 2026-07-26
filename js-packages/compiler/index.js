// poo/compiler

// Public API: compile(source) -> { ast, code }. Everything downstream
// (poo/worker) only ever needs this one function.

import Parser from '@cosmonaut/parser';
import { generateProgram } from './codegen.js';

import { createLexer }     from './lexer.js';
import { methods }         from './parser.js';

// :::::: LSD
// Loads poo.lsd via fetch (relative to this module's own location) and
// parses it once, sharing the resulting intermediate representation
// between lexer.js/parser.js/codegen.js. Fetch, not a bundled/embedded
// string constant or fs access - this package runs inside a browser
// Service Worker (see poo/worker), where fetch is the natural way to
// load a co-located resource, and fs isn't available at all.
// -------------------
// Uses top-level await: consumers can still write a plain
// `import lsd from './lsd.js'` without needing async/await themselves -
// the module system resolves this automatically, since any module that
// imports an async module waits for it to settle before continuing.
import { parseLSD } from '@cosmonaut/lsd';
const response = await fetch(new URL('./poo.lsd', import.meta.url));
if (!response.ok) throw new Error(`[poo/compiler] Failed to load poo.lsd: ${response.status} ${response.statusText}`);
const source = await response.text();
export default parseLSD(source);

// :::::: LEXER
import { compileTokenizer } from '@cosmonaut/lsd';
import lsd from './lsd.js';
export const createLexer = compileTokenizer(lsd);

// :::::: PARSER
import { compileParserMethods } from '@cosmonaut/lsd';
import lsd from './lsd.js';
export const methods = compileParserMethods(lsd);

// :::::: COMPILER
export function compile (source) {
  const tokens = createLexer(source).tokenize();
  const parser = new Parser(tokens, { methods, entry: 'Program' });
  const ast    = parser.run();

  // Program compiles to `many(Statement)`, which - like every plain
  // `many`/`many0` - NEVER fails: it silently stops and returns whatever
  // it collected so far the moment the next Statement fails to match,
  // without raising an error. Without this check, a syntax error deep in
  // the source (or any construct simply not yet covered by poo.lsd,
  // including plain JS syntax accidentally mixed in) would silently
  // produce a truncated AST instead of a clear parse error.
  if (!parser.eof()) {
    const token = parser.peek();
    throw new SyntaxError(
      `[poo] Unexpected input at ${token?.line ?? '?'}:${token?.column ?? '?'} ` +
      `(near "${token?.value ?? ''}") - stopped after parsing ${ast.length} statement(s).`
    );
  }

  const code = generateProgram(ast);

  return { ast, code };
}
