import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../cubit/online_followup_cubit.dart';

class NewFollowupSubmissionScreen extends StatefulWidget {
  const NewFollowupSubmissionScreen({super.key});

  @override
  State<NewFollowupSubmissionScreen> createState() =>
      _NewFollowupSubmissionScreenState();
}

class _NewFollowupSubmissionScreenState
    extends State<NewFollowupSubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController(text: '86.5');
  final _chestController = TextEditingController(text: '102');
  final _waistController = TextEditingController(text: '86');
  final _hipsController = TextEditingController(text: '98');
  final _notesController = TextEditingController();

  List<String> _attachedMedical = ['bloodwork_test_nov.pdf'];
  List<String> _attachedPhotos = ['progress_front_wk3.jpg', 'progress_side_wk3.jpg'];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _weightController.dispose();
    _chestController.dispose();
    _waistController.dispose();
    _hipsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSubmitting = true);
      context.read<OnlineFollowupCubit>().submit(
            currentWeight: double.tryParse(_weightController.text.trim()) ?? 85.0,
            chestCm: double.tryParse(_chestController.text.trim()) ?? 100.0,
            waistCm: double.tryParse(_waistController.text.trim()) ?? 85.0,
            hipsCm: double.tryParse(_hipsController.text.trim()) ?? 95.0,
            notes: _notesController.text.trim(),
            medicalFiles: _attachedMedical,
            progressPhotos: _attachedPhotos,
          );

      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.tr(AppStrings.success)),
              backgroundColor: context.customColors.success,
            ),
          );
          Navigator.of(context).pop();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          context.tr(AppStrings.newFollowup),
          style: AppTextStyles.headingLarge(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  controller: _weightController,
                  label: '${context.tr(AppStrings.currentWeight)} (kg)',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                SizedBox(height: 18.h),

                // Measurements
                Text(
                  context.tr(AppStrings.bodyMeasurements),
                  style: AppTextStyles.headingMedium(context),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _chestController,
                        label: context.tr(AppStrings.chest),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: CustomTextField(
                        controller: _waistController,
                        label: context.tr(AppStrings.waist),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: CustomTextField(
                        controller: _hipsController,
                        label: context.tr(AppStrings.hips),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // Documents & Photos Attachments
                CustomCard(
                  padding: EdgeInsets.all(14.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.attachment, color: colors.primary, size: 20.sp),
                          SizedBox(width: 8.w),
                          Text(
                            'Mock File Attachments Included',
                            style: AppTextStyles.headingSmall(context),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '• ${_attachedMedical.join(", ")}',
                        style: TextStyle(fontSize: 11.sp, color: colors.textSecondary),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '• ${_attachedPhotos.join(", ")}',
                        style: TextStyle(fontSize: 11.sp, color: colors.textSecondary),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18.h),

                CustomTextField(
                  controller: _notesController,
                  label: context.tr(AppStrings.notesForSpecialist),
                  hint: 'Energy levels, sleep quality, cravings...',
                  maxLines: 4,
                ),
                SizedBox(height: 28.h),
                CustomButton(
                  text: context.tr(AppStrings.submit),
                  isLoading: _isSubmitting,
                  onPressed: _submit,
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
