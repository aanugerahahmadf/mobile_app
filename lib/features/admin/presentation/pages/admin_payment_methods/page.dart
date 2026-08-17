import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/api/api_endpoints.dart';
import '../base/base_page.dart';

class AdminPaymentMethodsPage extends StatelessWidget {
  const AdminPaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return AdminCrudPage(
      title: l.adminPaymentMethods,
      listEndpoint: ApiEndpoints.adminPaymentMethods,
      storeEndpoint: ApiEndpoints.adminPaymentMethods,
      detailEndpoint: ApiEndpoints.adminPaymentMethod,
      updateEndpoint: ApiEndpoints.adminPaymentMethod,
      deleteEndpoint: ApiEndpoints.adminPaymentMethod,
      imageUploadEndpoint: ApiEndpoints.adminPaymentMethod,
      fields: [
        FieldConfig('name', isTitle: true),
        FieldConfig('type'),
        FieldConfig('bank_name'),
        FieldConfig('account_number'),
        FieldConfig('is_active'),
      ],
      formFields: [
        FormFieldConfig(key: 'name', label: l.name, required: true),
        FormFieldConfig(
          key: 'type',
          label: l.type,
          required: true,
          type: FormFieldType.dropdown,
          options: ['bank_transfer', 'qris', 'cash'],
        ),
        FormFieldConfig(key: 'code', label: l.code),
        FormFieldConfig(key: 'bank_name', label: l.bankName),
        FormFieldConfig(key: 'account_number', label: l.accountNumber),
        FormFieldConfig(key: 'account_holder', label: l.accountHolder),
        FormFieldConfig(key: 'image_url', label: 'Image', type: FormFieldType.image),
        FormFieldConfig(key: 'instructions', label: 'Instructions', type: FormFieldType.multiline),
        FormFieldConfig(key: 'fee', label: 'Admin Fee', type: FormFieldType.number),
        FormFieldConfig(key: 'sort_order', label: 'Sort Order', type: FormFieldType.number),
        FormFieldConfig(key: 'is_active', label: l.isActive, type: FormFieldType.toggle),
      ],
      imageField: 'image_url',
    );
  }
}
