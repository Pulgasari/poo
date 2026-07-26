// poo/compiler/lexer.js

import { compileTokenizer } from '@cosmonaut/lsd';
import lsd from './lsd.js';

export const createLexer = compileTokenizer(lsd);
