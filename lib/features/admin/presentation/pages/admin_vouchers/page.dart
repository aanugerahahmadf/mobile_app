import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/api/api_endpoints.dart';
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
      formFields: const [],
      customFormBuilder: (item, preloaded) async {
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
