import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../authentication/domain/entities/user_permissions.dart';
import '../../../authentication/presentation/cubit/auth_cubit.dart';
import '../../../authentication/presentation/cubit/auth_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          context.tr(AppStrings.profileTitle),
          style: AppTextStyles.headingLarge(context),
        ),
        elevation: 0,
        backgroundColor: colors.background,
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: context.tr(AppStrings.editProfile),
            icon: Icon(
              Icons.edit_note_rounded,
              color: colors.primary,
              size: 26.sp,
            ),
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.editProfile),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(context),
              SizedBox(height: 16.h),
              _buildHealthMetricsGrid(context),
              SizedBox(height: 20.h),
              _buildSectionTitle(
                context,
                context.tr(AppStrings.profileQuickActions),
              ),
              SizedBox(height: 10.h),
              _buildAccountSection(context),
              SizedBox(height: 20.h),
              _buildSectionTitle(
                context,
                context.tr(AppStrings.profileAppPreferences),
              ),
              SizedBox(height: 10.h),
              _buildPreferencesSection(context),
              SizedBox(height: 28.h),
              _buildLogoutButton(context),
              SizedBox(height: 16.h),
              Center(
                child: Text(
                  context.tr(AppStrings.version),
                  style: AppTextStyles.caption(
                    context,
                  ).copyWith(color: colors.textMuted, fontSize: 11.sp),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Text(
        title,
        style: AppTextStyles.headingSmall(context).copyWith(
          color: context.customColors.primaryDark,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    final colors = context.customColors;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;
        final isClinic = user?.customerType == CustomerType.clinic;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colors.primary, colors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: colors.primary.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: EdgeInsets.all(20.r),
          child: Column(
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(3.r),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 34.r,
                          backgroundColor: colors.primaryLight,
                          child: Icon(
                            Icons.person_rounded,
                            size: 38.sp,
                            color: colors.primary,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: EdgeInsets.all(4.r),
                          decoration: BoxDecoration(
                            color: colors.success,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Icon(
                            Icons.check,
                            size: 10.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.fullName ?? 'Valued Customer',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          user?.email ?? 'user@clinic.com',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.35),
                                  width: 0.8,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isClinic
                                        ? Icons.local_hospital_rounded
                                        : Icons.phone_android_rounded,
                                    size: 12.sp,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    isClinic
                                        ? context.tr(AppStrings.clinicCustomer)
                                        : context.tr(AppStrings.onlineCustomer),
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (user != null) ...[
                SizedBox(height: 16.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.workspace_premium_rounded,
                            color: Colors.amberAccent,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            user.subscriptionPackageName ??
                                context.tr(AppStrings.active),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          '${user.remainingSubscriptionDays} ${context.tr(AppStrings.daysLeft)}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildHealthMetricsGrid(BuildContext context) {
    final colors = context.customColors;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;
        if (user == null) return const SizedBox.shrink();

        final heightM = user.height / 100.0;
        final bmi = heightM > 0
            ? (user.currentWeight / (heightM * heightM)).toStringAsFixed(1)
            : '24.5';
        final weightDiff = (user.currentWeight - user.targetWeight)
            .abs()
            .toStringAsFixed(1);

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildMetricTile(
                    context,
                    title: context.tr(AppStrings.currentWeight),
                    value: '${user.currentWeight}',
                    unit: context.tr(AppStrings.profileWeightUnit),
                    icon: Icons.monitor_weight_outlined,
                    iconColor: colors.primary,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildMetricTile(
                    context,
                    title: context.tr(AppStrings.targetWeight),
                    value: '${user.targetWeight}',
                    unit: context.tr(AppStrings.profileWeightUnit),
                    icon: Icons.flag_circle_outlined,
                    iconColor: colors.secondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _buildMetricTile(
                    context,
                    title: context.tr(AppStrings.height),
                    value: '${user.height.toInt()}',
                    unit: context.tr(AppStrings.profileHeightUnit),
                    icon: Icons.height_rounded,
                    iconColor: Colors.teal,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildMetricTile(
                    context,
                    title: context.tr(AppStrings.profileBmiLabel),
                    value: bmi,
                    unit: 'kg/m²',
                    icon: Icons.speed_rounded,
                    iconColor: colors.warning,
                    subtitle:
                        '$weightDiff ${context.tr(AppStrings.profileWeightUnit)} ${context.tr(AppStrings.profileWeightGoalDiff)}',
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetricTile(
    BuildContext context, {
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color iconColor,
    String? subtitle,
  }) {
    final colors = context.customColors;

    return CustomCard(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.caption(context).copyWith(
                    fontSize: 11.sp,
                    color: colors.textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 4.w),
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 16.sp),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: AppTextStyles.headingLarge(context).copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 17.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: colors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 9.sp,
                color: colors.primaryDark,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    final colors = context.customColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: colors.cardShadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildActionItem(
            context,
            icon: Icons.person_outline_rounded,
            iconColor: colors.primary,
            title: context.tr(AppStrings.editProfile),
            subtitle: context.tr(AppStrings.fullName),
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.editProfile),
          ),
          _buildDivider(colors),
          _buildActionItem(
            context,
            icon: Icons.card_membership_rounded,
            iconColor: Colors.amber.shade700,
            title: context.tr(AppStrings.subscriptionsTitle),
            subtitle: context.tr(AppStrings.availablePackages),
            onTap: () =>
                Navigator.of(context).pushNamed(AppRoutes.subscriptionPackages),
          ),
          _buildDivider(colors),
          _buildActionItem(
            context,
            icon: Icons.receipt_long_rounded,
            iconColor: Colors.indigo,
            title: context.tr(AppStrings.paymentStatus),
            subtitle: context.tr(AppStrings.currentSubscriptionDetails),
            onTap: () =>
                Navigator.of(context).pushNamed(AppRoutes.paymentStatus),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesSection(BuildContext context) {
    final colors = context.customColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: colors.cardShadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildActionItem(
            context,
            icon: Icons.settings_outlined,
            iconColor: colors.textSecondary,
            title: context.tr(AppStrings.settings),
            subtitle: context.tr(AppStrings.language),
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.settings),
          ),
          _buildDivider(colors),
          _buildActionItem(
            context,
            icon: Icons.smart_toy_outlined,
            iconColor: colors.primary,
            title: context.tr(AppStrings.demoTestingTools),
            subtitle: context.tr(AppStrings.demoMode),
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.demoTools),
          ),
          _buildDivider(colors),
          _buildActionItem(
            context,
            icon: Icons.shield_outlined,
            iconColor: Colors.blueGrey,
            title: context.tr(AppStrings.profilePrivacyPolicy),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.tr(AppStrings.profilePrivacyPolicy)),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(dynamic colors) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Divider(
        height: 1,
        thickness: 0.7,
        color: colors.divider.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    final colors = context.customColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: iconColor, size: 20.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge(
                      context,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: AppTextStyles.caption(
                        context,
                      ).copyWith(fontSize: 11.sp),
                    ),
                  ],
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
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    final colors = context.customColors;

    return InkWell(
      onTap: () {
        ConfirmationDialog.show(
          context,
          title: context.tr(AppStrings.logout),
          message: context.tr(AppStrings.logoutConfirm),
          isDestructive: true,
          onConfirm: () {
            context.read<AuthCubit>().logout();
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
          },
        );
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: colors.error.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: colors.error.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: colors.error, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              context.tr(AppStrings.logout),
              style: TextStyle(
                color: colors.error,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
