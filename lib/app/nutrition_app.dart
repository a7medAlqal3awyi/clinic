import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/di/injection_container.dart';
import '../core/localization/app_localizations.dart';
import '../core/routing/app_router.dart';
import '../core/routing/app_routes.dart';
import '../core/theme/app_theme.dart';

// Cubits
import '../features/authentication/presentation/cubit/auth_cubit.dart';
import '../features/communication/presentation/cubit/communication_cubit.dart';
import '../features/notifications/presentation/cubit/notification_cubit.dart';
import '../features/nutrition_plan/presentation/cubit/nutrition_plan_cubit.dart';
import '../features/online_followup/presentation/cubit/online_followup_cubit.dart';
import '../features/profile/presentation/cubit/profile_cubit.dart';
import '../features/profile/presentation/cubit/profile_state.dart';
import '../features/progress_tracking/presentation/cubit/progress_cubit.dart';
import '../features/subscriptions/presentation/cubit/subscription_cubit.dart';

class NutritionApp extends StatelessWidget {
  const NutritionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileCubit>(
          create: (_) => sl<ProfileCubit>()..initSettings(),
        ),
        BlocProvider<AuthCubit>(
          create: (_) => sl<AuthCubit>()..checkAuthStatus(),
        ),
        BlocProvider<NutritionPlanCubit>(
          create: (_) => sl<NutritionPlanCubit>()..loadPlan(),
        ),
        BlocProvider<ProgressCubit>(
          create: (_) => sl<ProgressCubit>()..loadProgressData(),
        ),
        BlocProvider<CommunicationCubit>(
          create: (_) => sl<CommunicationCubit>()..loadMessages(),
        ),
        BlocProvider<SubscriptionCubit>(
          create: (_) => sl<SubscriptionCubit>()..loadPackagesAndHistory(),
        ),
        BlocProvider<OnlineFollowupCubit>(
          create: (_) => sl<OnlineFollowupCubit>()..loadFollowups(),
        ),
        BlocProvider<NotificationCubit>(
          create: (_) => sl<NotificationCubit>()..loadNotifications(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              final locale = state is ProfileLoaded
                  ? state.settings.locale
                  : const Locale('ar');

              return MaterialApp(
                title: 'Nutrition & Diet Clinic',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: ThemeMode.light,
                locale: locale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                initialRoute: AppRoutes.splash,
                onGenerateRoute: AppRouter.generateRoute,
              );
            },
          );
        },
      ),
    );
  }
}
