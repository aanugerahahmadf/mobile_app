import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../providers/locale_provider.dart';
import 'app_bottom_sheet.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  static const _languages = [
    ('id', 'Bahasa Indonesia'),
    ('ms', 'Bahasa Melayu'),
    ('en', 'English'),
    ('en_US', 'English (US)'),
    ('zh', '中文'),
    ('zh_CN', '中文 (简体)'),
    ('zh_TW', '中文 (繁體)'),
    ('ar', 'العربية'),
    ('ja', '日本語'),
    ('ko', '한국어'),
    ('th', 'ไทย'),
    ('vi', 'Tiếng Việt'),
    ('hi', 'हिन्दी'),
    ('bn', 'বাংলা'),
    ('ur', 'اردو'),
    ('fa', 'فارسی'),
    ('pt', 'Português'),
    ('pt_BR', 'Português (Brasil)'),
    ('pt_PT', 'Português (Portugal)'),
    ('es', 'Español'),
    ('fr', 'Français'),
    ('de', 'Deutsch'),
    ('it', 'Italiano'),
    ('nl', 'Nederlands'),
    ('ru', 'Русский'),
    ('tr', 'Türkçe'),
    ('pl', 'Polski'),
    ('uk', 'Українська'),
    ('ro', 'Română'),
    ('cs', 'Čeština'),
    ('hu', 'Magyar'),
    ('el', 'Ελληνικά'),
    ('sv', 'Svenska'),
    ('da', 'Dansk'),
    ('fi', 'Suomi'),
    ('no', 'Norsk'),
    ('fil', 'Filipino'),
    ('my', 'မြန်မာဘာသာ'),
    ('km', 'ភាសាខ្មែរ'),
    ('he', 'עברית'),
    ('sr', 'Српски'),
    ('hr', 'Hrvatski'),
    ('sk', 'Slovenčina'),
    ('bg', 'Български'),
    ('lt', 'Lietuvių'),
    ('lv', 'Latviešu'),
    ('et', 'Eesti'),
    ('sl', 'Slovenščina'),
    ('sq', 'Shqip'),
    ('bs', 'Bosanski'),
    ('hy', 'Հայերեն'),
    ('ka', 'ქართული'),
    ('az', 'Azərbaycan'),
    ('kk', 'Қазақ'),
    ('mn', 'Монгол'),
    ('ne', 'नेपाली'),
    ('tl', 'Tagalog'),
    ('sw', 'Kiswahili'),
    ('am', 'አማርኛ'),
    ('ca', 'Català'),
    ('eu', 'Euskara'),
    ('cy', 'Cymraeg'),
    ('uz', "O'zbek"),
    ('ku', 'Kurdî'),
    ('ckb', 'کوردی'),
    ('zu', 'isiZulu'),
  ];

  void _showPicker(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final currentLocale = ref.read(localeProvider);
    final currentCode = currentLocale.languageCode +
        (currentLocale.countryCode != null ? '_${currentLocale.countryCode}' : '');

    AppBottomSheet.show(
      context,
      Column(
        children: _languages.map((entry) {
          final code = entry.$1;
          final name = entry.$2;
          final isSelected = code == currentCode;
          return ListTile(
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
          );
        }).toList(),
      ),
      title: l.selectLanguage,
      initial: 0.7,
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

    return ListTile(
      leading: Icon(Icons.language, color: AppColors.primaryColor),
      title: Text(l.language, style: AppTextStyles.bodyMedium),
      subtitle: Text(currentName.isNotEmpty ? currentName : l.indonesian,
          style: AppTextStyles.bodySmall),
      trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: () => _showPicker(context, ref),
    );
  }
}
