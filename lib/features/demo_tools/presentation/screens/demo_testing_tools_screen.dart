import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../authentication/data/datasource/auth_local_data_source.dart';
import '../../../authentication/presentation/cubit/auth_cubit.dart';
import '../../../communication/domain/entities/chat_message_entity.dart';
import '../../../communication/presentation/cubit/communication_cubit.dart';
import '../../../notifications/data/datasource/notification_local_data_source.dart';
import '../../../notifications/domain/entities/notification_entity.dart';
import '../../../notifications/presentation/cubit/notification_cubit.dart';
import '../../../nutrition_plan/data/datasource/nutrition_plan_local_data_source.dart';
import '../../../nutrition_plan/domain/entities/nutrition_plan_entity.dart';
import '../../../nutrition_plan/presentation/cubit/nutrition_plan_cubit.dart';
import '../../../online_followup/data/datasource/online_followup_local_data_source.dart';
import '../../../online_followup/domain/entities/online_followup_entity.dart';
import '../../../online_followup/presentation/cubit/online_followup_cubit.dart';
import '../../../subscriptions/data/datasource/subscription_local_data_source.dart';
import '../../../subscriptions/domain/entities/subscription_entities.dart';
import '../../../subscriptions/presentation/cubit/subscription_cubit.dart';

class DemoTestingToolsScreen extends StatelessWidget {
  const DemoTestingToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          context.tr(AppStrings.demoTestingTools),
          style: AppTextStyles.headingLarge(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: colors.error.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: colors.error.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: colors.error, size: 22.sp),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        'DEMO / TEST ONLY: These actions simulate backend administration responses without an actual server.',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: colors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h),

              Text('Subscription Admin Simulation', style: AppTextStyles.headingMedium(context)),
              SizedBox(height: 10.h),
              _buildActionTile(
                context,
                title: 'Approve Pending Bank Transfer',
                subtitle: 'Approves newest payment request and activates user subscription for 90 days.',
                icon: Icons.check_circle_outline,
                color: colors.success,
                onTap: () async {
                  final subDs = sl<SubscriptionLocalDataSource>();
                  final authDs = sl<AuthLocalDataSource>();
                  final reqs = await subDs.getPaymentHistory();
                  if (reqs.isNotEmpty) {
                    await subDs.updatePaymentStatus(reqs.first.id, PaymentRequestStatus.approved, null);
                  }
                  await authDs.updateDemoSubscription(
                    status: 'active',
                    packageName: 'Premium Online Nutrition',
                    tier: 'premium',
                    durationDays: 90,
                  );
                  context.read<AuthCubit>().reloadUser();
                  context.read<SubscriptionCubit>().loadPackagesAndHistory();

                  // Create Notification
                  final notifDs = sl<NotificationLocalDataSource>();
                  await notifDs.addNotification(NotificationEntity(
                    id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
                    title: 'Payment Approved!',
                    body: 'Your bank transfer was verified by clinic staff. Subscription activated.',
                    type: NotificationType.paymentApproved,
                    date: DateTime.now(),
                    routeTarget: '/subscriptions',
                  ));
                  context.read<NotificationCubit>().loadNotifications();

                  _showSnackBar(context, 'Payment Approved & Subscription Activated!');
                },
              ),
              SizedBox(height: 10.h),
              _buildActionTile(
                context,
                title: 'Reject Pending Bank Transfer',
                subtitle: 'Rejects payment request due to invalid receipt.',
                icon: Icons.cancel_outlined,
                color: colors.error,
                onTap: () async {
                  final subDs = sl<SubscriptionLocalDataSource>();
                  final reqs = await subDs.getPaymentHistory();
                  if (reqs.isNotEmpty) {
                    await subDs.updatePaymentStatus(
                      reqs.first.id,
                      PaymentRequestStatus.rejected,
                      'Receipt unreadable or account mismatch',
                    );
                  }
                  context.read<SubscriptionCubit>().loadPackagesAndHistory();

                  final notifDs = sl<NotificationLocalDataSource>();
                  await notifDs.addNotification(NotificationEntity(
                    id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
                    title: 'Payment Verification Failed',
                    body: 'Your bank transfer slip could not be verified. Please re-upload.',
                    type: NotificationType.paymentRejected,
                    date: DateTime.now(),
                    routeTarget: '/payment-status',
                  ));
                  context.read<NotificationCubit>().loadNotifications();

                  _showSnackBar(context, 'Payment request marked as rejected.');
                },
              ),
              SizedBox(height: 10.h),
              _buildActionTile(
                context,
                title: 'Simulate Subscription Expiration',
                subtitle: 'Forces subscription status to expired for testing locked features.',
                icon: Icons.timer_off_outlined,
                color: colors.warning,
                onTap: () async {
                  final authDs = sl<AuthLocalDataSource>();
                  await authDs.updateDemoSubscription(status: 'expired');
                  context.read<AuthCubit>().reloadUser();
                  _showSnackBar(context, 'Subscription set to EXPIRED.');
                },
              ),

              SizedBox(height: 20.h),
              Text('Doctor Online Follow-up Actions', style: AppTextStyles.headingMedium(context)),
              SizedBox(height: 10.h),
              _buildActionTile(
                context,
                title: 'Simulate Specialist Reviewing Check-in',
                subtitle: 'Marks latest submission as reviewed and adds doctor feedback notes.',
                icon: Icons.rate_review_outlined,
                color: colors.primary,
                onTap: () async {
                  final folDs = sl<OnlineFollowupLocalDataSource>();
                  final list = await folDs.getFollowups();
                  if (list.isNotEmpty) {
                    await folDs.updateStatus(
                      list.first.id,
                      FollowupStatus.reviewed,
                      'Great progress! Macros updated for next week: reduced carbs by 20g, raised protein.',
                    );
                    context.read<OnlineFollowupCubit>().loadFollowups();

                    final notifDs = sl<NotificationLocalDataSource>();
                    await notifDs.addNotification(NotificationEntity(
                      id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
                      title: 'Follow-up Check-in Reviewed',
                      body: 'Your doctor has reviewed your check-in and left notes.',
                      type: NotificationType.followupReviewed,
                      date: DateTime.now(),
                      routeTarget: '/online-followup',
                    ));
                    context.read<NotificationCubit>().loadNotifications();

                    _showSnackBar(context, 'Check-in reviewed by specialist.');
                  } else {
                    _showSnackBar(context, 'Please submit a check-in first.');
                  }
                },
              ),

              SizedBox(height: 20.h),
              Text('Plan & Messaging Simulation', style: AppTextStyles.headingMedium(context)),
              SizedBox(height: 10.h),
              _buildActionTile(
                context,
                title: 'Assign New Nutrition Protocol',
                subtitle: 'Updates the daily target to 2300 kcal (Lean Bulk Phase).',
                icon: Icons.restaurant_menu_rounded,
                color: const Color(0xFF0EA5E9),
                onTap: () async {
                  final planDs = sl<NutritionPlanLocalDataSource>();
                  final current = await planDs.getPlan();
                  final newPlan = current.copyWith(
                    title: 'Phase 2: Lean Muscle Bulk & Maintenance',
                    dailyCalorieTarget: 2300,
                    proteinTargetGrams: 165,
                    carbsTargetGrams: 240,
                    fatsTargetGrams: 60,
                  );
                  await planDs.savePlan(newPlan);
                  context.read<NutritionPlanCubit>().loadPlan();

                  final notifDs = sl<NotificationLocalDataSource>();
                  await notifDs.addNotification(NotificationEntity(
                    id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
                    title: 'New Nutrition Protocol Assigned',
                    body: 'Phase 2: Lean Muscle Bulk has been assigned to your calendar.',
                    type: NotificationType.newPlan,
                    date: DateTime.now(),
                    routeTarget: '/nutrition-plan',
                  ));
                  context.read<NotificationCubit>().loadNotifications();

                  _showSnackBar(context, 'Phase 2 Nutrition Plan assigned!');
                },
              ),
              SizedBox(height: 10.h),
              _buildActionTile(
                context,
                title: 'Receive Doctor Message in Chat',
                subtitle: 'Simulates doctor sending advice message to user.',
                icon: Icons.forum_outlined,
                color: const Color(0xFF8B5CF6),
                onTap: () async {
                  context.read<CommunicationCubit>().sendMessage(
                        text: 'Hello! I noticed your weight dropped by 0.8kg this week. Fantastic consistency with the hydration goals!',
                        type: MessageType.text,
                      );
                  _showSnackBar(context, 'Simulated doctor response generated!');
                },
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return CustomCard(
      onTap: onTap,
      padding: EdgeInsets.all(14.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundColor: color.withOpacity(0.12),
            child: Icon(icon, color: color, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.headingSmall(context)),
                SizedBox(height: 4.h),
                Text(subtitle, style: AppTextStyles.caption(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: context.customColors.primaryDark,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
