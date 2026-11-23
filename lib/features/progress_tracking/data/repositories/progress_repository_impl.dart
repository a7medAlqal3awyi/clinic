import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/progress_entities.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasource/progress_local_data_source.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final ProgressLocalDataSource localDataSource;

  ProgressRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<WeightEntryEntity>>> getWeightHistory() async {
    try {
      final list = await localDataSource.getWeights();
      return Right(list);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addWeightEntry(double weight, String? note) async {
    try {
      final entry = WeightEntryEntity(
        id: 'w_${DateTime.now().millisecondsSinceEpoch}',
        weight: weight,
        date: DateTime.now(),
        note: note,
      );
      await localDataSource.saveWeight(entry);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<InBodyReportEntity>>> getInBodyReports() async {
    try {
      final list = await localDataSource.getInBodyList();
      return Right(list);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addInBodyReport(InBodyReportEntity report) async {
    try {
      await localDataSource.saveInBody(report);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ClinicVisitEntity>>> getClinicVisits() async {
    try {
      final list = await localDataSource.getVisits();
      return Right(list);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
