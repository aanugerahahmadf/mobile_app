import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.dividerColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          hint: Text(hint, style: TextStyle(fontSize: 12, color: AppColors.textTertiary)),
          items: [
            DropdownMenuItem(
              value: null,
              child: Text(hint, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ),
            ...categories.map((c) {
              final name = '${c['name']}'.replaceAll(RegExp(r'^(Paket |Produk )'), '');
              return DropdownMenuItem(
                value: '${c['id']}',
                child: Text(name, style: const TextStyle(fontSize: 12)),
              );
            }),
          ],
          onChanged: onChanged,
          selectedItemBuilder: (context) => [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                hint,
                style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ...categories.map((c) {
              final name = '${c['name']}'.replaceAll(RegExp(r'^(Paket |Produk )'), '');
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  name,
                  style: TextStyle(fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }),
          ],
          icon: Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.textTertiary),
          underline: const SizedBox.shrink(),
          style: TextStyle(fontSize: 12, color: AppColors.textPrimary),
          dropdownColor: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
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
