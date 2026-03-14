import 'local_catalog_data_source.dart';
import 'catalogo.dart';

class CatalogController {
  CatalogController._();

  static final CatalogController instance = CatalogController._();

  Catalogo? _catalogo;

  Catalogo get catalogo {
    if (_catalogo == null) {
      throw Exception('Catalogo ainda não carregado');
    }
    return _catalogo!;
  }

  Future<void> loadCatalog() async {
    if (_catalogo != null) return;

    final dataSource = LocalCatalogDataSource();
    _catalogo = await dataSource.loadCatalog();
  }
}