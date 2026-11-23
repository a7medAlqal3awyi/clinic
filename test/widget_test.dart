import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clinic/core/di/injection_container.dart';
import 'package:clinic/features/authentication/domain/entities/user_entity.dart';
import 'package:clinic/features/authentication/domain/entities/user_permissions.dart';
import 'package:clinic/features/nutrition_plan/domain/entities/nutrition_plan_entity.dart';
import 'package:clinic/features/progress_tracking/domain/entities/progress_entities.dart';
import 'package:clinic/features/subscriptions/domain/entities/subscription_entities.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await initServiceLocator();
  });

  tearDown(() async {
    await sl.reset();
  });

  test('UserEntity permissions logic works for clinic and online customers', () {
    final clinicUser = UserEntity(
      id: 'clinic_1',
      fullName: 'Mohamed Clinic',
      email: 'clinic@test.com',
      phone: '01000000000',
      customerType: CustomerType.clinic,
      subscriptionStatus: SubscriptionStatus.active,
      gender: 'male',
      age: 30,
      height: 180,
      currentWeight: 85,
      targetWeight: 75,
      mainGoal: 'Weight Loss',
    );

    expect(clinicUser.permissions.isClinic, isTrue);
    expect(clinicUser.permissions.canAccessVisitHistory, isTrue);
    expect(clinicUser.permissions.canChatWithSpecialist, isTrue);

    final onlineUser = UserEntity(
      id: 'online_1',
      fullName: 'Sara Online',
      email: 'online@test.com',
      phone: '01100000000',
      customerType: CustomerType.online,
      subscriptionStatus: SubscriptionStatus.active,
      subscriptionPackageTier: 'premium',
      gender: 'female',
      age: 26,
      height: 165,
      currentWeight: 65,
      targetWeight: 58,
      mainGoal: 'Tone',
    );

    expect(onlineUser.permissions.isOnline, isTrue);
    expect(onlineUser.permissions.canAccessOnlineFollowup, isTrue);
    expect(onlineUser.permissions.canChatWithSpecialist, isTrue);
  });

  test('NutritionPlanEntity consumed calories and completion calculation', () {
    const meal1 = MealEntity(
      id: 'm1',
      name: 'Breakfast',
      time: '08:00',
      totalCalories: 400,
      totalProtein: 30,
      totalCarbs: 40,
      totalFat: 10,
      isCompleted: true,
      items: [],
    );
    const meal2 = MealEntity(
      id: 'm2',
      name: 'Lunch',
      time: '14:00',
      totalCalories: 600,
      totalProtein: 45,
      totalCarbs: 60,
      totalFat: 15,
      isCompleted: false,
      items: [],
    );

    final plan = NutritionPlanEntity(
      id: 'p1',
      title: 'Plan',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
      dailyCalorieTarget: 2000,
      proteinTargetGrams: 150,
      carbsTargetGrams: 200,
      fatsTargetGrams: 50,
      meals: const [meal1, meal2],
    );

    expect(plan.consumedCalories, equals(400));
    expect(plan.completionPercentage, equals(0.5));
  });

  test('SubscriptionPackageEntity models demo pricing correctly', () {
    const pkg = SubscriptionPackageEntity(
      id: 'pkg_prem',
      name: 'Premium',
      tier: 'premium',
      description: 'Full care',
      durationMonths: 3,
      price: 2200.0,
      features: ['Feature 1', 'Feature 2'],
      isPopular: true,
    );

    expect(pkg.price, equals(2200.0));
    expect(pkg.currency, equals('EGP'));
    expect(pkg.isPopular, isTrue);
  });
}
