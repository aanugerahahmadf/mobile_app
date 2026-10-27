// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/profile.proto.

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

import 'auth.pb.dart' as $1;
import 'profile.pb.dart' as $0;

export 'profile.pb.dart';

/// Profile Service
@$pb.GrpcServiceName('wedding.user.v1.ProfileService')
class ProfileServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ProfileServiceClient(super.channel, {super.options, super.interceptors});

  /// Get user profile
  $grpc.ResponseFuture<$0.UserProfile> getProfile(
    $0.GetProfileRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getProfile, request, options: options);
  }

  /// Update user profile
  $grpc.ResponseFuture<$1.User> updateProfile(
    $0.UpdateProfileRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateProfile, request, options: options);
  }

  /// Change password
  $grpc.ResponseFuture<$0.ChangePasswordResponse> changePassword(
    $0.ChangePasswordRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$changePassword, request, options: options);
  }

  /// Update avatar
  $grpc.ResponseFuture<$1.User> updateAvatar(
    $0.UpdateAvatarRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateAvatar, request, options: options);
  }

  /// Delete avatar
  $grpc.ResponseFuture<$1.User> deleteAvatar(
    $0.DeleteAvatarRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteAvatar, request, options: options);
  }

  /// Delete account
  $grpc.ResponseFuture<$0.DeleteAccountResponse> deleteAccount(
    $0.DeleteAccountRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteAccount, request, options: options);
  }

  /// Update notification preferences
  $grpc.ResponseFuture<$1.User> updateNotificationPreferences(
    $0.UpdateNotificationPreferencesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateNotificationPreferences, request,
        options: options);
  }

  /// Update locale preferences
  $grpc.ResponseFuture<$1.User> updateLocalePreferences(
    $0.UpdateLocalePreferencesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateLocalePreferences, request,
        options: options);
  }

  /// Get user addresses
  $grpc.ResponseFuture<$0.UserAddressesResponse> getAddresses(
    $0.GetAddressesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getAddresses, request, options: options);
  }

  /// Create address
  $grpc.ResponseFuture<$0.UserAddress> createAddress(
    $0.CreateAddressRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createAddress, request, options: options);
  }

  /// Update address
  $grpc.ResponseFuture<$0.UserAddress> updateAddress(
    $0.UpdateAddressRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateAddress, request, options: options);
  }

  /// Delete address
  $grpc.ResponseFuture<$0.DeleteAddressResponse> deleteAddress(
    $0.DeleteAddressRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteAddress, request, options: options);
  }

  /// Set default address
  $grpc.ResponseFuture<$0.UserAddress> setDefaultAddress(
    $0.SetDefaultAddressRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setDefaultAddress, request, options: options);
  }

  // method descriptors

  static final _$getProfile =
      $grpc.ClientMethod<$0.GetProfileRequest, $0.UserProfile>(
          '/wedding.user.v1.ProfileService/GetProfile',
          ($0.GetProfileRequest value) => value.writeToBuffer(),
          $0.UserProfile.fromBuffer);
  static final _$updateProfile =
      $grpc.ClientMethod<$0.UpdateProfileRequest, $1.User>(
          '/wedding.user.v1.ProfileService/UpdateProfile',
          ($0.UpdateProfileRequest value) => value.writeToBuffer(),
          $1.User.fromBuffer);
  static final _$changePassword =
      $grpc.ClientMethod<$0.ChangePasswordRequest, $0.ChangePasswordResponse>(
          '/wedding.user.v1.ProfileService/ChangePassword',
          ($0.ChangePasswordRequest value) => value.writeToBuffer(),
          $0.ChangePasswordResponse.fromBuffer);
  static final _$updateAvatar =
      $grpc.ClientMethod<$0.UpdateAvatarRequest, $1.User>(
          '/wedding.user.v1.ProfileService/UpdateAvatar',
          ($0.UpdateAvatarRequest value) => value.writeToBuffer(),
          $1.User.fromBuffer);
  static final _$deleteAvatar =
      $grpc.ClientMethod<$0.DeleteAvatarRequest, $1.User>(
          '/wedding.user.v1.ProfileService/DeleteAvatar',
          ($0.DeleteAvatarRequest value) => value.writeToBuffer(),
          $1.User.fromBuffer);
  static final _$deleteAccount =
      $grpc.ClientMethod<$0.DeleteAccountRequest, $0.DeleteAccountResponse>(
          '/wedding.user.v1.ProfileService/DeleteAccount',
          ($0.DeleteAccountRequest value) => value.writeToBuffer(),
          $0.DeleteAccountResponse.fromBuffer);
  static final _$updateNotificationPreferences =
      $grpc.ClientMethod<$0.UpdateNotificationPreferencesRequest, $1.User>(
          '/wedding.user.v1.ProfileService/UpdateNotificationPreferences',
          ($0.UpdateNotificationPreferencesRequest value) =>
              value.writeToBuffer(),
          $1.User.fromBuffer);
  static final _$updateLocalePreferences =
      $grpc.ClientMethod<$0.UpdateLocalePreferencesRequest, $1.User>(
          '/wedding.user.v1.ProfileService/UpdateLocalePreferences',
          ($0.UpdateLocalePreferencesRequest value) => value.writeToBuffer(),
          $1.User.fromBuffer);
  static final _$getAddresses =
      $grpc.ClientMethod<$0.GetAddressesRequest, $0.UserAddressesResponse>(
          '/wedding.user.v1.ProfileService/GetAddresses',
          ($0.GetAddressesRequest value) => value.writeToBuffer(),
          $0.UserAddressesResponse.fromBuffer);
  static final _$createAddress =
      $grpc.ClientMethod<$0.CreateAddressRequest, $0.UserAddress>(
          '/wedding.user.v1.ProfileService/CreateAddress',
          ($0.CreateAddressRequest value) => value.writeToBuffer(),
          $0.UserAddress.fromBuffer);
  static final _$updateAddress =
      $grpc.ClientMethod<$0.UpdateAddressRequest, $0.UserAddress>(
          '/wedding.user.v1.ProfileService/UpdateAddress',
          ($0.UpdateAddressRequest value) => value.writeToBuffer(),
          $0.UserAddress.fromBuffer);
  static final _$deleteAddress =
      $grpc.ClientMethod<$0.DeleteAddressRequest, $0.DeleteAddressResponse>(
          '/wedding.user.v1.ProfileService/DeleteAddress',
          ($0.DeleteAddressRequest value) => value.writeToBuffer(),
          $0.DeleteAddressResponse.fromBuffer);
  static final _$setDefaultAddress =
      $grpc.ClientMethod<$0.SetDefaultAddressRequest, $0.UserAddress>(
          '/wedding.user.v1.ProfileService/SetDefaultAddress',
          ($0.SetDefaultAddressRequest value) => value.writeToBuffer(),
          $0.UserAddress.fromBuffer);
}

@$pb.GrpcServiceName('wedding.user.v1.ProfileService')
abstract class ProfileServiceBase extends $grpc.Service {
  $core.String get $name => 'wedding.user.v1.ProfileService';

  ProfileServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetProfileRequest, $0.UserProfile>(
        'GetProfile',
        getProfile_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetProfileRequest.fromBuffer(value),
        ($0.UserProfile value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateProfileRequest, $1.User>(
        'UpdateProfile',
        updateProfile_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateProfileRequest.fromBuffer(value),
        ($1.User value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ChangePasswordRequest,
            $0.ChangePasswordResponse>(
        'ChangePassword',
        changePassword_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ChangePasswordRequest.fromBuffer(value),
        ($0.ChangePasswordResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateAvatarRequest, $1.User>(
        'UpdateAvatar',
        updateAvatar_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateAvatarRequest.fromBuffer(value),
        ($1.User value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteAvatarRequest, $1.User>(
        'DeleteAvatar',
        deleteAvatar_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DeleteAvatarRequest.fromBuffer(value),
        ($1.User value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.DeleteAccountRequest, $0.DeleteAccountResponse>(
            'DeleteAccount',
            deleteAccount_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.DeleteAccountRequest.fromBuffer(value),
            ($0.DeleteAccountResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.UpdateNotificationPreferencesRequest, $1.User>(
            'UpdateNotificationPreferences',
            updateNotificationPreferences_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.UpdateNotificationPreferencesRequest.fromBuffer(value),
            ($1.User value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateLocalePreferencesRequest, $1.User>(
        'UpdateLocalePreferences',
        updateLocalePreferences_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateLocalePreferencesRequest.fromBuffer(value),
        ($1.User value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetAddressesRequest, $0.UserAddressesResponse>(
            'GetAddresses',
            getAddresses_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetAddressesRequest.fromBuffer(value),
            ($0.UserAddressesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CreateAddressRequest, $0.UserAddress>(
        'CreateAddress',
        createAddress_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CreateAddressRequest.fromBuffer(value),
        ($0.UserAddress value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateAddressRequest, $0.UserAddress>(
        'UpdateAddress',
        updateAddress_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateAddressRequest.fromBuffer(value),
        ($0.UserAddress value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.DeleteAddressRequest, $0.DeleteAddressResponse>(
            'DeleteAddress',
            deleteAddress_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.DeleteAddressRequest.fromBuffer(value),
            ($0.DeleteAddressResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SetDefaultAddressRequest, $0.UserAddress>(
        'SetDefaultAddress',
        setDefaultAddress_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SetDefaultAddressRequest.fromBuffer(value),
        ($0.UserAddress value) => value.writeToBuffer()));
  }

  $async.Future<$0.UserProfile> getProfile_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetProfileRequest> $request) async {
    return getProfile($call, await $request);
  }

  $async.Future<$0.UserProfile> getProfile(
      $grpc.ServiceCall call, $0.GetProfileRequest request);

  $async.Future<$1.User> updateProfile_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateProfileRequest> $request) async {
    return updateProfile($call, await $request);
  }

  $async.Future<$1.User> updateProfile(
      $grpc.ServiceCall call, $0.UpdateProfileRequest request);

  $async.Future<$0.ChangePasswordResponse> changePassword_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ChangePasswordRequest> $request) async {
    return changePassword($call, await $request);
  }

  $async.Future<$0.ChangePasswordResponse> changePassword(
      $grpc.ServiceCall call, $0.ChangePasswordRequest request);

  $async.Future<$1.User> updateAvatar_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateAvatarRequest> $request) async {
    return updateAvatar($call, await $request);
  }

  $async.Future<$1.User> updateAvatar(
      $grpc.ServiceCall call, $0.UpdateAvatarRequest request);

  $async.Future<$1.User> deleteAvatar_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DeleteAvatarRequest> $request) async {
    return deleteAvatar($call, await $request);
  }

  $async.Future<$1.User> deleteAvatar(
      $grpc.ServiceCall call, $0.DeleteAvatarRequest request);

  $async.Future<$0.DeleteAccountResponse> deleteAccount_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DeleteAccountRequest> $request) async {
    return deleteAccount($call, await $request);
  }

  $async.Future<$0.DeleteAccountResponse> deleteAccount(
      $grpc.ServiceCall call, $0.DeleteAccountRequest request);

  $async.Future<$1.User> updateNotificationPreferences_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateNotificationPreferencesRequest> $request) async {
    return updateNotificationPreferences($call, await $request);
  }

  $async.Future<$1.User> updateNotificationPreferences(
      $grpc.ServiceCall call, $0.UpdateNotificationPreferencesRequest request);

  $async.Future<$1.User> updateLocalePreferences_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateLocalePreferencesRequest> $request) async {
    return updateLocalePreferences($call, await $request);
  }

  $async.Future<$1.User> updateLocalePreferences(
      $grpc.ServiceCall call, $0.UpdateLocalePreferencesRequest request);

  $async.Future<$0.UserAddressesResponse> getAddresses_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetAddressesRequest> $request) async {
    return getAddresses($call, await $request);
  }

  $async.Future<$0.UserAddressesResponse> getAddresses(
      $grpc.ServiceCall call, $0.GetAddressesRequest request);

  $async.Future<$0.UserAddress> createAddress_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CreateAddressRequest> $request) async {
    return createAddress($call, await $request);
  }

  $async.Future<$0.UserAddress> createAddress(
      $grpc.ServiceCall call, $0.CreateAddressRequest request);

  $async.Future<$0.UserAddress> updateAddress_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateAddressRequest> $request) async {
    return updateAddress($call, await $request);
  }

  $async.Future<$0.UserAddress> updateAddress(
      $grpc.ServiceCall call, $0.UpdateAddressRequest request);

  $async.Future<$0.DeleteAddressResponse> deleteAddress_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DeleteAddressRequest> $request) async {
    return deleteAddress($call, await $request);
  }

  $async.Future<$0.DeleteAddressResponse> deleteAddress(
      $grpc.ServiceCall call, $0.DeleteAddressRequest request);

  $async.Future<$0.UserAddress> setDefaultAddress_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SetDefaultAddressRequest> $request) async {
    return setDefaultAddress($call, await $request);
  }

  $async.Future<$0.UserAddress> setDefaultAddress(
      $grpc.ServiceCall call, $0.SetDefaultAddressRequest request);
}
