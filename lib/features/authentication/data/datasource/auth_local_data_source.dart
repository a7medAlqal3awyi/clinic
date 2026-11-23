import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/user_permissions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> getSavedUser();
  Future<void> saveUser(UserModel user);
  Future<void> clearUser();
  Future<UserModel> loginDemo({
    required String emailOrPhone,
    required String password,
  });
  Future<UserModel> registerDemo(UserModel newUser);
  Future<void> updateDemoSubscription({
    required String status,
    String? packageName,
    String? tier,
    int? durationDays,
  });
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  // Predefined Demo Accounts
  static final UserModel demoClinicUser = UserModel(
    id: 'user_clinic_001',
    fullName: 'Mohamed Ahmed',
    email: 'clinic@example.com',
    phone: '01012345678',
    customerType: CustomerType.clinic,
    subscriptionStatus: SubscriptionStatus.active,
    subscriptionPackageName: 'Clinic Executive Care',
    subscriptionPackageTier: 'vip',
    subscriptionStartDate: DateTime.now().subtract(const Duration(days: 30)),
    subscriptionEndDate: DateTime.now().add(const Duration(days: 60)),
    gender: 'male',
    age: 32,
    height: 180,
    currentWeight: 88.5,
    targetWeight: 78.0,
    mainGoal: 'Weight Loss & Fat Reduction',
    avatarUrl: null,
  );

  static final UserModel demoOnlineUser = UserModel(
    id: 'user_online_002',
    fullName: 'Yasmine Hassan',
    email: 'online@example.com',
    phone: '01198765432',
    customerType: CustomerType.online,
    subscriptionStatus: SubscriptionStatus.active,
    subscriptionPackageName: 'Premium Online Nutrition',
    subscriptionPackageTier: 'premium',
    subscriptionStartDate: DateTime.now().subtract(const Duration(days: 15)),
    subscriptionEndDate: DateTime.now().add(const Duration(days: 75)),
    gender: 'female',
    age: 27,
    height: 165,
    currentWeight: 68.0,
    targetWeight: 58.0,
    mainGoal: 'Lean Body & Muscle Tone',
    avatarUrl: null,
  );

  @override
  Future<UserModel?> getSavedUser() async {
    final raw = sharedPreferences.getString(AppConstants.prefsUserKey);
    if (raw != null) {
      try {
        return UserModel.fromJsonString(raw);
      } catch (_) {
        return null;
      }
    }
    // Default to clinic customer on initial fresh launch if desired, or null
    return demoClinicUser;
  }

  @override
  Future<void> saveUser(UserModel user) async {
    await sharedPreferences.setString(
      AppConstants.prefsUserKey,
      user.toJsonString(),
    );
  }

  @override
  Future<void> clearUser() async {
    await sharedPreferences.remove(AppConstants.prefsUserKey);
  }

  @override
  Future<UserModel> loginDemo({
    required String emailOrPhone,
    required String password,
  }) async {
    // Artificial slight delay for realistic network simulation
    await Future.delayed(const Duration(milliseconds: 600));

    final normalized = emailOrPhone.trim().toLowerCase();
    if (normalized == 'clinic@example.com' || normalized == '01012345678') {
      await saveUser(demoClinicUser);
      return demoClinicUser;
    } else if (normalized == 'online@example.com' || normalized == '01198765432') {
      await saveUser(demoOnlineUser);
      return demoOnlineUser;
    } else {
      // Allow any login with default online user profile
      final customUser = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        fullName: normalized.contains('@') ? normalized.split('@').first : 'Demo User',
        email: normalized.contains('@') ? normalized : '$normalized@demo.com',
        phone: '01000000000',
        customerType: CustomerType.online,
        subscriptionStatus: SubscriptionStatus.active,
        subscriptionPackageName: 'Standard Nutrition Plan',
        subscriptionPackageTier: 'basic',
        subscriptionStartDate: DateTime.now(),
        subscriptionEndDate: DateTime.now().add(const Duration(days: 30)),
        gender: 'male',
        age: 26,
        height: 175,
        currentWeight: 80,
        targetWeight: 72,
        mainGoal: 'Healthy Lifestyle',
      );
      await saveUser(customUser);
      return customUser;
    }
  }

  @override
  Future<UserModel> registerDemo(UserModel newUser) async {
    await Future.delayed(const Duration(milliseconds: 700));
    await saveUser(newUser);
    return newUser;
  }

  @override
  Future<void> updateDemoSubscription({
    required String status,
    String? packageName,
    String? tier,
    int? durationDays,
  }) async {
    final current = await getSavedUser();
    if (current == null) return;

    SubscriptionStatus parsedStatus;
    switch (status) {
      case 'active':
        parsedStatus = SubscriptionStatus.active;
        break;
      case 'expired':
        parsedStatus = SubscriptionStatus.expired;
        break;
      case 'pendingReview':
        parsedStatus = SubscriptionStatus.pendingReview;
        break;
      default:
        parsedStatus = SubscriptionStatus.none;
    }

    final updated = UserModel.fromEntity(
      current.copyWith(
        subscriptionStatus: parsedStatus,
        subscriptionPackageName: packageName ?? current.subscriptionPackageName,
        subscriptionPackageTier: tier ?? current.subscriptionPackageTier,
        subscriptionEndDate: durationDays != null
            ? DateTime.now().add(Duration(days: durationDays))
            : (parsedStatus == SubscriptionStatus.expired
                ? DateTime.now().subtract(const Duration(days: 1))
                : current.subscriptionEndDate),
      ),
    );
    await saveUser(updated);
  }
}
