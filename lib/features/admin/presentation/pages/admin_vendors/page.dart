import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/core/api/api_endpoints.dart';
import 'package:mobile_app/core/api/dio_client.dart';
import 'package:mobile_app/core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';

class AdminVendorsPage extends ConsumerStatefulWidget {
  const AdminVendorsPage({super.key});

  @override
  ConsumerState<AdminVendorsPage> createState() => _AdminVendorsPageState();
}

class _AdminVendorsPageState extends ConsumerState<AdminVendorsPage> {
  List<Map<String, dynamic>> _vendors = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    try {
      final res = await DioClient.instance.get(ApiEndpoints.adminVendors);
      final data = res.data['data'];
      if (mounted) {
        setState(() {
          _vendors = (data is List ? data.cast<Map<String, dynamic>>() : []);
          _loading = false;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: const Text('Vendor'), backgroundColor: Colors.transparent, elevation: 0),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : _vendors.isEmpty
                  ? Center(child: Text(l.noData, style: AppTextStyles.bodyMedium))
                  : RefreshIndicator(
                      onRefresh: _fetch,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _vendors.length,
                        itemBuilder: (_, i) {
                          final v = _vendors[i];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              leading: CircleAvatar(
                                backgroundColor: AppColors.primaryColor.withValues(alpha: 0.1),
                                child: Text(
                                  (v['full_name'] as String? ?? '?')[0].toUpperCase(),
                                  style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                                ),
                              ),
                              title: Text(v['full_name'] as String? ?? '-', style: const TextStyle(fontWeight: FontWeight.w600)),
                              subtitle: Text('${v['email']}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _countChip('${v['package_count'] ?? 0}', 'Paket'),
                                  const SizedBox(width: 4),
                                  _countChip('${v['product_count'] ?? 0}', 'Produk'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }

  Widget _countChip(String count, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text('$count $label', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primaryColor)),
    );
  }
}
