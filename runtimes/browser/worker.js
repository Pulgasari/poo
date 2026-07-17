// @poo/runtimes/browser/worker.js

importScripts('./parser.js', './codegen.js', './cache.js');

// Die drei Backends (Browser, Deno, Odin) – hier nur Browser ausgeführt, aber Struktur ist da
async function compile (source, target) {
  
  // 1. Cache-Check
  const cached = await getCachedCode(source);
  if (cached) return { code: cached, fromCache: true };
    
  // 2. Parsen
  const ast = parse (source);
  if (!ast) throw new Error("Parser-Fehler: AST konnte nicht erzeugt werden.");
    
  // 3. Generieren (je nach Ziel)
  let generatedCode;
       if (target === 'browser') generatedCode = generate (ast, 'browser');
  else if (target === 'deno')    generatedCode = generate (ast, 'deno'); 
  else if (target === 'odin')    generatedCode = generate (ast, 'odin');
  else throw new Error(`Unbekanntes Ziel: ${target}`);

  // 4. Cachen (nicht blockierend, wir warten nicht)
  setCachedCode(source, generatedCode).catch(() => {});

  // done!
  return { code: generatedCode, fromCache: false };
  
}

self.onmessage = async (event) => {
  const { source, target, action } = event.data;

  if (action === 'compile') {
    try {
      const { code, fromCache } = await compile(source, target);
      self.postMessage({ type: 'success', code, fromCache, target });
    } catch (err) {
      self.postMessage({ type: 'error', message: err.message || String(err) });
    }
  }
};
