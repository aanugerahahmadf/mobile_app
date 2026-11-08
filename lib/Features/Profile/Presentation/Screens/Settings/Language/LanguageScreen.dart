import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';
import '../../../../../../Core/Constants/AppColors/AppColors.dart';
import '../../../../../../Core/Constants/AppTextStyles/AppTextStyles.dart';
import '../../../../../../Core/Constants/AppSizes/AppSizes.dart';
import '../../../../../../Core/Providers/LocaleProvider/LocaleProvider.dart';
import '../../../../../../Core/Reference/Languages/Languages.dart';
import '../../../../../../Core/Widgets/AppBreadcrumbs/AppBreadcrumbs.dart';

class LanguageScreen extends ConsumerStatefulWidget {
  const LanguageScreen({super.key});

  @override
  ConsumerState<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends ConsumerState<LanguageScreen> {
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
    final currentLocale = ref.watch(localeProvider);
    final currentCode =
        currentLocale.languageCode +
        (currentLocale.countryCode != null
            ? '_${currentLocale.countryCode}'
            : '');

    final filtered = supportedLanguages.where((entry) {
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return entry.$1.toLowerCase().contains(q) ||
          entry.$2.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l.language),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(38),
          child: const AppBreadcrumbs.global(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.sm, AppSizes.md, AppSizes.sm),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l.search,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
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
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSizes.md),
              itemCount: filtered.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSizes.sm),
              itemBuilder: (_, i) {
                final code = filtered[i].$1;
                final name = filtered[i].$2;
                final isSelected = code == currentCode;
                final flag = localeToFlag(code);

                return Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: flag != null
                        ? Text(flag, style: const TextStyle(fontSize: 24))
                        : Icon(
                            isSelected ? Icons.check_circle : Icons.language,
                            color: isSelected
                                ? AppColors.primaryColor
                                : AppColors.textSecondary,
                          ),
                    title: Text(name, style: AppTextStyles.bodyMedium),
                    subtitle: Text(code, style: AppTextStyles.bodySmall),
                    trailing: isSelected
                        ? Icon(Icons.check_circle, color: AppColors.primaryColor)
                        : null,
                    onTap: () {
                      ref.read(localeProvider.notifier).setLocale(code);
                      Navigator.pop(context);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
