export 'base_card.dart' show FieldConfig;
export 'base_form.dart' show FormFieldConfig, FormFieldType;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/api/dio_client.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../data/repositories/admin_repository.dart';
import 'base_card.dart';
import 'base_form.dart';

typedef FormDataTransformer = Map<String, dynamic> Function(Map<String, dynamic> data);

class AdminCrudPage extends ConsumerStatefulWidget {
  final String title;
  final String listEndpoint;
  final String Function(int id) detailEndpoint;
  final String storeEndpoint;
  final String Function(int id) updateEndpoint;
  final String Function(int id) deleteEndpoint;
  final String Function(int id)? imageUploadEndpoint;
  final List<FieldConfig> fields;
  final AdminCardBuilder? cardBuilder;
  final List<FormFieldConfig> formFields;
  final String? iconField;
  final String? imageField;
  final FormDataTransformer? transformData;
  final Future<Map<String, dynamic>?> Function(Map<String, dynamic>? item, Map<String, List<Map<String, dynamic>>> preloadedOptions)? customFormBuilder;

  const AdminCrudPage({
    super.key,
    required this.title,
    required this.listEndpoint,
    required this.detailEndpoint,
    required this.storeEndpoint,
    required this.updateEndpoint,
    required this.deleteEndpoint,
    this.imageUploadEndpoint,
    required this.fields,
    this.cardBuilder,
    required this.formFields,
    this.iconField,
    this.imageField,
    this.transformData,
    this.customFormBuilder,
  });

  @override
  ConsumerState<AdminCrudPage> createState() => _AdminCrudPageState();
}

class _AdminCrudPageState extends ConsumerState<AdminCrudPage> {
  List<Map<String, dynamic>> _items = [];
  bool _loading = true;

  late final AdminRepository _repo;

  @override
  void initState() {
    super.initState();
    _repo = ref.read(adminRepositoryProvider);
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    try {
      final data = await _repo.list(widget.listEndpoint);
      if (mounted) {
        setState(() {
          _items = data;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _delete(int id) async {
    final l = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.confirm),
        content: Text(l.confirmDelete),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.delete, style: TextStyle(color: AppColors.errorColor))),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        await _repo.delete(widget.deleteEndpoint, id);
        _fetch();
      } catch (_) {}
    }
  }

  Future<void> _showForm([Map<String, dynamic>? item]) async {
    final l = AppLocalizations.of(context)!;
    final preloaded = <String, List<Map<String, dynamic>>>{};
    for (final f in widget.formFields) {
      if (f.type == FormFieldType.dropdown && f.endpoint != null) {
        try {
          var uri = f.endpoint!;
          if (f.endpointQuery != null) uri += '?${f.endpointQuery}';
          final res = await DioClient.instance.get(uri);
          final data = res.data['data'];
          if (data is List) {
            preloaded[f.key] = data.cast<Map<String, dynamic>>();
          }
        } catch (_) {}
      }
    }
    if (!mounted) return;
    final result = widget.customFormBuilder != null
        ? await widget.customFormBuilder!(item, preloaded)
        : await showModalBottomSheet<Map<String, dynamic>>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            backgroundColor: Colors.transparent,
            builder: (_) => AdminFormDialog(
              title: item == null ? '${l.add} ${widget.title}' : '${l.edit} ${widget.title}',
              fields: widget.formFields,
              initialData: item,
              preloadedOptions: preloaded,
            ),
          );
    if (result != null) {
      final data = widget.transformData != null ? widget.transformData!(result) : result;
      try {
        if (item == null) {
          final created = await _repo.create(widget.storeEndpoint, _cleanData(data));
          if (created != null && widget.imageUploadEndpoint != null) {
            final imagePath = _getImagePath(data);
            if (imagePath != null) {
              await _repo.uploadImage(widget.imageUploadEndpoint!, created['id'] as int, imagePath);
            }
          }
        } else {
          final cleaned = _cleanData(data);
          if (_hasImageFile(data) && widget.imageUploadEndpoint != null) {
            final imagePath = _getImagePath(data);
            if (imagePath != null) {
              await _repo.uploadImage(widget.imageUploadEndpoint!, item['id'] as int, imagePath);
            }
            cleaned.remove(widget.imageField);
          }
          await _repo.update(widget.updateEndpoint, item['id'] as int, cleaned);
        }
        _fetch();
      } catch (_) {}
    }
  }

  Map<String, dynamic> _cleanData(Map<String, dynamic> data) {
    final cleaned = <String, dynamic>{};
    data.forEach((key, value) {
      if (!_isFilePath(value)) {
        cleaned[key] = value;
      }
    });
    return cleaned;
  }

  bool _isFilePath(dynamic value) {
    if (value is! String) return false;
    return value.startsWith('/') || value.contains(':\\');
  }

  String? _getImagePath(Map<String, dynamic> data) {
    if (widget.imageField != null && data.containsKey(widget.imageField)) {
      final v = data[widget.imageField!];
      if (v is String && _isFilePath(v)) return v;
    }
    return null;
  }

  bool _hasImageFile(Map<String, dynamic> data) => _getImagePath(data) != null;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: const Icon(Icons.add),
      ),
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
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _items.length,
                    itemBuilder: (_, i) {
                      final item = _items[i];
                      final id = item['id'] as int? ?? 0;
                      if (widget.cardBuilder != null) {
                        return widget.cardBuilder!(item, () => _showForm(item), () => _delete(id));
                      }
                      return AdminDataCard(
                        item: item,
                        id: id,
                        fields: widget.fields,
                        imageField: widget.imageField,
                        onEdit: () => _showForm(item),
                        onDelete: () => _delete(id),
                      );
                    },
                  ),
                ),
    );
  }
}
