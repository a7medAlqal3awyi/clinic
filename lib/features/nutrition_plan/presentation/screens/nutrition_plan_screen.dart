import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/entities/nutrition_plan_entity.dart';
import '../cubit/nutrition_plan_cubit.dart';
import '../cubit/nutrition_plan_state.dart';

class NutritionPlanScreen extends StatefulWidget {
  const NutritionPlanScreen({super.key});

  @override
  State<NutritionPlanScreen> createState() => _NutritionPlanScreenState();
}

class _NutritionPlanScreenState extends State<NutritionPlanScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          context.tr(AppStrings.nutritionPlanTitle),
          style: AppTextStyles.headingLarge(context),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<NutritionPlanCubit, NutritionPlanState>(
          builder: (context, state) {
            if (state is NutritionPlanLoading) {
              return StateViews.loading(context);
            } else if (state is NutritionPlanError) {
              return StateViews.error(
                context,
                message: state.message,
                onRetry: () => context.read<NutritionPlanCubit>().loadPlan(),
              );
            } else if (state is NutritionPlanLoaded) {
              final plan = state.plan;
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDaySelector(context),
                    SizedBox(height: 16.h),
                    _buildPlanHeaderCard(context, plan),
                    SizedBox(height: 16.h),
                    Text(
                      context.tr(AppStrings.todayMeals),
                      style: AppTextStyles.headingLarge(context),
                    ),
                    SizedBox(height: 10.h),
                    ...plan.meals.map((meal) => _buildMealCard(context, meal)),
                    SizedBox(height: 16.h),
                    if (plan.generalInstructions != null)
                      _buildInstructionsCard(context, plan.generalInstructions!),
                    SizedBox(height: 24.h),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildDaySelector(BuildContext context) {
    final colors = context.customColors;
    final now = DateTime.now();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (index) {
        final date = now.subtract(Duration(days: 2 - index));
        final isSelected = _selectedDate.day == date.day &&
            _selectedDate.month == date.month;

        final dayLabels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
        final dayName = dayLabels[date.weekday % 7];

        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedDate = date),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 3.w),
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                color: isSelected ? colors.primary : colors.surface,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSelected ? colors.primary : colors.border,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    dayName,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: isSelected ? Colors.white70 : colors.textMuted,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPlanHeaderCard(BuildContext context, NutritionPlanEntity plan) {
    final colors = context.customColors;

    return CustomCard(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  plan.title,
                  style: AppTextStyles.headingMedium(context),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: colors.primaryLight,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '${(plan.completionPercentage * 100).toInt()}% ${context.tr(AppStrings.donePercent)}',
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${context.tr(AppStrings.dailyCalorieTarget)}: ${plan.dailyCalorieTarget} kcal',
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.primaryDark,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '${context.tr(AppStrings.consumedWithColon)}: ${plan.consumedCalories} ${context.tr(AppStrings.kcal)}',
                style: AppTextStyles.bodyMedium(context),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: LinearProgressIndicator(
              value: plan.completionPercentage,
              minHeight: 8.h,
              backgroundColor: colors.border,
              valueColor: AlwaysStoppedAnimation<Color>(colors.progressFill),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard(BuildContext context, MealEntity meal) {
    final colors = context.customColors;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: CustomCard(
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRoutes.mealDetails,
            arguments: meal,
          );
        },
        padding: EdgeInsets.all(14.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    meal.isCompleted
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: meal.isCompleted ? colors.success : colors.textMuted,
                    size: 24.sp,
                  ),
                  onPressed: () {
                    context
                        .read<NutritionPlanCubit>()
                        .toggleMeal(meal.id, !meal.isCompleted);
                  },
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.name,
                        style: AppTextStyles.headingSmall(context).copyWith(
                          decoration: meal.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      Text(
                        '${meal.time} • ${meal.totalCalories} kcal',
                        style: AppTextStyles.caption(context),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14.sp,
                  color: colors.textMuted,
                ),
              ],
            ),
            if (meal.items.isNotEmpty) ...[
              SizedBox(height: 10.h),
              Divider(color: colors.divider),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 4.h,
                children: meal.items.take(3).map((item) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: colors.background,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: colors.border),
                    ),
                    child: Text(
                      '${item.name} (${item.quantity})',
                      style: TextStyle(fontSize: 10.sp, color: colors.textSecondary),
                    ),
                  );
                }).toList(),
              ),
            ],
            if (meal.notes != null && meal.notes!.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(Icons.notes_rounded, size: 14.sp, color: colors.primary),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      meal.notes!,
                      style: AppTextStyles.caption(context).copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionsCard(BuildContext context, String instructions) {
    final colors = context.customColors;

    return CustomCard(
      backgroundColor: colors.chipBackground,
      padding: EdgeInsets.all(14.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.medical_services_outlined, size: 18.sp, color: colors.primary),
              SizedBox(width: 8.w),
              Text(
                context.tr(AppStrings.instructions),
                style: AppTextStyles.headingSmall(context).copyWith(
                  color: colors.primaryDark,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            instructions,
            style: AppTextStyles.bodyMedium(context).copyWith(
              color: colors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
