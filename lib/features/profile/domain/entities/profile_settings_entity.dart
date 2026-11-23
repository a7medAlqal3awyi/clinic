import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ProfileSettingsEntity extends Equatable {
  final Locale locale;
  final bool notificationsEnabled;
  final ThemeMode themeMode;

  const ProfileSettingsEntity({
    required this.locale,
    this.notificationsEnabled = true,
    this.themeMode = ThemeMode.light,
  });

  ProfileSettingsEntity copyWith({
    Locale? locale,
    bool? notificationsEnabled,
    ThemeMode? themeMode,
  }) {
    return ProfileSettingsEntity(
      locale: locale ?? this.locale,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props => [locale, notificationsEnabled, themeMode];
}
