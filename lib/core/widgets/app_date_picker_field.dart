import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AppDatePickerField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const AppDatePickerField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
  });

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.text.isNotEmpty
          ? DateFormat('yyyy-MM-dd').tryParse(controller.text) ?? now
          : now,
      firstDate: DateTime(1900),
      lastDate: now,
      locale: const Locale('id'),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.titleSmall),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _pickDate(context),
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
      ],
    );
  }
}
