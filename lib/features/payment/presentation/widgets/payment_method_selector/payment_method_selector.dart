import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../core/constants/app_sizes/app_sizes.dart';
import '../../../../../core/constants/app_text_styles/app_text_styles.dart';
import '../../../domain/payment_method_info/payment_method_info.dart';

class PaymentMethodSelector extends StatelessWidget {
  final List<PaymentMethodInfo> methods;
  final int? selectedId;
  final ValueChanged<int> onSelect;

  const PaymentMethodSelector({
    super.key,
    required this.methods,
    required this.selectedId,
    required this.onSelect,
  });

  static const _groupOrder = [
    'bank_transfer',
    'e_wallet',
    'qris',
    'credit_card',
  ];

  String _groupTitle(String type, AppLocalizations l) {
    switch (type) {
      case 'bank_transfer':
        return l.transferBank;
      case 'e_wallet':
        return l.eWallet;
      case 'qris':
        return l.qris;
      case 'credit_card':
        return l.creditCard;
      default:
        return l.otherPaymentMethods;
    }
  }

  String? _subtitle(PaymentMethodInfo m, AppLocalizations l) {
    switch (m.type) {
      case 'bank_transfer':
        if (m.accountNumber != null && m.accountNumber!.isNotEmpty) {
          final digits = m.accountNumber!.replaceAll(RegExp(r'\D'), '');
          final tail = digits.length > 4
              ? digits.substring(digits.length - 4)
              : digits;
          return '${m.bankName ?? m.name} •••• $tail';
        }
        return m.bankName;
      case 'e_wallet':
        return l.payWithEWallet(m.name);
      case 'qris':
        return l.payWithQris;
      case 'credit_card':
        return l.payWithCreditCard;
      default:
        return m.accountNumber;
    }
  }

  IconData _icon(String type) {
    switch (type) {
      case 'bank_transfer':
        return Icons.account_balance;
      case 'e_wallet':
        return Icons.account_balance_wallet;
      case 'qris':
        return Icons.qr_code_2;
      case 'credit_card':
        return Icons.credit_card;
      default:
        return Icons.payments;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final active = methods.where((m) => m.isActive).toList();

    final grouped = <String, List<PaymentMethodInfo>>{};
    for (final type in _groupOrder) {
      grouped[type] = active.where((m) => m.type == type).toList();
    }
    final other = active.where((m) => !_groupOrder.contains(m.type)).toList();
    if (other.isNotEmpty) grouped['other'] = other;

    final groups = _groupOrder
        .where((type) => (grouped[type]?.isNotEmpty ?? false))
        .map((type) => MapEntry(type, grouped[type]!))
        .toList();
    if (other.isNotEmpty) groups.add(MapEntry('other', other));

    if (groups.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var gi = 0; gi < groups.length; gi++) ...[
            if (gi > 0) const Divider(height: 1),
            _buildGroupHeader(_groupTitle(groups[gi].key, l)),
            for (var i = 0; i < groups[gi].value.length; i++) ...[
              if (i > 0) const Divider(height: 1, indent: 64),
              _buildRow(groups[gi].value[i], l),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildGroupHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      color: AppColors.surfaceColor,
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  Widget _buildRow(PaymentMethodInfo method, AppLocalizations l) {
    final selected = selectedId == method.id;
    return InkWell(
      onTap: () => onSelect(method.id),
      child: Container(
        color: selected
            ? AppColors.primaryColor.withAlpha(12)
            : AppColors.surfaceColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primaryColor.withAlpha(20)
                    : AppColors.primaryColor.withAlpha(10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _icon(method.type),
                size: 22,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? AppColors.primaryColor
                          : AppColors.textPrimary,
                    ),
                  ),
                  if (_subtitle(method, l) != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      _subtitle(method, l)!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            _buildRadio(selected),
          ],
        ),
      ),
    );
  }

  Widget _buildRadio(bool selected) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? AppColors.primaryColor : Colors.transparent,
        border: Border.all(
          color: selected ? AppColors.primaryColor : AppColors.dividerColor,
          width: 2,
        ),
      ),
      child: selected
          ? const Icon(Icons.check, size: 14, color: Colors.white)
          : null,
    );
  }
}
