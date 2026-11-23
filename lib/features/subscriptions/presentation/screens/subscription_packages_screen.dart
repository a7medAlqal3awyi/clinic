import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/entities/subscription_entities.dart';
import '../cubit/subscription_cubit.dart';
import '../cubit/subscription_state.dart';

class SubscriptionPackagesScreen extends StatelessWidget {
  const SubscriptionPackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          context.tr(AppStrings.subscriptionsTitle),
          style: AppTextStyles.headingLarge(context),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
          builder: (context, state) {
            if (state is SubscriptionLoading) {
              return StateViews.loading(context);
            } else if (state is SubscriptionLoaded) {
              final packages = state.packages;
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: colors.chipBackground,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: colors.primary, size: 20.sp),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              context.tr(AppStrings.demoPriceNotice),
                              style: AppTextStyles.caption(context).copyWith(
                                color: colors.primaryDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      context.tr(AppStrings.availablePackages),
                      style: AppTextStyles.headingLarge(context),
                    ),
                    SizedBox(height: 12.h),
                    ...packages.map((pkg) => _buildPackageCard(context, pkg)),
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

  Widget _buildPackageCard(BuildContext context, SubscriptionPackageEntity pkg) {
    final colors = context.customColors;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: CustomCard(
        border: pkg.isPopular ? Border.all(color: colors.primary, width: 2) : null,
        padding: EdgeInsets.all(18.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pkg.name,
                  style: AppTextStyles.headingMedium(context),
                ),
                if (pkg.isPopular)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      context.tr(AppStrings.mostPopular),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 6.h),
            Text(
              pkg.description,
              style: AppTextStyles.bodyMedium(context),
            ),
            SizedBox(height: 12.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '${pkg.price.toInt()} ${pkg.currency}',
                  style: AppTextStyles.displayMedium(context).copyWith(
                    color: colors.primaryDark,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  '/ ${pkg.durationMonths} ${context.tr(AppStrings.perMonth)}',
                  style: AppTextStyles.caption(context),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Divider(color: colors.divider),
            SizedBox(height: 10.h),
            ...pkg.features.map((feat) => Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline_rounded, size: 16.sp, color: colors.success),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          feat,
                          style: AppTextStyles.bodyMedium(context),
                        ),
                      ),
                    ],
                  ),
                )),
            SizedBox(height: 16.h),
            CustomButton(
              text: context.tr(AppStrings.subscribeNow),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.paymentProof,
                  arguments: pkg,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
