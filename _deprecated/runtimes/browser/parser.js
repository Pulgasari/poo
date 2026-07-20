// Deine echte Parser-Logik hier. Dies ist nur ein Mock für die Demo.
export function parse(source) {
    // Simulierter AST: Ein einfaches "Print"-Statement
    // Du ersetzt das hier durch DEINEN fertigen Parser!
    return {
        type: 'Program',
        body: [
            { type: 'PrintStatement', value: source.trim() }
        ]
    };
}
