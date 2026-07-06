import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/api/api_endpoints.dart';
import '../base/base_page.dart';

class AdminCategoriesPage extends StatelessWidget {
  const AdminCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!
;
    return AdminCrudPage(
      title: l.adminCategories,
      listEndpoint: ApiEndpoints.adminCategories,
      storeEndpoint: ApiEndpoints.adminCategories,
      detailEndpoint: ApiEndpoints.adminCategory,
      updateEndpoint: ApiEndpoints.adminCategory,
      deleteEndpoint: ApiEndpoints.adminCategory,
      fields: [FieldConfig('name', isTitle: true), FieldConfig('type'), FieldConfig('slug')],
      formFields: [
        FormFieldConfig(key: 'name', label: l.fullName, required: true),
        FormFieldConfig(key: 'slug', label: l.slug),
        FormFieldConfig(key: 'type', label: l.type, type: FormFieldType.dropdown, options: const ['package', 'product']),
        FormFieldConfig(key: 'icon', label: l.icon),
        FormFieldConfig(key: 'color', label: l.color),
        FormFieldConfig(key: 'description', label: l.description, type: FormFieldType.multiline),
      ],
    );
  }
}
