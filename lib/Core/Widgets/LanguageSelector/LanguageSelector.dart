import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';
import '../../Constants/AppColors/AppColors.dart';
import '../../Constants/AppTextStyles/AppTextStyles.dart';
import '../../Providers/LocaleProvider/LocaleProvider.dart';
import '../../Reference/Languages/Languages.dart';
import '../AppBottomSheet/AppBottomSheet.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  static const _languages = supportedLanguages;

  void _showPicker(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final currentLocale = ref.read(localeProvider);
    final currentCode = currentLocale.languageCode +
        (currentLocale.countryCode != null ? '_${currentLocale.countryCode}' : '');

    AppBottomSheet.show(
      context,
      _LanguagePickerContent(
        languages: _languages,
        currentCode: currentCode,
        onSelected: (code) {
          ref.read(localeProvider.notifier).setLocale(code);
          Navigator.pop(context);
        },
      ),
      title: l.selectLanguage,
      initial: 0.85,
      max: 0.95,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);
    final currentCode = currentLocale.languageCode +
        (currentLocale.countryCode != null ? '_${currentLocale.countryCode}' : '');
    final currentName = _languages.firstWhere(
      (e) => e.$1 == currentCode,
      orElse: () => ('', currentCode),
    ).$2;

    final flag = localeToFlag(currentCode);

    return ListTile(
      leading: flag != null
          ? Text(flag, style: const TextStyle(fontSize: 28))
          : Icon(Icons.language, color: AppColors.primaryColor),
      title: Text(l.language, style: AppTextStyles.bodyMedium),
      subtitle: Text(
        currentName.isNotEmpty ? currentName : l.indonesian,
        style: AppTextStyles.bodySmall,
      ),
      trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: () => _showPicker(context, ref),
    );
  }
}

class _LanguagePickerContent extends StatefulWidget {
  final List<(String, String)> languages;
  final String currentCode;
  final ValueChanged<String> onSelected;

  const _LanguagePickerContent({
    required this.languages,
    required this.currentCode,
    required this.onSelected,
  });

  @override
  State<_LanguagePickerContent> createState() => _LanguagePickerContentState();
}

class _LanguagePickerContentState extends State<_LanguagePickerContent> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final filtered = widget.languages.where((entry) {
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return entry.$1.toLowerCase().contains(q) || entry.$2.toLowerCase().contains(q);
    }).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: l.search,
            prefixIcon: const Icon(Icons.search, size: 20),
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _query = '');
                    },
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            filled: true,
            fillColor: AppColors.surfaceColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.dividerColor),
            ),
          ),
          onChanged: (val) => setState(() => _query = val),
        ),
        const SizedBox(height: 12),
        ...filtered.map((entry) {
          final code = entry.$1;
          final name = entry.$2;
          final isSelected = code == widget.currentCode;
          final flag = localeToFlag(code);
          return ListTile(
            leading: flag != null
                ? Text(flag, style: const TextStyle(fontSize: 22))
                : Icon(
                    Icons.language,
                    color: isSelected ? AppColors.primaryColor : AppColors.textTertiary,
                    size: 22,
                  ),
            title: Text(name, style: AppTextStyles.bodyMedium),
            subtitle: Text(code, style: AppTextStyles.caption),
            trailing: isSelected
                ? Icon(Icons.check, color: AppColors.primaryColor)
                : null,
            onTap: () => widget.onSelected(code),
          );
        }),
      ],
    );
  }
}
