import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../domain/payment_method_info.dart';

class BankTransferDetail extends StatelessWidget {
  final PaymentMethodInfo method;
  final int amount;

  const BankTransferDetail({
    super.key,
    required this.method,
    required this.amount,
  });

  Future<void> _copy(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      AppSnackBar.show(context, AppLocalizations.of(context)!.copied, type: SnackBarType.success);
    }
  }

  List<String> _steps(AppLocalizations l) {
    final raw = method.instructions;
    if (raw != null && raw.trim().isNotEmpty) {
      return raw.split('\n').where((s) => s.trim().isNotEmpty).toList();
    }
    return [
      '${l.transferTo} ${method.bankName ?? ''}',
      l.uploadProofDesc,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final accountNumber = method.accountNumber ?? '-';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildAmountCard(l),
        const SizedBox(height: AppSizes.md),
        _buildAccountCard(context, l, accountNumber),
        const SizedBox(height: AppSizes.lg),
        Text(l.transferInstructions, style: AppTextStyles.titleMedium),
        const SizedBox(height: AppSizes.sm),
        _buildSteps(_steps(l)),
      ],
    );
  }

  Widget _buildAmountCard(AppLocalizations l) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.totalPayment.toUpperCase(),
            style: AppTextStyles.labelSmall.copyWith(color: Colors.white70, fontWeight: FontWeight.w700, letterSpacing: 0.6),
          ),
          const SizedBox(height: 6),
          Text(
            Formatters.currency(amount),
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context, AppLocalizations l, String accountNumber) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.bankAccount,
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSizes.sm),
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withAlpha(10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.account_balance, size: 24, color: AppColors.primaryColor),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(method.bankName ?? method.name, style: AppTextStyles.titleSmall),
                    const SizedBox(height: 2),
                    Text(
                      accountNumber,
                      style: GoogleFonts.inter(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    if (method.accountHolder != null && method.accountHolder!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        '${l.accountHolder}: ${method.accountHolder}',
                        style: AppTextStyles.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              _buildCopyButton(context, l, accountNumber),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCopyButton(BuildContext context, AppLocalizations l, String accountNumber) {
    return InkWell(
      onTap: () => _copy(context, accountNumber),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryColor, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          l.copy,
          style: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildSteps(List<String> steps) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.dividerColor),
      ),
      child: Column(
        children: [
          for (var i = 0; i < steps.length; i++) ...[
            if (i > 0) const Divider(height: AppSizes.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor,
                  ),
                  child: Text(
                    '${i + 1}',
                    style: AppTextStyles.labelSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(steps[i], style: AppTextStyles.bodyMedium),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
