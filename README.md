# heaven_streaming

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


lib/
 └── data/
      └── catalog/
           ├── catalog_data_source.dart        (abstract)
           ├── asset_catalog_data_source.dart
           ├── http_catalog_data_source.dart
           └── file_catalog_data_source.dart   (se precisar)


lib/
├── main.dart
├── app/
│   ├── app_widget.dart
│   └── routes.dart
├── features/
│   ├── splash/
│   │   ├── presentation/
│   │   │   ├── splash_page.dart
│   │   │   └── splash_controller.dart
│   └── home/
│       └── presentation/
│           └── home_page.dart
└── core/
    └── widgets/
        └── app_loading.dart


## Biblioteca de vídeos (local até a v2.0)

Os vídeos não ficam dentro do app. Eles ficam numa pasta servida por HTTP:

```
example_library/
├── catalog.json        # metadados; caminhos relativos à pasta
└── m001/
    ├── video.mp4
    └── poster.jpg
```

Séries não têm `videoPath`; em vez disso trazem uma lista `episodios`:

```json
{
  "id": "m001",
  "titulo": "O Pequeno Urso",
  "posterPath": "m001/poster.png",
  "episodios": [
    {
      "temporada": 1,
      "numero": 1,
      "titulo": "Brincando na Neve",
      "videoPath": "m001/O_Pequeno_Urso/SEASON_1-1/O Pequeno Urso - S01E01 - Brincando na Neve.mp4"
    }
  ]
}
```

Rodando em dois terminais:

```bash
# 1. Servidor da biblioteca (porta 8081; aceita outra pasta/porta)
dart run tool/serve_library.dart                      # usa example_library
dart run tool/serve_library.dart ~/Videos/Gotflix 8081

# 2. App
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
flutter run -d linux
```

Na web, o app busca a biblioteca no mesmo host que o serviu, na porta 8081.
No desktop, em `localhost:8081`. Para outro endereço:

```bash
flutter run -d linux --dart-define=LIBRARY_URL=http://192.168.0.10:8081/
```

Depois de alterar `lib/dat/catalog/catalogo.dart`, regenere o código:

```bash
dart run build_runner build --delete-conflicting-outputs
```
