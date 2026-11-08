import 'package:dio/dio.dart';
import '../../../../Core/Api/ApiEndpoints/ApiEndpoints.dart';
import '../../../../Core/Api/DioClient/DioClient.dart';
import '../../Domain/ProfileRepository/ProfileRepository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final Dio _dio;

  ProfileRepositoryImpl({Dio? dio}) : _dio = dio ?? DioClient.instance;

  Map<String, dynamic> _data(Map<String, dynamic>? resp) {
    final d = resp?['data'];
    if (d is Map<String, dynamic>) return d;
    return resp ?? {};
  }

  @override
  Future<Map<String, dynamic>> getProfile() async {
    final response = await _dio.get(ApiEndpoints.profile);
    return _data(response.data as Map<String, dynamic>?);
  }

  @override
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.profile, data: data);
    return _data(response.data as Map<String, dynamic>?);
  }

  @override
  Future<String> uploadAvatar(String filePath) async {
    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(filePath),
    });
    final response = await _dio.post(
      ApiEndpoints.profileAvatar,
      data: formData,
    );
    return ((response.data as Map<String, dynamic>?)?['data']?['avatar_url']
            as String?) ??
        '';
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    await _dio.put(
      ApiEndpoints.changePassword,
      data: {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPassword,
      },
    );
  }

  @override
  Future<void> updateDocumentNumber(
    String ktpNumber, {
    String documentType = 'ktp',
  }) async {
    await _dio.put(
      ApiEndpoints.profileDocumentNumber(documentType),
      data: {'document_type': documentType, 'document_number': ktpNumber},
    );
  }

  @override
  Future<Map<String, dynamic>> uploadDocument(
    String filePath, {
    String documentType = 'ktp',
  }) async {
    final formData = FormData.fromMap({
      'document_type': documentType,
      'document_photo': await MultipartFile.fromFile(filePath),
    });
    final response = await _dio.post(
      ApiEndpoints.profileDocumentPhoto(documentType),
      data: formData,
    );
    final d = response.data as Map<String, dynamic>?;
    return (d?['data'] as Map<String, dynamic>?) ?? {};
  }

  @override
  Future<Map<String, dynamic>> uploadSelfie(
    String filePath, {
    bool livenessCompleted = false,
  }) async {
    final formData = FormData.fromMap({
      'selfie_photo': await MultipartFile.fromFile(filePath),
      'liveness_completed': livenessCompleted,
    });
    final response = await _dio.post(
      ApiEndpoints.profileSelfie,
      data: formData,
    );
    final d = response.data as Map<String, dynamic>?;
    return (d?['data'] as Map<String, dynamic>?) ?? {};
  }

  @override
  Future<Map<String, dynamic>> uploadFaceScan(
    String filePath, {
    bool livenessCompleted = false,
  }) async {
    final formData = FormData.fromMap({
      'face_scan_photo': await MultipartFile.fromFile(filePath),
      'liveness_completed': livenessCompleted,
    });
    final response = await _dio.post(
      ApiEndpoints.profileFaceScan,
      data: formData,
    );
    final d = response.data as Map<String, dynamic>?;
    return (d?['data'] as Map<String, dynamic>?) ?? {};
  }

  @override
  Future<Map<String, dynamic>> getCompletion() async {
    final response = await _dio.get(ApiEndpoints.profileCompletion);
    final d = response.data as Map<String, dynamic>?;
    return (d?['data'] as Map<String, dynamic>?) ?? {};
  }
}
