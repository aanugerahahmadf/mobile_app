import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/api/api_endpoints.dart';
import 'package:mobile_app/core/api/dio_client.dart';
import 'package:mobile_app/core/constants/app_colors.dart';
import 'package:mobile_app/core/constants/app_text_styles.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/vendor_model.dart';

class VendorListPage extends StatefulWidget {
  const VendorListPage({super.key});

  @override
  State<VendorListPage> createState() => _VendorListPageState();
}

class _VendorListPageState extends State<VendorListPage> {
  List<VendorModel> _vendors = [];
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
      final res = await DioClient.instance.get(ApiEndpoints.vendors);
      final data = res.data['data'];
      if (mounted) {
        setState(() {
          _vendors = data is List
              ? data.map((e) => VendorModel.fromJson(e as Map<String, dynamic>)).toList()
              : [];
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
      appBar: AppBar(
        title: Text(l.vendors),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Error: $_error', textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      FilledButton.tonalIcon(
                        onPressed: _fetch,
                        icon: const Icon(Icons.refresh),
                        label: Text(l.retry),
                      ),
                    ],
                  ),
                )
              : _vendors.isEmpty
                  ? Center(child: Text(l.noVendorsAvailable, style: AppTextStyles.bodyMedium))
                  : RefreshIndicator(
                      onRefresh: _fetch,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _vendors.length,
                        itemBuilder: (_, i) => _VendorCard(
                          vendor: _vendors[i],
                          onTap: () => context.push('/vendor/${_vendors[i].id}'),
                        ),
                      ),
                    ),
    );
  }
}

class _VendorCard extends StatelessWidget {
  final VendorModel vendor;
  final VoidCallback onTap;

  const _VendorCard({required this.vendor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: vendor.logo != null && vendor.logo!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: vendor.logo!,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => Container(
                          width: 64, height: 64,
                          color: AppColors.primaryColor.withValues(alpha: 0.1),
                          child: const Icon(Icons.store, color: AppColors.primaryColor),
                        ),
                        errorWidget: (_, _, _) => Container(
                          width: 64, height: 64,
                          color: AppColors.primaryColor.withValues(alpha: 0.1),
                          child: const Icon(Icons.store, color: AppColors.primaryColor),
                        ),
                      )
                    : Container(
                        width: 64, height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.store, color: AppColors.primaryColor, size: 32),
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vendor.storeName,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    if (vendor.storeDescription != null && vendor.storeDescription!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          vendor.storeDescription!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                      ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
