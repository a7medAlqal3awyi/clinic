import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../domain/entities/progress_entities.dart';

class InBodyDetailsScreen extends StatelessWidget {
  final InBodyReportEntity report;

  const InBodyDetailsScreen({super.key, required this.report});

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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomCard(
                padding: EdgeInsets.all(18.r),
                child: Column(
                  children: [
                    Text(
                      'Scan Date',
                      style: AppTextStyles.caption(context),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${report.date.day}/${report.date.month}/${report.date.year}',
                      style: AppTextStyles.headingLarge(context).copyWith(
                        color: colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                'Body Composition Breakdown',
                style: AppTextStyles.headingLarge(context),
              ),
              SizedBox(height: 12.h),
              _buildMetricTile(context, 'Weight', '${report.weight} kg', Icons.monitor_weight),
              _buildMetricTile(context, 'Body Fat Percentage', '${report.bodyFatPercentage}%', Icons.pie_chart),
              _buildMetricTile(context, 'Skeletal Muscle Mass', '${report.muscleMassKg} kg', Icons.fitness_center),
              _buildMetricTile(context, 'Body Mass Index (BMI)', '${report.bmi}', Icons.calculate),
              _buildMetricTile(context, 'Visceral Fat Level', 'Level ${report.visceralFatLevel}', Icons.warning_amber),
              _buildMetricTile(context, 'Total Body Water', '${report.bodyWaterKg} kg', Icons.water_drop),
              SizedBox(height: 18.h),
              if (report.notes != null) ...[
                Text(
                  context.tr(AppStrings.specialistNotes),
                  style: AppTextStyles.headingLarge(context),
                ),
                SizedBox(height: 8.h),
                CustomCard(
                  backgroundColor: colors.chipBackground,
                  padding: EdgeInsets.all(16.r),
                  child: Text(
                    report.notes!,
                    style: AppTextStyles.bodyMedium(context).copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricTile(BuildContext context, String title, String val, IconData icon) {
    final colors = context.customColors;
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      child: CustomCard(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 20.sp, color: colors.primary),
                SizedBox(width: 12.w),
                Text(title, style: AppTextStyles.bodyLarge(context)),
              ],
            ),
            Text(
              val,
              style: AppTextStyles.headingSmall(context).copyWith(
                color: colors.primaryDark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
