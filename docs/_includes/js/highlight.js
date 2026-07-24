// poo/docs/_includes/js/highlight.js

let poo = {};
poo.builtins    = 'Array Blob Bool Char Color Date Enum Generator List Map Number Queue Pattern Record RegExp Set Stack String Store Symbol Tree Tuple Union';
poo.keywords     = 'as and break catch continue cpy do fail fn if kill loop in new obj of on or pkg ref return skip static switch use val yield',
poo.literals     = 'false null true undefined',
poo.punctuations = `{}[]();:,.`;
poo.operators = `
  >>> <=> === ~== !==
  >> |> |? |! |* || && ?? =>
  == != =< >= += -= *= /= #= ~= :=
  + - * / % = < > ! & | ^ ~ #
`;

hljs.registerLanguage('poo', function (hljs) {

  const VARIABLE_INTERPOLATION = {
    className : 'variable',
    begin     : /\$[a-zA-Z_][a-zA-Z0-9_]*/
  };

  // 2. Vorab-Deklaration für die komplexe Interpolation ${ ... }
  const EXPRESSION_INTERPOLATION = {
    className : 'subst',
    begin     : /\\$\{/,
    end       : /\}/,
    keywords  : {
      built_in : poo.builtins,
      keyword  : poo.keywords,
      literal  : poo.literals,
    },
    contains: [] // Wird gleich unten dynamisch befüllt, um Rekursion zu erlauben
  };

  const STRING_DOUBLE   = { className: 'string', begin: '"', end: '"', contains: [hljs.BACKSLASH_ESCAPE] };
  const STRING_SINGLE   = { className: 'string', begin: "'", end: "'", contains: [hljs.BACKSLASH_ESCAPE, VARIABLE_INTERPOLATION] };
  const STRING_BACKTICK = { className: 'string', begin: '`', end: '`', contains: [hljs.BACKSLASH_ESCAPE, VARIABLE_INTERPOLATION, EXPRESSION_INTERPOLATION] };   

  EXPRESSION_INTERPOLATION.contains = [
    hljs.COMMENT('//', '$'),
    STRING_DOUBLE,
    STRING_SINGLE,
    STRING_BACKTICK,
    { className: 'keyword', begin: /fn[*^]/ },
    { className: 'number', begin: '0[xX][0-9a-fA-F_]+|0[bB][01_]+|\\d[\\d_]*\\.\\d[\\d_]*(?:[eE][+-]?\\d+)?|\\d[\\d_]*' },
    { className: 'operator', begin: buildOperatorRegex(poo.operators) },
    { className: 'punctuation', begin: /[{}[\]();:,.]/ }
  ];

  return {
    name: "Poo",
    case_insensitive: false,
    keywords: {
      built_in : poo.builtins,
      keyword  : poo.keywords,
      literal  : poo.literals,
    },
    contains: [
      hljs.COMMENT('//', '$'),
      { className: 'keyword', begin: /fn[*^]/ },
      STRING_DOUBLE,
      STRING_SINGLE,
      STRING_BACKTICK,
      { className: 'number', begin: '0[xX][0-9a-fA-F_]+|0[bB][01_]+|\\d[\\d_]*\\.\\d[\\d_]*(?:[eE][+-]?\\d+)?|\\d[\\d_]*' },
      { className: 'operator', begin: buildOperatorRegex(poo.operators) },
      { className: 'punctuation', begin: /[{}[\]();:,.]/ }
    ]
  };
  
});

/*
hljs.registerLanguage('poo', function (hljs) {
  return {
    name: "Poo",
    case_insensitive: false,
    keywords: {
      keyword  : "as and break catch continue cpy do fail fn if kill loop in new obj of on or pkg ref return skip static switch use val yield",
      literal  : "false null true undefined",
      built_in : "Array Blob Bool Char Color Date Enum Generator List Map Number Queue Pattern Record RegExp Set Stack String Store Symbol Tree Tuple Union"
    },
    contains: [
      hljs.COMMENT('//', '$'),
      { className: 'keyword', begin: /fn[*^]/ }, // special keywords
      { className: 'string', begin: '"', end: '"', contains: [hljs.BACKSLASH_ESCAPE] },
      { className: 'string', begin: "'", end: "'", contains: [hljs.BACKSLASH_ESCAPE] },
      { className: 'string', begin: '`', end: '`', contains: [hljs.BACKSLASH_ESCAPE] },
      { className: 'number',      begin: '0[xX][0-9a-fA-F_]+|0[bB][01_]+|\\d[\\d_]*\\.\\d[\\d_]*(?:[eE][+-]?\\d+)?|\\d[\\d_]*' },
      { className: 'operator',    begin: buildOperatorRegex(poo.operators) },  
      { className: 'punctuation', begin: /[{}[\]();:,.]/ }
    ]
  };
});
*/
