import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/api/api_endpoints.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/formatters.dart';
import '../base/base_page.dart';
import 'form.dart';

class AdminVouchersPage extends StatelessWidget {
  const AdminVouchersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return AdminCrudPage(
      title: l.adminVouchers,
      listEndpoint: ApiEndpoints.adminVouchers,
      storeEndpoint: ApiEndpoints.adminVouchers,
      detailEndpoint: ApiEndpoints.adminVoucher,
      updateEndpoint: ApiEndpoints.adminVoucher,
      deleteEndpoint: ApiEndpoints.adminVoucher,
      fields: [FieldConfig('code', isTitle: true), FieldConfig('discount_amount'), FieldConfig('discount_type'), FieldConfig('is_active')],
      cardBuilder: (item, onEdit, onDelete) => _VoucherCard(item: item, onEdit: onEdit, onDelete: onDelete),
      formFields: const [],
      customFormBuilder: (context, item, preloaded) async {
        final l = AppLocalizations.of(context)!;
        return showModalBottomSheet<Map<String, dynamic>>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          backgroundColor: Colors.transparent,
          builder: (_) => AdminVoucherFormDialog(
            title: item == null ? '${l.add} ${l.adminVouchers}' : '${l.edit} ${l.adminVouchers}',
            initialData: item,
            preloadedOptions: preloaded,
          ),
        );
      },
    );
  }
}

class _VoucherCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _VoucherCard({required this.item, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final name = item['name'] as String?;
    final code = item['code'] as String? ?? '-';
    final discAmount = item['discount_amount'] as num? ?? 0;
    final discType = item['discount_type'] as String? ?? 'fixed';
    final isActive = item['is_active'] == true;
    final label = discType == 'percentage' ? '${discAmount.toInt()}%' : Formatters.currency(discAmount.toInt());
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(16),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (name != null && name.isNotEmpty) ...[
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
              ],
              Row(
                children: [
                  Expanded(
                    child: Text(code, style: TextStyle(fontWeight: name != null ? FontWeight.w400 : FontWeight.w600, fontSize: name != null ? 11 : 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.successColor.withValues(alpha: 0.15) : Colors.grey.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(isActive ? l.active : l.inactive, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: isActive ? AppColors.successColor : Colors.grey)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.infoColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.infoColor)),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(onTap: onEdit, child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: AppColors.primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.edit_outlined, size: 18, color: AppColors.primaryColor),
                  )),
                  const SizedBox(width: 8),
                  GestureDetector(onTap: onDelete, child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: AppColors.errorColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.delete_outline, size: 18, color: AppColors.errorColor),
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
