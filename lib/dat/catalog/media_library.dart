import 'package:flutter/foundation.dart';

/// Local de onde a biblioteca de vídeos é servida (pasta servida por HTTP).
///
/// Os caminhos do catalog.json são relativos a [baseUri]. Na v2.0 basta
/// apontar [baseUri] para a CDN/servidor remoto.
class MediaLibrary {
  final Uri baseUri;

  MediaLibrary(Uri baseUri)
    : baseUri = baseUri.path.endsWith('/')
          ? baseUri
          : baseUri.replace(path: '${baseUri.path}/');

  /// Usa `--dart-define=LIBRARY_URL=...` se informado. Senão, na web usa o
  /// mesmo host que serviu o app (porta 8081); no desktop, localhost:8081.
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
