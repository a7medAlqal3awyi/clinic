import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class RegisterOnlineScreen extends StatefulWidget {
  const RegisterOnlineScreen({super.key});

  @override
  State<RegisterOnlineScreen> createState() => _RegisterOnlineScreenState();
}

class _RegisterOnlineScreenState extends State<RegisterOnlineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController(text: '26');
  final _heightController = TextEditingController(text: '172');
  final _weightController = TextEditingController(text: '82');
  final _targetWeightController = TextEditingController(text: '72');

  String _gender = 'female';
  String _mainGoal = 'Weight Loss & Fat Reduction';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().registerOnline(
            fullName: _nameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            password: _passwordController.text.trim(),
            gender: _gender,
            age: int.tryParse(_ageController.text.trim()) ?? 25,
            height: double.tryParse(_heightController.text.trim()) ?? 170.0,
            currentWeight: double.tryParse(_weightController.text.trim()) ?? 80.0,
            targetWeight: double.tryParse(_targetWeightController.text.trim()) ?? 70.0,
            mainGoal: _mainGoal,
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
          context.tr(AppStrings.registerTitle),
          style: AppTextStyles.headingLarge(context),
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.mainNavigation,
              (route) => false,
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: colors.error),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr(AppStrings.registerSubtitle),
                      style: AppTextStyles.bodyMedium(context),
                    ),
                    SizedBox(height: 20.h),
                    CustomTextField(
                      controller: _nameController,
                      label: context.tr(AppStrings.fullName),
                      hint: 'Sarah Ibrahim',
                      prefixIcon: Icon(Icons.person_outline, color: colors.primary, size: 20.sp),
                      validator: (val) => val == null || val.isEmpty ? context.tr(AppStrings.requiredField) : null,
                    ),
                    SizedBox(height: 14.h),
                    CustomTextField(
                      controller: _emailController,
                      label: context.tr(AppStrings.email),
                      hint: 'sarah@example.com',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icon(Icons.email_outlined, color: colors.primary, size: 20.sp),
                      validator: (val) => val == null || !val.contains('@') ? context.tr(AppStrings.invalidEmail) : null,
                    ),
                    SizedBox(height: 14.h),
                    CustomTextField(
                      controller: _phoneController,
                      label: context.tr(AppStrings.phone),
                      hint: '01012345678',
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icon(Icons.phone_outlined, color: colors.primary, size: 20.sp),
                      validator: (val) => val == null || val.isEmpty ? context.tr(AppStrings.requiredField) : null,
                    ),
                    SizedBox(height: 14.h),
                    CustomTextField(
                      controller: _passwordController,
                      label: context.tr(AppStrings.password),
                      hint: '••••••••',
                      obscureText: true,
                      prefixIcon: Icon(Icons.lock_outline, color: colors.primary, size: 20.sp),
                      validator: (val) => val == null || val.length < 6 ? context.tr(AppStrings.passwordTooShort) : null,
                    ),
                    SizedBox(height: 18.h),

                    // Gender Selector
                    Text(
                      context.tr(AppStrings.gender),
                      style: AppTextStyles.headingSmall(context).copyWith(color: colors.textSecondary),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: Center(child: Text(context.tr(AppStrings.male))),
                            selected: _gender == 'male',
                            onSelected: (val) => setState(() => _gender = 'male'),
                            selectedColor: colors.primaryLight,
                            labelStyle: TextStyle(
                              color: _gender == 'male' ? colors.primary : colors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: ChoiceChip(
                            label: Center(child: Text(context.tr(AppStrings.female))),
                            selected: _gender == 'female',
                            onSelected: (val) => setState(() => _gender = 'female'),
                            selectedColor: colors.primaryLight,
                            labelStyle: TextStyle(
                              color: _gender == 'female' ? colors.primary : colors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),

                    // Biometrics Grid
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _ageController,
                            label: context.tr(AppStrings.age),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: CustomTextField(
                            controller: _heightController,
                            label: context.tr(AppStrings.height),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _weightController,
                            label: context.tr(AppStrings.currentWeight),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: CustomTextField(
                            controller: _targetWeightController,
                            label: context.tr(AppStrings.targetWeight),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),

                    // Main Goal
                    Text(
                      context.tr(AppStrings.mainGoal),
                      style: AppTextStyles.headingSmall(context).copyWith(color: colors.textSecondary),
                    ),
                    SizedBox(height: 8.h),
                    DropdownButtonFormField<String>(
                      value: _mainGoal,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: colors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.r),
                          borderSide: BorderSide(color: colors.border),
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'Weight Loss & Fat Reduction',
                          child: Text(context.tr(AppStrings.goalWeightLoss)),
                        ),
                        DropdownMenuItem(
                          value: 'Muscle Building & Lean Bulk',
                          child: Text(context.tr(AppStrings.goalMuscleGain)),
                        ),
                        DropdownMenuItem(
                          value: 'Maintain Weight & Fitness',
                          child: Text(context.tr(AppStrings.goalMaintain)),
                        ),
                        DropdownMenuItem(
                          value: 'Healthy Lifestyle & Wellbeing',
                          child: Text(context.tr(AppStrings.goalHealthyLifestyle)),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _mainGoal = val);
                      },
                    ),
                    SizedBox(height: 28.h),
                    CustomButton(
                      text: context.tr(AppStrings.createAccount),
                      isLoading: isLoading,
                      onPressed: _submit,
                    ),
                    SizedBox(height: 16.h),
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
