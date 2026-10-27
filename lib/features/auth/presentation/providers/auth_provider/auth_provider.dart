import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../../../core/api/api_endpoints/api_endpoints.dart';
import '../../../../../core/api/dio_client/dio_client.dart';
import '../../../../../core/errors/app_error_codes/app_error_codes.dart';
import '../../../../../core/services/notification_service/notification_service.dart';
import '../../../../../core/utils/guest_mode/guest_mode.dart';
import '../../../../../core/utils/security_question_prompt/security_question_prompt.dart';
import '../../../data/models/user_model/user_model.dart';
import '../biometric_settings_provider/biometric_settings_provider.dart' show resetAppLock;

class SavedAccount {
  final String email;
  final String fullName;
  final String? avatarUrl;
  final String token;
  const SavedAccount({
    required this.email,
    required this.fullName,
    this.avatarUrl,
    required this.token,
  });

  factory SavedAccount.fromJson(Map<String, dynamic> json) => SavedAccount(
    email: json['email'] as String,
    fullName: json['full_name'] as String,
    avatarUrl: json['avatar_url'] as String?,
    token: json['token'] as String,
  );

  Map<String, dynamic> toJson() => {
    'email': email,
    'full_name': fullName,
    'avatar_url': avatarUrl,
    'token': token,
  };
}

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
  const AuthAuthenticated(
    this.user, {
    this.needsOtp = false,
    this.needsCompletion = false,
  });
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

/// Kata sandi sudah benar, tapi akun ini memakai 2FA -- belum ada token.
///
/// State ini bukan error: belum ada apa-apa yang salah, yang belum ada hanya
/// bukti kedua. Dipisah dari [AuthError] supaya listener tidak sempat
/// menampilkan "Autentikasi Gagal" untuk langkah yang memang diharapkan.
///
/// Sebaliknya dari [AuthAuthenticated] di semua hal yang penting: token
/// BELUM ditulis ke penyimpanan, jadi aplikasi ini belum benar-benar masuk.
/// Itulah yang membuat state ini aman -- kalau sheet 2FA ditutup, tidak ada
/// yang tersisa untuk dibajak.
class AuthTwoFactorRequired extends AuthState {
  /// Token sementara milik challenge ini, bukan hak akses.
  ///
  /// Diteruskan apa adanya ke /auth/two-factor/verify. Tidak disimpan di
  /// mana pun: ia hanya hidup selama sheet terbuka.
  final String challengeToken;

  /// Metode awal yang dipilih server: authenticator | email.
  final String method;

  /// Email tujuan kode, hanya untuk ditampilkan di sheet.
  final String email;

  const AuthTwoFactorRequired({
    required this.challengeToken,
    required this.method,
    required this.email,
  });
}

/// Kode 2FA salah / challenge kedaluwarsa.
///
/// Tanpa tipe ini, sheet 2FA harus membedakan "coba lagi" dari "sesi habis,
/// Sign In ulang" dengan memeriksa string pesan -- rapuh, karena teks pesan
/// ikut diterjemahkan.
class TwoFactorVerifyException implements Exception {
  final String message;

  /// Challenge sudah tidak berlaku, jadi sheet perlu menutup diri dan
  /// mengarahkan pengguna kembali ke form Sign In.
  final bool sessionExpired;

  const TwoFactorVerifyException(this.message, {this.sessionExpired = false});

  @override
  String toString() => message;
}

final _googleSignIn = GoogleSignIn(
  serverClientId: dotenv.get('GOOGLE_CLIENT_ID'),
);

class AuthNotifier extends StateNotifier<AuthState> {
  final _storage = const FlutterSecureStorage();
  final Dio _dio = DioClient.instance;
  List<SavedAccount> _savedAccounts = [];
  int _activeIndex = 0;

  AuthNotifier() : super(const AuthInitial());

  List<SavedAccount> get savedAccounts => List.unmodifiable(_savedAccounts);
  int get activeAccountIndex => _activeIndex;

  void _setAuthenticated(
    UserModel user, {
    bool needsOtp = false,
    bool needsCompletion = false,
  }) {
    unawaited(clearGuestMode());
    state = AuthAuthenticated(
      user,
      needsOtp: needsOtp,
      needsCompletion: needsCompletion,
    );
    if (!needsOtp && !needsCompletion) {
      unawaited(NotificationService.instance.syncFcmToken());
    }
  }

  Future<void> _loadSavedAccounts() async {
    final json = await _storage.read(key: 'saved_accounts');
    if (json != null && json.isNotEmpty) {
      try {
        final list = jsonDecode(json) as List;
        _savedAccounts = list
            .map((e) => SavedAccount.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {}
    }
  }

  Future<void> _saveAccounts() async {
    final json = jsonEncode(_savedAccounts.map((e) => e.toJson()).toList());
    await _storage.write(key: 'saved_accounts', value: json);
  }

  Future<void> _addOrUpdateAccount(SavedAccount account) async {
    await _loadSavedAccounts();
    final idx = _savedAccounts.indexWhere((a) => a.email == account.email);
    if (idx >= 0) {
      _savedAccounts[idx] = account;
    } else {
      _savedAccounts.add(account);
    }
    _activeIndex = _savedAccounts.indexWhere((a) => a.email == account.email);
    await _saveAccounts();
  }

  Future<void> _switchToAccount(int index) async {
    if (index < 0 || index >= _savedAccounts.length) return;
    state = const AuthLoading();
    final account = _savedAccounts[index];
    await _storage.write(key: 'auth_token', value: account.token);
    try {
      final response = await _dio.get(ApiEndpoints.user);
      final respData = response.data as Map<String, dynamic>?;
      final userMap = respData?['data'] as Map<String, dynamic>?;
      if (userMap == null) throw Exception();
      final user = UserModel.fromJson(userMap);
      final needsCompletion = userMap['needs_completion'] == true;
      _activeIndex = index;
      await _saveAccounts();
      _setAuthenticated(user, needsCompletion: needsCompletion);
    } catch (_) {
      _savedAccounts.removeAt(index);
      await _saveAccounts();
      if (_savedAccounts.isNotEmpty) {
        await _switchToAccount(0);
      } else {
        await clearGuestMode();
        await _storage.delete(key: 'auth_token');
        state = const AuthInitial();
      }
    }
  }

  Future<void> switchToNextAccount() async {
    await _loadSavedAccounts();
    if (_savedAccounts.length < 2) return;
    final nextIdx = (_activeIndex + 1) % _savedAccounts.length;
    await _switchToAccount(nextIdx);
  }

  Future<void> switchToAccount(int index) async {
    await _loadSavedAccounts();
    await _switchToAccount(index);
  }

  Future<void> removeSavedAccount(int index) async {
    if (index < 0 || index >= _savedAccounts.length) return;
    _savedAccounts.removeAt(index);
    if (_savedAccounts.isEmpty) {
      await _storage.delete(key: 'auth_token');
      await _storage.delete(key: 'saved_accounts');
      state = const AuthInitial();
    } else {
      if (index == _activeIndex) {
        await _switchToAccount(0);
      } else if (index < _activeIndex) {
        _activeIndex--;
      }
      await _saveAccounts();
    }
  }

  Future<void> login({
    required String login,
    required String password,
    String? loginType,
  }) async {
    state = const AuthLoading();
    try {
      final data = <String, dynamic>{'login': login, 'password': password};
      if (loginType != null && loginType != 'email') {
        data['login_type'] = loginType;
      }
      final response = await _dio.post(ApiEndpoints.login, data: data);
      final respData = response.data as Map<String, dynamic>? ?? {};
      final inner = respData['data'] as Map<String, dynamic>? ?? respData;

      // 2FA aktif: server sengaja TIDAK menerbitkan token. Ini cabang
      // terpisah, bukan error -- yang belum ada hanya bukti kedua.
      if (respData['status'] == 'two_factor_required') {
        state = AuthTwoFactorRequired(
          challengeToken: inner['challenge_token'] as String? ?? '',
          method: inner['method'] as String? ?? 'authenticator',
          email: inner['email'] as String? ?? '',
        );
        return;
      }

      final token = inner['token'] as String?;
      final userMap = inner['user'] as Map<String, dynamic>?;
      if (token == null || userMap == null) {
        throw Exception(AppErrorCodes.loginFailed);
      }
      final user = UserModel.fromJson(userMap);
      await _storage.write(key: 'auth_token', value: token);
      await _addOrUpdateAccount(
        SavedAccount(
          email: user.email,
          fullName: user.fullName,
          avatarUrl: user.avatarUrl,
          token: token,
        ),
      );
      _setAuthenticated(user);
    } on DioException catch (e) {
      final msg =
          e.response?.data?['message'] as String? ?? AppErrorCodes.loginFailed;
      state = AuthError(msg);
    } catch (e) {
      state = AuthError(AppErrorCodes.anErrorOccurred);
    }
  }

  /// Verifikasi kode 2FA, lalu terbitkan sesi.
  ///
  /// Dipanggil dari sheet 2FA setelah [AuthTwoFactorRequired]. Berhasil ->
  /// [AuthAuthenticated] seperti login biasa; token yang sama bookkeeping-nya
  /// (disimpan ke secure storage + daftar akun tersimpan) supaya kedua jalan
  /// masuk tidak menghasilkan state berbeda setelahnya.
  Future<void> verifyTwoFactor({
    required String challengeToken,
    required String code,
    required String method,
  }) async {
    final previous = state;
    state = const AuthLoading();
    try {
      final response = await _dio.post(
        ApiEndpoints.twoFactorVerify,
        data: {
          'challenge_token': challengeToken,
          'code': code,
          'method': method,
        },
      );
      final respData = response.data as Map<String, dynamic>? ?? {};
      final inner = respData['data'] as Map<String, dynamic>? ?? respData;

      final token = inner['token'] as String?;
      final userMap = inner['user'] as Map<String, dynamic>?;
      if (token == null || userMap == null) {
        throw Exception(AppErrorCodes.loginFailed);
      }
      final user = UserModel.fromJson(userMap);
      await _storage.write(key: 'auth_token', value: token);
      await _addOrUpdateAccount(
        SavedAccount(
          email: user.email,
          fullName: user.fullName,
          avatarUrl: user.avatarUrl,
          token: token,
        ),
      );
      _setAuthenticated(user);
    } on DioException catch (e) {
      // Kode salah: challenge di server masih hidup, jadi pengguna boleh
      // mencoba lagi. State sebelumnya dikembalikan, bukan AuthInitial --
      // pindah ke AuthInitial akan memutus sheet 2FA yang sedang terbuka.
      // 401 = challenge sudah kedaluwarsa atau 2FA dimatikan di tengah
      // jalan. Kode salah sendiri dijawab 422, jadi keduanya bisa dibedakan
      // tanpa membaca teks pesan.
      final expired = e.response?.statusCode == 401;

      state = expired
          ? const AuthInitial()
          : (previous is AuthTwoFactorRequired ? previous : const AuthInitial());

      throw TwoFactorVerifyException(
        e.response?.data?['message'] as String? ??
            e.response?.data?['error'] as String? ??
            AppErrorCodes.loginFailed,
        sessionExpired: expired,
      );
    } catch (e) {
      state = previous is AuthTwoFactorRequired
          ? previous
          : const AuthInitial();
      throw TwoFactorVerifyException(AppErrorCodes.anErrorOccurred);
    }
  }

  /// Minta ulang kode email 2FA.
  ///
  /// Error sengaja TIDAK dilempar: gagal mengirim kode bukan kondisi yang
  /// membuat sheet 2FA tidak bisa dipakai, dan kode yang sudah terkirim
  /// mungkin masih berlaku.
  Future<bool> resendTwoFactorCode(String challengeToken) async {
    try {
      await _dio.post(
        ApiEndpoints.twoFactorResend,
        data: {'challenge_token': challengeToken},
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> googleLogin() async {
    state = const AuthLoading();
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        state = const AuthInitial();
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) throw Exception(AppErrorCodes.failedGetGoogleToken);

      final response = await _dio.post(
        ApiEndpoints.googleLogin,
        data: {'id_token': idToken},
      );
      final respData = response.data as Map<String, dynamic>? ?? {};
      final inner = respData['data'] as Map<String, dynamic>? ?? respData;

      // 2FA aktif: server sengaja TIDAK menerbitkan token -- sama seperti pada
      // login email/kata sandi.
      //
      // Cabang ini WAJIB ada di sini. Flow "akun Google sudah terdaftar + multi
      // two factor aktif" berakhir di OtpEmailOrTwoFactory, dan tanpa baris ini
      // response itu jatuh ke `token == null` di bawah lalu dilempar sebagai
      // AuthError -- artinya akun Google yang 2FA-nya aktif tidak akan pernah
      // sampai ke sheet challenge, selalu gagal login.
      if (respData['status'] == 'two_factor_required') {
        state = AuthTwoFactorRequired(
          challengeToken: inner['challenge_token'] as String? ?? '',
          method: inner['method'] as String? ?? 'authenticator',
          email: inner['email'] as String? ?? '',
        );
        return;
      }

      final token = inner['token'] as String?;
      final userMap = inner['user'] as Map<String, dynamic>?;
      if (token == null || userMap == null) {
        throw Exception(AppErrorCodes.googleLoginFailed);
      }
      final user = UserModel.fromJson(userMap);
      final needsOtp = inner['needs_otp'] == true;
      final needsCompletion = inner['needs_completion'] == true;

      await _storage.write(key: 'auth_token', value: token);
      await _addOrUpdateAccount(
        SavedAccount(
          email: user.email,
          fullName: user.fullName,
          avatarUrl: user.avatarUrl,
          token: token,
        ),
      );

      if (needsOtp) {
        await _dio.post(
          ApiEndpoints.sendOtp,
          data: {'email': user.email, 'purpose': 'google_register'},
        );
      }

      _setAuthenticated(
        user,
        needsOtp: needsOtp,
        needsCompletion: needsCompletion,
      );
    } on DioException catch (e) {
      final msg = _extractBackendError(e);
      state = AuthError(msg);
    } catch (e, st) {
      debugPrint('[GoogleLogin] error: $e\n$st');
      state = AuthError(AppErrorCodes.anErrorOccurred);
    }
  }

  Future<void> facebookLogin() async {
    state = const AuthLoading();
    try {
      final result = await FacebookAuth.instance.login(
        permissions: ['public_profile', 'email'],
      );
      if (result.status != LoginStatus.success) {
        state = const AuthInitial();
        return;
      }
      final accessToken = result.accessToken?.tokenString;
      if (accessToken == null) {
        throw Exception(AppErrorCodes.failedGetFacebookToken);
      }

      final response = await _dio.post(
        ApiEndpoints.facebookLogin,
        data: {'access_token': accessToken},
      );
      final respData = response.data as Map<String, dynamic>? ?? {};
      final inner = respData['data'] as Map<String, dynamic>? ?? respData;

      // 2FA aktif: server sengaja TIDAK menerbitkan token.
      if (respData['status'] == 'two_factor_required') {
        state = AuthTwoFactorRequired(
          challengeToken: inner['challenge_token'] as String? ?? '',
          method: inner['method'] as String? ?? 'authenticator',
          email: inner['email'] as String? ?? '',
        );
        return;
      }

      final token = inner['token'] as String?;
      final userMap = inner['user'] as Map<String, dynamic>?;
      if (token == null || userMap == null) {
        throw Exception(AppErrorCodes.facebookLoginFailed);
      }
      final user = UserModel.fromJson(userMap);
      final needsOtp = inner['needs_otp'] == true;
      final needsCompletion = inner['needs_completion'] == true;

      await _storage.write(key: 'auth_token', value: token);
      await _addOrUpdateAccount(
        SavedAccount(
          email: user.email,
          fullName: user.fullName,
          avatarUrl: user.avatarUrl,
          token: token,
        ),
      );

      if (needsOtp) {
        await _dio.post(
          ApiEndpoints.sendOtp,
          data: {'email': user.email, 'purpose': 'google_register'},
        );
      }

      _setAuthenticated(
        user,
        needsOtp: needsOtp,
        needsCompletion: needsCompletion,
      );
    } on DioException catch (e) {
      final msg = _extractBackendError(e);
      state = AuthError(msg);
    } catch (e) {
      state = AuthError(AppErrorCodes.anErrorOccurred);
    }
  }

  Future<void> appleLogin() async {
    state = const AuthLoading();
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final identityToken = credential.identityToken;
      if (identityToken == null) {
        throw Exception(AppErrorCodes.failedGetAppleToken);
      }

      final response = await _dio.post(
        ApiEndpoints.appleLogin,
        data: {'identity_token': identityToken},
      );
      final respData = response.data as Map<String, dynamic>? ?? {};
      final inner = respData['data'] as Map<String, dynamic>? ?? respData;

      // 2FA aktif: server sengaja TIDAK menerbitkan token.
      if (respData['status'] == 'two_factor_required') {
        state = AuthTwoFactorRequired(
          challengeToken: inner['challenge_token'] as String? ?? '',
          method: inner['method'] as String? ?? 'authenticator',
          email: inner['email'] as String? ?? '',
        );
        return;
      }

      final token = inner['token'] as String?;
      final userMap = inner['user'] as Map<String, dynamic>?;
      if (token == null || userMap == null) {
        throw Exception(AppErrorCodes.appleLoginFailed);
      }
      final user = UserModel.fromJson(userMap);
      final needsOtp = inner['needs_otp'] == true;
      final needsCompletion = inner['needs_completion'] == true;

      await _storage.write(key: 'auth_token', value: token);
      await _addOrUpdateAccount(
        SavedAccount(
          email: user.email,
          fullName: user.fullName,
          avatarUrl: user.avatarUrl,
          token: token,
        ),
      );

      if (needsOtp) {
        await _dio.post(
          ApiEndpoints.sendOtp,
          data: {'email': user.email, 'purpose': 'google_register'},
        );
      }

      _setAuthenticated(
        user,
        needsOtp: needsOtp,
        needsCompletion: needsCompletion,
      );
    } on DioException catch (e) {
      final msg =
          e.response?.data?['message'] as String? ??
          AppErrorCodes.appleLoginFailed;
      state = AuthError(msg);
    } catch (e) {
      state = AuthError(AppErrorCodes.anErrorOccurred);
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
    required String ktpNumber,
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
    // same as before but add _addOrUpdateAccount
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
        'ktp_number': ktpNumber,
        if (passportNumber != null && passportNumber.isNotEmpty)
          'passport_number': passportNumber,
        if (simNumber != null && simNumber.isNotEmpty) 'sim_number': simNumber,
        if (npwpNumber != null && npwpNumber.isNotEmpty)
          'npwp_number': npwpNumber,
        if (identityType != null && identityType.isNotEmpty)
          'identity_type': identityType,
        if (birthPlace != null && birthPlace.isNotEmpty)
          'birth_place': birthPlace,
        if (birthDate != null && birthDate.isNotEmpty) 'birth_date': birthDate,
        if (country != null && country.isNotEmpty) 'country': country,
        'province_id': ?provinceId,
        'city_id': ?cityId,
        'district_id': ?districtId,
        'village_id': ?villageId,
        if (provinceName != null && provinceName.isNotEmpty)
          'province_name': provinceName,
        if (cityName != null && cityName.isNotEmpty) 'city_name': cityName,
        if (districtName != null && districtName.isNotEmpty)
          'district_name': districtName,
        if (villageName != null && villageName.isNotEmpty)
          'village_name': villageName,
        if (postalCode != null && postalCode.isNotEmpty)
          'postal_code': postalCode,
        if (address != null && address.isNotEmpty) 'address': address,
        if (gender != null && gender.isNotEmpty) 'gender': gender,
        if (religion != null && religion.isNotEmpty) 'religion': religion,
        if (maritalStatus != null && maritalStatus.isNotEmpty)
          'marital_status': maritalStatus,
        if (motherName != null && motherName.isNotEmpty)
          'mother_name': motherName,
        if (occupation != null && occupation.isNotEmpty)
          'occupation': occupation,
        if (incomeRange != null && incomeRange.isNotEmpty)
          'income_range': incomeRange,
        if (sourceOfFunds != null && sourceOfFunds.isNotEmpty)
          'source_of_funds': sourceOfFunds,
        'password': password,
        'password_confirmation': passwordConfirmation,
      };
      if (ktpPhotoPath != null) {
        formData['ktp_photo'] = await MultipartFile.fromFile(ktpPhotoPath);
      }
      if (selfiePhotoPath != null) {
        formData['selfie_photo'] = await MultipartFile.fromFile(
          selfiePhotoPath,
        );
      }
      if (faceScanPath != null) {
        formData['face_scan_photo'] = await MultipartFile.fromFile(
          faceScanPath,
        );
        formData['liveness_completed'] = true;
      }
      final response = await _dio.post(
        ApiEndpoints.register,
        data: FormData.fromMap(formData),
      );
      final respData = response.data as Map<String, dynamic>? ?? {};
      final inner = respData['data'] as Map<String, dynamic>? ?? respData;
      final token = inner['token'] as String?;
      final userMap = inner['user'] as Map<String, dynamic>?;
      if (token == null || userMap == null) {
        throw Exception(AppErrorCodes.registrationFailed);
      }
      final user = UserModel.fromJson(userMap);
      await _storage.write(key: 'auth_token', value: token);
      await _addOrUpdateAccount(
        SavedAccount(
          email: user.email,
          fullName: user.fullName,
          avatarUrl: user.avatarUrl,
          token: token,
        ),
      );
      _setAuthenticated(user);
    } on DioException catch (e) {
      final msg = _extractBackendError(e);
      state = AuthError(msg);
    } catch (e) {
      state = AuthError(AppErrorCodes.anErrorOccurred);
    }
  }

  /// Logout untuk melanjutkan alur auth, lalu SIGN IN LAGI dengan akun yang
  /// sama.
  ///
  /// Berbeda dengan [logout]: method itu, kalau ada akun tersimpan lain,
  /// langsung `_switchToAccount(0)` -- jadi orang masuk ke akun yang BERBEDA.
  /// Di alur Security Question itu berbahaya: akun yang sedang disiapkan 2FA
  /// akan ditinggalkan, dan yang masuk justru akun lain di perangkat ini.
  ///
  /// Yang terjadi di sini persis seperti [logout], kecuali:
  ///   - akun tersimpan TIDAK dihapus, hanya token aktifnya yang dibuang;
  ///   - tidak ada switch ke akun lain;
  ///   - state berakhir di AuthInitial supaya sheet Sign In bisa dibuka.
  ///
  /// Penanda "pertanyaan keamanan sudah dijawab" sengaja TIDAK dihapus --
  /// hanya [deleteAccount] yang boleh melakukannya. Kalau penandanya ikut
  /// hilang, Sign In berikutnya akan menanyakan Security Question lagi dan
  /// alurnya berputar.
  Future<void> logoutForReauth() async {
    state = const AuthLoading();
    try {
      await _dio.post(ApiEndpoints.logout);
    } catch (_) {}
    await clearGuestMode();
    await _storage.delete(key: 'auth_token');
    state = const AuthInitial();
  }

  Future<void> logout() async {
    final currentEmail = state is AuthAuthenticated
        ? (state as AuthAuthenticated).user.email
        : null;
    state = const AuthLoading();
    try {
      await _dio.post(ApiEndpoints.logout);
    } catch (_) {}
    await clearGuestMode();
    await _loadSavedAccounts();
    if (currentEmail != null) {
      _savedAccounts.removeWhere((a) => a.email == currentEmail);
    }
    if (_savedAccounts.isNotEmpty) {
      await _switchToAccount(0);
    } else {
      await _storage.delete(key: 'auth_token');
      await _storage.delete(key: 'saved_accounts');
      state = const AuthInitial();
    }
  }

  Future<bool> deleteAccount() async {
    final currentEmail = state is AuthAuthenticated
        ? (state as AuthAuthenticated).user.email
        : null;
    state = const AuthLoading();
    try {
      await _dio.delete(ApiEndpoints.deleteAccount);
      await _loadSavedAccounts();
      if (currentEmail != null) {
        _savedAccounts.removeWhere((a) => a.email == currentEmail);
        await resetAppLock(email: currentEmail);
        // Penanda "pertanyaan keamanan sudah dijawab" ikut dihapus. Kalau
        // tidak, akun yang dihapus lalu didaftarkan ulang dengan email yang
        // sama akan langsung melewati langkah itu -- padahal bagi akun baru
        // pertanyaannya belum pernah dijawab.
        await SecurityQuestionPrompt.reset(currentEmail);
      }
      _savedAccounts = [];
      await clearGuestMode();
      await _storage.delete(key: 'auth_token');
      await _storage.delete(key: 'saved_accounts');
      state = const AuthInitial();
      return true;
    } on DioException catch (e) {
      final msg =
          e.response?.data?['message'] as String? ??
          AppErrorCodes.anErrorOccurred;
      state = AuthError(msg);
      return false;
    } catch (_) {
      state = AuthError(AppErrorCodes.anErrorOccurred);
      return false;
    }
  }

  Future<void> checkAuth() async {
    await _loadSavedAccounts();
    if (_savedAccounts.isNotEmpty) {
      await _switchToAccount(0);
      return;
    }
    state = const AuthLoading();
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token == null || token.isEmpty) {
        state = const AuthInitial();
        return;
      }
      final response = await _dio.get(ApiEndpoints.user);
      final respData = response.data as Map<String, dynamic>?;
      final userMap = respData?['data'] as Map<String, dynamic>?;
      if (userMap == null) throw Exception(AppErrorCodes.failedLoadProfile);
      final user = UserModel.fromJson(userMap);
      final needsCompletion = userMap['needs_completion'] == true;
      await _addOrUpdateAccount(
        SavedAccount(
          email: user.email,
          fullName: user.fullName,
          avatarUrl: user.avatarUrl,
          token: token,
        ),
      );
      _setAuthenticated(user, needsCompletion: needsCompletion);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _storage.delete(key: 'auth_token');
      }
      state = const AuthInitial();
    } catch (_) {
      state = const AuthInitial();
    }
  }

  /// Buang challenge 2FA yang sedang menggantung.
  ///
  /// Dipanggil saat pengguna menyerah di sheet verifikasi (tekan "Keluar"),
  /// supaya state tidak tertinggal di [AuthTwoFactorRequired] -- kalau iya,
  /// sheet berikutnya yang dibuka akan menemukan challenge lama dan
  /// mengirim kodenya ke challenge yang sudah kedaluwarsa.
  void resetTwoFactorChallenge() {
    if (state is AuthTwoFactorRequired) {
      state = const AuthInitial();
    }
  }

  void updateAvatarDirect(String avatarUrl) {
    final current = state;
    if (current is AuthAuthenticated) {
      _setAuthenticated(current.user.copyWith(avatarUrl: avatarUrl));
    }
  }

  Future<void> refreshUser() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token == null || token.isEmpty) return;
      final response = await _dio.get(ApiEndpoints.user);
      final respData = response.data as Map<String, dynamic>?;
      final userMap = respData?['data'] as Map<String, dynamic>?;
      if (userMap == null) return;
      final user = UserModel.fromJson(userMap);
      final needsCompletion = userMap['needs_completion'] == true;
      _setAuthenticated(user, needsCompletion: needsCompletion);
    } catch (_) {}
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(ApiEndpoints.profile, data: data);
      final respData = response.data as Map<String, dynamic>?;
      final userMap = respData?['data'] as Map<String, dynamic>?;
      if (userMap == null) throw Exception(AppErrorCodes.failedUpdateProfile);
      final user = UserModel.fromJson(userMap);
      final needsCompletion = userMap['needs_completion'] == true;
      _setAuthenticated(user, needsCompletion: needsCompletion);
    } on DioException catch (e) {
      final msg =
          e.response?.data?['message'] as String? ??
          AppErrorCodes.failedUpdateProfile;
      state = AuthError(msg);
    }
  }

  Future<String> uploadAvatar(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(filePath),
      });
      final response = await _dio.post(
        ApiEndpoints.profileAvatar,
        data: formData,
      );
      final respData = response.data as Map<String, dynamic>? ?? {};
      final avatarData = respData['data'] as Map<String, dynamic>?;
      if (avatarData != null) {
        final avatarUrl = avatarData['avatar_url'] as String?;
        final current = state;
        if (current is AuthAuthenticated) {
          final updatedUser = current.user.copyWith(avatarUrl: avatarUrl);
          _setAuthenticated(updatedUser);
        }
        return avatarUrl ?? '';
      }
      return '';
    } on DioException catch (e) {
      final msg =
          e.response?.data?['message'] as String? ??
          AppErrorCodes.failedUploadAvatar;
      state = AuthError(msg);
      rethrow;
    }
  }

  /// Extracts a user-friendly error message from a DioException.
  /// Prefers the first field-level validation error from the `errors` map,
  /// then falls back to the top-level `message`, then a generic error code.
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
    return AppErrorCodes.registrationFailed;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
