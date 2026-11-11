import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heaven_streaming/app/app_widget.dart';
import 'package:heaven_streaming/app/navigation.dart';
import 'package:heaven_streaming/core/theme/app_theme.dart';
import 'package:heaven_streaming/core/widgets/app_button.dart';
import 'package:heaven_streaming/dat/catalog/catalog.dart';
import 'package:heaven_streaming/dat/catalog/catalog_controller.dart';
import 'package:heaven_streaming/dat/my_list/my_list_controller.dart';
import 'package:heaven_streaming/dat/profiles/profile_controller.dart';
import 'package:heaven_streaming/dat/progress/watch_progress_controller.dart';
import 'package:heaven_streaming/features/details/presentation/details_page.dart';
import 'package:heaven_streaming/features/profiles/presentation/profiles_page.dart';
import 'package:heaven_streaming/features/shell/presentation/shell_page.dart';

import 'support/catalog_fixture.dart';

/// Window sizes: the 1920 design frame, a small laptop, the narrowest desktop
/// layout, and the 390 mobile frame in both orientations.
const sizes = <String, Size>{
  'desktop 1920x1080': Size(1920, 1080),
  'desktop 1280x720': Size(1280, 720),
  'desktop 900x600': Size(900, 600),
  'mobile 390x844': Size(390, 844),
  'mobile 844x390': Size(844, 390),
};

/// Scrolls [finder] to the middle of the viewport (clear of the top nav).
Future<void> reveal(WidgetTester tester, Finder finder) async {
  await Scrollable.ensureVisible(tester.element(finder), alignment: 0.5);
  await tester.pump();
}

Future<void> pumpAt(WidgetTester tester, Size size, Widget home) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MaterialApp(theme: AppTheme.dark, home: home));
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  late Catalog catalog;

  setUp(() {
    catalog = buildCatalog();
    CatalogController.instance.debugCatalog = catalog;
    ProfileController.instance.select(
      ProfileController.instance.profiles.first,
    );
    AppNavigation.tab.value = ShellTab.home;
    MyListController.instance.clear();
    WatchProgressController.instance.clear();
  });

  testWidgets('splash goes to "Who\'s watching?" and a profile opens Home', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const AppWidget());
    expect(find.text('STREAMING'), findsOneWidget);
    expect(find.text("Who's watching?"), findsNothing);

    // The splash stays for 2 seconds, then the profile picker replaces it.
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('STREAMING'), findsNothing);
    expect(find.text("Who's watching?"), findsOneWidget);
    for (final name in ['Gui', 'Ana', 'Kids', 'Guest', 'Add Profile']) {
      expect(find.text(name), findsOneWidget);
    }
    expect(find.text('Manage Profiles'), findsOneWidget);
    expect(find.text('Trending Now'), findsNothing);

    await tester.tap(find.text('Ana'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(ProfileController.instance.current?.name, 'Ana');
    expect(find.text("Who's watching?"), findsNothing);
    expect(find.text('Trending Now'), findsOneWidget);

    // "Switch profile" in the avatar menu returns to the picker.
    await tester.tap(find.byTooltip('Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Switch profile'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text("Who's watching?"), findsOneWidget);
  });

  testWidgets('profiles can be added and removed', (tester) async {
    await pumpAt(tester, const Size(1920, 1080), const ProfilesPage());

    await tester.tap(find.text('Add Profile'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Leo');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    expect(find.text('Leo'), findsOneWidget);
    // Five profiles is the limit, so the add tile goes away.
    expect(find.text('Add Profile'), findsNothing);

    await tester.tap(find.text('Manage Profiles'));
    await tester.pump();
    await tester.tap(find.text('Leo'));
    await tester.pumpAndSettle();
    expect(find.text('Leo'), findsNothing);
    expect(find.text('Add Profile'), findsOneWidget);
    await tester.tap(find.text('Done'));
    await tester.pump();
    expect(find.text('Manage Profiles'), findsOneWidget);
  });

  for (final MapEntry(key: name, value: size) in sizes.entries) {
    group(name, () {
      testWidgets('profiles', (tester) async {
        await pumpAt(tester, size, const ProfilesPage());
        expect(find.text("Who's watching?"), findsOneWidget);
      });

      for (final tab in ShellTab.values) {
        testWidgets('shell: ${tab.label}', (tester) async {
          AppNavigation.tab.value = tab;
          await pumpAt(tester, size, const ShellPage());
          if (tab == ShellTab.myList) {
            expect(find.text('Your list is empty'), findsOneWidget);
          }
          // Scroll to the end so every lazily built row is laid out.
          final scrollable = find.byWidgetPredicate(
            (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
          );
          if (scrollable.evaluate().isNotEmpty) {
            await tester.drag(scrollable.first, const Offset(0, -3000));
            await tester.pump(const Duration(milliseconds: 300));
          }
        });
      }

      testWidgets('shell: Home with Continue Watching and a filled My List', (
        tester,
      ) async {
        WatchProgressController.instance.save(
          videoId: 'v0',
          episodeIndex: 6,
          position: const Duration(minutes: 20),
          duration: const Duration(minutes: 50),
        );
        WatchProgressController.instance.save(
          videoId: 'v1',
          position: const Duration(minutes: 5),
          duration: const Duration(minutes: 90),
        );
        for (final video in catalog.videos) {
          MyListController.instance.toggle(video.id);
        }

        await pumpAt(tester, size, const ShellPage());
        expect(find.textContaining('Continue Watching'), findsOneWidget);
        expect(find.text('S2:E2 · 30m left'), findsOneWidget);
        expect(find.text('1h 25m left'), findsOneWidget);

        AppNavigation.tab.value = ShellTab.myList;
        await tester.pump(const Duration(milliseconds: 300));
        expect(find.text('Your list is empty'), findsNothing);
        expect(find.text('Recently added'), findsOneWidget);
      });

      testWidgets('shell: search filters the results', (tester) async {
        AppNavigation.tab.value = ShellTab.search;
        await pumpAt(tester, size, const ShellPage());
        expect(find.text('Top Searches'), findsOneWidget);

        await tester.enterText(find.byType(TextField), 'iron');
        await tester.pump(const Duration(milliseconds: 300));
        expect(find.text('Top results for "iron"'), findsOneWidget);
        expect(find.text('Iron Valley'), findsOneWidget);
        expect(find.text('Neon Drift'), findsNothing);

        await tester.enterText(find.byType(TextField), 'zzz');
        await tester.pump(const Duration(milliseconds: 300));
        expect(find.text('No results'), findsOneWidget);
      });

      testWidgets('shell: catalog error state', (tester) async {
        CatalogController.instance.debugCatalog = Catalog(videos: []);
        await pumpAt(tester, size, const ShellPage());
        expect(find.text('No videos in the catalog.'), findsOneWidget);
        expect(find.text('Try again'), findsOneWidget);
      });

      testWidgets('details: movie', (tester) async {
        await pumpAt(tester, size, DetailsPage(video: catalog.videos[1]));
        expect(find.text('Iron Valley'), findsWidgets);
        expect(find.text('More Like This'), findsOneWidget);
        expect(find.text('Play'), findsOneWidget);

        // "My List" toggles the title in the profile's list.
        expect(MyListController.instance.contains('v1'), isFalse);
        final myList = find.widgetWithText(AppButton, 'My List');
        await reveal(tester, myList);
        await tester.tap(myList);
        await tester.pump();
        expect(MyListController.instance.contains('v1'), isTrue);
      });

      testWidgets('details: series', (tester) async {
        WatchProgressController.instance.save(
          videoId: 'v2',
          episodeIndex: 2,
          position: const Duration(minutes: 10),
          duration: const Duration(minutes: 40),
        );
        await pumpAt(tester, size, DetailsPage(video: catalog.videos[2]));
        expect(find.text('Resume S1:E3'), findsOneWidget);
        expect(find.text('Season 1'), findsOneWidget);
        expect(find.textContaining('5 episodes'), findsOneWidget);
        expect(find.textContaining('30m left'), findsOneWidget);

        final scrollable = find.byWidgetPredicate(
          (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
        );
        await tester.drag(scrollable.first, const Offset(0, -3000));
        await tester.pump(const Duration(milliseconds: 300));

        await reveal(tester, find.text('More Like This'));
        await tester.tap(find.text('More Like This'));
        await tester.pump(const Duration(milliseconds: 300));
        expect(find.textContaining('5 episodes'), findsNothing);
      });
    });
  }
}
