import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../core/constants/app_text_styles/app_text_styles.dart';
import '../../../../../core/constants/app_sizes/app_sizes.dart';
import '../../../../../core/errors/localized_error/localized_error.dart';
import '../../../../../core/utils/formatters/formatters.dart';
import '../../../../../core/widgets/guest_auth_prompt/guest_auth_prompt.dart';
import '../../../../auth/presentation/providers/auth_provider/auth_provider.dart';
import '../../../data/models/history_model.dart';
import '../../providers/history_provider.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  String? _activeType;

  @override
  void initState() {
    super.initState();
    if (ref.read(authProvider) is AuthAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(historyProvider.notifier).fetchHistory();
      });
    }
  }

  String _statusLabel(String? status, AppLocalizations l) {
    switch (status) {
      case 'pending':
        return l.pending;
      case 'success':
      case 'completed':
      case 'approved':
      case 'paid':
      case 'confirmed':
        return l.completed;
      case 'failed':
      case 'rejected':
      case 'expired':
        return l.failed;
      case 'cancelled':
        return l.cancelled;
      default:
        return status ?? '-';
    }
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'pending':
        return AppColors.warningColor;
      case 'success':
      case 'completed':
      case 'approved':
      case 'paid':
      case 'confirmed':
        return AppColors.successColor;
      case 'failed':
      case 'rejected':
      case 'expired':
        return AppColors.errorColor;
      case 'cancelled':
        return AppColors.errorColor;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _typeIcon(String? type) {
    switch (type) {
      case 'order':
        return Icons.shopping_bag_outlined;
      default:
        return Icons.history;
    }
  }

  String _typeLabel(String? type, AppLocalizations l) {
    switch (type) {
      case 'order':
        return l.order;
      default:
        return type ?? '-';
    }
  }

  void _showDetail(HistoryModel item) {
    final l = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(l.orderDetail, style: AppTextStyles.titleLarge),
              const SizedBox(height: 20),
              _detailRow(
                l.transactionId,
                '#${item.referenceNumber ?? item.id}',
              ),
              _detailRow(l.type, _typeLabel(item.type, l)),
              _detailRow(l.status, _statusLabel(item.status, l)),
              _detailRow(l.date, Formatters.dateTime(item.createdAt ?? '')),
              const Divider(height: 24),
              _detailRow(
                l.total,
                '- ${Formatters.currency(item.amount.toInt())}',
                valueStyle: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.errorColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Divider(height: 24),
              if (item.info != null && item.info!.isNotEmpty)
                _detailRow(l.description, item.info!),
              if (item.notes != null && item.notes!.isNotEmpty)
                _detailRow(l.notes, item.notes!),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: valueStyle ?? AppTextStyles.bodyMedium),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isAuthenticated = ref.watch(authProvider) is AuthAuthenticated;
    if (!isAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l.history),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: const GuestAuthPrompt(icon: Icons.history),
      );
    }
    final state = ref.watch(historyProvider);
    final notifier = ref.read(historyProvider.notifier);

    final filtered = _activeType == null
        ? state.items
        : state.items.where((i) => i.type == _activeType).toList();

    final types = <String?>[null, 'order'];

    return Scaffold(
      appBar: AppBar(
        title: Text(l.history),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.md,
              AppSizes.sm,
              AppSizes.md,
              0,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.centerLeft,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.sm,
                    ),
                    itemCount: types.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: AppSizes.xs),
                    itemBuilder: (_, i) {
                      final isSelected = _activeType == types[i];
                      final label = types[i] == null ? l.all : l.order;
                      return Center(
                        child: FilterChip(
                          label: Text(
                            label,
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : AppColors.textSecondary,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (_) =>
                              setState(() => _activeType = types[i]),
                          selectedColor: AppColors.secondaryColor,
                          checkmarkColor: AppColors.primaryColor,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Expanded(
            child: state.loading
                ? const Center(child: CircularProgressIndicator())
                : state.error != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.md),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            LocalizedError.of(l, state.error!),
                            style: AppTextStyles.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () => notifier.fetchHistory(),
                            child: Text(l.tryAgain),
                          ),
                        ],
                      ),
                    ),
                  )
                : filtered.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.lg),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.history,
                            size: 64,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l.noData,
                            style: AppTextStyles.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l.noOrdersDesc,
                            style: AppTextStyles.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () => notifier.fetchHistory(),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(AppSizes.md),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final item = filtered[i];
                        final statusColor = _statusColor(item.status);
                        final statusTxt = _statusLabel(item.status, l);

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                          color: Theme.of(context).colorScheme.surface,
                          child: InkWell(
                            onTap: () => _showDetail(item),
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor
                                              .withAlpha(20),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              _typeIcon(item.type),
                                              size: 14,
                                              color: AppColors.primaryColor,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              _typeLabel(item.type, l),
                                              style: AppTextStyles.labelSmall
                                                  .copyWith(
                                                    color:
                                                        AppColors.primaryColor,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: statusColor.withAlpha(20),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          statusTxt,
                                          style: AppTextStyles.labelSmall
                                              .copyWith(
                                                color: statusColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    '- ${Formatters.currency(item.amount.toInt())}',
                                    style: AppTextStyles.titleLarge.copyWith(
                                      color: AppColors.errorColor,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  if (item.info != null &&
                                      item.info!.isNotEmpty)
                                    Text(
                                      item.info!,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '#${item.referenceNumber ?? item.id}',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColors.textTertiary,
                                        ),
                                      ),
                                      Text(
                                        Formatters.dateTime(
                                          item.createdAt ?? '',
                                        ),
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColors.textTertiary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
