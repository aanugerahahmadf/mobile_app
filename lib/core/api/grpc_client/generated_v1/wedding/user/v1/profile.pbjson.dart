// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/profile.proto.

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

@$core.Deprecated('Use getProfileRequestDescriptor instead')
const GetProfileRequest$json = {
  '1': 'GetProfileRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `GetProfileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getProfileRequestDescriptor = $convert.base64Decode(
    'ChFHZXRQcm9maWxlUmVxdWVzdBIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQ=');

@$core.Deprecated('Use userProfileDescriptor instead')
const UserProfile$json = {
  '1': 'UserProfile',
  '2': [
    {
      '1': 'user',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.User',
      '10': 'user'
    },
    {'1': 'order_count', '3': 2, '4': 1, '5': 5, '10': 'orderCount'},
    {'1': 'review_count', '3': 3, '4': 1, '5': 5, '10': 'reviewCount'},
    {'1': 'wishlist_count', '3': 4, '4': 1, '5': 5, '10': 'wishlistCount'},
    {'1': 'total_spent', '3': 5, '4': 1, '5': 1, '10': 'totalSpent'},
    {
      '1': 'favorite_category',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.Category',
      '10': 'favoriteCategory'
    },
    {'1': 'joined_at', '3': 7, '4': 1, '5': 9, '10': 'joinedAt'},
  ],
};

/// Descriptor for `UserProfile`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userProfileDescriptor = $convert.base64Decode(
    'CgtVc2VyUHJvZmlsZRIpCgR1c2VyGAEgASgLMhUud2VkZGluZy51c2VyLnYxLlVzZXJSBHVzZX'
    'ISHwoLb3JkZXJfY291bnQYAiABKAVSCm9yZGVyQ291bnQSIQoMcmV2aWV3X2NvdW50GAMgASgF'
    'UgtyZXZpZXdDb3VudBIlCg53aXNobGlzdF9jb3VudBgEIAEoBVINd2lzaGxpc3RDb3VudBIfCg'
    't0b3RhbF9zcGVudBgFIAEoAVIKdG90YWxTcGVudBJGChFmYXZvcml0ZV9jYXRlZ29yeRgGIAEo'
    'CzIZLndlZGRpbmcudXNlci52MS5DYXRlZ29yeVIQZmF2b3JpdGVDYXRlZ29yeRIbCglqb2luZW'
    'RfYXQYByABKAlSCGpvaW5lZEF0');

@$core.Deprecated('Use updateProfileRequestDescriptor instead')
const UpdateProfileRequest$json = {
  '1': 'UpdateProfileRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'phone', '3': 2, '4': 1, '5': 9, '10': 'phone'},
    {'1': 'address', '3': 3, '4': 1, '5': 9, '10': 'address'},
    {'1': 'city', '3': 4, '4': 1, '5': 9, '10': 'city'},
    {'1': 'province', '3': 5, '4': 1, '5': 9, '10': 'province'},
    {'1': 'postal_code', '3': 6, '4': 1, '5': 9, '10': 'postalCode'},
    {'1': 'date_of_birth', '3': 7, '4': 1, '5': 9, '10': 'dateOfBirth'},
    {
      '1': 'gender',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.wedding.user.v1.Gender',
      '10': 'gender'
    },
    {'1': 'avatar', '3': 9, '4': 1, '5': 9, '10': 'avatar'},
    {
      '1': 'notification_email',
      '3': 10,
      '4': 1,
      '5': 8,
      '10': 'notificationEmail'
    },
    {'1': 'notification_sms', '3': 11, '4': 1, '5': 8, '10': 'notificationSms'},
    {
      '1': 'notification_push',
      '3': 12,
      '4': 1,
      '5': 8,
      '10': 'notificationPush'
    },
    {'1': 'language', '3': 13, '4': 1, '5': 9, '10': 'language'},
    {'1': 'currency', '3': 14, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'timezone', '3': 15, '4': 1, '5': 9, '10': 'timezone'},
  ],
};

/// Descriptor for `UpdateProfileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateProfileRequestDescriptor = $convert.base64Decode(
    'ChRVcGRhdGVQcm9maWxlUmVxdWVzdBISCgRuYW1lGAEgASgJUgRuYW1lEhQKBXBob25lGAIgAS'
    'gJUgVwaG9uZRIYCgdhZGRyZXNzGAMgASgJUgdhZGRyZXNzEhIKBGNpdHkYBCABKAlSBGNpdHkS'
    'GgoIcHJvdmluY2UYBSABKAlSCHByb3ZpbmNlEh8KC3Bvc3RhbF9jb2RlGAYgASgJUgpwb3N0YW'
    'xDb2RlEiIKDWRhdGVfb2ZfYmlydGgYByABKAlSC2RhdGVPZkJpcnRoEi8KBmdlbmRlchgIIAEo'
    'DjIXLndlZGRpbmcudXNlci52MS5HZW5kZXJSBmdlbmRlchIWCgZhdmF0YXIYCSABKAlSBmF2YX'
    'RhchItChJub3RpZmljYXRpb25fZW1haWwYCiABKAhSEW5vdGlmaWNhdGlvbkVtYWlsEikKEG5v'
    'dGlmaWNhdGlvbl9zbXMYCyABKAhSD25vdGlmaWNhdGlvblNtcxIrChFub3RpZmljYXRpb25fcH'
    'VzaBgMIAEoCFIQbm90aWZpY2F0aW9uUHVzaBIaCghsYW5ndWFnZRgNIAEoCVIIbGFuZ3VhZ2US'
    'GgoIY3VycmVuY3kYDiABKAlSCGN1cnJlbmN5EhoKCHRpbWV6b25lGA8gASgJUgh0aW1lem9uZQ'
    '==');

@$core.Deprecated('Use changePasswordRequestDescriptor instead')
const ChangePasswordRequest$json = {
  '1': 'ChangePasswordRequest',
  '2': [
    {'1': 'current_password', '3': 1, '4': 1, '5': 9, '10': 'currentPassword'},
    {'1': 'new_password', '3': 2, '4': 1, '5': 9, '10': 'newPassword'},
    {
      '1': 'new_password_confirmation',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'newPasswordConfirmation'
    },
  ],
};

/// Descriptor for `ChangePasswordRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changePasswordRequestDescriptor = $convert.base64Decode(
    'ChVDaGFuZ2VQYXNzd29yZFJlcXVlc3QSKQoQY3VycmVudF9wYXNzd29yZBgBIAEoCVIPY3Vycm'
    'VudFBhc3N3b3JkEiEKDG5ld19wYXNzd29yZBgCIAEoCVILbmV3UGFzc3dvcmQSOgoZbmV3X3Bh'
    'c3N3b3JkX2NvbmZpcm1hdGlvbhgDIAEoCVIXbmV3UGFzc3dvcmRDb25maXJtYXRpb24=');

@$core.Deprecated('Use changePasswordResponseDescriptor instead')
const ChangePasswordResponse$json = {
  '1': 'ChangePasswordResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `ChangePasswordResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changePasswordResponseDescriptor =
    $convert.base64Decode(
        'ChZDaGFuZ2VQYXNzd29yZFJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSGAoHbW'
        'Vzc2FnZRgCIAEoCVIHbWVzc2FnZQ==');

@$core.Deprecated('Use updateAvatarRequestDescriptor instead')
const UpdateAvatarRequest$json = {
  '1': 'UpdateAvatarRequest',
  '2': [
    {'1': 'avatar', '3': 1, '4': 1, '5': 9, '10': 'avatar'},
    {'1': 'delete_current', '3': 2, '4': 1, '5': 8, '10': 'deleteCurrent'},
  ],
};

/// Descriptor for `UpdateAvatarRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateAvatarRequestDescriptor = $convert.base64Decode(
    'ChNVcGRhdGVBdmF0YXJSZXF1ZXN0EhYKBmF2YXRhchgBIAEoCVIGYXZhdGFyEiUKDmRlbGV0ZV'
    '9jdXJyZW50GAIgASgIUg1kZWxldGVDdXJyZW50');

@$core.Deprecated('Use deleteAvatarRequestDescriptor instead')
const DeleteAvatarRequest$json = {
  '1': 'DeleteAvatarRequest',
};

/// Descriptor for `DeleteAvatarRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteAvatarRequestDescriptor =
    $convert.base64Decode('ChNEZWxldGVBdmF0YXJSZXF1ZXN0');

@$core.Deprecated('Use deleteAccountRequestDescriptor instead')
const DeleteAccountRequest$json = {
  '1': 'DeleteAccountRequest',
  '2': [
    {'1': 'password', '3': 1, '4': 1, '5': 9, '10': 'password'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `DeleteAccountRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteAccountRequestDescriptor = $convert.base64Decode(
    'ChREZWxldGVBY2NvdW50UmVxdWVzdBIaCghwYXNzd29yZBgBIAEoCVIIcGFzc3dvcmQSFgoGcm'
    'Vhc29uGAIgASgJUgZyZWFzb24=');

@$core.Deprecated('Use deleteAccountResponseDescriptor instead')
const DeleteAccountResponse$json = {
  '1': 'DeleteAccountResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `DeleteAccountResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteAccountResponseDescriptor = $convert.base64Decode(
    'ChVEZWxldGVBY2NvdW50UmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIYCgdtZX'
    'NzYWdlGAIgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use updateNotificationPreferencesRequestDescriptor instead')
const UpdateNotificationPreferencesRequest$json = {
  '1': 'UpdateNotificationPreferencesRequest',
  '2': [
    {
      '1': 'notification_email',
      '3': 1,
      '4': 1,
      '5': 8,
      '10': 'notificationEmail'
    },
    {'1': 'notification_sms', '3': 2, '4': 1, '5': 8, '10': 'notificationSms'},
    {
      '1': 'notification_push',
      '3': 3,
      '4': 1,
      '5': 8,
      '10': 'notificationPush'
    },
  ],
};

/// Descriptor for `UpdateNotificationPreferencesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateNotificationPreferencesRequestDescriptor =
    $convert.base64Decode(
        'CiRVcGRhdGVOb3RpZmljYXRpb25QcmVmZXJlbmNlc1JlcXVlc3QSLQoSbm90aWZpY2F0aW9uX2'
        'VtYWlsGAEgASgIUhFub3RpZmljYXRpb25FbWFpbBIpChBub3RpZmljYXRpb25fc21zGAIgASgI'
        'Ug9ub3RpZmljYXRpb25TbXMSKwoRbm90aWZpY2F0aW9uX3B1c2gYAyABKAhSEG5vdGlmaWNhdG'
        'lvblB1c2g=');

@$core.Deprecated('Use updateLocalePreferencesRequestDescriptor instead')
const UpdateLocalePreferencesRequest$json = {
  '1': 'UpdateLocalePreferencesRequest',
  '2': [
    {'1': 'language', '3': 1, '4': 1, '5': 9, '10': 'language'},
    {'1': 'currency', '3': 2, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'timezone', '3': 3, '4': 1, '5': 9, '10': 'timezone'},
  ],
};

/// Descriptor for `UpdateLocalePreferencesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateLocalePreferencesRequestDescriptor =
    $convert.base64Decode(
        'Ch5VcGRhdGVMb2NhbGVQcmVmZXJlbmNlc1JlcXVlc3QSGgoIbGFuZ3VhZ2UYASABKAlSCGxhbm'
        'd1YWdlEhoKCGN1cnJlbmN5GAIgASgJUghjdXJyZW5jeRIaCgh0aW1lem9uZRgDIAEoCVIIdGlt'
        'ZXpvbmU=');

@$core.Deprecated('Use getAddressesRequestDescriptor instead')
const GetAddressesRequest$json = {
  '1': 'GetAddressesRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `GetAddressesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAddressesRequestDescriptor =
    $convert.base64Decode(
        'ChNHZXRBZGRyZXNzZXNSZXF1ZXN0EhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZA==');

@$core.Deprecated('Use userAddressesResponseDescriptor instead')
const UserAddressesResponse$json = {
  '1': 'UserAddressesResponse',
  '2': [
    {
      '1': 'addresses',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.UserAddress',
      '10': 'addresses'
    },
  ],
};

/// Descriptor for `UserAddressesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userAddressesResponseDescriptor = $convert.base64Decode(
    'ChVVc2VyQWRkcmVzc2VzUmVzcG9uc2USOgoJYWRkcmVzc2VzGAEgAygLMhwud2VkZGluZy51c2'
    'VyLnYxLlVzZXJBZGRyZXNzUglhZGRyZXNzZXM=');

@$core.Deprecated('Use createAddressRequestDescriptor instead')
const CreateAddressRequest$json = {
  '1': 'CreateAddressRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'phone', '3': 2, '4': 1, '5': 9, '10': 'phone'},
    {'1': 'address', '3': 3, '4': 1, '5': 9, '10': 'address'},
    {'1': 'city', '3': 4, '4': 1, '5': 9, '10': 'city'},
    {'1': 'province', '3': 5, '4': 1, '5': 9, '10': 'province'},
    {'1': 'postal_code', '3': 6, '4': 1, '5': 9, '10': 'postalCode'},
    {
      '1': 'type',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.wedding.user.v1.AddressType',
      '10': 'type'
    },
    {'1': 'is_default', '3': 8, '4': 1, '5': 8, '10': 'isDefault'},
  ],
};

/// Descriptor for `CreateAddressRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createAddressRequestDescriptor = $convert.base64Decode(
    'ChRDcmVhdGVBZGRyZXNzUmVxdWVzdBISCgRuYW1lGAEgASgJUgRuYW1lEhQKBXBob25lGAIgAS'
    'gJUgVwaG9uZRIYCgdhZGRyZXNzGAMgASgJUgdhZGRyZXNzEhIKBGNpdHkYBCABKAlSBGNpdHkS'
    'GgoIcHJvdmluY2UYBSABKAlSCHByb3ZpbmNlEh8KC3Bvc3RhbF9jb2RlGAYgASgJUgpwb3N0YW'
    'xDb2RlEjAKBHR5cGUYByABKA4yHC53ZWRkaW5nLnVzZXIudjEuQWRkcmVzc1R5cGVSBHR5cGUS'
    'HQoKaXNfZGVmYXVsdBgIIAEoCFIJaXNEZWZhdWx0');

@$core.Deprecated('Use updateAddressRequestDescriptor instead')
const UpdateAddressRequest$json = {
  '1': 'UpdateAddressRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'phone', '3': 3, '4': 1, '5': 9, '10': 'phone'},
    {'1': 'address', '3': 4, '4': 1, '5': 9, '10': 'address'},
    {'1': 'city', '3': 5, '4': 1, '5': 9, '10': 'city'},
    {'1': 'province', '3': 6, '4': 1, '5': 9, '10': 'province'},
    {'1': 'postal_code', '3': 7, '4': 1, '5': 9, '10': 'postalCode'},
    {
      '1': 'type',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.wedding.user.v1.AddressType',
      '10': 'type'
    },
    {'1': 'is_default', '3': 9, '4': 1, '5': 8, '10': 'isDefault'},
  ],
};

/// Descriptor for `UpdateAddressRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateAddressRequestDescriptor = $convert.base64Decode(
    'ChRVcGRhdGVBZGRyZXNzUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQSEgoEbmFtZRgCIAEoCVIEbm'
    'FtZRIUCgVwaG9uZRgDIAEoCVIFcGhvbmUSGAoHYWRkcmVzcxgEIAEoCVIHYWRkcmVzcxISCgRj'
    'aXR5GAUgASgJUgRjaXR5EhoKCHByb3ZpbmNlGAYgASgJUghwcm92aW5jZRIfCgtwb3N0YWxfY2'
    '9kZRgHIAEoCVIKcG9zdGFsQ29kZRIwCgR0eXBlGAggASgOMhwud2VkZGluZy51c2VyLnYxLkFk'
    'ZHJlc3NUeXBlUgR0eXBlEh0KCmlzX2RlZmF1bHQYCSABKAhSCWlzRGVmYXVsdA==');

@$core.Deprecated('Use deleteAddressRequestDescriptor instead')
const DeleteAddressRequest$json = {
  '1': 'DeleteAddressRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `DeleteAddressRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteAddressRequestDescriptor = $convert
    .base64Decode('ChREZWxldGVBZGRyZXNzUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQ=');

@$core.Deprecated('Use deleteAddressResponseDescriptor instead')
const DeleteAddressResponse$json = {
  '1': 'DeleteAddressResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `DeleteAddressResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteAddressResponseDescriptor = $convert.base64Decode(
    'ChVEZWxldGVBZGRyZXNzUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIYCgdtZX'
    'NzYWdlGAIgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use setDefaultAddressRequestDescriptor instead')
const SetDefaultAddressRequest$json = {
  '1': 'SetDefaultAddressRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `SetDefaultAddressRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setDefaultAddressRequestDescriptor = $convert
    .base64Decode('ChhTZXREZWZhdWx0QWRkcmVzc1JlcXVlc3QSDgoCaWQYASABKAlSAmlk');

@$core.Deprecated('Use userAddressDescriptor instead')
const UserAddress$json = {
  '1': 'UserAddress',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'phone', '3': 4, '4': 1, '5': 9, '10': 'phone'},
    {'1': 'address', '3': 5, '4': 1, '5': 9, '10': 'address'},
    {'1': 'city', '3': 6, '4': 1, '5': 9, '10': 'city'},
    {'1': 'province', '3': 7, '4': 1, '5': 9, '10': 'province'},
    {'1': 'postal_code', '3': 8, '4': 1, '5': 9, '10': 'postalCode'},
    {
      '1': 'type',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.wedding.user.v1.AddressType',
      '10': 'type'
    },
    {'1': 'is_default', '3': 10, '4': 1, '5': 8, '10': 'isDefault'},
    {'1': 'created_at', '3': 11, '4': 1, '5': 9, '10': 'createdAt'},
    {'1': 'updated_at', '3': 12, '4': 1, '5': 9, '10': 'updatedAt'},
  ],
};

/// Descriptor for `UserAddress`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userAddressDescriptor = $convert.base64Decode(
    'CgtVc2VyQWRkcmVzcxIOCgJpZBgBIAEoCVICaWQSFwoHdXNlcl9pZBgCIAEoCVIGdXNlcklkEh'
    'IKBG5hbWUYAyABKAlSBG5hbWUSFAoFcGhvbmUYBCABKAlSBXBob25lEhgKB2FkZHJlc3MYBSAB'
    'KAlSB2FkZHJlc3MSEgoEY2l0eRgGIAEoCVIEY2l0eRIaCghwcm92aW5jZRgHIAEoCVIIcHJvdm'
    'luY2USHwoLcG9zdGFsX2NvZGUYCCABKAlSCnBvc3RhbENvZGUSMAoEdHlwZRgJIAEoDjIcLndl'
    'ZGRpbmcudXNlci52MS5BZGRyZXNzVHlwZVIEdHlwZRIdCgppc19kZWZhdWx0GAogASgIUglpc0'
    'RlZmF1bHQSHQoKY3JlYXRlZF9hdBgLIAEoCVIJY3JlYXRlZEF0Eh0KCnVwZGF0ZWRfYXQYDCAB'
    'KAlSCXVwZGF0ZWRBdA==');
