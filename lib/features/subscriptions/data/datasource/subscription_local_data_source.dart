import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entities/subscription_entities.dart';

abstract class SubscriptionLocalDataSource {
  Future<List<SubscriptionPackageEntity>> getAvailablePackages();
  Future<List<PaymentRequestEntity>> getPaymentHistory();
  Future<PaymentRequestEntity> savePaymentRequest(PaymentRequestEntity request);
  Future<void> updatePaymentStatus(String requestId, PaymentRequestStatus status, String? reason);
}

class SubscriptionLocalDataSourceImpl implements SubscriptionLocalDataSource {
  final SharedPreferences sharedPreferences;

  SubscriptionLocalDataSourceImpl({required this.sharedPreferences});

  static final List<SubscriptionPackageEntity> defaultPackages = [
    const SubscriptionPackageEntity(
      id: 'pkg_basic',
      name: 'Basic Nutrition Plan',
      tier: 'basic',
      description: 'Ideal starting point for structured dietary management and caloric awareness.',
      durationMonths: 1,
      price: 850.0,
      features: [
        'Custom 1-Month Nutrition Plan',
        'Weekly Weight & Measurement Log',
        'Macronutrient Breakdown Guide',
        'Standard InBody scan review',
      ],
      isPopular: false,
    ),
    const SubscriptionPackageEntity(
      id: 'pkg_premium',
      name: 'Premium Transformation',
      tier: 'premium',
      description: 'Our most sought-after plan for accelerated and sustainable results with clinical supervision.',
      durationMonths: 3,
      price: 2200.0,
      features: [
        'Personalized Macro Protocol (Updated bi-weekly)',
        'Direct Chat with Nutrition Specialist',
        'Bi-weekly Online Check-ins & Photo Assessment',
        'Full InBody reports & Biometric Tracking',
        'Healthy Dining Out & Supplement Guidance',
      ],
      isPopular: true,
    ),
    const SubscriptionPackageEntity(
      id: 'pkg_vip',
      name: 'VIP Concierge Nutrition',
      tier: 'vip',
      description: 'Comprehensive health lifestyle transformation with priority response and tailored medical nutrition.',
      durationMonths: 6,
      price: 3900.0,
      features: [
        'Full Clinical Nutrition Management (6 Months)',
        'Priority 24/7 Specialist Direct Messaging',
        'Comprehensive Lab/Bloodwork Analysis',
        'Customized Travel & Event Nutrition Plans',
        'Dedicated Follow-up Manager & Weekly Audits',
      ],
      isPopular: false,
    ),
  ];

  @override
  Future<List<SubscriptionPackageEntity>> getAvailablePackages() async {
    return defaultPackages;
  }

  @override
  Future<List<PaymentRequestEntity>> getPaymentHistory() async {
    final raw = sharedPreferences.getString(AppConstants.prefsPaymentsKey);
    if (raw != null) {
      try {
        final list = jsonDecode(raw) as List<dynamic>;
        return list
            .map((item) => PaymentRequestEntity(
                  id: item['id'],
                  packageId: item['packageId'],
                  packageName: item['packageName'],
                  amount: (item['amount'] as num).toDouble(),
                  submittedDate: DateTime.parse(item['submittedDate']),
                  status: _parseStatus(item['status']),
                  receiptPath: item['receiptPath'],
                  bankTransferRef: item['bankTransferRef'],
                  rejectionReason: item['rejectionReason'],
                ))
            .toList();
      } catch (_) {
        return [];
      }
    }
    return [];
  }

  static PaymentRequestStatus _parseStatus(dynamic s) {
    switch (s) {
      case 'approved':
        return PaymentRequestStatus.approved;
      case 'rejected':
        return PaymentRequestStatus.rejected;
      default:
        return PaymentRequestStatus.pendingReview;
    }
  }

  @override
  Future<PaymentRequestEntity> savePaymentRequest(PaymentRequestEntity request) async {
    final list = await getPaymentHistory();
    final updated = [request, ...list];
    final encoded = jsonEncode(updated
        .map((p) => {
              'id': p.id,
              'packageId': p.packageId,
              'packageName': p.packageName,
              'amount': p.amount,
              'submittedDate': p.submittedDate.toIso8601String(),
              'status': p.status.name,
              'receiptPath': p.receiptPath,
              'bankTransferRef': p.bankTransferRef,
              'rejectionReason': p.rejectionReason,
            })
        .toList());
    await sharedPreferences.setString(AppConstants.prefsPaymentsKey, encoded);
    return request;
  }

  @override
  Future<void> updatePaymentStatus(
    String requestId,
    PaymentRequestStatus status,
    String? reason,
  ) async {
    final list = await getPaymentHistory();
    final updated = list.map((item) {
      if (item.id == requestId) {
        return PaymentRequestEntity(
          id: item.id,
          packageId: item.packageId,
          packageName: item.packageName,
          amount: item.amount,
          submittedDate: item.submittedDate,
          status: status,
          receiptPath: item.receiptPath,
          bankTransferRef: item.bankTransferRef,
          rejectionReason: reason,
        );
      }
      return item;
    }).toList();

    final encoded = jsonEncode(updated
        .map((p) => {
              'id': p.id,
              'packageId': p.packageId,
              'packageName': p.packageName,
              'amount': p.amount,
              'submittedDate': p.submittedDate.toIso8601String(),
              'status': p.status.name,
              'receiptPath': p.receiptPath,
              'bankTransferRef': p.bankTransferRef,
              'rejectionReason': p.rejectionReason,
            })
        .toList());
    await sharedPreferences.setString(AppConstants.prefsPaymentsKey, encoded);
  }
}
