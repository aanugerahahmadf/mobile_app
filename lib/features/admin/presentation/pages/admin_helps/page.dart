import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/api/api_endpoints.dart';
import '../base/base_page.dart';

class AdminHelpsPage extends StatelessWidget {
  const AdminHelpsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!
;
    return AdminCrudPage(
      title: l.adminHelps,
      listEndpoint: ApiEndpoints.adminHelp,
      storeEndpoint: ApiEndpoints.adminHelp,
      detailEndpoint: ApiEndpoints.adminHelpItem,
      updateEndpoint: ApiEndpoints.adminHelpItem,
      deleteEndpoint: ApiEndpoints.adminHelpItem,
      fields: [FieldConfig('title', isTitle: true), FieldConfig('subtitle')],
      formFields: [
        FormFieldConfig(key: 'title', label: l.title, required: true),
        FormFieldConfig(key: 'subtitle', label: l.subtitle),
        FormFieldConfig(key: 'faqs', label: 'FAQs', type: FormFieldType.multiline),
        FormFieldConfig(key: 'contact_options', label: l.contactOptions, type: FormFieldType.multiline),
      ],
    );
  }
}
