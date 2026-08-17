import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/api/api_endpoints.dart';
import '../base/base_page.dart';

class AdminBanksPage extends StatelessWidget {
  const AdminBanksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return AdminCrudPage(
      title: l.adminBanks,
      listEndpoint: ApiEndpoints.adminBanks,
      storeEndpoint: ApiEndpoints.adminBanks,
      detailEndpoint: ApiEndpoints.adminBank,
      updateEndpoint: ApiEndpoints.adminBank,
      deleteEndpoint: ApiEndpoints.adminBank,
      fields: [FieldConfig('name', isTitle: true), FieldConfig('account_number'), FieldConfig('account_holder')],
      formFields: [
        FormFieldConfig(key: 'name', label: l.bankName, required: true),
        FormFieldConfig(key: 'account_number', label: l.accountNumber, required: true),
        FormFieldConfig(key: 'account_holder', label: l.accountHolder, required: true),
        FormFieldConfig(key: 'is_active', label: l.isActive, type: FormFieldType.toggle),
      ],
    );
  }
}
