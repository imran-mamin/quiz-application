'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"pubspec.lock": "641cf84e7d27aa3090545b0b3997dba0",
"flutter_bootstrap.js": "863a340235006f775f8477752fe76fe5",
"lib/main.dart": "b12d538b66b0642bd7711458f9599abe",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "f7c5e5502d577306fb6d530b1864ff86",
"canvaskit/chromium/canvaskit.wasm": "c054c2c892172308ca5a0bd1d7a7754b",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "27361387bc24144b46a745f1afe92b50",
"canvaskit/canvaskit.wasm": "a37f2b0af4995714de856e21e882325c",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "9fe690d47b904d72c7d020bd303adf16",
"canvaskit/skwasm.wasm": "1c93738510f202d9ff44d36a4760126b",
"dad_first_project.iml": "731a1a3080009db8d4572ef3fb1679c3",
"web/icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"web/icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"web/icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"web/icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"web/index.html": "cc52f92fac73b0c22ad3433dcc36c55a",
"web/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"web/manifest.json": "6acd9d606844e18df7f2a5bb75c15197",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"README.md": "c35a7ee2a97006f4278d3d279f0fbb77",
".idea/modules.xml": "cdf4e1e6bad9ed57ecafaa7cbc8fbcad",
".idea/libraries/KotlinJavaRuntime.xml": "4b0df607078b06360237b0a81046129d",
".idea/libraries/Dart_SDK.xml": "7370b625f2064a53a28081e62834ee2d",
".idea/workspace.xml": "cc5f609be0f96835c87839f62217d14b",
".idea/runConfigurations/main_dart.xml": "2b82ac5d547e7256de51268edfd10dc3",
"pubspec.yaml": "beec1a22de6ec99454c300fbc9ff5db6",
"index.html": "d21342b7197f8eba08b410488f4213de",
"/": "d21342b7197f8eba08b410488f4213de",
"assets/NOTICES": "b13ad659174d05bdfc013e771c55fc6c",
"assets/AssetManifest.bin": "0b0a3415aad49b6e9bf965ff578614f9",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/fonts/MaterialIcons-Regular.otf": "405d42ee1b45f78772d7d0a3c1220b3f",
"assets/AssetManifest.json": "99914b932bd37a50b983c5e7c90ae93b",
"assets/AssetManifest.bin.json": "a1fee2517bf598633e2f67fcf3e26c94",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
".dart_tool/package_graph.json": "a6499d9b6963459a92c080617996d561",
".dart_tool/extension_discovery/README.md": "606241196f08642dcc9f7acef0d2d8da",
".dart_tool/extension_discovery/vs_code.json": "ed607032f98858f498b1a98a726d1ac4",
".dart_tool/package_config.json": "80d3ac1b71916fc5d47c6655161960e0",
".dart_tool/version": "32ac16bae1a2e078d20df2a49e69b829",
".dart_tool/dartpad/web_plugin_registrant.dart": "7ed35bc85b7658d113371ffc24d07117",
".dart_tool/flutter_build/a9d06035b8985dcc6cc1a8921d2bb59e/flutter_assets.d": "a20ffe76080aca31f1e428c7672a08ee",
".dart_tool/flutter_build/a9d06035b8985dcc6cc1a8921d2bb59e/web_entrypoint.stamp": "6073fa7424147e9653de3cb6b5719d85",
".dart_tool/flutter_build/a9d06035b8985dcc6cc1a8921d2bb59e/gen_localizations.stamp": "436d2f2faeb7041740ee3f49a985d62a",
".dart_tool/flutter_build/a9d06035b8985dcc6cc1a8921d2bb59e/web_plugin_registrant.dart": "7ed35bc85b7658d113371ffc24d07117",
".dart_tool/flutter_build/a9d06035b8985dcc6cc1a8921d2bb59e/main.dart.js": "c357633d1751f4d0299b7fa51e081cc2",
".dart_tool/flutter_build/a9d06035b8985dcc6cc1a8921d2bb59e/web_resources.d": "d5afbbeee3d3a22b7014b99022d6488d",
".dart_tool/flutter_build/a9d06035b8985dcc6cc1a8921d2bb59e/web_static_assets.stamp": "d351a950e882b843078e5c67000270ec",
".dart_tool/flutter_build/a9d06035b8985dcc6cc1a8921d2bb59e/main.dart.js.deps": "6a5df7e78059dea0a9079b2236aed72e",
".dart_tool/flutter_build/a9d06035b8985dcc6cc1a8921d2bb59e/outputs.json": "fbc6be9d8b01e2e596a55709d7fb8a6b",
".dart_tool/flutter_build/a9d06035b8985dcc6cc1a8921d2bb59e/web_service_worker.stamp": "fcfd6f692f457d581ff526308158d567",
".dart_tool/flutter_build/a9d06035b8985dcc6cc1a8921d2bb59e/service_worker.d": "f0e89f39168e493ebaa7089c2440b400",
".dart_tool/flutter_build/a9d06035b8985dcc6cc1a8921d2bb59e/web_templated_files.stamp": "79ef8951ad4efdde753a7c8bafc84fb0",
".dart_tool/flutter_build/a9d06035b8985dcc6cc1a8921d2bb59e/app.dill": "6ada291ac9a91e8180b4e90eed874e95",
".dart_tool/flutter_build/a9d06035b8985dcc6cc1a8921d2bb59e/dart2js.stamp": "f24708dcfd5a3dc949a5a5e630a5451d",
".dart_tool/flutter_build/a9d06035b8985dcc6cc1a8921d2bb59e/main.dart": "d9687ff0d5c52d82d280f788d7beefc2",
".dart_tool/flutter_build/a9d06035b8985dcc6cc1a8921d2bb59e/web_release_bundle.stamp": "cdd46e74e1532a3248a383b7dd608bcd",
".dart_tool/flutter_build/a9d06035b8985dcc6cc1a8921d2bb59e/app.dill.deps": "f6ae38c95e40d5734e73ccb567e5728f",
".dart_tool/flutter_build/a9d06035b8985dcc6cc1a8921d2bb59e/dart2js.d": "c27390179e08926b4a301be5eaaa531d",
".dart_tool/package_config_subset": "b43f63271236566f418a447945cb08cd",
"main.dart.js": "3b1332cf02e94d18e9e56e1abef46b93",
"test/widget_test.dart": "286906a566abaeaca6d78d709dde6dd8",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"analysis_options.yaml": "66d03d7647c8e438164feaf5b922d44a",
"manifest.json": "f1a76fcb8d0ea9acf20fc853ad3c369a",
"build/web/flutter_bootstrap.js": "7898b56384180a9eb38f6508921880bb",
"build/web/canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"build/web/canvaskit/chromium/canvaskit.js.symbols": "f7c5e5502d577306fb6d530b1864ff86",
"build/web/canvaskit/chromium/canvaskit.wasm": "c054c2c892172308ca5a0bd1d7a7754b",
"build/web/canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"build/web/canvaskit/canvaskit.js.symbols": "27361387bc24144b46a745f1afe92b50",
"build/web/canvaskit/canvaskit.wasm": "a37f2b0af4995714de856e21e882325c",
"build/web/canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"build/web/canvaskit/skwasm.js.symbols": "9fe690d47b904d72c7d020bd303adf16",
"build/web/canvaskit/skwasm.wasm": "1c93738510f202d9ff44d36a4760126b",
"build/web/icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"build/web/icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"build/web/icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"build/web/icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"build/web/index.html": "751679b73bdcc69718ba55964cc80b84",
"build/web/assets/NOTICES": "c2d43e32437337f7034c9b579a1ef777",
"build/web/assets/AssetManifest.bin": "693635b5258fe5f1cda720cf224f158c",
"build/web/assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"build/web/assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "825e75415ebd366b740bb49659d7a5c6",
"build/web/assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"build/web/assets/fonts/MaterialIcons-Regular.otf": "deea0f5dba93813bade5621aec9b6b13",
"build/web/assets/AssetManifest.json": "2efbb41d7877d10aac9d091f58ccd7b9",
"build/web/assets/AssetManifest.bin.json": "69a99f98c8b1fb8111c5fb961769fcd8",
"build/web/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"build/web/main.dart.js": "c357633d1751f4d0299b7fa51e081cc2",
"build/web/flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"build/web/manifest.json": "6acd9d606844e18df7f2a5bb75c15197",
"build/web/version.json": "43285fd58059451f642ca19d2521308f",
"version.json": "3e5c2897d4a1409cb9a6082a8c38b36a"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
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
