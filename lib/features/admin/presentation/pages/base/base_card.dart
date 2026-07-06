import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';

class FieldConfig {
  final String key;
  final bool isTitle;
  const FieldConfig(this.key, {this.isTitle = false});
}

typedef AdminCardBuilder = Widget Function(Map<String, dynamic> item, VoidCallback onEdit, VoidCallback onDelete);

class AdminDataCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final int id;
  final List<FieldConfig> fields;
  final String? imageField;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AdminDataCard({
    super.key,
    required this.item,
    required this.id,
    required this.fields,
    this.imageField,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceColor,
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (imageField != null && item[imageField!] != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: item[imageField!],
                          width: 48, height: 48, fit: BoxFit.cover,
                        ),
                      )
                    else
                      Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.folder, color: AppColors.primaryColor),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: fields.map((f) {
                        final val = item[f.key];
                        final display = val?.toString() ?? '-';
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            display,
                            style: f.isTitle
                                ? AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)
                                : AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                            maxLines: f.isTitle ? 2 : 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: onEdit,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.edit_outlined, size: 18, color: AppColors.primaryColor),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onDelete,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.errorColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.delete_outline, size: 18, color: AppColors.errorColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ),
    );
  }
}
