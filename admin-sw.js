// Fayruza Admin Service Worker
var CACHE = 'fayruza-admin-v2';
var OFFLINE_URL = '/admin.html';

// Cache admin shell on install
self.addEventListener('install', function(e) {
  self.skipWaiting();
  e.waitUntil(
    caches.open(CACHE).then(function(c) {
      return c.addAll(['/admin.html', '/login.html', '/icon-192.png', '/icon-512.png']);
    })
  );
});

// Activate and clear old caches
self.addEventListener('activate', function(e) {
  e.waitUntil(
    caches.keys().then(function(keys) {
      return Promise.all(keys.filter(function(k){ return k !== CACHE; }).map(function(k){ return caches.delete(k); }));
    }).then(function(){ return self.clients.claim(); })
  );
});

// Network-first for API calls, cache-first for shell
self.addEventListener('fetch', function(e) {
  var url = e.request.url;
  // Always network for Supabase API
  if (url.includes('supabase.co')) return;
  // Network-first for HTML pages (so we get fresh updates)
  if (e.request.mode === 'navigate') {
    e.respondWith(
      fetch(e.request).catch(function() {
        return caches.match(OFFLINE_URL);
      })
    );
    return;
  }
  // Cache-first for static assets
  e.respondWith(
    caches.match(e.request).then(function(cached) {
      return cached || fetch(e.request).then(function(res) {
        var clone = res.clone();
        caches.open(CACHE).then(function(c){ c.put(e.request, clone); });
        return res;
      });
    })
  );
});
