// @poo/worker

// Service Worker entry point. Registers standard install/activate
// handlers (immediate takeover, no waiting on old clients to close) and
// intercepts fetches for ".poo" files - see intercept.js.

import { shouldIntercept, handleFetch } from './intercept.js';

self.addEventListener('install', event => {
  self.skipWaiting();
});

self.addEventListener('activate', event => {
  event.waitUntil(self.clients.claim());
});

self.addEventListener('fetch', event => {
  if (!shouldIntercept(event.request)) return;
  event.respondWith(handleFetch(event));
});
