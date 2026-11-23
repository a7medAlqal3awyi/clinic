import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _send() {
    if (_emailController.text.trim().isNotEmpty) {
      setState(() => _sent = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr(AppStrings.resetLinkSent)),
          backgroundColor: context.customColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          context.tr(AppStrings.forgotPasswordTitle),
          style: AppTextStyles.headingLarge(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr(AppStrings.forgotPasswordDesc),
                style: AppTextStyles.bodyMedium(context),
              ),
              SizedBox(height: 24.h),
              CustomTextField(
                controller: _emailController,
                label: context.tr(AppStrings.email),
                hint: 'name@example.com',
                prefixIcon: Icon(Icons.email_outlined, color: colors.primary, size: 20.sp),
              ),
              SizedBox(height: 28.h),
              CustomButton(
                text: _sent ? context.tr(AppStrings.resetLinkSent) : context.tr(AppStrings.sendResetLink),
                onPressed: _send,
                backgroundColor: _sent ? colors.success : colors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
