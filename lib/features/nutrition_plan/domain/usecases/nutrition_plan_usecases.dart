import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/nutrition_plan_entity.dart';
import '../repositories/nutrition_plan_repository.dart';

class GetCurrentPlanUseCase implements UseCase<NutritionPlanEntity, NoParams> {
  final NutritionPlanRepository repository;
  GetCurrentPlanUseCase(this.repository);

  @override
  Future<Either<Failure, NutritionPlanEntity>> call(NoParams params) {
    return repository.getCurrentPlan();
  }
}

class ToggleMealCompletionParams {
  final String mealId;
  final bool isCompleted;
  const ToggleMealCompletionParams({required this.mealId, required this.isCompleted});
}

class ToggleMealCompletionUseCase implements UseCase<void, ToggleMealCompletionParams> {
  final NutritionPlanRepository repository;
  ToggleMealCompletionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ToggleMealCompletionParams params) {
    return repository.toggleMealCompletion(params.mealId, params.isCompleted);
  }
}

class UpdateMealNotesParams {
  final String mealId;
  final String notes;
  const UpdateMealNotesParams({required this.mealId, required this.notes});
}

class UpdateMealNotesUseCase implements UseCase<void, UpdateMealNotesParams> {
  final NutritionPlanRepository repository;
  UpdateMealNotesUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateMealNotesParams params) {
    return repository.updateMealNotes(params.mealId, params.notes);
  }
}
