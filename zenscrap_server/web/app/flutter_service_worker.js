'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "d528bb972aa83e06f2573055d12b9105",
"version.json": "c2b90b9a9c3ba7d2a2cc0ea2b3e864df",
"main.dart.js_12.part.js": "576b695c23db19d73575a5f3bf9fc095",
"splash/img/light-2x.png": "2e6280ba021a28eeee862f88db767d4f",
"splash/img/dark-4x.png": "3b880acad4f01ab94b17fe6861495a25",
"splash/img/light-3x.png": "aae002f1662b9510221be9db041d2860",
"splash/img/dark-3x.png": "aae002f1662b9510221be9db041d2860",
"splash/img/light-4x.png": "3b880acad4f01ab94b17fe6861495a25",
"splash/img/dark-2x.png": "2e6280ba021a28eeee862f88db767d4f",
"splash/img/dark-1x.png": "f8a89bb5c4b627da90fb4ba225e09bba",
"splash/img/light-1x.png": "f8a89bb5c4b627da90fb4ba225e09bba",
"index.html": "f2fa22576f1e48033d3fbe0a59eed0f2",
"/": "f2fa22576f1e48033d3fbe0a59eed0f2",
"main.dart.js_13.part.js": "704c9e0305dae02dc230cf3390ef280d",
"main.dart.js_11.part.js": "5ecbe12968931ba878b599fec9d62394",
"main.dart.js": "03c4eb9b1f28a6c91251dd0cbc4eb1be",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"main.dart.js_10.part.js": "5f12cb7622259c0d8ea5eb9be0c65d77",
"main.dart.js_15.part.js": "dd8d92dca1d357481c8d85acf4eec1bf",
"favicon.png": "d4be0544212295c87db0614954d85d75",
"main.dart.mjs": "177f8b3ba25cf8295ed7b2ec66d02e62",
"icons/Icon-192.png": "00eeff42f260633fd891bfd4d1c8c845",
"icons/Icon-maskable-192.png": "00eeff42f260633fd891bfd4d1c8c845",
"icons/Icon-maskable-512.png": "322f0b0ce5c6238d8e8952ca2d279972",
"icons/Icon-512.png": "322f0b0ce5c6238d8e8952ca2d279972",
"manifest.json": "ce9779d92707a5a37b526d4aca06fca6",
"main.dart.js_14.part.js": "62aabb06d916e67dabda4f3498e58b48",
"sitemap.xml": "c71092bae445f45208e1a05400116375",
"main.dart.js_1.part.js": "92afc1c4edb967d864074b592f1e1a8c",
"main.dart.wasm": "0f6a3bde527c3a355d994473a3d24ee7",
"robots.txt": "78cfb2815076cad68ff4fe8b232d47b0",
"main.dart.js_16.part.js": "9e1a2cb29963c32526572f04af3da146",
"assets/AssetManifest.json": "f0a802f66bd086d14af9e45273bdc9d7",
"assets/NOTICES": "8d589f2701818cdfeb2af87cf6c5c997",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/AssetManifest.bin.json": "da386e19fa95d7c14aaea54c784b6181",
"assets/packages/serverpod_auth_idp_flutter/assets/images/google.svg": "edd0e34f60d7ca4a2f4ece79cff21ae3",
"assets/packages/serverpod_auth_idp_flutter/assets/images/apple.svg": "00587615733dd4954be85d8bf79f1d6f",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "cc26808b75bd1a5529ce7ade2a2ce8c4",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/AssetManifest.bin": "d63171c38e331b04a61f64594e1bebd8",
"assets/fonts/MaterialIcons-Regular.otf": "849bdfa80a85005e03ca8501d7b4da52",
"assets/assets/logo.PNG": "bf6009c05b3c6d12ad6d6dab876e9812",
"assets/assets/transparent_logo.PNG": "20f08e84b191f2335e2cc7145966bcc9",
"main.dart.js_2.part.js": "14d086791d36fbb3e1e2cf8832f4956e",
"main.dart.js_17.part.js": "5a7e4440c4c45b818e48a26869af300e",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"main.dart.wasm",
"main.dart.mjs",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
