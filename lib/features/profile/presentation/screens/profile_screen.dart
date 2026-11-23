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
import '../../../authentication/presentation/cubit/auth_cubit.dart';
import '../../../authentication/presentation/cubit/auth_state.dart';
import '../../domain/entities/profile_settings_entity.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
          child: Column(
            children: [
              _buildUserCard(context),
              SizedBox(height: 18.h),
              _buildBiometricsSummary(context),
              SizedBox(height: 18.h),
              _buildSettingsList(context),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(BuildContext context) {
    final colors = context.customColors;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;

        return CustomCard(
          padding: EdgeInsets.all(18.r),
          child: Column(
            children: [
              CircleAvatar(
                radius: 36.r,
                backgroundColor: colors.primaryLight,
                child: Icon(Icons.person, size: 40.sp, color: colors.primary),
              ),
              SizedBox(height: 12.h),
              Text(
                user?.fullName ?? 'Demo User',
                style: AppTextStyles.headingLarge(context),
              ),
              SizedBox(height: 4.h),
              Text(
                user?.email ?? 'demo@example.com',
                style: AppTextStyles.bodyMedium(context),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: colors.chipBackground,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  user?.customerType.name.toUpperCase() ?? 'CUSTOMER',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.primaryDark,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBiometricsSummary(BuildContext context) {
    final colors = context.customColors;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;

        return CustomCard(
          padding: EdgeInsets.all(16.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat(context, '${user?.age ?? 28} yrs', context.tr(AppStrings.age)),
              _buildStat(context, '${user?.height.toInt() ?? 175} cm', context.tr(AppStrings.height)),
              _buildStat(context, '${user?.currentWeight ?? 85} kg', context.tr(AppStrings.currentWeight)),
              _buildStat(context, '${user?.targetWeight ?? 75} kg', context.tr(AppStrings.targetWeight)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStat(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.headingSmall(context)),
        SizedBox(height: 2.h),
        Text(label, style: TextStyle(fontSize: 10.sp, color: context.customColors.textMuted)),
      ],
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    final colors = context.customColors;

    return Column(
      children: [
        _buildListTile(
          context,
          icon: Icons.edit_outlined,
          title: context.tr(AppStrings.editProfile),
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.editProfile),
        ),
        SizedBox(height: 10.h),
        _buildListTile(
          context,
          icon: Icons.card_membership_outlined,
          title: context.tr(AppStrings.subscriptionsTitle),
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.subscriptionPackages),
        ),
        SizedBox(height: 10.h),
        _buildListTile(
          context,
          icon: Icons.settings_outlined,
          title: context.tr(AppStrings.settings),
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.settings),
        ),
        SizedBox(height: 10.h),
        _buildListTile(
          context,
          icon: Icons.build_circle_outlined,
          title: context.tr(AppStrings.demoTestingTools),
          color: colors.primary,
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.demoTools),
        ),
        SizedBox(height: 10.h),
        _buildListTile(
          context,
          icon: Icons.logout_rounded,
          title: context.tr(AppStrings.logout),
          color: colors.error,
          onTap: () {
            ConfirmationDialog.show(
              context,
              title: context.tr(AppStrings.logout),
              message: context.tr(AppStrings.logoutConfirm),
              isDestructive: true,
              onConfirm: () {
                context.read<AuthCubit>().logout();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.login,
                  (route) => false,
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    final colors = context.customColors;
    final itemColor = color ?? colors.textPrimary;

    return CustomCard(
      onTap: onTap,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 20.sp, color: itemColor),
              SizedBox(width: 12.w),
              Text(
                title,
                style: AppTextStyles.bodyLarge(context).copyWith(
                  color: itemColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Icon(Icons.arrow_forward_ios_rounded, size: 14.sp, color: colors.textMuted),
        ],
      ),
    );
  }
}
