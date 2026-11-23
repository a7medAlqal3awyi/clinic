import 'dart:ui';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/profile_settings_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileSettingsEntity>> getSettings();
  Future<Either<Failure, void>> changeLanguage(Locale locale);
  Future<Either<Failure, void>> toggleNotifications(bool enabled);
}
