import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/online_followup_entity.dart';
import '../../domain/repositories/online_followup_repository.dart';
import '../datasource/online_followup_local_data_source.dart';

class OnlineFollowupRepositoryImpl implements OnlineFollowupRepository {
  final OnlineFollowupLocalDataSource localDataSource;

  OnlineFollowupRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<OnlineFollowupEntity>>> getFollowupHistory() async {
    try {
      final list = await localDataSource.getFollowups();
      return Right(list);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OnlineFollowupEntity>> submitFollowup(
      OnlineFollowupEntity followup) async {
    try {
      final saved = await localDataSource.saveFollowup(followup);
      return Right(saved);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateFollowupStatusDemo({
    required String id,
    required FollowupStatus status,
    String? feedback,
  }) async {
    try {
      await localDataSource.updateStatus(id, status, feedback);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
