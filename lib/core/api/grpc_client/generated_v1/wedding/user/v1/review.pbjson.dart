// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/review.proto.

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

@$core.Deprecated('Use getCatalogReviewsRequestDescriptor instead')
const GetCatalogReviewsRequest$json = {
  '1': 'GetCatalogReviewsRequest',
  '2': [
    {'1': 'catalog_id', '3': 1, '4': 1, '5': 9, '10': 'catalogId'},
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.PaginationRequest',
      '10': 'pagination'
    },
    {'1': 'rating', '3': 3, '4': 1, '5': 5, '10': 'rating'},
  ],
};

/// Descriptor for `GetCatalogReviewsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCatalogReviewsRequestDescriptor = $convert.base64Decode(
    'ChhHZXRDYXRhbG9nUmV2aWV3c1JlcXVlc3QSHQoKY2F0YWxvZ19pZBgBIAEoCVIJY2F0YWxvZ0'
    'lkEkIKCnBhZ2luYXRpb24YAiABKAsyIi53ZWRkaW5nLnVzZXIudjEuUGFnaW5hdGlvblJlcXVl'
    'c3RSCnBhZ2luYXRpb24SFgoGcmF0aW5nGAMgASgFUgZyYXRpbmc=');

@$core.Deprecated('Use getPackageReviewsRequestDescriptor instead')
const GetPackageReviewsRequest$json = {
  '1': 'GetPackageReviewsRequest',
  '2': [
    {'1': 'package_id', '3': 1, '4': 1, '5': 9, '10': 'packageId'},
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.PaginationRequest',
      '10': 'pagination'
    },
    {'1': 'rating', '3': 3, '4': 1, '5': 5, '10': 'rating'},
  ],
};

/// Descriptor for `GetPackageReviewsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPackageReviewsRequestDescriptor = $convert.base64Decode(
    'ChhHZXRQYWNrYWdlUmV2aWV3c1JlcXVlc3QSHQoKcGFja2FnZV9pZBgBIAEoCVIJcGFja2FnZU'
    'lkEkIKCnBhZ2luYXRpb24YAiABKAsyIi53ZWRkaW5nLnVzZXIudjEuUGFnaW5hdGlvblJlcXVl'
    'c3RSCnBhZ2luYXRpb24SFgoGcmF0aW5nGAMgASgFUgZyYXRpbmc=');

@$core.Deprecated('Use getMyReviewsRequestDescriptor instead')
const GetMyReviewsRequest$json = {
  '1': 'GetMyReviewsRequest',
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

/// Descriptor for `GetMyReviewsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMyReviewsRequestDescriptor = $convert.base64Decode(
    'ChNHZXRNeVJldmlld3NSZXF1ZXN0EkIKCnBhZ2luYXRpb24YASABKAsyIi53ZWRkaW5nLnVzZX'
    'IudjEuUGFnaW5hdGlvblJlcXVlc3RSCnBhZ2luYXRpb24=');

@$core.Deprecated('Use getReviewRequestDescriptor instead')
const GetReviewRequest$json = {
  '1': 'GetReviewRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `GetReviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReviewRequestDescriptor =
    $convert.base64Decode('ChBHZXRSZXZpZXdSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZA==');

@$core.Deprecated('Use getReviewStatsRequestDescriptor instead')
const GetReviewStatsRequest$json = {
  '1': 'GetReviewStatsRequest',
  '2': [
    {'1': 'catalog_id', '3': 1, '4': 1, '5': 9, '10': 'catalogId'},
    {'1': 'package_id', '3': 2, '4': 1, '5': 9, '10': 'packageId'},
  ],
};

/// Descriptor for `GetReviewStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReviewStatsRequestDescriptor = $convert.base64Decode(
    'ChVHZXRSZXZpZXdTdGF0c1JlcXVlc3QSHQoKY2F0YWxvZ19pZBgBIAEoCVIJY2F0YWxvZ0lkEh'
    '0KCnBhY2thZ2VfaWQYAiABKAlSCXBhY2thZ2VJZA==');

@$core.Deprecated('Use getFeaturedReviewsRequestDescriptor instead')
const GetFeaturedReviewsRequest$json = {
  '1': 'GetFeaturedReviewsRequest',
  '2': [
    {'1': 'limit', '3': 1, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `GetFeaturedReviewsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFeaturedReviewsRequestDescriptor =
    $convert.base64Decode(
        'ChlHZXRGZWF0dXJlZFJldmlld3NSZXF1ZXN0EhQKBWxpbWl0GAEgASgFUgVsaW1pdA==');

@$core.Deprecated('Use getAllReviewsRequestDescriptor instead')
const GetAllReviewsRequest$json = {
  '1': 'GetAllReviewsRequest',
  '2': [
    {
      '1': 'pagination',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.PaginationRequest',
      '10': 'pagination'
    },
    {'1': 'status', '3': 2, '4': 1, '5': 9, '10': 'status'},
    {'1': 'rating', '3': 3, '4': 1, '5': 5, '10': 'rating'},
  ],
};

/// Descriptor for `GetAllReviewsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAllReviewsRequestDescriptor = $convert.base64Decode(
    'ChRHZXRBbGxSZXZpZXdzUmVxdWVzdBJCCgpwYWdpbmF0aW9uGAEgASgLMiIud2VkZGluZy51c2'
    'VyLnYxLlBhZ2luYXRpb25SZXF1ZXN0UgpwYWdpbmF0aW9uEhYKBnN0YXR1cxgCIAEoCVIGc3Rh'
    'dHVzEhYKBnJhdGluZxgDIAEoBVIGcmF0aW5n');

@$core.Deprecated('Use createReviewRequestDescriptor instead')
const CreateReviewRequest$json = {
  '1': 'CreateReviewRequest',
  '2': [
    {'1': 'catalog_id', '3': 1, '4': 1, '5': 9, '10': 'catalogId'},
    {'1': 'package_id', '3': 2, '4': 1, '5': 9, '10': 'packageId'},
    {'1': 'order_id', '3': 3, '4': 1, '5': 9, '10': 'orderId'},
    {'1': 'rating', '3': 4, '4': 1, '5': 5, '10': 'rating'},
    {'1': 'title', '3': 5, '4': 1, '5': 9, '10': 'title'},
    {'1': 'comment', '3': 6, '4': 1, '5': 9, '10': 'comment'},
    {'1': 'photos', '3': 7, '4': 3, '5': 9, '10': 'photos'},
    {'1': 'is_anonymous', '3': 8, '4': 1, '5': 8, '10': 'isAnonymous'},
  ],
};

/// Descriptor for `CreateReviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createReviewRequestDescriptor = $convert.base64Decode(
    'ChNDcmVhdGVSZXZpZXdSZXF1ZXN0Eh0KCmNhdGFsb2dfaWQYASABKAlSCWNhdGFsb2dJZBIdCg'
    'pwYWNrYWdlX2lkGAIgASgJUglwYWNrYWdlSWQSGQoIb3JkZXJfaWQYAyABKAlSB29yZGVySWQS'
    'FgoGcmF0aW5nGAQgASgFUgZyYXRpbmcSFAoFdGl0bGUYBSABKAlSBXRpdGxlEhgKB2NvbW1lbn'
    'QYBiABKAlSB2NvbW1lbnQSFgoGcGhvdG9zGAcgAygJUgZwaG90b3MSIQoMaXNfYW5vbnltb3Vz'
    'GAggASgIUgtpc0Fub255bW91cw==');

@$core.Deprecated('Use updateReviewRequestDescriptor instead')
const UpdateReviewRequest$json = {
  '1': 'UpdateReviewRequest',
  '2': [
    {'1': 'review_id', '3': 1, '4': 1, '5': 9, '10': 'reviewId'},
    {'1': 'rating', '3': 2, '4': 1, '5': 5, '10': 'rating'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'comment', '3': 4, '4': 1, '5': 9, '10': 'comment'},
    {'1': 'photos', '3': 5, '4': 3, '5': 9, '10': 'photos'},
    {'1': 'is_anonymous', '3': 6, '4': 1, '5': 8, '10': 'isAnonymous'},
  ],
};

/// Descriptor for `UpdateReviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateReviewRequestDescriptor = $convert.base64Decode(
    'ChNVcGRhdGVSZXZpZXdSZXF1ZXN0EhsKCXJldmlld19pZBgBIAEoCVIIcmV2aWV3SWQSFgoGcm'
    'F0aW5nGAIgASgFUgZyYXRpbmcSFAoFdGl0bGUYAyABKAlSBXRpdGxlEhgKB2NvbW1lbnQYBCAB'
    'KAlSB2NvbW1lbnQSFgoGcGhvdG9zGAUgAygJUgZwaG90b3MSIQoMaXNfYW5vbnltb3VzGAYgAS'
    'gIUgtpc0Fub255bW91cw==');

@$core.Deprecated('Use deleteReviewRequestDescriptor instead')
const DeleteReviewRequest$json = {
  '1': 'DeleteReviewRequest',
  '2': [
    {'1': 'review_id', '3': 1, '4': 1, '5': 9, '10': 'reviewId'},
  ],
};

/// Descriptor for `DeleteReviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteReviewRequestDescriptor =
    $convert.base64Decode(
        'ChNEZWxldGVSZXZpZXdSZXF1ZXN0EhsKCXJldmlld19pZBgBIAEoCVIIcmV2aWV3SWQ=');

@$core.Deprecated('Use addReviewPhotoRequestDescriptor instead')
const AddReviewPhotoRequest$json = {
  '1': 'AddReviewPhotoRequest',
  '2': [
    {'1': 'review_id', '3': 1, '4': 1, '5': 9, '10': 'reviewId'},
    {'1': 'url', '3': 2, '4': 1, '5': 9, '10': 'url'},
    {'1': 'caption', '3': 3, '4': 1, '5': 9, '10': 'caption'},
  ],
};

/// Descriptor for `AddReviewPhotoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addReviewPhotoRequestDescriptor = $convert.base64Decode(
    'ChVBZGRSZXZpZXdQaG90b1JlcXVlc3QSGwoJcmV2aWV3X2lkGAEgASgJUghyZXZpZXdJZBIQCg'
    'N1cmwYAiABKAlSA3VybBIYCgdjYXB0aW9uGAMgASgJUgdjYXB0aW9u');

@$core.Deprecated('Use removeReviewPhotoRequestDescriptor instead')
const RemoveReviewPhotoRequest$json = {
  '1': 'RemoveReviewPhotoRequest',
  '2': [
    {'1': 'review_id', '3': 1, '4': 1, '5': 9, '10': 'reviewId'},
    {'1': 'photo_url', '3': 2, '4': 1, '5': 9, '10': 'photoUrl'},
  ],
};

/// Descriptor for `RemoveReviewPhotoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeReviewPhotoRequestDescriptor =
    $convert.base64Decode(
        'ChhSZW1vdmVSZXZpZXdQaG90b1JlcXVlc3QSGwoJcmV2aWV3X2lkGAEgASgJUghyZXZpZXdJZB'
        'IbCglwaG90b191cmwYAiABKAlSCHBob3RvVXJs');

@$core.Deprecated('Use markReviewHelpfulRequestDescriptor instead')
const MarkReviewHelpfulRequest$json = {
  '1': 'MarkReviewHelpfulRequest',
  '2': [
    {'1': 'review_id', '3': 1, '4': 1, '5': 9, '10': 'reviewId'},
  ],
};

/// Descriptor for `MarkReviewHelpfulRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markReviewHelpfulRequestDescriptor =
    $convert.base64Decode(
        'ChhNYXJrUmV2aWV3SGVscGZ1bFJlcXVlc3QSGwoJcmV2aWV3X2lkGAEgASgJUghyZXZpZXdJZA'
        '==');

@$core.Deprecated('Use unmarkReviewHelpfulRequestDescriptor instead')
const UnmarkReviewHelpfulRequest$json = {
  '1': 'UnmarkReviewHelpfulRequest',
  '2': [
    {'1': 'review_id', '3': 1, '4': 1, '5': 9, '10': 'reviewId'},
  ],
};

/// Descriptor for `UnmarkReviewHelpfulRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unmarkReviewHelpfulRequestDescriptor =
    $convert.base64Decode(
        'ChpVbm1hcmtSZXZpZXdIZWxwZnVsUmVxdWVzdBIbCglyZXZpZXdfaWQYASABKAlSCHJldmlld0'
        'lk');

@$core.Deprecated('Use moderateReviewRequestDescriptor instead')
const ModerateReviewRequest$json = {
  '1': 'ModerateReviewRequest',
  '2': [
    {'1': 'review_id', '3': 1, '4': 1, '5': 9, '10': 'reviewId'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.wedding.user.v1.ReviewStatus',
      '10': 'status'
    },
    {'1': 'moderation_note', '3': 3, '4': 1, '5': 9, '10': 'moderationNote'},
  ],
};

/// Descriptor for `ModerateReviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moderateReviewRequestDescriptor = $convert.base64Decode(
    'ChVNb2RlcmF0ZVJldmlld1JlcXVlc3QSGwoJcmV2aWV3X2lkGAEgASgJUghyZXZpZXdJZBI1Cg'
    'ZzdGF0dXMYAiABKA4yHS53ZWRkaW5nLnVzZXIudjEuUmV2aWV3U3RhdHVzUgZzdGF0dXMSJwoP'
    'bW9kZXJhdGlvbl9ub3RlGAMgASgJUg5tb2RlcmF0aW9uTm90ZQ==');

@$core.Deprecated('Use replyToReviewRequestDescriptor instead')
const ReplyToReviewRequest$json = {
  '1': 'ReplyToReviewRequest',
  '2': [
    {'1': 'review_id', '3': 1, '4': 1, '5': 9, '10': 'reviewId'},
    {'1': 'reply', '3': 2, '4': 1, '5': 9, '10': 'reply'},
  ],
};

/// Descriptor for `ReplyToReviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List replyToReviewRequestDescriptor = $convert.base64Decode(
    'ChRSZXBseVRvUmV2aWV3UmVxdWVzdBIbCglyZXZpZXdfaWQYASABKAlSCHJldmlld0lkEhQKBX'
    'JlcGx5GAIgASgJUgVyZXBseQ==');

@$core.Deprecated('Use reportReviewRequestDescriptor instead')
const ReportReviewRequest$json = {
  '1': 'ReportReviewRequest',
  '2': [
    {'1': 'review_id', '3': 1, '4': 1, '5': 9, '10': 'reviewId'},
    {
      '1': 'reason',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.wedding.user.v1.ReportReason',
      '10': 'reason'
    },
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
  ],
};

/// Descriptor for `ReportReviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportReviewRequestDescriptor = $convert.base64Decode(
    'ChNSZXBvcnRSZXZpZXdSZXF1ZXN0EhsKCXJldmlld19pZBgBIAEoCVIIcmV2aWV3SWQSNQoGcm'
    'Vhc29uGAIgASgOMh0ud2VkZGluZy51c2VyLnYxLlJlcG9ydFJlYXNvblIGcmVhc29uEiAKC2Rl'
    'c2NyaXB0aW9uGAMgASgJUgtkZXNjcmlwdGlvbg==');

@$core.Deprecated('Use reviewListResponseDescriptor instead')
const ReviewListResponse$json = {
  '1': 'ReviewListResponse',
  '2': [
    {
      '1': 'reviews',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.Review',
      '10': 'reviews'
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

/// Descriptor for `ReviewListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reviewListResponseDescriptor = $convert.base64Decode(
    'ChJSZXZpZXdMaXN0UmVzcG9uc2USMQoHcmV2aWV3cxgBIAMoCzIXLndlZGRpbmcudXNlci52MS'
    '5SZXZpZXdSB3Jldmlld3MSQwoKcGFnaW5hdGlvbhgCIAEoCzIjLndlZGRpbmcudXNlci52MS5Q'
    'YWdpbmF0aW9uUmVzcG9uc2VSCnBhZ2luYXRpb24=');

@$core.Deprecated('Use reviewStatsDescriptor instead')
const ReviewStats$json = {
  '1': 'ReviewStats',
  '2': [
    {'1': 'total_reviews', '3': 1, '4': 1, '5': 5, '10': 'totalReviews'},
    {'1': 'average_rating', '3': 2, '4': 1, '5': 1, '10': 'averageRating'},
    {
      '1': 'rating_distribution',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.RatingCount',
      '10': 'ratingDistribution'
    },
    {'1': 'with_photos', '3': 4, '4': 1, '5': 5, '10': 'withPhotos'},
    {
      '1': 'verified_purchases',
      '3': 5,
      '4': 1,
      '5': 5,
      '10': 'verifiedPurchases'
    },
  ],
};

/// Descriptor for `ReviewStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reviewStatsDescriptor = $convert.base64Decode(
    'CgtSZXZpZXdTdGF0cxIjCg10b3RhbF9yZXZpZXdzGAEgASgFUgx0b3RhbFJldmlld3MSJQoOYX'
    'ZlcmFnZV9yYXRpbmcYAiABKAFSDWF2ZXJhZ2VSYXRpbmcSTQoTcmF0aW5nX2Rpc3RyaWJ1dGlv'
    'bhgDIAMoCzIcLndlZGRpbmcudXNlci52MS5SYXRpbmdDb3VudFIScmF0aW5nRGlzdHJpYnV0aW'
    '9uEh8KC3dpdGhfcGhvdG9zGAQgASgFUgp3aXRoUGhvdG9zEi0KEnZlcmlmaWVkX3B1cmNoYXNl'
    'cxgFIAEoBVIRdmVyaWZpZWRQdXJjaGFzZXM=');

@$core.Deprecated('Use ratingCountDescriptor instead')
const RatingCount$json = {
  '1': 'RatingCount',
  '2': [
    {'1': 'rating', '3': 1, '4': 1, '5': 5, '10': 'rating'},
    {'1': 'count', '3': 2, '4': 1, '5': 5, '10': 'count'},
    {'1': 'percentage', '3': 3, '4': 1, '5': 1, '10': 'percentage'},
  ],
};

/// Descriptor for `RatingCount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ratingCountDescriptor = $convert.base64Decode(
    'CgtSYXRpbmdDb3VudBIWCgZyYXRpbmcYASABKAVSBnJhdGluZxIUCgVjb3VudBgCIAEoBVIFY2'
    '91bnQSHgoKcGVyY2VudGFnZRgDIAEoAVIKcGVyY2VudGFnZQ==');

@$core.Deprecated('Use reviewReportDescriptor instead')
const ReviewReport$json = {
  '1': 'ReviewReport',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {
      '1': 'review',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.Review',
      '10': 'review'
    },
    {
      '1': 'reporter',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.User',
      '10': 'reporter'
    },
    {
      '1': 'reason',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.wedding.user.v1.ReportReason',
      '10': 'reason'
    },
    {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'status',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.wedding.user.v1.ReportStatus',
      '10': 'status'
    },
    {'1': 'created_at', '3': 7, '4': 1, '5': 9, '10': 'createdAt'},
    {'1': 'reviewed_at', '3': 8, '4': 1, '5': 9, '10': 'reviewedAt'},
    {
      '1': 'reviewed_by',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.User',
      '10': 'reviewedBy'
    },
  ],
};

/// Descriptor for `ReviewReport`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reviewReportDescriptor = $convert.base64Decode(
    'CgxSZXZpZXdSZXBvcnQSDgoCaWQYASABKAlSAmlkEi8KBnJldmlldxgCIAEoCzIXLndlZGRpbm'
    'cudXNlci52MS5SZXZpZXdSBnJldmlldxIxCghyZXBvcnRlchgDIAEoCzIVLndlZGRpbmcudXNl'
    'ci52MS5Vc2VyUghyZXBvcnRlchI1CgZyZWFzb24YBCABKA4yHS53ZWRkaW5nLnVzZXIudjEuUm'
    'Vwb3J0UmVhc29uUgZyZWFzb24SIAoLZGVzY3JpcHRpb24YBSABKAlSC2Rlc2NyaXB0aW9uEjUK'
    'BnN0YXR1cxgGIAEoDjIdLndlZGRpbmcudXNlci52MS5SZXBvcnRTdGF0dXNSBnN0YXR1cxIdCg'
    'pjcmVhdGVkX2F0GAcgASgJUgljcmVhdGVkQXQSHwoLcmV2aWV3ZWRfYXQYCCABKAlSCnJldmll'
    'd2VkQXQSNgoLcmV2aWV3ZWRfYnkYCSABKAsyFS53ZWRkaW5nLnVzZXIudjEuVXNlclIKcmV2aW'
    'V3ZWRCeQ==');

@$core.Deprecated('Use deleteReviewResponseDescriptor instead')
const DeleteReviewResponse$json = {
  '1': 'DeleteReviewResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `DeleteReviewResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteReviewResponseDescriptor = $convert.base64Decode(
    'ChREZWxldGVSZXZpZXdSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEhgKB21lc3'
    'NhZ2UYAiABKAlSB21lc3NhZ2U=');
