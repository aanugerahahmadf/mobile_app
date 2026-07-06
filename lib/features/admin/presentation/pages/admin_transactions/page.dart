import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/api/api_endpoints.dart';
import '../base/base_page.dart';

class AdminTransactionsPage extends StatelessWidget {
  const AdminTransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!
;
    return AdminCrudPage(
      title: l.adminTransactions,
      listEndpoint: ApiEndpoints.adminTransactions,
      storeEndpoint: ApiEndpoints.adminTransactions,
      detailEndpoint: ApiEndpoints.adminTransaction,
      updateEndpoint: ApiEndpoints.adminTransaction,
      deleteEndpoint: ApiEndpoints.adminTransaction,
      fields: [FieldConfig('reference_number', isTitle: true), FieldConfig('amount')],
      formFields: [
        FormFieldConfig(key: 'status', label: l.status),
      ],
    );
  }
}
