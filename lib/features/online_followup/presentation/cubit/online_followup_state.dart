import 'package:equatable/equatable.dart';
import '../../domain/entities/online_followup_entity.dart';

abstract class OnlineFollowupState extends Equatable {
  const OnlineFollowupState();

  @override
  List<Object?> get props => [];
}

class OnlineFollowupInitial extends OnlineFollowupState {}

class OnlineFollowupLoading extends OnlineFollowupState {}

class OnlineFollowupLoaded extends OnlineFollowupState {
  final List<OnlineFollowupEntity> history;
  const OnlineFollowupLoaded(this.history);

  @override
  List<Object?> get props => [history];
}

class OnlineFollowupSubmitted extends OnlineFollowupState {
  final OnlineFollowupEntity submission;
  const OnlineFollowupSubmitted(this.submission);

  @override
  List<Object?> get props => [submission];
}

class OnlineFollowupError extends OnlineFollowupState {
  final String message;
  const OnlineFollowupError(this.message);

  @override
  List<Object?> get props => [message];
}
