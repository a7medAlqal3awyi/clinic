import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/subscription_entities.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../datasource/subscription_local_data_source.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionLocalDataSource localDataSource;

  SubscriptionRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<SubscriptionPackageEntity>>> getPackages() async {
    try {
      final packages = await localDataSource.getAvailablePackages();
      return Right(packages);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PaymentRequestEntity>>> getPaymentRequests() async {
    try {
      final list = await localDataSource.getPaymentHistory();
      return Right(list);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaymentRequestEntity>> submitBankTransfer({
    required String packageId,
    required String packageName,
    required double amount,
    required String receiptPath,
    String? bankTransferRef,
  }) async {
    try {
      final req = PaymentRequestEntity(
        id: 'pay_${DateTime.now().millisecondsSinceEpoch}',
        packageId: packageId,
        packageName: packageName,
        amount: amount,
        submittedDate: DateTime.now(),
        status: PaymentRequestStatus.pendingReview,
        receiptPath: receiptPath,
        bankTransferRef: bankTransferRef,
      );
      final saved = await localDataSource.savePaymentRequest(req);
      return Right(saved);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePaymentStatusDemo({
    required String requestId,
    required PaymentRequestStatus status,
    String? rejectionReason,
  }) async {
    try {
      await localDataSource.updatePaymentStatus(requestId, status, rejectionReason);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
