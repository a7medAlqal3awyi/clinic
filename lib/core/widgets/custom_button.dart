import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../extensions/context_extension.dart';
import '../theme/app_text_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final double? width;
  final double? height;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final btnHeight = height ?? 52.h;
    final btnWidth = width ?? double.infinity;

    if (isOutlined) {
      return SizedBox(
        width: btnWidth,
        height: btnHeight,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: backgroundColor ?? colors.primary, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
          child: isLoading
              ? SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 18.sp, color: textColor ?? colors.primary),
                      SizedBox(width: 8.w),
                    ],
                    Text(
                      text,
                      style: AppTextStyles.button(context).copyWith(
                        color: textColor ?? colors.primary,
                      ),
                    ),
                  ],
                ),
        ),
      );
    }

    return SizedBox(
      width: btnWidth,
      height: btnHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? colors.primary,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          disabledBackgroundColor: colors.border,
        ),
        child: isLoading
            ? SizedBox(
                width: 22.w,
                height: 22.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18.sp, color: textColor ?? Colors.white),
                    SizedBox(width: 8.w),
                  ],
                  Text(
                    text,
                    style: AppTextStyles.button(context).copyWith(
                      color: textColor ?? Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
