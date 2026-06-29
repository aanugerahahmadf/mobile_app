import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_country_picker_field.dart';
import '../../../../core/widgets/app_region_picker_field.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  final String? type;
  final String? id;

  const CheckoutPage({super.key, this.type, this.id});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _notesController = TextEditingController();
  final _voucherController = TextEditingController();

  int _currentStep = 0;
  bool _loadingItem = false;
  bool _submitting = false;
  bool _voucherValid = false;
  bool _voucherChecking = false;

  final _countryController = TextEditingController();
  final _addressController = TextEditingController();

  int? _provinceId;
  int? _cityId;
  int? _districtId;
  int? _villageId;
  String _provinceName = '';
  String _cityName = '';
  String _districtName = '';
  String _villageName = '';
  String _postalCode = '';

  DateTime? _eventDate;
  TimeOfDay? _eventTime;
  int _quantity = 1;
  int _discountAmount = 0;

  Map<String, dynamic>? _itemData;
  Map<String, dynamic>? _voucherData;

  @override
  void initState() {
    super.initState();
    final authState = ref.read(authProvider);
    final user = authState is AuthAuthenticated ? authState.user : null;
    _nameController.text = user?.fullName ?? '';
    _whatsappController.text = user?.whatsapp ?? '';

    if (widget.type != null && widget.id != null) {
      _fetchItem();
    } else {
      _loadFromCart();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _whatsappController.dispose();
    _notesController.dispose();
    _voucherController.dispose();
    _countryController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _fetchItem() async {
    setState(() => _loadingItem = true);
    try {
      final endpoint = widget.type == 'packages'
          ? ApiEndpoints.packageDetail(widget.id!)
          : ApiEndpoints.productDetail(widget.id!);
      final res = await DioClient.instance.get(endpoint);
      final data = res.data['data'] as Map<String, dynamic>? ?? {};
      setState(() => _itemData = data);
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(context, 'Gagal memuat data item', type: SnackBarType.error);
      }
    } finally {
      if (mounted) setState(() => _loadingItem = false);
    }
  }

  Future<void> _loadFromCart() async {
    try {
      final res = await DioClient.instance.get(ApiEndpoints.cart);
      final items = (res.data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      if (items.isNotEmpty) {
        final first = items.first;
        final itemData = (first['package'] ?? first['product']) as Map<String, dynamic>?;
        setState(() {
          _itemData = itemData;
          _quantity = (first['quantity'] as int?) ?? 1;
        });
      }
    } catch (_) {}
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _eventDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('id', 'ID'),
    );
    if (picked != null) setState(() => _eventDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _eventTime ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) setState(() => _eventTime = picked);
  }

  Future<void> _checkVoucher() async {
    final code = _voucherController.text.trim();
    if (code.isEmpty) {
      setState(() { _voucherValid = false; _voucherData = null; _discountAmount = 0; });
      return;
    }
    setState(() => _voucherChecking = true);
    try {
      final res = await DioClient.instance.get(ApiEndpoints.vouchers, queryParameters: {'code': code});
      final data = res.data['data'] as Map<String, dynamic>?;
      if (data != null && data['is_valid'] == true) {
        final total = _getTotalPrice();
        final discType = data['discount_type'] as String? ?? 'fixed';
        final discValueRaw = data['discount_amount'];
        final discValue = discValueRaw is num
            ? discValueRaw.toInt()
            : (discValueRaw is String ? (double.tryParse(discValueRaw)?.toInt() ?? 0) : 0);
        final amount = discType == 'percentage' ? (total * discValue ~/ 100) : discValue;
        setState(() {
          _voucherValid = true;
          _voucherData = data;
          _discountAmount = amount > total ? total : amount;
        });
      } else {
        setState(() { _voucherValid = false; _voucherData = null; _discountAmount = 0; });
        if (mounted) AppSnackBar.show(context, 'Voucher tidak valid', type: SnackBarType.warning);
      }
    } catch (e) {
      setState(() { _voucherValid = false; _voucherData = null; _discountAmount = 0; });
    } finally {
      if (mounted) setState(() => _voucherChecking = false);
    }
  }

  int _getItemPrice() {
    if (_itemData != null) {
      final priceRaw = _itemData!['price'];
      return priceRaw is num
          ? priceRaw.toInt()
          : (priceRaw is String ? (double.tryParse(priceRaw)?.toInt() ?? 0) : 0);
    }
    return 0;
  }

  int _getTotalPrice() {
    return _getItemPrice() * _quantity;
  }

  int _getFinalPrice() {
    return _getTotalPrice() - _discountAmount;
  }

  String _getItemName() {
    return _itemData?['name'] as String? ?? '';
  }

  String _getItemImage() {
    final media = _itemData?['media'] as List? ?? [];
    final String rawImage;
    if (media.isNotEmpty && media[0] is Map) {
      final m = media[0] as Map;
      rawImage = (m['url'] as String? ?? '').isNotEmpty
          ? m['url'] as String
          : (m['original_url'] as String? ?? '');
    } else {
      rawImage = _itemData?['image'] as String? ?? _itemData?['image_url'] as String? ?? '';
    }
    return Formatters.imageUrl(rawImage);
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _handleCheckout() async {
    setState(() => _submitting = true);
    try {
      final data = <String, dynamic>{
        if (widget.type == 'packages') 'package_id': widget.id! else 'product_id': widget.id!,
        'event_date': _eventDate!.toIso8601String().split('T')[0],
        'event_time': '${_eventTime!.hour.toString().padLeft(2, '0')}:${_eventTime!.minute.toString().padLeft(2, '0')}',
        'quantity': _quantity,
        'notes': _notesController.text.trim(),
        'customer_name': _nameController.text.trim(),
        'whatsapp': _whatsappController.text.trim(),
        'country': _countryController.text.trim(),
        'address': _addressController.text.trim(),
        'province_name': _provinceName,
        'city_name': _cityName,
        'district_name': _districtName,
        'village_name': _villageName,
        'postal_code': _postalCode,
      };
      if (_provinceId != null) data['province_id'] = _provinceId;
      if (_cityId != null) data['city_id'] = _cityId;
      if (_districtId != null) data['district_id'] = _districtId;
      if (_villageId != null) data['village_id'] = _villageId;
      if (_voucherValid && _voucherData != null) {
        data['voucher_code'] = _voucherController.text.trim();
      }

      final res = await DioClient.instance.post(ApiEndpoints.bookings, data: data);
      final respData = res.data as Map<String, dynamic>? ?? {};
      final orderData = respData['data'] as Map<String, dynamic>? ?? respData;
      final orderId = '${orderData['id']}';
      if (orderId.isEmpty) throw Exception('Gagal mendapatkan ID pesanan');

      final snapToken = orderData['snap_token'] as String?;

      if (mounted) {
        AppSnackBar.show(context, 'Pesanan berhasil dibuat', type: SnackBarType.success);
        if (snapToken != null && snapToken.isNotEmpty) {
          context.push('/payment/$orderId', extra: {'snap_token': snapToken});
        } else {
          context.push('/payment/$orderId');
        }
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(context, 'Gagal membuat pesanan', type: SnackBarType.error);
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getStepTitle()),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: _loadingItem
          ? const Center(child: AppShimmer(height: 400))
          : Column(
              children: [
                _buildStepIndicator(),
                const Divider(height: 1),
                Expanded(
                  child: _buildStepContent(),
                ),
              ],
            ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0: return 'Detail Acara';
      case 1: return 'Info Kontak';
      case 2: return 'Voucher & Diskon';
      case 3: return 'Konfirmasi';
      default: return 'Checkout';
    }
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg, vertical: AppSizes.md),
      child: Row(
        children: [
          for (int i = 0; i < 4; i++) ...[
            // Circle indikator step
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (i <= _currentStep) ? AppColors.primaryColor : Colors.grey[300],
              ),
              child: Center(
                child: (i < _currentStep)
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : Text(
                        '${i + 1}',
                        style: TextStyle(
                          color: (i <= _currentStep) ? Colors.white : Colors.grey[600],
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            // Garis penghubung (hanya jika bukan step terakhir)
            if (i < 3)
              Expanded(
                child: Container(
                  height: 2,
                  color: (i < _currentStep) ? AppColors.primaryColor : Colors.grey[300],
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_currentStep == 0) _buildStep1(),
            if (_currentStep == 1) _buildStep2(),
            if (_currentStep == 2) _buildStep3(),
            if (_currentStep == 3) _buildStep4(),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildItemPreview(),
        SizedBox(height: AppSizes.lg),
        Text('Tanggal Acara', style: AppTextStyles.titleSmall),
        const SizedBox(height: 8),
        InkWell(
          onTap: _pickDate,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: AppColors.primaryColor, size: 20),
                SizedBox(width: AppSizes.sm),
                Text(
                  _eventDate != null
                      ? Formatters.date(_eventDate!.toIso8601String())
                      : 'Pilih tanggal acara',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: _eventDate != null ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: AppSizes.md),
        Text('Jam Acara', style: AppTextStyles.titleSmall),
        const SizedBox(height: 8),
        InkWell(
          onTap: _pickTime,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, color: AppColors.primaryColor, size: 20),
                SizedBox(width: AppSizes.sm),
                Text(
                  _eventTime != null
                      ? '${_eventTime!.hour.toString().padLeft(2, '0')}:${_eventTime!.minute.toString().padLeft(2, '0')} WIB'
                      : 'Pilih jam acara',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: _eventTime != null ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: AppSizes.md),
        Text('Jumlah', style: AppTextStyles.titleSmall),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
              icon: Icon(Icons.remove_circle_outline, color: _quantity > 1 ? AppColors.primaryColor : Colors.grey[300]),
            ),
            Text('$_quantity', style: AppTextStyles.titleLarge),
            IconButton(
              onPressed: () => setState(() => _quantity++),
              icon: Icon(Icons.add_circle_outline, color: AppColors.primaryColor),
            ),
          ],
        ),
        SizedBox(height: AppSizes.md),
        AppTextField(
          label: 'Catatan (opsional)',
          controller: _notesController,
          maxLines: 3,
        ),
        SizedBox(height: AppSizes.md),
        AppCountryPickerField(
          label: 'Negara',
          controller: _countryController,
          onChanged: (_) => setState(() {}),
        ),
        SizedBox(height: AppSizes.sm),
        AppRegionPickerField(
          country: _countryController.text,
          onProvinceIdChanged: (v) => setState(() => _provinceId = v),
          onCityIdChanged: (v) => setState(() => _cityId = v),
          onDistrictIdChanged: (v) => setState(() => _districtId = v),
          onVillageIdChanged: (v) => setState(() => _villageId = v),
          onProvinceNameChanged: (v) => setState(() => _provinceName = v),
          onCityNameChanged: (v) => setState(() => _cityName = v),
          onDistrictNameChanged: (v) => setState(() => _districtName = v),
          onVillageNameChanged: (v) => setState(() => _villageName = v),
          onPostalCodeChanged: (v) => setState(() => _postalCode = v),
        ),
        SizedBox(height: AppSizes.sm),
        AppTextField(
          label: 'Alamat Lengkap',
          controller: _addressController,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Informasi Kontak', style: AppTextStyles.titleMedium),
        SizedBox(height: AppSizes.sm),
        Text('Pastikan data kontak Anda benar', style: AppTextStyles.bodySmall),
        SizedBox(height: AppSizes.lg),
        AppTextField(
          label: 'Nama Lengkap',
          controller: _nameController,
          readOnly: true,
          validator: Validators.required,
        ),
        SizedBox(height: AppSizes.md),
        AppTextField(
          label: 'Nomor WhatsApp',
          controller: _whatsappController,
          keyboardType: TextInputType.phone,
          validator: Validators.phone,
        ),
        SizedBox(height: AppSizes.md),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.infoColor.withAlpha(20),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.infoColor, size: 18),
              SizedBox(width: AppSizes.sm),
              Expanded(
                child: Text('Nomor WhatsApp akan digunakan untuk notifikasi pesanan', style: AppTextStyles.bodySmall),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    final total = _getTotalPrice();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Voucher Diskon', style: AppTextStyles.titleMedium),
        SizedBox(height: AppSizes.sm),
        Text('Masukkan kode voucher untuk mendapatkan diskon', style: AppTextStyles.bodySmall),
        SizedBox(height: AppSizes.lg),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: 'Kode Voucher',
                controller: _voucherController,
              ),
            ),
            SizedBox(width: AppSizes.sm),
            AppButton(
              label: 'Cek',
              onPressed: _voucherChecking ? null : _checkVoucher,
              type: ButtonType.outline,
              loading: _voucherChecking,
            ),
          ],
        ),
        if (_voucherValid) ...[
          SizedBox(height: AppSizes.md),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.successColor.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.successColor.withAlpha(80)),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: AppColors.successColor, size: 20),
                SizedBox(width: AppSizes.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Voucher berhasil diterapkan!', style: AppTextStyles.bodySmall.copyWith(color: AppColors.successColor, fontWeight: FontWeight.w600)),
                      Text('Diskon: ${Formatters.currency(_discountAmount)}', style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        SizedBox(height: AppSizes.lg),
        const Divider(),
        SizedBox(height: AppSizes.sm),
        _buildPriceRow('Subtotal', Formatters.currency(total)),
        if (_voucherValid)
          _buildPriceRow('Diskon Voucher', '- ${Formatters.currency(_discountAmount)}', color: AppColors.successColor),
        const Divider(height: AppSizes.md),
        _buildPriceRow('Total', Formatters.currency(_getFinalPrice()), bold: true),
      ],
    );
  }

  Widget _buildStep4() {
    final total = _getTotalPrice();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ringkasan Pesanan', style: AppTextStyles.titleMedium),
        SizedBox(height: AppSizes.lg),
        _buildSummaryCard(),
        SizedBox(height: AppSizes.md),
        _buildSummaryRow('Item', _getItemName()),
        _buildSummaryRow('Jumlah', '$_quantity'),
        _buildSummaryRow('Tanggal', _eventDate != null ? Formatters.date(_eventDate!.toIso8601String()) : '-'),
        _buildSummaryRow('Jam', _eventTime != null ? '${_eventTime!.hour.toString().padLeft(2, '0')}:${_eventTime!.minute.toString().padLeft(2, '0')} WIB' : '-'),
        _buildSummaryRow('WhatsApp', _whatsappController.text.trim()),
        if (_notesController.text.trim().isNotEmpty)
          _buildSummaryRow('Catatan', _notesController.text.trim()),
        SizedBox(height: AppSizes.lg),
        const Divider(),
        SizedBox(height: AppSizes.sm),
        _buildPriceRow('Subtotal', Formatters.currency(total)),
        if (_voucherValid)
          _buildPriceRow('Diskon Voucher', '- ${Formatters.currency(_discountAmount)}', color: AppColors.successColor),
        const Divider(height: AppSizes.md),
        _buildPriceRow('Total', Formatters.currency(_getFinalPrice()), bold: true),
      ],
    );
  }

  Widget _buildItemPreview() {
    if (_itemData == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor.withAlpha(30),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              _getItemImage(),
              width: 56, height: 56, fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 56, height: 56,
                color: Colors.grey[200],
                child: Icon(Icons.image, color: Colors.grey[400]),
              ),
            ),
          ),
          SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_getItemName(), style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                SizedBox(height: 4),
                Text(Formatters.currency(_getItemPrice()), style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor.withAlpha(30),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  _getItemImage(),
                  width: 48, height: 48, fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 48, height: 48,
                    color: Colors.grey[200],
                    child: Icon(Icons.image, color: Colors.grey[400]),
                  ),
                ),
              ),
              SizedBox(width: AppSizes.sm),
              Expanded(child: Text(_getItemName(), style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
          ),
          Expanded(child: Text(value, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: bold ? AppTextStyles.titleSmall : AppTextStyles.bodyMedium),
          Text(value, style: (bold ? AppTextStyles.titleMedium : AppTextStyles.bodyMedium).copyWith(color: color)),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final isLastStep = _currentStep == 3;
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.sm, AppSizes.md, AppSizes.md),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              AppButton(
                label: 'Kembali',
                onPressed: _prevStep,
                type: ButtonType.text,
              ),
            if (_currentStep > 0) SizedBox(width: AppSizes.md),
            Expanded(
              child: AppButton(
                label: isLastStep ? 'Konfirmasi & Bayar' : 'Lanjutkan',
                loading: _submitting,
                onPressed: isLastStep ? _handleCheckout : _nextStep,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
