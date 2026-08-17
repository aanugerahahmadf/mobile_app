import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../utils/country_codes.dart';

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
  OverlayEntry? _dropdownOverlay;

  @override
  void dispose() {
    _removeDropdown();
    super.dispose();
  }

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

  void _showDropdown(BuildContext fieldContext) {
    _removeDropdown();
    final overlay = Overlay.of(fieldContext);
    final renderBox = fieldContext.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    final searchController = TextEditingController();
    final all = _uniqueCountries;

    _dropdownOverlay = OverlayEntry(
      builder: (ctx) {
        return StatefulBuilder(
          builder: (_, setDropdownState) {
            final query = searchController.text.toLowerCase();
            final filtered = query.isEmpty
                ? all
                : all.where((c) => c.name.toLowerCase().contains(query)).toList();
            return GestureDetector(
              onTap: () {},
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: _removeDropdown,
                    child: Container(color: Colors.transparent),
                  ),
                  Positioned(
                    top: position.dy + size.height + 4,
                    left: position.dx,
                    width: size.width,
                    child: Material(
                      elevation: 8,
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.surfaceColor,
                      surfaceTintColor: AppColors.surfaceColor,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 280),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: TextField(
                                controller: searchController,
                                decoration: InputDecoration(
                                  hintText: AppLocalizations.of(ctx)!.searchCountry,
                                  prefixIcon: const Icon(Icons.search, size: 20),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                                ),
                                onChanged: (_) => setDropdownState(() {}),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Flexible(
                              child: ListView(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                children: filtered.map((c) => ListTile(
                                  dense: true,
                                  leading: Text(c.flag, style: const TextStyle(fontSize: 20)),
                                  title: Text(c.name, style: AppTextStyles.bodyMedium),
                                  trailing: widget.controller.text == c.name
                                      ? Icon(Icons.check, color: AppColors.primaryColor, size: 20)
                                      : null,
                                  onTap: () {
                                    widget.controller.text = c.name;
                                    widget.onChanged?.call(c.name);
                                    _removeDropdown();
                                  },
                                )).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    overlay.insert(_dropdownOverlay!);
  }

  void _removeDropdown() {
    _dropdownOverlay?.remove();
    _dropdownOverlay = null;
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
              onTap: widget.readOnly ? null : () => _showDropdown(fieldCtx),
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
