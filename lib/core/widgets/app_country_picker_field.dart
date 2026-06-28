import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_countries.dart';

class AppCountryPickerField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const AppCountryPickerField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.onChanged,
  });

  void _showPicker(BuildContext context) {
    final searchController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            final query = searchController.text.toLowerCase();
            final filtered = query.isEmpty
                ? countries
                : countries.where((c) => c.toLowerCase().contains(query)).toList();
            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.4,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari negara...',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final country = filtered[index];
                          final selected = controller.text == country;
                          return ListTile(
                            title: Text(country, style: AppTextStyles.bodyMedium),
                            trailing: selected
                                ? Icon(Icons.check, color: AppColors.primaryColor, size: 20)
                                : null,
                            onTap: () {
                              controller.text = country;
                              onChanged?.call(country);
                              Navigator.pop(ctx);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.titleSmall),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showPicker(context),
          child: AbsorbPointer(
            child: TextFormField(
              controller: controller,
              validator: validator,
              style: AppTextStyles.bodyLarge,
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                errorText: null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
