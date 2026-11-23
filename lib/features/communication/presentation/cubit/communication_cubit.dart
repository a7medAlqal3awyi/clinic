import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/usecase.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/usecases/communication_usecases.dart';
import 'communication_state.dart';

class CommunicationCubit extends Cubit<CommunicationState> {
  final GetChatMessagesUseCase getChatMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;

  CommunicationCubit({
    required this.getChatMessagesUseCase,
    required this.sendMessageUseCase,
  }) : super(CommunicationInitial());

  Future<void> loadMessages() async {
    emit(CommunicationLoading());
    final result = await getChatMessagesUseCase(const NoParams());
    result.fold(
      (failure) => emit(CommunicationError(failure.message)),
      (messages) => emit(CommunicationLoaded(messages: messages)),
    );
  }

  Future<void> sendMessage({
    required String text,
    MessageType type = MessageType.text,
    String? attachmentPath,
    String? attachmentName,
  }) async {
    final result = await sendMessageUseCase(
      SendMessageParams(
        text: text,
        type: type,
        attachmentPath: attachmentPath,
        attachmentName: attachmentName,
      ),
    );

    result.fold(
      (failure) => emit(CommunicationError(failure.message)),
      (_) async {
        // Refresh messages immediately to display user's outgoing message
        final updated = await getChatMessagesUseCase(const NoParams());
        updated.fold(
          (failure) => emit(CommunicationError(failure.message)),
          (msgs) {
            emit(CommunicationLoaded(messages: msgs, isSpecialistTyping: true));
            // Simulate typing state and show response
            Future.delayed(const Duration(milliseconds: 1600), () async {
              final refreshed = await getChatMessagesUseCase(const NoParams());
              refreshed.fold(
                (_) {},
                (allMsgs) => emit(CommunicationLoaded(messages: allMsgs, isSpecialistTyping: false)),
              );
            });
          },
        );
      },
    );
  }
}
