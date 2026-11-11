import 'package:flutter/material.dart';

import '../../app/navigation.dart';
import '../../dat/profiles/profile_controller.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.g.dart';
import '../utils/responsive.dart';
import 'brand_logo.dart';

/// "Nav / Top": logo, sections, search, notifications and the profile menu
/// over a fading background. Meant to be laid over the top of the page.
class TopNav extends StatelessWidget {
  const TopNav({super.key, this.current});

  /// The highlighted section; null on pages outside the sections (details).
  final ShellTab? current;

  static const _sections = [
    ShellTab.home,
    ShellTab.series,
    ShellTab.movies,
    ShellTab.newAndPopular,
    ShellTab.myList,
  ];

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.pagePadding(context);
    return Container(
      height: AppSizes.navHeight,
      padding: EdgeInsets.symmetric(horizontal: padding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          // Stays dark behind the items so scrolled content does not show
          // through them, then fades out like the design.
          colors: [
            AppColors.background.withValues(alpha: 0.95),
            AppColors.background.withValues(alpha: 0.85),
            AppColors.background.withValues(alpha: 0),
          ],
          stops: const [0, 0.65, 1],
        ),
      ),
      child: Row(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => AppNavigation.goToTab(context, ShellTab.home),
              child: const BrandLogo(),
            ),
          ),
          const SizedBox(width: AppSpacing.huge),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final section in _sections)
                    _NavItem(
                      label: section.label,
                      selected: section == current,
                      onTap: () => AppNavigation.goToTab(context, section),
                    ),
                ],
              ),
            ),
          ),
          IconButton(
            tooltip: 'Search',
            onPressed: () => AppNavigation.goToTab(context, ShellTab.search),
            color: current == ShellTab.search
                ? AppColors.primary
                : AppColors.textPrimary,
            icon: const Icon(Icons.search),
          ),
          const SizedBox(width: AppSpacing.sm),
          PopupMenuButton<void>(
            tooltip: 'Notifications',
            position: PopupMenuPosition.under,
            color: AppColors.surfaceRaised,
            icon: const Icon(
              Icons.notifications_none,
              color: AppColors.textPrimary,
            ),
            itemBuilder: (_) => const [
              PopupMenuItem(
                enabled: false,
                child: Text('No new notifications'),
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.sm),
          const _ProfileMenu(),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        child: Text(
          label,
          maxLines: 1,
          style: selected ? AppTextStyles.bodyStrong : AppTextStyles.body,
        ),
      ),
    );
  }
}

class _ProfileMenu extends StatelessWidget {
  const _ProfileMenu();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ProfileController.instance,
      builder: (context, _) {
        final profile = ProfileController.instance.current;
        return PopupMenuButton<void>(
          tooltip: 'Profile',
          position: PopupMenuPosition.under,
          color: AppColors.surfaceRaised,
          itemBuilder: (_) => [
            if (profile != null)
              PopupMenuItem(enabled: false, child: Text(profile.name)),
            PopupMenuItem(
              onTap: () => AppNavigation.switchProfile(context),
              child: const Text('Switch profile'),
            ),
          ],
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: profile?.avatar,
                  color: AppColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: AppColors.textPrimary,
              ),
            ],
          ),
        );
      },
    );
  }
}
