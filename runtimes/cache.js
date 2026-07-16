// cache.js
const CACHE_NAME = 'my-lang-cache-v1';

// Einfacher Hash für den Cache-Key (nicht kryptografisch sicher, aber schnell)
export function hashSource(source) {
    let hash = 0;
    for (let i = 0; i < source.length; i++) {
        const char = source.charCodeAt(i);
        hash = ((hash << 5) - hash) + char;
        hash |= 0; // Convert to 32bit integer
    }
    return 'src_' + Math.abs(hash).toString(36);
}

export async function getCachedCode(source) {
    const key = hashSource(source);
    try {
        const cache = await caches.open(CACHE_NAME);
        const response = await cache.match(key);
        if (response) {
            const data = await response.json();
            return data.code;
        }
    } catch (e) { /* Ignore */ }
    return null;
}

export async function setCachedCode (source, code) {
    const key = hashSource(source);
    try {
        const cache    = await caches.open(CACHE_NAME);
        const response = new Response(JSON.stringify({ code }), {
            headers: { 'Content-Type': 'application/json' }
        });
        await cache.put(key, response);
    } catch (e) { /* Ignore */ }
}
