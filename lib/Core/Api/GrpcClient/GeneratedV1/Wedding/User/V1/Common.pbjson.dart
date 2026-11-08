// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/common.proto.

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

@$core.Deprecated('Use sortDirectionDescriptor instead')
const SortDirection$json = {
  '1': 'SortDirection',
  '2': [
    {'1': 'SORT_DIRECTION_UNSPECIFIED', '2': 0},
    {'1': 'SORT_DIRECTION_ASC', '2': 1},
    {'1': 'SORT_DIRECTION_DESC', '2': 2},
  ],
};

/// Descriptor for `SortDirection`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List sortDirectionDescriptor = $convert.base64Decode(
    'Cg1Tb3J0RGlyZWN0aW9uEh4KGlNPUlRfRElSRUNUSU9OX1VOU1BFQ0lGSUVEEAASFgoSU09SVF'
    '9ESVJFQ1RJT05fQVNDEAESFwoTU09SVF9ESVJFQ1RJT05fREVTQxAC');

@$core.Deprecated('Use genderDescriptor instead')
const Gender$json = {
  '1': 'Gender',
  '2': [
    {'1': 'GENDER_UNSPECIFIED', '2': 0},
    {'1': 'GENDER_MALE', '2': 1},
    {'1': 'GENDER_FEMALE', '2': 2},
    {'1': 'GENDER_OTHER', '2': 3},
    {'1': 'GENDER_PREFER_NOT_TO_SAY', '2': 4},
  ],
};

/// Descriptor for `Gender`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List genderDescriptor = $convert.base64Decode(
    'CgZHZW5kZXISFgoSR0VOREVSX1VOU1BFQ0lGSUVEEAASDwoLR0VOREVSX01BTEUQARIRCg1HRU'
    '5ERVJfRkVNQUxFEAISEAoMR0VOREVSX09USEVSEAMSHAoYR0VOREVSX1BSRUZFUl9OT1RfVE9f'
    'U0FZEAQ=');

@$core.Deprecated('Use addressTypeDescriptor instead')
const AddressType$json = {
  '1': 'AddressType',
  '2': [
    {'1': 'ADDRESS_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'ADDRESS_TYPE_HOME', '2': 1},
    {'1': 'ADDRESS_TYPE_WORK', '2': 2},
    {'1': 'ADDRESS_TYPE_OTHER', '2': 3},
  ],
};

/// Descriptor for `AddressType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List addressTypeDescriptor = $convert.base64Decode(
    'CgtBZGRyZXNzVHlwZRIcChhBRERSRVNTX1RZUEVfVU5TUEVDSUZJRUQQABIVChFBRERSRVNTX1'
    'RZUEVfSE9NRRABEhUKEUFERFJFU1NfVFlQRV9XT1JLEAISFgoSQUREUkVTU19UWVBFX09USEVS'
    'EAM=');

@$core.Deprecated('Use paymentMethodDescriptor instead')
const PaymentMethod$json = {
  '1': 'PaymentMethod',
  '2': [
    {'1': 'PAYMENT_METHOD_UNSPECIFIED', '2': 0},
    {'1': 'PAYMENT_METHOD_MIDTRANS', '2': 1},
    {'1': 'PAYMENT_METHOD_BANK_TRANSFER', '2': 2},
    {'1': 'PAYMENT_METHOD_CASH_ON_DELIVERY', '2': 3},
    {'1': 'PAYMENT_METHOD_E_WALLET', '2': 4},
    {'1': 'PAYMENT_METHOD_CREDIT_CARD', '2': 5},
  ],
};

/// Descriptor for `PaymentMethod`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List paymentMethodDescriptor = $convert.base64Decode(
    'Cg1QYXltZW50TWV0aG9kEh4KGlBBWU1FTlRfTUVUSE9EX1VOU1BFQ0lGSUVEEAASGwoXUEFZTU'
    'VOVF9NRVRIT0RfTUlEVFJBTlMQARIgChxQQVlNRU5UX01FVEhPRF9CQU5LX1RSQU5TRkVSEAIS'
    'IwofUEFZTUVOVF9NRVRIT0RfQ0FTSF9PTl9ERUxJVkVSWRADEhsKF1BBWU1FTlRfTUVUSE9EX0'
    'VfV0FMTEVUEAQSHgoaUEFZTUVOVF9NRVRIT0RfQ1JFRElUX0NBUkQQBQ==');

@$core.Deprecated('Use orderStatusDescriptor instead')
const OrderStatus$json = {
  '1': 'OrderStatus',
  '2': [
    {'1': 'ORDER_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'ORDER_STATUS_PENDING', '2': 1},
    {'1': 'ORDER_STATUS_CONFIRMED', '2': 2},
    {'1': 'ORDER_STATUS_PROCESSING', '2': 3},
    {'1': 'ORDER_STATUS_SHIPPED', '2': 4},
    {'1': 'ORDER_STATUS_DELIVERED', '2': 5},
    {'1': 'ORDER_STATUS_CANCELLED', '2': 6},
    {'1': 'ORDER_STATUS_REFUNDED', '2': 7},
  ],
};

/// Descriptor for `OrderStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List orderStatusDescriptor = $convert.base64Decode(
    'CgtPcmRlclN0YXR1cxIcChhPUkRFUl9TVEFUVVNfVU5TUEVDSUZJRUQQABIYChRPUkRFUl9TVE'
    'FUVVNfUEVORElORxABEhoKFk9SREVSX1NUQVRVU19DT05GSVJNRUQQAhIbChdPUkRFUl9TVEFU'
    'VVNfUFJPQ0VTU0lORxADEhgKFE9SREVSX1NUQVRVU19TSElQUEVEEAQSGgoWT1JERVJfU1RBVF'
    'VTX0RFTElWRVJFRBAFEhoKFk9SREVSX1NUQVRVU19DQU5DRUxMRUQQBhIZChVPUkRFUl9TVEFU'
    'VVNfUkVGVU5ERUQQBw==');

@$core.Deprecated('Use paymentStatusDescriptor instead')
const PaymentStatus$json = {
  '1': 'PaymentStatus',
  '2': [
    {'1': 'PAYMENT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'PAYMENT_STATUS_PENDING', '2': 1},
    {'1': 'PAYMENT_STATUS_PAID', '2': 2},
    {'1': 'PAYMENT_STATUS_FAILED', '2': 3},
    {'1': 'PAYMENT_STATUS_REFUNDED', '2': 4},
    {'1': 'PAYMENT_STATUS_PARTIALLY_REFUNDED', '2': 5},
  ],
};

/// Descriptor for `PaymentStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List paymentStatusDescriptor = $convert.base64Decode(
    'Cg1QYXltZW50U3RhdHVzEh4KGlBBWU1FTlRfU1RBVFVTX1VOU1BFQ0lGSUVEEAASGgoWUEFZTU'
    'VOVF9TVEFUVVNfUEVORElORxABEhcKE1BBWU1FTlRfU1RBVFVTX1BBSUQQAhIZChVQQVlNRU5U'
    'X1NUQVRVU19GQUlMRUQQAxIbChdQQVlNRU5UX1NUQVRVU19SRUZVTkRFRBAEEiUKIVBBWU1FTl'
    'RfU1RBVFVTX1BBUlRJQUxMWV9SRUZVTkRFRBAF');

@$core.Deprecated('Use reviewStatusDescriptor instead')
const ReviewStatus$json = {
  '1': 'ReviewStatus',
  '2': [
    {'1': 'REVIEW_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'REVIEW_STATUS_PENDING', '2': 1},
    {'1': 'REVIEW_STATUS_APPROVED', '2': 2},
    {'1': 'REVIEW_STATUS_REJECTED', '2': 3},
    {'1': 'REVIEW_STATUS_HIDDEN', '2': 4},
  ],
};

/// Descriptor for `ReviewStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List reviewStatusDescriptor = $convert.base64Decode(
    'CgxSZXZpZXdTdGF0dXMSHQoZUkVWSUVXX1NUQVRVU19VTlNQRUNJRklFRBAAEhkKFVJFVklFV1'
    '9TVEFUVVNfUEVORElORxABEhoKFlJFVklFV19TVEFUVVNfQVBQUk9WRUQQAhIaChZSRVZJRVdf'
    'U1RBVFVTX1JFSkVDVEVEEAMSGAoUUkVWSUVXX1NUQVRVU19ISURERU4QBA==');

@$core.Deprecated('Use discountTypeDescriptor instead')
const DiscountType$json = {
  '1': 'DiscountType',
  '2': [
    {'1': 'DISCOUNT_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'DISCOUNT_TYPE_PERCENTAGE', '2': 1},
    {'1': 'DISCOUNT_TYPE_FIXED_AMOUNT', '2': 2},
    {'1': 'DISCOUNT_TYPE_FREE_SHIPPING', '2': 3},
  ],
};

/// Descriptor for `DiscountType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List discountTypeDescriptor = $convert.base64Decode(
    'CgxEaXNjb3VudFR5cGUSHQoZRElTQ09VTlRfVFlQRV9VTlNQRUNJRklFRBAAEhwKGERJU0NPVU'
    '5UX1RZUEVfUEVSQ0VOVEFHRRABEh4KGkRJU0NPVU5UX1RZUEVfRklYRURfQU1PVU5UEAISHwob'
    'RElTQ09VTlRfVFlQRV9GUkVFX1NISVBQSU5HEAM=');

@$core.Deprecated('Use reportReasonDescriptor instead')
const ReportReason$json = {
  '1': 'ReportReason',
  '2': [
    {'1': 'REPORT_REASON_UNSPECIFIED', '2': 0},
    {'1': 'REPORT_REASON_SPAM', '2': 1},
    {'1': 'REPORT_REASON_INAPPROPRIATE', '2': 2},
    {'1': 'REPORT_REASON_FAKE', '2': 3},
    {'1': 'REPORT_REASON_OFFENSIVE', '2': 4},
    {'1': 'REPORT_REASON_IRRELEVANT', '2': 5},
    {'1': 'REPORT_REASON_OTHER', '2': 6},
  ],
};

/// Descriptor for `ReportReason`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List reportReasonDescriptor = $convert.base64Decode(
    'CgxSZXBvcnRSZWFzb24SHQoZUkVQT1JUX1JFQVNPTl9VTlNQRUNJRklFRBAAEhYKElJFUE9SVF'
    '9SRUFTT05fU1BBTRABEh8KG1JFUE9SVF9SRUFTT05fSU5BUFBST1BSSUFURRACEhYKElJFUE9S'
    'VF9SRUFTT05fRkFLRRADEhsKF1JFUE9SVF9SRUFTT05fT0ZGRU5TSVZFEAQSHAoYUkVQT1JUX1'
    'JFQVNPTl9JUlJFTEVWQU5UEAUSFwoTUkVQT1JUX1JFQVNPTl9PVEhFUhAG');

@$core.Deprecated('Use reportStatusDescriptor instead')
const ReportStatus$json = {
  '1': 'ReportStatus',
  '2': [
    {'1': 'REPORT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'REPORT_STATUS_PENDING', '2': 1},
    {'1': 'REPORT_STATUS_REVIEWED', '2': 2},
    {'1': 'REPORT_STATUS_RESOLVED', '2': 3},
    {'1': 'REPORT_STATUS_DISMISSED', '2': 4},
  ],
};

/// Descriptor for `ReportStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List reportStatusDescriptor = $convert.base64Decode(
    'CgxSZXBvcnRTdGF0dXMSHQoZUkVQT1JUX1NUQVRVU19VTlNQRUNJRklFRBAAEhkKFVJFUE9SVF'
    '9TVEFUVVNfUEVORElORxABEhoKFlJFUE9SVF9TVEFUVVNfUkVWSUVXRUQQAhIaChZSRVBPUlRf'
    'U1RBVFVTX1JFU09MVkVEEAMSGwoXUkVQT1JUX1NUQVRVU19ESVNNSVNTRUQQBA==');

@$core.Deprecated('Use searchTypeDescriptor instead')
const SearchType$json = {
  '1': 'SearchType',
  '2': [
    {'1': 'SEARCH_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'SEARCH_TYPE_CATALOG', '2': 1},
    {'1': 'SEARCH_TYPE_PACKAGE', '2': 2},
    {'1': 'SEARCH_TYPE_BOTH', '2': 3},
  ],
};

/// Descriptor for `SearchType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List searchTypeDescriptor = $convert.base64Decode(
    'CgpTZWFyY2hUeXBlEhsKF1NFQVJDSF9UWVBFX1VOU1BFQ0lGSUVEEAASFwoTU0VBUkNIX1RZUE'
    'VfQ0FUQUxPRxABEhcKE1NFQVJDSF9UWVBFX1BBQ0tBR0UQAhIUChBTRUFSQ0hfVFlQRV9CT1RI'
    'EAM=');

@$core.Deprecated('Use wishlistActionTypeDescriptor instead')
const WishlistActionType$json = {
  '1': 'WishlistActionType',
  '2': [
    {'1': 'WISHLIST_ACTION_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'WISHLIST_ACTION_TYPE_ADDED', '2': 1},
    {'1': 'WISHLIST_ACTION_TYPE_REMOVED', '2': 2},
  ],
};

/// Descriptor for `WishlistActionType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List wishlistActionTypeDescriptor = $convert.base64Decode(
    'ChJXaXNobGlzdEFjdGlvblR5cGUSJAogV0lTSExJU1RfQUNUSU9OX1RZUEVfVU5TUEVDSUZJRU'
    'QQABIeChpXSVNITElTVF9BQ1RJT05fVFlQRV9BRERFRBABEiAKHFdJU0hMSVNUX0FDVElPTl9U'
    'WVBFX1JFTU9WRUQQAg==');

@$core.Deprecated('Use searchSuggestionTypeDescriptor instead')
const SearchSuggestionType$json = {
  '1': 'SearchSuggestionType',
  '2': [
    {'1': 'SEARCH_SUGGESTION_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'SEARCH_SUGGESTION_TYPE_CATALOG', '2': 1},
    {'1': 'SEARCH_SUGGESTION_TYPE_PACKAGE', '2': 2},
    {'1': 'SEARCH_SUGGESTION_TYPE_CATEGORY', '2': 3},
    {'1': 'SEARCH_SUGGESTION_TYPE_KEYWORD', '2': 4},
  ],
};

/// Descriptor for `SearchSuggestionType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List searchSuggestionTypeDescriptor = $convert.base64Decode(
    'ChRTZWFyY2hTdWdnZXN0aW9uVHlwZRImCiJTRUFSQ0hfU1VHR0VTVElPTl9UWVBFX1VOU1BFQ0'
    'lGSUVEEAASIgoeU0VBUkNIX1NVR0dFU1RJT05fVFlQRV9DQVRBTE9HEAESIgoeU0VBUkNIX1NV'
    'R0dFU1RJT05fVFlQRV9QQUNLQUdFEAISIwofU0VBUkNIX1NVR0dFU1RJT05fVFlQRV9DQVRFR0'
    '9SWRADEiIKHlNFQVJDSF9TVUdHRVNUSU9OX1RZUEVfS0VZV09SRBAE');

@$core.Deprecated('Use refundStatusDescriptor instead')
const RefundStatus$json = {
  '1': 'RefundStatus',
  '2': [
    {'1': 'REFUND_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'REFUND_STATUS_PENDING', '2': 1},
    {'1': 'REFUND_STATUS_APPROVED', '2': 2},
    {'1': 'REFUND_STATUS_REJECTED', '2': 3},
    {'1': 'REFUND_STATUS_PROCESSED', '2': 4},
  ],
};

/// Descriptor for `RefundStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List refundStatusDescriptor = $convert.base64Decode(
    'CgxSZWZ1bmRTdGF0dXMSHQoZUkVGVU5EX1NUQVRVU19VTlNQRUNJRklFRBAAEhkKFVJFRlVORF'
    '9TVEFUVVNfUEVORElORxABEhoKFlJFRlVORF9TVEFUVVNfQVBQUk9WRUQQAhIaChZSRUZVTkRf'
    'U1RBVFVTX1JFSkVDVEVEEAMSGwoXUkVGVU5EX1NUQVRVU19QUk9DRVNTRUQQBA==');

@$core.Deprecated('Use paginationRequestDescriptor instead')
const PaginationRequest$json = {
  '1': 'PaginationRequest',
  '2': [
    {'1': 'page', '3': 1, '4': 1, '5': 5, '10': 'page'},
    {'1': 'per_page', '3': 2, '4': 1, '5': 5, '10': 'perPage'},
  ],
};

/// Descriptor for `PaginationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paginationRequestDescriptor = $convert.base64Decode(
    'ChFQYWdpbmF0aW9uUmVxdWVzdBISCgRwYWdlGAEgASgFUgRwYWdlEhkKCHBlcl9wYWdlGAIgAS'
    'gFUgdwZXJQYWdl');

@$core.Deprecated('Use paginationResponseDescriptor instead')
const PaginationResponse$json = {
  '1': 'PaginationResponse',
  '2': [
    {'1': 'current_page', '3': 1, '4': 1, '5': 5, '10': 'currentPage'},
    {'1': 'last_page', '3': 2, '4': 1, '5': 5, '10': 'lastPage'},
    {'1': 'per_page', '3': 3, '4': 1, '5': 5, '10': 'perPage'},
    {'1': 'total', '3': 4, '4': 1, '5': 5, '10': 'total'},
    {'1': 'has_more_pages', '3': 5, '4': 1, '5': 8, '10': 'hasMorePages'},
  ],
};

/// Descriptor for `PaginationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paginationResponseDescriptor = $convert.base64Decode(
    'ChJQYWdpbmF0aW9uUmVzcG9uc2USIQoMY3VycmVudF9wYWdlGAEgASgFUgtjdXJyZW50UGFnZR'
    'IbCglsYXN0X3BhZ2UYAiABKAVSCGxhc3RQYWdlEhkKCHBlcl9wYWdlGAMgASgFUgdwZXJQYWdl'
    'EhQKBXRvdGFsGAQgASgFUgV0b3RhbBIkCg5oYXNfbW9yZV9wYWdlcxgFIAEoCFIMaGFzTW9yZV'
    'BhZ2Vz');

@$core.Deprecated('Use dateRangeDescriptor instead')
const DateRange$json = {
  '1': 'DateRange',
  '2': [
    {'1': 'from', '3': 1, '4': 1, '5': 9, '10': 'from'},
    {'1': 'to', '3': 2, '4': 1, '5': 9, '10': 'to'},
  ],
};

/// Descriptor for `DateRange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dateRangeDescriptor = $convert.base64Decode(
    'CglEYXRlUmFuZ2USEgoEZnJvbRgBIAEoCVIEZnJvbRIOCgJ0bxgCIAEoCVICdG8=');

@$core.Deprecated('Use priceRangeDescriptor instead')
const PriceRange$json = {
  '1': 'PriceRange',
  '2': [
    {'1': 'min', '3': 1, '4': 1, '5': 1, '10': 'min'},
    {'1': 'max', '3': 2, '4': 1, '5': 1, '10': 'max'},
  ],
};

/// Descriptor for `PriceRange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List priceRangeDescriptor = $convert.base64Decode(
    'CgpQcmljZVJhbmdlEhAKA21pbhgBIAEoAVIDbWluEhAKA21heBgCIAEoAVIDbWF4');

@$core.Deprecated('Use capacityRangeDescriptor instead')
const CapacityRange$json = {
  '1': 'CapacityRange',
  '2': [
    {'1': 'min', '3': 1, '4': 1, '5': 5, '10': 'min'},
    {'1': 'max', '3': 2, '4': 1, '5': 5, '10': 'max'},
  ],
};

/// Descriptor for `CapacityRange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List capacityRangeDescriptor = $convert.base64Decode(
    'Cg1DYXBhY2l0eVJhbmdlEhAKA21pbhgBIAEoBVIDbWluEhAKA21heBgCIAEoBVIDbWF4');

@$core.Deprecated('Use imageInfoDescriptor instead')
const ImageInfo$json = {
  '1': 'ImageInfo',
  '2': [
    {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
    {'1': 'alt', '3': 2, '4': 1, '5': 9, '10': 'alt'},
    {'1': 'sort_order', '3': 3, '4': 1, '5': 5, '10': 'sortOrder'},
  ],
};

/// Descriptor for `ImageInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List imageInfoDescriptor = $convert.base64Decode(
    'CglJbWFnZUluZm8SEAoDdXJsGAEgASgJUgN1cmwSEAoDYWx0GAIgASgJUgNhbHQSHQoKc29ydF'
    '9vcmRlchgDIAEoBVIJc29ydE9yZGVy');

@$core.Deprecated('Use metaDataDescriptor instead')
const MetaData$json = {
  '1': 'MetaData',
  '2': [
    {
      '1': 'data',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.MetaData.DataEntry',
      '10': 'data'
    },
  ],
  '3': [MetaData_DataEntry$json],
};

@$core.Deprecated('Use metaDataDescriptor instead')
const MetaData_DataEntry$json = {
  '1': 'DataEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `MetaData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List metaDataDescriptor = $convert.base64Decode(
    'CghNZXRhRGF0YRI3CgRkYXRhGAEgAygLMiMud2VkZGluZy51c2VyLnYxLk1ldGFEYXRhLkRhdG'
    'FFbnRyeVIEZGF0YRo3CglEYXRhRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiAB'
    'KAlSBXZhbHVlOgI4AQ==');
