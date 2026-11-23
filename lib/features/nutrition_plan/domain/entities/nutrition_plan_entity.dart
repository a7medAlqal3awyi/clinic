import 'package:equatable/equatable.dart';

class FoodItemEntity extends Equatable {
  final String name;
  final String quantity;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;

  const FoodItemEntity({
    required this.name,
    required this.quantity,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  @override
  List<Object?> get props => [name, quantity, calories, protein, carbs, fat];
}

class MealEntity extends Equatable {
  final String id;
  final String name; // e.g. Breakfast, Lunch, Dinner, Snack
  final String time; // e.g. "08:30 AM"
  final List<FoodItemEntity> items;
  final int totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final String? notes;
  final String? imageUrl;
  final bool isCompleted;

  const MealEntity({
    required this.id,
    required this.name,
    required this.time,
    required this.items,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    this.notes,
    this.imageUrl,
    this.isCompleted = false,
  });

  MealEntity copyWith({
    String? id,
    String? name,
    String? time,
    List<FoodItemEntity>? items,
    int? totalCalories,
    double? totalProtein,
    double? totalCarbs,
    double? totalFat,
    String? notes,
    String? imageUrl,
    bool? isCompleted,
  }) {
    return MealEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      time: time ?? this.time,
      items: items ?? this.items,
      totalCalories: totalCalories ?? this.totalCalories,
      totalProtein: totalProtein ?? this.totalProtein,
      totalCarbs: totalCarbs ?? this.totalCarbs,
      totalFat: totalFat ?? this.totalFat,
      notes: notes ?? this.notes,
      imageUrl: imageUrl ?? this.imageUrl,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        time,
        items,
        totalCalories,
        totalProtein,
        totalCarbs,
        totalFat,
        notes,
        imageUrl,
        isCompleted,
      ];
}

class NutritionPlanEntity extends Equatable {
  final String id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final int dailyCalorieTarget;
  final double proteinTargetGrams;
  final double carbsTargetGrams;
  final double fatsTargetGrams;
  final List<MealEntity> meals;
  final String? generalInstructions;

  const NutritionPlanEntity({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.dailyCalorieTarget,
    required this.proteinTargetGrams,
    required this.carbsTargetGrams,
    required this.fatsTargetGrams,
    required this.meals,
    this.generalInstructions,
  });

  int get consumedCalories => meals
      .where((m) => m.isCompleted)
      .fold(0, (sum, m) => sum + m.totalCalories);

  double get completionPercentage {
    if (meals.isEmpty) return 0.0;
    final completed = meals.where((m) => m.isCompleted).length;
    return (completed / meals.length).clamp(0.0, 1.0);
  }

  NutritionPlanEntity copyWith({
    String? id,
    String? title,
    DateTime? startDate,
    DateTime? endDate,
    int? dailyCalorieTarget,
    double? proteinTargetGrams,
    double? carbsTargetGrams,
    double? fatsTargetGrams,
    List<MealEntity>? meals,
    String? generalInstructions,
  }) {
    return NutritionPlanEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      dailyCalorieTarget: dailyCalorieTarget ?? this.dailyCalorieTarget,
      proteinTargetGrams: proteinTargetGrams ?? this.proteinTargetGrams,
      carbsTargetGrams: carbsTargetGrams ?? this.carbsTargetGrams,
      fatsTargetGrams: fatsTargetGrams ?? this.fatsTargetGrams,
      meals: meals ?? this.meals,
      generalInstructions: generalInstructions ?? this.generalInstructions,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        startDate,
        endDate,
        dailyCalorieTarget,
        proteinTargetGrams,
        carbsTargetGrams,
        fatsTargetGrams,
        meals,
        generalInstructions,
      ];
}
