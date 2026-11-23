import 'package:equatable/equatable.dart';

enum MessageSender {
  user,
  specialist,
}

enum MessageType {
  text,
  image,
  file,
  voice,
}

class ChatMessageEntity extends Equatable {
  final String id;
  final String text;
  final MessageSender sender;
  final MessageType type;
  final DateTime timestamp;
  final bool isRead;
  final String? attachmentPath;
  final String? attachmentName;

  const ChatMessageEntity({
    required this.id,
    required this.text,
    required this.sender,
    this.type = MessageType.text,
    required this.timestamp,
    this.isRead = true,
    this.attachmentPath,
    this.attachmentName,
  });

  @override
  List<Object?> get props => [
        id,
        text,
        sender,
        type,
        timestamp,
        isRead,
        attachmentPath,
        attachmentName,
      ];
}
