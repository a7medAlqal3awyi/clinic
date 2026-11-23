import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../cubit/progress_cubit.dart';

class AddWeightScreen extends StatefulWidget {
  const AddWeightScreen({super.key});

  @override
  State<AddWeightScreen> createState() => _AddWeightScreenState();
}

class _AddWeightScreenState extends State<AddWeightScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController(text: '87.5');
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final weight = double.tryParse(_weightController.text.trim()) ?? 80.0;
      context.read<ProgressCubit>().recordWeight(
            weight,
            _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
          );
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
    final colors = context.customColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          context.tr(AppStrings.addWeight),
          style: AppTextStyles.headingLarge(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  controller: _weightController,
                  label: '${context.tr(AppStrings.currentWeight)} (kg)',
                  hint: '87.5',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  prefixIcon: Icon(Icons.scale, color: colors.primary, size: 20.sp),
                  validator: (val) {
                    if (val == null || double.tryParse(val.trim()) == null) {
                      return context.tr(AppStrings.requiredField);
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  controller: _notesController,
                  label: 'Notes / Context (Morning, fasted, workout)',
                  hint: 'Weighed on empty stomach before breakfast...',
                  maxLines: 3,
                ),
                SizedBox(height: 28.h),
                CustomButton(
                  text: context.tr(AppStrings.save),
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
