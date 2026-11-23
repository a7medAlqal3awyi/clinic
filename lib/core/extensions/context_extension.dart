import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

extension ThemeContextExtension on BuildContext {
  AppCustomColors get customColors {
    return Theme.of(this).extension<AppCustomColors>() ?? AppCustomColors.light;
  }

  ThemeData get theme => Theme.of(this);
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
