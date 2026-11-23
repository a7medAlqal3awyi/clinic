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
import '../../domain/entities/online_followup_entity.dart';
import '../cubit/online_followup_cubit.dart';
import '../cubit/online_followup_state.dart';

class OnlineFollowupScreen extends StatelessWidget {
  const OnlineFollowupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          context.tr(AppStrings.onlineFollowup),
          style: AppTextStyles.headingLarge(context),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colors.primary,
        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.newFollowup),
        icon: const Icon(Icons.add_task_rounded, color: Colors.white),
        label: Text(
          context.tr(AppStrings.newFollowup),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<OnlineFollowupCubit, OnlineFollowupState>(
          builder: (context, state) {
            if (state is OnlineFollowupLoading) {
              return StateViews.loading(context);
            } else if (state is OnlineFollowupLoaded) {
              final history = state.history;
              if (history.isEmpty) {
                return StateViews.empty(
                  context,
                  title: 'No Check-ins Submitted',
                  subtitle: 'Submit biometrics and progress notes to receive customized adjustments.',
                  icon: Icons.assignment_turned_in_outlined,
                );
              }

              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
                itemCount: history.length,
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final item = history[index];
                  return CustomCard(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Submitted: ${item.submissionDate.day}/${item.submissionDate.month}/${item.submissionDate.year}',
                              style: AppTextStyles.headingSmall(context),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: _statusColor(item.status, colors).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(color: _statusColor(item.status, colors)),
                              ),
                              child: Text(
                                _statusText(context, item.status),
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: _statusColor(item.status, colors),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildMiniVal(context, 'Weight', '${item.currentWeight} kg'),
                            _buildMiniVal(context, 'Waist', '${item.waistCm} cm'),
                            _buildMiniVal(context, 'Chest', '${item.chestCm} cm'),
                            _buildMiniVal(context, 'Hips', '${item.hipsCm} cm'),
                          ],
                        ),
                        if (item.notes.isNotEmpty) ...[
                          SizedBox(height: 10.h),
                          Text(
                            'Client Notes: ${item.notes}',
                            style: AppTextStyles.caption(context),
                          ),
                        ],
                        if (item.specialistFeedback != null) ...[
                          SizedBox(height: 10.h),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                              color: colors.chipBackground,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Doctor Feedback:',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.bold,
                                    color: colors.primaryDark,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  item.specialistFeedback!,
                                  style: AppTextStyles.bodyMedium(context),
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
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildMiniVal(BuildContext context, String title, String val) {
    return Column(
      children: [
        Text(val, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 2.h),
        Text(title, style: TextStyle(fontSize: 10.sp, color: context.customColors.textMuted)),
      ],
    );
  }

  String _statusText(BuildContext context, FollowupStatus s) {
    switch (s) {
      case FollowupStatus.underReview:
        return context.tr(AppStrings.statusUnderReview);
      case FollowupStatus.reviewed:
        return context.tr(AppStrings.statusReviewed);
      case FollowupStatus.needInfo:
        return context.tr(AppStrings.statusNeedInfo);
      default:
        return context.tr(AppStrings.statusSubmitted);
    }
  }

  Color _statusColor(FollowupStatus s, dynamic colors) {
    switch (s) {
      case FollowupStatus.reviewed:
        return colors.success;
      case FollowupStatus.needInfo:
        return colors.error;
      case FollowupStatus.underReview:
        return colors.info;
      default:
        return colors.warning;
    }
  }
}
