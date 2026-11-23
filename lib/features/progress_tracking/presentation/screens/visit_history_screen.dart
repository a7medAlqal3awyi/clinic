import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/state_views.dart';
import '../cubit/progress_cubit.dart';
import '../cubit/progress_state.dart';

class VisitHistoryScreen extends StatelessWidget {
  const VisitHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          context.tr(AppStrings.visitHistory),
          style: AppTextStyles.headingLarge(context),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<ProgressCubit, ProgressState>(
          builder: (context, state) {
            if (state is ProgressLoading) {
              return StateViews.loading(context);
            } else if (state is ProgressLoaded) {
              final visits = state.clinicVisits;
              if (visits.isEmpty) {
                return StateViews.empty(
                  context,
                  title: 'No In-Clinic Visits Recorded',
                  icon: Icons.event_note,
                );
              }

              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
                itemCount: visits.length,
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final visit = visits[index];
                  return CustomCard(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Date: ${visit.date.day}/${visit.date.month}/${visit.date.year}',
                              style: AppTextStyles.headingMedium(context),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: colors.primaryLight,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                '${visit.weight} kg',
                                style: TextStyle(
                                  color: colors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          '${context.tr(AppStrings.visitNotes)}:',
                          style: AppTextStyles.headingSmall(context).copyWith(
                            fontSize: 12.sp,
                            color: colors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          visit.specialistNotes,
                          style: AppTextStyles.bodyMedium(context),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Recommendations:',
                          style: AppTextStyles.headingSmall(context).copyWith(
                            fontSize: 12.sp,
                            color: colors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          visit.recommendations,
                          style: AppTextStyles.bodyMedium(context).copyWith(
                            color: colors.primaryDark,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
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
}
