// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/wishlist.proto.

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

@$core.Deprecated('Use getMyWishlistRequestDescriptor instead')
const GetMyWishlistRequest$json = {
  '1': 'GetMyWishlistRequest',
  '2': [
    {
      '1': 'pagination',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.PaginationRequest',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `GetMyWishlistRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMyWishlistRequestDescriptor = $convert.base64Decode(
    'ChRHZXRNeVdpc2hsaXN0UmVxdWVzdBJCCgpwYWdpbmF0aW9uGAEgASgLMiIud2VkZGluZy51c2'
    'VyLnYxLlBhZ2luYXRpb25SZXF1ZXN0UgpwYWdpbmF0aW9u');

@$core.Deprecated('Use isInWishlistRequestDescriptor instead')
const IsInWishlistRequest$json = {
  '1': 'IsInWishlistRequest',
  '2': [
    {'1': 'catalog_id', '3': 1, '4': 1, '5': 9, '10': 'catalogId'},
    {'1': 'package_id', '3': 2, '4': 1, '5': 9, '10': 'packageId'},
  ],
};

/// Descriptor for `IsInWishlistRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List isInWishlistRequestDescriptor = $convert.base64Decode(
    'ChNJc0luV2lzaGxpc3RSZXF1ZXN0Eh0KCmNhdGFsb2dfaWQYASABKAlSCWNhdGFsb2dJZBIdCg'
    'pwYWNrYWdlX2lkGAIgASgJUglwYWNrYWdlSWQ=');

@$core.Deprecated('Use toggleWishlistRequestDescriptor instead')
const ToggleWishlistRequest$json = {
  '1': 'ToggleWishlistRequest',
  '2': [
    {'1': 'catalog_id', '3': 1, '4': 1, '5': 9, '10': 'catalogId'},
    {'1': 'package_id', '3': 2, '4': 1, '5': 9, '10': 'packageId'},
  ],
};

/// Descriptor for `ToggleWishlistRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toggleWishlistRequestDescriptor = $convert.base64Decode(
    'ChVUb2dnbGVXaXNobGlzdFJlcXVlc3QSHQoKY2F0YWxvZ19pZBgBIAEoCVIJY2F0YWxvZ0lkEh'
    '0KCnBhY2thZ2VfaWQYAiABKAlSCXBhY2thZ2VJZA==');

@$core.Deprecated('Use addToWishlistRequestDescriptor instead')
const AddToWishlistRequest$json = {
  '1': 'AddToWishlistRequest',
  '2': [
    {'1': 'catalog_id', '3': 1, '4': 1, '5': 9, '10': 'catalogId'},
    {'1': 'package_id', '3': 2, '4': 1, '5': 9, '10': 'packageId'},
  ],
};

/// Descriptor for `AddToWishlistRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addToWishlistRequestDescriptor = $convert.base64Decode(
    'ChRBZGRUb1dpc2hsaXN0UmVxdWVzdBIdCgpjYXRhbG9nX2lkGAEgASgJUgljYXRhbG9nSWQSHQ'
    'oKcGFja2FnZV9pZBgCIAEoCVIJcGFja2FnZUlk');

@$core.Deprecated('Use removeFromWishlistRequestDescriptor instead')
const RemoveFromWishlistRequest$json = {
  '1': 'RemoveFromWishlistRequest',
  '2': [
    {'1': 'wishlist_id', '3': 1, '4': 1, '5': 9, '10': 'wishlistId'},
  ],
};

/// Descriptor for `RemoveFromWishlistRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeFromWishlistRequestDescriptor =
    $convert.base64Decode(
        'ChlSZW1vdmVGcm9tV2lzaGxpc3RSZXF1ZXN0Eh8KC3dpc2hsaXN0X2lkGAEgASgJUgp3aXNobG'
        'lzdElk');

@$core.Deprecated('Use clearWishlistRequestDescriptor instead')
const ClearWishlistRequest$json = {
  '1': 'ClearWishlistRequest',
};

/// Descriptor for `ClearWishlistRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clearWishlistRequestDescriptor =
    $convert.base64Decode('ChRDbGVhcldpc2hsaXN0UmVxdWVzdA==');

@$core.Deprecated('Use moveToCartRequestDescriptor instead')
const MoveToCartRequest$json = {
  '1': 'MoveToCartRequest',
  '2': [
    {'1': 'wishlist_id', '3': 1, '4': 1, '5': 9, '10': 'wishlistId'},
    {'1': 'quantity', '3': 2, '4': 1, '5': 5, '10': 'quantity'},
  ],
};

/// Descriptor for `MoveToCartRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moveToCartRequestDescriptor = $convert.base64Decode(
    'ChFNb3ZlVG9DYXJ0UmVxdWVzdBIfCgt3aXNobGlzdF9pZBgBIAEoCVIKd2lzaGxpc3RJZBIaCg'
    'hxdWFudGl0eRgCIAEoBVIIcXVhbnRpdHk=');

@$core.Deprecated('Use shareWishlistRequestDescriptor instead')
const ShareWishlistRequest$json = {
  '1': 'ShareWishlistRequest',
};

/// Descriptor for `ShareWishlistRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shareWishlistRequestDescriptor =
    $convert.base64Decode('ChRTaGFyZVdpc2hsaXN0UmVxdWVzdA==');

@$core.Deprecated('Use wishlistListResponseDescriptor instead')
const WishlistListResponse$json = {
  '1': 'WishlistListResponse',
  '2': [
    {
      '1': 'wishlist',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.Wishlist',
      '10': 'wishlist'
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

/// Descriptor for `WishlistListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List wishlistListResponseDescriptor = $convert.base64Decode(
    'ChRXaXNobGlzdExpc3RSZXNwb25zZRI1Cgh3aXNobGlzdBgBIAMoCzIZLndlZGRpbmcudXNlci'
    '52MS5XaXNobGlzdFIId2lzaGxpc3QSQwoKcGFnaW5hdGlvbhgCIAEoCzIjLndlZGRpbmcudXNl'
    'ci52MS5QYWdpbmF0aW9uUmVzcG9uc2VSCnBhZ2luYXRpb24=');

@$core.Deprecated('Use wishlistDescriptor instead')
const Wishlist$json = {
  '1': 'Wishlist',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {
      '1': 'user',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.User',
      '10': 'user'
    },
    {
      '1': 'catalog',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.Catalog',
      '10': 'catalog'
    },
    {
      '1': 'package',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.Package',
      '10': 'package'
    },
    {'1': 'created_at', '3': 5, '4': 1, '5': 9, '10': 'createdAt'},
  ],
};

/// Descriptor for `Wishlist`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List wishlistDescriptor = $convert.base64Decode(
    'CghXaXNobGlzdBIOCgJpZBgBIAEoCVICaWQSKQoEdXNlchgCIAEoCzIVLndlZGRpbmcudXNlci'
    '52MS5Vc2VyUgR1c2VyEjIKB2NhdGFsb2cYAyABKAsyGC53ZWRkaW5nLnVzZXIudjEuQ2F0YWxv'
    'Z1IHY2F0YWxvZxIyCgdwYWNrYWdlGAQgASgLMhgud2VkZGluZy51c2VyLnYxLlBhY2thZ2VSB3'
    'BhY2thZ2USHQoKY3JlYXRlZF9hdBgFIAEoCVIJY3JlYXRlZEF0');

@$core.Deprecated('Use isInWishlistResponseDescriptor instead')
const IsInWishlistResponse$json = {
  '1': 'IsInWishlistResponse',
  '2': [
    {'1': 'in_wishlist', '3': 1, '4': 1, '5': 8, '10': 'inWishlist'},
  ],
};

/// Descriptor for `IsInWishlistResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List isInWishlistResponseDescriptor = $convert.base64Decode(
    'ChRJc0luV2lzaGxpc3RSZXNwb25zZRIfCgtpbl93aXNobGlzdBgBIAEoCFIKaW5XaXNobGlzdA'
    '==');

@$core.Deprecated('Use wishlistActionResponseDescriptor instead')
const WishlistActionResponse$json = {
  '1': 'WishlistActionResponse',
  '2': [
    {
      '1': 'wishlist',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.Wishlist',
      '10': 'wishlist'
    },
    {
      '1': 'action',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.wedding.user.v1.WishlistActionType',
      '10': 'action'
    },
    {'1': 'message', '3': 3, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `WishlistActionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List wishlistActionResponseDescriptor = $convert.base64Decode(
    'ChZXaXNobGlzdEFjdGlvblJlc3BvbnNlEjUKCHdpc2hsaXN0GAEgASgLMhkud2VkZGluZy51c2'
    'VyLnYxLldpc2hsaXN0Ugh3aXNobGlzdBI7CgZhY3Rpb24YAiABKA4yIy53ZWRkaW5nLnVzZXIu'
    'djEuV2lzaGxpc3RBY3Rpb25UeXBlUgZhY3Rpb24SGAoHbWVzc2FnZRgDIAEoCVIHbWVzc2FnZQ'
    '==');

@$core.Deprecated('Use removeFromWishlistResponseDescriptor instead')
const RemoveFromWishlistResponse$json = {
  '1': 'RemoveFromWishlistResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `RemoveFromWishlistResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeFromWishlistResponseDescriptor =
    $convert.base64Decode(
        'ChpSZW1vdmVGcm9tV2lzaGxpc3RSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEh'
        'gKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2U=');

@$core.Deprecated('Use clearWishlistResponseDescriptor instead')
const ClearWishlistResponse$json = {
  '1': 'ClearWishlistResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `ClearWishlistResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clearWishlistResponseDescriptor = $convert.base64Decode(
    'ChVDbGVhcldpc2hsaXN0UmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIYCgdtZX'
    'NzYWdlGAIgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use wishlistShareDescriptor instead')
const WishlistShare$json = {
  '1': 'WishlistShare',
  '2': [
    {'1': 'share_token', '3': 1, '4': 1, '5': 9, '10': 'shareToken'},
    {'1': 'share_url', '3': 2, '4': 1, '5': 9, '10': 'shareUrl'},
    {'1': 'expires_at', '3': 3, '4': 1, '5': 9, '10': 'expiresAt'},
  ],
};

/// Descriptor for `WishlistShare`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List wishlistShareDescriptor = $convert.base64Decode(
    'Cg1XaXNobGlzdFNoYXJlEh8KC3NoYXJlX3Rva2VuGAEgASgJUgpzaGFyZVRva2VuEhsKCXNoYX'
    'JlX3VybBgCIAEoCVIIc2hhcmVVcmwSHQoKZXhwaXJlc19hdBgDIAEoCVIJZXhwaXJlc0F0');
