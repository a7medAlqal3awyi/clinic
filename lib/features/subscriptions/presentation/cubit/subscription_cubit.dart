import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/usecase.dart';
import '../../domain/entities/subscription_entities.dart';
import '../../domain/usecases/subscription_usecases.dart';
import 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final GetPackagesUseCase getPackagesUseCase;
  final GetPaymentRequestsUseCase getPaymentRequestsUseCase;
  final SubmitBankTransferUseCase submitBankTransferUseCase;

  SubscriptionCubit({
    required this.getPackagesUseCase,
    required this.getPaymentRequestsUseCase,
    required this.submitBankTransferUseCase,
  }) : super(SubscriptionInitial());

  Future<void> loadPackagesAndHistory() async {
    emit(SubscriptionLoading());
    final pkgs = await getPackagesUseCase(const NoParams());
    final hist = await getPaymentRequestsUseCase(const NoParams());

    pkgs.fold(
      (failure) => emit(SubscriptionError(failure.message)),
      (packages) {
        hist.fold(
          (failure) => emit(SubscriptionError(failure.message)),
          (requests) => emit(SubscriptionLoaded(
            packages: packages,
            requests: requests,
          )),
        );
      },
    );
  }

  Future<void> submitBankTransfer({
    required String packageId,
    required String packageName,
    required double amount,
    required String receiptPath,
    String? bankTransferRef,
  }) async {
    emit(SubscriptionLoading());
    final result = await submitBankTransferUseCase(
      SubmitBankTransferParams(
        packageId: packageId,
        packageName: packageName,
        amount: amount,
        receiptPath: receiptPath,
        bankTransferRef: bankTransferRef,
      ),
    );

    result.fold(
      (failure) => emit(SubscriptionError(failure.message)),
      (req) {
        emit(SubscriptionPaymentSubmitted(req));
        loadPackagesAndHistory();
      },
    );
  }
}
