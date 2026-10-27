// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/notification.proto.

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

import 'notification.pb.dart' as $0;

export 'notification.pb.dart';

/// Notification Service
@$pb.GrpcServiceName('wedding.user.v1.NotificationService')
class NotificationServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  NotificationServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.NotificationListResponse> getNotifications(
    $0.GetNotificationsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getNotifications, request, options: options);
  }

  $grpc.ResponseFuture<$0.UnreadCountResponse> getUnreadCount(
    $0.GetUnreadCountRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getUnreadCount, request, options: options);
  }

  $grpc.ResponseFuture<$0.MarkAsReadResponse> markAsRead(
    $0.MarkAsReadRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$markAsRead, request, options: options);
  }

  $grpc.ResponseFuture<$0.MarkAllAsReadResponse> markAllAsRead(
    $0.MarkAllAsReadRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$markAllAsRead, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeleteNotificationResponse> deleteNotification(
    $0.DeleteNotificationRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteNotification, request, options: options);
  }

  /// Streaming for real-time notifications
  $grpc.ResponseStream<$0.Notification> watchNotifications(
    $0.WatchNotificationsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$watchNotifications, $async.Stream.fromIterable([request]),
        options: options);
  }

  // method descriptors

  static final _$getNotifications = $grpc.ClientMethod<
          $0.GetNotificationsRequest, $0.NotificationListResponse>(
      '/wedding.user.v1.NotificationService/GetNotifications',
      ($0.GetNotificationsRequest value) => value.writeToBuffer(),
      $0.NotificationListResponse.fromBuffer);
  static final _$getUnreadCount =
      $grpc.ClientMethod<$0.GetUnreadCountRequest, $0.UnreadCountResponse>(
          '/wedding.user.v1.NotificationService/GetUnreadCount',
          ($0.GetUnreadCountRequest value) => value.writeToBuffer(),
          $0.UnreadCountResponse.fromBuffer);
  static final _$markAsRead =
      $grpc.ClientMethod<$0.MarkAsReadRequest, $0.MarkAsReadResponse>(
          '/wedding.user.v1.NotificationService/MarkAsRead',
          ($0.MarkAsReadRequest value) => value.writeToBuffer(),
          $0.MarkAsReadResponse.fromBuffer);
  static final _$markAllAsRead =
      $grpc.ClientMethod<$0.MarkAllAsReadRequest, $0.MarkAllAsReadResponse>(
          '/wedding.user.v1.NotificationService/MarkAllAsRead',
          ($0.MarkAllAsReadRequest value) => value.writeToBuffer(),
          $0.MarkAllAsReadResponse.fromBuffer);
  static final _$deleteNotification = $grpc.ClientMethod<
          $0.DeleteNotificationRequest, $0.DeleteNotificationResponse>(
      '/wedding.user.v1.NotificationService/DeleteNotification',
      ($0.DeleteNotificationRequest value) => value.writeToBuffer(),
      $0.DeleteNotificationResponse.fromBuffer);
  static final _$watchNotifications =
      $grpc.ClientMethod<$0.WatchNotificationsRequest, $0.Notification>(
          '/wedding.user.v1.NotificationService/WatchNotifications',
          ($0.WatchNotificationsRequest value) => value.writeToBuffer(),
          $0.Notification.fromBuffer);
}

@$pb.GrpcServiceName('wedding.user.v1.NotificationService')
abstract class NotificationServiceBase extends $grpc.Service {
  $core.String get $name => 'wedding.user.v1.NotificationService';

  NotificationServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetNotificationsRequest,
            $0.NotificationListResponse>(
        'GetNotifications',
        getNotifications_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetNotificationsRequest.fromBuffer(value),
        ($0.NotificationListResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetUnreadCountRequest, $0.UnreadCountResponse>(
            'GetUnreadCount',
            getUnreadCount_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetUnreadCountRequest.fromBuffer(value),
            ($0.UnreadCountResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.MarkAsReadRequest, $0.MarkAsReadResponse>(
        'MarkAsRead',
        markAsRead_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.MarkAsReadRequest.fromBuffer(value),
        ($0.MarkAsReadResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.MarkAllAsReadRequest, $0.MarkAllAsReadResponse>(
            'MarkAllAsRead',
            markAllAsRead_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.MarkAllAsReadRequest.fromBuffer(value),
            ($0.MarkAllAsReadResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteNotificationRequest,
            $0.DeleteNotificationResponse>(
        'DeleteNotification',
        deleteNotification_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DeleteNotificationRequest.fromBuffer(value),
        ($0.DeleteNotificationResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.WatchNotificationsRequest, $0.Notification>(
            'WatchNotifications',
            watchNotifications_Pre,
            false,
            true,
            ($core.List<$core.int> value) =>
                $0.WatchNotificationsRequest.fromBuffer(value),
            ($0.Notification value) => value.writeToBuffer()));
  }

  $async.Future<$0.NotificationListResponse> getNotifications_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetNotificationsRequest> $request) async {
    return getNotifications($call, await $request);
  }

  $async.Future<$0.NotificationListResponse> getNotifications(
      $grpc.ServiceCall call, $0.GetNotificationsRequest request);

  $async.Future<$0.UnreadCountResponse> getUnreadCount_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetUnreadCountRequest> $request) async {
    return getUnreadCount($call, await $request);
  }

  $async.Future<$0.UnreadCountResponse> getUnreadCount(
      $grpc.ServiceCall call, $0.GetUnreadCountRequest request);

  $async.Future<$0.MarkAsReadResponse> markAsRead_Pre($grpc.ServiceCall $call,
      $async.Future<$0.MarkAsReadRequest> $request) async {
    return markAsRead($call, await $request);
  }

  $async.Future<$0.MarkAsReadResponse> markAsRead(
      $grpc.ServiceCall call, $0.MarkAsReadRequest request);

  $async.Future<$0.MarkAllAsReadResponse> markAllAsRead_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.MarkAllAsReadRequest> $request) async {
    return markAllAsRead($call, await $request);
  }

  $async.Future<$0.MarkAllAsReadResponse> markAllAsRead(
      $grpc.ServiceCall call, $0.MarkAllAsReadRequest request);

  $async.Future<$0.DeleteNotificationResponse> deleteNotification_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DeleteNotificationRequest> $request) async {
    return deleteNotification($call, await $request);
  }

  $async.Future<$0.DeleteNotificationResponse> deleteNotification(
      $grpc.ServiceCall call, $0.DeleteNotificationRequest request);

  $async.Stream<$0.Notification> watchNotifications_Pre($grpc.ServiceCall $call,
      $async.Future<$0.WatchNotificationsRequest> $request) async* {
    yield* watchNotifications($call, await $request);
  }

  $async.Stream<$0.Notification> watchNotifications(
      $grpc.ServiceCall call, $0.WatchNotificationsRequest request);
}
