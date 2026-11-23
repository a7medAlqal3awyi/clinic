import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entities/notification_entity.dart';

abstract class NotificationLocalDataSource {
  Future<List<NotificationEntity>> getNotifications();
  Future<void> markRead(String id);
  Future<void> markAllRead();
  Future<void> addNotification(NotificationEntity notification);
}

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  final SharedPreferences sharedPreferences;

  NotificationLocalDataSourceImpl({required this.sharedPreferences});

  static List<NotificationEntity> get defaultSeed => [
        NotificationEntity(
          id: 'notif_1',
          title: 'Nutrition Plan Updated',
          body: 'Dr. Sarah has adjusted your macro distribution and dinner calories.',
          type: NotificationType.planUpdated,
          date: DateTime.now().subtract(const Duration(hours: 3)),
          isRead: false,
          routeTarget: '/nutrition-plan',
        ),
        NotificationEntity(
          id: 'notif_2',
          title: 'New Specialist Message',
          body: 'You have a new message from Dr. Sarah Mansour regarding your query.',
          type: NotificationType.chatMessage,
          date: DateTime.now().subtract(const Duration(hours: 12)),
          isRead: false,
          routeTarget: '/chat',
        ),
        NotificationEntity(
          id: 'notif_3',
          title: 'Biometric Progress Logged',
          body: 'Your latest weight measurement has been saved to your analytics chart.',
          type: NotificationType.progressResult,
          date: DateTime.now().subtract(const Duration(days: 1)),
          isRead: true,
          routeTarget: '/progress',
        ),
        NotificationEntity(
          id: 'notif_4',
          title: 'Subscription Status',
          body: 'Your nutrition care membership is active with 60 days remaining.',
          type: NotificationType.subscriptionExpiring,
          date: DateTime.now().subtract(const Duration(days: 3)),
          isRead: true,
          routeTarget: '/subscriptions',
        ),
      ];

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    final raw = sharedPreferences.getString(AppConstants.prefsNotificationsKey);
    if (raw != null) {
      try {
        final list = jsonDecode(raw) as List<dynamic>;
        return list
            .map((item) => NotificationEntity(
                  id: item['id'],
                  title: item['title'],
                  body: item['body'],
                  type: _parseType(item['type']),
                  date: DateTime.parse(item['date']),
                  isRead: item['isRead'] ?? false,
                  routeTarget: item['routeTarget'],
                ))
            .toList();
      } catch (_) {
        return defaultSeed;
      }
    }
    return defaultSeed;
  }

  static NotificationType _parseType(dynamic t) {
    switch (t) {
      case 'planUpdated':
        return NotificationType.planUpdated;
      case 'chatMessage':
        return NotificationType.chatMessage;
      case 'progressResult':
        return NotificationType.progressResult;
      case 'subscriptionExpiring':
        return NotificationType.subscriptionExpiring;
      case 'paymentApproved':
        return NotificationType.paymentApproved;
      case 'paymentRejected':
        return NotificationType.paymentRejected;
      case 'followupReviewed':
        return NotificationType.followupReviewed;
      default:
        return NotificationType.newPlan;
    }
  }

  @override
  Future<void> markRead(String id) async {
    final current = await getNotifications();
    final updated = current.map((n) {
      if (n.id == id) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();
    await _saveList(updated);
  }

  @override
  Future<void> markAllRead() async {
    final current = await getNotifications();
    final updated = current.map((n) => n.copyWith(isRead: true)).toList();
    await _saveList(updated);
  }

  @override
  Future<void> addNotification(NotificationEntity notification) async {
    final current = await getNotifications();
    final updated = [notification, ...current];
    await _saveList(updated);
  }

  Future<void> _saveList(List<NotificationEntity> list) async {
    final encoded = jsonEncode(list
        .map((n) => {
              'id': n.id,
              'title': n.title,
              'body': n.body,
              'type': n.type.name,
              'date': n.date.toIso8601String(),
              'isRead': n.isRead,
              'routeTarget': n.routeTarget,
            })
        .toList());
    await sharedPreferences.setString(AppConstants.prefsNotificationsKey, encoded);
  }
}
