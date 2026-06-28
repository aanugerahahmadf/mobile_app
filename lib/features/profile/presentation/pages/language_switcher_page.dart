import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';

class LanguageSwitcherPage extends StatelessWidget {
  const LanguageSwitcherPage({super.key});

  static const _languages = [
    ('id', 'Bahasa Indonesia'),
    ('en', 'English'),
    ('ms', 'Bahasa Melayu'),
    ('zh', '中文'),
    ('ar', 'العربية'),
    ('ja', '日本語'),
    ('ko', '한국어'),
    ('th', 'ไทย'),
    ('vi', 'Tiếng Việt'),
    ('es', 'Español'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Bahasa')),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSizes.md),
        itemCount: _languages.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final name = _languages[i].$2;
          return ListTile(
            leading: const Icon(
              Icons.check,
              color: AppColors.primaryColor,
            ),
            title: Text(name, style: AppTextStyles.bodyMedium),
          );
        },
      ),
    );
  }
}
