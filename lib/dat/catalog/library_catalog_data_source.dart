import 'dart:convert';

import 'package:http/http.dart' as http;

import 'catalogo.dart';
import 'media_library.dart';

class LibraryCatalogDataSource {
  final MediaLibrary library;
  LibraryCatalogDataSource(this.library);

  Future<Catalogo> loadCatalog() async {
    final response = await http.get(library.catalogUri);
    if (response.statusCode != 200) {
      throw Exception(
        'Falha ao carregar ${library.catalogUri}: HTTP ${response.statusCode}',
      );
    }
    final jsonMap = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return Catalogo.fromJson(jsonMap);
  }
}
