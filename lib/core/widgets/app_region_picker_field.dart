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

  // Fallback text controllers (when API returns no data)
  final _fallbackDistrictController = TextEditingController();
  final _fallbackVillageController = TextEditingController();
  final _fallbackPostalController = TextEditingController();

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
    _fallbackDistrictController.text = widget.initialDistrictName ?? '';
    _fallbackVillageController.text = widget.initialVillageName ?? '';
    _fallbackPostalController.text = widget.initialPostalCode ?? '';
    _setupFallbackListeners();
    if (_isIndonesia) {
      _fetchProvinces();
    } else if (widget.country != null && widget.country!.isNotEmpty) {
      _fetchWorldStates();
    }
  }

  void _setupFallbackListeners() {
    _fallbackDistrictController.addListener(() {
      widget.onDistrictNameChanged(_fallbackDistrictController.text);
    });
    _fallbackVillageController.addListener(() {
      widget.onVillageNameChanged(_fallbackVillageController.text);
    });
    _fallbackPostalController.addListener(() {
      widget.onPostalCodeChanged(_fallbackPostalController.text);
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
        _fallbackDistrictController.text = '';
        _fallbackVillageController.text = '';
        _fallbackPostalController.text = '';
        if (nowIndonesia) {
          _fetchProvinces();
        } else if (widget.country != null && widget.country!.isNotEmpty) {
          _fetchWorldStates();
        }
      });
    }
    if (widget.initialPostalCode != oldWidget.initialPostalCode) {
      _fallbackPostalController.text = widget.initialPostalCode ?? '';
    }
  }

  @override
  void dispose() {
    _fallbackDistrictController.dispose();
    _fallbackVillageController.dispose();
    _fallbackPostalController.dispose();
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
    setState(() => _loadingWorldCities = true);
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
    setState(() => _loadingWorldDistricts = true);
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
    setState(() => _loadingWorldVillages = true);
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
    setState(() => _loadingWorldPostalCodes = true);
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
      _fallbackDistrictController.text = '';
      _fallbackVillageController.text = '';
      _fallbackPostalController.text = '';
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
      _fallbackPostalController.text = '';
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
      _fallbackDistrictController.text = districtName ?? '';
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
      _fallbackVillageController.text = villageName ?? '';
    });
    widget.onVillageIdChanged(null);
    widget.onVillageNameChanged(villageName ?? '');
  }

  void _selectWorldPostalCode(String? code) {
    setState(() {
      _selectedWorldPostalCode = code;
      _fallbackPostalController.text = code ?? '';
    });
    widget.onPostalCodeChanged(code ?? '');
  }

  // --- Bottom sheets ---

  void _showSearchPicker({
    required String title,
    required List<String> items,
    required String? currentValue,
    required ValueChanged<String> onSelect,
  }) {
    final searchController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final query = searchController.text.toLowerCase();
            final filtered = query.isEmpty
                ? items
                : items.where((i) => i.toLowerCase().contains(query)).toList();
            return DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.3,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) => Column(children: [
                const SizedBox(height: 12),
                Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(title, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari $title...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onChanged: (_) => setSheetState(() {}),
                  ),
                ),
                Expanded(
                  child: filtered.isEmpty
                      ? const Center(child: Text('Tidak ada data'))
                      : ListView.builder(
                          controller: scrollController,
                          itemCount: filtered.length,
                          itemBuilder: (_, i) {
                            final item = filtered[i];
                            final isSelected = currentValue == item;
                            return ListTile(
                              title: Text(item),
                              trailing: isSelected
                                  ? const Icon(Icons.check, color: AppColors.primaryColor, size: 20) : null,
                              onTap: () { onSelect(item); Navigator.pop(ctx); },
                            );
                          },
                        ),
                ),
              ]),
            );
          },
        );
      },
    );
  }

  // --- Builder helpers ---

  Widget _buildPickerField({
    required String label,
    required String? value,
    required bool loading,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: widget.readOnly ? null : onTap,
            child: AbsorbPointer(
              child: TextFormField(
                controller: TextEditingController(text: value ?? ''),
                decoration: InputDecoration(
                  suffixIcon: loading
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                        )
                      : const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField({
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

  /// Shows a dropdown if items is non-empty, otherwise shows a free-text field.
  Widget _buildWorldField({
    required String label,
    required List<String> items,
    required bool loading,
    required String? selectedValue,
    required TextEditingController fallbackController,
    required ValueChanged<String> onSelect,
  }) {
    if (loading || items.isNotEmpty) {
      return _buildPickerField(
        label: label,
        value: selectedValue,
        loading: loading,
        onTap: () {
          _showSearchPicker(
            title: label,
            items: items,
            currentValue: selectedValue,
            onSelect: onSelect,
          );
        },
      );
    }
    return _buildEditableField(label: label, controller: fallbackController);
  }

  @override
  Widget build(BuildContext context) {
    if (_isIndonesia) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPickerField(
            label: 'Provinsi',
            value: _selectedProvince?.name,
            loading: _loadingProvinces,
            onTap: () {
              final names = _provinces.map((p) => p.name).toList();
              _showSearchPicker(
                title: 'Provinsi',
                items: names,
                currentValue: _selectedProvince?.name,
                onSelect: (v) {
                  final match = _provinces.where((p) => p.name == v).firstOrNull;
                  if (match != null) _selectProvince(match);
                },
              );
            },
          ),
          if (_loadingCities || _cities.isNotEmpty)
            _buildPickerField(
              label: 'Kota / Kabupaten',
              value: _selectedCity?.name,
              loading: _loadingCities,
              onTap: () {
                final names = _cities.map((c) => c.name).toList();
                _showSearchPicker(
                  title: 'Kota/Kabupaten',
                  items: names,
                  currentValue: _selectedCity?.name,
                  onSelect: (v) {
                    final match = _cities.where((c) => c.name == v).firstOrNull;
                    if (match != null) _selectCity(match);
                  },
                );
              },
            ),
          if (_loadingDistricts || _districts.isNotEmpty)
            _buildPickerField(
              label: 'Kecamatan',
              value: _selectedDistrict?.name,
              loading: _loadingDistricts,
              onTap: () {
                final names = _districts.map((d) => d.name).toList();
                _showSearchPicker(
                  title: 'Kecamatan',
                  items: names,
                  currentValue: _selectedDistrict?.name,
                  onSelect: (v) {
                    final match = _districts.where((d) => d.name == v).firstOrNull;
                    if (match != null) _selectDistrict(match);
                  },
                );
              },
            ),
          if (_loadingVillages || _villages.isNotEmpty)
            _buildPickerField(
              label: 'Kelurahan / Desa',
              value: _selectedVillage?.name,
              loading: _loadingVillages,
              onTap: () {
                final names = _villages.map((v) => v.name).toList();
                _showSearchPicker(
                  title: 'Kelurahan/Desa',
                  items: names,
                  currentValue: _selectedVillage?.name,
                  onSelect: (v) {
                    final match = _villages.where((x) => x.name == v).firstOrNull;
                    if (match != null) _selectVillage(match);
                  },
                );
              },
            ),
          _buildEditableField(label: 'Kode Pos', controller: _fallbackPostalController),
        ],
      );
    }

    // Non-Indonesia: real data cascading with GeoNames fallback
    final districtItems = _worldDistricts.map((d) => d.name).toList();
    final villageItems = _worldVillages.map((v) => v.name).toList();
    final postalItems = _worldPostalCodes.map((p) => '${p.postalCode} — ${p.placeName}').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPickerField(
          label: 'Provinsi',
          value: _selectedWorldState?.name,
          loading: _loadingWorldStates,
          onTap: () {
            final names = _worldStates.map((s) => s.name).toList();
            _showSearchPicker(
              title: 'Provinsi',
              items: names,
              currentValue: _selectedWorldState?.name,
              onSelect: (v) {
                final match = _worldStates.where((s) => s.name == v).firstOrNull;
                if (match != null) _selectWorldState(match);
              },
            );
          },
        ),
        if (_loadingWorldCities || _worldCities.isNotEmpty)
          _buildPickerField(
            label: 'Kota / Kabupaten',
            value: _selectedWorldCity?.name,
            loading: _loadingWorldCities,
            onTap: () {
              final names = _worldCities.map((c) => c.name).toList();
              _showSearchPicker(
                title: 'Kota / Kabupaten',
                items: names,
                currentValue: _selectedWorldCity?.name,
                onSelect: (v) {
                  final match = _worldCities.where((c) => c.name == v).firstOrNull;
                  if (match != null) _selectWorldCity(match);
                },
              );
            },
          ),
        _buildWorldField(
          label: 'Kecamatan',
          items: districtItems,
          loading: _loadingWorldDistricts,
          selectedValue: _selectedWorldDistrict,
          fallbackController: _fallbackDistrictController,
          onSelect: _selectWorldDistrict,
        ),
        _buildWorldField(
          label: 'Kelurahan / Desa',
          items: villageItems,
          loading: _loadingWorldVillages,
          selectedValue: _selectedWorldVillage,
          fallbackController: _fallbackVillageController,
          onSelect: _selectWorldVillage,
        ),
        _buildWorldField(
          label: 'Kode Pos',
          items: postalItems,
          loading: _loadingWorldPostalCodes,
          selectedValue: _selectedWorldPostalCode,
          fallbackController: _fallbackPostalController,
          onSelect: (v) {
            // For postal codes, extract just the code part
            final code = v.split(' — ').first.trim();
            _selectWorldPostalCode(code);
          },
        ),
      ],
    );
  }
}
