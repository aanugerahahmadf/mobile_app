import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/api/dio_client/dio_client.dart';
import '../../../../../core/errors/app_error_codes/app_error_codes.dart';
import '../../../../../core/utils/formatters/formatters.dart';
import '../../../../../core/utils/guest_mode/guest_mode.dart';
import '../../../../auth/presentation/providers/auth_provider/auth_provider.dart';
import '../../../data/profile_repository_impl/profile_repository_impl.dart';
import '../../../domain/profile_repository/profile_repository.dart';

class ProfileState {
  final Map<String, dynamic>? userData;
  final bool loading;
  final bool saving;
  final String? error;
  final int completionPercent;
  final Map<String, dynamic>? completionItems;
  final bool ktpUploading;
  final bool selfieUploading;
  final String? ktpUrl;
  final String? selfieUrl;
  final bool? ktpAiVerified;
  final double? ktpAiScore;
  final String? ktpAiReason;
  final bool? faceVerified;
  final double? faceSimilarity;
  final String? faceReason;

  const ProfileState({
    this.userData,
    this.loading = false,
    this.saving = false,
    this.error,
    this.completionPercent = 0,
    this.completionItems,
    this.ktpUploading = false,
    this.selfieUploading = false,
    this.ktpUrl,
    this.selfieUrl,
    this.ktpAiVerified,
    this.ktpAiScore,
    this.ktpAiReason,
    this.faceVerified,
    this.faceSimilarity,
    this.faceReason,
  });

  ProfileState copyWith({
    Map<String, dynamic>? userData,
    bool? loading,
    bool? saving,
    String? error,
    int? completionPercent,
    Map<String, dynamic>? completionItems,
    bool? ktpUploading,
    bool? selfieUploading,
    String? ktpUrl,
    String? selfieUrl,
    bool? ktpAiVerified,
    double? ktpAiScore,
    String? ktpAiReason,
    bool? faceVerified,
    double? faceSimilarity,
    String? faceReason,
    bool clearAiResults = false,
  }) {
    return ProfileState(
      userData: userData ?? this.userData,
      loading: loading ?? this.loading,
      saving: saving ?? this.saving,
      error: error,
      completionPercent: completionPercent ?? this.completionPercent,
      completionItems: completionItems ?? this.completionItems,
      ktpUploading: ktpUploading ?? this.ktpUploading,
      selfieUploading: selfieUploading ?? this.selfieUploading,
      ktpUrl: ktpUrl ?? this.ktpUrl,
      selfieUrl: selfieUrl ?? this.selfieUrl,
      ktpAiVerified: clearAiResults
          ? null
          : (ktpAiVerified ?? this.ktpAiVerified),
      ktpAiScore: clearAiResults ? null : (ktpAiScore ?? this.ktpAiScore),
      ktpAiReason: clearAiResults ? null : (ktpAiReason ?? this.ktpAiReason),
      faceVerified: clearAiResults ? null : (faceVerified ?? this.faceVerified),
      faceSimilarity: clearAiResults
          ? null
          : (faceSimilarity ?? this.faceSimilarity),
      faceReason: clearAiResults ? null : (faceReason ?? this.faceReason),
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileRepository _repository;
  final Ref _ref;

  ProfileNotifier(this._repository, this._ref) : super(const ProfileState());

  bool get _isGuest =>
      _ref.read(guestModeProvider).isGuest ||
      _ref.read(authProvider) is! AuthAuthenticated;

  Future<void> fetchProfile() async {
    if (_isGuest) return;
    state = state.copyWith(loading: true, error: null);
    try {
      final data = await _repository.getProfile();
      state = state.copyWith(userData: data, loading: false);
    } on DioException catch (e) {
      state = state.copyWith(
        loading: false,
        error: e.error?.toString() ?? AppErrorCodes.failedLoadProfile,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    if (_isGuest) return;
    state = state.copyWith(saving: true, error: null);
    try {
      final result = await _repository.updateProfile(data);
      final merged = Map<String, dynamic>.from(state.userData ?? {});
      result.forEach((key, value) {
        if (value != null) merged[key] = value;
      });
      state = state.copyWith(userData: merged, saving: false);
    } on DioException catch (e) {
      state = state.copyWith(saving: false, error: _extractBackendError(e));
      rethrow;
    } catch (e) {
      state = state.copyWith(saving: false, error: e.toString());
      rethrow;
    }
  }

  /// Extracts a user-friendly error message from a DioException.
  /// Prefers error_code, then field-level validation errors, then top-level message.
  static String _extractBackendError(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final errorCode = data['error_code'] as String?;
      if (errorCode != null && errorCode.isNotEmpty) return errorCode;
      final errors = data['errors'] as Map<String, dynamic>?;
      if (errors != null && errors.isNotEmpty) {
        final firstKey = errors.keys.first;
        final fieldErrors = errors[firstKey];
        if (fieldErrors is List && fieldErrors.isNotEmpty) {
          return fieldErrors.first.toString();
        }
      }
      final msg = data['message'] as String?;
      if (msg != null && msg.isNotEmpty) return msg;
    }
    return AppErrorCodes.failedUpdateProfile;
  }

  Future<String?> uploadAvatar(String filePath) async {
    if (_isGuest) return null;
    state = state.copyWith(saving: true, error: null);
    try {
      final avatarUrl = Formatters.imageUrl(
        await _repository.uploadAvatar(filePath),
      );
      if (state.userData != null) {
        final updated = Map<String, dynamic>.from(state.userData!)
          ..['avatar_url'] = avatarUrl;
        state = state.copyWith(userData: updated, saving: false);
      } else {
        state = state.copyWith(saving: false);
      }
      return avatarUrl;
    } on DioException catch (e) {
      state = state.copyWith(
        saving: false,
        error: e.error?.toString() ?? AppErrorCodes.failedUploadAvatar,
      );
      rethrow;
    } catch (e) {
      state = state.copyWith(saving: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> fetchCompletion() async {
    if (_isGuest) return;
    try {
      final result = await _repository.getCompletion();
      state = state.copyWith(
        completionPercent: (result['completion_percent'] as num?)?.toInt() ?? 0,
        completionItems: result['items'] as Map<String, dynamic>?,
      );
    } catch (_) {}
  }

  Future<void> updateKtpNumber(String ktpNumber) async {
    if (_isGuest) return;
    state = state.copyWith(saving: true, error: null);
    try {
      await _repository.updateKtpNumber(ktpNumber);
      final updated = Map<String, dynamic>.from(state.userData ?? {})
        ..['ktp_number'] = ktpNumber;
      state = state.copyWith(saving: false, userData: updated);
      await fetchCompletion();
    } on DioException catch (e) {
      state = state.copyWith(
        saving: false,
        error: e.error?.toString() ?? AppErrorCodes.failedUpdateKtpNumber,
      );
      rethrow;
    } catch (e) {
      state = state.copyWith(saving: false, error: e.toString());
      rethrow;
    }
  }

  void resetKycAiState() {
    if (_isGuest) return;
    state = state.copyWith(clearAiResults: true);
  }

  Future<Map<String, dynamic>?> uploadKtp(String filePath) async {
    if (_isGuest) return null;
    state = state.copyWith(ktpUploading: true, error: null);
    try {
      final result = await _repository.uploadKtp(filePath);
      final url = result['ktp_photo_url'] as String? ?? '';
      state = state.copyWith(
        ktpUrl: url,
        ktpUploading: false,
        ktpAiVerified: result['ktp_ai_verified'] as bool?,
        ktpAiScore: (result['ktp_ai_score'] as num?)?.toDouble(),
        ktpAiReason: result['ktp_ai_reason'] as String?,
      );
      if (state.userData != null) {
        final updated = Map<String, dynamic>.from(state.userData!)
          ..['ktp_photo_url'] = url;
        state = state.copyWith(userData: updated);
      }
      await fetchCompletion();
      return result;
    } on DioException catch (e) {
      state = state.copyWith(
        ktpUploading: false,
        error: e.error?.toString() ?? AppErrorCodes.failedUploadKtp,
      );
      return null;
    } catch (e) {
      state = state.copyWith(ktpUploading: false, error: e.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>?> uploadSelfie(
    String filePath, {
    bool livenessCompleted = false,
  }) async {
    if (_isGuest) return null;
    state = state.copyWith(selfieUploading: true, error: null);
    try {
      final result = await _repository.uploadSelfie(
        filePath,
        livenessCompleted: livenessCompleted,
      );
      state = state.copyWith(
        selfieUrl: result['selfie_photo_url'] as String?,
        selfieUploading: false,
        faceVerified: result['face_verified'] as bool?,
        faceSimilarity: (result['similarity'] as num?)?.toDouble(),
        faceReason: result['face_reason'] as String?,
      );
      if (state.userData != null) {
        final updated = Map<String, dynamic>.from(state.userData!)
          ..['selfie_photo_url'] = result['selfie_photo_url']
          ..['identity_verified_at'] = result['identity_verified_at'];
        state = state.copyWith(userData: updated);
      }
      await fetchCompletion();
      return result;
    } on DioException catch (e) {
      state = state.copyWith(
        selfieUploading: false,
        error: e.error?.toString() ?? AppErrorCodes.failedUploadSelfie,
      );
      return null;
    } catch (e) {
      state = state.copyWith(selfieUploading: false, error: e.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>?> uploadFaceScan(
    String filePath, {
    bool livenessCompleted = false,
  }) async {
    if (_isGuest) return null;
    state = state.copyWith(error: null);
    try {
      final result = await _repository.uploadFaceScan(
        filePath,
        livenessCompleted: livenessCompleted,
      );
      state = state.copyWith(
        faceVerified: result['face_verified'] as bool?,
        faceSimilarity: (result['similarity'] as num?)?.toDouble(),
        faceReason: result['face_reason'] as String?,
      );
      if (state.userData != null) {
        final updated = Map<String, dynamic>.from(state.userData!)
          ..['face_scan_photo_url'] = result['face_scan_photo_url']
          ..['identity_verified_at'] = result['identity_verified_at'];
        state = state.copyWith(userData: updated);
      }
      await fetchCompletion();
      return result;
    } on DioException catch (e) {
      state = state.copyWith(
        error: e.error?.toString() ?? AppErrorCodes.failedUploadFaceScan,
      );
      return null;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    if (_isGuest) return;
    state = state.copyWith(saving: true, error: null);
    try {
      await _repository.changePassword(currentPassword, newPassword);
      state = state.copyWith(saving: false);
    } on DioException catch (e) {
      state = state.copyWith(
        saving: false,
        error: e.error?.toString() ?? AppErrorCodes.failedChangePassword,
      );
      rethrow;
    } catch (e) {
      state = state.copyWith(saving: false, error: e.toString());
      rethrow;
    }
  }

  /// Mengirim OTP verifikasi email ke [email] via endpoint /auth/send-otp
  Future<void> sendVerifyEmailOtp(String email) async {
    if (_isGuest) return;
    await DioClient.instance.post(
      '/auth/send-otp',
      data: {'email': email, 'purpose': 'verify_email'},
    );
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((
  ref,
) {
  return ProfileNotifier(ProfileRepositoryImpl(), ref);
});
