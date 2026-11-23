import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasource/notification_local_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationLocalDataSource localDataSource;

  NotificationRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    try {
      final list = await localDataSource.getNotifications();
      return Right(list);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String id) async {
    try {
      await localDataSource.markRead(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      await localDataSource.markAllRead();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addDemoNotification(NotificationEntity notification) async {
    try {
      await localDataSource.addNotification(notification);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
