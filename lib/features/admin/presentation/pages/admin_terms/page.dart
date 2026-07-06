import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/api/api_endpoints.dart';
import '../base/base_page.dart';

class AdminTermsPage extends StatelessWidget {
  const AdminTermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!
;
    return AdminCrudPage(
      title: l.adminTerms,
      listEndpoint: ApiEndpoints.adminTerms,
      storeEndpoint: ApiEndpoints.adminTerms,
      detailEndpoint: ApiEndpoints.adminTerm,
      updateEndpoint: ApiEndpoints.adminTerm,
      deleteEndpoint: ApiEndpoints.adminTerm,
      fields: [FieldConfig('title', isTitle: true)],
      formFields: [
        FormFieldConfig(key: 'title', label: l.title, required: true),
        FormFieldConfig(key: 'content', label: l.content, type: FormFieldType.multiline),
      ],
    );
  }
}
