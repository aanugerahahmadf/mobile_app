// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/voucher.proto.

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

@$core.Deprecated('Use getMyVouchersRequestDescriptor instead')
const GetMyVouchersRequest$json = {
  '1': 'GetMyVouchersRequest',
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

/// Descriptor for `GetMyVouchersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMyVouchersRequestDescriptor = $convert.base64Decode(
    'ChRHZXRNeVZvdWNoZXJzUmVxdWVzdBJCCgpwYWdpbmF0aW9uGAEgASgLMiIud2VkZGluZy51c2'
    'VyLnYxLlBhZ2luYXRpb25SZXF1ZXN0UgpwYWdpbmF0aW9u');

@$core.Deprecated('Use getVoucherByCodeRequestDescriptor instead')
const GetVoucherByCodeRequest$json = {
  '1': 'GetVoucherByCodeRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
  ],
};

/// Descriptor for `GetVoucherByCodeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getVoucherByCodeRequestDescriptor =
    $convert.base64Decode(
        'ChdHZXRWb3VjaGVyQnlDb2RlUmVxdWVzdBISCgRjb2RlGAEgASgJUgRjb2Rl');

@$core.Deprecated('Use listVouchersRequestDescriptor instead')
const ListVouchersRequest$json = {
  '1': 'ListVouchersRequest',
  '2': [
    {
      '1': 'pagination',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.PaginationRequest',
      '10': 'pagination'
    },
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'active', '3': 3, '4': 1, '5': 8, '10': 'active'},
    {'1': 'is_global', '3': 4, '4': 1, '5': 8, '10': 'isGlobal'},
  ],
};

/// Descriptor for `ListVouchersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listVouchersRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0Vm91Y2hlcnNSZXF1ZXN0EkIKCnBhZ2luYXRpb24YASABKAsyIi53ZWRkaW5nLnVzZX'
    'IudjEuUGFnaW5hdGlvblJlcXVlc3RSCnBhZ2luYXRpb24SEgoEY29kZRgCIAEoCVIEY29kZRIW'
    'CgZhY3RpdmUYAyABKAhSBmFjdGl2ZRIbCglpc19nbG9iYWwYBCABKAhSCGlzR2xvYmFs');

@$core.Deprecated('Use getVoucherStatsRequestDescriptor instead')
const GetVoucherStatsRequest$json = {
  '1': 'GetVoucherStatsRequest',
  '2': [
    {'1': 'voucher_id', '3': 1, '4': 1, '5': 9, '10': 'voucherId'},
  ],
};

/// Descriptor for `GetVoucherStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getVoucherStatsRequestDescriptor =
    $convert.base64Decode(
        'ChZHZXRWb3VjaGVyU3RhdHNSZXF1ZXN0Eh0KCnZvdWNoZXJfaWQYASABKAlSCXZvdWNoZXJJZA'
        '==');

@$core.Deprecated('Use validateVoucherRequestDescriptor instead')
const ValidateVoucherRequest$json = {
  '1': 'ValidateVoucherRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'cart_total', '3': 2, '4': 1, '5': 1, '10': 'cartTotal'},
    {
      '1': 'items',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.ValidateVoucherItemInput',
      '10': 'items'
    },
  ],
};

/// Descriptor for `ValidateVoucherRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validateVoucherRequestDescriptor = $convert.base64Decode(
    'ChZWYWxpZGF0ZVZvdWNoZXJSZXF1ZXN0EhIKBGNvZGUYASABKAlSBGNvZGUSHQoKY2FydF90b3'
    'RhbBgCIAEoAVIJY2FydFRvdGFsEj8KBWl0ZW1zGAMgAygLMikud2VkZGluZy51c2VyLnYxLlZh'
    'bGlkYXRlVm91Y2hlckl0ZW1JbnB1dFIFaXRlbXM=');

@$core.Deprecated('Use createVoucherRequestDescriptor instead')
const CreateVoucherRequest$json = {
  '1': 'CreateVoucherRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'discount_amount', '3': 4, '4': 1, '5': 1, '10': 'discountAmount'},
    {
      '1': 'discount_type',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.wedding.user.v1.DiscountType',
      '10': 'discountType'
    },
    {'1': 'min_purchase', '3': 6, '4': 1, '5': 1, '10': 'minPurchase'},
    {'1': 'max_discount', '3': 7, '4': 1, '5': 1, '10': 'maxDiscount'},
    {'1': 'usage_limit', '3': 8, '4': 1, '5': 5, '10': 'usageLimit'},
    {
      '1': 'usage_limit_per_user',
      '3': 9,
      '4': 1,
      '5': 5,
      '10': 'usageLimitPerUser'
    },
    {'1': 'valid_from', '3': 10, '4': 1, '5': 9, '10': 'validFrom'},
    {'1': 'valid_until', '3': 11, '4': 1, '5': 9, '10': 'validUntil'},
    {'1': 'is_global', '3': 12, '4': 1, '5': 8, '10': 'isGlobal'},
    {
      '1': 'applicable_catalogs',
      '3': 13,
      '4': 3,
      '5': 9,
      '10': 'applicableCatalogs'
    },
    {
      '1': 'applicable_packages',
      '3': 14,
      '4': 3,
      '5': 9,
      '10': 'applicablePackages'
    },
    {
      '1': 'applicable_categories',
      '3': 15,
      '4': 3,
      '5': 9,
      '10': 'applicableCategories'
    },
    {
      '1': 'excluded_catalogs',
      '3': 16,
      '4': 3,
      '5': 9,
      '10': 'excludedCatalogs'
    },
    {
      '1': 'excluded_packages',
      '3': 17,
      '4': 3,
      '5': 9,
      '10': 'excludedPackages'
    },
    {
      '1': 'excluded_categories',
      '3': 18,
      '4': 3,
      '5': 9,
      '10': 'excludedCategories'
    },
    {'1': 'user_ids', '3': 19, '4': 3, '5': 9, '10': 'userIds'},
  ],
};

/// Descriptor for `CreateVoucherRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createVoucherRequestDescriptor = $convert.base64Decode(
    'ChRDcmVhdGVWb3VjaGVyUmVxdWVzdBISCgRuYW1lGAEgASgJUgRuYW1lEhIKBGNvZGUYAiABKA'
    'lSBGNvZGUSIAoLZGVzY3JpcHRpb24YAyABKAlSC2Rlc2NyaXB0aW9uEicKD2Rpc2NvdW50X2Ft'
    'b3VudBgEIAEoAVIOZGlzY291bnRBbW91bnQSQgoNZGlzY291bnRfdHlwZRgFIAEoDjIdLndlZG'
    'RpbmcudXNlci52MS5EaXNjb3VudFR5cGVSDGRpc2NvdW50VHlwZRIhCgxtaW5fcHVyY2hhc2UY'
    'BiABKAFSC21pblB1cmNoYXNlEiEKDG1heF9kaXNjb3VudBgHIAEoAVILbWF4RGlzY291bnQSHw'
    'oLdXNhZ2VfbGltaXQYCCABKAVSCnVzYWdlTGltaXQSLwoUdXNhZ2VfbGltaXRfcGVyX3VzZXIY'
    'CSABKAVSEXVzYWdlTGltaXRQZXJVc2VyEh0KCnZhbGlkX2Zyb20YCiABKAlSCXZhbGlkRnJvbR'
    'IfCgt2YWxpZF91bnRpbBgLIAEoCVIKdmFsaWRVbnRpbBIbCglpc19nbG9iYWwYDCABKAhSCGlz'
    'R2xvYmFsEi8KE2FwcGxpY2FibGVfY2F0YWxvZ3MYDSADKAlSEmFwcGxpY2FibGVDYXRhbG9ncx'
    'IvChNhcHBsaWNhYmxlX3BhY2thZ2VzGA4gAygJUhJhcHBsaWNhYmxlUGFja2FnZXMSMwoVYXBw'
    'bGljYWJsZV9jYXRlZ29yaWVzGA8gAygJUhRhcHBsaWNhYmxlQ2F0ZWdvcmllcxIrChFleGNsdW'
    'RlZF9jYXRhbG9ncxgQIAMoCVIQZXhjbHVkZWRDYXRhbG9ncxIrChFleGNsdWRlZF9wYWNrYWdl'
    'cxgRIAMoCVIQZXhjbHVkZWRQYWNrYWdlcxIvChNleGNsdWRlZF9jYXRlZ29yaWVzGBIgAygJUh'
    'JleGNsdWRlZENhdGVnb3JpZXMSGQoIdXNlcl9pZHMYEyADKAlSB3VzZXJJZHM=');

@$core.Deprecated('Use updateVoucherRequestDescriptor instead')
const UpdateVoucherRequest$json = {
  '1': 'UpdateVoucherRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'discount_amount', '3': 4, '4': 1, '5': 1, '10': 'discountAmount'},
    {
      '1': 'discount_type',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.wedding.user.v1.DiscountType',
      '10': 'discountType'
    },
    {'1': 'min_purchase', '3': 6, '4': 1, '5': 1, '10': 'minPurchase'},
    {'1': 'max_discount', '3': 7, '4': 1, '5': 1, '10': 'maxDiscount'},
    {'1': 'usage_limit', '3': 8, '4': 1, '5': 5, '10': 'usageLimit'},
    {
      '1': 'usage_limit_per_user',
      '3': 9,
      '4': 1,
      '5': 5,
      '10': 'usageLimitPerUser'
    },
    {'1': 'valid_from', '3': 10, '4': 1, '5': 9, '10': 'validFrom'},
    {'1': 'valid_until', '3': 11, '4': 1, '5': 9, '10': 'validUntil'},
    {'1': 'is_active', '3': 12, '4': 1, '5': 8, '10': 'isActive'},
    {'1': 'is_global', '3': 13, '4': 1, '5': 8, '10': 'isGlobal'},
    {
      '1': 'applicable_catalogs',
      '3': 14,
      '4': 3,
      '5': 9,
      '10': 'applicableCatalogs'
    },
    {
      '1': 'applicable_packages',
      '3': 15,
      '4': 3,
      '5': 9,
      '10': 'applicablePackages'
    },
    {
      '1': 'applicable_categories',
      '3': 16,
      '4': 3,
      '5': 9,
      '10': 'applicableCategories'
    },
    {
      '1': 'excluded_catalogs',
      '3': 17,
      '4': 3,
      '5': 9,
      '10': 'excludedCatalogs'
    },
    {
      '1': 'excluded_packages',
      '3': 18,
      '4': 3,
      '5': 9,
      '10': 'excludedPackages'
    },
    {
      '1': 'excluded_categories',
      '3': 19,
      '4': 3,
      '5': 9,
      '10': 'excludedCategories'
    },
    {'1': 'user_ids', '3': 20, '4': 3, '5': 9, '10': 'userIds'},
  ],
};

/// Descriptor for `UpdateVoucherRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateVoucherRequestDescriptor = $convert.base64Decode(
    'ChRVcGRhdGVWb3VjaGVyUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQSEgoEbmFtZRgCIAEoCVIEbm'
    'FtZRIgCgtkZXNjcmlwdGlvbhgDIAEoCVILZGVzY3JpcHRpb24SJwoPZGlzY291bnRfYW1vdW50'
    'GAQgASgBUg5kaXNjb3VudEFtb3VudBJCCg1kaXNjb3VudF90eXBlGAUgASgOMh0ud2VkZGluZy'
    '51c2VyLnYxLkRpc2NvdW50VHlwZVIMZGlzY291bnRUeXBlEiEKDG1pbl9wdXJjaGFzZRgGIAEo'
    'AVILbWluUHVyY2hhc2USIQoMbWF4X2Rpc2NvdW50GAcgASgBUgttYXhEaXNjb3VudBIfCgt1c2'
    'FnZV9saW1pdBgIIAEoBVIKdXNhZ2VMaW1pdBIvChR1c2FnZV9saW1pdF9wZXJfdXNlchgJIAEo'
    'BVIRdXNhZ2VMaW1pdFBlclVzZXISHQoKdmFsaWRfZnJvbRgKIAEoCVIJdmFsaWRGcm9tEh8KC3'
    'ZhbGlkX3VudGlsGAsgASgJUgp2YWxpZFVudGlsEhsKCWlzX2FjdGl2ZRgMIAEoCFIIaXNBY3Rp'
    'dmUSGwoJaXNfZ2xvYmFsGA0gASgIUghpc0dsb2JhbBIvChNhcHBsaWNhYmxlX2NhdGFsb2dzGA'
    '4gAygJUhJhcHBsaWNhYmxlQ2F0YWxvZ3MSLwoTYXBwbGljYWJsZV9wYWNrYWdlcxgPIAMoCVIS'
    'YXBwbGljYWJsZVBhY2thZ2VzEjMKFWFwcGxpY2FibGVfY2F0ZWdvcmllcxgQIAMoCVIUYXBwbG'
    'ljYWJsZUNhdGVnb3JpZXMSKwoRZXhjbHVkZWRfY2F0YWxvZ3MYESADKAlSEGV4Y2x1ZGVkQ2F0'
    'YWxvZ3MSKwoRZXhjbHVkZWRfcGFja2FnZXMYEiADKAlSEGV4Y2x1ZGVkUGFja2FnZXMSLwoTZX'
    'hjbHVkZWRfY2F0ZWdvcmllcxgTIAMoCVISZXhjbHVkZWRDYXRlZ29yaWVzEhkKCHVzZXJfaWRz'
    'GBQgAygJUgd1c2VySWRz');

@$core.Deprecated('Use deleteVoucherRequestDescriptor instead')
const DeleteVoucherRequest$json = {
  '1': 'DeleteVoucherRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `DeleteVoucherRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteVoucherRequestDescriptor = $convert
    .base64Decode('ChREZWxldGVWb3VjaGVyUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQ=');

@$core.Deprecated('Use toggleVoucherStatusRequestDescriptor instead')
const ToggleVoucherStatusRequest$json = {
  '1': 'ToggleVoucherStatusRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `ToggleVoucherStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toggleVoucherStatusRequestDescriptor =
    $convert.base64Decode(
        'ChpUb2dnbGVWb3VjaGVyU3RhdHVzUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQ=');

@$core.Deprecated('Use bulkCreateVouchersRequestDescriptor instead')
const BulkCreateVouchersRequest$json = {
  '1': 'BulkCreateVouchersRequest',
  '2': [
    {'1': 'prefix', '3': 1, '4': 1, '5': 9, '10': 'prefix'},
    {'1': 'count', '3': 2, '4': 1, '5': 5, '10': 'count'},
    {'1': 'discount_amount', '3': 3, '4': 1, '5': 1, '10': 'discountAmount'},
    {
      '1': 'discount_type',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.wedding.user.v1.DiscountType',
      '10': 'discountType'
    },
    {'1': 'min_purchase', '3': 5, '4': 1, '5': 1, '10': 'minPurchase'},
    {'1': 'max_discount', '3': 6, '4': 1, '5': 1, '10': 'maxDiscount'},
    {'1': 'usage_limit', '3': 7, '4': 1, '5': 5, '10': 'usageLimit'},
    {
      '1': 'usage_limit_per_user',
      '3': 8,
      '4': 1,
      '5': 5,
      '10': 'usageLimitPerUser'
    },
    {'1': 'valid_from', '3': 9, '4': 1, '5': 9, '10': 'validFrom'},
    {'1': 'valid_until', '3': 10, '4': 1, '5': 9, '10': 'validUntil'},
    {'1': 'length', '3': 11, '4': 1, '5': 5, '10': 'length'},
  ],
};

/// Descriptor for `BulkCreateVouchersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bulkCreateVouchersRequestDescriptor = $convert.base64Decode(
    'ChlCdWxrQ3JlYXRlVm91Y2hlcnNSZXF1ZXN0EhYKBnByZWZpeBgBIAEoCVIGcHJlZml4EhQKBW'
    'NvdW50GAIgASgFUgVjb3VudBInCg9kaXNjb3VudF9hbW91bnQYAyABKAFSDmRpc2NvdW50QW1v'
    'dW50EkIKDWRpc2NvdW50X3R5cGUYBCABKA4yHS53ZWRkaW5nLnVzZXIudjEuRGlzY291bnRUeX'
    'BlUgxkaXNjb3VudFR5cGUSIQoMbWluX3B1cmNoYXNlGAUgASgBUgttaW5QdXJjaGFzZRIhCgxt'
    'YXhfZGlzY291bnQYBiABKAFSC21heERpc2NvdW50Eh8KC3VzYWdlX2xpbWl0GAcgASgFUgp1c2'
    'FnZUxpbWl0Ei8KFHVzYWdlX2xpbWl0X3Blcl91c2VyGAggASgFUhF1c2FnZUxpbWl0UGVyVXNl'
    'chIdCgp2YWxpZF9mcm9tGAkgASgJUgl2YWxpZEZyb20SHwoLdmFsaWRfdW50aWwYCiABKAlSCn'
    'ZhbGlkVW50aWwSFgoGbGVuZ3RoGAsgASgFUgZsZW5ndGg=');

@$core.Deprecated('Use exportVoucherCodesRequestDescriptor instead')
const ExportVoucherCodesRequest$json = {
  '1': 'ExportVoucherCodesRequest',
  '2': [
    {'1': 'voucher_id', '3': 1, '4': 1, '5': 9, '10': 'voucherId'},
  ],
};

/// Descriptor for `ExportVoucherCodesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exportVoucherCodesRequestDescriptor =
    $convert.base64Decode(
        'ChlFeHBvcnRWb3VjaGVyQ29kZXNSZXF1ZXN0Eh0KCnZvdWNoZXJfaWQYASABKAlSCXZvdWNoZX'
        'JJZA==');

@$core.Deprecated('Use voucherListResponseDescriptor instead')
const VoucherListResponse$json = {
  '1': 'VoucherListResponse',
  '2': [
    {
      '1': 'vouchers',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.Voucher',
      '10': 'vouchers'
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

/// Descriptor for `VoucherListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voucherListResponseDescriptor = $convert.base64Decode(
    'ChNWb3VjaGVyTGlzdFJlc3BvbnNlEjQKCHZvdWNoZXJzGAEgAygLMhgud2VkZGluZy51c2VyLn'
    'YxLlZvdWNoZXJSCHZvdWNoZXJzEkMKCnBhZ2luYXRpb24YAiABKAsyIy53ZWRkaW5nLnVzZXIu'
    'djEuUGFnaW5hdGlvblJlc3BvbnNlUgpwYWdpbmF0aW9u');

@$core.Deprecated('Use voucherDescriptor instead')
const Voucher$json = {
  '1': 'Voucher',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'code', '3': 3, '4': 1, '5': 9, '10': 'code'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {'1': 'is_active', '3': 5, '4': 1, '5': 8, '10': 'isActive'},
    {'1': 'is_global', '3': 6, '4': 1, '5': 8, '10': 'isGlobal'},
    {'1': 'max_uses', '3': 7, '4': 1, '5': 5, '10': 'maxUses'},
    {'1': 'uses_count', '3': 8, '4': 1, '5': 5, '10': 'usesCount'},
    {'1': 'expires_at', '3': 9, '4': 1, '5': 9, '10': 'expiresAt'},
    {'1': 'discount_amount', '3': 10, '4': 1, '5': 1, '10': 'discountAmount'},
    {
      '1': 'discount_type',
      '3': 11,
      '4': 1,
      '5': 14,
      '6': '.wedding.user.v1.DiscountType',
      '10': 'discountType'
    },
    {'1': 'min_purchase', '3': 12, '4': 1, '5': 1, '10': 'minPurchase'},
    {'1': 'max_discount', '3': 13, '4': 1, '5': 1, '10': 'maxDiscount'},
    {
      '1': 'applicable_catalogs',
      '3': 14,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.Catalog',
      '10': 'applicableCatalogs'
    },
    {
      '1': 'applicable_packages',
      '3': 15,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.Package',
      '10': 'applicablePackages'
    },
    {
      '1': 'applicable_categories',
      '3': 16,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.Category',
      '10': 'applicableCategories'
    },
    {
      '1': 'excluded_catalogs',
      '3': 17,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.Catalog',
      '10': 'excludedCatalogs'
    },
    {
      '1': 'excluded_packages',
      '3': 18,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.Package',
      '10': 'excludedPackages'
    },
    {
      '1': 'excluded_categories',
      '3': 19,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.Category',
      '10': 'excludedCategories'
    },
    {
      '1': 'users',
      '3': 20,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.User',
      '10': 'users'
    },
    {'1': 'created_at', '3': 21, '4': 1, '5': 9, '10': 'createdAt'},
    {'1': 'updated_at', '3': 22, '4': 1, '5': 9, '10': 'updatedAt'},
  ],
};

/// Descriptor for `Voucher`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voucherDescriptor = $convert.base64Decode(
    'CgdWb3VjaGVyEg4KAmlkGAEgASgJUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEhIKBGNvZGUYAy'
    'ABKAlSBGNvZGUSIAoLZGVzY3JpcHRpb24YBCABKAlSC2Rlc2NyaXB0aW9uEhsKCWlzX2FjdGl2'
    'ZRgFIAEoCFIIaXNBY3RpdmUSGwoJaXNfZ2xvYmFsGAYgASgIUghpc0dsb2JhbBIZCghtYXhfdX'
    'NlcxgHIAEoBVIHbWF4VXNlcxIdCgp1c2VzX2NvdW50GAggASgFUgl1c2VzQ291bnQSHQoKZXhw'
    'aXJlc19hdBgJIAEoCVIJZXhwaXJlc0F0EicKD2Rpc2NvdW50X2Ftb3VudBgKIAEoAVIOZGlzY2'
    '91bnRBbW91bnQSQgoNZGlzY291bnRfdHlwZRgLIAEoDjIdLndlZGRpbmcudXNlci52MS5EaXNj'
    'b3VudFR5cGVSDGRpc2NvdW50VHlwZRIhCgxtaW5fcHVyY2hhc2UYDCABKAFSC21pblB1cmNoYX'
    'NlEiEKDG1heF9kaXNjb3VudBgNIAEoAVILbWF4RGlzY291bnQSSQoTYXBwbGljYWJsZV9jYXRh'
    'bG9ncxgOIAMoCzIYLndlZGRpbmcudXNlci52MS5DYXRhbG9nUhJhcHBsaWNhYmxlQ2F0YWxvZ3'
    'MSSQoTYXBwbGljYWJsZV9wYWNrYWdlcxgPIAMoCzIYLndlZGRpbmcudXNlci52MS5QYWNrYWdl'
    'UhJhcHBsaWNhYmxlUGFja2FnZXMSTgoVYXBwbGljYWJsZV9jYXRlZ29yaWVzGBAgAygLMhkud2'
    'VkZGluZy51c2VyLnYxLkNhdGVnb3J5UhRhcHBsaWNhYmxlQ2F0ZWdvcmllcxJFChFleGNsdWRl'
    'ZF9jYXRhbG9ncxgRIAMoCzIYLndlZGRpbmcudXNlci52MS5DYXRhbG9nUhBleGNsdWRlZENhdG'
    'Fsb2dzEkUKEWV4Y2x1ZGVkX3BhY2thZ2VzGBIgAygLMhgud2VkZGluZy51c2VyLnYxLlBhY2th'
    'Z2VSEGV4Y2x1ZGVkUGFja2FnZXMSSgoTZXhjbHVkZWRfY2F0ZWdvcmllcxgTIAMoCzIZLndlZG'
    'RpbmcudXNlci52MS5DYXRlZ29yeVISZXhjbHVkZWRDYXRlZ29yaWVzEisKBXVzZXJzGBQgAygL'
    'MhUud2VkZGluZy51c2VyLnYxLlVzZXJSBXVzZXJzEh0KCmNyZWF0ZWRfYXQYFSABKAlSCWNyZW'
    'F0ZWRBdBIdCgp1cGRhdGVkX2F0GBYgASgJUgl1cGRhdGVkQXQ=');

@$core.Deprecated('Use voucherValidationDescriptor instead')
const VoucherValidation$json = {
  '1': 'VoucherValidation',
  '2': [
    {'1': 'valid', '3': 1, '4': 1, '5': 8, '10': 'valid'},
    {
      '1': 'voucher',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.Voucher',
      '10': 'voucher'
    },
    {'1': 'discount', '3': 3, '4': 1, '5': 1, '10': 'discount'},
    {'1': 'message', '3': 4, '4': 1, '5': 9, '10': 'message'},
    {
      '1': 'applied_items',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.ValidatedItem',
      '10': 'appliedItems'
    },
  ],
};

/// Descriptor for `VoucherValidation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voucherValidationDescriptor = $convert.base64Decode(
    'ChFWb3VjaGVyVmFsaWRhdGlvbhIUCgV2YWxpZBgBIAEoCFIFdmFsaWQSMgoHdm91Y2hlchgCIA'
    'EoCzIYLndlZGRpbmcudXNlci52MS5Wb3VjaGVyUgd2b3VjaGVyEhoKCGRpc2NvdW50GAMgASgB'
    'UghkaXNjb3VudBIYCgdtZXNzYWdlGAQgASgJUgdtZXNzYWdlEkMKDWFwcGxpZWRfaXRlbXMYBS'
    'ADKAsyHi53ZWRkaW5nLnVzZXIudjEuVmFsaWRhdGVkSXRlbVIMYXBwbGllZEl0ZW1z');

@$core.Deprecated('Use validatedItemDescriptor instead')
const ValidatedItem$json = {
  '1': 'ValidatedItem',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'type', '3': 2, '4': 1, '5': 9, '10': 'type'},
    {'1': 'original_price', '3': 3, '4': 1, '5': 1, '10': 'originalPrice'},
    {'1': 'discounted_price', '3': 4, '4': 1, '5': 1, '10': 'discountedPrice'},
    {'1': 'discount', '3': 5, '4': 1, '5': 1, '10': 'discount'},
  ],
};

/// Descriptor for `ValidatedItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validatedItemDescriptor = $convert.base64Decode(
    'Cg1WYWxpZGF0ZWRJdGVtEg4KAmlkGAEgASgJUgJpZBISCgR0eXBlGAIgASgJUgR0eXBlEiUKDm'
    '9yaWdpbmFsX3ByaWNlGAMgASgBUg1vcmlnaW5hbFByaWNlEikKEGRpc2NvdW50ZWRfcHJpY2UY'
    'BCABKAFSD2Rpc2NvdW50ZWRQcmljZRIaCghkaXNjb3VudBgFIAEoAVIIZGlzY291bnQ=');

@$core.Deprecated('Use voucherStatsDescriptor instead')
const VoucherStats$json = {
  '1': 'VoucherStats',
  '2': [
    {
      '1': 'voucher',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.Voucher',
      '10': 'voucher'
    },
    {'1': 'total_uses', '3': 2, '4': 1, '5': 5, '10': 'totalUses'},
    {'1': 'remaining_uses', '3': 3, '4': 1, '5': 5, '10': 'remainingUses'},
    {
      '1': 'usage_by_user',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.VoucherUserUsage',
      '10': 'usageByUser'
    },
    {'1': 'revenue_impact', '3': 5, '4': 1, '5': 1, '10': 'revenueImpact'},
  ],
};

/// Descriptor for `VoucherStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voucherStatsDescriptor = $convert.base64Decode(
    'CgxWb3VjaGVyU3RhdHMSMgoHdm91Y2hlchgBIAEoCzIYLndlZGRpbmcudXNlci52MS5Wb3VjaG'
    'VyUgd2b3VjaGVyEh0KCnRvdGFsX3VzZXMYAiABKAVSCXRvdGFsVXNlcxIlCg5yZW1haW5pbmdf'
    'dXNlcxgDIAEoBVINcmVtYWluaW5nVXNlcxJFCg11c2FnZV9ieV91c2VyGAQgAygLMiEud2VkZG'
    'luZy51c2VyLnYxLlZvdWNoZXJVc2VyVXNhZ2VSC3VzYWdlQnlVc2VyEiUKDnJldmVudWVfaW1w'
    'YWN0GAUgASgBUg1yZXZlbnVlSW1wYWN0');

@$core.Deprecated('Use voucherUserUsageDescriptor instead')
const VoucherUserUsage$json = {
  '1': 'VoucherUserUsage',
  '2': [
    {
      '1': 'user',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.User',
      '10': 'user'
    },
    {'1': 'uses_count', '3': 2, '4': 1, '5': 5, '10': 'usesCount'},
    {'1': 'first_used_at', '3': 3, '4': 1, '5': 9, '10': 'firstUsedAt'},
    {'1': 'last_used_at', '3': 4, '4': 1, '5': 9, '10': 'lastUsedAt'},
  ],
};

/// Descriptor for `VoucherUserUsage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voucherUserUsageDescriptor = $convert.base64Decode(
    'ChBWb3VjaGVyVXNlclVzYWdlEikKBHVzZXIYASABKAsyFS53ZWRkaW5nLnVzZXIudjEuVXNlcl'
    'IEdXNlchIdCgp1c2VzX2NvdW50GAIgASgFUgl1c2VzQ291bnQSIgoNZmlyc3RfdXNlZF9hdBgD'
    'IAEoCVILZmlyc3RVc2VkQXQSIAoMbGFzdF91c2VkX2F0GAQgASgJUgpsYXN0VXNlZEF0');

@$core.Deprecated('Use voucherExportDescriptor instead')
const VoucherExport$json = {
  '1': 'VoucherExport',
  '2': [
    {
      '1': 'voucher',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.Voucher',
      '10': 'voucher'
    },
    {'1': 'codes', '3': 2, '4': 3, '5': 9, '10': 'codes'},
    {'1': 'csv_url', '3': 3, '4': 1, '5': 9, '10': 'csvUrl'},
    {'1': 'exported_at', '3': 4, '4': 1, '5': 9, '10': 'exportedAt'},
  ],
};

/// Descriptor for `VoucherExport`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voucherExportDescriptor = $convert.base64Decode(
    'Cg1Wb3VjaGVyRXhwb3J0EjIKB3ZvdWNoZXIYASABKAsyGC53ZWRkaW5nLnVzZXIudjEuVm91Y2'
    'hlclIHdm91Y2hlchIUCgVjb2RlcxgCIAMoCVIFY29kZXMSFwoHY3N2X3VybBgDIAEoCVIGY3N2'
    'VXJsEh8KC2V4cG9ydGVkX2F0GAQgASgJUgpleHBvcnRlZEF0');

@$core.Deprecated('Use deleteVoucherResponseDescriptor instead')
const DeleteVoucherResponse$json = {
  '1': 'DeleteVoucherResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `DeleteVoucherResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteVoucherResponseDescriptor = $convert.base64Decode(
    'ChVEZWxldGVWb3VjaGVyUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIYCgdtZX'
    'NzYWdlGAIgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use validateVoucherItemInputDescriptor instead')
const ValidateVoucherItemInput$json = {
  '1': 'ValidateVoucherItemInput',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'type', '3': 2, '4': 1, '5': 9, '10': 'type'},
    {'1': 'quantity', '3': 3, '4': 1, '5': 5, '10': 'quantity'},
    {'1': 'price', '3': 4, '4': 1, '5': 1, '10': 'price'},
  ],
};

/// Descriptor for `ValidateVoucherItemInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validateVoucherItemInputDescriptor = $convert.base64Decode(
    'ChhWYWxpZGF0ZVZvdWNoZXJJdGVtSW5wdXQSDgoCaWQYASABKAlSAmlkEhIKBHR5cGUYAiABKA'
    'lSBHR5cGUSGgoIcXVhbnRpdHkYAyABKAVSCHF1YW50aXR5EhQKBXByaWNlGAQgASgBUgVwcmlj'
    'ZQ==');
