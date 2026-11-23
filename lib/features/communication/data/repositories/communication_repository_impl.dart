import 'dart:math';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/communication_repository.dart';
import '../datasource/communication_local_data_source.dart';

class CommunicationRepositoryImpl implements CommunicationRepository {
  final CommunicationLocalDataSource localDataSource;

  CommunicationRepositoryImpl({required this.localDataSource});

  final List<String> _specialistResponses = [
    "Thank you for sharing! I have reviewed your input and adjusted the plan notes.",
    "Excellent adherence this week! Keep maintaining your hydration targets.",
    "Make sure not to skip the post-workout snack to assist recovery and muscle retention.",
    "Noted! If you feel any unusual fatigue, please record it in the online follow-up section.",
    "Good job. I'll inspect your upcoming InBody metrics to determine if calories need raising."
  ];

  @override
  Future<Either<Failure, List<ChatMessageEntity>>> getMessages() async {
    try {
      final messages = await localDataSource.getChatMessages();
      return Right(messages);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatMessageEntity>> sendMessage({
    required String text,
    MessageType type = MessageType.text,
    String? attachmentPath,
    String? attachmentName,
  }) async {
    try {
      final userMsg = ChatMessageEntity(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        text: text,
        sender: MessageSender.user,
        type: type,
        timestamp: DateTime.now(),
        isRead: true,
        attachmentPath: attachmentPath,
        attachmentName: attachmentName,
      );
      await localDataSource.saveMessage(userMsg);

      // Trigger realistic specialist simulated reply after 1.5 seconds in background
      Future.delayed(const Duration(milliseconds: 1400), () async {
        final randomResp = _specialistResponses[Random().nextInt(_specialistResponses.length)];
        final specialistMsg = ChatMessageEntity(
          id: 'msg_reply_${DateTime.now().millisecondsSinceEpoch}',
          text: randomResp,
          sender: MessageSender.specialist,
          type: MessageType.text,
          timestamp: DateTime.now(),
          isRead: false,
        );
        await localDataSource.saveMessage(specialistMsg);
      });

      return Right(userMsg);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearChatDemo() async {
    try {
      await localDataSource.clearAll();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
