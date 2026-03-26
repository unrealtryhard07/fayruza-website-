// Fayruza Restaurant — Service Worker
// Caches the menu shell for fast loading and basic offline support

const CACHE = 'fayruza-v2';
const SHELL = [
  '/index.html',
  '/history.html',
  '/status.html',
  '/manifest.json'
];

// Install — cache the app shell
self.addEventListener('install', function(e) {
  e.waitUntil(
    caches.open(CACHE).then(function(c) { return c.addAll(SHELL); })
  );
  self.skipWaiting();
});

// Activate — clean old caches
self.addEventListener('activate', function(e) {
  e.waitUntil(
    caches.keys().then(function(keys) {
      return Promise.all(
        keys.filter(function(k) { return k !== CACHE; })
            .map(function(k) { return caches.delete(k); })
      );
    })
  );
  self.clients.claim();
});

// Fetch — network first, fall back to cache for navigation
self.addEventListener('fetch', function(e) {
  // Only handle GET requests for same-origin or assets
  if (e.request.method !== 'GET') return;

  // For Supabase API calls — always go to network, never cache
  if (e.request.url.includes('supabase.co')) return;

  e.respondWith(
    fetch(e.request)
      .then(function(res) {
        // Cache fresh copy of html/css/js
        if (res.ok && (e.request.destination === 'document' || e.request.destination === 'script' || e.request.destination === 'style')) {
          var resClone = res.clone();
          caches.open(CACHE).then(function(c) { c.put(e.request, resClone); });
        }
        return res;
      })
      .catch(function() {
        // Offline fallback — serve from cache
        return caches.match(e.request).then(function(cached) {
          return cached || caches.match('/index.html');
        });
      })
  );
});

// Push notifications (from admin panel)
self.addEventListener('push', function(e) {
  var data = {};
  try { data = e.data ? e.data.json() : {}; } catch(err) {}
  e.waitUntil(
    self.registration.showNotification(data.title || '🔔 Fayruza Admin', {
      body: data.body || 'New activity at the restaurant',
      icon: '/icon-192.png',
      badge: '/icon-192.png',
      tag: data.tag || 'fayruza-notif',
      requireInteraction: true,
      data: { url: data.url || '/admin.html' }
    })
  );
});

// Notification click — open admin
self.addEventListener('notificationclick', function(e) {
  e.notification.close();
  e.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then(function(cls) {
      var target = (e.notification.data && e.notification.data.url) || '/admin.html';
      for (var i = 0; i < cls.length; i++) {
        if (cls[i].url.includes(target) && 'focus' in cls[i]) return cls[i].focus();
      }
      return clients.openWindow(target);
    })
  );
});
