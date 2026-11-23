import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_message_entity.dart';

abstract class CommunicationState extends Equatable {
  const CommunicationState();

  @override
  List<Object?> get props => [];
}

class CommunicationInitial extends CommunicationState {}

class CommunicationLoading extends CommunicationState {}

class CommunicationLoaded extends CommunicationState {
  final List<ChatMessageEntity> messages;
  final bool isSpecialistTyping;

  const CommunicationLoaded({
    required this.messages,
    this.isSpecialistTyping = false,
  });

  @override
  List<Object?> get props => [messages, isSpecialistTyping];
}

class CommunicationError extends CommunicationState {
  final String message;
  const CommunicationError(this.message);

  @override
  List<Object?> get props => [message];
}
