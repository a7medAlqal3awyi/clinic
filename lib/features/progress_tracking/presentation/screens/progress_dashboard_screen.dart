import 'package:fl_chart/fl_chart.dart';
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
import '../../../authentication/domain/entities/user_entity.dart';
import '../../../authentication/domain/entities/user_permissions.dart';
import '../../../authentication/presentation/cubit/auth_cubit.dart';
import '../../../authentication/presentation/cubit/auth_state.dart';
import '../../domain/entities/progress_entities.dart';
import '../cubit/progress_cubit.dart';
import '../cubit/progress_state.dart';

class ProgressDashboardScreen extends StatelessWidget {
  const ProgressDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          context.tr(AppStrings.progressDashboard),
          style: AppTextStyles.headingLarge(context),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colors.primary,
        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.addWeight),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          context.tr(AppStrings.addWeight),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<ProgressCubit, ProgressState>(
          builder: (context, state) {
            if (state is ProgressLoading) {
              return StateViews.loading(context);
            } else if (state is ProgressError) {
              return StateViews.error(
                context,
                message: state.message,
                onRetry: () => context.read<ProgressCubit>().loadProgressData(),
              );
            } else if (state is ProgressLoaded) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWeightSummaryCards(context, state),
                    SizedBox(height: 18.h),
                    _buildWeightChart(context, state.weightHistory),
                    SizedBox(height: 18.h),
                    _buildInBodySection(context, state.inBodyReports),
                    SizedBox(height: 18.h),
                    _buildClinicVisitsSection(context, state.clinicVisits),
                    SizedBox(height: 80.h), // padding for FAB
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

  Widget _buildWeightSummaryCards(BuildContext context, ProgressLoaded state) {
    final colors = context.customColors;
    final current = state.latestWeight?.weight ?? 88.0;
    const starting = 92.0;
    const target = 78.0;
    final diff = current - starting;

    return Row(
      children: [
        Expanded(
          child: CustomCard(
            padding: EdgeInsets.all(12.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr(AppStrings.startingWeight),
                  style: AppTextStyles.caption(context),
                ),
                SizedBox(height: 4.h),
                Text(
                  '$starting kg',
                  style: AppTextStyles.headingMedium(context),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: CustomCard(
            padding: EdgeInsets.all(12.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr(AppStrings.latestWeight),
                  style: AppTextStyles.caption(context),
                ),
                SizedBox(height: 4.h),
                Text(
                  '$current kg',
                  style: AppTextStyles.headingMedium(context).copyWith(
                    color: colors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: CustomCard(
            padding: EdgeInsets.all(12.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr(AppStrings.weightDifference),
                  style: AppTextStyles.caption(context),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${diff > 0 ? '+' : ''}${diff.toStringAsFixed(1)} kg',
                  style: AppTextStyles.headingMedium(context).copyWith(
                    color: diff <= 0 ? colors.success : colors.error,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeightChart(BuildContext context, List<WeightEntryEntity> weights) {
    final colors = context.customColors;
    final reversedWeights = weights.reversed.toList();

    return CustomCard(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weight Trend Over Time',
                style: AppTextStyles.headingMedium(context),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed(AppRoutes.weightHistory),
                child: Text(
                  context.tr(AppStrings.viewAll),
                  style: TextStyle(color: colors.primary, fontSize: 12.sp),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 180.h,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (val) => FlLine(
                    color: colors.border,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (val, meta) {
                        final idx = val.toInt();
                        if (idx >= 0 && idx < reversedWeights.length) {
                          final date = reversedWeights[idx].date;
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              '${date.day}/${date.month}',
                              style: TextStyle(fontSize: 10.sp, color: colors.textMuted),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: reversedWeights.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value.weight);
                    }).toList(),
                    isCurved: true,
                    color: colors.primary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                        radius: 4,
                        color: colors.primary,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: colors.primary.withOpacity(0.12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInBodySection(
    BuildContext context,
    List<InBodyReportEntity> reports,
  ) {
    final colors = context.customColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.tr(AppStrings.inbodyTitle),
              style: AppTextStyles.headingMedium(context),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.inbodyReports),
              child: Text(
                context.tr(AppStrings.viewAll),
                style: TextStyle(color: colors.primary, fontSize: 12.sp),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        if (reports.isEmpty)
          CustomCard(
            padding: EdgeInsets.all(16.r),
            child: Center(
              child: Text(
                'No InBody scans recorded yet',
                style: AppTextStyles.bodyMedium(context),
              ),
            ),
          )
        else
          CustomCard(
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoutes.inbodyDetails,
                arguments: reports.first,
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
                      'Latest Scan: ${reports.first.date.day}/${reports.first.date.month}/${reports.first.date.year}',
                      style: AppTextStyles.headingSmall(context),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 14.sp, color: colors.textMuted),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildBiometricPill(
                      context,
                      label: context.tr(AppStrings.bodyFatPercentage),
                      value: '${reports.first.bodyFatPercentage}%',
                    ),
                    _buildBiometricPill(
                      context,
                      label: context.tr(AppStrings.muscleMass),
                      value: '${reports.first.muscleMassKg} kg',
                    ),
                    _buildBiometricPill(
                      context,
                      label: context.tr(AppStrings.bmi),
                      value: '${reports.first.bmi}',
                    ),
                    _buildBiometricPill(
                      context,
                      label: context.tr(AppStrings.visceralFat),
                      value: 'Lvl ${reports.first.visceralFatLevel}',
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildBiometricPill(BuildContext context, {required String label, required String value}) {
    final colors = context.customColors;
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: colors.primaryDark,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(fontSize: 10.sp, color: colors.textMuted),
        ),
      ],
    );
  }

  Widget _buildClinicVisitsSection(
    BuildContext context,
    List<ClinicVisitEntity> visits,
  ) {
    final colors = context.customColors;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isClinic = state is AuthAuthenticated && state.user.customerType == CustomerType.clinic;
        if (!isClinic) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.tr(AppStrings.visitHistory),
                  style: AppTextStyles.headingMedium(context),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pushNamed(AppRoutes.visitHistory),
                  child: Text(
                    context.tr(AppStrings.viewAll),
                    style: TextStyle(color: colors.primary, fontSize: 12.sp),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            ...visits.take(2).map((visit) => Container(
                  margin: EdgeInsets.only(bottom: 10.h),
                  child: CustomCard(
                    padding: EdgeInsets.all(14.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Visit: ${visit.date.day}/${visit.date.month}/${visit.date.year}',
                              style: AppTextStyles.headingSmall(context),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: colors.primaryLight,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Text(
                                '${visit.weight} kg',
                                style: TextStyle(
                                  color: colors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          visit.specialistNotes,
                          style: AppTextStyles.bodyMedium(context),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        );
      },
    );
  }
}
