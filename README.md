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


## Project structure

The UI follows `design/penpot-design/Design.penpot` (pages "03 · Desktop / TV"
and "04 · Mobile"). Flow: Splash → Who's watching? → Home.

```
lib/
├── main.dart
├── app/
│   ├── app_widget.dart                        # MaterialApp, routes
│   ├── routes.dart                            # splash, profiles, home
│   └── navigation.dart                        # sections, open details / player
├── core/
│   ├── theme/                                 # tokens (generated), theme, text styles, key art
│   ├── utils/                                 # breakpoints, formatters
│   └── widgets/                               # buttons, chips, cards, top nav, backdrop…
├── dat/
│   ├── catalog/                               # models, HTTP data source, controller
│   ├── profiles/profile_controller.dart       # "Who's watching?" profiles (in memory)
│   ├── my_list/my_list_controller.dart        # My List per profile (in memory)
│   └── progress/watch_progress_controller.dart # Continue Watching (in memory)
└── features/
    ├── splash/                                # 01 Splash
    ├── profiles/                              # 02 Who's watching?
    ├── shell/                                 # top / bottom nav, loading / error states
    ├── home/                                  # 03 Home: hero + rails
    ├── browse/                                # Series, Movies, New & Popular, "See all"
    ├── details/                               # 04 / 05 Details (movie, series + episodes)
    ├── search/                                # 06 Search
    ├── my_list/                               # 08 My List, 11 Empty
    └── player/media_player.dart               # 07 Player, auto-play next

test/
└── ui_smoke_test.dart                         # every screen at desktop and mobile sizes

tool/
└── serve_library.dart                         # dev server for the video library
```

Design tokens live in `design/tokens/tokens.json`; run `npm run tokens` inside
`design/` to regenerate `lib/core/theme/app_tokens.g.dart`.


## Video library (local until v2.0)

Videos are not bundled with the app. They live in a folder served over HTTP:

```
example_library/
├── catalog.json        # metadata; paths relative to the folder
└── m001/
    ├── video.mp4
    └── poster.jpg
```

Series have no `videoPath`; instead they carry an `episodes` list:

```json
{
  "id": "m001",
  "title": "O Pequeno Urso",
  "posterPath": "m001/poster.png",
  "episodes": [
    {
      "season": 1,
      "number": 1,
      "title": "Brincando na Neve",
      "videoPath": "m001/O_Pequeno_Urso/SEASON_1-1/O Pequeno Urso - S01E01 - Brincando na Neve.mp4"
    }
  ]
}
```

Run it in two terminals:

```bash
# 1. Library server (port 8081; accepts another folder/port)
dart run tool/serve_library.dart                      # uses example_library
dart run tool/serve_library.dart ~/Videos/Gotflix 8081

# 2. App
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
flutter run -d linux
```

On the web, the app fetches the library from the same host that served it, on port 8081.
On desktop, from `localhost:8081`. For another address:

```bash
flutter run -d linux --dart-define=LIBRARY_URL=http://192.168.0.10:8081/
```

After changing `lib/dat/catalog/catalog.dart`, regenerate the code:

```bash
dart run build_runner build --delete-conflicting-outputs
```
