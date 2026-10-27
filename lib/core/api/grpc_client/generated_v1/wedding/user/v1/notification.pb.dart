// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/notification.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GetNotificationsRequest extends $pb.GeneratedMessage {
  factory GetNotificationsRequest({
    $1.PaginationRequest? pagination,
    $core.bool? unreadOnly,
  }) {
    final result = GetNotificationsRequest._();
    if (pagination != null) result.pagination = pagination;
    if (unreadOnly != null) result.unreadOnly = unreadOnly;
    return result;
  }

  GetNotificationsRequest._();

  factory GetNotificationsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetNotificationsRequest()..mergeFromBuffer(data, registry);
  factory GetNotificationsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetNotificationsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetNotificationsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetNotificationsRequest.$_createMessage)
    ..aOM<$1.PaginationRequest>(1, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginationRequest.$_createMessage)
    ..aOB(2, _omitFieldNames ? '' : 'unreadOnly')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetNotificationsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetNotificationsRequest copyWith(
          void Function(GetNotificationsRequest) updates) =>
      super.copyWith((message) => updates(message as GetNotificationsRequest))
          as GetNotificationsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetNotificationsRequest() / GetNotificationsRequest.new instead')
  static GetNotificationsRequest create() => GetNotificationsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetNotificationsRequest._();
  @$core.override
  GetNotificationsRequest createEmptyInstance() => GetNotificationsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetNotificationsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetNotificationsRequest>(
          GetNotificationsRequest.$_createMessage);
  static GetNotificationsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.PaginationRequest get pagination => $_getN(0);
  @$pb.TagNumber(1)
  set pagination($1.PaginationRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPagination() => $_has(0);
  @$pb.TagNumber(1)
  void clearPagination() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.PaginationRequest ensurePagination() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get unreadOnly => $_getBF(1);
  @$pb.TagNumber(2)
  set unreadOnly($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnreadOnly() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnreadOnly() => $_clearField(2);
}

class NotificationListResponse extends $pb.GeneratedMessage {
  factory NotificationListResponse({
    $core.Iterable<Notification>? notifications,
    $1.PaginationResponse? pagination,
  }) {
    final result = NotificationListResponse._();
    if (notifications != null) result.notifications.addAll(notifications);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  NotificationListResponse._();

  factory NotificationListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NotificationListResponse()..mergeFromBuffer(data, registry);
  factory NotificationListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NotificationListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotificationListResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: NotificationListResponse.$_createMessage)
    ..pPM<Notification>(1, _omitFieldNames ? '' : 'notifications',
        subBuilder: Notification.$_createMessage)
    ..aOM<$1.PaginationResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginationResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationListResponse copyWith(
          void Function(NotificationListResponse) updates) =>
      super.copyWith((message) => updates(message as NotificationListResponse))
          as NotificationListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use NotificationListResponse() / NotificationListResponse.new instead')
  static NotificationListResponse create() => NotificationListResponse._();
  static $pb.GeneratedMessage $_createMessage() => NotificationListResponse._();
  @$core.override
  NotificationListResponse createEmptyInstance() =>
      NotificationListResponse._();
  @$core.pragma('dart2js:noInline')
  static NotificationListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationListResponse>(
          NotificationListResponse.$_createMessage);
  static NotificationListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Notification> get notifications => $_getList(0);

  @$pb.TagNumber(2)
  $1.PaginationResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.PaginationResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.PaginationResponse ensurePagination() => $_ensure(1);
}

class GetUnreadCountRequest extends $pb.GeneratedMessage {
  factory GetUnreadCountRequest() => GetUnreadCountRequest._();

  GetUnreadCountRequest._();

  factory GetUnreadCountRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetUnreadCountRequest()..mergeFromBuffer(data, registry);
  factory GetUnreadCountRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetUnreadCountRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUnreadCountRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetUnreadCountRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUnreadCountRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUnreadCountRequest copyWith(
          void Function(GetUnreadCountRequest) updates) =>
      super.copyWith((message) => updates(message as GetUnreadCountRequest))
          as GetUnreadCountRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetUnreadCountRequest() / GetUnreadCountRequest.new instead')
  static GetUnreadCountRequest create() => GetUnreadCountRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetUnreadCountRequest._();
  @$core.override
  GetUnreadCountRequest createEmptyInstance() => GetUnreadCountRequest._();
  @$core.pragma('dart2js:noInline')
  static GetUnreadCountRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUnreadCountRequest>(
          GetUnreadCountRequest.$_createMessage);
  static GetUnreadCountRequest? _defaultInstance;
}

class UnreadCountResponse extends $pb.GeneratedMessage {
  factory UnreadCountResponse({
    $core.int? count,
  }) {
    final result = UnreadCountResponse._();
    if (count != null) result.count = count;
    return result;
  }

  UnreadCountResponse._();

  factory UnreadCountResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UnreadCountResponse()..mergeFromBuffer(data, registry);
  factory UnreadCountResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UnreadCountResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnreadCountResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: UnreadCountResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'count')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnreadCountResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnreadCountResponse copyWith(void Function(UnreadCountResponse) updates) =>
      super.copyWith((message) => updates(message as UnreadCountResponse))
          as UnreadCountResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use UnreadCountResponse() / UnreadCountResponse.new instead')
  static UnreadCountResponse create() => UnreadCountResponse._();
  static $pb.GeneratedMessage $_createMessage() => UnreadCountResponse._();
  @$core.override
  UnreadCountResponse createEmptyInstance() => UnreadCountResponse._();
  @$core.pragma('dart2js:noInline')
  static UnreadCountResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UnreadCountResponse>(
          UnreadCountResponse.$_createMessage);
  static UnreadCountResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get count => $_getIZ(0);
  @$pb.TagNumber(1)
  set count($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearCount() => $_clearField(1);
}

class MarkAsReadRequest extends $pb.GeneratedMessage {
  factory MarkAsReadRequest({
    $core.String? notificationId,
  }) {
    final result = MarkAsReadRequest._();
    if (notificationId != null) result.notificationId = notificationId;
    return result;
  }

  MarkAsReadRequest._();

  factory MarkAsReadRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkAsReadRequest()..mergeFromBuffer(data, registry);
  factory MarkAsReadRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkAsReadRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkAsReadRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: MarkAsReadRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'notificationId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkAsReadRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkAsReadRequest copyWith(void Function(MarkAsReadRequest) updates) =>
      super.copyWith((message) => updates(message as MarkAsReadRequest))
          as MarkAsReadRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use MarkAsReadRequest() / MarkAsReadRequest.new instead')
  static MarkAsReadRequest create() => MarkAsReadRequest._();
  static $pb.GeneratedMessage $_createMessage() => MarkAsReadRequest._();
  @$core.override
  MarkAsReadRequest createEmptyInstance() => MarkAsReadRequest._();
  @$core.pragma('dart2js:noInline')
  static MarkAsReadRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MarkAsReadRequest>(
          MarkAsReadRequest.$_createMessage);
  static MarkAsReadRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get notificationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set notificationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNotificationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotificationId() => $_clearField(1);
}

class MarkAsReadResponse extends $pb.GeneratedMessage {
  factory MarkAsReadResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = MarkAsReadResponse._();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  MarkAsReadResponse._();

  factory MarkAsReadResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkAsReadResponse()..mergeFromBuffer(data, registry);
  factory MarkAsReadResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkAsReadResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkAsReadResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: MarkAsReadResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkAsReadResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkAsReadResponse copyWith(void Function(MarkAsReadResponse) updates) =>
      super.copyWith((message) => updates(message as MarkAsReadResponse))
          as MarkAsReadResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use MarkAsReadResponse() / MarkAsReadResponse.new instead')
  static MarkAsReadResponse create() => MarkAsReadResponse._();
  static $pb.GeneratedMessage $_createMessage() => MarkAsReadResponse._();
  @$core.override
  MarkAsReadResponse createEmptyInstance() => MarkAsReadResponse._();
  @$core.pragma('dart2js:noInline')
  static MarkAsReadResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MarkAsReadResponse>(
          MarkAsReadResponse.$_createMessage);
  static MarkAsReadResponse? _defaultInstance;

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

class MarkAllAsReadRequest extends $pb.GeneratedMessage {
  factory MarkAllAsReadRequest() => MarkAllAsReadRequest._();

  MarkAllAsReadRequest._();

  factory MarkAllAsReadRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkAllAsReadRequest()..mergeFromBuffer(data, registry);
  factory MarkAllAsReadRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkAllAsReadRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkAllAsReadRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: MarkAllAsReadRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkAllAsReadRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkAllAsReadRequest copyWith(void Function(MarkAllAsReadRequest) updates) =>
      super.copyWith((message) => updates(message as MarkAllAsReadRequest))
          as MarkAllAsReadRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MarkAllAsReadRequest() / MarkAllAsReadRequest.new instead')
  static MarkAllAsReadRequest create() => MarkAllAsReadRequest._();
  static $pb.GeneratedMessage $_createMessage() => MarkAllAsReadRequest._();
  @$core.override
  MarkAllAsReadRequest createEmptyInstance() => MarkAllAsReadRequest._();
  @$core.pragma('dart2js:noInline')
  static MarkAllAsReadRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MarkAllAsReadRequest>(
          MarkAllAsReadRequest.$_createMessage);
  static MarkAllAsReadRequest? _defaultInstance;
}

class MarkAllAsReadResponse extends $pb.GeneratedMessage {
  factory MarkAllAsReadResponse({
    $core.bool? success,
    $core.int? markedCount,
    $core.String? message,
  }) {
    final result = MarkAllAsReadResponse._();
    if (success != null) result.success = success;
    if (markedCount != null) result.markedCount = markedCount;
    if (message != null) result.message = message;
    return result;
  }

  MarkAllAsReadResponse._();

  factory MarkAllAsReadResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkAllAsReadResponse()..mergeFromBuffer(data, registry);
  factory MarkAllAsReadResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkAllAsReadResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkAllAsReadResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: MarkAllAsReadResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aI(2, _omitFieldNames ? '' : 'markedCount')
    ..aOS(3, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkAllAsReadResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkAllAsReadResponse copyWith(
          void Function(MarkAllAsReadResponse) updates) =>
      super.copyWith((message) => updates(message as MarkAllAsReadResponse))
          as MarkAllAsReadResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MarkAllAsReadResponse() / MarkAllAsReadResponse.new instead')
  static MarkAllAsReadResponse create() => MarkAllAsReadResponse._();
  static $pb.GeneratedMessage $_createMessage() => MarkAllAsReadResponse._();
  @$core.override
  MarkAllAsReadResponse createEmptyInstance() => MarkAllAsReadResponse._();
  @$core.pragma('dart2js:noInline')
  static MarkAllAsReadResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MarkAllAsReadResponse>(
          MarkAllAsReadResponse.$_createMessage);
  static MarkAllAsReadResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get markedCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set markedCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMarkedCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearMarkedCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get message => $_getSZ(2);
  @$pb.TagNumber(3)
  set message($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessage() => $_clearField(3);
}

class DeleteNotificationRequest extends $pb.GeneratedMessage {
  factory DeleteNotificationRequest({
    $core.String? notificationId,
  }) {
    final result = DeleteNotificationRequest._();
    if (notificationId != null) result.notificationId = notificationId;
    return result;
  }

  DeleteNotificationRequest._();

  factory DeleteNotificationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteNotificationRequest()..mergeFromBuffer(data, registry);
  factory DeleteNotificationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteNotificationRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteNotificationRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: DeleteNotificationRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'notificationId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteNotificationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteNotificationRequest copyWith(
          void Function(DeleteNotificationRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteNotificationRequest))
          as DeleteNotificationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DeleteNotificationRequest() / DeleteNotificationRequest.new instead')
  static DeleteNotificationRequest create() => DeleteNotificationRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      DeleteNotificationRequest._();
  @$core.override
  DeleteNotificationRequest createEmptyInstance() =>
      DeleteNotificationRequest._();
  @$core.pragma('dart2js:noInline')
  static DeleteNotificationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteNotificationRequest>(
          DeleteNotificationRequest.$_createMessage);
  static DeleteNotificationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get notificationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set notificationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNotificationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotificationId() => $_clearField(1);
}

class DeleteNotificationResponse extends $pb.GeneratedMessage {
  factory DeleteNotificationResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = DeleteNotificationResponse._();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  DeleteNotificationResponse._();

  factory DeleteNotificationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteNotificationResponse()..mergeFromBuffer(data, registry);
  factory DeleteNotificationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteNotificationResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteNotificationResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: DeleteNotificationResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteNotificationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteNotificationResponse copyWith(
          void Function(DeleteNotificationResponse) updates) =>
      super.copyWith(
              (message) => updates(message as DeleteNotificationResponse))
          as DeleteNotificationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DeleteNotificationResponse() / DeleteNotificationResponse.new instead')
  static DeleteNotificationResponse create() => DeleteNotificationResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      DeleteNotificationResponse._();
  @$core.override
  DeleteNotificationResponse createEmptyInstance() =>
      DeleteNotificationResponse._();
  @$core.pragma('dart2js:noInline')
  static DeleteNotificationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteNotificationResponse>(
          DeleteNotificationResponse.$_createMessage);
  static DeleteNotificationResponse? _defaultInstance;

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

class WatchNotificationsRequest extends $pb.GeneratedMessage {
  factory WatchNotificationsRequest({
    $core.String? userId,
  }) {
    final result = WatchNotificationsRequest._();
    if (userId != null) result.userId = userId;
    return result;
  }

  WatchNotificationsRequest._();

  factory WatchNotificationsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchNotificationsRequest()..mergeFromBuffer(data, registry);
  factory WatchNotificationsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchNotificationsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchNotificationsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: WatchNotificationsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchNotificationsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchNotificationsRequest copyWith(
          void Function(WatchNotificationsRequest) updates) =>
      super.copyWith((message) => updates(message as WatchNotificationsRequest))
          as WatchNotificationsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WatchNotificationsRequest() / WatchNotificationsRequest.new instead')
  static WatchNotificationsRequest create() => WatchNotificationsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      WatchNotificationsRequest._();
  @$core.override
  WatchNotificationsRequest createEmptyInstance() =>
      WatchNotificationsRequest._();
  @$core.pragma('dart2js:noInline')
  static WatchNotificationsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchNotificationsRequest>(
          WatchNotificationsRequest.$_createMessage);
  static WatchNotificationsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);
}

class Notification extends $pb.GeneratedMessage {
  factory Notification({
    $core.String? id,
    $core.String? userId,
    $core.String? type,
    $core.String? title,
    $core.String? message,
    $1.MetaData? data,
    $core.bool? isRead,
    $core.String? readAt,
    $core.String? createdAt,
  }) {
    final result = Notification._();
    if (id != null) result.id = id;
    if (userId != null) result.userId = userId;
    if (type != null) result.type = type;
    if (title != null) result.title = title;
    if (message != null) result.message = message;
    if (data != null) result.data = data;
    if (isRead != null) result.isRead = isRead;
    if (readAt != null) result.readAt = readAt;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  Notification._();

  factory Notification.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Notification()..mergeFromBuffer(data, registry);
  factory Notification.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Notification()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Notification',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: Notification.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..aOS(3, _omitFieldNames ? '' : 'type')
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aOS(5, _omitFieldNames ? '' : 'message')
    ..aOM<$1.MetaData>(6, _omitFieldNames ? '' : 'data',
        subBuilder: $1.MetaData.$_createMessage)
    ..aOB(7, _omitFieldNames ? '' : 'isRead')
    ..aOS(8, _omitFieldNames ? '' : 'readAt')
    ..aOS(9, _omitFieldNames ? '' : 'createdAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notification clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notification copyWith(void Function(Notification) updates) =>
      super.copyWith((message) => updates(message as Notification))
          as Notification;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Notification() / Notification.new instead')
  static Notification create() => Notification._();
  static $pb.GeneratedMessage $_createMessage() => Notification._();
  @$core.override
  Notification createEmptyInstance() => Notification._();
  @$core.pragma('dart2js:noInline')
  static Notification getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Notification>(
          Notification.$_createMessage);
  static Notification? _defaultInstance;

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
  $core.String get type => $_getSZ(2);
  @$pb.TagNumber(3)
  set type($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get message => $_getSZ(4);
  @$pb.TagNumber(5)
  set message($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMessage() => $_has(4);
  @$pb.TagNumber(5)
  void clearMessage() => $_clearField(5);

  @$pb.TagNumber(6)
  $1.MetaData get data => $_getN(5);
  @$pb.TagNumber(6)
  set data($1.MetaData value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasData() => $_has(5);
  @$pb.TagNumber(6)
  void clearData() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.MetaData ensureData() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.bool get isRead => $_getBF(6);
  @$pb.TagNumber(7)
  set isRead($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIsRead() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsRead() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get readAt => $_getSZ(7);
  @$pb.TagNumber(8)
  set readAt($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasReadAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearReadAt() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get createdAt => $_getSZ(8);
  @$pb.TagNumber(9)
  set createdAt($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCreatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreatedAt() => $_clearField(9);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
