import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/api/api_endpoints.dart';
import '../../../../../core/api/dio_client.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../base/base_page.dart';

class AdminDiscountsPage extends StatelessWidget {
  const AdminDiscountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return AdminCrudPage(
      title: l.adminDiscounts,
      listEndpoint: ApiEndpoints.adminDiscounts,
      storeEndpoint: ApiEndpoints.adminDiscounts,
      detailEndpoint: ApiEndpoints.adminDiscount,
      updateEndpoint: ApiEndpoints.adminDiscount,
      deleteEndpoint: ApiEndpoints.adminDiscount,
      fields: const [FieldConfig('id', isTitle: true), FieldConfig('value'), FieldConfig('type')],
      cardBuilder: (item, onEdit, onDelete) => _DiscountCard(item: item, onEdit: onEdit, onDelete: onDelete),
      formFields: const [],
      customFormBuilder: _buildDiscountForm,
    );
  }

  static Future<Map<String, dynamic>?> _buildDiscountForm(
    BuildContext context,
    Map<String, dynamic>? item,
    Map<String, List<Map<String, dynamic>>> preloaded,
  ) async {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DiscountFormDialog(item: item),
    );
  }
}

class _DiscountFormDialog extends StatefulWidget {
  final Map<String, dynamic>? item;
  const _DiscountFormDialog({this.item});

  @override
  State<_DiscountFormDialog> createState() => _DiscountFormDialogState();
}

class _DiscountFormDialogState extends State<_DiscountFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _valueCtrl;
  late TextEditingController _minPurchaseCtrl;
  late TextEditingController _startDateCtrl;
  late TextEditingController _endDateCtrl;

  String? _selectedType;
  String? _selectedDiscType;
  String? _selectedDiscId;
  List<Map<String, dynamic>> _discItems = [];
  bool _loadingItems = false;
  bool _isActive = true;

  static const _discTypeOptions = {
    'Package': 'App\\Models\\Package',
    'Product': 'App\\Models\\Product',
  };

  @override
  void initState() {
    super.initState();
    final d = widget.item;
    _valueCtrl = TextEditingController(text: d?['value']?.toString() ?? '');
    _minPurchaseCtrl = TextEditingController(text: d?['min_purchase']?.toString() ?? '');
    _startDateCtrl = TextEditingController(text: _formatDate(d?['start_date']));
    _endDateCtrl = TextEditingController(text: _formatDate(d?['end_date']));
    _selectedType = d?['type']?.toString() ?? 'percentage';
    _isActive = d?['is_active'] == true;

    final discType = d?['discountable_type']?.toString() ?? '';
    if (discType.isNotEmpty) {
      final entry = _discTypeOptions.entries.firstWhere(
        (e) => e.value == discType,
        orElse: () => MapEntry('', ''),
      );
      _selectedDiscType = entry.key.isNotEmpty ? entry.value : null;
    }
    _selectedDiscId = d?['discountable_id']?.toString();
    if (_selectedDiscType != null) {
      _fetchDiscItems();
    }
  }

  String _formatDate(dynamic date) {
    if (date == null) return '';
    final str = date.toString();
    if (str.length >= 16) return str.substring(0, 16);
    return str;
  }

  @override
  void dispose() {
    _valueCtrl.dispose();
    _minPurchaseCtrl.dispose();
    _startDateCtrl.dispose();
    _endDateCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchDiscItems() async {
    if (_selectedDiscType == null) return;
    setState(() => _loadingItems = true);
    try {
      final isPackage = _selectedDiscType!.contains('Package');
      final endpoint = isPackage ? ApiEndpoints.adminPackages : ApiEndpoints.adminProducts;
      final res = await DioClient.instance.get(endpoint);
      final data = res.data['data'];
      List<Map<String, dynamic>> items;
      if (data is List) {
        items = data.cast<Map<String, dynamic>>();
      } else if (data is Map && data.containsKey('data')) {
        items = (data['data'] as List).cast<Map<String, dynamic>>();
      } else {
        items = [];
      }
      setState(() {
        _discItems = items;
        _loadingItems = false;
        if (_selectedDiscId != null && !items.any((e) => '${e['id']}' == _selectedDiscId)) {
          _selectedDiscId = null;
        }
      });
    } catch (_) {
      setState(() {
        _discItems = [];
        _loadingItems = false;
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDiscType == null || _selectedDiscId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.selectItemFirst)),
      );
      return;
    }
    final data = <String, dynamic>{
      'discountable_type': _selectedDiscType,
      'discountable_id': int.parse(_selectedDiscId!),
      'type': _selectedType ?? 'percentage',
      'value': double.tryParse(_valueCtrl.text.trim()) ?? 0,
      'min_purchase': double.tryParse(_minPurchaseCtrl.text.trim()) ?? 0,
      'start_date': _startDateCtrl.text.trim().isEmpty ? null : _startDateCtrl.text.trim(),
      'end_date': _endDateCtrl.text.trim().isEmpty ? null : _endDateCtrl.text.trim(),
      'is_active': _isActive,
    };
    Navigator.pop(context, data);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isEdit = widget.item != null;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4,
                decoration: BoxDecoration(color: AppColors.textTertiary.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 16),
              Text(isEdit ? '${l.edit} ${l.adminDiscounts}' : '${l.add} ${l.adminDiscounts}', style: AppTextStyles.titleMedium),
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection(l.selectItem, [
                        DropdownButtonFormField<String>(
                          initialValue: _selectedDiscType,
                          decoration: _inputDecoration(l.itemType),
                          items: _discTypeOptions.entries.map((e) => DropdownMenuItem(
                            value: e.value,
                            child: Text(e.key),
                          )).toList(),
                          onChanged: (v) {
                            setState(() {
                              _selectedDiscType = v;
                              _selectedDiscId = null;
                              _discItems = [];
                            });
                            _fetchDiscItems();
                          },
                          validator: (v) => v == null ? l.fieldRequired : null,
                        ),
                        const SizedBox(height: 8),
                        _loadingItems
                          ? const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)))
                          : DropdownButtonFormField<String>(
                              initialValue: _selectedDiscId,
                              decoration: _inputDecoration(l.itemName),
                              items: _discItems.map((e) => DropdownMenuItem(
                                value: '${e['id']}',
                                child: Text('${e['name'] ?? '-'}'),
                              )).toList(),
                              onChanged: (v) => setState(() => _selectedDiscId = v),
                              validator: (v) => v == null ? l.fieldRequired : null,
                            ),
                      ]),
                      const SizedBox(height: 12),
                      _buildSection(l.value, [
                        DropdownButtonFormField<String>(
                          initialValue: _selectedType,
                          decoration: _inputDecoration(l.type),
                          items: [
                            DropdownMenuItem(value: 'percentage', child: Text(l.percentageValue)),
                            DropdownMenuItem(value: 'fixed', child: Text(l.currencyValue)),
                          ],
                          onChanged: (v) => setState(() => _selectedType = v),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _valueCtrl,
                          decoration: _inputDecoration(_selectedType == 'percentage' ? l.percentageValue : l.currencyValue),
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return l.fieldRequired;
                            final num = double.tryParse(v.trim());
                            if (num == null || num < 0) return l.invalidValue;
                            if (_selectedType == 'percentage' && (num > 100)) return l.invalidValue;
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _minPurchaseCtrl,
                          decoration: _inputDecoration(l.minPurchase),
                          keyboardType: TextInputType.number,
                        ),
                      ]),
                      const SizedBox(height: 12),
                      _buildSection(l.period, [
                        TextFormField(
                          controller: _startDateCtrl,
                          decoration: _inputDecoration(l.startDate, suffix: IconButton(
                            icon: const Icon(Icons.calendar_today, size: 18),
                            onPressed: () => _pickDate(_startDateCtrl),
                          )),
                          readOnly: true,
                          onTap: () => _pickDate(_startDateCtrl),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _endDateCtrl,
                          decoration: _inputDecoration(l.endDate, suffix: IconButton(
                            icon: const Icon(Icons.calendar_today, size: 18),
                            onPressed: () => _pickDate(_endDateCtrl),
                          )),
                          readOnly: true,
                          onTap: () => _pickDate(_endDateCtrl),
                        ),
                      ]),
                      const SizedBox(height: 8),
                      SwitchListTile(
                        title: Text(l.isActive),
                        value: _isActive,
                        onChanged: (v) => setState(() => _isActive = v),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
                  const SizedBox(width: 8),
                  FilledButton(onPressed: _submit, child: Text(l.save)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.labelMedium),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  InputDecoration _inputDecoration(String label, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      suffixIcon: suffix,
    );
  }

  Future<void> _pickDate(TextEditingController ctrl) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(ctrl.text) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      final time = TimeOfDay.fromDateTime(DateTime.tryParse(ctrl.text) ?? DateTime.now());
      final dt = DateTime(picked.year, picked.month, picked.day, time.hour, time.minute);
      ctrl.text = dt.toIso8601String().substring(0, 16);
    }
  }
}

class _DiscountCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _DiscountCard({required this.item, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final type = item['type'] as String? ?? 'percentage';
    final value = item['value'] as num? ?? 0;
    final minPurchase = item['min_purchase'] as num? ?? 0;
    final isActive = item['is_active'] == true;
    final discObj = item['discountable'] as Map<String, dynamic>?;
    final itemName = discObj?['name'] as String? ?? '-';

    final label = type == 'percentage' ? '${value.toInt()}%' : 'Rp ${value.toInt()}';
    final discType = item['discountable_type'] as String? ?? '';
    final typeLabel = discType.contains('Package') ? 'Package' : (discType.contains('Product') ? 'Product' : '-');
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
              Row(
                children: [
                  Expanded(child: Text(itemName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.successColor.withValues(alpha: 0.15) : Colors.grey.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(isActive ? l.active : l.inactive, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: isActive ? AppColors.successColor : Colors.grey)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.infoColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.infoColor)),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.warningColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(typeLabel, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: AppColors.warningColor)),
                  ),
                ],
              ),
              if (minPurchase > 0) ...[
                const SizedBox(height: 2),
                Text('${l.minPurchase}: Rp ${minPurchase.toInt()}', style: const TextStyle(fontSize: 9, color: Colors.grey)),
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
