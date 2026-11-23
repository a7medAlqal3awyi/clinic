import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entities/chat_message_entity.dart';

abstract class CommunicationLocalDataSource {
  Future<List<ChatMessageEntity>> getChatMessages();
  Future<void> saveMessage(ChatMessageEntity message);
  Future<void> clearAll();
}

class CommunicationLocalDataSourceImpl implements CommunicationLocalDataSource {
  final SharedPreferences sharedPreferences;

  CommunicationLocalDataSourceImpl({required this.sharedPreferences});

  static List<ChatMessageEntity> get defaultSeedMessages => [
        ChatMessageEntity(
          id: 'msg_1',
          text: 'Hello Mohamed, welcome to your clinical nutrition follow-up portal. How are you feeling with the new meal schedule?',
          sender: MessageSender.specialist,
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(hours: 48)),
        ),
        ChatMessageEntity(
          id: 'msg_2',
          text: 'Hello Dr. Sarah! Energy is noticeably better, but I felt a bit hungry before bedtime yesterday.',
          sender: MessageSender.user,
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(hours: 46)),
        ),
        ChatMessageEntity(
          id: 'msg_3',
          text: 'Great feedback! You can safely have 1 cup of chamomile tea or 100g of low-fat Greek yogurt with cinnamon if cravings strike.',
          sender: MessageSender.specialist,
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(hours: 44)),
        ),
      ];

  @override
  Future<List<ChatMessageEntity>> getChatMessages() async {
    final raw = sharedPreferences.getString(AppConstants.prefsChatsKey);
    if (raw != null) {
      try {
        final list = jsonDecode(raw) as List<dynamic>;
        return list
            .map((item) => ChatMessageEntity(
                  id: item['id'],
                  text: item['text'],
                  sender: item['sender'] == 'specialist'
                      ? MessageSender.specialist
                      : MessageSender.user,
                  type: _parseType(item['type']),
                  timestamp: DateTime.parse(item['timestamp']),
                  isRead: item['isRead'] ?? true,
                  attachmentPath: item['attachmentPath'],
                  attachmentName: item['attachmentName'],
                ))
            .toList();
      } catch (_) {
        return defaultSeedMessages;
      }
    }
    return defaultSeedMessages;
  }

  static MessageType _parseType(dynamic t) {
    switch (t) {
      case 'image':
        return MessageType.image;
      case 'file':
        return MessageType.file;
      case 'voice':
        return MessageType.voice;
      default:
        return MessageType.text;
    }
  }

  @override
  Future<void> saveMessage(ChatMessageEntity message) async {
    final current = await getChatMessages();
    final updated = [...current, message];
    final encoded = jsonEncode(updated
        .map((m) => {
              'id': m.id,
              'text': m.text,
              'sender': m.sender == MessageSender.specialist ? 'specialist' : 'user',
              'type': m.type.name,
              'timestamp': m.timestamp.toIso8601String(),
              'isRead': m.isRead,
              'attachmentPath': m.attachmentPath,
              'attachmentName': m.attachmentName,
            })
        .toList());
    await sharedPreferences.setString(AppConstants.prefsChatsKey, encoded);
  }

  @override
  Future<void> clearAll() async {
    await sharedPreferences.remove(AppConstants.prefsChatsKey);
  }
}
