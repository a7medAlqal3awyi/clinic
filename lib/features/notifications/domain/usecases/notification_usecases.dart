import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class GetNotificationsUseCase implements UseCase<List<NotificationEntity>, NoParams> {
  final NotificationRepository repository;
  GetNotificationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(NoParams params) {
    return repository.getNotifications();
  }
}

class MarkNotificationAsReadUseCase implements UseCase<void, String> {
  final NotificationRepository repository;
  MarkNotificationAsReadUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) {
    return repository.markAsRead(id);
  }
}

class MarkAllNotificationsAsReadUseCase implements UseCase<void, NoParams> {
  final NotificationRepository repository;
  MarkAllNotificationsAsReadUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.markAllAsRead();
  }
}
