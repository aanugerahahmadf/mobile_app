import 'package:dio/dio.dart';
import '../../../../Core/Api/ApiEndpoints/ApiEndpoints.dart';
import '../../../../Core/Api/DioClient/DioClient.dart';
import '../../Domain/LegalRepository/LegalRepository.dart';
import '../Models/LegalModel/LegalModel.dart';

class LegalRepositoryImpl implements LegalRepository {
  final Dio _dio = DioClient.instance;

  @override
  Future<LegalContent> getTermsOfService({String locale = 'id'}) async {
    return DioClient.safeCall(() async {
      final res = await _dio.get(ApiEndpoints.legalTerms);
      return LegalContent.fromJson(res.data, locale: locale);
    });
  }

  @override
  Future<LegalContent> getPrivacyPolicy({String locale = 'id'}) async {
    return DioClient.safeCall(() async {
      final res = await _dio.get(ApiEndpoints.legalPrivacy);
      return LegalContent.fromJson(res.data, locale: locale);
    });
  }

  @override
  Future<LegalContent> getWeddingDecorationPolicy({
    String locale = 'id',
  }) async {
    return DioClient.safeCall(() async {
      final res = await _dio.get(ApiEndpoints.legalWeddingPolicy);
      return LegalContent.fromJson(res.data, locale: locale);
    });
  }

  @override
  Future<HelpModel> getHelpCenter({String locale = 'id'}) async {
    return DioClient.safeCall(() async {
      final res = await _dio.get(ApiEndpoints.legalHelp);
      return HelpModel.fromJson(res.data, locale: locale);
    });
  }

  @override
  Future<AboutModel> getAbout({String locale = 'id'}) async {
    return DioClient.safeCall(() async {
      final res = await _dio.get(ApiEndpoints.legalAbout);
      return AboutModel.fromJson(res.data, locale: locale);
    });
  }
}
