import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../core/constants/app_sizes/app_sizes.dart';
import '../../../../../core/widgets/app_shimmer/app_shimmer.dart';
import '../../providers/legal_provider/legal_provider.dart';

class PrivacyPolicyPage extends ConsumerWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final async = ref.watch(privacyPolicyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.privacyPolicy),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: async.when(
        loading: () => const Center(child: AppShimmer(width: 200, height: 16)),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 12),
                Text(
                  l.failedLoadPage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => ref.invalidate(privacyPolicyProvider),
                  icon: const Icon(Icons.refresh, size: 18),
                  label: Text(l.tryAgain),
                ),
              ],
            ),
          ),
        ),
        data: (content) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                content.title,
                style: TextStyle(fontFamily: 'InstrumentSans', 
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              if (content.updatedAt != null) ...[
                const SizedBox(height: 8),
                Text(
                  l.lastUpdatedFormat(content.updatedAt!),
                  style: TextStyle(fontFamily: 'InstrumentSans', 
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              if (content.content is List)
                ...(content.content as List).map<Widget>((section) {
                  final heading = section['heading'] as String?;
                  final body = section['body'] as String?;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (heading != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              heading,
                              style: TextStyle(fontFamily: 'InstrumentSans', 
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        Text(
                          body ?? '',
                          style: TextStyle(fontFamily: 'InstrumentSans', 
                            fontSize: 14,
                            height: 1.6,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                })
              else
                Text(
                  content.content is String
                      ? content.content as String
                      : (content.content is Map
                            ? (content.content?['text'] as String? ??
                                  (content.content?['content'] as String? ??
                                      ''))
                            : ''),
                  style: TextStyle(fontFamily: 'InstrumentSans', 
                    fontSize: 14,
                    height: 1.6,
                    color: AppColors.textPrimary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
