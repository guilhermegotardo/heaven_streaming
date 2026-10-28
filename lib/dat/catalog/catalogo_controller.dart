import 'catalogo.dart';
import 'library_catalog_data_source.dart';
import 'media_library.dart';

class CatalogController {
  CatalogController._();

  static final CatalogController instance = CatalogController._();

  final MediaLibrary library = MediaLibrary.fromEnvironment();

  Catalogo? _catalogo;

  Catalogo get catalogo {
    if (_catalogo == null) {
      throw Exception('Catalogo ainda não carregado');
    }
    return _catalogo!;
  }

  Future<Catalogo> loadCatalog() async {
    return _catalogo ??= await LibraryCatalogDataSource(library).loadCatalog();
  }
}
