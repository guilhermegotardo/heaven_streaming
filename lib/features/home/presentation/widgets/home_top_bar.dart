import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.g.dart';
import '../../../../core/widgets/brand_logo.dart';

/// What the home is showing.
enum CatalogFilter {
  all('Home'),
  series('Series'),
  movies('Movies');

  const CatalogFilter(this.label);
  final String label;
}

/// Penpot "Nav/Top": logo + catalog filters.
///
/// Wide: one row over the hero, fading from the background.
/// Compact: logo, then "Series" / "Movies" chips (tap again to go back to all).
class HomeTopBar extends StatelessWidget {
  const HomeTopBar({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.compact,
    required this.horizontalPadding,
  });

  final CatalogFilter selected;
  final ValueChanged<CatalogFilter> onSelect;
  final bool compact;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) => compact ? _buildCompact() : _buildWide();

  Widget _buildWide() {
    return Container(
      height: 96,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background.withValues(alpha: 0.95),
            AppColors.background.withValues(alpha: 0),
          ],
        ),
      ),
      child: Row(
        children: [
          const BrandLogo(),
          const SizedBox(width: AppSpacing.xxxl),
          for (final filter in CatalogFilter.values)
            _NavItem(
              label: filter.label,
              active: filter == selected,
              onTap: () => onSelect(filter),
            ),
        ],
      ),
    );
  }

  Widget _buildCompact() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.md),
          const BrandLogo(size: 24),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final filter in [CatalogFilter.series, CatalogFilter.movies])
                _FilterChip(
                  label: filter.label,
                  selected: filter == selected,
                  onTap: () => onSelect(filter == selected ? CatalogFilter.all : filter),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        child: Text(
          label,
          style: TextStyle(
            fontSize: AppFontSize.body,
            fontWeight: active ? AppFontWeight.semibold : AppFontWeight.regular,
            color: active ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      backgroundColor: Colors.transparent,
      selectedColor: AppColors.textPrimary,
      side: BorderSide(color: selected ? AppColors.textPrimary : AppColors.border),
      shape: const StadiumBorder(),
      labelStyle: TextStyle(
        fontFamily: AppFontFamily.base,
        fontSize: AppFontSize.bodySm,
        fontWeight: AppFontWeight.semibold,
        color: selected ? AppColors.background : AppColors.textPrimary,
      ),
    );
  }
}
