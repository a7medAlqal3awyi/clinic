import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/nutrition_plan_entity.dart';

abstract class NutritionPlanRepository {
  Future<Either<Failure, NutritionPlanEntity>> getCurrentPlan();
  Future<Either<Failure, void>> toggleMealCompletion(String mealId, bool completed);
  Future<Either<Failure, void>> updateMealNotes(String mealId, String notes);
  Future<Either<Failure, void>> resetPlanDemo(NutritionPlanEntity newPlan);
}
