import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../api/api_endpoints/api_endpoints.dart';
import '../../api/dio_client/dio_client.dart';
import '../../providers/locale_provider/locale_provider.dart';
import '../dropdown_option/dropdown_option.dart';

final dropdownOptionsProvider = FutureProvider<Map<String, List<DropdownOption>>>((ref) async {
  final locale = ref.watch(localeProvider);
  final langCode = locale.languageCode;

  final response = await DioClient.instance.get(
    ApiEndpoints.dropdownOptions,
    queryParameters: {'locale': langCode},
  );
  final data = response.data as Map<String, dynamic>?;
  final raw = data?['data'] as Map<String, dynamic>? ?? {};
  return raw.map((type, value) {
    final list = (value as List)
        .map((item) => DropdownOption.fromJson(item as Map<String, dynamic>))
        .toList();
    return MapEntry(type, list);
  });
});
