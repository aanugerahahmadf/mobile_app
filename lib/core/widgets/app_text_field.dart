import 'package:flutter/material.dart';
import '../constants/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  final String? label;
  final String? errorText;
  final bool obscureText;
  final bool readOnly;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final TextInputType keyboardType;
  final int maxLines;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  const AppTextField({
    super.key,
    this.label,
    this.errorText,
    this.obscureText = false,
    this.readOnly = false,
    this.suffixIcon,
    this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              label!,
              style: AppTextStyles.titleSmall,
            ),
          ),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          readOnly: readOnly,
          validator: readOnly ? null : validator,
          onChanged: readOnly ? null : onChanged,
          keyboardType: keyboardType,
          maxLines: maxLines,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          style: AppTextStyles.bodyLarge,
          decoration: InputDecoration(
            errorText: errorText,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
