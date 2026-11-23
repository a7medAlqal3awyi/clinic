import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../extensions/context_extension.dart';
import '../theme/app_text_styles.dart';

class StateViews {
  static Widget loading(BuildContext context, {String? message}) {
    final colors = context.customColors;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
            strokeWidth: 2.5,
          ),
          if (message != null) ...[
            SizedBox(height: 16.h),
            Text(
              message,
              style: AppTextStyles.bodyMedium(context),
            ),
          ],
        ],
      ),
    );
  }

  static Widget empty(
    BuildContext context, {
    required String title,
    String? subtitle,
    IconData icon = Icons.inbox_outlined,
    Widget? action,
  }) {
    final colors = context.customColors;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: colors.primaryLight.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48.sp, color: colors.primary),
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.headingMedium(context),
            ),
            if (subtitle != null) ...[
              SizedBox(height: 8.h),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium(context),
              ),
            ],
            if (action != null) ...[
              SizedBox(height: 20.h),
              action,
            ],
          ],
        ),
      ),
    );
  }

  static Widget error(
    BuildContext context, {
    required String message,
    VoidCallback? onRetry,
    String? retryText,
  }) {
    final colors = context.customColors;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 48.sp, color: colors.error),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge(context).copyWith(
                color: colors.error,
              ),
            ),
            if (onRetry != null) ...[
              SizedBox(height: 16.h),
              ElevatedButton.icon(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                label: Text(
                  retryText ?? 'Retry',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
