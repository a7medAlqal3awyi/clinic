import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/usecase.dart';
import '../../domain/usecases/notification_usecases.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkNotificationAsReadUseCase markNotificationAsReadUseCase;
  final MarkAllNotificationsAsReadUseCase markAllNotificationsAsReadUseCase;

  NotificationCubit({
    required this.getNotificationsUseCase,
    required this.markNotificationAsReadUseCase,
    required this.markAllNotificationsAsReadUseCase,
  }) : super(NotificationInitial());

  Future<void> loadNotifications() async {
    emit(NotificationLoading());
    final result = await getNotificationsUseCase(const NoParams());
    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (notifications) => emit(NotificationLoaded(notifications)),
    );
  }

  Future<void> markRead(String id) async {
    await markNotificationAsReadUseCase(id);
    loadNotifications();
  }

  Future<void> markAllRead() async {
    await markAllNotificationsAsReadUseCase(const NoParams());
    loadNotifications();
  }
}
