import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/core/api/api_endpoints.dart';
import 'package:mobile_app/core/api/dio_client.dart';
import 'package:mobile_app/core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';

class AdminWishlistsPage extends ConsumerStatefulWidget {
  const AdminWishlistsPage({super.key});

  @override
  ConsumerState<AdminWishlistsPage> createState() => _AdminWishlistsPageState();
}

class _AdminWishlistsPageState extends ConsumerState<AdminWishlistsPage> {
  List<Map<String, dynamic>> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    try {
      final res = await DioClient.instance.get(ApiEndpoints.adminWishlists);
      final data = res.data['data'];
      List<Map<String, dynamic>> items;
      if (data is List) {
        items = data.cast<Map<String, dynamic>>();
      } else if (data is Map && data.containsKey('data')) {
        items = (data['data'] as List).cast<Map<String, dynamic>>();
      } else {
        items = [];
      }
      if (mounted) setState(() { _items = items; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.adminWishlists), backgroundColor: Colors.transparent, elevation: 0),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? Center(child: Text(l.noData, style: AppTextStyles.bodyMedium))
              : RefreshIndicator(
                  onRefresh: _fetch,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _items.length,
                    itemBuilder: (_, i) {
                      final item = _items[i];
                      final userName = item['user_name'] as String? ?? 'User #${item['user_id']}';
                      final packageName = item['package_name'] as String?;
                      final productName = item['product_name'] as String?;
                      final createdAt = item['created_at'] as String?;
                      return Material(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 36, height: 36,
                                    decoration: BoxDecoration(
                                      color: AppColors.errorColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(Icons.favorite, color: AppColors.errorColor, size: 18),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(userName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              if (packageName != null)
                                Text(l.packageName, style: TextStyle(fontSize: 9, color: AppColors.textSecondary)),
                              if (packageName != null)
                                Text(packageName, style: const TextStyle(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                              if (productName != null) ...[
                                const SizedBox(height: 4),
                                Text(l.productName, style: TextStyle(fontSize: 9, color: AppColors.textSecondary)),
                                Text(productName, style: const TextStyle(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                              ],
                              const Spacer(),
                              if (createdAt != null)
                                Text(createdAt, style: const TextStyle(fontSize: 9, color: Colors.grey)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
