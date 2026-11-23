import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/usecase.dart';
import '../../domain/entities/online_followup_entity.dart';
import '../../domain/usecases/online_followup_usecases.dart';
import 'online_followup_state.dart';

class OnlineFollowupCubit extends Cubit<OnlineFollowupState> {
  final GetFollowupsUseCase getFollowupsUseCase;
  final SubmitFollowupUseCase submitFollowupUseCase;

  OnlineFollowupCubit({
    required this.getFollowupsUseCase,
    required this.submitFollowupUseCase,
  }) : super(OnlineFollowupInitial());

  Future<void> loadFollowups() async {
    emit(OnlineFollowupLoading());
    final result = await getFollowupsUseCase(const NoParams());
    result.fold(
      (failure) => emit(OnlineFollowupError(failure.message)),
      (history) => emit(OnlineFollowupLoaded(history)),
    );
  }

  Future<void> submit({
    required double currentWeight,
    required double chestCm,
    required double waistCm,
    required double hipsCm,
    required String notes,
    required List<String> medicalFiles,
    required List<String> progressPhotos,
  }) async {
    emit(OnlineFollowupLoading());
    final entity = OnlineFollowupEntity(
      id: 'fol_${DateTime.now().millisecondsSinceEpoch}',
      submissionDate: DateTime.now(),
      currentWeight: currentWeight,
      chestCm: chestCm,
      waistCm: waistCm,
      hipsCm: hipsCm,
      notes: notes,
      medicalTestFiles: medicalFiles,
      progressPhotos: progressPhotos,
      status: FollowupStatus.submitted,
    );

    final result = await submitFollowupUseCase(entity);
    result.fold(
      (failure) => emit(OnlineFollowupError(failure.message)),
      (submission) {
        emit(OnlineFollowupSubmitted(submission));
        loadFollowups();
      },
    );
  }
}
