import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../extensions/context_extension.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Border? border;
  final double? borderRadius;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.border,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final radius = borderRadius ?? 16.r;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.cardBackground,
        borderRadius: BorderRadius.circular(radius),
        border: border ?? Border.all(color: colors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: colors.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: onTap,
          child: Padding(
            padding: padding ?? EdgeInsets.all(16.r),
            child: child,
          ),
        ),
      ),
    );
  }
}
