import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/usecase.dart';
import '../../domain/usecases/nutrition_plan_usecases.dart';
import 'nutrition_plan_state.dart';

class NutritionPlanCubit extends Cubit<NutritionPlanState> {
  final GetCurrentPlanUseCase getCurrentPlanUseCase;
  final ToggleMealCompletionUseCase toggleMealCompletionUseCase;
  final UpdateMealNotesUseCase updateMealNotesUseCase;

  NutritionPlanCubit({
    required this.getCurrentPlanUseCase,
    required this.toggleMealCompletionUseCase,
    required this.updateMealNotesUseCase,
  }) : super(NutritionPlanInitial());

  Future<void> loadPlan() async {
    emit(NutritionPlanLoading());
    final result = await getCurrentPlanUseCase(const NoParams());
    result.fold(
      (failure) => emit(NutritionPlanError(failure.message)),
      (plan) => emit(NutritionPlanLoaded(plan)),
    );
  }

  Future<void> toggleMeal(String mealId, bool completed) async {
    final result = await toggleMealCompletionUseCase(
      ToggleMealCompletionParams(mealId: mealId, isCompleted: completed),
    );
    result.fold(
      (failure) => emit(NutritionPlanError(failure.message)),
      (_) => loadPlan(),
    );
  }

  Future<void> updateNotes(String mealId, String notes) async {
    final result = await updateMealNotesUseCase(
      UpdateMealNotesParams(mealId: mealId, notes: notes),
    );
    result.fold(
      (failure) => emit(NutritionPlanError(failure.message)),
      (_) => loadPlan(),
    );
  }
}
