import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/api/api_endpoints.dart';
import '../base/base_page.dart';

class AdminWeddingPoliciesPage extends StatelessWidget {
  const AdminWeddingPoliciesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!
;
    return AdminCrudPage(
      title: l.adminWeddingPolicies,
      listEndpoint: ApiEndpoints.adminWeddingPolicies,
      storeEndpoint: ApiEndpoints.adminWeddingPolicies,
      detailEndpoint: ApiEndpoints.adminWeddingPolicy,
      updateEndpoint: ApiEndpoints.adminWeddingPolicy,
      deleteEndpoint: ApiEndpoints.adminWeddingPolicy,
      fields: [FieldConfig('title', isTitle: true)],
      formFields: [
        FormFieldConfig(key: 'title', label: l.title, required: true),
        FormFieldConfig(key: 'content', label: l.content, type: FormFieldType.multiline),
      ],
    );
  }
}
