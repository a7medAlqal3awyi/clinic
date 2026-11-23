import 'package:flutter/material.dart';
import '../../features/authentication/presentation/screens/forgot_password_screen.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/authentication/presentation/screens/register_online_screen.dart';
import '../../features/authentication/presentation/screens/splash_screen.dart';
import '../../features/communication/presentation/screens/chat_details_screen.dart';
import '../../features/communication/presentation/screens/conversations_screen.dart';
import '../../features/demo_tools/presentation/screens/demo_testing_tools_screen.dart';
import '../../features/home/presentation/screens/home_dashboard_screen.dart';
import '../../features/home/presentation/screens/main_navigation_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/nutrition_plan/domain/entities/nutrition_plan_entity.dart';
import '../../features/nutrition_plan/presentation/screens/meal_details_screen.dart';
import '../../features/nutrition_plan/presentation/screens/nutrition_plan_screen.dart';
import '../../features/online_followup/presentation/screens/new_followup_submission_screen.dart';
import '../../features/online_followup/presentation/screens/online_followup_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/progress_tracking/domain/entities/progress_entities.dart';
import '../../features/progress_tracking/presentation/screens/add_weight_screen.dart';
import '../../features/progress_tracking/presentation/screens/inbody_details_screen.dart';
import '../../features/progress_tracking/presentation/screens/inbody_reports_screen.dart';
import '../../features/progress_tracking/presentation/screens/progress_dashboard_screen.dart';
import '../../features/progress_tracking/presentation/screens/visit_history_screen.dart';
import '../../features/progress_tracking/presentation/screens/weight_history_screen.dart';
import '../../features/subscriptions/domain/entities/subscription_entities.dart';
import '../../features/subscriptions/presentation/screens/payment_proof_submission_screen.dart';
import '../../features/subscriptions/presentation/screens/payment_status_screen.dart';
import '../../features/subscriptions/presentation/screens/subscription_packages_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterOnlineScreen());
      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case AppRoutes.mainNavigation:
        return MaterialPageRoute(builder: (_) => const MainNavigationScreen());
      case AppRoutes.mealDetails:
        final meal = settings.arguments as MealEntity;
        return MaterialPageRoute(builder: (_) => MealDetailsScreen(meal: meal));
      case AppRoutes.addWeight:
        return MaterialPageRoute(builder: (_) => const AddWeightScreen());
      case AppRoutes.weightHistory:
        return MaterialPageRoute(builder: (_) => const WeightHistoryScreen());
      case AppRoutes.inbodyReports:
        return MaterialPageRoute(builder: (_) => const InBodyReportsScreen());
      case AppRoutes.inbodyDetails:
        final report = settings.arguments as InBodyReportEntity;
        return MaterialPageRoute(builder: (_) => InBodyDetailsScreen(report: report));
      case AppRoutes.visitHistory:
        return MaterialPageRoute(builder: (_) => const VisitHistoryScreen());
      case AppRoutes.chatDetails:
        return MaterialPageRoute(builder: (_) => const ChatDetailsScreen());
      case AppRoutes.subscriptionPackages:
        return MaterialPageRoute(builder: (_) => const SubscriptionPackagesScreen());
      case AppRoutes.paymentProof:
        final package = settings.arguments as SubscriptionPackageEntity;
        return MaterialPageRoute(builder: (_) => PaymentProofSubmissionScreen(package: package));
      case AppRoutes.paymentStatus:
        return MaterialPageRoute(builder: (_) => const PaymentStatusScreen());
      case AppRoutes.newFollowup:
        return MaterialPageRoute(builder: (_) => const NewFollowupSubmissionScreen());
      case AppRoutes.followupHistory:
        return MaterialPageRoute(builder: (_) => const OnlineFollowupScreen());
      case AppRoutes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case AppRoutes.editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case AppRoutes.demoTools:
        return MaterialPageRoute(builder: (_) => const DemoTestingToolsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
