import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/api/api_endpoints.dart';
import '../base/base_page.dart';

class AdminLegalPagesPage extends StatelessWidget {
  const AdminLegalPagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!
;
    return AdminCrudPage(
      title: l.adminLegalPages,
      listEndpoint: ApiEndpoints.adminLegalPages,
      storeEndpoint: ApiEndpoints.adminLegalPages,
      detailEndpoint: ApiEndpoints.adminLegalPage,
      updateEndpoint: ApiEndpoints.adminLegalPage,
      deleteEndpoint: ApiEndpoints.adminLegalPage,
      fields: [FieldConfig('title', isTitle: true)],
      formFields: [
        FormFieldConfig(key: 'title', label: l.title, required: true),
        FormFieldConfig(key: 'content', label: l.content, type: FormFieldType.multiline),
      ],
    );
  }
}
