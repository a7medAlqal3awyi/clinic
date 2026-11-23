import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.mainNavigation);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Scaffold(
      backgroundColor: colors.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                color: colors.primaryLight,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: Icon(
                Icons.spa_rounded,
                size: 50.sp,
                color: colors.primary,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              context.tr(AppStrings.appName),
              style: AppTextStyles.displayMedium(context).copyWith(
                color: colors.primaryDark,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'Clinical Nutrition & Diet Management',
              style: AppTextStyles.bodyMedium(context).copyWith(
                color: colors.textMuted,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 48.h),
            SizedBox(
              width: 32.w,
              height: 32.w,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
