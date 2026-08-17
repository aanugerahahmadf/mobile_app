import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/reference/languages.dart';

class LanguagePage extends ConsumerWidget {
  const LanguagePage({super.key});

  static const _languages = supportedLanguages;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);
    final currentCode = currentLocale.languageCode +
        (currentLocale.countryCode != null ? '_${currentLocale.countryCode}' : '');

    return Scaffold(
      appBar: AppBar(title: Text(l.language), backgroundColor: Colors.transparent, elevation: 0),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSizes.md),
        itemCount: _languages.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSizes.sm),
        itemBuilder: (_, i) {
          final code = _languages[i].$1;
          final name = _languages[i].$2;
          final isSelected = code == currentCode;
          return Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isSelected ? AppColors.primaryColor : AppColors.textSecondary,
              ),
              title: Text(name, style: AppTextStyles.bodyMedium),
              trailing: isSelected
                  ? Icon(Icons.check, color: AppColors.primaryColor)
                  : null,
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(code);
                Navigator.pop(context);
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        },
      ),
    );
  }
}
