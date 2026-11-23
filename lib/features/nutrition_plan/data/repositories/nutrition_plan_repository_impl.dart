import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/nutrition_plan_entity.dart';
import '../../domain/repositories/nutrition_plan_repository.dart';
import '../datasource/nutrition_plan_local_data_source.dart';

class NutritionPlanRepositoryImpl implements NutritionPlanRepository {
  final NutritionPlanLocalDataSource localDataSource;

  NutritionPlanRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, NutritionPlanEntity>> getCurrentPlan() async {
    try {
      final plan = await localDataSource.getPlan();
      return Right(plan);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleMealCompletion(String mealId, bool completed) async {
    try {
      await localDataSource.toggleMeal(mealId, completed);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateMealNotes(String mealId, String notes) async {
    try {
      await localDataSource.updateNotes(mealId, notes);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPlanDemo(NutritionPlanEntity newPlan) async {
    try {
      await localDataSource.savePlan(newPlan);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
