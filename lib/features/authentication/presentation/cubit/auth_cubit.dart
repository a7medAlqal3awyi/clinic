import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/auth_usecases.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterOnlineUseCase registerOnlineUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final LogoutUseCase logoutUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.registerOnlineUseCase,
    required this.getCurrentUserUseCase,
    required this.logoutUseCase,
    required this.updateProfileUseCase,
  }) : super(AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    final result = await getCurrentUserUseCase(const NoParams());
    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (user) {
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> login(String emailOrPhone, String password) async {
    emit(AuthLoading());
    final result = await loginUseCase(
      LoginParams(emailOrPhone: emailOrPhone, password: password),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> registerOnline({
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
    emit(AuthLoading());
    final result = await registerOnlineUseCase(
      RegisterOnlineParams(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
        gender: gender,
        age: age,
        height: height,
        currentWeight: currentWeight,
        targetWeight: targetWeight,
        mainGoal: mainGoal,
      ),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> updateProfile(UserEntity user) async {
    emit(AuthLoading());
    final result = await updateProfileUseCase(user);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) {
        emit(AuthProfileUpdated(user));
        emit(AuthAuthenticated(user));
      },
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());
    await logoutUseCase(const NoParams());
    emit(AuthUnauthenticated());
  }

  // Refreshes the in-memory state after demo manipulation
  Future<void> reloadUser() async {
    final result = await getCurrentUserUseCase(const NoParams());
    result.fold(
      (_) => emit(AuthUnauthenticated()),
      (user) {
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }
}
