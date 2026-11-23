import 'package:equatable/equatable.dart';

class SubscriptionPackageEntity extends Equatable {
  final String id;
  final String name;
  final String tier; // basic, premium, vip
  final String description;
  final int durationMonths;
  final double price;
  final String currency;
  final List<String> features;
  final bool isPopular;

  const SubscriptionPackageEntity({
    required this.id,
    required this.name,
    required this.tier,
    required this.description,
    required this.durationMonths,
    required this.price,
    this.currency = 'EGP',
    required this.features,
    this.isPopular = false,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        tier,
        description,
        durationMonths,
        price,
        currency,
        features,
        isPopular,
      ];
}

enum PaymentRequestStatus {
  pendingReview,
  approved,
  rejected,
}

class PaymentRequestEntity extends Equatable {
  final String id;
  final String packageId;
  final String packageName;
  final double amount;
  final DateTime submittedDate;
  final PaymentRequestStatus status;
  final String? receiptPath;
  final String? bankTransferRef;
  final String? rejectionReason;

  const PaymentRequestEntity({
    required this.id,
    required this.packageId,
    required this.packageName,
    required this.amount,
    required this.submittedDate,
    required this.status,
    this.receiptPath,
    this.bankTransferRef,
    this.rejectionReason,
  });

  @override
  List<Object?> get props => [
        id,
        packageId,
        packageName,
        amount,
        submittedDate,
        status,
        receiptPath,
        bankTransferRef,
        rejectionReason,
      ];
}
