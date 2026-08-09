// poo/compiler/lsd.js

// Loads poo.lsd via fetch (relative to this module's own location) and turns
// it into a Cosmonaut spec once, shared by index.js and codegen.js. Fetch,
// not a bundled string or fs access - this package runs inside a browser
// Service Worker (see poo/worker), where fetch is the natural way to load a
// co-located resource and fs is not available at all.

// Uses top-level await: consumers still write a plain `import spec from
// './lsd.js'` without needing async themselves, since any module importing
// an async module waits for it to settle before continuing.

import { readLSD } from '@cosmonaut/lsd';

const response = await fetch(new URL('./poo.lsd', import.meta.url));

if (!response.ok) {
  throw new Error(`[poo/compiler] Failed to load poo.lsd: ${response.status} ${response.statusText}`);
}

// A full spec: { lexer, parser, highlighting, document }. `document` is the
// parsed intermediate representation, which codegen.js reads for the
// operator table.
export default readLSD(await response.text());
