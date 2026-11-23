import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../extensions/context_extension.dart';
import '../localization/app_localizations.dart';
import '../localization/app_strings.dart';
import '../theme/app_text_styles.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmText;
  final String? cancelText;
  final bool isDestructive;
  final VoidCallback onConfirm;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText,
    this.cancelText,
    this.isDestructive = false,
    required this.onConfirm,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    bool isDestructive = false,
    required VoidCallback onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      backgroundColor: colors.surface,
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.headingLarge(context),
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              style: AppTextStyles.bodyMedium(context),
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    cancelText ?? context.tr(AppStrings.cancel),
                    style: TextStyle(color: colors.textSecondary),
                  ),
                ),
                SizedBox(width: 8.w),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDestructive ? colors.error : colors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    confirmText ?? context.tr(AppStrings.confirm),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
