# ZenScrap Core

Shared Dart library containing core logic used by both the ZenScrap Flutter client and Serverpod server.

## Purpose

This package exists to avoid code duplication between the client and server. Any logic that needs to be consistent across both should be placed here.

## Current Contents

### Banned Domains (`banned_domains.dart`)

Utilities for detecting URLs from domains that cannot be scraped:

```dart
import 'package:zenscrap_core/zenscrap_core.dart';

// Check if a URL is from a banned domain
if (isUrlFromBannedDomain('https://instagram.com/post/123')) {
  print('Cannot scrape this URL');
}

// Get the specific banned domain for error messages
final domain = getBannedDomainFromUrl('https://www.facebook.com/page');
if (domain != null) {
  print('The domain $domain is not supported');
}
```

## Adding New Shared Logic

When you need logic that must be identical in both the client and server:

1. Add your code to `lib/src/`
2. Export it from `lib/zenscrap_core.dart`
3. Import `package:zenscrap_core/zenscrap_core.dart` where needed

## Usage

This package is included as a path dependency in both `zenscrap_server` and `zenscrap_flutter`.
