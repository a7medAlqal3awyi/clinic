import 'package:file_picker/file_picker.dart';
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
import '../../domain/entities/subscription_entities.dart';
import '../cubit/subscription_cubit.dart';

class PaymentProofSubmissionScreen extends StatefulWidget {
  final SubscriptionPackageEntity package;

  const PaymentProofSubmissionScreen({super.key, required this.package});

  @override
  State<PaymentProofSubmissionScreen> createState() =>
      _PaymentProofSubmissionScreenState();
}

class _PaymentProofSubmissionScreenState
    extends State<PaymentProofSubmissionScreen> {
  final _refController = TextEditingController();
  String? _selectedFilePath;
  String? _selectedFileName;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _refController.dispose();
    super.dispose();
  }

  Future<void> _pickReceipt() async {
    final files = await FilePicker.pickFiles(type: FileType.any);
    if (files.isNotEmpty) {
      setState(() {
        _selectedFilePath = files.first.path ?? 'mock_receipt.jpg';
        _selectedFileName = files.first.name;
      });
    }
  }

  void _submit() {
    if (_selectedFileName == null) {
      // Simulate fallback file for demo convenience if user didn't pick
      _selectedFileName = 'bank_transfer_receipt.jpg';
      _selectedFilePath = '/mock/storage/receipt.jpg';
    }

    setState(() => _isSubmitting = true);
    context.read<SubscriptionCubit>().submitBankTransfer(
          packageId: widget.package.id,
          packageName: widget.package.name,
          amount: widget.package.price,
          receiptPath: _selectedFilePath!,
          bankTransferRef: _refController.text.trim().isEmpty
              ? 'TRX-${DateTime.now().millisecondsSinceEpoch}'
              : _refController.text.trim(),
        );

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _isSubmitting = false);
        Navigator.of(context).pushReplacementNamed(AppRoutes.paymentStatus);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          context.tr(AppStrings.bankTransferInfo),
          style: AppTextStyles.headingMedium(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomCard(
                backgroundColor: colors.chipBackground,
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.package.name,
                      style: AppTextStyles.headingMedium(context).copyWith(
                        color: colors.primaryDark,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Total Amount: ${widget.package.price.toInt()} ${widget.package.currency}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h),

              // Bank Transfer Details
              Text(
                context.tr(AppStrings.bankTransferInfo),
                style: AppTextStyles.headingMedium(context),
              ),
              SizedBox(height: 10.h),
              CustomCard(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.tr(AppStrings.bankName), style: AppTextStyles.bodyMedium(context)),
                    SizedBox(height: 6.h),
                    Text(context.tr(AppStrings.accountHolder), style: AppTextStyles.bodyMedium(context)),
                    SizedBox(height: 6.h),
                    Text(context.tr(AppStrings.accountNumber), style: AppTextStyles.bodyMedium(context)),
                    SizedBox(height: 6.h),
                    Text(context.tr(AppStrings.iban), style: AppTextStyles.bodyMedium(context)),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // Upload receipt
              Text(
                context.tr(AppStrings.uploadProof),
                style: AppTextStyles.headingMedium(context),
              ),
              SizedBox(height: 10.h),
              InkWell(
                onTap: _pickReceipt,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: colors.primary.withOpacity(0.5), width: 1.5),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.cloud_upload_outlined, size: 36.sp, color: colors.primary),
                      SizedBox(height: 8.h),
                      Text(
                        _selectedFileName ?? 'Tap to select transfer receipt screenshot',
                        style: TextStyle(
                          color: _selectedFileName != null ? colors.primaryDark : colors.textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                controller: _refController,
                label: 'Bank Reference / Transaction ID (Optional)',
                hint: 'e.g. TRX-902348',
              ),
              SizedBox(height: 28.h),
              CustomButton(
                text: context.tr(AppStrings.submitPayment),
                isLoading: _isSubmitting,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
