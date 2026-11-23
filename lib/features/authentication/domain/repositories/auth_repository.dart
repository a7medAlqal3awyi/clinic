import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String emailOrPhone,
    required String password,
  });

  Future<Either<Failure, UserEntity>> registerOnline({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String gender,
    required int age,
    required double height,
    required double currentWeight,
    required double targetWeight,
    required String mainGoal,
  });

  Future<Either<Failure, UserEntity?>> getCurrentUser();

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, void>> updateProfile(UserEntity user);

  // Demo helper
  Future<Either<Failure, void>> updateSubscriptionStatus({
    required String status,
    String? packageName,
    String? tier,
    int? durationDays,
  });
}
