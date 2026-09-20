import 'package:flutter/material.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../constants/app_text_styles/app_text_styles.dart';
import '../app_date_time_picker/app_date_time_picker.dart';

class AppDatePickerField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool readOnly;

  final bool isCheckout;
  final bool isBirthday;

  const AppDatePickerField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.readOnly = false,
    this.isCheckout = false,
    this.isBirthday = true,
  });

  Future<void> _pickDate(BuildContext context) async {
    await showAppDatePickerField(
      context,
      controller,
      isCheckout: isCheckout,
      isBirthday: isBirthday,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: readOnly ? 0.6 : 1.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          Builder(
            builder: (fieldCtx) => GestureDetector(
              onTap: readOnly ? null : () => _pickDate(fieldCtx),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: controller,
                  validator: validator,
                  style: AppTextStyles.bodyLarge,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.calendar_today, size: 18, color: AppColors.textSecondary),
                    errorText: null,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
