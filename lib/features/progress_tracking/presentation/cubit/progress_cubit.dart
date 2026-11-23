import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/usecase.dart';
import '../../domain/entities/progress_entities.dart';
import '../../domain/usecases/progress_usecases.dart';
import 'progress_state.dart';

class ProgressCubit extends Cubit<ProgressState> {
  final GetWeightHistoryUseCase getWeightHistoryUseCase;
  final AddWeightUseCase addWeightUseCase;
  final GetInBodyReportsUseCase getInBodyReportsUseCase;
  final AddInBodyReportUseCase addInBodyReportUseCase;
  final GetClinicVisitsUseCase getClinicVisitsUseCase;

  ProgressCubit({
    required this.getWeightHistoryUseCase,
    required this.addWeightUseCase,
    required this.getInBodyReportsUseCase,
    required this.addInBodyReportUseCase,
    required this.getClinicVisitsUseCase,
  }) : super(ProgressInitial());

  Future<void> loadProgressData() async {
    emit(ProgressLoading());
    final weightsResult = await getWeightHistoryUseCase(const NoParams());
    final inBodyResult = await getInBodyReportsUseCase(const NoParams());
    final visitsResult = await getClinicVisitsUseCase(const NoParams());

    weightsResult.fold(
      (failure) => emit(ProgressError(failure.message)),
      (weights) {
        inBodyResult.fold(
          (failure) => emit(ProgressError(failure.message)),
          (reports) {
            visitsResult.fold(
              (failure) => emit(ProgressError(failure.message)),
              (visits) => emit(ProgressLoaded(
                weightHistory: weights,
                inBodyReports: reports,
                clinicVisits: visits,
              )),
            );
          },
        );
      },
    );
  }

  Future<void> recordWeight(double weight, String? note) async {
    final result = await addWeightUseCase(AddWeightParams(weight: weight, note: note));
    result.fold(
      (failure) => emit(ProgressError(failure.message)),
      (_) => loadProgressData(),
    );
  }

  Future<void> recordInBody(InBodyReportEntity report) async {
    final result = await addInBodyReportUseCase(report);
    result.fold(
      (failure) => emit(ProgressError(failure.message)),
      (_) => loadProgressData(),
    );
  }
}
