import 'package:equatable/equatable.dart';
import '../../domain/entities/subscription_entities.dart';

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object?> get props => [];
}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionLoaded extends SubscriptionState {
  final List<SubscriptionPackageEntity> packages;
  final List<PaymentRequestEntity> requests;

  const SubscriptionLoaded({
    required this.packages,
    required this.requests,
  });

  @override
  List<Object?> get props => [packages, requests];
}

class SubscriptionPaymentSubmitted extends SubscriptionState {
  final PaymentRequestEntity request;
  const SubscriptionPaymentSubmitted(this.request);

  @override
  List<Object?> get props => [request];
}

class SubscriptionError extends SubscriptionState {
  final String message;
  const SubscriptionError(this.message);

  @override
  List<Object?> get props => [message];
}
