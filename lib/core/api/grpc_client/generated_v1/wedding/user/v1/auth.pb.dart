// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/auth.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pbenum.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// Login Request/Response
class LoginRequest extends $pb.GeneratedMessage {
  factory LoginRequest({
    $core.String? email,
    $core.String? password,
    $core.String? deviceToken,
    $core.String? deviceType,
    $core.bool? rememberMe,
  }) {
    final result = LoginRequest._();
    if (email != null) result.email = email;
    if (password != null) result.password = password;
    if (deviceToken != null) result.deviceToken = deviceToken;
    if (deviceType != null) result.deviceType = deviceType;
    if (rememberMe != null) result.rememberMe = rememberMe;
    return result;
  }

  LoginRequest._();

  factory LoginRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LoginRequest()..mergeFromBuffer(data, registry);
  factory LoginRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LoginRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LoginRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: LoginRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..aOS(2, _omitFieldNames ? '' : 'password')
    ..aOS(3, _omitFieldNames ? '' : 'deviceToken')
    ..aOS(4, _omitFieldNames ? '' : 'deviceType')
    ..aOB(5, _omitFieldNames ? '' : 'rememberMe')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginRequest copyWith(void Function(LoginRequest) updates) =>
      super.copyWith((message) => updates(message as LoginRequest))
          as LoginRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LoginRequest() / LoginRequest.new instead')
  static LoginRequest create() => LoginRequest._();
  static $pb.GeneratedMessage $_createMessage() => LoginRequest._();
  @$core.override
  LoginRequest createEmptyInstance() => LoginRequest._();
  @$core.pragma('dart2js:noInline')
  static LoginRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoginRequest>(
          LoginRequest.$_createMessage);
  static LoginRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get password => $_getSZ(1);
  @$pb.TagNumber(2)
  set password($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassword() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get deviceToken => $_getSZ(2);
  @$pb.TagNumber(3)
  set deviceToken($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDeviceToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearDeviceToken() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get deviceType => $_getSZ(3);
  @$pb.TagNumber(4)
  set deviceType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDeviceType() => $_has(3);
  @$pb.TagNumber(4)
  void clearDeviceType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get rememberMe => $_getBF(4);
  @$pb.TagNumber(5)
  set rememberMe($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRememberMe() => $_has(4);
  @$pb.TagNumber(5)
  void clearRememberMe() => $_clearField(5);
}

class RegisterRequest extends $pb.GeneratedMessage {
  factory RegisterRequest({
    $core.String? name,
    $core.String? email,
    $core.String? password,
    $core.String? passwordConfirmation,
    $core.String? phone,
    $core.bool? acceptTerms,
    $core.bool? marketingConsent,
  }) {
    final result = RegisterRequest._();
    if (name != null) result.name = name;
    if (email != null) result.email = email;
    if (password != null) result.password = password;
    if (passwordConfirmation != null)
      result.passwordConfirmation = passwordConfirmation;
    if (phone != null) result.phone = phone;
    if (acceptTerms != null) result.acceptTerms = acceptTerms;
    if (marketingConsent != null) result.marketingConsent = marketingConsent;
    return result;
  }

  RegisterRequest._();

  factory RegisterRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RegisterRequest()..mergeFromBuffer(data, registry);
  factory RegisterRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RegisterRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: RegisterRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'email')
    ..aOS(3, _omitFieldNames ? '' : 'password')
    ..aOS(4, _omitFieldNames ? '' : 'passwordConfirmation')
    ..aOS(5, _omitFieldNames ? '' : 'phone')
    ..aOB(6, _omitFieldNames ? '' : 'acceptTerms')
    ..aOB(7, _omitFieldNames ? '' : 'marketingConsent')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterRequest copyWith(void Function(RegisterRequest) updates) =>
      super.copyWith((message) => updates(message as RegisterRequest))
          as RegisterRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RegisterRequest() / RegisterRequest.new instead')
  static RegisterRequest create() => RegisterRequest._();
  static $pb.GeneratedMessage $_createMessage() => RegisterRequest._();
  @$core.override
  RegisterRequest createEmptyInstance() => RegisterRequest._();
  @$core.pragma('dart2js:noInline')
  static RegisterRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RegisterRequest>(
          RegisterRequest.$_createMessage);
  static RegisterRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get email => $_getSZ(1);
  @$pb.TagNumber(2)
  set email($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEmail() => $_has(1);
  @$pb.TagNumber(2)
  void clearEmail() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get password => $_getSZ(2);
  @$pb.TagNumber(3)
  set password($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPassword() => $_has(2);
  @$pb.TagNumber(3)
  void clearPassword() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get passwordConfirmation => $_getSZ(3);
  @$pb.TagNumber(4)
  set passwordConfirmation($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPasswordConfirmation() => $_has(3);
  @$pb.TagNumber(4)
  void clearPasswordConfirmation() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get phone => $_getSZ(4);
  @$pb.TagNumber(5)
  set phone($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPhone() => $_has(4);
  @$pb.TagNumber(5)
  void clearPhone() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get acceptTerms => $_getBF(5);
  @$pb.TagNumber(6)
  set acceptTerms($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAcceptTerms() => $_has(5);
  @$pb.TagNumber(6)
  void clearAcceptTerms() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get marketingConsent => $_getBF(6);
  @$pb.TagNumber(7)
  set marketingConsent($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMarketingConsent() => $_has(6);
  @$pb.TagNumber(7)
  void clearMarketingConsent() => $_clearField(7);
}

class LogoutRequest extends $pb.GeneratedMessage {
  factory LogoutRequest({
    $core.String? refreshToken,
  }) {
    final result = LogoutRequest._();
    if (refreshToken != null) result.refreshToken = refreshToken;
    return result;
  }

  LogoutRequest._();

  factory LogoutRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LogoutRequest()..mergeFromBuffer(data, registry);
  factory LogoutRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LogoutRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LogoutRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: LogoutRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'refreshToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutRequest copyWith(void Function(LogoutRequest) updates) =>
      super.copyWith((message) => updates(message as LogoutRequest))
          as LogoutRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LogoutRequest() / LogoutRequest.new instead')
  static LogoutRequest create() => LogoutRequest._();
  static $pb.GeneratedMessage $_createMessage() => LogoutRequest._();
  @$core.override
  LogoutRequest createEmptyInstance() => LogoutRequest._();
  @$core.pragma('dart2js:noInline')
  static LogoutRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LogoutRequest>(
          LogoutRequest.$_createMessage);
  static LogoutRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get refreshToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set refreshToken($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRefreshToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearRefreshToken() => $_clearField(1);
}

class LogoutResponse extends $pb.GeneratedMessage {
  factory LogoutResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = LogoutResponse._();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  LogoutResponse._();

  factory LogoutResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LogoutResponse()..mergeFromBuffer(data, registry);
  factory LogoutResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LogoutResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LogoutResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: LogoutResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutResponse copyWith(void Function(LogoutResponse) updates) =>
      super.copyWith((message) => updates(message as LogoutResponse))
          as LogoutResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LogoutResponse() / LogoutResponse.new instead')
  static LogoutResponse create() => LogoutResponse._();
  static $pb.GeneratedMessage $_createMessage() => LogoutResponse._();
  @$core.override
  LogoutResponse createEmptyInstance() => LogoutResponse._();
  @$core.pragma('dart2js:noInline')
  static LogoutResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LogoutResponse>(
          LogoutResponse.$_createMessage);
  static LogoutResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

class RefreshTokenRequest extends $pb.GeneratedMessage {
  factory RefreshTokenRequest({
    $core.String? refreshToken,
  }) {
    final result = RefreshTokenRequest._();
    if (refreshToken != null) result.refreshToken = refreshToken;
    return result;
  }

  RefreshTokenRequest._();

  factory RefreshTokenRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RefreshTokenRequest()..mergeFromBuffer(data, registry);
  factory RefreshTokenRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RefreshTokenRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RefreshTokenRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: RefreshTokenRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'refreshToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefreshTokenRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefreshTokenRequest copyWith(void Function(RefreshTokenRequest) updates) =>
      super.copyWith((message) => updates(message as RefreshTokenRequest))
          as RefreshTokenRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use RefreshTokenRequest() / RefreshTokenRequest.new instead')
  static RefreshTokenRequest create() => RefreshTokenRequest._();
  static $pb.GeneratedMessage $_createMessage() => RefreshTokenRequest._();
  @$core.override
  RefreshTokenRequest createEmptyInstance() => RefreshTokenRequest._();
  @$core.pragma('dart2js:noInline')
  static RefreshTokenRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RefreshTokenRequest>(
          RefreshTokenRequest.$_createMessage);
  static RefreshTokenRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get refreshToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set refreshToken($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRefreshToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearRefreshToken() => $_clearField(1);
}

class ForgotPasswordRequest extends $pb.GeneratedMessage {
  factory ForgotPasswordRequest({
    $core.String? email,
  }) {
    final result = ForgotPasswordRequest._();
    if (email != null) result.email = email;
    return result;
  }

  ForgotPasswordRequest._();

  factory ForgotPasswordRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ForgotPasswordRequest()..mergeFromBuffer(data, registry);
  factory ForgotPasswordRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ForgotPasswordRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ForgotPasswordRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ForgotPasswordRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ForgotPasswordRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ForgotPasswordRequest copyWith(
          void Function(ForgotPasswordRequest) updates) =>
      super.copyWith((message) => updates(message as ForgotPasswordRequest))
          as ForgotPasswordRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ForgotPasswordRequest() / ForgotPasswordRequest.new instead')
  static ForgotPasswordRequest create() => ForgotPasswordRequest._();
  static $pb.GeneratedMessage $_createMessage() => ForgotPasswordRequest._();
  @$core.override
  ForgotPasswordRequest createEmptyInstance() => ForgotPasswordRequest._();
  @$core.pragma('dart2js:noInline')
  static ForgotPasswordRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ForgotPasswordRequest>(
          ForgotPasswordRequest.$_createMessage);
  static ForgotPasswordRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => $_clearField(1);
}

class ForgotPasswordResponse extends $pb.GeneratedMessage {
  factory ForgotPasswordResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = ForgotPasswordResponse._();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  ForgotPasswordResponse._();

  factory ForgotPasswordResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ForgotPasswordResponse()..mergeFromBuffer(data, registry);
  factory ForgotPasswordResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ForgotPasswordResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ForgotPasswordResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ForgotPasswordResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ForgotPasswordResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ForgotPasswordResponse copyWith(
          void Function(ForgotPasswordResponse) updates) =>
      super.copyWith((message) => updates(message as ForgotPasswordResponse))
          as ForgotPasswordResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ForgotPasswordResponse() / ForgotPasswordResponse.new instead')
  static ForgotPasswordResponse create() => ForgotPasswordResponse._();
  static $pb.GeneratedMessage $_createMessage() => ForgotPasswordResponse._();
  @$core.override
  ForgotPasswordResponse createEmptyInstance() => ForgotPasswordResponse._();
  @$core.pragma('dart2js:noInline')
  static ForgotPasswordResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ForgotPasswordResponse>(
          ForgotPasswordResponse.$_createMessage);
  static ForgotPasswordResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

class ResetPasswordRequest extends $pb.GeneratedMessage {
  factory ResetPasswordRequest({
    $core.String? token,
    $core.String? email,
    $core.String? password,
    $core.String? passwordConfirmation,
  }) {
    final result = ResetPasswordRequest._();
    if (token != null) result.token = token;
    if (email != null) result.email = email;
    if (password != null) result.password = password;
    if (passwordConfirmation != null)
      result.passwordConfirmation = passwordConfirmation;
    return result;
  }

  ResetPasswordRequest._();

  factory ResetPasswordRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResetPasswordRequest()..mergeFromBuffer(data, registry);
  factory ResetPasswordRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResetPasswordRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResetPasswordRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ResetPasswordRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'token')
    ..aOS(2, _omitFieldNames ? '' : 'email')
    ..aOS(3, _omitFieldNames ? '' : 'password')
    ..aOS(4, _omitFieldNames ? '' : 'passwordConfirmation')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResetPasswordRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResetPasswordRequest copyWith(void Function(ResetPasswordRequest) updates) =>
      super.copyWith((message) => updates(message as ResetPasswordRequest))
          as ResetPasswordRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ResetPasswordRequest() / ResetPasswordRequest.new instead')
  static ResetPasswordRequest create() => ResetPasswordRequest._();
  static $pb.GeneratedMessage $_createMessage() => ResetPasswordRequest._();
  @$core.override
  ResetPasswordRequest createEmptyInstance() => ResetPasswordRequest._();
  @$core.pragma('dart2js:noInline')
  static ResetPasswordRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResetPasswordRequest>(
          ResetPasswordRequest.$_createMessage);
  static ResetPasswordRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get email => $_getSZ(1);
  @$pb.TagNumber(2)
  set email($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEmail() => $_has(1);
  @$pb.TagNumber(2)
  void clearEmail() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get password => $_getSZ(2);
  @$pb.TagNumber(3)
  set password($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPassword() => $_has(2);
  @$pb.TagNumber(3)
  void clearPassword() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get passwordConfirmation => $_getSZ(3);
  @$pb.TagNumber(4)
  set passwordConfirmation($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPasswordConfirmation() => $_has(3);
  @$pb.TagNumber(4)
  void clearPasswordConfirmation() => $_clearField(4);
}

class ResetPasswordResponse extends $pb.GeneratedMessage {
  factory ResetPasswordResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = ResetPasswordResponse._();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  ResetPasswordResponse._();

  factory ResetPasswordResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResetPasswordResponse()..mergeFromBuffer(data, registry);
  factory ResetPasswordResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResetPasswordResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResetPasswordResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ResetPasswordResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResetPasswordResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResetPasswordResponse copyWith(
          void Function(ResetPasswordResponse) updates) =>
      super.copyWith((message) => updates(message as ResetPasswordResponse))
          as ResetPasswordResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ResetPasswordResponse() / ResetPasswordResponse.new instead')
  static ResetPasswordResponse create() => ResetPasswordResponse._();
  static $pb.GeneratedMessage $_createMessage() => ResetPasswordResponse._();
  @$core.override
  ResetPasswordResponse createEmptyInstance() => ResetPasswordResponse._();
  @$core.pragma('dart2js:noInline')
  static ResetPasswordResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResetPasswordResponse>(
          ResetPasswordResponse.$_createMessage);
  static ResetPasswordResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

class VerifyEmailRequest extends $pb.GeneratedMessage {
  factory VerifyEmailRequest({
    $core.String? token,
    $core.String? email,
  }) {
    final result = VerifyEmailRequest._();
    if (token != null) result.token = token;
    if (email != null) result.email = email;
    return result;
  }

  VerifyEmailRequest._();

  factory VerifyEmailRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VerifyEmailRequest()..mergeFromBuffer(data, registry);
  factory VerifyEmailRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VerifyEmailRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VerifyEmailRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: VerifyEmailRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'token')
    ..aOS(2, _omitFieldNames ? '' : 'email')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyEmailRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyEmailRequest copyWith(void Function(VerifyEmailRequest) updates) =>
      super.copyWith((message) => updates(message as VerifyEmailRequest))
          as VerifyEmailRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use VerifyEmailRequest() / VerifyEmailRequest.new instead')
  static VerifyEmailRequest create() => VerifyEmailRequest._();
  static $pb.GeneratedMessage $_createMessage() => VerifyEmailRequest._();
  @$core.override
  VerifyEmailRequest createEmptyInstance() => VerifyEmailRequest._();
  @$core.pragma('dart2js:noInline')
  static VerifyEmailRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VerifyEmailRequest>(
          VerifyEmailRequest.$_createMessage);
  static VerifyEmailRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get email => $_getSZ(1);
  @$pb.TagNumber(2)
  set email($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEmail() => $_has(1);
  @$pb.TagNumber(2)
  void clearEmail() => $_clearField(2);
}

class VerifyEmailResponse extends $pb.GeneratedMessage {
  factory VerifyEmailResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = VerifyEmailResponse._();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  VerifyEmailResponse._();

  factory VerifyEmailResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VerifyEmailResponse()..mergeFromBuffer(data, registry);
  factory VerifyEmailResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VerifyEmailResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VerifyEmailResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: VerifyEmailResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyEmailResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyEmailResponse copyWith(void Function(VerifyEmailResponse) updates) =>
      super.copyWith((message) => updates(message as VerifyEmailResponse))
          as VerifyEmailResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use VerifyEmailResponse() / VerifyEmailResponse.new instead')
  static VerifyEmailResponse create() => VerifyEmailResponse._();
  static $pb.GeneratedMessage $_createMessage() => VerifyEmailResponse._();
  @$core.override
  VerifyEmailResponse createEmptyInstance() => VerifyEmailResponse._();
  @$core.pragma('dart2js:noInline')
  static VerifyEmailResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VerifyEmailResponse>(
          VerifyEmailResponse.$_createMessage);
  static VerifyEmailResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

class ResendVerificationRequest extends $pb.GeneratedMessage {
  factory ResendVerificationRequest({
    $core.String? email,
  }) {
    final result = ResendVerificationRequest._();
    if (email != null) result.email = email;
    return result;
  }

  ResendVerificationRequest._();

  factory ResendVerificationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResendVerificationRequest()..mergeFromBuffer(data, registry);
  factory ResendVerificationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResendVerificationRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResendVerificationRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ResendVerificationRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResendVerificationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResendVerificationRequest copyWith(
          void Function(ResendVerificationRequest) updates) =>
      super.copyWith((message) => updates(message as ResendVerificationRequest))
          as ResendVerificationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ResendVerificationRequest() / ResendVerificationRequest.new instead')
  static ResendVerificationRequest create() => ResendVerificationRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ResendVerificationRequest._();
  @$core.override
  ResendVerificationRequest createEmptyInstance() =>
      ResendVerificationRequest._();
  @$core.pragma('dart2js:noInline')
  static ResendVerificationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResendVerificationRequest>(
          ResendVerificationRequest.$_createMessage);
  static ResendVerificationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => $_clearField(1);
}

class ResendVerificationResponse extends $pb.GeneratedMessage {
  factory ResendVerificationResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = ResendVerificationResponse._();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  ResendVerificationResponse._();

  factory ResendVerificationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResendVerificationResponse()..mergeFromBuffer(data, registry);
  factory ResendVerificationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResendVerificationResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResendVerificationResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ResendVerificationResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResendVerificationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResendVerificationResponse copyWith(
          void Function(ResendVerificationResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ResendVerificationResponse))
          as ResendVerificationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ResendVerificationResponse() / ResendVerificationResponse.new instead')
  static ResendVerificationResponse create() => ResendVerificationResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ResendVerificationResponse._();
  @$core.override
  ResendVerificationResponse createEmptyInstance() =>
      ResendVerificationResponse._();
  @$core.pragma('dart2js:noInline')
  static ResendVerificationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResendVerificationResponse>(
          ResendVerificationResponse.$_createMessage);
  static ResendVerificationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

class MeRequest extends $pb.GeneratedMessage {
  factory MeRequest() => MeRequest._();

  MeRequest._();

  factory MeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MeRequest()..mergeFromBuffer(data, registry);
  factory MeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MeRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: MeRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MeRequest copyWith(void Function(MeRequest) updates) =>
      super.copyWith((message) => updates(message as MeRequest)) as MeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use MeRequest() / MeRequest.new instead')
  static MeRequest create() => MeRequest._();
  static $pb.GeneratedMessage $_createMessage() => MeRequest._();
  @$core.override
  MeRequest createEmptyInstance() => MeRequest._();
  @$core.pragma('dart2js:noInline')
  static MeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MeRequest>(MeRequest.$_createMessage);
  static MeRequest? _defaultInstance;
}

class AuthResponse extends $pb.GeneratedMessage {
  factory AuthResponse({
    User? user,
    $core.String? accessToken,
    $core.String? tokenType,
    $core.int? expiresIn,
    $core.String? refreshToken,
    $core.int? refreshExpiresIn,
  }) {
    final result = AuthResponse._();
    if (user != null) result.user = user;
    if (accessToken != null) result.accessToken = accessToken;
    if (tokenType != null) result.tokenType = tokenType;
    if (expiresIn != null) result.expiresIn = expiresIn;
    if (refreshToken != null) result.refreshToken = refreshToken;
    if (refreshExpiresIn != null) result.refreshExpiresIn = refreshExpiresIn;
    return result;
  }

  AuthResponse._();

  factory AuthResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AuthResponse()..mergeFromBuffer(data, registry);
  factory AuthResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AuthResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AuthResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: AuthResponse.$_createMessage)
    ..aOM<User>(1, _omitFieldNames ? '' : 'user',
        subBuilder: User.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'accessToken')
    ..aOS(3, _omitFieldNames ? '' : 'tokenType')
    ..aI(4, _omitFieldNames ? '' : 'expiresIn')
    ..aOS(5, _omitFieldNames ? '' : 'refreshToken')
    ..aI(6, _omitFieldNames ? '' : 'refreshExpiresIn')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthResponse copyWith(void Function(AuthResponse) updates) =>
      super.copyWith((message) => updates(message as AuthResponse))
          as AuthResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AuthResponse() / AuthResponse.new instead')
  static AuthResponse create() => AuthResponse._();
  static $pb.GeneratedMessage $_createMessage() => AuthResponse._();
  @$core.override
  AuthResponse createEmptyInstance() => AuthResponse._();
  @$core.pragma('dart2js:noInline')
  static AuthResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthResponse>(
          AuthResponse.$_createMessage);
  static AuthResponse? _defaultInstance;

  @$pb.TagNumber(1)
  User get user => $_getN(0);
  @$pb.TagNumber(1)
  set user(User value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => $_clearField(1);
  @$pb.TagNumber(1)
  User ensureUser() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get accessToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set accessToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAccessToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccessToken() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get tokenType => $_getSZ(2);
  @$pb.TagNumber(3)
  set tokenType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTokenType() => $_has(2);
  @$pb.TagNumber(3)
  void clearTokenType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get expiresIn => $_getIZ(3);
  @$pb.TagNumber(4)
  set expiresIn($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpiresIn() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpiresIn() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get refreshToken => $_getSZ(4);
  @$pb.TagNumber(5)
  set refreshToken($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRefreshToken() => $_has(4);
  @$pb.TagNumber(5)
  void clearRefreshToken() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get refreshExpiresIn => $_getIZ(5);
  @$pb.TagNumber(6)
  set refreshExpiresIn($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRefreshExpiresIn() => $_has(5);
  @$pb.TagNumber(6)
  void clearRefreshExpiresIn() => $_clearField(6);
}

/// User entity
class User extends $pb.GeneratedMessage {
  factory User({
    $core.String? id,
    $core.String? name,
    $core.String? email,
    $core.String? phone,
    $core.String? avatar,
    $core.String? emailVerifiedAt,
    $core.String? address,
    $core.String? city,
    $core.String? province,
    $core.String? postalCode,
    $core.String? dateOfBirth,
    $1.Gender? gender,
    $core.bool? notificationEmail,
    $core.bool? notificationSms,
    $core.bool? notificationPush,
    $core.String? language,
    $core.String? currency,
    $core.String? timezone,
    $core.Iterable<$core.String>? roles,
    $core.String? createdAt,
    $core.String? updatedAt,
    $core.double? profileCompletion,
  }) {
    final result = User._();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (email != null) result.email = email;
    if (phone != null) result.phone = phone;
    if (avatar != null) result.avatar = avatar;
    if (emailVerifiedAt != null) result.emailVerifiedAt = emailVerifiedAt;
    if (address != null) result.address = address;
    if (city != null) result.city = city;
    if (province != null) result.province = province;
    if (postalCode != null) result.postalCode = postalCode;
    if (dateOfBirth != null) result.dateOfBirth = dateOfBirth;
    if (gender != null) result.gender = gender;
    if (notificationEmail != null) result.notificationEmail = notificationEmail;
    if (notificationSms != null) result.notificationSms = notificationSms;
    if (notificationPush != null) result.notificationPush = notificationPush;
    if (language != null) result.language = language;
    if (currency != null) result.currency = currency;
    if (timezone != null) result.timezone = timezone;
    if (roles != null) result.roles.addAll(roles);
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (profileCompletion != null) result.profileCompletion = profileCompletion;
    return result;
  }

  User._();

  factory User.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      User()..mergeFromBuffer(data, registry);
  factory User.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      User()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'User',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: User.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'email')
    ..aOS(4, _omitFieldNames ? '' : 'phone')
    ..aOS(5, _omitFieldNames ? '' : 'avatar')
    ..aOS(6, _omitFieldNames ? '' : 'emailVerifiedAt')
    ..aOS(7, _omitFieldNames ? '' : 'address')
    ..aOS(8, _omitFieldNames ? '' : 'city')
    ..aOS(9, _omitFieldNames ? '' : 'province')
    ..aOS(10, _omitFieldNames ? '' : 'postalCode')
    ..aOS(11, _omitFieldNames ? '' : 'dateOfBirth')
    ..aE<$1.Gender>(12, _omitFieldNames ? '' : 'gender',
        enumValues: $1.Gender.values)
    ..aOB(13, _omitFieldNames ? '' : 'notificationEmail')
    ..aOB(14, _omitFieldNames ? '' : 'notificationSms')
    ..aOB(15, _omitFieldNames ? '' : 'notificationPush')
    ..aOS(16, _omitFieldNames ? '' : 'language')
    ..aOS(17, _omitFieldNames ? '' : 'currency')
    ..aOS(18, _omitFieldNames ? '' : 'timezone')
    ..pPS(19, _omitFieldNames ? '' : 'roles')
    ..aOS(20, _omitFieldNames ? '' : 'createdAt')
    ..aOS(21, _omitFieldNames ? '' : 'updatedAt')
    ..aD(22, _omitFieldNames ? '' : 'profileCompletion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  User clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  User copyWith(void Function(User) updates) =>
      super.copyWith((message) => updates(message as User)) as User;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use User() / User.new instead')
  static User create() => User._();
  static $pb.GeneratedMessage $_createMessage() => User._();
  @$core.override
  User createEmptyInstance() => User._();
  @$core.pragma('dart2js:noInline')
  static User getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<User>(User.$_createMessage);
  static User? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get email => $_getSZ(2);
  @$pb.TagNumber(3)
  set email($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEmail() => $_has(2);
  @$pb.TagNumber(3)
  void clearEmail() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get phone => $_getSZ(3);
  @$pb.TagNumber(4)
  set phone($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPhone() => $_has(3);
  @$pb.TagNumber(4)
  void clearPhone() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get avatar => $_getSZ(4);
  @$pb.TagNumber(5)
  set avatar($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAvatar() => $_has(4);
  @$pb.TagNumber(5)
  void clearAvatar() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get emailVerifiedAt => $_getSZ(5);
  @$pb.TagNumber(6)
  set emailVerifiedAt($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEmailVerifiedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearEmailVerifiedAt() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get address => $_getSZ(6);
  @$pb.TagNumber(7)
  set address($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAddress() => $_has(6);
  @$pb.TagNumber(7)
  void clearAddress() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get city => $_getSZ(7);
  @$pb.TagNumber(8)
  set city($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCity() => $_has(7);
  @$pb.TagNumber(8)
  void clearCity() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get province => $_getSZ(8);
  @$pb.TagNumber(9)
  set province($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasProvince() => $_has(8);
  @$pb.TagNumber(9)
  void clearProvince() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get postalCode => $_getSZ(9);
  @$pb.TagNumber(10)
  set postalCode($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasPostalCode() => $_has(9);
  @$pb.TagNumber(10)
  void clearPostalCode() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get dateOfBirth => $_getSZ(10);
  @$pb.TagNumber(11)
  set dateOfBirth($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasDateOfBirth() => $_has(10);
  @$pb.TagNumber(11)
  void clearDateOfBirth() => $_clearField(11);

  @$pb.TagNumber(12)
  $1.Gender get gender => $_getN(11);
  @$pb.TagNumber(12)
  set gender($1.Gender value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasGender() => $_has(11);
  @$pb.TagNumber(12)
  void clearGender() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.bool get notificationEmail => $_getBF(12);
  @$pb.TagNumber(13)
  set notificationEmail($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasNotificationEmail() => $_has(12);
  @$pb.TagNumber(13)
  void clearNotificationEmail() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.bool get notificationSms => $_getBF(13);
  @$pb.TagNumber(14)
  set notificationSms($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(14)
  $core.bool hasNotificationSms() => $_has(13);
  @$pb.TagNumber(14)
  void clearNotificationSms() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.bool get notificationPush => $_getBF(14);
  @$pb.TagNumber(15)
  set notificationPush($core.bool value) => $_setBool(14, value);
  @$pb.TagNumber(15)
  $core.bool hasNotificationPush() => $_has(14);
  @$pb.TagNumber(15)
  void clearNotificationPush() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get language => $_getSZ(15);
  @$pb.TagNumber(16)
  set language($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasLanguage() => $_has(15);
  @$pb.TagNumber(16)
  void clearLanguage() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get currency => $_getSZ(16);
  @$pb.TagNumber(17)
  set currency($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasCurrency() => $_has(16);
  @$pb.TagNumber(17)
  void clearCurrency() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.String get timezone => $_getSZ(17);
  @$pb.TagNumber(18)
  set timezone($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasTimezone() => $_has(17);
  @$pb.TagNumber(18)
  void clearTimezone() => $_clearField(18);

  @$pb.TagNumber(19)
  $pb.PbList<$core.String> get roles => $_getList(18);

  @$pb.TagNumber(20)
  $core.String get createdAt => $_getSZ(19);
  @$pb.TagNumber(20)
  set createdAt($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasCreatedAt() => $_has(19);
  @$pb.TagNumber(20)
  void clearCreatedAt() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.String get updatedAt => $_getSZ(20);
  @$pb.TagNumber(21)
  set updatedAt($core.String value) => $_setString(20, value);
  @$pb.TagNumber(21)
  $core.bool hasUpdatedAt() => $_has(20);
  @$pb.TagNumber(21)
  void clearUpdatedAt() => $_clearField(21);

  @$pb.TagNumber(22)
  $core.double get profileCompletion => $_getN(21);
  @$pb.TagNumber(22)
  set profileCompletion($core.double value) => $_setDouble(21, value);
  @$pb.TagNumber(22)
  $core.bool hasProfileCompletion() => $_has(21);
  @$pb.TagNumber(22)
  void clearProfileCompletion() => $_clearField(22);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
