// poo/compiler/lsd.js

// Loads poo.lsd via fetch (relative to this module's own location) and
// parses it once, sharing the resulting intermediate representation
// between lexer.js/parser.js/codegen.js. Fetch, not a bundled/embedded
// string constant or fs access - this package runs inside a browser
// Service Worker (see poo/worker), where fetch is the natural way to
// load a co-located resource, and fs isn't available at all.

// Uses top-level await: consumers can still write a plain
// `import lsd from './lsd.js'` without needing async/await themselves -
// the module system resolves this automatically, since any module that
// imports an async module waits for it to settle before continuing.

import { parseLSD } from '@cosmonaut/lsd';

const response = await fetch(new URL('./poo.lsd', import.meta.url));

if (!response.ok) {
  throw new Error(`[poo/compiler] Failed to load poo.lsd: ${response.status} ${response.statusText}`);
}

const source = await response.text();

export default parseLSD(source);
