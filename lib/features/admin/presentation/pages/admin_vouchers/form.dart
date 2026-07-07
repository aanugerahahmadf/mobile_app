import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/core/api/dio_client.dart';
import 'package:mobile_app/core/api/api_endpoints.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';

class AdminVoucherFormDialog extends StatefulWidget {
  final String title;
  final Map<String, dynamic>? initialData;
  final Map<String, List<Map<String, dynamic>>> preloadedOptions;

  const AdminVoucherFormDialog({
    super.key,
    required this.title,
    this.initialData,
    this.preloadedOptions = const {},
  });

  @override
  State<AdminVoucherFormDialog> createState() => _AdminVoucherFormDialogState();
}

class _AdminVoucherFormDialogState extends State<AdminVoucherFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeController;
  late TextEditingController _discountAmountController;
  late TextEditingController _descriptionController;
  late TextEditingController _minPurchaseController;
  late TextEditingController _maxUsesController;
  late TextEditingController _expiresAtController;
  late TextEditingController _searchUserController;

  String _discountType = 'fixed';
  bool _isActive = true;
  bool _isGlobal = false;
  List<Map<String, dynamic>> _allUsers = [];
  List<Map<String, dynamic>> _filteredUsers = [];
  final Set<int> _selectedUserIds = {};
  bool _loadingUsers = false;

  @override
  void initState() {
    super.initState();
    final d = widget.initialData;
    _codeController = TextEditingController(text: d?['code']?.toString() ?? '');
    _discountAmountController = TextEditingController(text: d?['discount_amount']?.toString() ?? '');
    _descriptionController = TextEditingController(text: d?['description']?.toString() ?? '');
    _minPurchaseController = TextEditingController(text: d?['min_purchase']?.toString() ?? '');
    _maxUsesController = TextEditingController(text: d?['max_uses']?.toString() ?? '');
    _expiresAtController = TextEditingController(text: d?['expires_at']?.toString() ?? '');
    _searchUserController = TextEditingController();
    _discountType = d?['discount_type']?.toString() ?? 'fixed';
    _isActive = d?['is_active'] == true || d?['is_active'] == 1 || d?['is_active'] == '1';
    _isGlobal = d?['is_global'] == true || d?['is_global'] == 1 || d?['is_global'] == '1';
    _searchUserController.addListener(_filterUsers);
    _fetchUsers();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _discountAmountController.dispose();
    _descriptionController.dispose();
    _minPurchaseController.dispose();
    _maxUsesController.dispose();
    _expiresAtController.dispose();
    _searchUserController.dispose();
    super.dispose();
  }

  Future<void> _fetchUsers() async {
    setState(() => _loadingUsers = true);
    try {
      final res = await DioClient.instance.get(ApiEndpoints.adminUsers);
      final data = res.data['data'];
      if (data is List) {
        final users = data.cast<Map<String, dynamic>>();
        final initialIds = <int>[];
        if (widget.initialData?['users'] is List) {
          for (final u in widget.initialData!['users'] as List) {
            if (u is Map) {
              final id = u['id'];
              if (id is int) initialIds.add(id);
            }
          }
        }
        if (mounted) {
          setState(() {
            _allUsers = users;
            _filteredUsers = users;
            _selectedUserIds.addAll(initialIds);
            _loadingUsers = false;
          });
        }
      }
    } catch (_) {
      if (mounted) setState(() => _loadingUsers = false);
    }
  }

  void _filterUsers() {
    final q = _searchUserController.text.toLowerCase();
    setState(() {
      _filteredUsers = _allUsers.where((u) {
        final name = '${u['full_name'] ?? u['name'] ?? ''}'.toLowerCase();
        final email = '${u['email'] ?? ''}'.toLowerCase();
        return name.contains(q) || email.contains(q);
      }).toList();
    });
  }

  void _toggleUser(int id) {
    setState(() {
      if (_selectedUserIds.contains(id)) {
        _selectedUserIds.remove(id);
      } else {
        _selectedUserIds.add(id);
      }
    });
  }

  Map<String, dynamic> _collectData() {
    final data = <String, dynamic>{
      'code': _codeController.text,
      'discount_amount': double.tryParse(_discountAmountController.text) ?? 0,
      'discount_type': _discountType,
      'is_active': _isActive,
      'is_global': _isGlobal,
    };
    if (_descriptionController.text.isNotEmpty) {
      data['description'] = _descriptionController.text;
    }
    if (_minPurchaseController.text.isNotEmpty) {
      data['min_purchase'] = double.tryParse(_minPurchaseController.text) ?? 0;
    }
    if (_maxUsesController.text.isNotEmpty) {
      data['max_uses'] = int.tryParse(_maxUsesController.text);
    }
    if (_expiresAtController.text.isNotEmpty) {
      data['expires_at'] = _expiresAtController.text;
    }
    if (!_isGlobal && _selectedUserIds.isNotEmpty) {
      data['user_ids'] = _selectedUserIds.toList();
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiary.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(widget.title, style: AppTextStyles.titleMedium),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(l.voucherCode, _codeController, required: true),
                      const SizedBox(height: 12),
                      _buildTextField(l.discount, _discountAmountController, keyboardType: TextInputType.number, required: true),
                      const SizedBox(height: 12),
                      _buildDropdown(l.discountType, _discountType, ['fixed', 'percentage'], (v) => setState(() => _discountType = v!)),
                      const SizedBox(height: 12),
                      _buildTextField(l.minPurchase, _minPurchaseController, keyboardType: TextInputType.number),
                      const SizedBox(height: 12),
                      _buildTextField(l.description, _descriptionController),
                      const SizedBox(height: 12),
                      _buildTextField(l.expiresAt, _expiresAtController),
                      const SizedBox(height: 12),
                      _buildTextField(l.maxUses, _maxUsesController, keyboardType: TextInputType.number),
                      const SizedBox(height: 12),
                      _buildToggle(l.isActive, _isActive, (v) => setState(() => _isActive = v)),
                      const SizedBox(height: 12),
                      _buildToggle(l.isGlobal, _isGlobal, (v) {
                        setState(() => _isGlobal = v);
                        if (v) _selectedUserIds.clear();
                      }),
                      if (!_isGlobal) ...[
                        const SizedBox(height: 12),
                        _buildUserSelector(l),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context, _collectData());
                    }
                  },
                  child: Text(l.save),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool required = false, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      keyboardType: keyboardType,
      validator: required ? (v) => (v == null || v.trim().isEmpty) ? '$label tidak boleh kosong' : null : null,
    );
  }

  Widget _buildDropdown(String label, String initialValue, List<String> options, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildToggle(String label, bool value, ValueChanged<bool> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTextStyles.bodyMedium)),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildUserSelector(AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.selectUsers, style: AppTextStyles.bodyMedium),
        const SizedBox(height: 8),
        TextField(
          controller: _searchUserController,
          decoration: InputDecoration(
            hintText: 'Cari pengguna...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            isDense: true,
          ),
        ),
        const SizedBox(height: 8),
        if (_loadingUsers)
          const Center(child: Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(strokeWidth: 2),
          ))
        else
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.dividerColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _filteredUsers.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(l.noData, style: AppTextStyles.bodySmall),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: _filteredUsers.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final u = _filteredUsers[i];
                      final id = u['id'] is int ? u['id'] as int : int.tryParse('${u['id']}') ?? 0;
                      final name = u['full_name'] ?? u['name'] ?? '-';
                      final email = u['email'] ?? '';
                      final selected = _selectedUserIds.contains(id);
                      return InkWell(
                        onTap: () => _toggleUser(id),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('$name', style: AppTextStyles.bodyMedium),
                                    if (email.isNotEmpty)
                                      Text(email, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                                  ],
                                ),
                              ),
                              if (selected)
                                const Icon(Icons.check_circle, color: Colors.green, size: 22)
                              else
                                const Icon(Icons.circle_outlined, color: Colors.grey, size: 22),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        if (_selectedUserIds.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text('${_selectedUserIds.length} pengguna dipilih', style: AppTextStyles.bodySmall),
        ],
      ],
    );
  }
}
