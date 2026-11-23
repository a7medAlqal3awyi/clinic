import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../authentication/presentation/cubit/auth_cubit.dart';
import '../../../authentication/presentation/cubit/auth_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _ageController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _targetWeightController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthCubit>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;

    _nameController = TextEditingController(text: user?.fullName ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _ageController = TextEditingController(text: '${user?.age ?? 28}');
    _heightController = TextEditingController(text: '${user?.height.toInt() ?? 175}');
    _weightController = TextEditingController(text: '${user?.currentWeight ?? 85}');
    _targetWeightController = TextEditingController(text: '${user?.targetWeight ?? 75}');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  void _save() {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      final updated = authState.user.copyWith(
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        age: int.tryParse(_ageController.text.trim()) ?? authState.user.age,
        height: double.tryParse(_heightController.text.trim()) ?? authState.user.height,
        currentWeight: double.tryParse(_weightController.text.trim()) ?? authState.user.currentWeight,
        targetWeight: double.tryParse(_targetWeightController.text.trim()) ?? authState.user.targetWeight,
      );

      context.read<AuthCubit>().updateProfile(updated);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr(AppStrings.success)),
          backgroundColor: context.customColors.success,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColors.background,
      appBar: AppBar(
        title: Text(
          context.tr(AppStrings.editProfile),
          style: AppTextStyles.headingLarge(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  controller: _nameController,
                  label: context.tr(AppStrings.fullName),
                ),
                SizedBox(height: 14.h),
                CustomTextField(
                  controller: _phoneController,
                  label: context.tr(AppStrings.phone),
                ),
                SizedBox(height: 14.h),
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
                SizedBox(height: 28.h),
                CustomButton(
                  text: context.tr(AppStrings.save),
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
