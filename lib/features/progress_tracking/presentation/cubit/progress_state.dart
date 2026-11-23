import 'package:equatable/equatable.dart';
import '../../domain/entities/progress_entities.dart';

abstract class ProgressState extends Equatable {
  const ProgressState();

  @override
  List<Object?> get props => [];
}

class ProgressInitial extends ProgressState {}

class ProgressLoading extends ProgressState {}

class ProgressLoaded extends ProgressState {
  final List<WeightEntryEntity> weightHistory;
  final List<InBodyReportEntity> inBodyReports;
  final List<ClinicVisitEntity> clinicVisits;

  const ProgressLoaded({
    required this.weightHistory,
    required this.inBodyReports,
    required this.clinicVisits,
  });

  WeightEntryEntity? get latestWeight =>
      weightHistory.isNotEmpty ? weightHistory.first : null;

  @override
  List<Object?> get props => [weightHistory, inBodyReports, clinicVisits];
}

class ProgressError extends ProgressState {
  final String message;
  const ProgressError(this.message);

  @override
  List<Object?> get props => [message];
}
