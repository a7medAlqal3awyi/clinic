import 'package:equatable/equatable.dart';
import '../../domain/entities/profile_settings_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileSettingsEntity settings;
  const ProfileLoaded(this.settings);

  @override
  List<Object?> get props => [settings];
}
