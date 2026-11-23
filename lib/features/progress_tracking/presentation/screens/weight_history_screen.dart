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

class WeightHistoryScreen extends StatelessWidget {
  const WeightHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          context.tr(AppStrings.weightHistory),
          style: AppTextStyles.headingLarge(context),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<ProgressCubit, ProgressState>(
          builder: (context, state) {
            if (state is ProgressLoading) {
              return StateViews.loading(context);
            } else if (state is ProgressLoaded) {
              final list = state.weightHistory;
              if (list.isEmpty) {
                return StateViews.empty(
                  context,
                  title: 'No weights logged yet',
                  icon: Icons.scale_outlined,
                );
              }

              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
                itemCount: list.length,
                separatorBuilder: (_, __) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  final item = list[index];
                  final formattedDate =
                      '${item.date.year}-${item.date.month.toString().padLeft(2, '0')}-${item.date.day.toString().padLeft(2, '0')}';

                  return CustomCard(
                    padding: EdgeInsets.all(14.r),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${item.weight} kg',
                              style: AppTextStyles.headingMedium(context).copyWith(
                                color: colors.primary,
                              ),
                            ),
                            if (item.note != null && item.note!.isNotEmpty) ...[
                              SizedBox(height: 4.h),
                              Text(
                                item.note!,
                                style: AppTextStyles.caption(context),
                              ),
                            ],
                          ],
                        ),
                        Text(
                          formattedDate,
                          style: AppTextStyles.bodySmall(context),
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
