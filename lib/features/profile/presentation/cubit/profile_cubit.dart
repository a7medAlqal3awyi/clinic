import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entities/profile_settings_entity.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final SharedPreferences sharedPreferences;

  ProfileCubit({required this.sharedPreferences})
      : super(const ProfileLoaded(ProfileSettingsEntity(locale: Locale('ar'))));

  void initSettings() {
    final langCode = sharedPreferences.getString(AppConstants.prefsLocaleKey) ?? 'ar';
    final notifs = sharedPreferences.getBool('notifications_enabled') ?? true;
    emit(ProfileLoaded(ProfileSettingsEntity(
      locale: Locale(langCode),
      notificationsEnabled: notifs,
    )));
  }

  Future<void> changeLanguage(Locale locale) async {
    await sharedPreferences.setString(AppConstants.prefsLocaleKey, locale.languageCode);
    if (state is ProfileLoaded) {
      final current = (state as ProfileLoaded).settings;
      emit(ProfileLoaded(current.copyWith(locale: locale)));
    } else {
      emit(ProfileLoaded(ProfileSettingsEntity(locale: locale)));
    }
  }

  Future<void> toggleNotifications(bool enabled) async {
    await sharedPreferences.setBool('notifications_enabled', enabled);
    if (state is ProfileLoaded) {
      final current = (state as ProfileLoaded).settings;
      emit(ProfileLoaded(current.copyWith(notificationsEnabled: enabled)));
    }
  }
}
