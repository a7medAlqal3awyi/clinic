import 'package:equatable/equatable.dart';
import 'user_permissions.dart';

class UserEntity extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final CustomerType customerType;
  final SubscriptionStatus subscriptionStatus;
  final String? subscriptionPackageName;
  final String? subscriptionPackageTier;
  final DateTime? subscriptionStartDate;
  final DateTime? subscriptionEndDate;
  final String gender;
  final int age;
  final double height;
  final double currentWeight;
  final double targetWeight;
  final String mainGoal;
  final String? avatarUrl;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.customerType,
    required this.subscriptionStatus,
    this.subscriptionPackageName,
    this.subscriptionPackageTier,
    this.subscriptionStartDate,
    this.subscriptionEndDate,
    required this.gender,
    required this.age,
    required this.height,
    required this.currentWeight,
    required this.targetWeight,
    required this.mainGoal,
    this.avatarUrl,
  });

  UserPermissions get permissions => UserPermissions(
        customerType: customerType,
        subscriptionStatus: subscriptionStatus,
        packageTier: subscriptionPackageTier,
      );

  int get remainingSubscriptionDays {
    if (customerType == CustomerType.clinic) return 90; // Standard clinical plan cycle
    if (subscriptionEndDate == null) return 0;
    final diff = subscriptionEndDate!.difference(DateTime.now()).inDays;
    return diff > 0 ? diff : 0;
  }

  UserEntity copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    CustomerType? customerType,
    SubscriptionStatus? subscriptionStatus,
    String? subscriptionPackageName,
    String? subscriptionPackageTier,
    DateTime? subscriptionStartDate,
    DateTime? subscriptionEndDate,
    String? gender,
    int? age,
    double? height,
    double? currentWeight,
    double? targetWeight,
    String? mainGoal,
    String? avatarUrl,
  }) {
    return UserEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      customerType: customerType ?? this.customerType,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      subscriptionPackageName:
          subscriptionPackageName ?? this.subscriptionPackageName,
      subscriptionPackageTier:
          subscriptionPackageTier ?? this.subscriptionPackageTier,
      subscriptionStartDate:
          subscriptionStartDate ?? this.subscriptionStartDate,
      subscriptionEndDate: subscriptionEndDate ?? this.subscriptionEndDate,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      height: height ?? this.height,
      currentWeight: currentWeight ?? this.currentWeight,
      targetWeight: targetWeight ?? this.targetWeight,
      mainGoal: mainGoal ?? this.mainGoal,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        fullName,
        email,
        phone,
        customerType,
        subscriptionStatus,
        subscriptionPackageName,
        subscriptionPackageTier,
        subscriptionStartDate,
        subscriptionEndDate,
        gender,
        age,
        height,
        currentWeight,
        targetWeight,
        mainGoal,
        avatarUrl,
      ];
}
