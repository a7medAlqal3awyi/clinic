import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/online_followup_entity.dart';
import '../repositories/online_followup_repository.dart';

class GetFollowupsUseCase implements UseCase<List<OnlineFollowupEntity>, NoParams> {
  final OnlineFollowupRepository repository;
  GetFollowupsUseCase(this.repository);

  @override
  Future<Either<Failure, List<OnlineFollowupEntity>>> call(NoParams params) {
    return repository.getFollowupHistory();
  }
}

class SubmitFollowupUseCase implements UseCase<OnlineFollowupEntity, OnlineFollowupEntity> {
  final OnlineFollowupRepository repository;
  SubmitFollowupUseCase(this.repository);

  @override
  Future<Either<Failure, OnlineFollowupEntity>> call(OnlineFollowupEntity params) {
    return repository.submitFollowup(params);
  }
}
