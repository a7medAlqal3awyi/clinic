import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/entities/notification_entity.dart';
import '../cubit/notification_cubit.dart';
import '../cubit/notification_state.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          context.tr(AppStrings.notificationsTitle),
          style: AppTextStyles.headingLarge(context),
        ),
        actions: [
          TextButton(
            onPressed: () => context.read<NotificationCubit>().markAllRead(),
            child: Text(
              context.tr(AppStrings.markAllRead),
              style: TextStyle(color: colors.primary, fontSize: 12.sp),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return StateViews.loading(context);
            } else if (state is NotificationLoaded) {
              final list = state.notifications;
              if (list.isEmpty) {
                return StateViews.empty(
                  context,
                  title: context.tr(AppStrings.noNotifications),
                  icon: Icons.notifications_none_rounded,
                );
              }

              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                itemCount: list.length,
                separatorBuilder: (_, __) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  final notif = list[index];
                  return CustomCard(
                    backgroundColor: notif.isRead ? colors.surface : colors.chipBackground,
                    onTap: () {
                      context.read<NotificationCubit>().markRead(notif.id);
                      if (notif.routeTarget != null) {
                        Navigator.of(context).pushNamed(notif.routeTarget!);
                      }
                    },
                    padding: EdgeInsets.all(14.r),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 18.r,
                          backgroundColor: _typeColor(notif.type, colors).withOpacity(0.15),
                          child: Icon(
                            _typeIcon(notif.type),
                            size: 18.sp,
                            color: _typeColor(notif.type, colors),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    notif.title,
                                    style: AppTextStyles.headingSmall(context).copyWith(
                                      fontWeight: notif.isRead ? FontWeight.w500 : FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${notif.date.hour}:${notif.date.minute.toString().padLeft(2, '0')}',
                                    style: AppTextStyles.caption(context),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                notif.body,
                                style: AppTextStyles.bodyMedium(context),
                              ),
                            ],
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

  IconData _typeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.chatMessage:
        return Icons.chat_bubble_outline;
      case NotificationType.planUpdated:
      case NotificationType.newPlan:
        return Icons.restaurant_menu;
      case NotificationType.progressResult:
        return Icons.insights;
      case NotificationType.subscriptionExpiring:
        return Icons.access_time;
      case NotificationType.paymentApproved:
        return Icons.check_circle_outline;
      case NotificationType.paymentRejected:
        return Icons.cancel_outlined;
      case NotificationType.followupReviewed:
        return Icons.assignment_turned_in_outlined;
    }
  }

  Color _typeColor(NotificationType type, dynamic colors) {
    switch (type) {
      case NotificationType.paymentApproved:
      case NotificationType.followupReviewed:
        return colors.success;
      case NotificationType.paymentRejected:
        return colors.error;
      case NotificationType.subscriptionExpiring:
        return colors.warning;
      default:
        return colors.primary;
    }
  }
}
