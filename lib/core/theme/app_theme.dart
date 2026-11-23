import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppCustomColors.light.primary,
      scaffoldBackgroundColor: AppCustomColors.light.background,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF1E293B)),
      ),
      cardTheme: CardThemeData(
        color: AppCustomColors.light.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppCustomColors.light.border, width: 1),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppCustomColors.light.divider,
        thickness: 1,
        space: 1,
      ),
      colorScheme: ColorScheme.light(
        primary: AppCustomColors.light.primary,
        secondary: AppCustomColors.light.secondary,
        surface: AppCustomColors.light.surface,
        error: AppCustomColors.light.error,
      ),
      extensions: const [
        AppCustomColors.light,
      ],
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppCustomColors.dark.primary,
      scaffoldBackgroundColor: AppCustomColors.dark.background,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: Color(0xFFF8FAFC)),
      ),
      cardTheme: CardThemeData(
        color: AppCustomColors.dark.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppCustomColors.dark.border, width: 1),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppCustomColors.dark.divider,
        thickness: 1,
        space: 1,
      ),
      colorScheme: ColorScheme.dark(
        primary: AppCustomColors.dark.primary,
        secondary: AppCustomColors.dark.secondary,
        surface: AppCustomColors.dark.surface,
        error: AppCustomColors.dark.error,
      ),
      extensions: const [
        AppCustomColors.dark,
      ],
    );
  }
}
