import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Api/ApiEndpoints/ApiEndpoints.dart';
import '../../Api/DioClient/DioClient.dart';
import '../../Providers/LocaleProvider/LocaleProvider.dart';
import '../DropdownOption/DropdownOption.dart';

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
