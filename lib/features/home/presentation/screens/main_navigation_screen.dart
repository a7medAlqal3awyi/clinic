import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../communication/presentation/screens/conversations_screen.dart';
import '../../../home/presentation/screens/home_dashboard_screen.dart';
import '../../../nutrition_plan/presentation/screens/nutrition_plan_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../progress_tracking/presentation/screens/progress_dashboard_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeDashboardScreen(),
    NutritionPlanScreen(),
    ProgressDashboardScreen(),
    ConversationsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(top: BorderSide(color: colors.border, width: 0.8)),
          boxShadow: [
            BoxShadow(
              color: colors.cardShadow,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: colors.surface,
          selectedItemColor: colors.primary,
          unselectedItemColor: colors.textMuted,
          selectedLabelStyle: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.normal),
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home_rounded),
              label: context.tr(AppStrings.tabHome),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.restaurant_menu_outlined),
              activeIcon: const Icon(Icons.restaurant_menu_rounded),
              label: context.tr(AppStrings.tabPlan),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.trending_up_rounded),
              activeIcon: const Icon(Icons.insights_rounded),
              label: context.tr(AppStrings.tabProgress),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.chat_outlined),
              activeIcon: const Icon(Icons.chat_rounded),
              label: context.tr(AppStrings.tabMessages),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person_rounded),
              label: context.tr(AppStrings.tabProfile),
            ),
          ],
        ),
      ),
    );
  }
}
