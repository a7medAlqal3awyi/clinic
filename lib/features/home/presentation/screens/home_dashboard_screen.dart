import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../../../authentication/domain/entities/user_permissions.dart';
import '../../../authentication/presentation/cubit/auth_cubit.dart';
import '../../../authentication/presentation/cubit/auth_state.dart';
import '../../../nutrition_plan/presentation/cubit/nutrition_plan_cubit.dart';
import '../../../nutrition_plan/presentation/cubit/nutrition_plan_state.dart';
import '../../../progress_tracking/presentation/cubit/progress_cubit.dart';
import '../../../progress_tracking/presentation/cubit/progress_state.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<AuthCubit>().reloadUser();
            context.read<NutritionPlanCubit>().loadPlan();
            context.read<ProgressCubit>().loadProgressData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                SizedBox(height: 18.h),
                _buildSubscriptionCard(context),
                SizedBox(height: 18.h),
                _buildCalorieAndMacrosCard(context),
                SizedBox(height: 18.h),
                _buildTodayMealsProgress(context),
                SizedBox(height: 18.h),
                _buildBiometricsSummary(context),
                SizedBox(height: 18.h),
                _buildQuickActions(context),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colors = context.customColors;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;
        final name = user?.fullName ?? 'Valued Customer';
        final isClinic = user?.customerType == CustomerType.clinic;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24.r,
                    backgroundColor: colors.primaryLight,
                    child: Icon(Icons.person, color: colors.primary, size: 28.sp),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr(AppStrings.welcomeBack),
                          style: AppTextStyles.caption(context).copyWith(
                            fontSize: 12.sp,
                          ),
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                name,
                                style: AppTextStyles.headingLarge(context),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: isClinic ? colors.primaryLight : colors.chipBackground,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: isClinic ? colors.primary : colors.secondary,
                                  width: 0.8,
                                ),
                              ),
                              child: Text(
                                isClinic
                                    ? context.tr(AppStrings.clinicCustomer)
                                    : context.tr(AppStrings.onlineCustomer),
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isClinic ? colors.primaryDark : colors.secondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.notifications);
                  },
                  icon: Stack(
                    children: [
                      Icon(Icons.notifications_none_rounded, size: 26.sp, color: colors.textPrimary),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            color: colors.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.demoTools);
                  },
                  icon: Icon(Icons.tune_rounded, size: 22.sp, color: colors.primary),
                  tooltip: context.tr(AppStrings.demoTestingTools),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildSubscriptionCard(BuildContext context) {
    final colors = context.customColors;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;
        final hasActive = user?.permissions.hasActiveSubscription ?? false;
        final remaining = user?.remainingSubscriptionDays ?? 0;
        final packageName = user?.subscriptionPackageName ?? 'Standard Health Protocol';

        return CustomCard(
          backgroundColor: colors.primaryDark,
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.verified_user_rounded, color: Colors.white, size: 18.sp),
                      SizedBox(width: 8.w),
                      Text(
                        context.tr(AppStrings.subscriptionStatus),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: hasActive ? colors.success : colors.warning,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      hasActive ? context.tr(AppStrings.active) : context.tr(AppStrings.pending),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                packageName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$remaining ${context.tr(AppStrings.daysLeft)}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13.sp,
                    ),
                  ),
                  if (user?.permissions.canRenewOrUpgrade ?? false)
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoutes.subscriptionPackages);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        context.tr(AppStrings.renewSubscription),
                        style: TextStyle(
                          color: colors.primaryLight,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCalorieAndMacrosCard(BuildContext context) {
    final colors = context.customColors;

    return BlocBuilder<NutritionPlanCubit, NutritionPlanState>(
      builder: (context, state) {
        final plan = state is NutritionPlanLoaded ? state.plan : null;
        final target = plan?.dailyCalorieTarget ?? 2100;
        final consumed = plan?.consumedCalories ?? 1200;
        final progress = (consumed / target).clamp(0.0, 1.0);

        return CustomCard(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.tr(AppStrings.dailyCalorieTarget),
                    style: AppTextStyles.headingMedium(context),
                  ),
                  Text(
                    '$consumed / $target ${context.tr(AppStrings.kcal)}',
                    style: AppTextStyles.headingSmall(context).copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10.h,
                  backgroundColor: colors.border,
                  valueColor: AlwaysStoppedAnimation<Color>(colors.progressFill),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMacroPill(
                    context,
                    label: context.tr(AppStrings.protein),
                    amount: '${plan?.proteinTargetGrams.toInt() ?? 155}g',
                    color: const Color(0xFF3B82F6),
                  ),
                  _buildMacroPill(
                    context,
                    label: context.tr(AppStrings.carbs),
                    amount: '${plan?.carbsTargetGrams.toInt() ?? 200}g',
                    color: const Color(0xFFF59E0B),
                  ),
                  _buildMacroPill(
                    context,
                    label: context.tr(AppStrings.fats),
                    amount: '${plan?.fatsTargetGrams.toInt() ?? 55}g',
                    color: const Color(0xFF10B981),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMacroPill(
    BuildContext context, {
    required String label,
    required String amount,
    required Color color,
  }) {
    final colors = context.customColors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: colors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            amount,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayMealsProgress(BuildContext context) {
    final colors = context.customColors;

    return BlocBuilder<NutritionPlanCubit, NutritionPlanState>(
      builder: (context, state) {
        final plan = state is NutritionPlanLoaded ? state.plan : null;
        final meals = plan?.meals ?? [];
        final completedMeals = meals.where((m) => m.isCompleted).length;
        final totalMeals = meals.length;

        return CustomCard(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.tr(AppStrings.todayMeals),
                    style: AppTextStyles.headingMedium(context),
                  ),
                  Text(
                    '$completedMeals / $totalMeals',
                    style: AppTextStyles.caption(context).copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              if (meals.isEmpty)
                Text(
                  context.tr(AppStrings.noMealsToday),
                  style: AppTextStyles.bodyMedium(context),
                )
              else
                ...meals.take(3).map((m) => Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: Row(
                        children: [
                          Icon(
                            m.isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                            color: m.isCompleted ? colors.success : colors.textMuted,
                            size: 20.sp,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  m.name,
                                  style: AppTextStyles.bodyLarge(context).copyWith(
                                    fontWeight: FontWeight.w600,
                                    decoration: m.isCompleted ? TextDecoration.lineThrough : null,
                                  ),
                                ),
                                Text(
                                  '${m.time} • ${m.totalCalories} kcal',
                                  style: AppTextStyles.caption(context),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBiometricsSummary(BuildContext context) {
    final colors = context.customColors;

    return BlocBuilder<ProgressCubit, ProgressState>(
      builder: (context, state) {
        final latestWeight = state is ProgressLoaded ? state.latestWeight?.weight : 88.0;
        final latestInBody = state is ProgressLoaded && state.inBodyReports.isNotEmpty
            ? state.inBodyReports.first
            : null;

        return Row(
          children: [
            Expanded(
              child: CustomCard(
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.weightHistory),
                padding: EdgeInsets.all(14.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.monitor_weight_outlined, size: 18.sp, color: colors.primary),
                        SizedBox(width: 6.w),
                        Text(
                          context.tr(AppStrings.latestWeight),
                          style: AppTextStyles.caption(context),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '$latestWeight kg',
                      style: AppTextStyles.headingLarge(context).copyWith(
                        color: colors.primaryDark,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '-4.0 kg overall',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: colors.success,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: CustomCard(
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.inbodyReports),
                padding: EdgeInsets.all(14.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.pie_chart_outline_rounded, size: 18.sp, color: colors.secondary),
                        SizedBox(width: 6.w),
                        Text(
                          context.tr(AppStrings.bodyFatPercentage),
                          style: AppTextStyles.caption(context),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '${latestInBody?.bodyFatPercentage ?? 24.2}%',
                      style: AppTextStyles.headingLarge(context).copyWith(
                        color: colors.secondary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'BMI: ${latestInBody?.bmi ?? 26.8}',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final colors = context.customColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr(AppStrings.quickActions),
          style: AppTextStyles.headingLarge(context),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildActionItem(
                context,
                title: context.tr(AppStrings.trackWeight),
                icon: Icons.add_circle_outline_rounded,
                color: colors.primary,
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.addWeight),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _buildActionItem(
                context,
                title: context.tr(AppStrings.inbodyReports),
                icon: Icons.analytics_outlined,
                color: colors.secondary,
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.inbodyReports),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final user = state is AuthAuthenticated ? state.user : null;
            final canOnlineFollowup = user?.permissions.canAccessOnlineFollowup ?? false;

            return Row(
              children: [
                Expanded(
                  child: _buildActionItem(
                    context,
                    title: context.tr(AppStrings.chatWithSpecialist),
                    icon: Icons.chat_bubble_outline_rounded,
                    color: const Color(0xFF0EA5E9),
                    onTap: () => Navigator.of(context).pushNamed(AppRoutes.chatDetails),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _buildActionItem(
                    context,
                    title: context.tr(AppStrings.onlineFollowup),
                    icon: Icons.assignment_turned_in_outlined,
                    color: const Color(0xFF8B5CF6),
                    onTap: () {
                      if (canOnlineFollowup) {
                        Navigator.of(context).pushNamed(AppRoutes.newFollowup);
                      } else {
                        Navigator.of(context).pushNamed(AppRoutes.subscriptionPackages);
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return CustomCard(
      onTap: onTap,
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 10.w),
      child: Column(
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundColor: color.withOpacity(0.12),
            child: Icon(icon, color: color, size: 20.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
