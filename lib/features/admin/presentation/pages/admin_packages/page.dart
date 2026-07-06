import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/api/api_endpoints.dart';
import '../base/base_page.dart';

class AdminPackagesPage extends StatelessWidget {
  const AdminPackagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!
;
    return AdminCrudPage(
      title: l.adminPackages,
      listEndpoint: ApiEndpoints.adminPackages,
      storeEndpoint: ApiEndpoints.adminPackages,
      detailEndpoint: ApiEndpoints.adminPackage,
      updateEndpoint: ApiEndpoints.adminPackage,
      deleteEndpoint: ApiEndpoints.adminPackage,
      imageUploadEndpoint: ApiEndpoints.adminPackageUpload,
      imageField: 'image_url',
      fields: [FieldConfig('name', isTitle: true), FieldConfig('price'), FieldConfig('discount_price'), FieldConfig('stock'), FieldConfig('is_active')],
      formFields: [
        FormFieldConfig(key: 'image_url', label: l.imageLabel, type: FormFieldType.image),
        FormFieldConfig(key: 'name', label: l.fullName, required: true),
        FormFieldConfig(key: 'slug', label: l.slug),
        FormFieldConfig(key: 'price', label: l.price, type: FormFieldType.number),
        FormFieldConfig(key: 'discount_price', label: l.discountPrice, type: FormFieldType.number),
        FormFieldConfig(key: 'stock', label: l.stock, type: FormFieldType.number),
        FormFieldConfig(key: 'is_active', label: l.isActive, type: FormFieldType.toggle),
        FormFieldConfig(key: 'is_featured', label: l.isFeatured, type: FormFieldType.toggle),
        FormFieldConfig(key: 'features', label: l.features),
        FormFieldConfig(key: 'theme', label: l.theme),
        FormFieldConfig(key: 'color', label: l.color),
        FormFieldConfig(key: 'min_capacity', label: l.minCapacity, type: FormFieldType.number),
        FormFieldConfig(key: 'max_capacity', label: l.maxCapacity, type: FormFieldType.number),
        FormFieldConfig(key: 'category_id', label: l.adminCategories, type: FormFieldType.dropdown, endpoint: ApiEndpoints.adminCategories, endpointQuery: 'type=package'),
        FormFieldConfig(key: 'description', label: l.description, type: FormFieldType.multiline),
      ],
    );
  }
}
