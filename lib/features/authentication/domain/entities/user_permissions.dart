enum CustomerType {
  clinic,
  online,
}

enum SubscriptionStatus {
  active,
  expired,
  pendingReview,
  none,
}

class UserPermissions {
  final CustomerType customerType;
  final SubscriptionStatus subscriptionStatus;
  final String? packageTier; // 'basic', 'premium', 'vip'

  const UserPermissions({
    required this.customerType,
    required this.subscriptionStatus,
    this.packageTier,
  });

  bool get isClinic => customerType == CustomerType.clinic;
  bool get isOnline => customerType == CustomerType.online;
  bool get hasActiveSubscription =>
      isClinic || subscriptionStatus == SubscriptionStatus.active;

  // Feature Permissions
  bool get canAccessNutritionPlan => hasActiveSubscription;
  bool get canLogDailyMeals => hasActiveSubscription;
  bool get canAccessInBodyReports => true;
  bool get canAccessWeightTracking => true;
  bool get canAccessVisitHistory => isClinic;
  bool get canAccessOnlineFollowup => isOnline && hasActiveSubscription;
  bool get canChatWithSpecialist {
    if (isClinic) return true;
    if (!hasActiveSubscription) return false;
    // Basic tier in demo might not have direct unlimited chat, premium/vip do
    return packageTier != 'basic';
  }
  bool get canRenewOrUpgrade => isOnline;
}
