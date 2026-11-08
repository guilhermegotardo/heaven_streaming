import 'package:flutter/material.dart';

import 'app_tokens.g.dart';

abstract final class AppTheme {
  static ThemeData get dark {
    const colorScheme = ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.primaryHover,
      onSecondary: AppColors.onPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      surfaceContainer: AppColors.surface,
      surfaceContainerHigh: AppColors.surfaceRaised,
      error: AppColors.error,
      outline: AppColors.border,
      scrim: AppColors.scrim,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: AppFontFamily.base,
      textTheme: _textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: AppSizes.appBarHeight,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
          ),
          textStyle: const TextStyle(
            fontSize: AppFontSize.body,
            fontWeight: AppFontWeight.semibold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
          ),
        ),
      ),
      chipTheme: const ChipThemeData(
        backgroundColor: AppColors.surfaceRaised,
        labelStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppFontSize.bodySm,
        ),
        side: BorderSide.none,
        shape: StadiumBorder(),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: TextStyle(color: AppColors.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
        size: AppSizes.iconMd,
      ),
      dividerTheme: const DividerThemeData(color: AppColors.border),
    );
  }

  static const _textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: AppFontSize.display,
      fontWeight: AppFontWeight.bold,
      height: AppLineHeight.tight,
      color: AppColors.textPrimary,
    ),
    headlineMedium: TextStyle(
      fontSize: AppFontSize.headline,
      fontWeight: AppFontWeight.bold,
      height: AppLineHeight.tight,
      color: AppColors.textPrimary,
    ),
    titleLarge: TextStyle(
      fontSize: AppFontSize.title,
      fontWeight: AppFontWeight.semibold,
      height: AppLineHeight.tight,
      color: AppColors.textPrimary,
    ),
    titleMedium: TextStyle(
      fontSize: AppFontSize.titleSm,
      fontWeight: AppFontWeight.semibold,
      height: AppLineHeight.tight,
      color: AppColors.textPrimary,
    ),
    bodyLarge: TextStyle(
      fontSize: AppFontSize.body,
      fontWeight: AppFontWeight.regular,
      height: AppLineHeight.normal,
      color: AppColors.textPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: AppFontSize.bodySm,
      fontWeight: AppFontWeight.regular,
      height: AppLineHeight.normal,
      color: AppColors.textSecondary,
    ),
    labelLarge: TextStyle(
      fontSize: AppFontSize.bodySm,
      fontWeight: AppFontWeight.semibold,
      color: AppColors.textPrimary,
    ),
    bodySmall: TextStyle(
      fontSize: AppFontSize.caption,
      fontWeight: AppFontWeight.regular,
      height: AppLineHeight.normal,
      color: AppColors.textSecondary,
    ),
  );
}
