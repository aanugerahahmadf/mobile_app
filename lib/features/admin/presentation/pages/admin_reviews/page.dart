import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/api/api_endpoints.dart';
import '../base/base_page.dart';

class AdminReviewsPage extends StatelessWidget {
  const AdminReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!
;
    return AdminCrudPage(
      title: l.adminReviews,
      listEndpoint: ApiEndpoints.adminReviews,
      storeEndpoint: ApiEndpoints.adminReviews,
      detailEndpoint: ApiEndpoints.adminReview,
      updateEndpoint: ApiEndpoints.adminReview,
      deleteEndpoint: ApiEndpoints.adminReview,
      fields: [FieldConfig('rating', isTitle: true), FieldConfig('comment')],
      formFields: [
        FormFieldConfig(key: 'user_id', label: l.userId, type: FormFieldType.number),
        FormFieldConfig(key: 'package_id', label: l.adminPackages, type: FormFieldType.number),
        FormFieldConfig(key: 'product_id', label: l.adminProducts, type: FormFieldType.number),
        FormFieldConfig(key: 'rating', label: l.rating, type: FormFieldType.number),
        FormFieldConfig(key: 'comment', label: l.writeReview, type: FormFieldType.multiline),
      ],
    );
  }
}
