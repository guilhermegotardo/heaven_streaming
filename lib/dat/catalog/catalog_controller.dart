import 'catalog.dart';
import 'library_catalog_data_source.dart';
import 'media_library.dart';

class CatalogController {
  CatalogController._();

  static final CatalogController instance = CatalogController._();

  final MediaLibrary library = MediaLibrary.fromEnvironment();

  Catalog? _catalog;

  Catalog get catalog {
    if (_catalog == null) {
      throw Exception('Catalog not loaded yet');
    }
    return _catalog!;
  }

  Future<Catalog> loadCatalog() async {
    return _catalog ??= await LibraryCatalogDataSource(library).loadCatalog();
  }
}
