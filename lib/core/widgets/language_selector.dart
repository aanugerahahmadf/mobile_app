import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import 'app_bottom_sheet.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

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

  void _showPicker(BuildContext context) {
    AppBottomSheet.show(
      context,
      Column(
        children: _languages.map((lang) {
          final name = lang.$2;
          return ListTile(
            leading: Icon(Icons.check, color: AppColors.primaryColor),
            title: Text(name, style: AppTextStyles.bodyMedium),
            onTap: () => Navigator.pop(context),
          );
        }).toList(),
      ),
      title: 'Pilih Bahasa',
      initial: 0.7,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.language, color: AppColors.primaryColor),
      title: Text('Bahasa', style: AppTextStyles.bodyMedium),
      subtitle: Text('Bahasa Indonesia', style: AppTextStyles.bodySmall),
      trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: () => _showPicker(context),
    );
  }
}
