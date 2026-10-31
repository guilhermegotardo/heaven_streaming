// Development server for the video library.
//
// Usage: dart run tool/serve_library.dart [folder] [port]
//   folder: defaults to example_library
//   port: defaults to 8081
//
// Supports Range requests (needed to seek in the video) and sends CORS
// headers so the web app, served on another port, can read the files.
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';

const _corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, HEAD, OPTIONS',
  'Access-Control-Allow-Headers': 'Range',
  'Access-Control-Expose-Headers': 'Content-Length, Content-Range, Accept-Ranges',
};

Middleware _cors() => (inner) => (request) async {
  if (request.method == 'OPTIONS') {
    return Response.ok(null, headers: _corsHeaders);
  }
  final response = await inner(request);
  return response.change(headers: _corsHeaders);
};

Future<void> main(List<String> args) async {
  final root = args.isNotEmpty ? args[0] : 'example_library';
  final port = args.length > 1 ? int.parse(args[1]) : 8081;

  if (!File('$root/catalog.json').existsSync()) {
    stderr.writeln('catalog.json not found in "$root".');
    exit(1);
  }

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(_cors())
      .addHandler(createStaticHandler(root));

  final server = await io.serve(handler, InternetAddress.anyIPv4, port);
  stdout.writeln('Library "$root" at http://${server.address.host}:${server.port}/');
}
