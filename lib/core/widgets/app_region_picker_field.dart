import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../api/api_endpoints.dart';
import '../api/dio_client.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class RegionData {
  final int id;
  final String code;
  final String name;

  RegionData({required this.id, required this.code, required this.name});

  factory RegionData.fromJson(Map<String, dynamic> json) {
    return RegionData(
      id: json['id'] as int,
      code: json['code'] as String,
      name: json['name'] as String,
    );
  }
}

class WorldRegionItem {
  final String name;
  final String? stateCode;

  const WorldRegionItem({required this.name, this.stateCode});

  factory WorldRegionItem.fromJson(Map<String, dynamic> json) {
    return WorldRegionItem(
      name: json['name'] as String,
      stateCode: json['state_code'] as String?,
    );
  }
}

class GeoItem {
  final String name;
  final int geonameId;

  const GeoItem({required this.name, required this.geonameId});

  factory GeoItem.fromJson(Map<String, dynamic> json) {
    return GeoItem(
      name: json['name'] as String,
      geonameId: json['geonameId'] as int,
    );
  }
}

class PostalCodeItem {
  final String postalCode;
  final String placeName;

  const PostalCodeItem({required this.postalCode, required this.placeName});

  factory PostalCodeItem.fromJson(Map<String, dynamic> json) {
    return PostalCodeItem(
      postalCode: json['postal_code'] as String,
      placeName: json['place_name'] as String? ?? '',
    );
  }
}

class AppRegionPickerField extends StatefulWidget {
  final String? country;
  final int? initialProvinceId;
  final int? initialCityId;
  final int? initialDistrictId;
  final int? initialVillageId;
  final String? initialProvinceName;
  final String? initialCityName;
  final String? initialDistrictName;
  final String? initialVillageName;
  final String? initialPostalCode;
  final ValueChanged<int?> onProvinceIdChanged;
  final ValueChanged<int?> onCityIdChanged;
  final ValueChanged<int?> onDistrictIdChanged;
  final ValueChanged<int?> onVillageIdChanged;
  final ValueChanged<String> onProvinceNameChanged;
  final ValueChanged<String> onCityNameChanged;
  final ValueChanged<String> onDistrictNameChanged;
  final ValueChanged<String> onVillageNameChanged;
  final ValueChanged<String> onPostalCodeChanged;
  final bool readOnly;

  const AppRegionPickerField({
    super.key,
    this.country,
    this.initialProvinceId,
    this.initialCityId,
    this.initialDistrictId,
    this.initialVillageId,
    this.initialProvinceName,
    this.initialCityName,
    this.initialDistrictName,
    this.initialVillageName,
    this.initialPostalCode,
    required this.onProvinceIdChanged,
    required this.onCityIdChanged,
    required this.onDistrictIdChanged,
    required this.onVillageIdChanged,
    required this.onProvinceNameChanged,
    required this.onCityNameChanged,
    required this.onDistrictNameChanged,
    required this.onVillageNameChanged,
    required this.onPostalCodeChanged,
    this.readOnly = false,
  });

  @override
  State<AppRegionPickerField> createState() => _AppRegionPickerFieldState();
}

class _AppRegionPickerFieldState extends State<AppRegionPickerField> {
  final Dio _dio = DioClient.instance;

  // Indonesia DB data
  List<RegionData> _provinces = [];
  List<RegionData> _cities = [];
  List<RegionData> _districts = [];
  List<RegionData> _villages = [];
  RegionData? _selectedProvince;
  RegionData? _selectedCity;
  RegionData? _selectedDistrict;
  RegionData? _selectedVillage;

  // World API data
  List<WorldRegionItem> _worldStates = [];
  List<WorldRegionItem> _worldCities = [];
  WorldRegionItem? _selectedWorldState;
  WorldRegionItem? _selectedWorldCity;

  // GeoNames data (world mode)
  List<GeoItem> _worldDistricts = [];
  List<GeoItem> _worldVillages = [];
  List<PostalCodeItem> _worldPostalCodes = [];
  String? _selectedWorldDistrict;
  String? _selectedWorldVillage;
  String? _selectedWorldPostalCode;

  // Fallback text controllers (world free text when API returns no data)
  final _freeDistrictController = TextEditingController();
  final _freeVillageController = TextEditingController();
  final _freePostalController = TextEditingController();
  final _freeCityController = TextEditingController();
  final _freeStateController = TextEditingController();

  // Loading states
  bool _loadingProvinces = false;
  bool _loadingCities = false;
  bool _loadingDistricts = false;
  bool _loadingVillages = false;
  bool _loadingWorldStates = false;
  bool _loadingWorldCities = false;
  bool _loadingWorldDistricts = false;
  bool _loadingWorldVillages = false;
  bool _loadingWorldPostalCodes = false;

  bool _isIndonesia = false;

  @override
  void initState() {
    super.initState();
    _isIndonesia = (widget.country ?? '').trim() == 'Indonesia';
    _freeDistrictController.text = widget.initialDistrictName ?? '';
    _freeVillageController.text = widget.initialVillageName ?? '';
    _freePostalController.text = widget.initialPostalCode ?? '';
    _freeCityController.text = widget.initialCityName ?? '';
    _freeStateController.text = widget.initialProvinceName ?? '';
    _setupFreeListeners();
    if (_isIndonesia) {
      _fetchProvinces();
    } else if (widget.country != null && widget.country!.isNotEmpty) {
      _fetchWorldStates();
    }
  }

  void _setupFreeListeners() {
    _freeDistrictController.addListener(() {
      widget.onDistrictNameChanged(_freeDistrictController.text);
    });
    _freeVillageController.addListener(() {
      widget.onVillageNameChanged(_freeVillageController.text);
    });
    _freePostalController.addListener(() {
      widget.onPostalCodeChanged(_freePostalController.text);
    });
    _freeCityController.addListener(() {
      widget.onCityNameChanged(_freeCityController.text);
    });
    _freeStateController.addListener(() {
      widget.onProvinceNameChanged(_freeStateController.text);
    });
  }

  @override
  void didUpdateWidget(AppRegionPickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nowIndonesia = (widget.country ?? '').trim() == 'Indonesia';
    final countryChanged = widget.country != oldWidget.country;

    if (nowIndonesia != _isIndonesia || countryChanged) {
      setState(() {
        _isIndonesia = nowIndonesia;
        _selectedProvince = null;
        _selectedCity = null;
        _selectedDistrict = null;
        _selectedVillage = null;
        _selectedWorldState = null;
        _selectedWorldCity = null;
        _worldDistricts = [];
        _worldVillages = [];
        _worldPostalCodes = [];
        _selectedWorldDistrict = null;
        _selectedWorldVillage = null;
        _selectedWorldPostalCode = null;
        _cities = [];
        _districts = [];
        _villages = [];
        _worldStates = [];
        _worldCities = [];
        _freeDistrictController.text = '';
        _freeVillageController.text = '';
        _freePostalController.text = '';
        _freeCityController.text = '';
        _freeStateController.text = '';
        if (nowIndonesia) {
          _fetchProvinces();
        } else if (widget.country != null && widget.country!.isNotEmpty) {
          _fetchWorldStates();
        }
      });
    }
  }

  @override
  void dispose() {
    _freeDistrictController.dispose();
    _freeVillageController.dispose();
    _freePostalController.dispose();
    _freeCityController.dispose();
    _freeStateController.dispose();
    super.dispose();
  }

  // --- Indonesia DB API ---

  Future<void> _fetchProvinces() async {
    setState(() => _loadingProvinces = true);
    try {
      final res = await _dio.get(ApiEndpoints.regionProvinces);
      final list = (res.data['data'] as List).map((e) => RegionData.fromJson(e)).toList();
      if (!mounted) return;
      setState(() { _provinces = list; _loadingProvinces = false; });
      if (widget.initialProvinceId != null) {
        final match = _provinces.where((p) => p.id == widget.initialProvinceId).firstOrNull;
        if (match != null) _selectProvince(match, notify: false);
      }
    } catch (_) {
      if (mounted) setState(() => _loadingProvinces = false);
    }
  }

  Future<void> _fetchCities(String provinceCode) async {
    setState(() => _loadingCities = true);
    try {
      final res = await _dio.get(ApiEndpoints.regionCities(provinceCode));
      final list = (res.data['data'] as List).map((e) => RegionData.fromJson(e)).toList();
      if (!mounted) return;
      setState(() { _cities = list; _loadingCities = false; });
      if (widget.initialCityId != null) {
        final match = _cities.where((c) => c.id == widget.initialCityId).firstOrNull;
        if (match != null) _selectCity(match, notify: false);
      }
    } catch (_) {
      if (mounted) setState(() => _loadingCities = false);
    }
  }

  Future<void> _fetchDistricts(String cityCode) async {
    setState(() => _loadingDistricts = true);
    try {
      final res = await _dio.get(ApiEndpoints.regionDistricts(cityCode));
      final list = (res.data['data'] as List).map((e) => RegionData.fromJson(e)).toList();
      if (!mounted) return;
      setState(() { _districts = list; _loadingDistricts = false; });
      if (widget.initialDistrictId != null) {
        final match = _districts.where((d) => d.id == widget.initialDistrictId).firstOrNull;
        if (match != null) _selectDistrict(match, notify: false);
      }
    } catch (_) {
      if (mounted) setState(() => _loadingDistricts = false);
    }
  }

  Future<void> _fetchVillages(String districtCode) async {
    setState(() => _loadingVillages = true);
    try {
      final res = await _dio.get(ApiEndpoints.regionVillages(districtCode));
      final list = (res.data['data'] as List).map((e) => RegionData.fromJson(e)).toList();
      if (!mounted) return;
      setState(() { _villages = list; _loadingVillages = false; });
      if (widget.initialVillageId != null) {
        final match = _villages.where((v) => v.id == widget.initialVillageId).firstOrNull;
        if (match != null) _selectVillage(match, notify: false);
      }
    } catch (_) {
      if (mounted) setState(() => _loadingVillages = false);
    }
  }

  // --- World API ---

  Future<void> _fetchWorldStates() async {
    setState(() => _loadingWorldStates = true);
    try {
      final res = await _dio.get(ApiEndpoints.worldStates, queryParameters: {'country': widget.country});
      final list = ((res.data['data'] as List?) ?? []).map((e) => WorldRegionItem.fromJson(e)).toList();
      if (!mounted) return;
      setState(() { _worldStates = list; _loadingWorldStates = false; });
      if (widget.initialProvinceName != null && widget.initialProvinceName!.isNotEmpty) {
        final match = _worldStates.where((s) => s.name == widget.initialProvinceName).firstOrNull;
        if (match != null) _selectWorldState(match, notify: false);
      }
    } catch (_) {
      if (mounted) setState(() => _loadingWorldStates = false);
    }
  }

  Future<void> _fetchWorldCities() async {
    if (_selectedWorldState == null) return;
    setState(() { _loadingWorldCities = true; });
    try {
      final res = await _dio.get(ApiEndpoints.worldCities, queryParameters: {
        'country': widget.country,
        'state': _selectedWorldState!.name,
      });
      final list = ((res.data['data'] as List?) ?? []).map((e) => WorldRegionItem.fromJson(e)).toList();
      if (!mounted) return;
      setState(() { _worldCities = list; _loadingWorldCities = false; });
      if (widget.initialCityName != null && widget.initialCityName!.isNotEmpty) {
        final match = _worldCities.where((c) => c.name == widget.initialCityName).firstOrNull;
        if (match != null) _selectWorldCity(match, notify: false);
      }
    } catch (_) {
      if (mounted) setState(() => _loadingWorldCities = false);
    }
  }

  // --- GeoNames API ---

  Future<void> _fetchWorldDistricts() async {
    if (_selectedWorldState == null) return;
    setState(() { _loadingWorldDistricts = true; });
    try {
      final res = await _dio.get(ApiEndpoints.geoAdmin2, queryParameters: {
        'country': widget.country,
        'state': _selectedWorldState!.name,
      });
      final list = ((res.data['data'] as List?) ?? []).map((e) => GeoItem.fromJson(e)).toList();
      if (!mounted) return;
      setState(() { _worldDistricts = list; _loadingWorldDistricts = false; });
      if (widget.initialDistrictName != null && widget.initialDistrictName!.isNotEmpty) {
        final match = _worldDistricts.where((d) => d.name == widget.initialDistrictName).firstOrNull;
        if (match != null) {
          setState(() => _selectedWorldDistrict = match.name);
          _fetchWorldVillages(match.name);
          widget.onDistrictNameChanged(match.name);
        }
      }
    } catch (_) {
      if (mounted) setState(() => _loadingWorldDistricts = false);
    }
  }

  Future<void> _fetchWorldVillages(String districtName) async {
    if (_selectedWorldState == null) return;
    setState(() { _loadingWorldVillages = true; });
    try {
      final res = await _dio.get(ApiEndpoints.geoAdmin3, queryParameters: {
        'country': widget.country,
        'state': _selectedWorldState!.name,
        'district': districtName,
      });
      final list = ((res.data['data'] as List?) ?? []).map((e) => GeoItem.fromJson(e)).toList();
      if (!mounted) return;
      setState(() { _worldVillages = list; _loadingWorldVillages = false; });
      if (widget.initialVillageName != null && widget.initialVillageName!.isNotEmpty) {
        final match = _worldVillages.where((v) => v.name == widget.initialVillageName).firstOrNull;
        if (match != null) {
          setState(() => _selectedWorldVillage = match.name);
          widget.onVillageNameChanged(match.name);
        }
      }
    } catch (_) {
      if (mounted) setState(() => _loadingWorldVillages = false);
    }
  }

  Future<void> _fetchWorldPostalCodes(String cityName) async {
    setState(() { _loadingWorldPostalCodes = true; });
    try {
      final res = await _dio.get(ApiEndpoints.geoPostalCodes, queryParameters: {
        'country': widget.country,
        'city': cityName,
      });
      final list = ((res.data['data'] as List?) ?? []).map((e) => PostalCodeItem.fromJson(e)).toList();
      if (!mounted) return;
      setState(() { _worldPostalCodes = list; _loadingWorldPostalCodes = false; });
      if (widget.initialPostalCode != null && widget.initialPostalCode!.isNotEmpty) {
        final match = _worldPostalCodes.where((p) => p.postalCode == widget.initialPostalCode).firstOrNull;
        if (match != null) {
          setState(() => _selectedWorldPostalCode = match.postalCode);
          widget.onPostalCodeChanged(match.postalCode);
        }
      }
    } catch (_) {
      if (mounted) setState(() => _loadingWorldPostalCodes = false);
    }
  }

  // --- Selection handlers: Indonesia ---

  void _selectProvince(RegionData? province, {bool notify = true}) {
    setState(() {
      _selectedProvince = province;
      _selectedCity = null;
      _selectedDistrict = null;
      _selectedVillage = null;
      _cities = [];
      _districts = [];
      _villages = [];
    });
    if (notify) {
      widget.onProvinceIdChanged(province?.id);
      widget.onProvinceNameChanged(province?.name ?? '');
      widget.onCityIdChanged(null);
      widget.onCityNameChanged('');
      widget.onDistrictIdChanged(null);
      widget.onDistrictNameChanged('');
      widget.onVillageIdChanged(null);
      widget.onVillageNameChanged('');
      _freePostalController.text = '';
      widget.onPostalCodeChanged('');
    }
    if (province != null) _fetchCities(province.code);
  }

  void _selectCity(RegionData? city, {bool notify = true}) {
    setState(() {
      _selectedCity = city;
      _selectedDistrict = null;
      _selectedVillage = null;
      _districts = [];
      _villages = [];
    });
    if (notify) {
      widget.onCityIdChanged(city?.id);
      widget.onCityNameChanged(city?.name ?? '');
      widget.onDistrictIdChanged(null);
      widget.onDistrictNameChanged('');
      widget.onVillageIdChanged(null);
      widget.onVillageNameChanged('');
      _freePostalController.text = '';
      widget.onPostalCodeChanged('');
    }
    if (city != null) _fetchDistricts(city.code);
  }

  void _selectDistrict(RegionData? district, {bool notify = true}) {
    setState(() {
      _selectedDistrict = district;
      _selectedVillage = null;
      _villages = [];
    });
    if (notify) {
      widget.onDistrictIdChanged(district?.id);
      widget.onDistrictNameChanged(district?.name ?? '');
      widget.onVillageIdChanged(null);
      widget.onVillageNameChanged('');
    }
    if (district != null) _fetchVillages(district.code);
  }

  void _selectVillage(RegionData? village, {bool notify = true}) {
    setState(() => _selectedVillage = village);
    if (notify) {
      widget.onVillageIdChanged(village?.id);
      widget.onVillageNameChanged(village?.name ?? '');
    }
  }

  // --- Selection handlers: World ---

  void _selectWorldState(WorldRegionItem? state, {bool notify = true}) {
    setState(() {
      _selectedWorldState = state;
      _selectedWorldCity = null;
      _selectedWorldDistrict = null;
      _selectedWorldVillage = null;
      _selectedWorldPostalCode = null;
      _worldCities = [];
      _worldDistricts = [];
      _worldVillages = [];
      _worldPostalCodes = [];
      _freeDistrictController.text = '';
      _freeVillageController.text = '';
      _freePostalController.text = '';
      _freeCityController.text = '';
      _freeStateController.text = state?.name ?? '';
    });
    if (notify) {
      widget.onProvinceIdChanged(null);
      widget.onProvinceNameChanged(state?.name ?? '');
      widget.onCityIdChanged(null);
      widget.onCityNameChanged('');
      widget.onDistrictIdChanged(null);
      widget.onDistrictNameChanged('');
      widget.onVillageIdChanged(null);
      widget.onVillageNameChanged('');
      widget.onPostalCodeChanged('');
    }
    if (state != null) {
      _fetchWorldCities();
      _fetchWorldDistricts();
    }
  }

  void _selectWorldCity(WorldRegionItem? city, {bool notify = true}) {
    setState(() {
      _selectedWorldCity = city;
      _selectedWorldPostalCode = null;
      _worldPostalCodes = [];
      _freePostalController.text = '';
      _freeCityController.text = city?.name ?? '';
    });
    if (notify) {
      widget.onCityIdChanged(null);
      widget.onCityNameChanged(city?.name ?? '');
      widget.onPostalCodeChanged('');
    }
    if (city != null) {
      _fetchWorldPostalCodes(city.name);
    }
  }

  void _selectWorldDistrict(String? districtName) {
    setState(() {
      _selectedWorldDistrict = districtName;
      _selectedWorldVillage = null;
      _worldVillages = [];
      _freeDistrictController.text = districtName ?? '';
    });
    widget.onDistrictIdChanged(null);
    widget.onDistrictNameChanged(districtName ?? '');
    if (districtName != null && districtName.isNotEmpty) {
      _fetchWorldVillages(districtName);
    } else {
      widget.onVillageNameChanged('');
    }
  }

  void _selectWorldVillage(String? villageName) {
    setState(() {
      _selectedWorldVillage = villageName;
      _freeVillageController.text = villageName ?? '';
    });
    widget.onVillageIdChanged(null);
    widget.onVillageNameChanged(villageName ?? '');
  }

  void _selectWorldPostalCode(String? code) {
    setState(() {
      _selectedWorldPostalCode = code;
      _freePostalController.text = code ?? '';
    });
    widget.onPostalCodeChanged(code ?? '');
  }

  // --- Autocomplete Builder ---

  Widget _buildAutocomplete<T extends Object>({
    required String label,
    required List<T> items,
    required bool loading,
    required Key fieldKey,
    required T? value,
    required String Function(T) labelOf,
    required ValueChanged<T> onSelect,
    VoidCallback? onClear,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          Autocomplete<T>(
            key: fieldKey,
            initialValue: value != null ? TextEditingValue(text: labelOf(value)) : null,
            optionsBuilder: (textEditingValue) {
              if (loading || items.isEmpty) return [];
              final query = textEditingValue.text.toLowerCase();
              if (query.isEmpty) return items.take(100);
              return items
                  .where((o) => labelOf(o).toLowerCase().contains(query))
                  .take(100);
            },
            onSelected: onSelect,
            displayStringForOption: labelOf,
            fieldViewBuilder: (ctx, textController, focusNode, onSubmitted) {
              return TextFormField(
                controller: textController,
                focusNode: focusNode,
                readOnly: widget.readOnly,
                decoration: InputDecoration(
                  suffixIcon: loading
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : (textController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close, size: 18),
                              onPressed: () {
                                textController.clear();
                                onClear?.call();
                              },
                            )
                          : null),
                ),
              );
            },
            optionsViewBuilder: (ctx, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  clipBehavior: Clip.antiAlias,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 200,
                      maxWidth: MediaQuery.of(ctx).size.width - 64,
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: options.length,
                      itemBuilder: (_, i) {
                        final item = options.elementAt(i);
                        final isSelected = value == item;
                        return ListTile(
                          dense: true,
                          selected: isSelected,
                          selectedTileColor: AppColors.primaryColor.withAlpha(20),
                          title: Text(
                            labelOf(item),
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              color: isSelected ? AppColors.primaryColor : AppColors.textPrimary,
                            ),
                          ),
                          onTap: () => onSelected(item),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFreeTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          AbsorbPointer(
            absorbing: widget.readOnly,
            child: TextFormField(controller: controller),
          ),
        ],
      ),
    );
  }

  Widget _buildWorldField({
    required String label,
    required List<String> items,
    required bool loading,
    required String? selectedValue,
    required TextEditingController freeController,
    required ValueChanged<String> onSelect,
  }) {
    if (loading) {
      return _buildAutocomplete<String>(
        label: label,
        items: items,
        loading: true,
        fieldKey: ValueKey('${label}_loading_${items.length}'),
        value: selectedValue,
        labelOf: (s) => s,
        onSelect: onSelect,
      );
    }
    if (items.isNotEmpty) {
      return _buildAutocomplete<String>(
        label: label,
        items: items,
        loading: false,
        fieldKey: ValueKey('${label}_${items.length}_$selectedValue'),
        value: selectedValue,
        labelOf: (s) => s,
        onSelect: onSelect,
      );
    }
    return _buildFreeTextField(label: label, controller: freeController);
  }

  // --- Indonesia child field (handles loading → autocomplete → free text fallback) ---

  Widget _buildIndonesiaChildField({
    required String label,
    required List<RegionData> items,
    required bool loading,
    required RegionData? value,
    required String keyPrefix,
    required ValueChanged<RegionData> onSelect,
    required VoidCallback onClear,
    required TextEditingController freeController,
  }) {
    if (loading) {
      return _buildAutocomplete<RegionData>(
        label: label,
        items: items,
        loading: true,
        fieldKey: ValueKey('${keyPrefix}_loading'),
        value: value,
        labelOf: (r) => r.name,
        onSelect: onSelect,
        onClear: onClear,
      );
    }
    if (items.isNotEmpty) {
      return _buildAutocomplete<RegionData>(
        label: label,
        items: items,
        loading: false,
        fieldKey: ValueKey('${keyPrefix}_${value?.id ?? ''}'),
        value: value,
        labelOf: (r) => r.name,
        onSelect: onSelect,
        onClear: onClear,
      );
    }
    return _buildFreeTextField(label: label, controller: freeController);
  }

  // --- Build ---

  @override
  Widget build(BuildContext context) {
    if (_isIndonesia) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAutocomplete<RegionData>(
            label: 'Provinsi',
            items: _provinces,
            loading: _loadingProvinces,
            fieldKey: const ValueKey('province'),
            value: _selectedProvince,
            labelOf: (p) => p.name,
            onSelect: _selectProvince,
            onClear: () => _selectProvince(null),
          ),
          _buildIndonesiaChildField(
            label: 'Kota / Kabupaten',
            items: _cities,
            loading: _loadingCities,
            value: _selectedCity,
            keyPrefix: 'city_${_selectedProvince?.id ?? 0}',
            onSelect: _selectCity,
            onClear: () => _selectCity(null),
            freeController: _freeCityController,
          ),
          _buildIndonesiaChildField(
            label: 'Kecamatan',
            items: _districts,
            loading: _loadingDistricts,
            value: _selectedDistrict,
            keyPrefix: 'district_${_selectedCity?.id ?? 0}',
            onSelect: _selectDistrict,
            onClear: () => _selectDistrict(null),
            freeController: _freeDistrictController,
          ),
          _buildIndonesiaChildField(
            label: 'Kelurahan / Desa',
            items: _villages,
            loading: _loadingVillages,
            value: _selectedVillage,
            keyPrefix: 'village_${_selectedDistrict?.id ?? 0}',
            onSelect: _selectVillage,
            onClear: () => _selectVillage(null),
            freeController: _freeVillageController,
          ),
          _buildFreeTextField(
            label: 'Kode Pos',
            controller: _freePostalController,
          ),
        ],
      );
    }

    // Non-Indonesia
    final stateItems = _worldStates.map((s) => s.name).toList();
    final cityItems = _worldCities.map((c) => c.name).toList();
    final districtItems = _worldDistricts.map((d) => d.name).toList();
    final villageItems = _worldVillages.map((v) => v.name).toList();
    final postalItems = _worldPostalCodes
        .map((p) => '${p.postalCode} — ${p.placeName}')
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAutocomplete<String>(
          label: 'Provinsi',
          items: stateItems,
          loading: _loadingWorldStates,
          fieldKey: const ValueKey('worldState'),
          value: _selectedWorldState?.name,
          labelOf: (s) => s,
          onSelect: (v) {
            final match = _worldStates.where((s) => s.name == v).firstOrNull;
            if (match != null) _selectWorldState(match);
          },
          onClear: () => _selectWorldState(null),
        ),
        _buildWorldField(
          label: 'Kota / Kabupaten',
          items: cityItems,
          loading: _loadingWorldCities,
          selectedValue: _selectedWorldCity?.name,
          freeController: _freeCityController,
          onSelect: (v) {
            final match = _worldCities.where((c) => c.name == v).firstOrNull;
            if (match != null) _selectWorldCity(match);
          },
        ),
        _buildWorldField(
          label: 'Kecamatan',
          items: districtItems,
          loading: _loadingWorldDistricts,
          selectedValue: _selectedWorldDistrict,
          freeController: _freeDistrictController,
          onSelect: _selectWorldDistrict,
        ),
        _buildWorldField(
          label: 'Kelurahan / Desa',
          items: villageItems,
          loading: _loadingWorldVillages,
          selectedValue: _selectedWorldVillage,
          freeController: _freeVillageController,
          onSelect: _selectWorldVillage,
        ),
        _buildWorldField(
          label: 'Kode Pos',
          items: postalItems,
          loading: _loadingWorldPostalCodes,
          selectedValue: _selectedWorldPostalCode,
          freeController: _freePostalController,
          onSelect: (v) {
            final code = v.split(' — ').first.trim();
            _selectWorldPostalCode(code);
          },
        ),
      ],
    );
  }
}
