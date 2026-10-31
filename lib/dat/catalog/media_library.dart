import 'package:flutter/foundation.dart';

/// Where the video library is served from (a folder served over HTTP).
///
/// Paths in catalog.json are relative to [baseUri]. In v2.0 it is enough to
/// point [baseUri] at the CDN/remote server.
class MediaLibrary {
  final Uri baseUri;

  MediaLibrary(Uri baseUri)
    : baseUri = baseUri.path.endsWith('/')
          ? baseUri
          : baseUri.replace(path: '${baseUri.path}/');

  /// Uses `--dart-define=LIBRARY_URL=...` when given. Otherwise, on the web it
  /// uses the same host that served the app (port 8081); on desktop, localhost:8081.
  factory MediaLibrary.fromEnvironment() {
    const url = String.fromEnvironment('LIBRARY_URL');
    if (url.isNotEmpty) return MediaLibrary(Uri.parse(url));
    if (kIsWeb) {
      return MediaLibrary(
        Uri(scheme: Uri.base.scheme, host: Uri.base.host, port: 8081, path: '/'),
      );
    }
    return MediaLibrary(Uri.parse('http://localhost:8081/'));
  }

  Uri get catalogUri => resolve('catalog.json');

  Uri resolve(String relativePath) => baseUri.resolve(relativePath);
}
