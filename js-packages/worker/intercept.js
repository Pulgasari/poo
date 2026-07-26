// @poo/worker/intercept.js

// Fetch-interception: any request for a ".poo" URL gets its response
// body compiled on the fly and served as JavaScript instead. Everything
// else passes through to the network untouched.

import { compile } from '../compiler/index.js';

export function shouldIntercept (request) {
  return request.method === 'GET' && new URL(request.url).pathname.endsWith('.poo');
}

export async function handleFetch (event) {
  const originalResponse = await fetch(event.request);

  if (!originalResponse.ok) return originalResponse;

  const source = await originalResponse.text();

  let code;
  try {
    ({ code } = compile(source));
  } catch (err) {
    code = `throw new Error(${JSON.stringify('[poo] Compile error in ' + event.request.url + ': ' + err.message)});\n`;
  }

  return new Response(code, {
    status: 200,
    headers: { 'Content-Type': 'application/javascript' },
  });

}
