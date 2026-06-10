import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get light => _build(
        brightness: Brightness.light,
        seed: AppColors.primary,
        scaffoldBg: AppColors.backgroundLight,
        cardColor: AppColors.cardLight,
        appBarBg: AppColors.surfaceLight,
        appBarFg: AppColors.textPrimaryLight,
        inputFill: AppColors.backgroundLight,
        bodyColor: AppColors.textPrimaryLight,
        subtitleColor: AppColors.textSecondaryLight,
      );

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        seed: AppColors.primaryDark,
        scaffoldBg: AppColors.backgroundDark,
        cardColor: AppColors.cardDark,
        appBarBg: AppColors.surfaceDark,
        appBarFg: AppColors.textPrimaryDark,
        inputFill: AppColors.surfaceDark,
        bodyColor: AppColors.textPrimaryDark,
        subtitleColor: AppColors.textSecondaryDark,
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color seed,
    required Color scaffoldBg,
    required Color cardColor,
    required Color appBarBg,
    required Color appBarFg,
    required Color inputFill,
    required Color bodyColor,
    required Color subtitleColor,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorSchemeSeed: seed,
      scaffoldBackgroundColor: scaffoldBg,

      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: appBarBg,
        foregroundColor: appBarFg,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: appBarFg,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),

      chipTheme: const ChipThemeData(shape: StadiumBorder()),

      textTheme: TextTheme(
        titleLarge:  TextStyle(fontWeight: FontWeight.w700, color: bodyColor),
        titleMedium: TextStyle(fontWeight: FontWeight.w600, color: bodyColor),
        bodyLarge:   TextStyle(color: bodyColor),
        bodyMedium:  TextStyle(color: bodyColor),
        bodySmall:   TextStyle(color: subtitleColor),
        labelSmall:  TextStyle(color: subtitleColor),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: seed, width: 2),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: seed,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
