import 'package:flutter/material.dart';
import '../../constants/app_colors/app_colors.dart';
import '../app_options_picker_sheet/app_options_picker_sheet.dart';

class StyledCategoryDropdown extends StatelessWidget {
  final String? value;
  final String hint;
  final List<Map<String, dynamic>> categories;
  final ValueChanged<String?> onChanged;

  const StyledCategoryDropdown({
    super.key,
    this.value,
    required this.hint,
    required this.categories,
    required this.onChanged,
  });

  String _name(Map<String, dynamic> c) =>
      '${c['name']}'.replaceAll(RegExp(r'^(Paket |Produk )'), '');

  @override
  Widget build(BuildContext context) {
    final selected = categories.where((c) => '${c['id']}' == value).firstOrNull;
    final selectedName = selected == null ? null : _name(selected);
    return GestureDetector(
      onTap: () {
        showAppOptionsPicker(
          context,
          title: hint,
          options: [
            hint,
            ...categories.map((c) => _name(c)),
          ],
          currentValue: selectedName ?? '',
          onSelected: (v) {
            if (v == hint) {
              onChanged(null);
            } else {
              final match = categories
                  .where((c) => _name(c) == v)
                  .firstOrNull;
              onChanged(match == null ? null : '${match['id']}');
            }
          },
        );
      },
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.dividerColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                selectedName ?? hint,
                style: TextStyle(
                  fontSize: 12,
                  color: selectedName == null
                      ? AppColors.textTertiary
                      : AppColors.textPrimary,
                  fontWeight: selectedName == null
                      ? FontWeight.normal
                      : FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

class StyledChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;
  final IconData? icon;

  const StyledChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 26,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryColor : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? AppColors.primaryColor : AppColors.dividerColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 13, color: selected ? Colors.white : AppColors.textSecondary),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                color: selected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StyledSortChips extends StatelessWidget {
  final List<(String, String?)> options;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const StyledSortChips({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final (label, value) = options[i];
          final selected = selectedValue == value;
          return StyledChoiceChip(
            label: label,
            selected: selected,
            onSelected: () => onChanged(value),
          );
        },
      ),
    );
  }
}
