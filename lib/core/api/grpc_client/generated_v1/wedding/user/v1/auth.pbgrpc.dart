// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/auth.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'auth.pb.dart' as $0;

export 'auth.pb.dart';

/// Auth Service
@$pb.GrpcServiceName('wedding.user.v1.AuthService')
class AuthServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  AuthServiceClient(super.channel, {super.options, super.interceptors});

  /// Login with email and password
  $grpc.ResponseFuture<$0.AuthResponse> login(
    $0.LoginRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$login, request, options: options);
  }

  /// Register new user
  $grpc.ResponseFuture<$0.AuthResponse> register(
    $0.RegisterRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$register, request, options: options);
  }

  /// Logout current user
  $grpc.ResponseFuture<$0.LogoutResponse> logout(
    $0.LogoutRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$logout, request, options: options);
  }

  /// Refresh access token
  $grpc.ResponseFuture<$0.AuthResponse> refreshToken(
    $0.RefreshTokenRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$refreshToken, request, options: options);
  }

  /// Request password reset
  $grpc.ResponseFuture<$0.ForgotPasswordResponse> forgotPassword(
    $0.ForgotPasswordRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$forgotPassword, request, options: options);
  }

  /// Reset password with token
  $grpc.ResponseFuture<$0.ResetPasswordResponse> resetPassword(
    $0.ResetPasswordRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$resetPassword, request, options: options);
  }

  /// Verify email with token
  $grpc.ResponseFuture<$0.VerifyEmailResponse> verifyEmail(
    $0.VerifyEmailRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$verifyEmail, request, options: options);
  }

  /// Resend verification email
  $grpc.ResponseFuture<$0.ResendVerificationResponse> resendVerification(
    $0.ResendVerificationRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$resendVerification, request, options: options);
  }

  /// Get current authenticated user
  $grpc.ResponseFuture<$0.User> me(
    $0.MeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$me, request, options: options);
  }

  // method descriptors

  static final _$login = $grpc.ClientMethod<$0.LoginRequest, $0.AuthResponse>(
      '/wedding.user.v1.AuthService/Login',
      ($0.LoginRequest value) => value.writeToBuffer(),
      $0.AuthResponse.fromBuffer);
  static final _$register =
      $grpc.ClientMethod<$0.RegisterRequest, $0.AuthResponse>(
          '/wedding.user.v1.AuthService/Register',
          ($0.RegisterRequest value) => value.writeToBuffer(),
          $0.AuthResponse.fromBuffer);
  static final _$logout =
      $grpc.ClientMethod<$0.LogoutRequest, $0.LogoutResponse>(
          '/wedding.user.v1.AuthService/Logout',
          ($0.LogoutRequest value) => value.writeToBuffer(),
          $0.LogoutResponse.fromBuffer);
  static final _$refreshToken =
      $grpc.ClientMethod<$0.RefreshTokenRequest, $0.AuthResponse>(
          '/wedding.user.v1.AuthService/RefreshToken',
          ($0.RefreshTokenRequest value) => value.writeToBuffer(),
          $0.AuthResponse.fromBuffer);
  static final _$forgotPassword =
      $grpc.ClientMethod<$0.ForgotPasswordRequest, $0.ForgotPasswordResponse>(
          '/wedding.user.v1.AuthService/ForgotPassword',
          ($0.ForgotPasswordRequest value) => value.writeToBuffer(),
          $0.ForgotPasswordResponse.fromBuffer);
  static final _$resetPassword =
      $grpc.ClientMethod<$0.ResetPasswordRequest, $0.ResetPasswordResponse>(
          '/wedding.user.v1.AuthService/ResetPassword',
          ($0.ResetPasswordRequest value) => value.writeToBuffer(),
          $0.ResetPasswordResponse.fromBuffer);
  static final _$verifyEmail =
      $grpc.ClientMethod<$0.VerifyEmailRequest, $0.VerifyEmailResponse>(
          '/wedding.user.v1.AuthService/VerifyEmail',
          ($0.VerifyEmailRequest value) => value.writeToBuffer(),
          $0.VerifyEmailResponse.fromBuffer);
  static final _$resendVerification = $grpc.ClientMethod<
          $0.ResendVerificationRequest, $0.ResendVerificationResponse>(
      '/wedding.user.v1.AuthService/ResendVerification',
      ($0.ResendVerificationRequest value) => value.writeToBuffer(),
      $0.ResendVerificationResponse.fromBuffer);
  static final _$me = $grpc.ClientMethod<$0.MeRequest, $0.User>(
      '/wedding.user.v1.AuthService/Me',
      ($0.MeRequest value) => value.writeToBuffer(),
      $0.User.fromBuffer);
}

@$pb.GrpcServiceName('wedding.user.v1.AuthService')
abstract class AuthServiceBase extends $grpc.Service {
  $core.String get $name => 'wedding.user.v1.AuthService';

  AuthServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.LoginRequest, $0.AuthResponse>(
        'Login',
        login_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LoginRequest.fromBuffer(value),
        ($0.AuthResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RegisterRequest, $0.AuthResponse>(
        'Register',
        register_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RegisterRequest.fromBuffer(value),
        ($0.AuthResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LogoutRequest, $0.LogoutResponse>(
        'Logout',
        logout_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LogoutRequest.fromBuffer(value),
        ($0.LogoutResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RefreshTokenRequest, $0.AuthResponse>(
        'RefreshToken',
        refreshToken_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RefreshTokenRequest.fromBuffer(value),
        ($0.AuthResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ForgotPasswordRequest,
            $0.ForgotPasswordResponse>(
        'ForgotPassword',
        forgotPassword_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ForgotPasswordRequest.fromBuffer(value),
        ($0.ForgotPasswordResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ResetPasswordRequest, $0.ResetPasswordResponse>(
            'ResetPassword',
            resetPassword_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ResetPasswordRequest.fromBuffer(value),
            ($0.ResetPasswordResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.VerifyEmailRequest, $0.VerifyEmailResponse>(
            'VerifyEmail',
            verifyEmail_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.VerifyEmailRequest.fromBuffer(value),
            ($0.VerifyEmailResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ResendVerificationRequest,
            $0.ResendVerificationResponse>(
        'ResendVerification',
        resendVerification_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ResendVerificationRequest.fromBuffer(value),
        ($0.ResendVerificationResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.MeRequest, $0.User>(
        'Me',
        me_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.MeRequest.fromBuffer(value),
        ($0.User value) => value.writeToBuffer()));
  }

  $async.Future<$0.AuthResponse> login_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.LoginRequest> $request) async {
    return login($call, await $request);
  }

  $async.Future<$0.AuthResponse> login(
      $grpc.ServiceCall call, $0.LoginRequest request);

  $async.Future<$0.AuthResponse> register_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RegisterRequest> $request) async {
    return register($call, await $request);
  }

  $async.Future<$0.AuthResponse> register(
      $grpc.ServiceCall call, $0.RegisterRequest request);

  $async.Future<$0.LogoutResponse> logout_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.LogoutRequest> $request) async {
    return logout($call, await $request);
  }

  $async.Future<$0.LogoutResponse> logout(
      $grpc.ServiceCall call, $0.LogoutRequest request);

  $async.Future<$0.AuthResponse> refreshToken_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RefreshTokenRequest> $request) async {
    return refreshToken($call, await $request);
  }

  $async.Future<$0.AuthResponse> refreshToken(
      $grpc.ServiceCall call, $0.RefreshTokenRequest request);

  $async.Future<$0.ForgotPasswordResponse> forgotPassword_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ForgotPasswordRequest> $request) async {
    return forgotPassword($call, await $request);
  }

  $async.Future<$0.ForgotPasswordResponse> forgotPassword(
      $grpc.ServiceCall call, $0.ForgotPasswordRequest request);

  $async.Future<$0.ResetPasswordResponse> resetPassword_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ResetPasswordRequest> $request) async {
    return resetPassword($call, await $request);
  }

  $async.Future<$0.ResetPasswordResponse> resetPassword(
      $grpc.ServiceCall call, $0.ResetPasswordRequest request);

  $async.Future<$0.VerifyEmailResponse> verifyEmail_Pre($grpc.ServiceCall $call,
      $async.Future<$0.VerifyEmailRequest> $request) async {
    return verifyEmail($call, await $request);
  }

  $async.Future<$0.VerifyEmailResponse> verifyEmail(
      $grpc.ServiceCall call, $0.VerifyEmailRequest request);

  $async.Future<$0.ResendVerificationResponse> resendVerification_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ResendVerificationRequest> $request) async {
    return resendVerification($call, await $request);
  }

  $async.Future<$0.ResendVerificationResponse> resendVerification(
      $grpc.ServiceCall call, $0.ResendVerificationRequest request);

  $async.Future<$0.User> me_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.MeRequest> $request) async {
    return me($call, await $request);
  }

  $async.Future<$0.User> me($grpc.ServiceCall call, $0.MeRequest request);
}
