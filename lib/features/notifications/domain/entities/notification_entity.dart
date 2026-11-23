import 'package:equatable/equatable.dart';

enum NotificationType {
  newPlan,
  planUpdated,
  chatMessage,
  progressResult,
  subscriptionExpiring,
  paymentApproved,
  paymentRejected,
  followupReviewed,
}

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime date;
  final bool isRead;
  final String? routeTarget;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.date,
    this.isRead = false,
    this.routeTarget,
  });

  NotificationEntity copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    DateTime? date,
    bool? isRead,
    String? routeTarget,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      date: date ?? this.date,
      isRead: isRead ?? this.isRead,
      routeTarget: routeTarget ?? this.routeTarget,
    );
  }

  @override
  List<Object?> get props => [id, title, body, type, date, isRead, routeTarget];
}
