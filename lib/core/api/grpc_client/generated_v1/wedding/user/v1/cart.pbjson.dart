// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/cart.proto.

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

@$core.Deprecated('Use getMyCartRequestDescriptor instead')
const GetMyCartRequest$json = {
  '1': 'GetMyCartRequest',
};

/// Descriptor for `GetMyCartRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMyCartRequestDescriptor =
    $convert.base64Decode('ChBHZXRNeUNhcnRSZXF1ZXN0');

@$core.Deprecated('Use addToCartRequestDescriptor instead')
const AddToCartRequest$json = {
  '1': 'AddToCartRequest',
  '2': [
    {'1': 'catalog_id', '3': 1, '4': 1, '5': 9, '10': 'catalogId'},
    {'1': 'package_id', '3': 2, '4': 1, '5': 9, '10': 'packageId'},
    {'1': 'quantity', '3': 3, '4': 1, '5': 5, '10': 'quantity'},
    {
      '1': 'options',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.MetaData',
      '10': 'options'
    },
  ],
};

/// Descriptor for `AddToCartRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addToCartRequestDescriptor = $convert.base64Decode(
    'ChBBZGRUb0NhcnRSZXF1ZXN0Eh0KCmNhdGFsb2dfaWQYASABKAlSCWNhdGFsb2dJZBIdCgpwYW'
    'NrYWdlX2lkGAIgASgJUglwYWNrYWdlSWQSGgoIcXVhbnRpdHkYAyABKAVSCHF1YW50aXR5EjMK'
    'B29wdGlvbnMYBCABKAsyGS53ZWRkaW5nLnVzZXIudjEuTWV0YURhdGFSB29wdGlvbnM=');

@$core.Deprecated('Use updateCartItemRequestDescriptor instead')
const UpdateCartItemRequest$json = {
  '1': 'UpdateCartItemRequest',
  '2': [
    {'1': 'cart_item_id', '3': 1, '4': 1, '5': 9, '10': 'cartItemId'},
    {'1': 'quantity', '3': 2, '4': 1, '5': 5, '10': 'quantity'},
    {
      '1': 'options',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.MetaData',
      '10': 'options'
    },
  ],
};

/// Descriptor for `UpdateCartItemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateCartItemRequestDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVDYXJ0SXRlbVJlcXVlc3QSIAoMY2FydF9pdGVtX2lkGAEgASgJUgpjYXJ0SXRlbU'
    'lkEhoKCHF1YW50aXR5GAIgASgFUghxdWFudGl0eRIzCgdvcHRpb25zGAMgASgLMhkud2VkZGlu'
    'Zy51c2VyLnYxLk1ldGFEYXRhUgdvcHRpb25z');

@$core.Deprecated('Use removeFromCartRequestDescriptor instead')
const RemoveFromCartRequest$json = {
  '1': 'RemoveFromCartRequest',
  '2': [
    {'1': 'cart_item_id', '3': 1, '4': 1, '5': 9, '10': 'cartItemId'},
  ],
};

/// Descriptor for `RemoveFromCartRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeFromCartRequestDescriptor = $convert.base64Decode(
    'ChVSZW1vdmVGcm9tQ2FydFJlcXVlc3QSIAoMY2FydF9pdGVtX2lkGAEgASgJUgpjYXJ0SXRlbU'
    'lk');

@$core.Deprecated('Use clearCartRequestDescriptor instead')
const ClearCartRequest$json = {
  '1': 'ClearCartRequest',
};

/// Descriptor for `ClearCartRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clearCartRequestDescriptor =
    $convert.base64Decode('ChBDbGVhckNhcnRSZXF1ZXN0');

@$core.Deprecated('Use applyVoucherToCartRequestDescriptor instead')
const ApplyVoucherToCartRequest$json = {
  '1': 'ApplyVoucherToCartRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
  ],
};

/// Descriptor for `ApplyVoucherToCartRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applyVoucherToCartRequestDescriptor =
    $convert.base64Decode(
        'ChlBcHBseVZvdWNoZXJUb0NhcnRSZXF1ZXN0EhIKBGNvZGUYASABKAlSBGNvZGU=');

@$core.Deprecated('Use removeVoucherFromCartRequestDescriptor instead')
const RemoveVoucherFromCartRequest$json = {
  '1': 'RemoveVoucherFromCartRequest',
};

/// Descriptor for `RemoveVoucherFromCartRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeVoucherFromCartRequestDescriptor =
    $convert.base64Decode('ChxSZW1vdmVWb3VjaGVyRnJvbUNhcnRSZXF1ZXN0');

@$core.Deprecated('Use syncCartRequestDescriptor instead')
const SyncCartRequest$json = {
  '1': 'SyncCartRequest',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.SyncCartItemInput',
      '10': 'items'
    },
  ],
};

/// Descriptor for `SyncCartRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List syncCartRequestDescriptor = $convert.base64Decode(
    'Cg9TeW5jQ2FydFJlcXVlc3QSOAoFaXRlbXMYASADKAsyIi53ZWRkaW5nLnVzZXIudjEuU3luY0'
    'NhcnRJdGVtSW5wdXRSBWl0ZW1z');

@$core.Deprecated('Use estimateShippingRequestDescriptor instead')
const EstimateShippingRequest$json = {
  '1': 'EstimateShippingRequest',
  '2': [
    {'1': 'address_id', '3': 1, '4': 1, '5': 9, '10': 'addressId'},
  ],
};

/// Descriptor for `EstimateShippingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List estimateShippingRequestDescriptor =
    $convert.base64Decode(
        'ChdFc3RpbWF0ZVNoaXBwaW5nUmVxdWVzdBIdCgphZGRyZXNzX2lkGAEgASgJUglhZGRyZXNzSW'
        'Q=');

@$core.Deprecated('Use cartDescriptor instead')
const Cart$json = {
  '1': 'Cart',
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
      '1': 'items',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.CartItem',
      '10': 'items'
    },
    {'1': 'subtotal', '3': 4, '4': 1, '5': 1, '10': 'subtotal'},
    {'1': 'discount', '3': 5, '4': 1, '5': 1, '10': 'discount'},
    {
      '1': 'voucher',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.Voucher',
      '10': 'voucher'
    },
    {'1': 'shipping_cost', '3': 7, '4': 1, '5': 1, '10': 'shippingCost'},
    {'1': 'tax', '3': 8, '4': 1, '5': 1, '10': 'tax'},
    {'1': 'total', '3': 9, '4': 1, '5': 1, '10': 'total'},
    {'1': 'item_count', '3': 10, '4': 1, '5': 5, '10': 'itemCount'},
    {'1': 'updated_at', '3': 11, '4': 1, '5': 9, '10': 'updatedAt'},
  ],
};

/// Descriptor for `Cart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cartDescriptor = $convert.base64Decode(
    'CgRDYXJ0Eg4KAmlkGAEgASgJUgJpZBIpCgR1c2VyGAIgASgLMhUud2VkZGluZy51c2VyLnYxLl'
    'VzZXJSBHVzZXISLwoFaXRlbXMYAyADKAsyGS53ZWRkaW5nLnVzZXIudjEuQ2FydEl0ZW1SBWl0'
    'ZW1zEhoKCHN1YnRvdGFsGAQgASgBUghzdWJ0b3RhbBIaCghkaXNjb3VudBgFIAEoAVIIZGlzY2'
    '91bnQSMgoHdm91Y2hlchgGIAEoCzIYLndlZGRpbmcudXNlci52MS5Wb3VjaGVyUgd2b3VjaGVy'
    'EiMKDXNoaXBwaW5nX2Nvc3QYByABKAFSDHNoaXBwaW5nQ29zdBIQCgN0YXgYCCABKAFSA3RheB'
    'IUCgV0b3RhbBgJIAEoAVIFdG90YWwSHQoKaXRlbV9jb3VudBgKIAEoBVIJaXRlbUNvdW50Eh0K'
    'CnVwZGF0ZWRfYXQYCyABKAlSCXVwZGF0ZWRBdA==');

@$core.Deprecated('Use cartItemDescriptor instead')
const CartItem$json = {
  '1': 'CartItem',
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
    {'1': 'quantity', '3': 5, '4': 1, '5': 5, '10': 'quantity'},
    {'1': 'subtotal', '3': 6, '4': 1, '5': 1, '10': 'subtotal'},
    {
      '1': 'options',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.MetaData',
      '10': 'options'
    },
    {'1': 'created_at', '3': 8, '4': 1, '5': 9, '10': 'createdAt'},
    {'1': 'updated_at', '3': 9, '4': 1, '5': 9, '10': 'updatedAt'},
  ],
};

/// Descriptor for `CartItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cartItemDescriptor = $convert.base64Decode(
    'CghDYXJ0SXRlbRIOCgJpZBgBIAEoCVICaWQSKQoEdXNlchgCIAEoCzIVLndlZGRpbmcudXNlci'
    '52MS5Vc2VyUgR1c2VyEjIKB2NhdGFsb2cYAyABKAsyGC53ZWRkaW5nLnVzZXIudjEuQ2F0YWxv'
    'Z1IHY2F0YWxvZxIyCgdwYWNrYWdlGAQgASgLMhgud2VkZGluZy51c2VyLnYxLlBhY2thZ2VSB3'
    'BhY2thZ2USGgoIcXVhbnRpdHkYBSABKAVSCHF1YW50aXR5EhoKCHN1YnRvdGFsGAYgASgBUghz'
    'dWJ0b3RhbBIzCgdvcHRpb25zGAcgASgLMhkud2VkZGluZy51c2VyLnYxLk1ldGFEYXRhUgdvcH'
    'Rpb25zEh0KCmNyZWF0ZWRfYXQYCCABKAlSCWNyZWF0ZWRBdBIdCgp1cGRhdGVkX2F0GAkgASgJ'
    'Ugl1cGRhdGVkQXQ=');

@$core.Deprecated('Use shippingEstimateDescriptor instead')
const ShippingEstimate$json = {
  '1': 'ShippingEstimate',
  '2': [
    {'1': 'cost', '3': 1, '4': 1, '5': 1, '10': 'cost'},
    {'1': 'estimated_days', '3': 2, '4': 1, '5': 5, '10': 'estimatedDays'},
    {'1': 'method', '3': 3, '4': 1, '5': 9, '10': 'method'},
    {'1': 'available', '3': 4, '4': 1, '5': 8, '10': 'available'},
  ],
};

/// Descriptor for `ShippingEstimate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shippingEstimateDescriptor = $convert.base64Decode(
    'ChBTaGlwcGluZ0VzdGltYXRlEhIKBGNvc3QYASABKAFSBGNvc3QSJQoOZXN0aW1hdGVkX2RheX'
    'MYAiABKAVSDWVzdGltYXRlZERheXMSFgoGbWV0aG9kGAMgASgJUgZtZXRob2QSHAoJYXZhaWxh'
    'YmxlGAQgASgIUglhdmFpbGFibGU=');

@$core.Deprecated('Use removeFromCartResponseDescriptor instead')
const RemoveFromCartResponse$json = {
  '1': 'RemoveFromCartResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `RemoveFromCartResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeFromCartResponseDescriptor =
    $convert.base64Decode(
        'ChZSZW1vdmVGcm9tQ2FydFJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSGAoHbW'
        'Vzc2FnZRgCIAEoCVIHbWVzc2FnZQ==');

@$core.Deprecated('Use clearCartResponseDescriptor instead')
const ClearCartResponse$json = {
  '1': 'ClearCartResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `ClearCartResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clearCartResponseDescriptor = $convert.base64Decode(
    'ChFDbGVhckNhcnRSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEhgKB21lc3NhZ2'
    'UYAiABKAlSB21lc3NhZ2U=');

@$core.Deprecated('Use syncCartItemInputDescriptor instead')
const SyncCartItemInput$json = {
  '1': 'SyncCartItemInput',
  '2': [
    {'1': 'catalog_id', '3': 1, '4': 1, '5': 9, '10': 'catalogId'},
    {'1': 'package_id', '3': 2, '4': 1, '5': 9, '10': 'packageId'},
    {'1': 'quantity', '3': 3, '4': 1, '5': 5, '10': 'quantity'},
    {
      '1': 'options',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.MetaData',
      '10': 'options'
    },
  ],
};

/// Descriptor for `SyncCartItemInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List syncCartItemInputDescriptor = $convert.base64Decode(
    'ChFTeW5jQ2FydEl0ZW1JbnB1dBIdCgpjYXRhbG9nX2lkGAEgASgJUgljYXRhbG9nSWQSHQoKcG'
    'Fja2FnZV9pZBgCIAEoCVIJcGFja2FnZUlkEhoKCHF1YW50aXR5GAMgASgFUghxdWFudGl0eRIz'
    'CgdvcHRpb25zGAQgASgLMhkud2VkZGluZy51c2VyLnYxLk1ldGFEYXRhUgdvcHRpb25z');
