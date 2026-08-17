import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/api/api_endpoints.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/formatters.dart';
import '../base/base_page.dart';

class AdminPackagesPage extends StatelessWidget {
  const AdminPackagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
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
      cardBuilder: (item, onEdit, onDelete) => _PackageCard(item: item, onEdit: onEdit, onDelete: onDelete),
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
        FormFieldConfig(key: 'vendor_id', label: 'Vendor', type: FormFieldType.dropdown, endpoint: ApiEndpoints.adminVendors, labelKey: 'store_name'),
        FormFieldConfig(key: 'description', label: l.description, type: FormFieldType.multiline),
      ],
    );
  }
}

class _PackageCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PackageCard({required this.item, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final discounts = item['discounts'] as List? ?? [];
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(16),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${item['name'] ?? '-'}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 4),
              Text(Formatters.currency(item['price'] is num ? (item['price'] as num).toInt() : 0), style: const TextStyle(fontSize: 11, color: Colors.grey)),
              if (item['vendor'] is Map)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    item['vendor']['store_name'] as String? ?? '',
                    style: const TextStyle(fontSize: 9, color: Colors.grey),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ),
              if (discounts.isNotEmpty) ...[
                const SizedBox(height: 6),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: discounts.map((d) {
                    final type = d['type'] as String? ?? 'percentage';
                    final value = d['value'] as num? ?? 0;
                    final label = type == 'percentage' ? '${value.toInt()}%' : Formatters.currency(value.toInt());
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.successColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.successColor)),
                    );
                  }).toList(),
                ),
              ],
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(onTap: onEdit, child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: AppColors.primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.edit_outlined, size: 18, color: AppColors.primaryColor),
                  )),
                  const SizedBox(width: 8),
                  GestureDetector(onTap: onDelete, child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: AppColors.errorColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.delete_outline, size: 18, color: AppColors.errorColor),
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
