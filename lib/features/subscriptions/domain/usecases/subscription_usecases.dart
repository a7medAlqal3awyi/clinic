import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/subscription_entities.dart';
import '../repositories/subscription_repository.dart';

class GetPackagesUseCase implements UseCase<List<SubscriptionPackageEntity>, NoParams> {
  final SubscriptionRepository repository;
  GetPackagesUseCase(this.repository);

  @override
  Future<Either<Failure, List<SubscriptionPackageEntity>>> call(NoParams params) {
    return repository.getPackages();
  }
}

class GetPaymentRequestsUseCase implements UseCase<List<PaymentRequestEntity>, NoParams> {
  final SubscriptionRepository repository;
  GetPaymentRequestsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PaymentRequestEntity>>> call(NoParams params) {
    return repository.getPaymentRequests();
  }
}

class SubmitBankTransferParams {
  final String packageId;
  final String packageName;
  final double amount;
  final String receiptPath;
  final String? bankTransferRef;

  const SubmitBankTransferParams({
    required this.packageId,
    required this.packageName,
    required this.amount,
    required this.receiptPath,
    this.bankTransferRef,
  });
}

class SubmitBankTransferUseCase implements UseCase<PaymentRequestEntity, SubmitBankTransferParams> {
  final SubscriptionRepository repository;
  SubmitBankTransferUseCase(this.repository);

  @override
  Future<Either<Failure, PaymentRequestEntity>> call(SubmitBankTransferParams params) {
    return repository.submitBankTransfer(
      packageId: params.packageId,
      packageName: params.packageName,
      amount: params.amount,
      receiptPath: params.receiptPath,
      bankTransferRef: params.bankTransferRef,
    );
  }
}
