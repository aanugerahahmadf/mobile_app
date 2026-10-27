import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../core/constants/app_text_styles/app_text_styles.dart';
import '../../../../../core/widgets/app_button/app_button.dart';

class AppMapAddressPicker extends ConsumerStatefulWidget {
  final String? country;
  final String? initialAddress;
  final double? initialLatitude;
  final double? initialLongitude;
  final ValueChanged<String> onAddressChanged;
  final ValueChanged<double?> onLatitudeChanged;
  final ValueChanged<double?> onLongitudeChanged;
  final ValueChanged<String> onPlaceIdChanged;
  final bool readOnly;

  const AppMapAddressPicker({
    super.key,
    this.country,
    this.initialAddress,
    this.initialLatitude,
    this.initialLongitude,
    required this.onAddressChanged,
    required this.onLatitudeChanged,
    required this.onLongitudeChanged,
    required this.onPlaceIdChanged,
    this.readOnly = false,
  });

  @override
  ConsumerState<AppMapAddressPicker> createState() => _AppMapAddressPickerState();
}

class _AppMapAddressPickerState extends ConsumerState<AppMapAddressPicker> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();

  LatLng _center = const LatLng(-6.2, 106.816666);
  LatLng? _markerPosition;
  bool _loading = false;
  bool _searching = false;
  String? _error;
  List<_SearchResult> _searchResults = [];
  bool _showSearchResults = false;
  bool _mapReady = false;
  String _selectedLabel = 'home';

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      setState(() {
        _center = LatLng(widget.initialLatitude!, widget.initialLongitude!);
        _markerPosition = _center;
      });
      if (widget.initialAddress != null) {
        _addressController.text = widget.initialAddress!;
      }
      await _reverseGeocode(_center);
    } else {
      await _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _loading = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _error = 'Location permission denied';
            _loading = false;
          });
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _error = 'Location permissions are permanently denied';
          _loading = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high,
      );
      final newCenter = LatLng(position.latitude, position.longitude);
      setState(() {
        _center = newCenter;
        _markerPosition = newCenter;
        _loading = false;
      });
      _mapController.move(newCenter, 15);
      await _reverseGeocode(newCenter);
    } catch (e) {
      setState(() {
        _error = 'Failed to get location: $e';
        _loading = false;
      });
    }
  }

  Future<void> _reverseGeocode(LatLng position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final address = _formatAddress(place);
        if (mounted) {
          setState(() {
            _addressController.text = address;
          });
          widget.onAddressChanged(address);
          widget.onPlaceIdChanged('');
        }
      }
    } catch (e) {
      debugPrint('Reverse geocoding error: $e');
    }
  }

  String _formatAddress(Placemark place) {
    final parts = [
      place.street,
      place.subLocality,
      place.locality,
      place.subAdministrativeArea,
      place.administrativeArea,
      place.postalCode,
      place.country,
    ].where((part) => part != null && part.isNotEmpty).join(', ');
    return parts;
  }

  Future<void> _searchAddress(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _showSearchResults = false;
      });
      return;
    }

    setState(() => _searching = true);
    try {
      final results = await locationFromAddress(query);
      if (mounted) {
        setState(() {
          _searchResults = results.map((loc) => _SearchResult(
            address: '${loc.latitude}, ${loc.longitude}',
            latitude: loc.latitude,
            longitude: loc.longitude,
          )).toList();
          _showSearchResults = true;
          _searching = false;
        });
      }
    } catch (e) {
      setState(() {
        _searching = false;
        _error = 'Search failed: $e';
      });
    }
  }

  void _onSearchResultTap(_SearchResult result) {
    final position = LatLng(result.latitude, result.longitude);
    setState(() {
      _center = position;
      _markerPosition = position;
      _showSearchResults = false;
      _searchController.clear();
    });
    _mapController.move(position, 15);
    _reverseGeocode(position);
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _markerPosition = position;
      _center = position;
    });
    _reverseGeocode(position);
  }

  void _saveAddress() {
    final address = _addressController.text.trim();
    if (address.isEmpty) return;

    widget.onAddressChanged(address);
    if (_markerPosition != null) {
      widget.onLatitudeChanged(_markerPosition!.latitude);
      widget.onLongitudeChanged(_markerPosition!.longitude);
    }
    widget.onPlaceIdChanged('');
  }

  Widget _buildErrorWidget() {
    if (_error == null) return const SizedBox.shrink();

    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.errorColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.errorColor.withValues(alpha: 0.5)),
          ),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: AppColors.errorColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _error!,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.errorColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Search Address', style: AppTextStyles.titleSmall),
        const SizedBox(height: 8),
        TextFormField(
          controller: _searchController,
          readOnly: widget.readOnly,
          decoration: InputDecoration(
            hintText: 'Type to search for a location...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searching
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : (_searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchResults = [];
                            _showSearchResults = false;
                          });
                        },
                      )
                    : null),
            border: const OutlineInputBorder(),
          ),
          onChanged: (value) {
            _searchAddress(value);
          },
          onTap: () {
            if (_searchResults.isNotEmpty) {
              setState(() => _showSearchResults = true);
            }
          },
        ),

        if (_showSearchResults && _searchResults.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.dividerColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _searchResults.length,
              separatorBuilder: (_, _) => Divider(height: 1, color: AppColors.dividerColor),
              itemBuilder: (_, i) {
                final result = _searchResults[i];
                return ListTile(
                  dense: true,
                  leading: const Icon(Icons.location_on, color: AppColors.primaryColor),
                  title: Text(
                    result.address,
                    style: AppTextStyles.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => _onSearchResultTap(result),
                );
              },
            ),
          ),

        const SizedBox(height: 16),

        Text('Address Detail', style: AppTextStyles.titleSmall),
        const SizedBox(height: 8),
        TextFormField(
          controller: _addressController,
          readOnly: widget.readOnly,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Enter detailed address (street, building, number)',
            border: const OutlineInputBorder(),
          ),
          onChanged: (value) {
            widget.onAddressChanged(value);
          },
        ),

        const SizedBox(height: 16),

        Text('Additional Details', style: AppTextStyles.titleSmall),
        const SizedBox(height: 8),
        TextFormField(
          controller: _detailController,
          readOnly: widget.readOnly,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'e.g. house number 16, near mosque',
            border: const OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 16),

        Text('Label Address', style: AppTextStyles.titleSmall),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildLabelChip('home', Icons.home, 'Home'),
            const SizedBox(width: 12),
            _buildLabelChip('office', Icons.work, 'Office'),
          ],
        ),

        const SizedBox(height: 16),

        Container(
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.dividerColor),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _center,
                    initialZoom: 15,
                    onTap: (_, position) => _onMapTap(position),
                    onMapReady: () {
                      setState(() => _mapReady = true);
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.weddingflowers.app',
                      maxZoom: 19,
                    ),
                    if (_markerPosition != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _markerPosition!,
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.location_pin,
                              color: AppColors.primaryColor,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                if (!_mapReady)
                  Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                if (_loading)
                  Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: AppButton(
                label: 'Gunakan Lokasi Saya',
                icon: Icons.my_location,
                onPressed: widget.readOnly ? null : _getCurrentLocation,
                type: ButtonType.outline,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButton(
                label: 'Simpan Alamat',
                icon: Icons.save,
                onPressed: widget.readOnly ? null : _saveAddress,
                type: ButtonType.primary,
              ),
            ),
          ],
        ),

        _buildErrorWidget(),
      ],
    );
  }

  Widget _buildLabelChip(String value, IconData icon, String label) {
    final isSelected = _selectedLabel == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedLabel = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.primaryColor : AppColors.dividerColor,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchResult {
  final String address;
  final double latitude;
  final double longitude;

  _SearchResult({
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}