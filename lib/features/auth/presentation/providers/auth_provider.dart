import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/api/dio_client.dart';
import '../../data/models/user_model.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final UserModel user;
  final bool needsOtp;
  final bool needsCompletion;
  const AuthAuthenticated(this.user, {this.needsOtp = false, this.needsCompletion = false});
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

class AuthNotifier extends StateNotifier<AuthState> {
  final _storage = const FlutterSecureStorage();
  final Dio _dio = DioClient.instance;

  AuthNotifier() : super(const AuthInitial());

  Future<void> login({required String login, required String password, String? loginType}) async {
    state = const AuthLoading();
    try {
      final data = <String, dynamic>{'login': login, 'password': password};
      if (loginType != null && loginType != 'email') {
        data['login_type'] = loginType;
      }
      final response = await _dio.post(
        ApiEndpoints.login,
        data: data,
      );
      final respData = response.data as Map<String, dynamic>? ?? {};
      final inner = respData['data'] as Map<String, dynamic>? ?? respData;
      final token = inner['token'] as String?;
      final userMap = inner['user'] as Map<String, dynamic>?;
      if (token == null || userMap == null) throw Exception('Login gagal');
      final user = UserModel.fromJson(userMap);
      await _storage.write(key: 'auth_token', value: token);
      state = AuthAuthenticated(user);
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String? ?? 'Login gagal';
      state = AuthError(msg);
    } catch (e) {
      state = AuthError('Terjadi kesalahan');
    }
  }

  Future<void> googleLogin() async {
    state = const AuthLoading();
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        serverClientId: dotenv.get('GOOGLE_CLIENT_ID'),
      ).signIn();
      if (googleUser == null) {
        state = const AuthInitial();
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) throw Exception('Gagal mendapatkan token Google');

      final response = await _dio.post(
        ApiEndpoints.googleLogin,
        data: {'id_token': idToken},
      );
      final respData = response.data as Map<String, dynamic>? ?? {};
      final inner = respData['data'] as Map<String, dynamic>? ?? respData;
      final token = inner['token'] as String?;
      final userMap = inner['user'] as Map<String, dynamic>?;
      if (token == null || userMap == null) throw Exception('Login Google gagal');
      final user = UserModel.fromJson(userMap);
      final needsOtp = inner['needs_otp'] == true;
      final needsCompletion = inner['needs_completion'] == true;

      await _storage.write(key: 'auth_token', value: token);

      if (needsOtp) {
        await _dio.post(
          ApiEndpoints.sendOtp,
          data: {'email': user.email, 'purpose': 'google_register'},
        );
      }

      state = AuthAuthenticated(user, needsOtp: needsOtp, needsCompletion: needsCompletion);
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String? ?? 'Login Google gagal';
      state = AuthError(msg);
    } catch (e) {
      state = AuthError('Terjadi kesalahan');
    }
  }

  Future<void> register({
    required String fullName,
    required String firstName,
    String? middleName,
    required String lastName,
    required String username,
    required String email,
    required String whatsapp,
    required String nik,
    String? passportNumber,
    String? simNumber,
    String? npwpNumber,
    String? identityType,
    String? birthPlace,
    String? birthDate,
    String? country,
    int? provinceId,
    int? cityId,
    int? districtId,
    int? villageId,
    String? provinceName,
    String? cityName,
    String? districtName,
    String? villageName,
    String? postalCode,
    String? address,
    String? ktpPhotoPath,
    String? selfiePhotoPath,
    String? faceScanPath,
    String? gender,
    String? religion,
    String? maritalStatus,
    String? motherName,
    String? occupation,
    String? incomeRange,
    String? sourceOfFunds,
    required String password,
    required String passwordConfirmation,
  }) async {
    state = const AuthLoading();
    try {
      final formData = <String, dynamic>{
        'full_name': fullName,
        'first_name': firstName,
        if (middleName != null && middleName.isNotEmpty) 'mid_name': middleName,
        'last_name': lastName,
        'username': username,
        'email': email,
        'whatsapp': whatsapp,
        'nik': nik,
        if (passportNumber != null && passportNumber.isNotEmpty) 'passport_number': passportNumber,
        if (simNumber != null && simNumber.isNotEmpty) 'sim_number': simNumber,
        if (npwpNumber != null && npwpNumber.isNotEmpty) 'npwp_number': npwpNumber,
        if (identityType != null && identityType.isNotEmpty) 'identity_type': identityType,
        if (birthPlace != null && birthPlace.isNotEmpty) 'birth_place': birthPlace,
        if (birthDate != null && birthDate.isNotEmpty) 'birth_date': birthDate,
        if (country != null && country.isNotEmpty) 'country': country,
        'province_id': ?provinceId,
        'city_id': ?cityId,
        'district_id': ?districtId,
        'village_id': ?villageId,
        if (provinceName != null && provinceName.isNotEmpty) 'province_name': provinceName,
        if (cityName != null && cityName.isNotEmpty) 'city_name': cityName,
        if (districtName != null && districtName.isNotEmpty) 'district_name': districtName,
        if (villageName != null && villageName.isNotEmpty) 'village_name': villageName,
        if (postalCode != null && postalCode.isNotEmpty) 'postal_code': postalCode,
        if (address != null && address.isNotEmpty) 'address': address,
        if (gender != null && gender.isNotEmpty) 'gender': gender,
        if (religion != null && religion.isNotEmpty) 'religion': religion,
        if (maritalStatus != null && maritalStatus.isNotEmpty) 'marital_status': maritalStatus,
        if (motherName != null && motherName.isNotEmpty) 'mother_name': motherName,
        if (occupation != null && occupation.isNotEmpty) 'occupation': occupation,
        if (incomeRange != null && incomeRange.isNotEmpty) 'income_range': incomeRange,
        if (sourceOfFunds != null && sourceOfFunds.isNotEmpty) 'source_of_funds': sourceOfFunds,
        'password': password,
        'password_confirmation': passwordConfirmation,
      };
      if (ktpPhotoPath != null) {
        formData['ktp_photo'] = await MultipartFile.fromFile(ktpPhotoPath);
      }
      if (selfiePhotoPath != null) {
        formData['selfie_photo'] = await MultipartFile.fromFile(selfiePhotoPath);
      }
      if (faceScanPath != null) {
        formData['face_scan_photo'] = await MultipartFile.fromFile(faceScanPath);
      }
      final response = await _dio.post(
        ApiEndpoints.register,
        data: FormData.fromMap(formData),
      );
      final respData = response.data as Map<String, dynamic>? ?? {};
      final inner = respData['data'] as Map<String, dynamic>? ?? respData;
      final token = inner['token'] as String?;
      final userMap = inner['user'] as Map<String, dynamic>?;
      if (token == null || userMap == null) throw Exception('Registrasi gagal');
      final user = UserModel.fromJson(userMap);
      await _storage.write(key: 'auth_token', value: token);
      state = AuthAuthenticated(user);
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String? ?? 'Registrasi gagal';
      state = AuthError(msg);
    } catch (e) {
      state = AuthError('Terjadi kesalahan');
    }
  }

  Future<void> logout() async {
    state = const AuthLoading();
    try {
      await _dio.post(ApiEndpoints.logout);
    } catch (_) {}
    await _storage.delete(key: 'auth_token');
    state = const AuthInitial();
  }

  Future<void> checkAuth() async {
    state = const AuthLoading();
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token == null || token.isEmpty) {
        state = const AuthInitial();
        return;
      }
      final response = await _dio.get(ApiEndpoints.user);
      final userMap = (response.data as Map<String, dynamic>?)?['data'] as Map<String, dynamic>?;
      if (userMap == null) throw Exception('Gagal memuat profil');
      final user = UserModel.fromJson(userMap);
      state = AuthAuthenticated(user);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _storage.delete(key: 'auth_token');
      }
      state = const AuthInitial();
    } catch (_) {
      state = const AuthInitial();
    }
  }

  void updateAvatarDirect(String avatarUrl) {
    final current = state;
    if (current is AuthAuthenticated) {
      state = AuthAuthenticated(current.user.copyWith(avatarUrl: avatarUrl));
    }
  }

  Future<void> refreshUser() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token == null || token.isEmpty) return;
      final response = await _dio.get(ApiEndpoints.user);
      final userMap = (response.data as Map<String, dynamic>?)?['data'] as Map<String, dynamic>?;
      if (userMap == null) return;
      final user = UserModel.fromJson(userMap);
      state = AuthAuthenticated(user);
    } catch (_) {}
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(ApiEndpoints.profile, data: data);
      final userMap = (response.data as Map<String, dynamic>?)?['data'] as Map<String, dynamic>?;
      if (userMap == null) throw Exception('Gagal update profil');
      final user = UserModel.fromJson(userMap);
      state = AuthAuthenticated(user);
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String? ?? 'Gagal update profil';
      state = AuthError(msg);
    }
  }

  Future<String> uploadAvatar(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(filePath),
      });
      final response = await _dio.post(ApiEndpoints.profileAvatar, data: formData);
      final respData = response.data as Map<String, dynamic>? ?? {};
      final avatarData = respData['data'] as Map<String, dynamic>?;
      if (avatarData != null) {
        final avatarUrl = avatarData['avatar_url'] as String?;
        final current = state;
        if (current is AuthAuthenticated) {
          final updatedUser = current.user.copyWith(avatarUrl: avatarUrl);
          state = AuthAuthenticated(updatedUser);
        }
        return avatarUrl ?? '';
      }
      return '';
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String? ?? 'Gagal upload avatar';
      state = AuthError(msg);
      rethrow;
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
