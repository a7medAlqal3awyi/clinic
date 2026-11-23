import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/online_followup_entity.dart';

abstract class OnlineFollowupRepository {
  Future<Either<Failure, List<OnlineFollowupEntity>>> getFollowupHistory();
  Future<Either<Failure, OnlineFollowupEntity>> submitFollowup(OnlineFollowupEntity followup);
  Future<Either<Failure, void>> updateFollowupStatusDemo({
    required String id,
    required FollowupStatus status,
    String? feedback,
  });
}
