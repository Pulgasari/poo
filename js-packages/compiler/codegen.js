// poo/compiler/codegen.js

// Translates poo AST nodes (produced by @cosmonaut/lsd's compiled parser
// methods, see parser.js) into JavaScript source text. This is entirely
// poo/compiler's own responsibility - @cosmonaut/lsd only takes source
// text to AST, nothing more (see its readme).
//
// Runtime-backed literals (Record/Tuple/List/Array) compile to a call
// against `poo.makeArrayLike(...)`, matching the namespace import style
// codegen emits at the top of every generated file:
//   import * as poo from 'poo/runtime';
//
// KNOWN LIMITATION (inherited from poo.lsd itself): BinaryExpression
// currently only ever has a single "left OPERATOR right" pair (parsing
// doesn't support chained/precedence-climbing expressions yet - see
// poo.lsd's own comment on the BinaryExpression block). genBinaryExpr
// still uses the full precedence-aware machinery below so that nothing
// here needs to change once that parsing limitation is lifted.

import Generator, { concat, text, indent, hardline, joinMap, print, genBinaryExpr as genBinaryExprHelper } from '@cosmonaut/generator';
import lsd from './lsd.js';

const operatorConfig = Object.fromEntries(
  lsd.meta.tables.operators.rows.flatMap(row =>
    (row.symbols ?? []).map(symbol => [symbol, {
      precedence: Number(row.precedence) || 0,
      associativity: row.associativity === 'right' ? 'right' : 'left',
    }])
  )
);

const isBinaryExpr = node => node?.type === 'BinaryExpr';

const RUNTIME_IMPORT_HEADER = "import * as poo from 'poo/runtime';";

const methods = {
  genIDENTIFIER : (g, node) => text(node.value),
  genNUMBER     : (g, node) => text(node.value),
  genSTRING     : (g, node) => text(node.value),
  genLITERAL    : (g, node) => text(node.value),

  genValDecl : (g, node) => concat(
    text('let '),
    text(node.name.value),
    text(' = '),
    g.genNode(node.value),
    text(';'),
  ),

  genObjDecl : (g, node) => concat(
    text(node.name.value),
    text(' = poo.makeObject('),
    g.genNode(node.body),
    text(');'),
  ),

  genFnDecl : (g, node) => concat(
    text('function '), text(node.identifier.value),
    text('('), joinMap(node.args ?? [], text(', '), a => text(a.value)), text(') {'),
    indent(concat(hardline, joinMap(node.body, hardline, stmt => g.genNode(stmt)))),
    hardline, text('}'),
  ),

  genExprStatement : (g, node) => concat(g.genNode(node.expression), text(';')),

  genBinaryExpr : (g, node) => g.genBinaryExprHelper(node, {
    getOperator : n => n.operator.value,
    getLeft     : n => n.left,
    getRight    : n => n.right,
    operators   : operatorConfig,
    isBinary    : isBinaryExpr,
    genOperand  : (gg, n) => gg.genNode(n),
  }),

  genFnCall : (g, node) => {
    const argsNode = node.args;
    const argsDoc  = Array.isArray(argsNode)
      ? g.genList(argsNode, { wrapper: '()' })
      : concat(text('('), g.genNode(argsNode), text(')'));
    return concat(text(node.callee.value), argsDoc);
  },

  genExprArgsList  : (g, node) => g.genList(node.items, { wrapper: null }),
  genNamedArgsList : (g, node) => g.genList(node.args,  { wrapper: '{}' }),
  genNamedPropDecl : (g, node) => concat(text(node.key.value), text(': '), g.genNode(node.value)),

  genArrayLikeLiteral : (g, node) => {
    const elementsDoc = !node.elements
      ? (node.kind === 'Record' ? text('{}') : text('[]'))
      : node.elements.type === 'NamedArgsList'
        ? g.genNode(node.elements)
        : concat(text('['), g.genList(node.elements.items, { wrapper: null }), text(']'));

    return concat(text('poo.makeArrayLike('), text(`'${node.kind}', `), elementsDoc, text(')'));
  },
};

const generator = new Generator({ methods });

export function generateProgram (statements) {
  const bodyDoc = concat(...statements.map((stmt, i) => i === 0 ? generator.genNode(stmt) : concat(hardline, generator.genNode(stmt))));
  const     doc = concat(text(RUNTIME_IMPORT_HEADER), hardline, hardline, bodyDoc, hardline);
  return print(doc);
}

export { generator };
export default generator;
