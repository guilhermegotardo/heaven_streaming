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