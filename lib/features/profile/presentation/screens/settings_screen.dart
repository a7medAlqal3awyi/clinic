import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_card.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          context.tr(AppStrings.settings),
          style: AppTextStyles.headingLarge(context),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final settings = (state is ProfileLoaded) ? state.settings : null;
            final isArabic = settings?.locale.languageCode == 'ar';

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
              child: Column(
                children: [
                  CustomCard(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr(AppStrings.language),
                          style: AppTextStyles.headingSmall(context),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: ChoiceChip(
                                label: Center(child: Text(context.tr(AppStrings.arabic))),
                                selected: isArabic,
                                onSelected: (_) {
                                  context.read<ProfileCubit>().changeLanguage(const Locale('ar'));
                                },
                                selectedColor: colors.primaryLight,
                                labelStyle: TextStyle(
                                  color: isArabic ? colors.primary : colors.textSecondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: ChoiceChip(
                                label: Center(child: Text(context.tr(AppStrings.english))),
                                selected: !isArabic,
                                onSelected: (_) {
                                  context.read<ProfileCubit>().changeLanguage(const Locale('en'));
                                },
                                selectedColor: colors.primaryLight,
                                labelStyle: TextStyle(
                                  color: !isArabic ? colors.primary : colors.textSecondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 14.h),
                  CustomCard(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.tr(AppStrings.notificationsEnabled),
                          style: AppTextStyles.bodyLarge(context),
                        ),
                        Switch(
                          value: settings?.notificationsEnabled ?? true,
                          activeColor: colors.primary,
                          onChanged: (val) {
                            context.read<ProfileCubit>().toggleNotifications(val);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    context.tr(AppStrings.version),
                    style: AppTextStyles.caption(context),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
