import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/api/api_endpoints.dart';
import '../base/base_page.dart';

class AdminPrivacyPoliciesPage extends StatelessWidget {
  const AdminPrivacyPoliciesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!
;
    return AdminCrudPage(
      title: l.adminPrivacyPolicies,
      listEndpoint: ApiEndpoints.adminPrivacyPolicies,
      storeEndpoint: ApiEndpoints.adminPrivacyPolicies,
      detailEndpoint: ApiEndpoints.adminPrivacyPolicy,
      updateEndpoint: ApiEndpoints.adminPrivacyPolicy,
      deleteEndpoint: ApiEndpoints.adminPrivacyPolicy,
      fields: [FieldConfig('title', isTitle: true)],
      formFields: [
        FormFieldConfig(key: 'title', label: l.title, required: true),
        FormFieldConfig(key: 'content', label: l.content, type: FormFieldType.multiline),
      ],
    );
  }
}
