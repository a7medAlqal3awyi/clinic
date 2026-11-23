import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/chat_message_entity.dart';

abstract class CommunicationRepository {
  Future<Either<Failure, List<ChatMessageEntity>>> getMessages();
  Future<Either<Failure, ChatMessageEntity>> sendMessage({
    required String text,
    MessageType type,
    String? attachmentPath,
    String? attachmentName,
  });
  Future<Either<Failure, void>> clearChatDemo();
}
