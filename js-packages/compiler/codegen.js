// poo/compiler/codegen.js

// The JavaScript target: poo AST -> JS source text.
//
// A target is a FUNCTION OF THE SPEC, not a standalone module. Which
// language this is (poo.lsd) and what it compiles to (this file) are two
// separate axes - one spec, many targets - so this file receives the spec
// rather than loading it, and never imports lsd.js.
//
// Runtime-backed literals (Record/Tuple/List/Array) compile to a call
// against `poo.makeArrayLike(...)`, matching the namespace import emitted
// at the top of every generated file.
//
// NAMING: poo.lsd has a node type literally named "BinaryExpr", and the
// Generator's own precedence-climbing helper is also called genBinaryExpr.
// They do not collide because built-in patterns live under `g.$` while
// registered node methods live on `g` directly - always call the helper as
// g.$.genBinaryExpr(...), never g.genBinaryExpr(...).
//
// KNOWN LIMITATION (inherited from poo.lsd): BinaryExpr only ever holds a
// single "left OPERATOR right" pair - the grammar has no precedence
// climbing yet. The helper below is already precedence-aware, so nothing
// here needs to change once that is lifted.

import { concat, hardline, indent, joinMap, text } from '@cosmonaut/layouter';

const RUNTIME_IMPORT = "import * as poo from 'poo/runtime';";
const isBinaryExpr   = node => node?.type === 'BinaryExpr';

// A Block production yields a plain array of statements, not a node.
const genBody = (g, statements) => joinMap(statements ?? [], hardline, statement => g.genNode(statement));

export default function jsTarget (spec) {

  // The META TABLE in poo.lsd is the single source of truth for precedence
  // and associativity - reading it here means the two can never drift.
  const operators = Object.fromEntries(
    spec.document.meta.tables.operators.rows.flatMap(row =>
      (row.symbols ?? []).map(symbol => [symbol, {
        precedence    : Number(row.precedence) || 0,
        associativity : row.associativity === 'right' ? 'right' : 'left',
      }])
    )
  );

  return {

    layout : { width: 80, indentSize: 2 },

    // Program is a transparent production, so parse() yields an array of
    // statements rather than a single node. The preamble and the joining
    // between top-level statements belong here, not in a gen* method.
    entry : (g, statements) => concat(
      text(RUNTIME_IMPORT),
      hardline,
      hardline,
      genBody(g, statements),
      hardline,
    ),

    methods : {

      // :::::: Terminals

      genIDENTIFIER : (g, node) => text(node.value),
      genNUMBER     : (g, node) => text(node.value),
      genSTRING     : (g, node) => text(node.value),
      genLITERAL    : (g, node) => text(node.value),

      // :::::: Declarations

      genValDecl : (g, node) => concat(
        text('let '),
        text(node.name.value),
        text(' = '),
        g.genNode(node.value),
        text(';'),
      ),

      genObjDecl : (g, node) => concat(
        text(node.name.value),
        text(' = poo.makeObject({'),
        indent(concat(hardline, genBody(g, node.body))),
        hardline, text('});'),
      ),

      genFnDecl : (g, node) => concat(
        text('function '), text(node.identifier.value),
        text('('), joinMap(node.args ?? [], text(', '), arg => text(arg.value)), text(') {'),
        indent(concat(hardline, genBody(g, node.body))),
        hardline, text('}'),
      ),

      // :::::: Statements

      genExprStatement : (g, node) => concat(g.genNode(node.expression), text(';')),

      // :::::: Expressions

      genBinaryExpr : (g, node) => g.$.genBinaryExpr(node, {
        operators,
        getOperator : n => n.operator.value,
        getLeft     : n => n.left,
        getRight    : n => n.right,
        isBinary    : isBinaryExpr,
        genOperand  : (gg, n) => gg.genNode(n),
      }),

      // args is either a ParenCallArgs (a CallArgsList node, or null for
      // "f()") or a SingleBareArg token.
      genFnCall : (g, node) => {
        const args = node.args == null
          ? text('()')
          : Array.isArray(node.args)
            ? g.$.genList(node.args, { wrapper: '()' })
            : concat(text('('), g.genNode(node.args), text(')'));

        return concat(text(node.callee.value), args);
      },

      // :::::: Arguments

      genExprArgsList  : (g, node) => g.$.genList(node.items, { wrapper: null }),
      genNamedArgsList : (g, node) => g.$.genList(node.args,  { wrapper: '{}' }),
      genNamedPropDecl : (g, node) => concat(text(node.key.value), text(': '), g.genNode(node.value)),

      // :::::: Literals

      genArrayLikeLiteral : (g, node) => {
        const elements = !node.elements
          ? (node.kind === 'Record' ? text('{}') : text('[]'))
          : node.elements.type === 'NamedArgsList'
            ? g.genNode(node.elements)
            : concat(text('['), g.$.genList(node.elements.items, { wrapper: null }), text(']'));

        return concat(text('poo.makeArrayLike('), text(`'${node.kind}', `), elements, text(')'));
      },

    },
  };
}
