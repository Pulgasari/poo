// poo/docs/_includes/js/highlight.js

let poo = {};
poo.builtins     = 'Array Blob Bool Char Color Date Enum Generator List Map Number Queue Pattern Record RegExp Set Stack String Store Symbol Tree Tuple Union';
poo.keywords     = 'as and break catch continue cpy do fail fn if kill loop in new obj of on or pkg ref return skip static switch use val yield',
poo.literals     = 'false null true undefined',
poo.punctuations = `{}[]();:,.`;
poo.operators = `
  >>> <=> === ~== !==
  >> |> |? |! |* || && ?? =>
  == != =< >= += -= *= /= #= ~= :=
  + - * / % = < > ! & | ^ ~ #
`;

// RegExp
const rgx = {};
rgx.numbers   = '0[xX][0-9a-fA-F_]+|0[bB][01_]+|\\d[\\d_]*\\.\\d[\\d_]*(?:[eE][+-]?\\d+)?|\\d[\\d_]*';
rgx.operators = buildOperatorRegex(poo.operators);

hljs.registerLanguage('poo', function (hljs) {
  const KEYWORDS = {
    built_in: poo.builtins,
    keyword: poo.keywords,
    literal: poo.literals,
  };

  const COMMENT = hljs.COMMENT(/\/\//, /$/);

  const NUMBER = {
    scope: 'number',
    match: new RegExp(rgx.numbers),
    relevance: 0,
  };

  const OPERATOR = {
    scope: 'operator',
    match: rgx.operators,
    relevance: 0,
  };

  const PUNCTUATION = {
    scope: 'punctuation',
    match: /[{}[\]();:,.]/,
    relevance: 0,
  };

  const SPECIAL_KEYWORD = {
    scope: 'keyword',
    match: /\bfn[*^]/,
  };

  const VARIABLE_INTERPOLATION = {
    scope: 'variable',
    match: /\$[A-Za-z_][A-Za-z0-9_]*/,
    relevance: 0,
  };

  const STRING_SINGLE = {
    scope: 'string',
    begin: /'/,
    end: /'/,
    contains: [
      hljs.BACKSLASH_ESCAPE,
    ],
  };

  /*
   * Diese Modes werden weiter unten gegenseitig verbunden:
   *
   * TEMPLATE_STRING
   *   -> ${ EXPRESSION_INTERPOLATION }
   *        -> verschachtelte { BRACED_CODE }
   *        -> verschachtelter `TEMPLATE_STRING`
   */
  const EXPRESSION_INTERPOLATION: any = {
    scope: 'subst',
    begin: /\$\{/,
    end: /\}/,
    keywords: KEYWORDS,
    contains: [],
  };

  const TEMPLATE_STRING: any = {
    scope: 'string',
    begin: /`/,
    end: /`/,
    contains: [
      hljs.BACKSLASH_ESCAPE,

      // Muss vor normaler $variable-Erkennung stehen.
      EXPRESSION_INTERPOLATION,

      VARIABLE_INTERPOLATION,
    ],
  };

  /*
   * Ein normaler {...}-Block innerhalb einer Interpolation.
   *
   * 'self' bedeutet:
   *
   *   {
   *     foo: {
   *       bar: {
   *         ...
   *       }
   *     }
   *   }
   *
   * Die verschachtelten Blöcke werden vollständig konsumiert, sodass deren
   * schließende } nicht EXPRESSION_INTERPOLATION beendet.
   */
  const BRACED_CODE: any = {
    begin: /\{/,
    end: /\}/,
    keywords: KEYWORDS,
    contains: [],
  };

  const EXPRESSION_ATOMS = [
    COMMENT,

    STRING_SINGLE,
    {
      scope: 'string',
      begin: /"/,
      end: /"/,
      contains: [
        hljs.BACKSLASH_ESCAPE,
        VARIABLE_INTERPOLATION,
      ],
    },

    TEMPLATE_STRING,
    SPECIAL_KEYWORD,
    NUMBER,
    OPERATOR,
    PUNCTUATION,
  ];

  /*
   * Wichtig:
   *
   * Nicht BRACED_CODE selbst in BRACED_CODE.contains einsetzen.
   * Dafür wird die highlight.js-Sonderreferenz 'self' verwendet.
   */
  BRACED_CODE.contains = [
    'self',
    ...EXPRESSION_ATOMS,
  ];

  /*
   * Innerhalb von ${...} sind normale Ausdrücke und {...}-Blöcke erlaubt.
   *
   * BRACED_CODE muss vor PUNCTUATION geprüft werden, damit eine öffnende {
   * einen rekursiven Block startet und nicht bloß als punctuation markiert
   * wird.
   */
  EXPRESSION_INTERPOLATION.contains = [
    BRACED_CODE,
    ...EXPRESSION_ATOMS,
  ];

  return {
    name: 'Poo',
    aliases: ['poo'],
    case_insensitive: false,
    keywords: KEYWORDS,

    contains: [
      COMMENT,
      STRING_SINGLE,

      {
        scope: 'string',
        begin: /"/,
        end: /"/,
        contains: [
          hljs.BACKSLASH_ESCAPE,
          VARIABLE_INTERPOLATION,
        ],
      },

      TEMPLATE_STRING,

      SPECIAL_KEYWORD,
      NUMBER,
      OPERATOR,
      PUNCTUATION,
    ],
  };
});

/*
hljs.registerLanguage('poo', function (hljs) {

  const VARIABLE_INTERPOLATION = {
    className : 'variable',
    begin     : /\$[a-zA-Z_][a-zA-Z0-9_]* /
  };

  // 2. Vorab-Deklaration für die komplexe Interpolation ${ ... }
  const EXPRESSION_INTERPOLATION = {
    className : 'subst',
    begin     : /\$\{/,
    end       : /\}/,
    keywords  : {
      built_in : poo.builtins,
      keyword  : poo.keywords,
      literal  : poo.literals,
    },
    contains: []
  };

  const STRING_SINGLE   = { className: 'string', begin: "'", end: "'", contains: [hljs.BACKSLASH_ESCAPE] };
  const STRING_DOUBLE   = { className: 'string', begin: '"', end: '"', contains: [hljs.BACKSLASH_ESCAPE, VARIABLE_INTERPOLATION] };
  const STRING_BACKTICK = { className: 'string', begin: '`', end: '`', contains: [hljs.BACKSLASH_ESCAPE, VARIABLE_INTERPOLATION, EXPRESSION_INTERPOLATION] };   

  EXPRESSION_INTERPOLATION.contains = [ // defined here to make recursion possible
    hljs.COMMENT('//', '$'),
    STRING_DOUBLE,
    STRING_SINGLE,
    STRING_BACKTICK,
    { className: 'keyword'     , begin: /fn[*^]/        },
    { className: 'number'      , begin: rgx.numbers     },
    { className: 'operator'    , begin: rgx.operators   },
    { className: 'punctuation' , begin: /[{}[\]();:,.]/ },
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
      { className: 'number'      , begin: rgx.numbers     },
      { className: 'operator'    , begin: rgx.operators   },
      { className: 'punctuation' , begin: /[{}[\]();:,.]/ },
    ]
  };
  
});
*/

/*
hljs.registerLanguage('poo', function (hljs) {
  return {
    name: "Poo",
    case_insensitive: false,
    keywords: {
      keyword  : "as and break catch continue cpy do fail fn if kill loop in new obj of on orrgx. pkg ref return skip static switch use val yield",
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

// :::::: HELPERS

function buildOperatorRegex (opsInput) {
  const ops = typeof opsInput === 'string' ? opsInput.trim().split(/\s+/) : opsInput;
  
  // Längste Operatoren zuerst sortieren (z. B. '===' vor '==')
  const sorted = ops.sort((a, b) => b.length - a.length);
  
  // Regex-Sonderzeichen automatisch escapen
  const escaped = sorted.map(op => op.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, '\\$&'));
  
  return new RegExp(escaped.join('|'));
}

