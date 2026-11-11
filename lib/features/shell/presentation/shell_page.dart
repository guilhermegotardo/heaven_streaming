import 'package:flutter/material.dart';

import '../../../app/navigation.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.g.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/state_view.dart';
import '../../../core/widgets/top_nav.dart';
import '../../../dat/catalog/catalog.dart';
import '../../../dat/catalog/catalog_controller.dart';
import '../../browse/presentation/browse_view.dart';
import '../../home/presentation/home_view.dart';
import '../../home/presentation/widgets/home_skeleton.dart';
import '../../my_list/presentation/my_list_view.dart';
import '../../search/presentation/search_view.dart';

/// The signed-in frame of the app: top nav on desktop, bottom nav on mobile,
/// and the section picked in [AppNavigation.tab]. Also owns the catalog
/// loading / error / empty states.
class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  late Future<Catalog> _catalog;

  @override
  void initState() {
    super.initState();
    _catalog = CatalogController.instance.loadCatalog();
  }

  void _retry() {
    setState(() {
      _catalog = CatalogController.instance.loadCatalog();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return ValueListenableBuilder<ShellTab>(
      valueListenable: AppNavigation.tab,
      builder: (context, tab, _) {
        final body = FutureBuilder<Catalog>(
          future: _catalog,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const HomeSkeleton();
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return StateView(
                icon: Icons.error_outline,
                title: 'Unable to load the catalog.',
                message:
                    'Check your connection or the catalog server and try again.',
                actionLabel: 'Try again',
                actionIcon: Icons.refresh,
                onAction: _retry,
              );
            }
            final videos = snapshot.data!.videos;
            if (videos.isEmpty) {
              return StateView(
                icon: Icons.movie_outlined,
                title: 'No videos in the catalog.',
                message: 'Add titles to the library and try again.',
                actionLabel: 'Try again',
                actionIcon: Icons.refresh,
                onAction: _retry,
              );
            }
            return KeyedSubtree(
              key: ValueKey(tab),
              child: _buildTab(tab, videos),
            );
          },
        );

        if (isMobile) {
          return Scaffold(
            body: body,
            bottomNavigationBar: _BottomNav(current: tab),
          );
        }
        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(child: body),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: TopNav(current: tab),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTab(ShellTab tab, List<Video> videos) {
    switch (tab) {
      case ShellTab.home:
        return HomeView(videos: videos);
      case ShellTab.series:
        return BrowseView(
          title: tab.label,
          videos: videos.where((video) => video.isSeries).toList(),
        );
      case ShellTab.movies:
        return BrowseView(
          title: tab.label,
          videos: videos.where((video) => !video.isSeries).toList(),
        );
      case ShellTab.newAndPopular:
        return BrowseView(
          title: tab.label,
          videos: [...videos]..sort((a, b) => b.year.compareTo(a.year)),
        );
      case ShellTab.myList:
        return MyListView(videos: videos);
      case ShellTab.search:
        return SearchView(videos: videos);
    }
  }
}

/// "Nav / Bottom" of the mobile design.
class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.current});

  final ShellTab current;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: AppSizes.bottomNavHeight,
          child: Row(
            children: [
              _BottomNavItem(
                icon: Icons.home_outlined,
                label: 'Home',
                selected:
                    current != ShellTab.search && current != ShellTab.myList,
                onTap: () => AppNavigation.goToTab(context, ShellTab.home),
              ),
              _BottomNavItem(
                icon: Icons.search,
                label: 'Search',
                selected: current == ShellTab.search,
                onTap: () => AppNavigation.goToTab(context, ShellTab.search),
              ),
              _BottomNavItem(
                icon: Icons.format_list_bulleted,
                label: 'My List',
                selected: current == ShellTab.myList,
                onTap: () => AppNavigation.goToTab(context, ShellTab.myList),
              ),
              _BottomNavItem(
                icon: Icons.person_outline,
                label: 'Profile',
                selected: false,
                onTap: () => AppNavigation.switchProfile(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.textPrimary : AppColors.textSecondary;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: AppSizes.iconMd, color: color),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
