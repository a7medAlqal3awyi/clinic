import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entities/nutrition_plan_entity.dart';

abstract class NutritionPlanLocalDataSource {
  Future<NutritionPlanEntity> getPlan();
  Future<void> toggleMeal(String mealId, bool completed);
  Future<void> updateNotes(String mealId, String notes);
  Future<void> savePlan(NutritionPlanEntity plan);
}

class NutritionPlanLocalDataSourceImpl implements NutritionPlanLocalDataSource {
  final SharedPreferences sharedPreferences;

  NutritionPlanLocalDataSourceImpl({required this.sharedPreferences});

  static NutritionPlanEntity get defaultDemoPlan => NutritionPlanEntity(
        id: 'plan_101',
        title: 'Caloric Deficit & High Protein Protocol',
        startDate: DateTime.now().subtract(const Duration(days: 7)),
        endDate: DateTime.now().add(const Duration(days: 23)),
        dailyCalorieTarget: 2100,
        proteinTargetGrams: 155,
        carbsTargetGrams: 200,
        fatsTargetGrams: 55,
        generalInstructions:
            'Drink at least 3.5 Liters of water daily. Take morning multivitamin with breakfast. Maintain a 30-minute brisk walk after lunch or dinner.',
        meals: [
          const MealEntity(
            id: 'meal_breakfast_1',
            name: 'Breakfast (Protein Oatmeal & Eggs)',
            time: '08:30 AM',
            totalCalories: 520,
            totalProtein: 42,
            totalCarbs: 58,
            totalFat: 14,
            isCompleted: true,
            notes: 'Added a pinch of cinnamon and chia seeds',
            items: [
              FoodItemEntity(
                name: 'Oats with Almond Milk',
                quantity: '60g oats + 150ml milk',
                calories: 240,
                protein: 8,
                carbs: 45,
                fat: 4,
              ),
              FoodItemEntity(
                name: 'Boiled Egg Whites + 1 Whole Egg',
                quantity: '3 Whites, 1 Whole',
                calories: 160,
                protein: 20,
                carbs: 1,
                fat: 7,
              ),
              FoodItemEntity(
                name: 'Greek Yogurt 0%',
                quantity: '100g',
                calories: 120,
                protein: 14,
                carbs: 12,
                fat: 3,
              ),
            ],
          ),
          const MealEntity(
            id: 'meal_lunch_2',
            name: 'Lunch (Grilled Salmon & Sweet Potato)',
            time: '02:00 PM',
            totalCalories: 680,
            totalProtein: 52,
            totalCarbs: 64,
            totalFat: 18,
            isCompleted: true,
            notes: 'Steamed broccoli with olive oil spray',
            items: [
              FoodItemEntity(
                name: 'Grilled Salmon Fillet',
                quantity: '180g',
                calories: 360,
                protein: 38,
                carbs: 0,
                fat: 14,
              ),
              FoodItemEntity(
                name: 'Baked Sweet Potato',
                quantity: '200g',
                calories: 210,
                protein: 4,
                carbs: 50,
                fat: 1,
              ),
              FoodItemEntity(
                name: 'Green Mixed Garden Salad',
                quantity: '1 Large Bowl',
                calories: 110,
                protein: 10,
                carbs: 14,
                fat: 3,
              ),
            ],
          ),
          const MealEntity(
            id: 'meal_snack_3',
            name: 'Snack (Almonds & Green Apple)',
            time: '05:30 PM',
            totalCalories: 260,
            totalProtein: 8,
            totalCarbs: 32,
            totalFat: 11,
            isCompleted: false,
            notes: null,
            items: [
              FoodItemEntity(
                name: 'Raw Unsalted Almonds',
                quantity: '20g',
                calories: 140,
                protein: 5,
                carbs: 4,
                fat: 11,
              ),
              FoodItemEntity(
                name: 'Crisp Green Apple',
                quantity: '1 medium (150g)',
                calories: 120,
                protein: 3,
                carbs: 28,
                fat: 0,
              ),
            ],
          ),
          const MealEntity(
            id: 'meal_dinner_4',
            name: 'Dinner (Grilled Chicken Breast & Quinoa)',
            time: '09:00 PM',
            totalCalories: 640,
            totalProtein: 53,
            totalCarbs: 46,
            totalFat: 12,
            isCompleted: false,
            notes: null,
            items: [
              FoodItemEntity(
                name: 'Skinless Chicken Breast',
                quantity: '200g',
                calories: 330,
                protein: 46,
                carbs: 0,
                fat: 6,
              ),
              FoodItemEntity(
                name: 'Cooked Quinoa',
                quantity: '130g',
                calories: 220,
                protein: 6,
                carbs: 39,
                fat: 4,
              ),
              FoodItemEntity(
                name: 'Sauteed Zucchini & Bell Peppers',
                quantity: '150g',
                calories: 90,
                protein: 1,
                carbs: 7,
                fat: 2,
              ),
            ],
          ),
        ],
      );

  @override
  Future<NutritionPlanEntity> getPlan() async {
    final raw = sharedPreferences.getString(AppConstants.prefsMealLogsKey);
    if (raw != null) {
      try {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        return _planFromJson(decoded);
      } catch (_) {
        return defaultDemoPlan;
      }
    }
    return defaultDemoPlan;
  }

  @override
  Future<void> toggleMeal(String mealId, bool completed) async {
    final plan = await getPlan();
    final updatedMeals = plan.meals.map((m) {
      if (m.id == mealId) {
        return m.copyWith(isCompleted: completed);
      }
      return m;
    }).toList();

    await savePlan(plan.copyWith(meals: updatedMeals));
  }

  @override
  Future<void> updateNotes(String mealId, String notes) async {
    final plan = await getPlan();
    final updatedMeals = plan.meals.map((m) {
      if (m.id == mealId) {
        return m.copyWith(notes: notes);
      }
      return m;
    }).toList();

    await savePlan(plan.copyWith(meals: updatedMeals));
  }

  @override
  Future<void> savePlan(NutritionPlanEntity plan) async {
    final map = _planToJson(plan);
    await sharedPreferences.setString(
      AppConstants.prefsMealLogsKey,
      jsonEncode(map),
    );
  }

  Map<String, dynamic> _planToJson(NutritionPlanEntity plan) {
    return {
      'id': plan.id,
      'title': plan.title,
      'startDate': plan.startDate.toIso8601String(),
      'endDate': plan.endDate.toIso8601String(),
      'dailyCalorieTarget': plan.dailyCalorieTarget,
      'proteinTargetGrams': plan.proteinTargetGrams,
      'carbsTargetGrams': plan.carbsTargetGrams,
      'fatsTargetGrams': plan.fatsTargetGrams,
      'generalInstructions': plan.generalInstructions,
      'meals': plan.meals
          .map((m) => {
                'id': m.id,
                'name': m.name,
                'time': m.time,
                'totalCalories': m.totalCalories,
                'totalProtein': m.totalProtein,
                'totalCarbs': m.totalCarbs,
                'totalFat': m.totalFat,
                'isCompleted': m.isCompleted,
                'notes': m.notes,
                'imageUrl': m.imageUrl,
                'items': m.items
                    .map((item) => {
                          'name': item.name,
                          'quantity': item.quantity,
                          'calories': item.calories,
                          'protein': item.protein,
                          'carbs': item.carbs,
                          'fat': item.fat,
                        })
                    .toList(),
              })
          .toList(),
    };
  }

  NutritionPlanEntity _planFromJson(Map<String, dynamic> map) {
    return NutritionPlanEntity(
      id: map['id'] as String,
      title: map['title'] as String,
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: DateTime.parse(map['endDate'] as String),
      dailyCalorieTarget: (map['dailyCalorieTarget'] as num).toInt(),
      proteinTargetGrams: (map['proteinTargetGrams'] as num).toDouble(),
      carbsTargetGrams: (map['carbsTargetGrams'] as num).toDouble(),
      fatsTargetGrams: (map['fatsTargetGrams'] as num).toDouble(),
      generalInstructions: map['generalInstructions'] as String?,
      meals: (map['meals'] as List<dynamic>)
          .map((m) => MealEntity(
                id: m['id'] as String,
                name: m['name'] as String,
                time: m['time'] as String,
                totalCalories: (m['totalCalories'] as num).toInt(),
                totalProtein: (m['totalProtein'] as num).toDouble(),
                totalCarbs: (m['totalCarbs'] as num).toDouble(),
                totalFat: (m['totalFat'] as num).toDouble(),
                isCompleted: m['isCompleted'] as bool? ?? false,
                notes: m['notes'] as String?,
                imageUrl: m['imageUrl'] as String?,
                items: (m['items'] as List<dynamic>)
                    .map((i) => FoodItemEntity(
                          name: i['name'] as String,
                          quantity: i['quantity'] as String,
                          calories: (i['calories'] as num).toInt(),
                          protein: (i['protein'] as num).toDouble(),
                          carbs: (i['carbs'] as num).toDouble(),
                          fat: (i['fat'] as num).toDouble(),
                        ))
                    .toList(),
              ))
          .toList(),
    );
  }
}
