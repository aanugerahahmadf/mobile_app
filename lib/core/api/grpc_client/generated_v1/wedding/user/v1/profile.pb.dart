// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/profile.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'auth.pb.dart' as $1;
import 'category.pb.dart' as $2;
import 'common.pbenum.dart' as $3;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// Profile Requests/Responses
class GetProfileRequest extends $pb.GeneratedMessage {
  factory GetProfileRequest({
    $core.String? userId,
  }) {
    final result = GetProfileRequest._();
    if (userId != null) result.userId = userId;
    return result;
  }

  GetProfileRequest._();

  factory GetProfileRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetProfileRequest()..mergeFromBuffer(data, registry);
  factory GetProfileRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetProfileRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetProfileRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetProfileRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetProfileRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetProfileRequest copyWith(void Function(GetProfileRequest) updates) =>
      super.copyWith((message) => updates(message as GetProfileRequest))
          as GetProfileRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetProfileRequest() / GetProfileRequest.new instead')
  static GetProfileRequest create() => GetProfileRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetProfileRequest._();
  @$core.override
  GetProfileRequest createEmptyInstance() => GetProfileRequest._();
  @$core.pragma('dart2js:noInline')
  static GetProfileRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetProfileRequest>(
          GetProfileRequest.$_createMessage);
  static GetProfileRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);
}

class UserProfile extends $pb.GeneratedMessage {
  factory UserProfile({
    $1.User? user,
    $core.int? orderCount,
    $core.int? reviewCount,
    $core.int? wishlistCount,
    $core.double? totalSpent,
    $2.Category? favoriteCategory,
    $core.String? joinedAt,
  }) {
    final result = UserProfile._();
    if (user != null) result.user = user;
    if (orderCount != null) result.orderCount = orderCount;
    if (reviewCount != null) result.reviewCount = reviewCount;
    if (wishlistCount != null) result.wishlistCount = wishlistCount;
    if (totalSpent != null) result.totalSpent = totalSpent;
    if (favoriteCategory != null) result.favoriteCategory = favoriteCategory;
    if (joinedAt != null) result.joinedAt = joinedAt;
    return result;
  }

  UserProfile._();

  factory UserProfile.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserProfile()..mergeFromBuffer(data, registry);
  factory UserProfile.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserProfile()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserProfile',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: UserProfile.$_createMessage)
    ..aOM<$1.User>(1, _omitFieldNames ? '' : 'user',
        subBuilder: $1.User.$_createMessage)
    ..aI(2, _omitFieldNames ? '' : 'orderCount')
    ..aI(3, _omitFieldNames ? '' : 'reviewCount')
    ..aI(4, _omitFieldNames ? '' : 'wishlistCount')
    ..aD(5, _omitFieldNames ? '' : 'totalSpent')
    ..aOM<$2.Category>(6, _omitFieldNames ? '' : 'favoriteCategory',
        subBuilder: $2.Category.$_createMessage)
    ..aOS(7, _omitFieldNames ? '' : 'joinedAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserProfile clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserProfile copyWith(void Function(UserProfile) updates) =>
      super.copyWith((message) => updates(message as UserProfile))
          as UserProfile;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UserProfile() / UserProfile.new instead')
  static UserProfile create() => UserProfile._();
  static $pb.GeneratedMessage $_createMessage() => UserProfile._();
  @$core.override
  UserProfile createEmptyInstance() => UserProfile._();
  @$core.pragma('dart2js:noInline')
  static UserProfile getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserProfile>(
          UserProfile.$_createMessage);
  static UserProfile? _defaultInstance;

  @$pb.TagNumber(1)
  $1.User get user => $_getN(0);
  @$pb.TagNumber(1)
  set user($1.User value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.User ensureUser() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get orderCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set orderCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOrderCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrderCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get reviewCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set reviewCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReviewCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearReviewCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get wishlistCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set wishlistCount($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWishlistCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearWishlistCount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get totalSpent => $_getN(4);
  @$pb.TagNumber(5)
  set totalSpent($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTotalSpent() => $_has(4);
  @$pb.TagNumber(5)
  void clearTotalSpent() => $_clearField(5);

  @$pb.TagNumber(6)
  $2.Category get favoriteCategory => $_getN(5);
  @$pb.TagNumber(6)
  set favoriteCategory($2.Category value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasFavoriteCategory() => $_has(5);
  @$pb.TagNumber(6)
  void clearFavoriteCategory() => $_clearField(6);
  @$pb.TagNumber(6)
  $2.Category ensureFavoriteCategory() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get joinedAt => $_getSZ(6);
  @$pb.TagNumber(7)
  set joinedAt($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasJoinedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearJoinedAt() => $_clearField(7);
}

class UpdateProfileRequest extends $pb.GeneratedMessage {
  factory UpdateProfileRequest({
    $core.String? name,
    $core.String? phone,
    $core.String? address,
    $core.String? city,
    $core.String? province,
    $core.String? postalCode,
    $core.String? dateOfBirth,
    $3.Gender? gender,
    $core.String? avatar,
    $core.bool? notificationEmail,
    $core.bool? notificationSms,
    $core.bool? notificationPush,
    $core.String? language,
    $core.String? currency,
    $core.String? timezone,
  }) {
    final result = UpdateProfileRequest._();
    if (name != null) result.name = name;
    if (phone != null) result.phone = phone;
    if (address != null) result.address = address;
    if (city != null) result.city = city;
    if (province != null) result.province = province;
    if (postalCode != null) result.postalCode = postalCode;
    if (dateOfBirth != null) result.dateOfBirth = dateOfBirth;
    if (gender != null) result.gender = gender;
    if (avatar != null) result.avatar = avatar;
    if (notificationEmail != null) result.notificationEmail = notificationEmail;
    if (notificationSms != null) result.notificationSms = notificationSms;
    if (notificationPush != null) result.notificationPush = notificationPush;
    if (language != null) result.language = language;
    if (currency != null) result.currency = currency;
    if (timezone != null) result.timezone = timezone;
    return result;
  }

  UpdateProfileRequest._();

  factory UpdateProfileRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateProfileRequest()..mergeFromBuffer(data, registry);
  factory UpdateProfileRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateProfileRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateProfileRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: UpdateProfileRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'phone')
    ..aOS(3, _omitFieldNames ? '' : 'address')
    ..aOS(4, _omitFieldNames ? '' : 'city')
    ..aOS(5, _omitFieldNames ? '' : 'province')
    ..aOS(6, _omitFieldNames ? '' : 'postalCode')
    ..aOS(7, _omitFieldNames ? '' : 'dateOfBirth')
    ..aE<$3.Gender>(8, _omitFieldNames ? '' : 'gender',
        enumValues: $3.Gender.values)
    ..aOS(9, _omitFieldNames ? '' : 'avatar')
    ..aOB(10, _omitFieldNames ? '' : 'notificationEmail')
    ..aOB(11, _omitFieldNames ? '' : 'notificationSms')
    ..aOB(12, _omitFieldNames ? '' : 'notificationPush')
    ..aOS(13, _omitFieldNames ? '' : 'language')
    ..aOS(14, _omitFieldNames ? '' : 'currency')
    ..aOS(15, _omitFieldNames ? '' : 'timezone')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateProfileRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateProfileRequest copyWith(void Function(UpdateProfileRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateProfileRequest))
          as UpdateProfileRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateProfileRequest() / UpdateProfileRequest.new instead')
  static UpdateProfileRequest create() => UpdateProfileRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdateProfileRequest._();
  @$core.override
  UpdateProfileRequest createEmptyInstance() => UpdateProfileRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateProfileRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateProfileRequest>(
          UpdateProfileRequest.$_createMessage);
  static UpdateProfileRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get phone => $_getSZ(1);
  @$pb.TagNumber(2)
  set phone($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPhone() => $_has(1);
  @$pb.TagNumber(2)
  void clearPhone() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get address => $_getSZ(2);
  @$pb.TagNumber(3)
  set address($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAddress() => $_has(2);
  @$pb.TagNumber(3)
  void clearAddress() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get city => $_getSZ(3);
  @$pb.TagNumber(4)
  set city($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCity() => $_has(3);
  @$pb.TagNumber(4)
  void clearCity() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get province => $_getSZ(4);
  @$pb.TagNumber(5)
  set province($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasProvince() => $_has(4);
  @$pb.TagNumber(5)
  void clearProvince() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get postalCode => $_getSZ(5);
  @$pb.TagNumber(6)
  set postalCode($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPostalCode() => $_has(5);
  @$pb.TagNumber(6)
  void clearPostalCode() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get dateOfBirth => $_getSZ(6);
  @$pb.TagNumber(7)
  set dateOfBirth($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDateOfBirth() => $_has(6);
  @$pb.TagNumber(7)
  void clearDateOfBirth() => $_clearField(7);

  @$pb.TagNumber(8)
  $3.Gender get gender => $_getN(7);
  @$pb.TagNumber(8)
  set gender($3.Gender value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasGender() => $_has(7);
  @$pb.TagNumber(8)
  void clearGender() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get avatar => $_getSZ(8);
  @$pb.TagNumber(9)
  set avatar($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAvatar() => $_has(8);
  @$pb.TagNumber(9)
  void clearAvatar() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get notificationEmail => $_getBF(9);
  @$pb.TagNumber(10)
  set notificationEmail($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasNotificationEmail() => $_has(9);
  @$pb.TagNumber(10)
  void clearNotificationEmail() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get notificationSms => $_getBF(10);
  @$pb.TagNumber(11)
  set notificationSms($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasNotificationSms() => $_has(10);
  @$pb.TagNumber(11)
  void clearNotificationSms() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get notificationPush => $_getBF(11);
  @$pb.TagNumber(12)
  set notificationPush($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasNotificationPush() => $_has(11);
  @$pb.TagNumber(12)
  void clearNotificationPush() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get language => $_getSZ(12);
  @$pb.TagNumber(13)
  set language($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasLanguage() => $_has(12);
  @$pb.TagNumber(13)
  void clearLanguage() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get currency => $_getSZ(13);
  @$pb.TagNumber(14)
  set currency($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasCurrency() => $_has(13);
  @$pb.TagNumber(14)
  void clearCurrency() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get timezone => $_getSZ(14);
  @$pb.TagNumber(15)
  set timezone($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasTimezone() => $_has(14);
  @$pb.TagNumber(15)
  void clearTimezone() => $_clearField(15);
}

class ChangePasswordRequest extends $pb.GeneratedMessage {
  factory ChangePasswordRequest({
    $core.String? currentPassword,
    $core.String? newPassword,
    $core.String? newPasswordConfirmation,
  }) {
    final result = ChangePasswordRequest._();
    if (currentPassword != null) result.currentPassword = currentPassword;
    if (newPassword != null) result.newPassword = newPassword;
    if (newPasswordConfirmation != null)
      result.newPasswordConfirmation = newPasswordConfirmation;
    return result;
  }

  ChangePasswordRequest._();

  factory ChangePasswordRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChangePasswordRequest()..mergeFromBuffer(data, registry);
  factory ChangePasswordRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChangePasswordRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChangePasswordRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ChangePasswordRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'currentPassword')
    ..aOS(2, _omitFieldNames ? '' : 'newPassword')
    ..aOS(3, _omitFieldNames ? '' : 'newPasswordConfirmation')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangePasswordRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangePasswordRequest copyWith(
          void Function(ChangePasswordRequest) updates) =>
      super.copyWith((message) => updates(message as ChangePasswordRequest))
          as ChangePasswordRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ChangePasswordRequest() / ChangePasswordRequest.new instead')
  static ChangePasswordRequest create() => ChangePasswordRequest._();
  static $pb.GeneratedMessage $_createMessage() => ChangePasswordRequest._();
  @$core.override
  ChangePasswordRequest createEmptyInstance() => ChangePasswordRequest._();
  @$core.pragma('dart2js:noInline')
  static ChangePasswordRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChangePasswordRequest>(
          ChangePasswordRequest.$_createMessage);
  static ChangePasswordRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get currentPassword => $_getSZ(0);
  @$pb.TagNumber(1)
  set currentPassword($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCurrentPassword() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrentPassword() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get newPassword => $_getSZ(1);
  @$pb.TagNumber(2)
  set newPassword($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNewPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearNewPassword() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get newPasswordConfirmation => $_getSZ(2);
  @$pb.TagNumber(3)
  set newPasswordConfirmation($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNewPasswordConfirmation() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewPasswordConfirmation() => $_clearField(3);
}

class ChangePasswordResponse extends $pb.GeneratedMessage {
  factory ChangePasswordResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = ChangePasswordResponse._();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  ChangePasswordResponse._();

  factory ChangePasswordResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChangePasswordResponse()..mergeFromBuffer(data, registry);
  factory ChangePasswordResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChangePasswordResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChangePasswordResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ChangePasswordResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangePasswordResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangePasswordResponse copyWith(
          void Function(ChangePasswordResponse) updates) =>
      super.copyWith((message) => updates(message as ChangePasswordResponse))
          as ChangePasswordResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ChangePasswordResponse() / ChangePasswordResponse.new instead')
  static ChangePasswordResponse create() => ChangePasswordResponse._();
  static $pb.GeneratedMessage $_createMessage() => ChangePasswordResponse._();
  @$core.override
  ChangePasswordResponse createEmptyInstance() => ChangePasswordResponse._();
  @$core.pragma('dart2js:noInline')
  static ChangePasswordResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChangePasswordResponse>(
          ChangePasswordResponse.$_createMessage);
  static ChangePasswordResponse? _defaultInstance;

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

class UpdateAvatarRequest extends $pb.GeneratedMessage {
  factory UpdateAvatarRequest({
    $core.String? avatar,
    $core.bool? deleteCurrent,
  }) {
    final result = UpdateAvatarRequest._();
    if (avatar != null) result.avatar = avatar;
    if (deleteCurrent != null) result.deleteCurrent = deleteCurrent;
    return result;
  }

  UpdateAvatarRequest._();

  factory UpdateAvatarRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateAvatarRequest()..mergeFromBuffer(data, registry);
  factory UpdateAvatarRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateAvatarRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateAvatarRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: UpdateAvatarRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'avatar')
    ..aOB(2, _omitFieldNames ? '' : 'deleteCurrent')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateAvatarRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateAvatarRequest copyWith(void Function(UpdateAvatarRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateAvatarRequest))
          as UpdateAvatarRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use UpdateAvatarRequest() / UpdateAvatarRequest.new instead')
  static UpdateAvatarRequest create() => UpdateAvatarRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdateAvatarRequest._();
  @$core.override
  UpdateAvatarRequest createEmptyInstance() => UpdateAvatarRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateAvatarRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateAvatarRequest>(
          UpdateAvatarRequest.$_createMessage);
  static UpdateAvatarRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get avatar => $_getSZ(0);
  @$pb.TagNumber(1)
  set avatar($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAvatar() => $_has(0);
  @$pb.TagNumber(1)
  void clearAvatar() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get deleteCurrent => $_getBF(1);
  @$pb.TagNumber(2)
  set deleteCurrent($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDeleteCurrent() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeleteCurrent() => $_clearField(2);
}

class DeleteAvatarRequest extends $pb.GeneratedMessage {
  factory DeleteAvatarRequest() => DeleteAvatarRequest._();

  DeleteAvatarRequest._();

  factory DeleteAvatarRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteAvatarRequest()..mergeFromBuffer(data, registry);
  factory DeleteAvatarRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteAvatarRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteAvatarRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: DeleteAvatarRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteAvatarRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteAvatarRequest copyWith(void Function(DeleteAvatarRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteAvatarRequest))
          as DeleteAvatarRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use DeleteAvatarRequest() / DeleteAvatarRequest.new instead')
  static DeleteAvatarRequest create() => DeleteAvatarRequest._();
  static $pb.GeneratedMessage $_createMessage() => DeleteAvatarRequest._();
  @$core.override
  DeleteAvatarRequest createEmptyInstance() => DeleteAvatarRequest._();
  @$core.pragma('dart2js:noInline')
  static DeleteAvatarRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteAvatarRequest>(
          DeleteAvatarRequest.$_createMessage);
  static DeleteAvatarRequest? _defaultInstance;
}

class DeleteAccountRequest extends $pb.GeneratedMessage {
  factory DeleteAccountRequest({
    $core.String? password,
    $core.String? reason,
  }) {
    final result = DeleteAccountRequest._();
    if (password != null) result.password = password;
    if (reason != null) result.reason = reason;
    return result;
  }

  DeleteAccountRequest._();

  factory DeleteAccountRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteAccountRequest()..mergeFromBuffer(data, registry);
  factory DeleteAccountRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteAccountRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteAccountRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: DeleteAccountRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'password')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteAccountRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteAccountRequest copyWith(void Function(DeleteAccountRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteAccountRequest))
          as DeleteAccountRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DeleteAccountRequest() / DeleteAccountRequest.new instead')
  static DeleteAccountRequest create() => DeleteAccountRequest._();
  static $pb.GeneratedMessage $_createMessage() => DeleteAccountRequest._();
  @$core.override
  DeleteAccountRequest createEmptyInstance() => DeleteAccountRequest._();
  @$core.pragma('dart2js:noInline')
  static DeleteAccountRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteAccountRequest>(
          DeleteAccountRequest.$_createMessage);
  static DeleteAccountRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get password => $_getSZ(0);
  @$pb.TagNumber(1)
  set password($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPassword() => $_has(0);
  @$pb.TagNumber(1)
  void clearPassword() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class DeleteAccountResponse extends $pb.GeneratedMessage {
  factory DeleteAccountResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = DeleteAccountResponse._();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  DeleteAccountResponse._();

  factory DeleteAccountResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteAccountResponse()..mergeFromBuffer(data, registry);
  factory DeleteAccountResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteAccountResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteAccountResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: DeleteAccountResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteAccountResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteAccountResponse copyWith(
          void Function(DeleteAccountResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteAccountResponse))
          as DeleteAccountResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DeleteAccountResponse() / DeleteAccountResponse.new instead')
  static DeleteAccountResponse create() => DeleteAccountResponse._();
  static $pb.GeneratedMessage $_createMessage() => DeleteAccountResponse._();
  @$core.override
  DeleteAccountResponse createEmptyInstance() => DeleteAccountResponse._();
  @$core.pragma('dart2js:noInline')
  static DeleteAccountResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteAccountResponse>(
          DeleteAccountResponse.$_createMessage);
  static DeleteAccountResponse? _defaultInstance;

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

class UpdateNotificationPreferencesRequest extends $pb.GeneratedMessage {
  factory UpdateNotificationPreferencesRequest({
    $core.bool? notificationEmail,
    $core.bool? notificationSms,
    $core.bool? notificationPush,
  }) {
    final result = UpdateNotificationPreferencesRequest._();
    if (notificationEmail != null) result.notificationEmail = notificationEmail;
    if (notificationSms != null) result.notificationSms = notificationSms;
    if (notificationPush != null) result.notificationPush = notificationPush;
    return result;
  }

  UpdateNotificationPreferencesRequest._();

  factory UpdateNotificationPreferencesRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateNotificationPreferencesRequest()..mergeFromBuffer(data, registry);
  factory UpdateNotificationPreferencesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateNotificationPreferencesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateNotificationPreferencesRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: UpdateNotificationPreferencesRequest.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'notificationEmail')
    ..aOB(2, _omitFieldNames ? '' : 'notificationSms')
    ..aOB(3, _omitFieldNames ? '' : 'notificationPush')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateNotificationPreferencesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateNotificationPreferencesRequest copyWith(
          void Function(UpdateNotificationPreferencesRequest) updates) =>
      super.copyWith((message) =>
              updates(message as UpdateNotificationPreferencesRequest))
          as UpdateNotificationPreferencesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateNotificationPreferencesRequest() / UpdateNotificationPreferencesRequest.new instead')
  static UpdateNotificationPreferencesRequest create() =>
      UpdateNotificationPreferencesRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      UpdateNotificationPreferencesRequest._();
  @$core.override
  UpdateNotificationPreferencesRequest createEmptyInstance() =>
      UpdateNotificationPreferencesRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateNotificationPreferencesRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              UpdateNotificationPreferencesRequest>(
          UpdateNotificationPreferencesRequest.$_createMessage);
  static UpdateNotificationPreferencesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get notificationEmail => $_getBF(0);
  @$pb.TagNumber(1)
  set notificationEmail($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNotificationEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotificationEmail() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get notificationSms => $_getBF(1);
  @$pb.TagNumber(2)
  set notificationSms($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNotificationSms() => $_has(1);
  @$pb.TagNumber(2)
  void clearNotificationSms() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get notificationPush => $_getBF(2);
  @$pb.TagNumber(3)
  set notificationPush($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNotificationPush() => $_has(2);
  @$pb.TagNumber(3)
  void clearNotificationPush() => $_clearField(3);
}

class UpdateLocalePreferencesRequest extends $pb.GeneratedMessage {
  factory UpdateLocalePreferencesRequest({
    $core.String? language,
    $core.String? currency,
    $core.String? timezone,
  }) {
    final result = UpdateLocalePreferencesRequest._();
    if (language != null) result.language = language;
    if (currency != null) result.currency = currency;
    if (timezone != null) result.timezone = timezone;
    return result;
  }

  UpdateLocalePreferencesRequest._();

  factory UpdateLocalePreferencesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateLocalePreferencesRequest()..mergeFromBuffer(data, registry);
  factory UpdateLocalePreferencesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateLocalePreferencesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateLocalePreferencesRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: UpdateLocalePreferencesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'language')
    ..aOS(2, _omitFieldNames ? '' : 'currency')
    ..aOS(3, _omitFieldNames ? '' : 'timezone')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateLocalePreferencesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateLocalePreferencesRequest copyWith(
          void Function(UpdateLocalePreferencesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateLocalePreferencesRequest))
          as UpdateLocalePreferencesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateLocalePreferencesRequest() / UpdateLocalePreferencesRequest.new instead')
  static UpdateLocalePreferencesRequest create() =>
      UpdateLocalePreferencesRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      UpdateLocalePreferencesRequest._();
  @$core.override
  UpdateLocalePreferencesRequest createEmptyInstance() =>
      UpdateLocalePreferencesRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateLocalePreferencesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateLocalePreferencesRequest>(
          UpdateLocalePreferencesRequest.$_createMessage);
  static UpdateLocalePreferencesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get language => $_getSZ(0);
  @$pb.TagNumber(1)
  set language($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLanguage() => $_has(0);
  @$pb.TagNumber(1)
  void clearLanguage() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get currency => $_getSZ(1);
  @$pb.TagNumber(2)
  set currency($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCurrency() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrency() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get timezone => $_getSZ(2);
  @$pb.TagNumber(3)
  set timezone($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTimezone() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimezone() => $_clearField(3);
}

/// Address messages
class GetAddressesRequest extends $pb.GeneratedMessage {
  factory GetAddressesRequest({
    $core.String? userId,
  }) {
    final result = GetAddressesRequest._();
    if (userId != null) result.userId = userId;
    return result;
  }

  GetAddressesRequest._();

  factory GetAddressesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetAddressesRequest()..mergeFromBuffer(data, registry);
  factory GetAddressesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetAddressesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAddressesRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetAddressesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAddressesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAddressesRequest copyWith(void Function(GetAddressesRequest) updates) =>
      super.copyWith((message) => updates(message as GetAddressesRequest))
          as GetAddressesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use GetAddressesRequest() / GetAddressesRequest.new instead')
  static GetAddressesRequest create() => GetAddressesRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetAddressesRequest._();
  @$core.override
  GetAddressesRequest createEmptyInstance() => GetAddressesRequest._();
  @$core.pragma('dart2js:noInline')
  static GetAddressesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAddressesRequest>(
          GetAddressesRequest.$_createMessage);
  static GetAddressesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);
}

class UserAddressesResponse extends $pb.GeneratedMessage {
  factory UserAddressesResponse({
    $core.Iterable<UserAddress>? addresses,
  }) {
    final result = UserAddressesResponse._();
    if (addresses != null) result.addresses.addAll(addresses);
    return result;
  }

  UserAddressesResponse._();

  factory UserAddressesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserAddressesResponse()..mergeFromBuffer(data, registry);
  factory UserAddressesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserAddressesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserAddressesResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: UserAddressesResponse.$_createMessage)
    ..pPM<UserAddress>(1, _omitFieldNames ? '' : 'addresses',
        subBuilder: UserAddress.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserAddressesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserAddressesResponse copyWith(
          void Function(UserAddressesResponse) updates) =>
      super.copyWith((message) => updates(message as UserAddressesResponse))
          as UserAddressesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UserAddressesResponse() / UserAddressesResponse.new instead')
  static UserAddressesResponse create() => UserAddressesResponse._();
  static $pb.GeneratedMessage $_createMessage() => UserAddressesResponse._();
  @$core.override
  UserAddressesResponse createEmptyInstance() => UserAddressesResponse._();
  @$core.pragma('dart2js:noInline')
  static UserAddressesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserAddressesResponse>(
          UserAddressesResponse.$_createMessage);
  static UserAddressesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<UserAddress> get addresses => $_getList(0);
}

class CreateAddressRequest extends $pb.GeneratedMessage {
  factory CreateAddressRequest({
    $core.String? name,
    $core.String? phone,
    $core.String? address,
    $core.String? city,
    $core.String? province,
    $core.String? postalCode,
    $3.AddressType? type,
    $core.bool? isDefault,
  }) {
    final result = CreateAddressRequest._();
    if (name != null) result.name = name;
    if (phone != null) result.phone = phone;
    if (address != null) result.address = address;
    if (city != null) result.city = city;
    if (province != null) result.province = province;
    if (postalCode != null) result.postalCode = postalCode;
    if (type != null) result.type = type;
    if (isDefault != null) result.isDefault = isDefault;
    return result;
  }

  CreateAddressRequest._();

  factory CreateAddressRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateAddressRequest()..mergeFromBuffer(data, registry);
  factory CreateAddressRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateAddressRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateAddressRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: CreateAddressRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'phone')
    ..aOS(3, _omitFieldNames ? '' : 'address')
    ..aOS(4, _omitFieldNames ? '' : 'city')
    ..aOS(5, _omitFieldNames ? '' : 'province')
    ..aOS(6, _omitFieldNames ? '' : 'postalCode')
    ..aE<$3.AddressType>(7, _omitFieldNames ? '' : 'type',
        enumValues: $3.AddressType.values)
    ..aOB(8, _omitFieldNames ? '' : 'isDefault')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateAddressRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateAddressRequest copyWith(void Function(CreateAddressRequest) updates) =>
      super.copyWith((message) => updates(message as CreateAddressRequest))
          as CreateAddressRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateAddressRequest() / CreateAddressRequest.new instead')
  static CreateAddressRequest create() => CreateAddressRequest._();
  static $pb.GeneratedMessage $_createMessage() => CreateAddressRequest._();
  @$core.override
  CreateAddressRequest createEmptyInstance() => CreateAddressRequest._();
  @$core.pragma('dart2js:noInline')
  static CreateAddressRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateAddressRequest>(
          CreateAddressRequest.$_createMessage);
  static CreateAddressRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get phone => $_getSZ(1);
  @$pb.TagNumber(2)
  set phone($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPhone() => $_has(1);
  @$pb.TagNumber(2)
  void clearPhone() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get address => $_getSZ(2);
  @$pb.TagNumber(3)
  set address($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAddress() => $_has(2);
  @$pb.TagNumber(3)
  void clearAddress() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get city => $_getSZ(3);
  @$pb.TagNumber(4)
  set city($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCity() => $_has(3);
  @$pb.TagNumber(4)
  void clearCity() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get province => $_getSZ(4);
  @$pb.TagNumber(5)
  set province($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasProvince() => $_has(4);
  @$pb.TagNumber(5)
  void clearProvince() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get postalCode => $_getSZ(5);
  @$pb.TagNumber(6)
  set postalCode($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPostalCode() => $_has(5);
  @$pb.TagNumber(6)
  void clearPostalCode() => $_clearField(6);

  @$pb.TagNumber(7)
  $3.AddressType get type => $_getN(6);
  @$pb.TagNumber(7)
  set type($3.AddressType value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasType() => $_has(6);
  @$pb.TagNumber(7)
  void clearType() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get isDefault => $_getBF(7);
  @$pb.TagNumber(8)
  set isDefault($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIsDefault() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsDefault() => $_clearField(8);
}

class UpdateAddressRequest extends $pb.GeneratedMessage {
  factory UpdateAddressRequest({
    $core.String? id,
    $core.String? name,
    $core.String? phone,
    $core.String? address,
    $core.String? city,
    $core.String? province,
    $core.String? postalCode,
    $3.AddressType? type,
    $core.bool? isDefault,
  }) {
    final result = UpdateAddressRequest._();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (phone != null) result.phone = phone;
    if (address != null) result.address = address;
    if (city != null) result.city = city;
    if (province != null) result.province = province;
    if (postalCode != null) result.postalCode = postalCode;
    if (type != null) result.type = type;
    if (isDefault != null) result.isDefault = isDefault;
    return result;
  }

  UpdateAddressRequest._();

  factory UpdateAddressRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateAddressRequest()..mergeFromBuffer(data, registry);
  factory UpdateAddressRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateAddressRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateAddressRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: UpdateAddressRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'phone')
    ..aOS(4, _omitFieldNames ? '' : 'address')
    ..aOS(5, _omitFieldNames ? '' : 'city')
    ..aOS(6, _omitFieldNames ? '' : 'province')
    ..aOS(7, _omitFieldNames ? '' : 'postalCode')
    ..aE<$3.AddressType>(8, _omitFieldNames ? '' : 'type',
        enumValues: $3.AddressType.values)
    ..aOB(9, _omitFieldNames ? '' : 'isDefault')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateAddressRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateAddressRequest copyWith(void Function(UpdateAddressRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateAddressRequest))
          as UpdateAddressRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateAddressRequest() / UpdateAddressRequest.new instead')
  static UpdateAddressRequest create() => UpdateAddressRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdateAddressRequest._();
  @$core.override
  UpdateAddressRequest createEmptyInstance() => UpdateAddressRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateAddressRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateAddressRequest>(
          UpdateAddressRequest.$_createMessage);
  static UpdateAddressRequest? _defaultInstance;

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
  $core.String get phone => $_getSZ(2);
  @$pb.TagNumber(3)
  set phone($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPhone() => $_has(2);
  @$pb.TagNumber(3)
  void clearPhone() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get address => $_getSZ(3);
  @$pb.TagNumber(4)
  set address($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAddress() => $_has(3);
  @$pb.TagNumber(4)
  void clearAddress() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get city => $_getSZ(4);
  @$pb.TagNumber(5)
  set city($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCity() => $_has(4);
  @$pb.TagNumber(5)
  void clearCity() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get province => $_getSZ(5);
  @$pb.TagNumber(6)
  set province($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasProvince() => $_has(5);
  @$pb.TagNumber(6)
  void clearProvince() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get postalCode => $_getSZ(6);
  @$pb.TagNumber(7)
  set postalCode($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPostalCode() => $_has(6);
  @$pb.TagNumber(7)
  void clearPostalCode() => $_clearField(7);

  @$pb.TagNumber(8)
  $3.AddressType get type => $_getN(7);
  @$pb.TagNumber(8)
  set type($3.AddressType value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasType() => $_has(7);
  @$pb.TagNumber(8)
  void clearType() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get isDefault => $_getBF(8);
  @$pb.TagNumber(9)
  set isDefault($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasIsDefault() => $_has(8);
  @$pb.TagNumber(9)
  void clearIsDefault() => $_clearField(9);
}

class DeleteAddressRequest extends $pb.GeneratedMessage {
  factory DeleteAddressRequest({
    $core.String? id,
  }) {
    final result = DeleteAddressRequest._();
    if (id != null) result.id = id;
    return result;
  }

  DeleteAddressRequest._();

  factory DeleteAddressRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteAddressRequest()..mergeFromBuffer(data, registry);
  factory DeleteAddressRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteAddressRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteAddressRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: DeleteAddressRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteAddressRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteAddressRequest copyWith(void Function(DeleteAddressRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteAddressRequest))
          as DeleteAddressRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DeleteAddressRequest() / DeleteAddressRequest.new instead')
  static DeleteAddressRequest create() => DeleteAddressRequest._();
  static $pb.GeneratedMessage $_createMessage() => DeleteAddressRequest._();
  @$core.override
  DeleteAddressRequest createEmptyInstance() => DeleteAddressRequest._();
  @$core.pragma('dart2js:noInline')
  static DeleteAddressRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteAddressRequest>(
          DeleteAddressRequest.$_createMessage);
  static DeleteAddressRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class DeleteAddressResponse extends $pb.GeneratedMessage {
  factory DeleteAddressResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = DeleteAddressResponse._();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  DeleteAddressResponse._();

  factory DeleteAddressResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteAddressResponse()..mergeFromBuffer(data, registry);
  factory DeleteAddressResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteAddressResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteAddressResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: DeleteAddressResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteAddressResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteAddressResponse copyWith(
          void Function(DeleteAddressResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteAddressResponse))
          as DeleteAddressResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DeleteAddressResponse() / DeleteAddressResponse.new instead')
  static DeleteAddressResponse create() => DeleteAddressResponse._();
  static $pb.GeneratedMessage $_createMessage() => DeleteAddressResponse._();
  @$core.override
  DeleteAddressResponse createEmptyInstance() => DeleteAddressResponse._();
  @$core.pragma('dart2js:noInline')
  static DeleteAddressResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteAddressResponse>(
          DeleteAddressResponse.$_createMessage);
  static DeleteAddressResponse? _defaultInstance;

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

class SetDefaultAddressRequest extends $pb.GeneratedMessage {
  factory SetDefaultAddressRequest({
    $core.String? id,
  }) {
    final result = SetDefaultAddressRequest._();
    if (id != null) result.id = id;
    return result;
  }

  SetDefaultAddressRequest._();

  factory SetDefaultAddressRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetDefaultAddressRequest()..mergeFromBuffer(data, registry);
  factory SetDefaultAddressRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetDefaultAddressRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetDefaultAddressRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: SetDefaultAddressRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetDefaultAddressRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetDefaultAddressRequest copyWith(
          void Function(SetDefaultAddressRequest) updates) =>
      super.copyWith((message) => updates(message as SetDefaultAddressRequest))
          as SetDefaultAddressRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SetDefaultAddressRequest() / SetDefaultAddressRequest.new instead')
  static SetDefaultAddressRequest create() => SetDefaultAddressRequest._();
  static $pb.GeneratedMessage $_createMessage() => SetDefaultAddressRequest._();
  @$core.override
  SetDefaultAddressRequest createEmptyInstance() =>
      SetDefaultAddressRequest._();
  @$core.pragma('dart2js:noInline')
  static SetDefaultAddressRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetDefaultAddressRequest>(
          SetDefaultAddressRequest.$_createMessage);
  static SetDefaultAddressRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class UserAddress extends $pb.GeneratedMessage {
  factory UserAddress({
    $core.String? id,
    $core.String? userId,
    $core.String? name,
    $core.String? phone,
    $core.String? address,
    $core.String? city,
    $core.String? province,
    $core.String? postalCode,
    $3.AddressType? type,
    $core.bool? isDefault,
    $core.String? createdAt,
    $core.String? updatedAt,
  }) {
    final result = UserAddress._();
    if (id != null) result.id = id;
    if (userId != null) result.userId = userId;
    if (name != null) result.name = name;
    if (phone != null) result.phone = phone;
    if (address != null) result.address = address;
    if (city != null) result.city = city;
    if (province != null) result.province = province;
    if (postalCode != null) result.postalCode = postalCode;
    if (type != null) result.type = type;
    if (isDefault != null) result.isDefault = isDefault;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  UserAddress._();

  factory UserAddress.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserAddress()..mergeFromBuffer(data, registry);
  factory UserAddress.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserAddress()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserAddress',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: UserAddress.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'phone')
    ..aOS(5, _omitFieldNames ? '' : 'address')
    ..aOS(6, _omitFieldNames ? '' : 'city')
    ..aOS(7, _omitFieldNames ? '' : 'province')
    ..aOS(8, _omitFieldNames ? '' : 'postalCode')
    ..aE<$3.AddressType>(9, _omitFieldNames ? '' : 'type',
        enumValues: $3.AddressType.values)
    ..aOB(10, _omitFieldNames ? '' : 'isDefault')
    ..aOS(11, _omitFieldNames ? '' : 'createdAt')
    ..aOS(12, _omitFieldNames ? '' : 'updatedAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserAddress clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserAddress copyWith(void Function(UserAddress) updates) =>
      super.copyWith((message) => updates(message as UserAddress))
          as UserAddress;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UserAddress() / UserAddress.new instead')
  static UserAddress create() => UserAddress._();
  static $pb.GeneratedMessage $_createMessage() => UserAddress._();
  @$core.override
  UserAddress createEmptyInstance() => UserAddress._();
  @$core.pragma('dart2js:noInline')
  static UserAddress getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserAddress>(
          UserAddress.$_createMessage);
  static UserAddress? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get phone => $_getSZ(3);
  @$pb.TagNumber(4)
  set phone($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPhone() => $_has(3);
  @$pb.TagNumber(4)
  void clearPhone() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get address => $_getSZ(4);
  @$pb.TagNumber(5)
  set address($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAddress() => $_has(4);
  @$pb.TagNumber(5)
  void clearAddress() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get city => $_getSZ(5);
  @$pb.TagNumber(6)
  set city($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCity() => $_has(5);
  @$pb.TagNumber(6)
  void clearCity() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get province => $_getSZ(6);
  @$pb.TagNumber(7)
  set province($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasProvince() => $_has(6);
  @$pb.TagNumber(7)
  void clearProvince() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get postalCode => $_getSZ(7);
  @$pb.TagNumber(8)
  set postalCode($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPostalCode() => $_has(7);
  @$pb.TagNumber(8)
  void clearPostalCode() => $_clearField(8);

  @$pb.TagNumber(9)
  $3.AddressType get type => $_getN(8);
  @$pb.TagNumber(9)
  set type($3.AddressType value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasType() => $_has(8);
  @$pb.TagNumber(9)
  void clearType() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get isDefault => $_getBF(9);
  @$pb.TagNumber(10)
  set isDefault($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasIsDefault() => $_has(9);
  @$pb.TagNumber(10)
  void clearIsDefault() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get createdAt => $_getSZ(10);
  @$pb.TagNumber(11)
  set createdAt($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCreatedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearCreatedAt() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get updatedAt => $_getSZ(11);
  @$pb.TagNumber(12)
  set updatedAt($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasUpdatedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearUpdatedAt() => $_clearField(12);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
