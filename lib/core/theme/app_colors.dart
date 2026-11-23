import 'package:flutter/material.dart';

@immutable
class AppCustomColors extends ThemeExtension<AppCustomColors> {
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color cardBackground;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color border;
  final Color divider;
  final Color success;
  final Color warning;
  final Color error;
  final Color info;
  final Color cardShadow;
  final Color chipBackground;
  final Color progressFill;

  const AppCustomColors({
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.cardBackground,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
    required this.divider,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.cardShadow,
    required this.chipBackground,
    required this.progressFill,
  });

  static const AppCustomColors light = AppCustomColors(
    primary: Color(0xFF1B6B4A),        // Calm Medical Forest Green
    primaryLight: Color(0xFFE8F5E9),   // Soft Mint Green
    primaryDark: Color(0xFF0F4730),    // Deep Evergreen
    secondary: Color(0xFF43A047),      // Fresh Plant Green
    background: Color(0xFFF8FAF9),     // Ultra soft clean grey-white
    surface: Color(0xFFFFFFFF),        // Pure White
    cardBackground: Color(0xFFFFFFFF), // White
    textPrimary: Color(0xFF1E293B),    // Slate 800
    textSecondary: Color(0xFF475569),  // Slate 600
    textMuted: Color(0xFF94A3B8),      // Slate 400
    border: Color(0xFFE2E8F0),         // Slate 200
    divider: Color(0xFFF1F5F9),        // Slate 100
    success: Color(0xFF10B981),        // Emerald 500
    warning: Color(0xFFF59E0B),        // Amber 500
    error: Color(0xFFEF4444),          // Red 500
    info: Color(0xFF0EA5E9),           // Sky 500
    cardShadow: Color(0x0C000000),      // 5% black subtle elevation
    chipBackground: Color(0xFFEFF6F0), // Subtle light green tint
    progressFill: Color(0xFF22C55E),   // Vibrant healthy green
  );

  static const AppCustomColors dark = AppCustomColors(
    primary: Color(0xFF2E8B57),
    primaryLight: Color(0xFF1E3A2F),
    primaryDark: Color(0xFF12281F),
    secondary: Color(0xFF48BB78),
    background: Color(0xFF0F172A),
    surface: Color(0xFF1E293B),
    cardBackground: Color(0xFF1E293B),
    textPrimary: Color(0xFFF8FAFC),
    textSecondary: Color(0xFFCBD5E1),
    textMuted: Color(0xFF64748B),
    border: Color(0xFF334155),
    divider: Color(0xFF1E293B),
    success: Color(0xFF34D399),
    warning: Color(0xFFFBBF24),
    error: Color(0xFFF87171),
    info: Color(0xFF38BDF8),
    cardShadow: Color(0x33000000),
    chipBackground: Color(0xFF1E3A2F),
    progressFill: Color(0xFF4ADE80),
  );

  @override
  ThemeExtension<AppCustomColors> copyWith({
    Color? primary,
    Color? primaryLight,
    Color? primaryDark,
    Color? secondary,
    Color? background,
    Color? surface,
    Color? cardBackground,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? border,
    Color? divider,
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
    Color? cardShadow,
    Color? chipBackground,
    Color? progressFill,
  }) {
    return AppCustomColors(
      primary: primary ?? this.primary,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryDark: primaryDark ?? this.primaryDark,
      secondary: secondary ?? this.secondary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      cardBackground: cardBackground ?? this.cardBackground,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,
      cardShadow: cardShadow ?? this.cardShadow,
      chipBackground: chipBackground ?? this.chipBackground,
      progressFill: progressFill ?? this.progressFill,
    );
  }

  @override
  ThemeExtension<AppCustomColors> lerp(ThemeExtension<AppCustomColors>? other, double t) {
    if (other is! AppCustomColors) return this;
    return AppCustomColors(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      border: Color.lerp(border, other.border, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      info: Color.lerp(info, other.info, t)!,
      cardShadow: Color.lerp(cardShadow, other.cardShadow, t)!,
      chipBackground: Color.lerp(chipBackground, other.chipBackground, t)!,
      progressFill: Color.lerp(progressFill, other.progressFill, t)!,
    );
  }
}
