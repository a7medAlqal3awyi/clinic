import 'dart:convert';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/user_permissions.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.phone,
    required super.customerType,
    required super.subscriptionStatus,
    super.subscriptionPackageName,
    super.subscriptionPackageTier,
    super.subscriptionStartDate,
    super.subscriptionEndDate,
    required super.gender,
    required super.age,
    required super.height,
    required super.currentWeight,
    required super.targetWeight,
    required super.mainGoal,
    super.avatarUrl,
  });

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      fullName: entity.fullName,
      email: entity.email,
      phone: entity.phone,
      customerType: entity.customerType,
      subscriptionStatus: entity.subscriptionStatus,
      subscriptionPackageName: entity.subscriptionPackageName,
      subscriptionPackageTier: entity.subscriptionPackageTier,
      subscriptionStartDate: entity.subscriptionStartDate,
      subscriptionEndDate: entity.subscriptionEndDate,
      gender: entity.gender,
      age: entity.age,
      height: entity.height,
      currentWeight: entity.currentWeight,
      targetWeight: entity.targetWeight,
      mainGoal: entity.mainGoal,
      avatarUrl: entity.avatarUrl,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      customerType: json['customerType'] == 'clinic'
          ? CustomerType.clinic
          : CustomerType.online,
      subscriptionStatus: _parseSubscriptionStatus(json['subscriptionStatus']),
      subscriptionPackageName: json['subscriptionPackageName'] as String?,
      subscriptionPackageTier: json['subscriptionPackageTier'] as String?,
      subscriptionStartDate: json['subscriptionStartDate'] != null
          ? DateTime.parse(json['subscriptionStartDate'] as String)
          : null,
      subscriptionEndDate: json['subscriptionEndDate'] != null
          ? DateTime.parse(json['subscriptionEndDate'] as String)
          : null,
      gender: json['gender'] as String? ?? 'male',
      age: (json['age'] as num?)?.toInt() ?? 28,
      height: (json['height'] as num?)?.toDouble() ?? 175.0,
      currentWeight: (json['currentWeight'] as num?)?.toDouble() ?? 85.0,
      targetWeight: (json['targetWeight'] as num?)?.toDouble() ?? 75.0,
      mainGoal: json['mainGoal'] as String? ?? 'Weight Loss',
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  static SubscriptionStatus _parseSubscriptionStatus(dynamic status) {
    switch (status) {
      case 'active':
        return SubscriptionStatus.active;
      case 'expired':
        return SubscriptionStatus.expired;
      case 'pendingReview':
        return SubscriptionStatus.pendingReview;
      default:
        return SubscriptionStatus.none;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'customerType': customerType == CustomerType.clinic ? 'clinic' : 'online',
      'subscriptionStatus': subscriptionStatus.name,
      'subscriptionPackageName': subscriptionPackageName,
      'subscriptionPackageTier': subscriptionPackageTier,
      'subscriptionStartDate': subscriptionStartDate?.toIso8601String(),
      'subscriptionEndDate': subscriptionEndDate?.toIso8601String(),
      'gender': gender,
      'age': age,
      'height': height,
      'currentWeight': currentWeight,
      'targetWeight': targetWeight,
      'mainGoal': mainGoal,
      'avatarUrl': avatarUrl,
    };
  }

  String toJsonString() => jsonEncode(toJson());

  factory UserModel.fromJsonString(String source) =>
      UserModel.fromJson(jsonDecode(source) as Map<String, dynamic>);
}
