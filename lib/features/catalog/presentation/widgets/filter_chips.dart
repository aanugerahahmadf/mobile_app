import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class FilterChips extends StatelessWidget {
  final List<(String label, String? value)> options;
  final String? selected;
  final ValueChanged<String?> onChanged;

  const FilterChips({super.key, required this.options, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
        itemCount: options.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSizes.sm),
        itemBuilder: (_, i) {
          final (label, value) = options[i];
          final isSelected = selected == value;
          return FilterChip(
            label: Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primaryColor : AppColors.textSecondary,
              ),
            ),
            selected: isSelected,
            onSelected: (_) => onChanged(value),
            selectedColor: AppColors.secondaryColor,
            checkmarkColor: AppColors.primaryColor,
          );
        },
      ),
    );
  }
}
