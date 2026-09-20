import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../core/constants/app_sizes/app_sizes.dart';
import '../../../../../core/constants/app_text_styles/app_text_styles.dart';
import '../../../../../core/reference/dropdown_option/dropdown_option.dart';
import '../../../../../core/reference/dropdown_options_provider/dropdown_options_provider.dart';
import '../../../../../core/utils/country_codes/country_codes.dart';
import '../../../../../core/utils/validators/validators.dart';
import '../../../../../core/widgets/app_button/app_button.dart';
import '../../../../../core/widgets/app_country_picker_field/app_country_picker_field.dart';
import '../../../../../core/widgets/app_region_picker_field/app_region_picker_field.dart';
import '../../../../../core/widgets/app_text_field/app_text_field.dart';
import '../../../../../core/widgets/app_options_picker_sheet/app_options_picker_sheet.dart';
import '../../../../../core/widgets/app_date_time_picker/app_date_time_picker.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

/// Membuka formulir pencarian akun hilang (account_issue) yang terstruktur,
/// identik dengan formulir Sign Up / Complete Profile.
/// Mengembalikan data terisi sebagai `Map<String, String>` atau `null` bila dibatalkan.
Future<Map<String, String>?> showAccountRecoveryFormSheet(
  BuildContext context,
) {
  return showModalBottomSheet<Map<String, String>>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (_) => const _AccountRecoveryFormSheet(),
  );
}

class _AccountRecoveryFormSheet extends ConsumerStatefulWidget {
  const _AccountRecoveryFormSheet();

  @override
  ConsumerState<_AccountRecoveryFormSheet> createState() =>
      _AccountRecoveryFormSheetState();
}

class _AccountRecoveryFormSheetState
    extends ConsumerState<_AccountRecoveryFormSheet> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ktpNumberController = TextEditingController();
  final _birthPlaceController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _addressController = TextEditingController();
  final _countryController = TextEditingController();

  String _countryCode = '+62';
  String _identityType = 'ktp';
  String _gender = '';
  String _religion = '';
  String _maritalStatus = '';
  String _occupation = '';
  String _incomeRange = '';
  String _sourceOfFunds = '';

  int? _provinceId;
  int? _cityId;
  int? _districtId;
  int? _villageId;
  String _provinceName = '';
  String _cityName = '';
  String _districtName = '';
  String _villageName = '';
  String _postalCode = '';

  Map<String, List<DropdownOption>> _dropdownOptions = {};
  bool _optionsLoaded = false;

  String get _fullName => [
    _firstNameController.text.trim(),
    _middleNameController.text.trim(),
    _lastNameController.text.trim(),
  ].where((s) => s.isNotEmpty).join(' ');

  String get _idLabel {
    final l = AppLocalizations.of(context)!;
    switch (_identityType) {
      case 'ktp':
        return l.identityNumberKtp;
      case 'passport':
        return l.identityNumberPassport;
      case 'sim':
        return l.identityNumberSim;
      case 'npwp':
        return l.identityNumberNpwp;
      default:
        return l.idNumber;
    }
  }

  String get _identityTypeLabel {
    final l = AppLocalizations.of(context)!;
    switch (_identityType) {
      case 'ktp':
        return l.idCardKtp;
      case 'passport':
        return l.passport;
      case 'sim':
        return l.idCardSim;
      case 'npwp':
        return l.idCardNpwp;
      default:
        return l.selectIdentityType;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _ktpNumberController.dispose();
    _birthPlaceController.dispose();
    _motherNameController.dispose();
    _whatsappController.dispose();
    _addressController.dispose();
    _countryController.dispose();
    super.dispose();
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

  List<String> _optLabels(String type, List<String> fallback) {
    return _dropdownOptions[type]?.map((o) => o.label).toList() ?? fallback;
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

  Widget _buildIdentityTypePicker() {
    final l = AppLocalizations.of(context)!;
    final options = [l.idCardKtp, l.passport, l.idCardSim, l.idCardNpwp];
    final currentLabel = switch (_identityType) {
      'ktp' => l.idCardKtp,
      'passport' => l.passport,
      'sim' => l.idCardSim,
      'npwp' => l.idCardNpwp,
      _ => l.selectIdentityType,
    };
    final icon = switch (_identityType) {
      'ktp' => Icons.credit_card,
      'passport' => Icons.card_travel,
      'sim' => Icons.drive_eta,
      'npwp' => Icons.receipt_long,
      _ => Icons.credit_card,
    };
    return Builder(
      builder: (fieldCtx) => GestureDetector(
        onTap: () => _showDropdown(
          fieldCtx,
          l.selectIdentityType,
          options,
          currentLabel,
          (v) {
            setState(() {
              if (v == l.passport) {
                _identityType = 'passport';
              } else if (v == l.idCardSim) {
                _identityType = 'sim';
              } else if (v == l.idCardNpwp) {
                _identityType = 'npwp';
              } else {
                _identityType = 'ktp';
              }
            });
          },
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.secondaryColor.withAlpha(30),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.dividerColor),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primaryColor, size: 22),
              SizedBox(width: AppSizes.md),
              Expanded(
                child: Text(
                  currentLabel,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required IconData icon,
    required String value,
    required List<String> options,
    required ValueChanged<String> onSelected,
  }) {
    return Builder(
      builder: (fieldCtx) => GestureDetector(
        onTap: () => _showDropdown(fieldCtx, hint, options, value, onSelected),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.secondaryColor.withAlpha(30),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.dividerColor),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primaryColor, size: 22),
              SizedBox(width: AppSizes.md),
              Expanded(
                child: Text(
                  value.isEmpty ? label : value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    final l = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Builder(
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
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
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
          ),
        ),
      ),
    );
  }

  String _extractBirthPlace(String combined) {
    final t = combined.trim();
    final m = RegExp(r'[,\s]*\d{2}/\d{2}/\d{4}\s*$').firstMatch(t);
    if (m != null) return t.substring(0, m.start).trim();
    return t;
  }

  String _extractBirthDate(String combined) {
    final m = RegExp(
      r'(\d{2})/(\d{2})/(\d{4})\s*$',
    ).firstMatch(combined.trim());
    if (m == null) return '';
    return m.group(0)!.trim();
  }

  void _submit() {
    final l = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (_birthPlaceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.dateOfBirthRequired)));
      return;
    }
    final data = <String, String>{
      'email': _emailController.text.trim(),
      'username': _usernameController.text.trim(),
      'fullName': _fullName,
      'identityType': _identityTypeLabel,
      'identityNumber': _ktpNumberController.text.trim(),
      'birthPlace': _extractBirthPlace(_birthPlaceController.text),
      'birthDate': _extractBirthDate(_birthPlaceController.text),
      'motherName': _motherNameController.text.trim(),
      'whatsapp': '$_countryCode ${_whatsappController.text.trim()}',
      'country': _countryController.text.trim(),
      'address': _addressController.text.trim(),
      'gender': _gender,
      'religion': _religion,
      'maritalStatus': _maritalStatus,
      'occupation': _occupation,
      'incomeRange': _incomeRange,
      'sourceOfFunds': _sourceOfFunds,
    };
    final region = [
      _provinceName,
      _cityName,
      _districtName,
      _villageName,
    ].where((s) => s.isNotEmpty).join(', ');
    if (region.isNotEmpty) data['region'] = region;
    if (_provinceId != null) data['provinceId'] = '$_provinceId';
    if (_cityId != null) data['cityId'] = '$_cityId';
    if (_districtId != null) data['districtId'] = '$_districtId';
    if (_villageId != null) data['villageId'] = '$_villageId';
    if (_provinceName.isNotEmpty) data['province'] = _provinceName;
    if (_cityName.isNotEmpty) data['city'] = _cityName;
    if (_districtName.isNotEmpty) data['district'] = _districtName;
    if (_villageName.isNotEmpty) data['village'] = _villageName;
    if (_postalCode.isNotEmpty) data['postalCode'] = _postalCode;
    Navigator.of(context).pop(data);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    if (!_optionsLoaded) {
      ref.read(dropdownOptionsProvider.future).then((opts) {
        if (mounted) {
          setState(() {
            _dropdownOptions = opts;
            _optionsLoaded = true;
          });
        }
      });
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSizes.inputRadius + 10),
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.92,
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiary.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md,
                vertical: AppSizes.md,
              ),
              child: Text(
                l.csAccountFormTitle,
                style: AppTextStyles.titleLarge.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
              child: Text(
                l.csAccountFormSubtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppSizes.lg,
                  AppSizes.sm,
                  AppSizes.lg,
                  AppSizes.md + MediaQuery.of(context).padding.bottom,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextField(
                        label: l.username,
                        controller: _usernameController,
                        validator: Validators.required,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: AppSizes.md),
                      AppTextField(
                        label: l.email,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.email,
                      ),
                      const SizedBox(height: AppSizes.md),
                      Text(l.fullName, style: AppTextStyles.titleSmall),
                      const SizedBox(height: AppSizes.sm),
                      AppTextField(
                        label: l.firstName,
                        controller: _firstNameController,
                        validator: Validators.required,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: AppSizes.md),
                      AppTextField(
                        label: l.middleName,
                        controller: _middleNameController,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: AppSizes.md),
                      AppTextField(
                        label: l.lastName,
                        controller: _lastNameController,
                        validator: Validators.required,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: AppSizes.sm),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _fullName.isNotEmpty
                              ? AppColors.successColor.withAlpha(15)
                              : AppColors.secondaryColor.withAlpha(30),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _fullName.isNotEmpty
                                ? AppColors.successColor.withAlpha(60)
                                : AppColors.dividerColor,
                          ),
                        ),
                        child: Text(
                          '${l.fullName}: ${_fullName.isNotEmpty ? _fullName : l.yourNameAppearsHere}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: _fullName.isNotEmpty
                                ? AppColors.successColor
                                : AppColors.textTertiary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.md),
                      Text(
                        l.selectIdentityType,
                        style: AppTextStyles.titleSmall,
                      ),
                      const SizedBox(height: AppSizes.sm),
                      _buildIdentityTypePicker(),
                      const SizedBox(height: AppSizes.md),
                      AppTextField(
                        label: _idLabel,
                        controller: _ktpNumberController,
                        keyboardType: _identityType == 'ktp'
                            ? TextInputType.number
                            : TextInputType.text,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return l.idNumberRequired;
                          }
                          if (_identityType == 'ktp' && v.trim().length != 16) {
                            return l.ktpNumberMustBe16Digits;
                          }
                          if (_identityType == 'sim' && v.trim().length < 6) {
                            return l.simMin6Chars;
                          }
                          if (_identityType == 'npwp' && v.trim().length < 15) {
                            return l.npwpMin15Chars;
                          }
                          if (!['ktp', 'sim', 'npwp'].contains(_identityType) &&
                              v.trim().length < 6) {
                            return l.passportMin6Chars;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSizes.md),
                      Builder(
                        builder: (fieldCtx) => AppTextField(
                          label: l.placeAndDateOfBirth,
                          controller: _birthPlaceController,
                          validator: (v) =>
                              (v == null || v.trim().isEmpty)
                                  ? l.dateOfBirthRequired
                                  : null,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today, size: 20),
                            onPressed: () async {
                              final picked = await showAppDatePicker(
                                context: fieldCtx,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) {
                                final formatted =
                                    '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                                _birthPlaceController.text =
                                    '${_birthPlaceController.text.trim()}, $formatted';
                                _birthPlaceController.selection =
                                    TextSelection.fromPosition(
                                      TextPosition(
                                        offset:
                                            _birthPlaceController.text.length,
                                      ),
                                    );
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.md),
                      AppTextField(
                        label: l.motherName,
                        controller: _motherNameController,
                      ),
                      const SizedBox(height: AppSizes.md),
                      Text(l.whatsappNumber, style: AppTextStyles.titleSmall),
                      const SizedBox(height: AppSizes.sm),
                      _buildPhoneField(),
                      const SizedBox(height: AppSizes.md),
                      Text(l.gender, style: AppTextStyles.titleSmall),
                      const SizedBox(height: AppSizes.sm),
                      _buildDropdownField(
                        label: l.selectGender,
                        hint: l.selectGender,
                        icon: Icons.people_outlined,
                        value: _gender,
                        options: _optLabels('gender', [l.male, l.female]),
                        onSelected: (v) => setState(() => _gender = v),
                      ),
                      const SizedBox(height: AppSizes.md),
                      Text(l.religionLabel, style: AppTextStyles.titleSmall),
                      const SizedBox(height: AppSizes.sm),
                      _buildDropdownField(
                        label: l.selectReligion,
                        hint: l.selectReligion,
                        icon: Icons.church_outlined,
                        value: _religion,
                        options: _optLabels('religion', [
                          l.islam,
                          l.christian,
                          l.catholic,
                          l.hindu,
                          l.buddha,
                          l.confucian,
                        ]),
                        onSelected: (v) => setState(() => _religion = v),
                      ),
                      const SizedBox(height: AppSizes.md),
                      Text(l.maritalStatus, style: AppTextStyles.titleSmall),
                      const SizedBox(height: AppSizes.sm),
                      _buildDropdownField(
                        label: l.selectMaritalStatus,
                        hint: l.selectMaritalStatus,
                        icon: Icons.favorite_border,
                        value: _maritalStatus,
                        options: _optLabels('marital_status', [
                          l.single,
                          l.married,
                          l.divorced,
                        ]),
                        onSelected: (v) => setState(() => _maritalStatus = v),
                      ),
                      const SizedBox(height: AppSizes.md),
                      Text(l.occupation, style: AppTextStyles.titleSmall),
                      const SizedBox(height: AppSizes.sm),
                      _buildDropdownField(
                        label: l.selectOccupation,
                        hint: l.selectOccupation,
                        icon: Icons.work_outline,
                        value: _occupation,
                        options: _optLabels('occupation', [
                          l.employee,
                          l.entrepreneur,
                          l.student,
                          l.housewife,
                          l.professional,
                          l.other,
                        ]),
                        onSelected: (v) => setState(() => _occupation = v),
                      ),
                      const SizedBox(height: AppSizes.md),
                      Text(l.incomeRange, style: AppTextStyles.titleSmall),
                      const SizedBox(height: AppSizes.sm),
                      _buildDropdownField(
                        label: l.selectIncomeRange,
                        hint: l.selectIncomeRange,
                        icon: Icons.trending_up_outlined,
                        value: _incomeRange,
                        options: _optLabels('income_range', [
                          l.lessThan1M,
                          l.range1to5M,
                          l.range5to10M,
                          l.range10to50M,
                          l.moreThan50M,
                        ]),
                        onSelected: (v) => setState(() => _incomeRange = v),
                      ),
                      const SizedBox(height: AppSizes.md),
                      Text(l.sourceOfFunds, style: AppTextStyles.titleSmall),
                      const SizedBox(height: AppSizes.sm),
                      _buildDropdownField(
                        label: l.selectSourceOfFunds,
                        hint: l.selectSourceOfFunds,
                        icon: Icons.account_balance_wallet_outlined,
                        value: _sourceOfFunds,
                        options: _optLabels('source_of_funds', [
                          l.salary,
                          l.business,
                          l.investment,
                          l.gift,
                          l.other,
                        ]),
                        onSelected: (v) => setState(() => _sourceOfFunds = v),
                      ),
                      const SizedBox(height: AppSizes.md),
                      Text(l.country, style: AppTextStyles.titleSmall),
                      const SizedBox(height: AppSizes.sm),
                      AppCountryPickerField(
                        label: l.country,
                        controller: _countryController,
                      ),
                      const SizedBox(height: AppSizes.md),
                      AppRegionPickerField(
                        country: _countryController.text.isEmpty
                            ? null
                            : _countryController.text,
                        onProvinceIdChanged: (id) => _provinceId = id,
                        onCityIdChanged: (id) => _cityId = id,
                        onDistrictIdChanged: (id) => _districtId = id,
                        onVillageIdChanged: (id) => _villageId = id,
                        onProvinceNameChanged: (v) => _provinceName = v,
                        onCityNameChanged: (v) => _cityName = v,
                        onDistrictNameChanged: (v) => _districtName = v,
                        onVillageNameChanged: (v) => _villageName = v,
                        onPostalCodeChanged: (v) => _postalCode = v,
                      ),
                      AppTextField(
                        label: l.fullAddress,
                        controller: _addressController,
                        maxLines: 2,
                      ),
                      const SizedBox(height: AppSizes.lg),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                AppSizes.md,
                AppSizes.sm,
                AppSizes.md,
                AppSizes.md + MediaQuery.of(context).padding.bottom,
              ),
              decoration: BoxDecoration(color: AppColors.surfaceColor),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: l.cancel,
                      onPressed: () => Navigator.of(context).pop(),
                      type: ButtonType.outline,
                      height: 56,
                    ),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    flex: 2,
                    child: AppButton(
                      label: l.send,
                      onPressed: _submit,
                      type: ButtonType.primary,
                      height: 56,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
