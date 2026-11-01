// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/notification.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use getNotificationsRequestDescriptor instead')
const GetNotificationsRequest$json = {
  '1': 'GetNotificationsRequest',
  '2': [
    {
      '1': 'pagination',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.PaginationRequest',
      '10': 'pagination'
    },
    {'1': 'unread_only', '3': 2, '4': 1, '5': 8, '10': 'unreadOnly'},
  ],
};

/// Descriptor for `GetNotificationsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getNotificationsRequestDescriptor = $convert.base64Decode(
    'ChdHZXROb3RpZmljYXRpb25zUmVxdWVzdBJCCgpwYWdpbmF0aW9uGAEgASgLMiIud2VkZGluZy'
    '51c2VyLnYxLlBhZ2luYXRpb25SZXF1ZXN0UgpwYWdpbmF0aW9uEh8KC3VucmVhZF9vbmx5GAIg'
    'ASgIUgp1bnJlYWRPbmx5');

@$core.Deprecated('Use notificationListResponseDescriptor instead')
const NotificationListResponse$json = {
  '1': 'NotificationListResponse',
  '2': [
    {
      '1': 'notifications',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.Notification',
      '10': 'notifications'
    },
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.PaginationResponse',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `NotificationListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationListResponseDescriptor = $convert.base64Decode(
    'ChhOb3RpZmljYXRpb25MaXN0UmVzcG9uc2USQwoNbm90aWZpY2F0aW9ucxgBIAMoCzIdLndlZG'
    'RpbmcudXNlci52MS5Ob3RpZmljYXRpb25SDW5vdGlmaWNhdGlvbnMSQwoKcGFnaW5hdGlvbhgC'
    'IAEoCzIjLndlZGRpbmcudXNlci52MS5QYWdpbmF0aW9uUmVzcG9uc2VSCnBhZ2luYXRpb24=');

@$core.Deprecated('Use getUnreadCountRequestDescriptor instead')
const GetUnreadCountRequest$json = {
  '1': 'GetUnreadCountRequest',
};

/// Descriptor for `GetUnreadCountRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUnreadCountRequestDescriptor =
    $convert.base64Decode('ChVHZXRVbnJlYWRDb3VudFJlcXVlc3Q=');

@$core.Deprecated('Use unreadCountResponseDescriptor instead')
const UnreadCountResponse$json = {
  '1': 'UnreadCountResponse',
  '2': [
    {'1': 'count', '3': 1, '4': 1, '5': 5, '10': 'count'},
  ],
};

/// Descriptor for `UnreadCountResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unreadCountResponseDescriptor =
    $convert.base64Decode(
        'ChNVbnJlYWRDb3VudFJlc3BvbnNlEhQKBWNvdW50GAEgASgFUgVjb3VudA==');

@$core.Deprecated('Use markAsReadRequestDescriptor instead')
const MarkAsReadRequest$json = {
  '1': 'MarkAsReadRequest',
  '2': [
    {'1': 'notification_id', '3': 1, '4': 1, '5': 9, '10': 'notificationId'},
  ],
};

/// Descriptor for `MarkAsReadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markAsReadRequestDescriptor = $convert.base64Decode(
    'ChFNYXJrQXNSZWFkUmVxdWVzdBInCg9ub3RpZmljYXRpb25faWQYASABKAlSDm5vdGlmaWNhdG'
    'lvbklk');

@$core.Deprecated('Use markAsReadResponseDescriptor instead')
const MarkAsReadResponse$json = {
  '1': 'MarkAsReadResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `MarkAsReadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markAsReadResponseDescriptor = $convert.base64Decode(
    'ChJNYXJrQXNSZWFkUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIYCgdtZXNzYW'
    'dlGAIgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use markAllAsReadRequestDescriptor instead')
const MarkAllAsReadRequest$json = {
  '1': 'MarkAllAsReadRequest',
};

/// Descriptor for `MarkAllAsReadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markAllAsReadRequestDescriptor =
    $convert.base64Decode('ChRNYXJrQWxsQXNSZWFkUmVxdWVzdA==');

@$core.Deprecated('Use markAllAsReadResponseDescriptor instead')
const MarkAllAsReadResponse$json = {
  '1': 'MarkAllAsReadResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'marked_count', '3': 2, '4': 1, '5': 5, '10': 'markedCount'},
    {'1': 'message', '3': 3, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `MarkAllAsReadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markAllAsReadResponseDescriptor = $convert.base64Decode(
    'ChVNYXJrQWxsQXNSZWFkUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIhCgxtYX'
    'JrZWRfY291bnQYAiABKAVSC21hcmtlZENvdW50EhgKB21lc3NhZ2UYAyABKAlSB21lc3NhZ2U=');

@$core.Deprecated('Use deleteNotificationRequestDescriptor instead')
const DeleteNotificationRequest$json = {
  '1': 'DeleteNotificationRequest',
  '2': [
    {'1': 'notification_id', '3': 1, '4': 1, '5': 9, '10': 'notificationId'},
  ],
};

/// Descriptor for `DeleteNotificationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteNotificationRequestDescriptor =
    $convert.base64Decode(
        'ChlEZWxldGVOb3RpZmljYXRpb25SZXF1ZXN0EicKD25vdGlmaWNhdGlvbl9pZBgBIAEoCVIObm'
        '90aWZpY2F0aW9uSWQ=');

@$core.Deprecated('Use deleteNotificationResponseDescriptor instead')
const DeleteNotificationResponse$json = {
  '1': 'DeleteNotificationResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `DeleteNotificationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteNotificationResponseDescriptor =
    $convert.base64Decode(
        'ChpEZWxldGVOb3RpZmljYXRpb25SZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEh'
        'gKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2U=');

@$core.Deprecated('Use watchNotificationsRequestDescriptor instead')
const WatchNotificationsRequest$json = {
  '1': 'WatchNotificationsRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `WatchNotificationsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchNotificationsRequestDescriptor =
    $convert.base64Decode(
        'ChlXYXRjaE5vdGlmaWNhdGlvbnNSZXF1ZXN0EhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZA==');

@$core.Deprecated('Use notificationDescriptor instead')
const Notification$json = {
  '1': 'Notification',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'type', '3': 3, '4': 1, '5': 9, '10': 'type'},
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    {'1': 'message', '3': 5, '4': 1, '5': 9, '10': 'message'},
    {
      '1': 'data',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.MetaData',
      '10': 'data'
    },
    {'1': 'is_read', '3': 7, '4': 1, '5': 8, '10': 'isRead'},
    {'1': 'read_at', '3': 8, '4': 1, '5': 9, '10': 'readAt'},
    {'1': 'created_at', '3': 9, '4': 1, '5': 9, '10': 'createdAt'},
  ],
};

/// Descriptor for `Notification`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationDescriptor = $convert.base64Decode(
    'CgxOb3RpZmljYXRpb24SDgoCaWQYASABKAlSAmlkEhcKB3VzZXJfaWQYAiABKAlSBnVzZXJJZB'
    'ISCgR0eXBlGAMgASgJUgR0eXBlEhQKBXRpdGxlGAQgASgJUgV0aXRsZRIYCgdtZXNzYWdlGAUg'
    'ASgJUgdtZXNzYWdlEi0KBGRhdGEYBiABKAsyGS53ZWRkaW5nLnVzZXIudjEuTWV0YURhdGFSBG'
    'RhdGESFwoHaXNfcmVhZBgHIAEoCFIGaXNSZWFkEhcKB3JlYWRfYXQYCCABKAlSBnJlYWRBdBId'
    'CgpjcmVhdGVkX2F0GAkgASgJUgljcmVhdGVkQXQ=');
