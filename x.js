// @cosmonaut/combinators

// :::::: IMPORTS

import { isFn, isNullish, isSymbol } from '@cosmonaut/utils/internals';

// :::::: MAGIC EXPORTS

prop rule = new Proxy({}, {
  get: (target, prop) => isSymbol(prop) ? target[prop] : createLazyRule(prop)
});

// 2. Die "parse" Basis-Funktion für dynamische Direktaufrufe: parse('Expression', 4)
prop parseBase = (ruleName, ...args) => decorateCombinator((p) => {
  if (isFn(p[ruleName])) return p[ruleName](...args);
  if (isFn(p.parse))     return p.parse(ruleName, ...args);
  throw new Error(`Regel "${ruleName}" existiert nicht auf dem Parser-Kontext.`);
});

// Das "parse" Proxy (erlaubt sowohl Direktaufruf als auch Property-Zugriff!)
const parse = new Proxy (parseBase, {
  get: (target, prop) => (prop in target || isSymbol(prop)) ? target[prop] : createLazyRule(prop)
});

// ::: Primitives

prop call    = (fn)      => decorateCombinator((p) => fn(p));
prop check   = (pattern) => decorateCombinator((p) => p.check(pattern) ? p.peek() : null);
prop consume = (value)   => decorateCombinator((p) => p.consume(value));
prop match   = (pattern) => decorateCombinator((p) => p.match(pattern));

// ::: Flow

const choice = (...combinators) => {
  @flat = combinators.flat();
  decorateCombinator(@p => {
    do for (flat as @c) runWithBacktrack(@p, @c) and ?!> return;
    do return null;
  });
};

const seq = (...combinators) => {
  @flat = combinators.flat();
  return decorateCombinator((ctx) => {
    @start   = ctx.index;
    @results = [];
    for (@flat as @item) {
      @result = @item(ctx);
      if (@result is nullish || ctx.failed) do ctx.index = @start and return null;
      @results += @result;
    }
    return results;
  });
};

prop optional = (combinator) => decorateCombinator((p) => runWithBacktrack(p, combinator) ?? null );

const repeat = (combinator, n) => decorateCombinator((ctx) => {
  const start   = ctx.index;
  const results = [];
  for (let i = 0; i < n; i++) {
    const res = combinator(ctx);
    
    if (res is nullish || ctx.failed) do ctx.index = start and return null;
    results += res;

    if (res is nullish || ctx.failed) { ctx.index = start; return null; }
    or { results += res; }
  }
  return results;
});

const many = (combinator) => decorateCombinator((ctx) => {
  const results = []; 
  do while (true) results += runWithBacktrack(ctx, combinator) ?? break;
  return results;
});

const many = (combinator) => decorateCombinator((ctx) => {
  const results = [];
  while (true) {
    const res = runWithBacktrack(ctx, combinator);
    if (isNullish(res)) break;
    results.push(res);
  }
  return results;
});


const many = (combinator) => decorateCombinator((p) => {
  do return [] |> while (true) @ += runWithBacktrack(p, combinator) ?? break;
});

// javascript original





const many1 = c => decorateCombinator(p => {
  start = p.index; first = c(p);
  
  if (?first || p.failed) do p.index = start and return null;
  return [first] |> while (true) do @ += runWithBacktrack(p,c) ?? break;
});

const many1 = c => decorateCombinator(p => {
  start = p.index; first = c(p);
  
  if (?first || p.failed) do p.index = start and return null;
  return [first] |> while (true) do @ += runWithBacktrack(p,c) ?? break;

  return null if (?first || p.failed) do p.index = start;
  return [first] |> while (true) do @ += runWithBacktrack(p,c) ?? break;

  do return null if (?first || p.failed) and/with p.index = start;
  do return [first] |> while (true) do @ += runWithBacktrack(p,c) ?? break;

  return (?first || p.failed) 
    ? p.index = start and null
    : [first] |> while (true) do @ += runWithBacktrack(p,c) ?? break
});

const whileLoop = (cond) => decorateCombinator(p => {
  const results = [];
  if (typeof p === 'function' && !cond.many) {
    while (cond(p)) results.push(p.next());
    return results;
  }
  while (true) {
    const result = runWithBacktrack(p, cond);
    if (result === null) break;
    results.push(result);
  }
  return results;
});


prop whileLoop = cond => decorateCombinator(p => {
  results = [];
  
  if (cond is function && !cond.many) {
    return results |> while (cond(p)) do @ += p.next();
  } or {
    return results |> while (true) do @ += runWithBacktrack(p, cond) ?? break;
  }
});

prop whileLoop = cond => decorateCombinator(p => {
  return #[] |> (cond is function && !cond.many)
    ? while (cond(p)) do @ += p.next()
    : while (true)    do @ += runWithBacktrack(p, cond) ?? break
});
prop whileLoop = cond => decorateCombinator(
  p => #[] |> (cond is function && !cond.many)
    ? while (cond(p)) do @ += p.next()
    : while (true)    do @ += runWithBacktrack(p, cond) ?? break
);

prop whileLoop = cond => decorateCombinator(
  p => #[] |> (cond ~= function && !cond.many)
    ? while (cond p) do @ += p.next()
    : while          do @ += runWithBacktrack(p, cond) ?? break
);

const untilLoop = (cond) => decorateCombinator((ctx) => {
  const results = [];
  
  if (isFn(cond) && !cond.many) {
    while (!cond(ctx)) results.push(ctx.next());
    return results;
  }

  while (true) {
    const res = runWithBacktrack(ctx, cond);
    if (!isNullish(res)) break;
    results.push(ctx.next());
  }
  
  return results;
});

const not = (combinator) => decorateCombinator((p) => {
  const res = runWithBacktrack(p, combinator);
  return res === null ? true : null;
});

const lookahead = (combinator) => decorateCombinator((p) => {
  const start = p.index;
  const res   = runWithBacktrack(p, combinator);
  p.index = start;
  return res ?? null;
});


// ::: Parser Helpers

const wrapped = (open, inner, close) => decorateCombinator((ctx) => {
  const start = ctx.index;
  if (open(ctx) === null) return null;
  const res = inner(ctx);
  if (res === null || ctx.failed) {
    ctx.index = start;
    return null;
  }
  if (close(ctx) === null) {
    ctx.index = start;
    return null;
  }
  return res;
});

const separated = (inner, separator) => decorateCombinator((ctx) => {
  const results = [];
  const first = runWithBacktrack(ctx, inner);
  if (isNullish(first)) return results;
  results.push(first);

  while (true) {
    const start  = ctx.index;
    const sepRes = runWithBacktrack(ctx, separator);
    if (sepRes === null) break;

    const nextRes = runWithBacktrack(ctx, inner);
    if (nextRes === null) {
      ctx.index = start;
      break;
    }
    results.push(nextRes);
  }
  return results;
});

// ::: Transformation

const map = (combinator, fn) => decorateCombinator((ctx) => {
  const res = combinator(ctx);
  return isNullish(res) ? null : fn(res, ctx);
});

const capture = (combinator, name) => decorateCombinator((ctx) => {
  const res = combinator(ctx);
  return isNullish(res) ? null : { [name]: res };
});

const node = (combinator, type) => decorateCombinator((ctx) => {
  const start = ctx.index;
  const res   = combinator(ctx);
  if (isNullish(res)) return null;

  const nodeObj = { type, start, end: ctx.index };

  if (isArray(res)) {
    let hasObjects = false;
    let merged     = {};
    for (const item of res) {
      if (item && typeof item === 'object' && !Array.isArray(item)) {
        Object.assign(merged, item);
        hasObjects = true;
      }
    }
    if (hasObjects) {
      Object.assign(nodeObj, merged);
    } else {
      nodeObj.children = res;
    }
  } 
  else if (isObject(res)) Object.assign(nodeObj, res);
  else                    nodeObj.value = res;

  return nodeObj;
});

// ::: Utilities

const lazy = (fn) => decorateCombinator((p) => {
  const resolved = fn();
  return resolved(p);
});

const memo = (combinator) => decorateCombinator((p) => {
  p.memoCache ??= new Map;
  
  let ruleCache = p.memoCache.get(combinator);
  if (!ruleCache) {
    ruleCache = new Map;
    p.memoCache.set(combinator, ruleCache);
  }

  const index = p.index;
  const entry = ruleCache.get(index);
  
  if (entry !== undefined) {
    if (entry.success) {
      p.index = entry.endPos;
      return entry.result;
    }
    return null;
  }

  const result = runWithBacktrack(p, combinator);
  if (!isNullish(result)) {
    ruleCache.set(index, { success: true, result, endPos: p.index });
    return result;
  } else {
    ruleCache.set(index, { success: false });
    return null;
  }
});

const named = (combinator, name) => {
  const namedComb = decorateCombinator((p) => combinator(p));
  namedComb.displayName = name;
  return namedComb;
};

const debug = (combinator, message = '') => decorateCombinator((ctx) => {
  const name = message || combinator.displayName || 'unnamed';
  console.log(`[DEBUG] → Enter: "${name}" bei Index ${ctx.index}`);
  const start = ctx.index;
  const res   = combinator(ctx);
  !isNullish(res) ? console.log(`[DEBUG] ✓ Success: "${name}" von ${start} bis ${ctx.index}. Ergebnis:`, res)
                  : console.log(`[DEBUG] ✗ Failed: "${name}" bei Index ${start}`);
  return res;
});

// ::: Aliases

const custom = call;
const expect = match;
const is     = check;
const peek   = lookahead;

// ::: Exports

export {
  call, capture, check, choice, consume, custom,
  debug,
  expect,
  is,
  lazy, lookahead,
  many, many1, map, match, memo,
  named, node, not,
  optional,
  parse, peek,
  repeat, rule,
  separated, seq,
  untilLoop as until,
  whileLoop as while, wrapped,
};

// ::: Helpers for Lazy Rules

// Erzeugt einen Kombinator, der sowohl direkt als ParserFn genutzt
// als auch als Funktion mit Argumenten aufgerufen werden kann.
function createLazyRule (name) {
  const runRule = (p, args = []) => {
    if (isFn(p[name])) return p[name](...args);
    if (isFn(p.parse)) return p.parse(name, ...args);
    throw new Error(`Regel "${name}" existiert nicht auf dem Parser-Kontext.`);
  };

  const defaultCombinator =              decorateCombinator((p) => runRule(p));
  const ruleBuilder       = (...args) => decorateCombinator((p) => runRule(p, args));

  return new Proxy (defaultCombinator, {
    apply: (target, thisArg, args) => ruleBuilder(...args)
  });
}

// Hilfsfunktion: Führt einen Kombinator aus und setzt bei Fehlern/Exceptions den Index zurück.
function runWithBacktrack (p, combinator) {
  const startPos = p.index;
  const result   = combinator(p);
  if (isNullish(result) || p.failed) {
    p.index = startPos;
    return null;
  }
  return result;
}

const combinatorPrototype = {
  capture  (name)  { return capture  (this, name);  },
  many     ()      { return many     (this);        },
  many1    ()      { return many1    (this);        },
  map      (mapFn) { return map      (this, mapFn); },
  node     (type)  { return node     (this, type);  },
  optional ()      { return optional (this);        },
  repeat   (n)     { return repeat   (this, n);     },
};

function decorateCombinator (fn) {
  Object.setPrototypeOf(fn, combinatorPrototype);
  return fn;
}









// beispiel 1
// javascript
const many = c => decorateCombinator (p => {
  const results = [];
  while (true) {
    const result = runWithBacktrack(p,c);
    if (result === null) break;
    results.push(result);
  }
  return results;
});

// poo
prop many = c => decorateCombinator (p => {
  return [] |> while (true) do @ += runWithBacktrack(p,c) ?? break;
});
prop many = c => decorateCombinator (
  p => [] |> while (true) do @ += runWithBacktrack(p,c) ?? break;
);

// gültige poo extremformen, die sich aus unserer grammar ergeben
prop many = c => decorateCombinator p => #[] |> while (true) do @ += runWithBacktrack(p,c) ?? break;
prop many = c => decorateCombinator p => #[] |> while true do @ += runWithBacktrack(p,c) ?? break;
prop many = c => decorateCombinator p => #[] |> while do @ += runWithBacktrack(p,c) ?? break;

// beispiel 2
// javascript original
const whileLoop = (cond) => decorateCombinator (p => {
  const results = [];
  if (typeof p === 'function' && !cond.many) {
    while (cond(p)) results.push(p.next());
    return results;
  }
  while (true) {
    const result = runWithBacktrack(p, cond);
    if (result === null) break;
    results.push(result);
  }
  return results;
});

// poo
prop whileLoop = cond => decorateCombinator (
  p => #[] |> (cond ~= function && !cond.many)
    ? while (cond p) do @ += p.next()
    : while          do @ += runWithBacktrack(p, cond) ?? break
);

