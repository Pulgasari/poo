// poo/compiler/lsd.js

// Parses poo.lsd once and shares the resulting intermediate
// representation between lexer.js and parser.js.

import { parseLSD } from '@cosmonaut/lsd';
import source from './poo-lsd-source.js';

export default parseLSD(source);
