import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../domain/entities/nutrition_plan_entity.dart';
import '../cubit/nutrition_plan_cubit.dart';

class MealDetailsScreen extends StatefulWidget {
  final MealEntity meal;

  const MealDetailsScreen({super.key, required this.meal});

  @override
  State<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  late TextEditingController _notesController;
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.meal.notes ?? '');
    _isCompleted = widget.meal.isCompleted;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _saveNotes() {
    context.read<NutritionPlanCubit>().updateNotes(
          widget.meal.id,
          _notesController.text.trim(),
        );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.tr(AppStrings.success)),
        backgroundColor: context.customColors.success,
      ),
    );
  }

  void _toggleMeal() {
    setState(() => _isCompleted = !_isCompleted);
    context.read<NutritionPlanCubit>().toggleMeal(widget.meal.id, _isCompleted);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final meal = widget.meal;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(meal.name, style: AppTextStyles.headingLarge(context)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomCard(
                padding: EdgeInsets.all(16.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${meal.totalCalories} ${context.tr(AppStrings.kcal)}',
                          style: AppTextStyles.displayMedium(context).copyWith(
                            color: colors.primary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Scheduled: ${meal.time}',
                          style: AppTextStyles.bodyMedium(context),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: _toggleMeal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isCompleted ? colors.success : colors.primaryLight,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      icon: Icon(
                        _isCompleted ? Icons.check : Icons.add,
                        color: _isCompleted ? Colors.white : colors.primary,
                        size: 18.sp,
                      ),
                      label: Text(
                        _isCompleted
                            ? context.tr(AppStrings.markCompleted)
                            : context.tr(AppStrings.markIncomplete),
                        style: TextStyle(
                          color: _isCompleted ? Colors.white : colors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h),

              // Macro breakdown
              Text(
                context.tr(AppStrings.macroNutrients),
                style: AppTextStyles.headingLarge(context),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  _buildMacroBox(context, 'Protein', '${meal.totalProtein}g', const Color(0xFF3B82F6)),
                  SizedBox(width: 10.w),
                  _buildMacroBox(context, 'Carbs', '${meal.totalCarbs}g', const Color(0xFFF59E0B)),
                  SizedBox(width: 10.w),
                  _buildMacroBox(context, 'Fats', '${meal.totalFat}g', const Color(0xFF10B981)),
                ],
              ),
              SizedBox(height: 22.h),

              // Food items
              Text(
                context.tr(AppStrings.foodItems),
                style: AppTextStyles.headingLarge(context),
              ),
              SizedBox(height: 10.h),
              ...meal.items.map((item) => Container(
                    margin: EdgeInsets.only(bottom: 8.h),
                    child: CustomCard(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name, style: AppTextStyles.headingSmall(context)),
                              SizedBox(height: 2.h),
                              Text(
                                item.quantity,
                                style: AppTextStyles.caption(context),
                              ),
                            ],
                          ),
                          Text(
                            '${item.calories} kcal',
                            style: TextStyle(
                              color: colors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              SizedBox(height: 20.h),

              // Meal Notes
              Text(
                context.tr(AppStrings.mealNotes),
                style: AppTextStyles.headingLarge(context),
              ),
              SizedBox(height: 8.h),
              CustomTextField(
                controller: _notesController,
                hint: context.tr(AppStrings.addNotes),
                maxLines: 3,
              ),
              SizedBox(height: 14.h),
              CustomButton(
                text: context.tr(AppStrings.save),
                onPressed: _saveNotes,
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMacroBox(BuildContext context, String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: context.customColors.textSecondary,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
