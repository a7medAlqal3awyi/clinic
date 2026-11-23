import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'clinic@example.com');
  final _passwordController = TextEditingController(text: '123456');
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = true;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _fillClinicDemo() {
    setState(() {
      _emailController.text = 'clinic@example.com';
      _passwordController.text = '123456';
    });
  }

  void _fillOnlineDemo() {
    setState(() {
      _emailController.text = 'online@example.com';
      _passwordController.text = '123456';
    });
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.mainNavigation);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: colors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: colors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.local_hospital_rounded,
                          size: 38.sp,
                          color: colors.primary,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Center(
                      child: Text(
                        context.tr(AppStrings.loginTitle),
                        style: AppTextStyles.displayLarge(context),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Center(
                      child: Text(
                        context.tr(AppStrings.loginSubtitle),
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium(context),
                      ),
                    ),
                    SizedBox(height: 28.h),

                    // Quick Demo Switcher Card
                    CustomCard(
                      backgroundColor: colors.chipBackground,
                      padding: EdgeInsets.all(12.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info_outline, size: 16.sp, color: colors.primary),
                              SizedBox(width: 6.w),
                              Text(
                                context.tr(AppStrings.demoAccountsNotice),
                                style: AppTextStyles.caption(context).copyWith(
                                  color: colors.primaryDark,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: _fillClinicDemo,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8.h),
                                    decoration: BoxDecoration(
                                      color: colors.surface,
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(color: colors.primary.withOpacity(0.3)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        context.tr(AppStrings.loginAsClinic),
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w600,
                                          color: colors.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: InkWell(
                                  onTap: _fillOnlineDemo,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8.h),
                                    decoration: BoxDecoration(
                                      color: colors.surface,
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(color: colors.secondary.withOpacity(0.3)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        context.tr(AppStrings.loginAsOnline),
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w600,
                                          color: colors.secondary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),
                    CustomTextField(
                      controller: _emailController,
                      label: context.tr(AppStrings.emailOrPhone),
                      hint: 'clinic@example.com / online@example.com',
                      prefixIcon: Icon(Icons.person_outline, color: colors.primary, size: 20.sp),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return context.tr(AppStrings.requiredField);
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    CustomTextField(
                      controller: _passwordController,
                      label: context.tr(AppStrings.password),
                      hint: '••••••••',
                      obscureText: _obscurePassword,
                      prefixIcon: Icon(Icons.lock_outline, color: colors.primary, size: 20.sp),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: colors.textMuted,
                          size: 20.sp,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return context.tr(AppStrings.passwordTooShort);
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              activeColor: colors.primary,
                              onChanged: (val) {
                                setState(() {
                                  _rememberMe = val ?? true;
                                });
                              },
                            ),
                            Text(
                              context.tr(AppStrings.rememberMe),
                              style: AppTextStyles.bodyMedium(context),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(AppRoutes.forgotPassword);
                          },
                          child: Text(
                            context.tr(AppStrings.forgotPassword),
                            style: AppTextStyles.bodyMedium(context).copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    CustomButton(
                      text: context.tr(AppStrings.login),
                      isLoading: isLoading,
                      onPressed: _submit,
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          context.tr(AppStrings.donotHaveAccount),
                          style: AppTextStyles.bodyMedium(context),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(AppRoutes.register);
                          },
                          child: Text(
                            context.tr(AppStrings.createAccount),
                            style: AppTextStyles.bodyMedium(context).copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
