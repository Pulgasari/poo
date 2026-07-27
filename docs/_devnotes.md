# devnotes

## TO DO

- evtl. datatypes mit `to_fingerprint` ausstatten
- *named capture groups* für `RegExp`
- *scan iteration* für `RegExp`
- *escape* in `RegExp`
- matching `RegExp` in `switch`
- case-insensitive string comparison

## Datatype Names

```md
Catalog Cluster Cohort
Ensemble
Group
Hub
Pack Pool Pure
Register Registry
Sequence Singles
Uniq Unique
Vault
```

##

[https://www.mcmillen.dev/language_checklist.html](https://www.mcmillen.dev/language_checklist.html)

## GitHub Syntax

> [!CAUTION]
> Advises about risks or negative outcomes of certain actions.

```md
> [!CAUTION]
> 
```

> [!IMPORTANT]
> Key information users need to know to achieve their goal.

```md
> [!IMPORTANT]
> 
```

> [!NOTE]
> Useful information that users should know, even when skimming content.

```md
> [!NOTE]
> 
```

> [!TIP]
> Helpful advice for doing things better or more easily.

```md
> [!TIP]
> 
```

> [!WARNING]
> Urgent info that needs immediate user attention to avoid problems.

```md
> [!WARNING]
> 
```

---






```
first class function
higher order function
pattern matching
list comprehension
generator expression
```

...

## Examples

###

```c
fn processPayload = filePath => {
  val text = fs::read(filePath) or return "file missing";
  val data = json::parse(text)  or return "invalid json structure";

  if (data ~= obj{ id: Number, targetUrl: String }) {
    safeUrl = data.targetUrl >> url::decode >> html::escape;
    print "Processing safe target: $safeUrl";
  }
  or return "payload fields are garbage";
};

```

###

```javascript
prop globalCounter = 0;
prop configName    = 'dev';
prop baseStats     = { hp: 100 };

prop player = {
  use baseStats;      // Statische Kopie
  ref configName;     // Live-Ansicht (Copy-on-Write)
  pnt globalCounter;  // Aktiver Pointer

  prop tick = () => {
    // 1. Lokaler Zugriff (Kein Präfix)
    print baseStats.hp; 

    // 2. Live-Read-Zugriff (Präfix @)
    print @configName; 

    // 3. Durchschreibender Zugriff (Präfix &)
    &globalCounter += 1; 
  };
};
```

##

```javascript
const firstDefinedOr = (matchers, arg, fallback) => {
  for (const matcher of matchers) {
    const result = matcher(arg);
    if (result !== undefined) return result;
  }
  return fallback;
};
// Aufruf:
return firstDefined(alternativeMatchers, state, undefined);

const anyLike = (matchers, arg, checkFn) => {
  for (const matcher of matchers) {
    const result = matcher(arg);
    if (checkFn(result)) return result;
  }
  return null;
};
// Aufruf:
return anyLike (alternativeMatchers, state, isDefined) ?? undefined;
```

```javascript
Array.anyLike = function (arg, checkFn) => {
  for (const matcher of this) {
    const result = matcher(arg);
    if (checkFn(result)) return result;
  }
  return null;
};
// Aufruf:
return alternativeMatchers.anyLike (state, isDefined) ?? undefined;
```
```javascript
/**
 * Combines multiple matchers into a single function.
 * Evaluates matchers sequentially until one returns a value other than undefined.
 *
 * @param {...Function} matchers - Array or list of matcher functions
 * @returns {Function} A unified matcher function
 */
export function createMatcherChain(...matchers) {
  return (...args) => {
    for (const matcher of matchers) {
      const result = matcher(...args);
      if (result !== undefined) return result;
    }
    return undefined;
  };
}

// Usage:
const combinedMatcher = createMatcherChain(matchA, matchB, matchC);
const result = combinedMatcher(state);
```

```javascript
/**
 * Returns the first non-undefined result from a list of matcher functions.
 *
 * @param {Array<Function>} matchers - List of functions to execute
 * @param {*} arg - Argument passed to each matcher
 * @param {Function} [isMatch] - Optional custom predicate (defaults to !== undefined)
 * @returns {*}
 */
export function firstMatch(matchers, arg, isMatch = (val) => val !== undefined) {
  for (const matcher of matchers) {
    const result = matcher(arg);
    if (isMatch(result)) return result;
  }
  return undefined;
}

/**
 * Evaluates matchers sequentially and returns the first defined result.
 */
export const firstMatch = (matchers, arg) => {
  for (const matcher of matchers) {
    const res = matcher(arg);
    if (res !== undefined) return res;
  }
};

// Usage:
const result = firstMatch(alternativeMatchers, state);
```












