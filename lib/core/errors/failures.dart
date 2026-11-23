import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server failure occurred']) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache failure occurred']) : super(message);
}

class AuthFailure extends Failure {
  const AuthFailure([String message = 'Authentication failure']) : super(message);
}

class PermissionFailure extends Failure {
  const PermissionFailure([String message = 'Permission denied']) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure([String message = 'Validation error']) : super(message);
}
