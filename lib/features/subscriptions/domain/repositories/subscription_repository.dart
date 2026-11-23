import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/subscription_entities.dart';

abstract class SubscriptionRepository {
  Future<Either<Failure, List<SubscriptionPackageEntity>>> getPackages();
  Future<Either<Failure, List<PaymentRequestEntity>>> getPaymentRequests();
  Future<Either<Failure, PaymentRequestEntity>> submitBankTransfer({
    required String packageId,
    required String packageName,
    required double amount,
    required String receiptPath,
    String? bankTransferRef,
  });
  Future<Either<Failure, void>> updatePaymentStatusDemo({
    required String requestId,
    required PaymentRequestStatus status,
    String? rejectionReason,
  });
}
