import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/progress_entities.dart';

abstract class ProgressRepository {
  Future<Either<Failure, List<WeightEntryEntity>>> getWeightHistory();
  Future<Either<Failure, void>> addWeightEntry(double weight, String? note);
  Future<Either<Failure, List<InBodyReportEntity>>> getInBodyReports();
  Future<Either<Failure, void>> addInBodyReport(InBodyReportEntity report);
  Future<Either<Failure, List<ClinicVisitEntity>>> getClinicVisits();
}
