// poo/compiler

// Public API: compile(source) -> { ast, code }. Everything downstream
// (poo/worker) only ever needs this one function.

import Parser from '@cosmonaut/parser';
import { generateProgram } from './codegen.js';
import { createLexer }     from './lexer.js';
import { methods }         from './parser.js';

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
