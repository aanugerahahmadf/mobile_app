import 'package:dio/dio.dart';
import 'package:mobile_app/core/api/api_endpoints/api_endpoints.dart';
import 'package:mobile_app/core/api/dio_client/dio_client.dart';

class AppLockService {
  /// Fetch app lock settings from DB.
  Future<Map<String, dynamic>?> fetchSettings() async {
    try {
      final response = await DioClient.instance.get(ApiEndpoints.appLock);
      final data = response.data['data'] as Map<String, dynamic>?;
      return data;
    } on DioException {
      return null;
    }
  }

  /// Update app lock flags (fingerprint_enabled, face_enabled, pin_enabled).
  Future<bool> updateFlags({
    bool? fingerprintEnabled,
    bool? faceEnabled,
    bool? pinEnabled,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (fingerprintEnabled != null) {
        data['fingerprint_enabled'] = fingerprintEnabled;
      }
      if (faceEnabled != null) data['face_enabled'] = faceEnabled;
      if (pinEnabled != null) data['pin_enabled'] = pinEnabled;
      await DioClient.instance.put(ApiEndpoints.appLock, data: data);
      return true;
    } on DioException {
      return false;
    }
  }

  /// Set or change PIN on DB.
  Future<bool> setPin(String pin, {String? currentPin}) async {
    try {
      final data = <String, dynamic>{'pin': pin};
      if (currentPin != null) data['current_pin'] = currentPin;
      await DioClient.instance.post(ApiEndpoints.appLockPin, data: data);
      return true;
    } on DioException {
      return false;
    }
  }

  /// Verify PIN against DB.
  Future<bool> verifyPinOnServer(String pin) async {
    try {
      final response = await DioClient.instance.post(
        ApiEndpoints.appLockPinVerify,
        data: {'pin': pin},
      );
      return response.data['data']['verified'] as bool? ?? false;
    } on DioException {
      return false;
    }
  }

  /// Enroll face for Face ID app lock.
  /// Returns {face_enrolled, similarity, enrolled_at} on success,
  /// or {reason, message} on failure (e.g. FACE_MISMATCH, KYC_NOT_COMPLETED).
  Future<Map<String, dynamic>?> enrollFace(String photoPath) async {
    try {
      final formData = FormData.fromMap({
        'face_photo': await MultipartFile.fromFile(photoPath),
        'liveness_completed': true,
      });
      final response = await DioClient.instance.post(
        ApiEndpoints.appLockFaceEnroll,
        data: formData,
      );
      return response.data['data'] as Map<String, dynamic>?;
    } on DioException catch (e) {
      // Extract error data from 422 responses (e.g. KYC_NOT_COMPLETED, FACE_MISMATCH).
      if (e.response?.data is Map && e.response?.data['data'] is Map) {
        return (e.response!.data['data'] as Map).cast<String, dynamic>();
      }
      return null;
    }
  }

  /// Verify face for unlock against enrolled reference via AI Core.
  Future<bool> verifyFaceOnServer(String photoPath) async {
    try {
      final formData = FormData.fromMap({
        'face_photo': await MultipartFile.fromFile(photoPath),
      });
      final response = await DioClient.instance.post(
        ApiEndpoints.appLockFaceVerify,
        data: formData,
      );
      return response.data['data']['verified'] as bool? ?? false;
    } on DioException {
      return false;
    }
  }
}
