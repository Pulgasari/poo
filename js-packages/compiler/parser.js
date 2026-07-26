// poo/compiler/parser.js

import { compileParserMethods } from '@cosmonaut/lsd';
import lsd from './lsd.js';

export const methods = compileParserMethods(lsd);
