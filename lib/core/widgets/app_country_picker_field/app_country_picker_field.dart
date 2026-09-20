import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../constants/app_text_styles/app_text_styles.dart';
import '../../utils/country_codes/country_codes.dart';
import '../app_options_picker_sheet/app_options_picker_sheet.dart';

class AppCountryPickerField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool readOnly;

  const AppCountryPickerField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.onChanged,
    this.readOnly = false,
  });

  @override
  State<AppCountryPickerField> createState() => _AppCountryPickerFieldState();
}

class _AppCountryPickerFieldState extends State<AppCountryPickerField> {
  String? _flagFor(String name) {
    for (final c in countryCodes) {
      if (c.name == name) return c.flag;
    }
    return null;
  }

  List<CountryCode> get _uniqueCountries {
    final seen = <String>{};
    return countryCodes.where((c) => seen.add(c.name)).toList();
  }

  String _optionLabel(CountryCode c) => '${c.flag} ${c.name}';

  void _pickCountry() {
    final l = AppLocalizations.of(context);
    showAppOptionsPicker(
      context,
      title: l?.selectCountry ?? 'Select Country',
      options: _uniqueCountries.map(_optionLabel).toList(),
      currentValue: widget.controller.text.isEmpty
          ? ''
          : _optionLabel(_uniqueCountries.firstWhere(
              (c) => c.name == widget.controller.text,
              orElse: () => _uniqueCountries.first,
            )),
      onSelected: (label) {
        final name = label.replaceFirst(RegExp(r'^\S+\s'), '').trim();
        widget.controller.text = name;
        widget.onChanged?.call(name);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final flag = _flagFor(widget.controller.text);
    return Opacity(
      opacity: widget.readOnly ? 0.6 : 1.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label, style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          Builder(
            builder: (fieldCtx) => GestureDetector(
              onTap: widget.readOnly ? null : _pickCountry,
              child: AbsorbPointer(
                child: TextFormField(
                  controller: widget.controller,
                  validator: widget.validator,
                  style: AppTextStyles.bodyLarge,
                  decoration: InputDecoration(
                    prefixIcon: flag != null
                        ? Padding(
                            padding: const EdgeInsets.only(left: 12, right: 8),
                            child: Text(flag, style: const TextStyle(fontSize: 22)),
                          )
                        : null,
                    suffixIcon: Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
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
