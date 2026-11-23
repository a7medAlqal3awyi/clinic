import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Headings
  static TextStyle displayLarge(BuildContext context) => TextStyle(
        fontSize: 26.sp,
        fontWeight: FontWeight.w800,
        color: Theme.of(context).extension<AppCustomColors>()?.textPrimary ?? const Color(0xFF1E293B),
        letterSpacing: -0.5,
        height: 1.25,
      );

  static TextStyle displayMedium(BuildContext context) => TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).extension<AppCustomColors>()?.textPrimary ?? const Color(0xFF1E293B),
        letterSpacing: -0.3,
        height: 1.3,
      );

  static TextStyle headingLarge(BuildContext context) => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).extension<AppCustomColors>()?.textPrimary ?? const Color(0xFF1E293B),
        height: 1.35,
      );

  static TextStyle headingMedium(BuildContext context) => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).extension<AppCustomColors>()?.textPrimary ?? const Color(0xFF1E293B),
        height: 1.4,
      );

  static TextStyle headingSmall(BuildContext context) => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).extension<AppCustomColors>()?.textPrimary ?? const Color(0xFF1E293B),
      );

  // Body
  static TextStyle bodyLarge(BuildContext context) => TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).extension<AppCustomColors>()?.textPrimary ?? const Color(0xFF1E293B),
        height: 1.5,
      );

  static TextStyle bodyMedium(BuildContext context) => TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).extension<AppCustomColors>()?.textSecondary ?? const Color(0xFF475569),
        height: 1.5,
      );

  static TextStyle bodySmall(BuildContext context) => TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).extension<AppCustomColors>()?.textMuted ?? const Color(0xFF94A3B8),
        height: 1.4,
      );

  // Labels & Buttons
  static TextStyle button(BuildContext context) => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 0.2,
      );

  static TextStyle label(BuildContext context) => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).extension<AppCustomColors>()?.textSecondary ?? const Color(0xFF475569),
      );

  static TextStyle caption(BuildContext context) => TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).extension<AppCustomColors>()?.textMuted ?? const Color(0xFF94A3B8),
      );
}
