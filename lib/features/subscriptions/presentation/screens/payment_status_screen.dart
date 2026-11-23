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

class PaymentStatusScreen extends StatelessWidget {
  const PaymentStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          context.tr(AppStrings.paymentStatus),
          style: AppTextStyles.headingLarge(context),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
          builder: (context, state) {
            if (state is SubscriptionLoading) {
              return StateViews.loading(context);
            } else if (state is SubscriptionLoaded) {
              final requests = state.requests;
              if (requests.isEmpty) {
                return StateViews.empty(
                  context,
                  title: 'No pending payment requests',
                  icon: Icons.receipt_long_outlined,
                );
              }

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: colors.chipBackground,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.hourglass_top_rounded, size: 48.sp, color: colors.warning),
                          SizedBox(height: 12.h),
                          Text(
                            context.tr(AppStrings.paymentPendingReview),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.headingMedium(context).copyWith(
                              color: colors.primaryDark,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            context.tr(AppStrings.paymentPendingDesc),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyMedium(context),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Submission Records',
                        style: AppTextStyles.headingMedium(context),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    ...requests.map((r) => Container(
                          margin: EdgeInsets.only(bottom: 12.h),
                          child: CustomCard(
                            padding: EdgeInsets.all(14.r),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(r.packageName, style: AppTextStyles.headingSmall(context)),
                                    SizedBox(height: 2.h),
                                    Text(
                                      '${r.amount.toInt()} EGP • ${r.submittedDate.day}/${r.submittedDate.month}/${r.submittedDate.year}',
                                      style: AppTextStyles.caption(context),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: _statusColor(r.status, colors).withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(color: _statusColor(r.status, colors)),
                                  ),
                                  child: Text(
                                    r.status.name.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                      color: _statusColor(r.status, colors),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                    SizedBox(height: 20.h),
                    CustomButton(
                      text: 'Test Approve in Demo Tools',
                      isOutlined: true,
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoutes.demoTools);
                      },
                    ),
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

  Color _statusColor(PaymentRequestStatus s, dynamic colors) {
    switch (s) {
      case PaymentRequestStatus.approved:
        return colors.success;
      case PaymentRequestStatus.rejected:
        return colors.error;
      default:
        return colors.warning;
    }
  }
}
