import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  final String emailOrPhone;
  final String password;
  const LoginParams({required this.emailOrPhone, required this.password});
}

class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    return repository.login(
      emailOrPhone: params.emailOrPhone,
      password: params.password,
    );
  }
}

class RegisterOnlineParams {
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String gender;
  final int age;
  final double height;
  final double currentWeight;
  final double targetWeight;
  final String mainGoal;

  const RegisterOnlineParams({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.gender,
    required this.age,
    required this.height,
    required this.currentWeight,
    required this.targetWeight,
    required this.mainGoal,
  });
}

class RegisterOnlineUseCase implements UseCase<UserEntity, RegisterOnlineParams> {
  final AuthRepository repository;
  RegisterOnlineUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterOnlineParams params) {
    return repository.registerOnline(
      fullName: params.fullName,
      email: params.email,
      phone: params.phone,
      password: params.password,
      gender: params.gender,
      age: params.age,
      height: params.height,
      currentWeight: params.currentWeight,
      targetWeight: params.targetWeight,
      mainGoal: params.mainGoal,
    );
  }
}

class GetCurrentUserUseCase implements UseCase<UserEntity?, NoParams> {
  final AuthRepository repository;
  GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity?>> call(NoParams params) {
    return repository.getCurrentUser();
  }
}

class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;
  LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.logout();
  }
}

class UpdateProfileUseCase implements UseCase<void, UserEntity> {
  final AuthRepository repository;
  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UserEntity user) {
    return repository.updateProfile(user);
  }
}
