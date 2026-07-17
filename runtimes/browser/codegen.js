
import { ValueType } from './runtime.js';

export function generate(ast, target = 'browser') {
    // Simulierter Generator: Gibt einen Code zurück, der die Runtime importiert und ausführt.
    // WICHTIG: Hier baust du DEINE echte Transformation ein!
    const statements = ast.body.map(stmt => {
        if (stmt.type === 'PrintStatement') {
            const text = stmt.value;
            return `console.log("Dein Code: ${text}");`;
        }
        return '';
    }).join('\n');

    return `
import { fromString, makeObject, GLOBAL_PROTOTYPE } from './runtime.js';

// Benutzergenerierter Code:
${statements}

console.log("Ausführung im Browser abgeschlossen!");
`;
}
