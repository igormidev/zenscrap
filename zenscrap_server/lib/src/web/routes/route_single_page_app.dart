import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod/serverpod.dart';

/// Route for serving a single page app (SPA).
///
/// This route will serve the file at `web/$serverDirectory/$appRootPath` for all requests that
/// do not match any other static files in the `serverDirectory`. This enables proper
/// handling of client-side routing in Flutter web apps, allowing users to directly
/// navigate to deep links and refresh pages on any route.
class RouteSinglePageApp extends RouteStaticDirectory {
  /// The path to the root file of the single page app.
  final String appRootFilePath;

  /// Creates a single page app route.
  ///
  /// The [appRootPath] is the path to the root file of the single page app
  /// relative to the [serverDirectory]. Defaults to 'index.html'.
  RouteSinglePageApp({
    required super.serverDirectory,
    String appRootPath = 'index.html',
    super.basePath,
    super.serveAsRootPath,
  }) : appRootFilePath = 'web/$serverDirectory/$appRootPath';

  @override
  Future<bool> handleCall(Session session, HttpRequest request) async {
    // Get the requested path
    var path = request.uri.path;

    // Remove base path if present
    if (basePath != null && path.startsWith(basePath!)) {
      path = path.substring(basePath!.length);
    }

    // Clean up path
    if (path.startsWith('/')) {
      path = path.substring(1);
    }

    // Try to serve the static file with proper headers
    final filePath = 'web/$serverDirectory/$path';
    final file = File(filePath);

    if (await file.exists()) {
      try {
        final fileContents = await file.readAsBytes();
        final fileExtension = p.extension(filePath).toLowerCase();

        // Set appropriate content type based on file extension
        ContentType? contentType;
        switch (fileExtension) {
          case '.html':
            contentType = ContentType.html;
            break;
          case '.js':
            contentType = ContentType(
              'application',
              'javascript',
              charset: 'utf-8',
            );
            break;
          case '.css':
            contentType = ContentType('text', 'css', charset: 'utf-8');
            break;
          case '.json':
            contentType = ContentType.json;
            break;
          case '.png':
            contentType = ContentType('image', 'png');
            break;
          case '.jpg':
          case '.jpeg':
            contentType = ContentType('image', 'jpeg');
            break;
          case '.gif':
            contentType = ContentType('image', 'gif');
            break;
          case '.svg':
            contentType = ContentType('image', 'svg+xml');
            break;
          case '.ico':
            contentType = ContentType('image', 'x-icon');
            break;
          case '.otf':
            contentType = ContentType('font', 'otf');
            break;
          case '.ttf':
            contentType = ContentType('font', 'ttf');
            break;
          case '.woff':
            contentType = ContentType('font', 'woff');
            break;
          case '.woff2':
            contentType = ContentType('font', 'woff2');
            break;
          case '.map':
            contentType = ContentType('application', 'json');
            break;
          case '.wasm':
            contentType = ContentType('application', 'wasm');
            break;
          case '.mjs':
            contentType = ContentType(
              'application',
              'javascript',
              charset: 'utf-8',
            );
            break;
          default:
            contentType = ContentType('application', 'octet-stream');
        }

        // Set content type
        request.response.headers.contentType = contentType;

        // Add CORS headers for font files to ensure they load properly
        if (fileExtension == '.otf' ||
            fileExtension == '.ttf' ||
            fileExtension == '.woff' ||
            fileExtension == '.woff2') {
          request.response.headers.add('Access-Control-Allow-Origin', '*');
          request.response.headers.add(
            'Access-Control-Allow-Methods',
            'GET, OPTIONS',
          );
          request.response.headers.add(
            'Access-Control-Allow-Headers',
            'Origin, Content-Type',
          );
          request.response.headers.add(
            'Cache-Control',
            'public, max-age=31536000',
          );
        }

        // Add cache headers for static assets
        if (fileExtension != '.html' && fileExtension != '.json') {
          request.response.headers.add('Cache-Control', 'public, max-age=3600');
        }

        // Write the file contents
        request.response.add(fileContents);
        await request.response.close();

        return true;
      } catch (e) {
        session.log('Error serving file $filePath: $e');
      }
    }

    // If no static file found, serve the index.html for client-side routing
    try {
      final indexFile = File(appRootFilePath);
      if (await indexFile.exists()) {
        final fileContents = await indexFile.readAsBytes();

        // Set appropriate headers for HTML
        request.response.headers.contentType = ContentType.html;
        request.response.headers.add(
          'Cache-Control',
          'no-cache, no-store, must-revalidate',
        );

        // Write the file contents
        request.response.add(fileContents);
        await request.response.close();

        return true;
      }
    } catch (e) {
      session.log('Failed to serve SPA fallback: $e');
    }

    return false;
  }
}
