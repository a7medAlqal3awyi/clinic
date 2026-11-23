import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../authentication/presentation/cubit/auth_cubit.dart';
import '../../../authentication/presentation/cubit/auth_state.dart';
import '../cubit/communication_cubit.dart';
import '../cubit/communication_state.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          context.tr(AppStrings.communicationTitle),
          style: AppTextStyles.headingLarge(context),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            final user = authState is AuthAuthenticated ? authState.user : null;
            final canChat = user?.permissions.canChatWithSpecialist ?? false;

            if (!canChat) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_outline_rounded, size: 48.sp, color: colors.warning),
                      SizedBox(height: 16.h),
                      Text(
                        'Direct Specialist Messaging Locked',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.headingMedium(context),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Direct chat with our clinical nutritionists is available for Clinic and Premium/VIP subscribers.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium(context),
                      ),
                      SizedBox(height: 20.h),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed(AppRoutes.subscriptionPackages);
                        },
                        child: Text(
                          context.tr(AppStrings.renewSubscription),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                children: [
                  CustomCard(
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.chatDetails);
                    },
                    padding: EdgeInsets.all(14.r),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 26.r,
                              backgroundColor: colors.primaryLight,
                              child: Icon(Icons.person, size: 30.sp, color: colors.primary),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 12.w,
                                height: 12.w,
                                decoration: BoxDecoration(
                                  color: colors.success,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.tr(AppStrings.nutritionSpecialist),
                                style: AppTextStyles.headingSmall(context),
                              ),
                              SizedBox(height: 4.h),
                              BlocBuilder<CommunicationCubit, CommunicationState>(
                                builder: (context, state) {
                                  String preview = 'Tap to chat with your doctor';
                                  if (state is CommunicationLoaded && state.messages.isNotEmpty) {
                                    preview = state.messages.last.text;
                                  }
                                  return Text(
                                    preview,
                                    style: AppTextStyles.bodySmall(context),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14.sp,
                          color: colors.textMuted,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
