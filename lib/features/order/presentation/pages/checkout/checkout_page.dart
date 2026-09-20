import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/api/api_endpoints/api_endpoints.dart';
import '../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../core/constants/app_sizes/app_sizes.dart';
import '../../../../../core/constants/app_text_styles/app_text_styles.dart';
import '../../../../../core/errors/app_error_codes/app_error_codes.dart';
import '../../../../../core/widgets/app_button/app_button.dart';
import '../../../../../core/widgets/app_snackbar/app_snackbar.dart';
import '../../../../../core/widgets/app_country_picker_field/app_country_picker_field.dart';
import '../../../../../core/widgets/app_region_picker_field/app_region_picker_field.dart';
import '../../../../../core/widgets/app_text_field/app_text_field.dart';
import '../../../../../core/widgets/app_options_picker_sheet/app_options_picker_sheet.dart';
import '../../../../../core/widgets/app_date_time_picker/app_date_time_picker.dart';
import '../../../../../core/utils/formatters/formatters.dart';
import '../../../../../core/utils/guest_mode/guest_mode.dart';
import '../../../../../core/utils/validators/validators.dart';
import '../../../../../core/utils/country_codes/country_codes.dart';
import '../../../../../core/widgets/guest_auth_prompt/guest_auth_prompt.dart';
import '../../../../../core/widgets/app_shimmer/app_shimmer.dart';
import '../../../../../core/api/dio_client/dio_client.dart';
import '../../../../auth/presentation/providers/auth_provider/auth_provider.dart';
import '../../../../auth/presentation/widgets/auth_modals/auth_modals.dart';
import '../../../../voucher/presentation/providers/voucher_provider/voucher_provider.dart';
import '../../../../voucher/data/models/voucher_model/voucher_model.dart';
import '../../../../payment/domain/payment_method_info/payment_method_info.dart';
import '../../../../payment/presentation/widgets/payment_method_selector/payment_method_selector.dart';
import '../../../../payment/presentation/widgets/upload_payment_proof/upload_payment_proof.dart';

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

  final _countryController = TextEditingController();
  final _addressController = TextEditingController();

  String _countryCode = '+62';

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
  VoucherModel? _appliedVoucher;

  Map<String, dynamic>? _orderData;
  String? _orderId;
  bool _paymentConfirmed = false;
  bool _paymentPending = false;
  bool _navLock = false;

  bool get _orderIsPaid {
    final ps = '${_orderData?['payment_status'] ?? ''}';
    return ps == 'paid' || ps == 'success' || ps == 'completed';
  }

  bool get _orderIsPending =>
      '${_orderData?['payment_status'] ?? ''}' == 'pending';

  @override
  void initState() {
    super.initState();
    final authState = ref.read(authProvider);
    if (authState is! AuthAuthenticated) {
      return;
    }
    final user = authState.user;
    _nameController.text = user.fullName;
    final rawWa = (user.whatsapp ?? '').trim().replaceAll(
      RegExp(r'[\s\-()]'),
      '',
    );
    _countryCode = _parseDialCode(rawWa);
    _whatsappController.text = _digitsAfterDialCode(rawWa);

    Future.microtask(() => ref.read(voucherProvider.notifier).fetchVouchers());

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

  String _parseDialCode(String rawWa) {
    if (rawWa.isEmpty) return '+62';
    for (final c in countryCodes) {
      if (rawWa.startsWith(c.dialCode.replaceAll('+', ''))) return c.dialCode;
    }
    return '+62';
  }

  String _digitsAfterDialCode(String rawWa) {
    if (rawWa.isEmpty) return '';
    for (final c in countryCodes) {
      final code = c.dialCode.replaceAll('+', '');
      if (rawWa.startsWith(code)) return rawWa.substring(code.length);
    }
    return rawWa;
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
        AppSnackBar.show(
          context,
          AppLocalizations.of(context)!.failedLoadItem,
          type: SnackBarType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _loadingItem = false);
    }
  }

  Future<void> _loadFromCart() async {
    try {
      final res = await DioClient.instance.get(ApiEndpoints.cart);
      final items =
          (res.data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      if (items.isNotEmpty) {
        final first = items.first;
        final itemData =
            (first['package'] ?? first['product']) as Map<String, dynamic>?;
        setState(() {
          _itemData = itemData;
          _quantity = (first['quantity'] as int?) ?? 1;
        });
      }
    } catch (_) {}
  }

  Future<void> _pickDate(BuildContext fieldCtx) async {
    final picked = await showAppDatePicker(
      context: fieldCtx,
      initialDate: _eventDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
      emphasizeAvailable: true,
      isCheckout: true,
      isBirthday: false,
    );
    if (picked != null) setState(() => _eventDate = picked);
  }

  Future<void> _pickTime(BuildContext fieldCtx) async {
    final picked = await showAppTimePicker(
      context: fieldCtx,
      initialTime: _eventTime ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) setState(() => _eventTime = picked);
  }

  Future<void> _checkVoucher() async {
    final l = AppLocalizations.of(context)!;
    final code = _voucherController.text.trim();
    if (code.isEmpty) {
      setState(() {
        _voucherValid = false;
        _appliedVoucher = null;
        _discountAmount = 0;
      });
      return;
    }
    try {
      final voucherState = ref.read(voucherProvider);
      final voucher = voucherState.vouchers
          .where((v) => v.code == code)
          .firstOrNull;

      if (voucher != null && voucher.isActive && !voucher.isExpired) {
        final total = _getBaseTotal();
        final amount = voucher.calculateDiscount(total.toDouble()).toInt();
        setState(() {
          _voucherValid = true;
          _appliedVoucher = voucher;
          _discountAmount = amount > total ? total : amount;
        });
      } else {
        final fallback = await _checkVoucherFallback(code);
        if (!fallback) {
          setState(() {
            _voucherValid = false;
            _appliedVoucher = null;
            _discountAmount = 0;
          });
          if (mounted) {
            AppSnackBar.show(
              context,
              l.invalidVoucherCode,
              type: SnackBarType.warning,
            );
          }
        }
      }
    } catch (e) {
      setState(() {
        _voucherValid = false;
        _appliedVoucher = null;
        _discountAmount = 0;
      });
    }
  }

  Future<bool> _checkVoucherFallback(String code) async {
    try {
      final total = _getBaseTotal();
      final res = await DioClient.instance.post(
        ApiEndpoints.voucherValidate,
        data: {'code': code, 'amount': total},
      );
      final data = res.data['data'] as Map<String, dynamic>?;
      if (data != null) {
        final voucher = VoucherModel.fromJson(data);
        final amount = voucher.calculateDiscount(total.toDouble()).toInt();
        setState(() {
          _voucherValid = true;
          _appliedVoucher = voucher;
          _discountAmount = amount > total ? total : amount;
        });
        return true;
      }
    } catch (_) {}
    return false;
  }

  int _getItemPrice() {
    if (_itemData != null) {
      final fp = _itemData!['final_price'] ?? _itemData!['discount_price'];
      if (fp != null && fp is num && fp > 0) return fp.toInt();
      final priceRaw = _itemData!['price'];
      return priceRaw is num
          ? priceRaw.toInt()
          : (priceRaw is String
                ? (double.tryParse(priceRaw)?.toInt() ?? 0)
                : 0);
    }
    return 0;
  }

  int _getBaseTotal() => _getItemPrice() * _quantity;

  int _getFinalPrice() {
    return _getBaseTotal() - _discountAmount;
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
      rawImage =
          _itemData?['image'] as String? ??
          _itemData?['image_url'] as String? ??
          '';
    }
    return Formatters.imageUrl(rawImage);
  }

  void _nextStep() {
    final l = AppLocalizations.of(context)!;
    if (_currentStep == 0) {
      if (_eventDate == null || _eventTime == null) {
        AppSnackBar.show(
          context,
          l.selectEventDateTime,
          type: SnackBarType.warning,
        );
        return;
      }
    }
    if (_currentStep == 1) {
      if (!_formKey.currentState!.validate()) return;
    }
    if (_currentStep < 4) {
      setState(() => _currentStep++);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  /// Mode tamu: klik checkout → wajib login/sign up dulu, lalu lanjutkan aksi.
  Future<void> _requireAuthThen(Future<void> Function() action) async {
    final l = AppLocalizations.of(context)!;
    final isGuest = await isGuestModeEnabled();
    final authState = ref.read(authProvider);
    if (isGuest && authState is! AuthAuthenticated) {
      if (!mounted) return;
      await showSignInSheet(context);
      if (!mounted) return;
      // Setelah sheet ditutup, cek ulang: kalau masih belum login, batal.
      final after = ref.read(authProvider);
      if (after is! AuthAuthenticated) {
        AppSnackBar.show(context, l.loginRequired, type: SnackBarType.warning);
        return;
      }
    }
    if (!mounted) return;
    await action();
  }

  Future<void> _handleCheckout() async {
    final l = AppLocalizations.of(context)!;
    setState(() => _submitting = true);
    try {
      if (_eventDate == null || _eventTime == null) {
        throw Exception(l.selectEventDateTime);
      }
      final itemId = widget.id ?? '${_itemData?['id'] ?? ''}';
      if (itemId.isEmpty) throw Exception(AppErrorCodes.failedGetOrderId);
      final isPackage =
          widget.type == 'packages' || _itemData?['type'] == 'package';
      final data = <String, dynamic>{
        if (isPackage) 'package_id': itemId else 'product_id': itemId,
        'event_date': _eventDate!.toIso8601String().split('T')[0],
        'event_time':
            '${_eventTime!.hour.toString().padLeft(2, '0')}:${_eventTime!.minute.toString().padLeft(2, '0')}',
        'quantity': _quantity,
        'notes': _notesController.text.trim(),
        'customer_name': _nameController.text.trim(),
        'whatsapp': '$_countryCode ${_whatsappController.text.trim()}',
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
      if (_voucherValid && _appliedVoucher != null) {
        if (_appliedVoucher!.code != null) {
          data['voucher_code'] = _appliedVoucher!.code;
        }
      }

      final res = await DioClient.instance.post(
        ApiEndpoints.bookings,
        data: data,
      );
      final respData = res.data as Map<String, dynamic>? ?? {};
      final orderData = respData['data'] as Map<String, dynamic>? ?? respData;
      final orderId = '${orderData['id']}';
      if (orderId.isEmpty) throw Exception(AppErrorCodes.failedGetOrderId);

      setState(() {
        _orderId = orderId;
        _orderData = orderData;
        _paymentConfirmed = false;
        _paymentPending = false;
      });
      setState(() => _currentStep = 4);
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(context, l.orderFailed, type: SnackBarType.error);
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _refreshAfterUpload() async {
    if (_orderId == null || !mounted) return;
    try {
      final updated = await DioClient.instance.get(
        ApiEndpoints.bookingDetail(_orderId!),
      );
      final data = updated.data['data'] as Map<String, dynamic>? ?? {};
      if (!mounted) return;
      setState(() {
        _orderData = data;
        final ps = '${data['payment_status'] ?? ''}';
        _paymentConfirmed =
            ps == 'paid' || ps == 'success' || ps == 'completed';
        _paymentPending = ps == 'pending';
      });
    } catch (_) {}
  }

  Future<void> _openPaymentMethod(PaymentMethodInfo method) async {
    if (_orderId == null || _navLock) return;
    _navLock = true;
    try {
      final reload = await context.push<bool>(
        '/payment-method/$_orderId',
        extra: method,
      );
      if (reload != true || !mounted) return;
      try {
        final updated = await DioClient.instance.get(
          ApiEndpoints.bookingDetail(_orderId!),
        );
        final data = updated.data['data'] as Map<String, dynamic>? ?? {};
        final ps = '${data['payment_status'] ?? ''}';
        setState(() {
          _orderData = data;
          _paymentConfirmed =
              ps == 'paid' || ps == 'success' || ps == 'completed';
          _paymentPending = ps == 'pending';
        });
      } catch (_) {
        if (mounted) {
          AppSnackBar.show(
            context,
            AppLocalizations.of(context)!.orderFailed,
            type: SnackBarType.error,
          );
        }
      }
    } finally {
      _navLock = false;
    }
  }

  List<String> _countryCodeOptions() =>
      countryCodes.map((c) => '${c.flag} ${c.name} (${c.dialCode})').toList();

  String _countryCodeLabel() {
    for (final c in countryCodes) {
      if (c.dialCode == _countryCode) {
        return '${c.flag} ${c.name} (${c.dialCode})';
      }
    }
    return _countryCode;
  }

  String? _dialCodeFromOption(String option) {
    for (final c in countryCodes) {
      if ('${c.flag} ${c.name} (${c.dialCode})' == option) return c.dialCode;
    }
    return null;
  }

  void _showDropdown(
    BuildContext fieldContext,
    String title,
    List<String> options,
    String currentValue,
    Function(String) onSelected,
  ) {
    showAppOptionsPicker(
      fieldContext,
      title: title,
      options: options,
      currentValue: currentValue,
      onSelected: onSelected,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(authProvider) is! AuthAuthenticated) {
      final l = AppLocalizations.of(context)!;
      return Scaffold(
        appBar: AppBar(
          title: Text(l.checkout),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: const GuestAuthPrompt(icon: Icons.shopping_bag_outlined),
      );
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(_getStepTitle()),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _loadingItem
          ? const Center(child: AppShimmer(height: 400))
          : Column(
              children: [
                _buildStepIndicator(),
                const Divider(height: 1),
                Expanded(child: _buildStepContent()),
              ],
            ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  String _getStepTitle() {
    final l = AppLocalizations.of(context)!;
    if (_currentStep == 4) {
      if (_paymentConfirmed || _orderIsPaid) return l.paymentSuccess;
      if (_paymentPending || _orderIsPending) return l.waitingVerification;
      return l.paymentMethod;
    }
    switch (_currentStep) {
      case 0:
        return l.eventDetail;
      case 1:
        return l.contactInfo;
      case 2:
        return l.voucherAndDiscount;
      case 3:
        return l.paymentConfirmation;
      default:
        return l.checkout;
    }
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.lg,
        vertical: AppSizes.md,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (int i = 0; i < 5; i++) ...[
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (i <= _currentStep)
                      ? AppColors.primaryColor
                      : AppColors.dividerColor,
                ),
                child: Center(
                  child: (i < _currentStep)
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : Text(
                          '${i + 1}',
                          style: TextStyle(
                            color: (i <= _currentStep)
                                ? Colors.white
                                : AppColors.textTertiary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              if (i < 4)
                Container(
                  width: 48,
                  height: 2,
                  color: (i < _currentStep)
                      ? AppColors.primaryColor
                      : AppColors.dividerColor,
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    if (_currentStep == 4) return _buildStep5();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
    final l = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildItemPreview(),
        SizedBox(height: AppSizes.lg),
        Text(l.eventDate, style: AppTextStyles.titleSmall),
        const SizedBox(height: 8),
        Builder(
          builder: (fieldCtx) => InkWell(
            onTap: () => _pickDate(fieldCtx),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.dividerColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                  SizedBox(width: AppSizes.sm),
                  Text(
                    _eventDate != null
                        ? Formatters.date(_eventDate!.toIso8601String())
                        : l.selectEventDate,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: _eventDate != null
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: AppSizes.md),
        Text(l.eventTime, style: AppTextStyles.titleSmall),
        const SizedBox(height: 8),
        Builder(
          builder: (fieldCtx) => InkWell(
            onTap: () => _pickTime(fieldCtx),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.dividerColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                  SizedBox(width: AppSizes.sm),
                  Text(
                    _eventTime != null
                        ? '${_eventTime!.hour.toString().padLeft(2, '0')}:${_eventTime!.minute.toString().padLeft(2, '0')} ${l.timezoneWIB}'
                        : l.selectEventTime,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: _eventTime != null
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: AppSizes.md),
        Text(l.quantity, style: AppTextStyles.titleSmall),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              onPressed: _quantity > 1
                  ? () => setState(() => _quantity--)
                  : null,
              icon: Icon(
                Icons.remove_circle_outline,
                color: _quantity > 1
                    ? AppColors.primaryColor
                    : AppColors.dividerColor,
              ),
            ),
            Text('$_quantity', style: AppTextStyles.titleLarge),
            IconButton(
              onPressed: () => setState(() => _quantity++),
              icon: Icon(
                Icons.add_circle_outline,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.md),
        AppTextField(
          label: '${l.notes} (${l.optional})',
          controller: _notesController,
          maxLines: 3,
        ),
        SizedBox(height: AppSizes.md),
        AppCountryPickerField(
          label: l.country,
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
          label: l.fullAddress,
          controller: _addressController,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildStep2() {
    final l = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.contactInformation, style: AppTextStyles.titleMedium),
        SizedBox(height: AppSizes.sm),
        Text(l.contactInfoSubtitle, style: AppTextStyles.bodySmall),
        SizedBox(height: AppSizes.lg),
        AppTextField(
          label: l.fullName,
          controller: _nameController,
          readOnly: true,
          validator: Validators.required,
        ),
        SizedBox(height: AppSizes.md),
        Builder(
          builder: (fieldCtx) => TextFormField(
            controller: _whatsappController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: Validators.phone,
            style: AppTextStyles.bodyLarge,
            decoration: InputDecoration(
              labelText: l.whatsappNumber,
              labelStyle: AppTextStyles.titleSmall,
              prefix: GestureDetector(
                onTap: () => _showDropdown(
                  fieldCtx,
                  l.selectCountryCode,
                  _countryCodeOptions(),
                  _countryCodeLabel(),
                  (v) {
                    final code = _dialCodeFromOption(v);
                    if (code != null) setState(() => _countryCode = code);
                  },
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        flagFromDialCode(_countryCode) ?? '',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _countryCode,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
              border: const OutlineInputBorder(),
            ),
          ),
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
                child: Text(
                  l.whatsappUsedForNotification,
                  style: AppTextStyles.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    final l = AppLocalizations.of(context)!;
    final total = _getBaseTotal();
    final voucherState = ref.watch(voucherProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.voucherDiscount, style: AppTextStyles.titleMedium),
        SizedBox(height: AppSizes.sm),
        Text(l.enterVoucherCode, style: AppTextStyles.bodySmall),
        SizedBox(height: AppSizes.lg),
        AppTextField(
          label: l.voucherCode,
          controller: _voucherController,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _checkVoucher(),
        ),
        if (!voucherState.loading && voucherState.vouchers.isNotEmpty) ...[
          SizedBox(height: AppSizes.md),
          Text(l.myVouchers, style: AppTextStyles.titleSmall),
          SizedBox(height: AppSizes.sm),
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: voucherState.vouchers.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSizes.sm),
              itemBuilder: (_, i) =>
                  _buildVoucherChip(voucherState.vouchers[i], l),
            ),
          ),
        ],
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
                Icon(
                  Icons.check_circle,
                  color: AppColors.successColor,
                  size: 20,
                ),
                SizedBox(width: AppSizes.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.voucherApplied,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.successColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        l.discountLabel.replaceFirst(
                          '%s',
                          Formatters.currency(_discountAmount),
                        ),
                        style: AppTextStyles.bodySmall,
                      ),
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
        _buildPriceRow(l.subtotal, Formatters.currency(total)),
        if (_voucherValid)
          _buildPriceRow(
            l.discountVoucher,
            '- ${Formatters.currency(_discountAmount)}',
            color: AppColors.successColor,
          ),
        const Divider(height: AppSizes.md),
        _buildPriceRow(
          l.total,
          Formatters.currency(_getFinalPrice()),
          bold: true,
        ),
      ],
    );
  }

  Widget _buildStep4() {
    final l = AppLocalizations.of(context)!;
    final total = _getBaseTotal();
    final finalPrice = _getFinalPrice();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildItemPreview(),
        SizedBox(height: AppSizes.lg),
        const Divider(),
        _buildPriceRow(l.subtotal, Formatters.currency(total)),
        if (_voucherValid)
          _buildPriceRow(
            l.discountVoucher,
            '- ${Formatters.currency(_discountAmount)}',
            color: AppColors.successColor,
          ),
        const Divider(height: AppSizes.md),
        _buildPriceRow(l.total, Formatters.currency(finalPrice), bold: true),
        SizedBox(height: AppSizes.sm),
        if (_eventDate != null || _eventTime != null) ...[
          const Divider(),
          if (_eventDate != null)
            _buildPriceRow(
              l.eventDate,
              Formatters.date(_eventDate!.toIso8601String()),
            ),
          if (_eventTime != null)
            _buildPriceRow(
              l.eventTime,
              '${_eventTime!.hour.toString().padLeft(2, '0')}:${_eventTime!.minute.toString().padLeft(2, '0')} ${l.timezoneWIB}',
            ),
        ],
        if (_nameController.text.isNotEmpty ||
            _whatsappController.text.isNotEmpty) ...[
          const Divider(),
          if (_nameController.text.isNotEmpty)
            _buildPriceRow(l.fullName, _nameController.text),
          if (_whatsappController.text.isNotEmpty)
            _buildPriceRow(
              l.whatsapp,
              '$_countryCode ${_whatsappController.text}',
            ),
        ],
      ],
    );
  }

  Widget _buildStep5() {
    final l = AppLocalizations.of(context)!;
    final order = _orderData;
    final payStatus = '${order?['payment_status'] ?? 'unpaid'}';
    final isPaid =
        _paymentConfirmed ||
        payStatus == 'paid' ||
        payStatus == 'success' ||
        payStatus == 'completed';
    final isPending = _paymentPending || payStatus == 'pending';

    final paymentMethods =
        (order?['payment_methods'] as List?)
            ?.cast<Map<String, dynamic>>()
            .map((m) => PaymentMethodInfo.fromJson(m))
            .toList() ??
        [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Sukses ───────────────────────────────────────────────────
          if (isPaid) ...[
            Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 72,
                    color: AppColors.successColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l.paymentSuccess,
                    style: AppTextStyles.titleLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.paymentSuccessDesc,
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  if (_orderId != null)
                    Text(
                      '#$_orderId',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ] else if (isPending) ...[
            Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 72,
                    color: AppColors.warningColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l.waitingVerification,
                    style: AppTextStyles.titleLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.waitingVerificationDesc,
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  if (_orderId != null) ...[
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        label: l.uploadProof,
                        onPressed: () => uploadPaymentProof(
                          context,
                          ref,
                          _orderId!,
                          onUploaded: _refreshAfterUpload,
                        ),
                        type: ButtonType.outline,
                      ),
                    ),
                    const SizedBox(height: AppSizes.sm),
                  ],
                  if (_orderId != null)
                    Text(
                      '#$_orderId',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ] else ...[
            // ── Pilih metode bayar ─────────────────────────────────────
            Text(l.paymentMethod, style: AppTextStyles.titleMedium),
            const SizedBox(height: AppSizes.sm),
            Text(l.selectPaymentMethod, style: AppTextStyles.bodySmall),
            const SizedBox(height: AppSizes.md),
            PaymentMethodSelector(
              methods: paymentMethods,
              selectedId: null,
              onSelect: (id) {
                PaymentMethodInfo? method;
                for (final m in paymentMethods) {
                  if (m.id == id) {
                    method = m;
                    break;
                  }
                }
                if (method != null) _openPaymentMethod(method);
              },
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              l.confirmAfterTransferHint,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVoucherChip(VoucherModel voucher, AppLocalizations l) {
    final isSelected = _appliedVoucher?.id == voucher.id;
    final expired = voucher.isExpired || !voucher.isActive;
    final discountLabel = voucher.isPercentage
        ? '${voucher.discountAmount.toInt()}%'
        : Formatters.currency(voucher.discountAmount.toInt());

    return GestureDetector(
      onTap: expired
          ? null
          : () {
              if (voucher.code != null) _voucherController.text = voucher.code!;
              _checkVoucher();
            },
      child: Container(
        width: 140,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          gradient: expired ? null : AppColors.primaryGradient,
          color: expired
              ? AppColors.dividerColor
              : isSelected
              ? null
              : AppColors.primaryColor.withAlpha(20),
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(color: AppColors.primaryColor, width: 2)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              discountLabel,
              style: AppTextStyles.labelMedium.copyWith(
                color: expired
                    ? AppColors.textTertiary
                    : (isSelected ? Colors.white : AppColors.primaryColor),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              (voucher.name != null && voucher.name!.isNotEmpty)
                  ? voucher.name!
                  : (voucher.code ?? 'Voucher'),
              style: AppTextStyles.labelSmall.copyWith(
                color: expired
                    ? AppColors.textTertiary
                    : (isSelected ? Colors.white70 : AppColors.textSecondary),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
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
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 56,
                height: 56,
                color: AppColors.shimmerBase,
                child: Icon(Icons.image, color: AppColors.textTertiary),
              ),
            ),
          ),
          SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getItemName(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  Formatters.currency(_getItemPrice()),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String value, {
    bool bold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(
            label,
            style: bold ? AppTextStyles.titleSmall : AppTextStyles.bodyMedium,
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style:
                  (bold ? AppTextStyles.titleMedium : AppTextStyles.bodyMedium)
                      .copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildBottomBar() {
    final l = AppLocalizations.of(context)!;
    if (_currentStep == 4) {
      final isPaid = _paymentConfirmed || _orderIsPaid;
      final isPending = _paymentPending || _orderIsPending;

      if (isPaid || isPending) {
        return Container(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.md,
            AppSizes.sm,
            AppSizes.md,
            AppSizes.md,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: l.viewOrder,
                    onPressed: () => context.push('/order/$_orderId'),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return null;
    }
    final isConfirmStep = _currentStep == 3;
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.md,
        AppSizes.sm,
        AppSizes.md,
        AppSizes.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              AppButton(
                label: l.back,
                onPressed: _prevStep,
                type: ButtonType.text,
              ),
            if (_currentStep > 0) SizedBox(width: AppSizes.md),
            Expanded(
              child: AppButton(
                label: isConfirmStep ? l.confirmAndPay : l.proceed,
                loading: _submitting,
                onPressed: isConfirmStep
                    ? () => _requireAuthThen(_handleCheckout)
                    : _nextStep,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
