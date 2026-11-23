import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/progress_entities.dart';
import '../repositories/progress_repository.dart';

class GetWeightHistoryUseCase implements UseCase<List<WeightEntryEntity>, NoParams> {
  final ProgressRepository repository;
  GetWeightHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<WeightEntryEntity>>> call(NoParams params) {
    return repository.getWeightHistory();
  }
}

class AddWeightParams {
  final double weight;
  final String? note;
  const AddWeightParams({required this.weight, this.note});
}

class AddWeightUseCase implements UseCase<void, AddWeightParams> {
  final ProgressRepository repository;
  AddWeightUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AddWeightParams params) {
    return repository.addWeightEntry(params.weight, params.note);
  }
}

class GetInBodyReportsUseCase implements UseCase<List<InBodyReportEntity>, NoParams> {
  final ProgressRepository repository;
  GetInBodyReportsUseCase(this.repository);

  @override
  Future<Either<Failure, List<InBodyReportEntity>>> call(NoParams params) {
    return repository.getInBodyReports();
  }
}

class AddInBodyReportUseCase implements UseCase<void, InBodyReportEntity> {
  final ProgressRepository repository;
  AddInBodyReportUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(InBodyReportEntity report) {
    return repository.addInBodyReport(report);
  }
}

class GetClinicVisitsUseCase implements UseCase<List<ClinicVisitEntity>, NoParams> {
  final ProgressRepository repository;
  GetClinicVisitsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ClinicVisitEntity>>> call(NoParams params) {
    return repository.getClinicVisits();
  }
}
