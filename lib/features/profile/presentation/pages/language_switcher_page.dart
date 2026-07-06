import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/providers/locale_provider.dart';

class LanguageSwitcherPage extends ConsumerWidget {
  const LanguageSwitcherPage({super.key});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);
    final currentCode = currentLocale.languageCode +
        (currentLocale.countryCode != null ? '_${currentLocale.countryCode}' : '');

    return Scaffold(
      appBar: AppBar(title: Text(l.selectLanguage)),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSizes.md),
        itemCount: _languages.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final code = _languages[i].$1;
          final name = _languages[i].$2;
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
        },
      ),
    );
  }
}
