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
import '../../domain/entities/progress_entities.dart';
import '../cubit/progress_cubit.dart';
import '../cubit/progress_state.dart';

class InBodyReportsScreen extends StatelessWidget {
  const InBodyReportsScreen({super.key});

  void _showMockUploadDialog(BuildContext context) {
    final colors = context.customColors;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.tr(AppStrings.uploadInbody)),
        content: Text(
          'Simulate uploading a new InBody document/scan for specialist analysis.',
          style: AppTextStyles.bodyMedium(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(context.tr(AppStrings.cancel)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: colors.primary),
            onPressed: () {
              Navigator.of(ctx).pop();
              final newReport = InBodyReportEntity(
                id: 'inbody_${DateTime.now().millisecondsSinceEpoch}',
                date: DateTime.now(),
                weight: 87.2,
                bodyFatPercentage: 23.5,
                muscleMassKg: 37.4,
                bmi: 26.4,
                visceralFatLevel: 8,
                bodyWaterKg: 44.0,
                notes: 'Uploaded by client via demo scanner. Continued healthy reduction in body fat.',
              );
              context.read<ProgressCubit>().recordInBody(newReport);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.tr(AppStrings.success)),
                  backgroundColor: colors.success,
                ),
              );
            },
            child: const Text('Add Demo Scan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          context.tr(AppStrings.inbodyTitle),
          style: AppTextStyles.headingLarge(context),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colors.primary,
        onPressed: () => _showMockUploadDialog(context),
        icon: const Icon(Icons.cloud_upload_outlined, color: Colors.white),
        label: Text(
          context.tr(AppStrings.uploadInbody),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<ProgressCubit, ProgressState>(
          builder: (context, state) {
            if (state is ProgressLoading) {
              return StateViews.loading(context);
            } else if (state is ProgressLoaded) {
              final reports = state.inBodyReports;
              if (reports.isEmpty) {
                return StateViews.empty(
                  context,
                  title: 'No InBody Scans Yet',
                  icon: Icons.pie_chart_outline,
                );
              }

              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
                itemCount: reports.length,
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final report = reports[index];
                  return CustomCard(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.inbodyDetails,
                        arguments: report,
                      );
                    },
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Scan Date: ${report.date.day}/${report.date.month}/${report.date.year}',
                              style: AppTextStyles.headingSmall(context),
                            ),
                            Icon(Icons.arrow_forward_ios_rounded, size: 14.sp, color: colors.textMuted),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildMiniCol(context, 'Weight', '${report.weight} kg'),
                            _buildMiniCol(context, 'Body Fat', '${report.bodyFatPercentage}%'),
                            _buildMiniCol(context, 'Muscle', '${report.muscleMassKg} kg'),
                            _buildMiniCol(context, 'BMI', '${report.bmi}'),
                          ],
                        ),
                        if (report.notes != null) ...[
                          SizedBox(height: 10.h),
                          Divider(color: colors.divider),
                          SizedBox(height: 6.h),
                          Text(
                            report.notes!,
                            style: AppTextStyles.caption(context),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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

  Widget _buildMiniCol(BuildContext context, String title, String val) {
    return Column(
      children: [
        Text(
          val,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: context.customColors.primaryDark,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          title,
          style: TextStyle(fontSize: 10.sp, color: context.customColors.textMuted),
        ),
      ],
    );
  }
}
