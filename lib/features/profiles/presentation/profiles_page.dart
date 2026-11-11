import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.g.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/brand_logo.dart';
import '../../../dat/profiles/profile_controller.dart';

/// "02 Profiles" — the "Who's watching?" screen shown after the splash.
/// Picking a profile opens the home page.
class ProfilesPage extends StatefulWidget {
  const ProfilesPage({super.key});

  @override
  State<ProfilesPage> createState() => _ProfilesPageState();
}

class _ProfilesPageState extends State<ProfilesPage> {
  final ProfileController _profiles = ProfileController.instance;

  /// "Manage Profiles" mode: tapping a profile removes it.
  bool _managing = false;

  void _select(Profile profile) {
    _profiles.select(profile);
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  Future<void> _addProfile() async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => const _AddProfileDialog(),
    );
    if (name != null) _profiles.add(name);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final padding = Responsive.pagePadding(context);
    final avatar = isMobile ? 104.0 : AppSizes.profileAvatar;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: padding,
              top: isMobile ? AppSpacing.lg : 40,
              child: BrandLogo(
                fontSize: isMobile ? AppFontSize.title : AppFontSize.logo,
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: padding,
                  vertical: AppSizes.navHeight,
                ),
                child: ListenableBuilder(
                  listenable: _profiles,
                  builder: (context, _) {
                    final canRemove =
                        _managing && _profiles.profiles.length > 1;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Who's watching?",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.display.copyWith(
                            fontSize: isMobile
                                ? AppFontSize.headline
                                : AppFontSize.displayLg,
                          ),
                        ),
                        SizedBox(height: isMobile ? AppSpacing.xxl : 72),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: isMobile ? AppSpacing.xl : AppSpacing.xxxl,
                          runSpacing: AppSpacing.xxl,
                          children: [
                            for (final profile in _profiles.profiles)
                              _ProfileTile(
                                label: profile.name,
                                size: avatar,
                                gradient: profile.avatar,
                                overlayIcon: canRemove
                                    ? Icons.delete_outline
                                    : null,
                                onTap: canRemove
                                    ? () => _profiles.remove(profile)
                                    : () => _select(profile),
                              ),
                            if (_profiles.canAdd)
                              _ProfileTile(
                                label: 'Add Profile',
                                size: avatar,
                                onTap: _addProfile,
                              ),
                          ],
                        ),
                        SizedBox(height: isMobile ? AppSpacing.xxxl : 112),
                        AppButton(
                          label: _managing ? 'Done' : 'Manage Profiles',
                          variant: AppButtonVariant.outline,
                          onPressed: () =>
                              setState(() => _managing = !_managing),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Square avatar with the name underneath. Without a [gradient] it is the
/// dashed "Add Profile" tile.
class _ProfileTile extends StatefulWidget {
  const _ProfileTile({
    required this.label,
    required this.size,
    required this.onTap,
    this.gradient,
    this.overlayIcon,
  });

  final String label;
  final double size;
  final VoidCallback onTap;
  final Gradient? gradient;
  final IconData? overlayIcon;

  @override
  State<_ProfileTile> createState() => _ProfileTileState();
}

class _ProfileTileState extends State<_ProfileTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    final gradient = widget.gradient;
    final radius = BorderRadius.circular(AppRadius.lg);
    final compact = size < AppSizes.profileAvatar;

    final Widget avatar;
    if (gradient == null) {
      avatar = CustomPaint(
        painter: const _DashedBorderPainter(),
        child: Center(
          child: Icon(
            Icons.add,
            size: compact ? AppSizes.iconLg : 56,
            color: AppColors.textSecondary,
          ),
        ),
      );
    } else {
      avatar = DecoratedBox(
        decoration: BoxDecoration(gradient: gradient, borderRadius: radius),
        child: widget.overlayIcon == null
            ? null
            : DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.scrim,
                  borderRadius: radius,
                ),
                child: Center(
                  child: Icon(
                    widget.overlayIcon,
                    size: compact ? AppSizes.iconLg : AppSpacing.xxxl,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
      );
    }

    return Semantics(
      button: true,
      label: widget.label,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: SizedBox(
            width: size,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: size,
                  height: size,
                  foregroundDecoration: BoxDecoration(
                    borderRadius: radius,
                    border: Border.all(
                      color: _hovered && gradient != null
                          ? AppColors.textPrimary
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                  child: avatar,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: (compact ? AppTextStyles.body : AppTextStyles.title)
                      .copyWith(
                        fontWeight: AppFontWeight.regular,
                        color: _hovered
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The 2px dashed rounded outline of "profile / add".
class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter();

  static const _dash = 12.0;
  static const _gap = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textDisabled
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final outline = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          (Offset.zero & size).deflate(1),
          const Radius.circular(AppRadius.lg),
        ),
      );
    for (final metric in outline.computeMetrics()) {
      for (var start = 0.0; start < metric.length; start += _dash + _gap) {
        canvas.drawPath(metric.extractPath(start, start + _dash), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) => false;
}

class _AddProfileDialog extends StatefulWidget {
  const _AddProfileDialog();

  @override
  State<_AddProfileDialog> createState() => _AddProfileDialogState();
}

class _AddProfileDialogState extends State<_AddProfileDialog> {
  final TextEditingController _name = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    Navigator.pop(context, name);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text('Add Profile', style: AppTextStyles.title),
      content: TextField(
        controller: _name,
        autofocus: true,
        maxLength: 16,
        textCapitalization: TextCapitalization.words,
        style: AppTextStyles.bodyStrong,
        decoration: const InputDecoration(hintText: 'Name'),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Add')),
      ],
    );
  }
}
