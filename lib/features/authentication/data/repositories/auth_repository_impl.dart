import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/user_permissions.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasource/auth_local_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, UserEntity>> login({
    required String emailOrPhone,
    required String password,
  }) async {
    try {
      final user = await localDataSource.loginDemo(
        emailOrPhone: emailOrPhone,
        password: password,
      );
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
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
  }) async {
    try {
      final newUser = UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        fullName: fullName,
        email: email,
        phone: phone,
        customerType: CustomerType.online,
        subscriptionStatus: SubscriptionStatus.none, // Must subscribe to package
        subscriptionPackageName: null,
        subscriptionPackageTier: null,
        gender: gender,
        age: age,
        height: height,
        currentWeight: currentWeight,
        targetWeight: targetWeight,
        mainGoal: mainGoal,
      );
      final saved = await localDataSource.registerDemo(newUser);
      return Right(saved);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = await localDataSource.getSavedUser();
      return Right(user);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearUser();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile(UserEntity user) async {
    try {
      await localDataSource.saveUser(UserModel.fromEntity(user));
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateSubscriptionStatus({
    required String status,
    String? packageName,
    String? tier,
    int? durationDays,
  }) async {
    try {
      await localDataSource.updateDemoSubscription(
        status: status,
        packageName: packageName,
        tier: tier,
        durationDays: durationDays,
      );
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
