import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/chat_message_entity.dart';
import '../repositories/communication_repository.dart';

class GetChatMessagesUseCase implements UseCase<List<ChatMessageEntity>, NoParams> {
  final CommunicationRepository repository;
  GetChatMessagesUseCase(this.repository);

  @override
  Future<Either<Failure, List<ChatMessageEntity>>> call(NoParams params) {
    return repository.getMessages();
  }
}

class SendMessageParams {
  final String text;
  final MessageType type;
  final String? attachmentPath;
  final String? attachmentName;

  const SendMessageParams({
    required this.text,
    this.type = MessageType.text,
    this.attachmentPath,
    this.attachmentName,
  });
}

class SendMessageUseCase implements UseCase<ChatMessageEntity, SendMessageParams> {
  final CommunicationRepository repository;
  SendMessageUseCase(this.repository);

  @override
  Future<Either<Failure, ChatMessageEntity>> call(SendMessageParams params) {
    return repository.sendMessage(
      text: params.text,
      type: params.type,
      attachmentPath: params.attachmentPath,
      attachmentName: params.attachmentName,
    );
  }
}
