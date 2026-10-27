// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/cbir.proto.

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

@$core.Deprecated('Use searchSimilarRequestDescriptor instead')
const SearchSimilarRequest$json = {
  '1': 'SearchSimilarRequest',
  '2': [
    {'1': 'image', '3': 1, '4': 1, '5': 12, '10': 'image'},
    {'1': 'mime_type', '3': 2, '4': 1, '5': 9, '10': 'mimeType'},
  ],
};

/// Descriptor for `SearchSimilarRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchSimilarRequestDescriptor = $convert.base64Decode(
    'ChRTZWFyY2hTaW1pbGFyUmVxdWVzdBIUCgVpbWFnZRgBIAEoDFIFaW1hZ2USGwoJbWltZV90eX'
    'BlGAIgASgJUghtaW1lVHlwZQ==');

@$core.Deprecated('Use searchSimilarChunkRequestDescriptor instead')
const SearchSimilarChunkRequest$json = {
  '1': 'SearchSimilarChunkRequest',
  '2': [
    {'1': 'chunk', '3': 1, '4': 1, '5': 12, '10': 'chunk'},
    {'1': 'chunk_index', '3': 2, '4': 1, '5': 5, '10': 'chunkIndex'},
    {'1': 'total_chunks', '3': 3, '4': 1, '5': 5, '10': 'totalChunks'},
    {'1': 'mime_type', '3': 4, '4': 1, '5': 9, '10': 'mimeType'},
  ],
};

/// Descriptor for `SearchSimilarChunkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchSimilarChunkRequestDescriptor = $convert.base64Decode(
    'ChlTZWFyY2hTaW1pbGFyQ2h1bmtSZXF1ZXN0EhQKBWNodW5rGAEgASgMUgVjaHVuaxIfCgtjaH'
    'Vua19pbmRleBgCIAEoBVIKY2h1bmtJbmRleBIhCgx0b3RhbF9jaHVua3MYAyABKAVSC3RvdGFs'
    'Q2h1bmtzEhsKCW1pbWVfdHlwZRgEIAEoCVIIbWltZVR5cGU=');

@$core.Deprecated('Use cbirSearchResponseDescriptor instead')
const CbirSearchResponse$json = {
  '1': 'CbirSearchResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {
      '1': 'results',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.CbirResult',
      '10': 'results'
    },
    {'1': 'total_results', '3': 4, '4': 1, '5': 5, '10': 'totalResults'},
    {
      '1': 'query_time_seconds',
      '3': 5,
      '4': 1,
      '5': 1,
      '10': 'queryTimeSeconds'
    },
  ],
};

/// Descriptor for `CbirSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cbirSearchResponseDescriptor = $convert.base64Decode(
    'ChJDYmlyU2VhcmNoUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIYCgdtZXNzYW'
    'dlGAIgASgJUgdtZXNzYWdlEjUKB3Jlc3VsdHMYAyADKAsyGy53ZWRkaW5nLnVzZXIudjEuQ2Jp'
    'clJlc3VsdFIHcmVzdWx0cxIjCg10b3RhbF9yZXN1bHRzGAQgASgFUgx0b3RhbFJlc3VsdHMSLA'
    'oScXVlcnlfdGltZV9zZWNvbmRzGAUgASgBUhBxdWVyeVRpbWVTZWNvbmRz');

@$core.Deprecated('Use arithmeticSearchRequestDescriptor instead')
const ArithmeticSearchRequest$json = {
  '1': 'ArithmeticSearchRequest',
  '2': [
    {'1': 'image_1', '3': 1, '4': 1, '5': 12, '10': 'image1'},
    {'1': 'mime_type_1', '3': 2, '4': 1, '5': 9, '10': 'mimeType1'},
    {'1': 'image_2', '3': 3, '4': 1, '5': 12, '10': 'image2'},
    {'1': 'mime_type_2', '3': 4, '4': 1, '5': 9, '10': 'mimeType2'},
    {'1': 'operation', '3': 5, '4': 1, '5': 9, '10': 'operation'},
    {'1': 'weights', '3': 6, '4': 3, '5': 1, '10': 'weights'},
  ],
};

/// Descriptor for `ArithmeticSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List arithmeticSearchRequestDescriptor = $convert.base64Decode(
    'ChdBcml0aG1ldGljU2VhcmNoUmVxdWVzdBIXCgdpbWFnZV8xGAEgASgMUgZpbWFnZTESHgoLbW'
    'ltZV90eXBlXzEYAiABKAlSCW1pbWVUeXBlMRIXCgdpbWFnZV8yGAMgASgMUgZpbWFnZTISHgoL'
    'bWltZV90eXBlXzIYBCABKAlSCW1pbWVUeXBlMhIcCglvcGVyYXRpb24YBSABKAlSCW9wZXJhdG'
    'lvbhIYCgd3ZWlnaHRzGAYgAygBUgd3ZWlnaHRz');

@$core.Deprecated('Use getArithmeticOpsRequestDescriptor instead')
const GetArithmeticOpsRequest$json = {
  '1': 'GetArithmeticOpsRequest',
};

/// Descriptor for `GetArithmeticOpsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getArithmeticOpsRequestDescriptor =
    $convert.base64Decode('ChdHZXRBcml0aG1ldGljT3BzUmVxdWVzdA==');

@$core.Deprecated('Use arithmeticOpsResponseDescriptor instead')
const ArithmeticOpsResponse$json = {
  '1': 'ArithmeticOpsResponse',
  '2': [
    {
      '1': 'ops',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.ArithmeticOp',
      '10': 'ops'
    },
  ],
};

/// Descriptor for `ArithmeticOpsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List arithmeticOpsResponseDescriptor = $convert.base64Decode(
    'ChVBcml0aG1ldGljT3BzUmVzcG9uc2USLwoDb3BzGAEgAygLMh0ud2VkZGluZy51c2VyLnYxLk'
    'FyaXRobWV0aWNPcFIDb3Bz');

@$core.Deprecated('Use arithmeticOpDescriptor instead')
const ArithmeticOp$json = {
  '1': 'ArithmeticOp',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    {'1': 'min_images', '3': 3, '4': 1, '5': 5, '10': 'minImages'},
    {'1': 'max_images', '3': 4, '4': 1, '5': 5, '10': 'maxImages'},
    {'1': 'supports_weights', '3': 5, '4': 1, '5': 8, '10': 'supportsWeights'},
  ],
};

/// Descriptor for `ArithmeticOp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List arithmeticOpDescriptor = $convert.base64Decode(
    'CgxBcml0aG1ldGljT3ASEgoEbmFtZRgBIAEoCVIEbmFtZRIgCgtkZXNjcmlwdGlvbhgCIAEoCV'
    'ILZGVzY3JpcHRpb24SHQoKbWluX2ltYWdlcxgDIAEoBVIJbWluSW1hZ2VzEh0KCm1heF9pbWFn'
    'ZXMYBCABKAVSCW1heEltYWdlcxIpChBzdXBwb3J0c193ZWlnaHRzGAUgASgIUg9zdXBwb3J0c1'
    'dlaWdodHM=');

@$core.Deprecated('Use getCbirStatsRequestDescriptor instead')
const GetCbirStatsRequest$json = {
  '1': 'GetCbirStatsRequest',
};

/// Descriptor for `GetCbirStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCbirStatsRequestDescriptor =
    $convert.base64Decode('ChNHZXRDYmlyU3RhdHNSZXF1ZXN0');

@$core.Deprecated('Use cbirStatsDescriptor instead')
const CbirStats$json = {
  '1': 'CbirStats',
  '2': [
    {'1': 'total_images', '3': 1, '4': 1, '5': 5, '10': 'totalImages'},
    {'1': 'total_features', '3': 2, '4': 1, '5': 5, '10': 'totalFeatures'},
    {'1': 'database_size', '3': 3, '4': 1, '5': 9, '10': 'databaseSize'},
    {'1': 'last_updated', '3': 4, '4': 1, '5': 9, '10': 'lastUpdated'},
  ],
};

/// Descriptor for `CbirStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cbirStatsDescriptor = $convert.base64Decode(
    'CglDYmlyU3RhdHMSIQoMdG90YWxfaW1hZ2VzGAEgASgFUgt0b3RhbEltYWdlcxIlCg50b3RhbF'
    '9mZWF0dXJlcxgCIAEoBVINdG90YWxGZWF0dXJlcxIjCg1kYXRhYmFzZV9zaXplGAMgASgJUgxk'
    'YXRhYmFzZVNpemUSIQoMbGFzdF91cGRhdGVkGAQgASgJUgtsYXN0VXBkYXRlZA==');

@$core.Deprecated('Use getCbirHistoryRequestDescriptor instead')
const GetCbirHistoryRequest$json = {
  '1': 'GetCbirHistoryRequest',
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

/// Descriptor for `GetCbirHistoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCbirHistoryRequestDescriptor = $convert.base64Decode(
    'ChVHZXRDYmlySGlzdG9yeVJlcXVlc3QSQgoKcGFnaW5hdGlvbhgBIAEoCzIiLndlZGRpbmcudX'
    'Nlci52MS5QYWdpbmF0aW9uUmVxdWVzdFIKcGFnaW5hdGlvbg==');

@$core.Deprecated('Use cbirHistoryResponseDescriptor instead')
const CbirHistoryResponse$json = {
  '1': 'CbirHistoryResponse',
  '2': [
    {
      '1': 'history',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.CbirHistory',
      '10': 'history'
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

/// Descriptor for `CbirHistoryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cbirHistoryResponseDescriptor = $convert.base64Decode(
    'ChNDYmlySGlzdG9yeVJlc3BvbnNlEjYKB2hpc3RvcnkYASADKAsyHC53ZWRkaW5nLnVzZXIudj'
    'EuQ2Jpckhpc3RvcnlSB2hpc3RvcnkSQwoKcGFnaW5hdGlvbhgCIAEoCzIjLndlZGRpbmcudXNl'
    'ci52MS5QYWdpbmF0aW9uUmVzcG9uc2VSCnBhZ2luYXRpb24=');

@$core.Deprecated('Use cbirHistoryDescriptor instead')
const CbirHistory$json = {
  '1': 'CbirHistory',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'query_image_url', '3': 3, '4': 1, '5': 9, '10': 'queryImageUrl'},
    {
      '1': 'results',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.CbirHistoryResult',
      '10': 'results'
    },
    {'1': 'results_count', '3': 5, '4': 1, '5': 5, '10': 'resultsCount'},
    {'1': 'top_similarity', '3': 6, '4': 1, '5': 1, '10': 'topSimilarity'},
    {'1': 'created_at', '3': 7, '4': 1, '5': 9, '10': 'createdAt'},
  ],
};

/// Descriptor for `CbirHistory`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cbirHistoryDescriptor = $convert.base64Decode(
    'CgtDYmlySGlzdG9yeRIOCgJpZBgBIAEoCVICaWQSFwoHdXNlcl9pZBgCIAEoCVIGdXNlcklkEi'
    'YKD3F1ZXJ5X2ltYWdlX3VybBgDIAEoCVINcXVlcnlJbWFnZVVybBI8CgdyZXN1bHRzGAQgAygL'
    'MiIud2VkZGluZy51c2VyLnYxLkNiaXJIaXN0b3J5UmVzdWx0UgdyZXN1bHRzEiMKDXJlc3VsdH'
    'NfY291bnQYBSABKAVSDHJlc3VsdHNDb3VudBIlCg50b3Bfc2ltaWxhcml0eRgGIAEoAVINdG9w'
    'U2ltaWxhcml0eRIdCgpjcmVhdGVkX2F0GAcgASgJUgljcmVhdGVkQXQ=');

@$core.Deprecated('Use cbirHistoryResultDescriptor instead')
const CbirHistoryResult$json = {
  '1': 'CbirHistoryResult',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 9, '10': 'type'},
    {'1': 'item_id', '3': 2, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'similarity', '3': 3, '4': 1, '5': 1, '10': 'similarity'},
    {'1': 'score', '3': 4, '4': 1, '5': 1, '10': 'score'},
    {
      '1': 'item',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.CbirResultData',
      '10': 'item'
    },
  ],
};

/// Descriptor for `CbirHistoryResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cbirHistoryResultDescriptor = $convert.base64Decode(
    'ChFDYmlySGlzdG9yeVJlc3VsdBISCgR0eXBlGAEgASgJUgR0eXBlEhcKB2l0ZW1faWQYAiABKA'
    'lSBml0ZW1JZBIeCgpzaW1pbGFyaXR5GAMgASgBUgpzaW1pbGFyaXR5EhQKBXNjb3JlGAQgASgB'
    'UgVzY29yZRIzCgRpdGVtGAUgASgLMh8ud2VkZGluZy51c2VyLnYxLkNiaXJSZXN1bHREYXRhUg'
    'RpdGVt');

@$core.Deprecated('Use getSavedCbirResultsRequestDescriptor instead')
const GetSavedCbirResultsRequest$json = {
  '1': 'GetSavedCbirResultsRequest',
  '2': [
    {'1': 'search_id', '3': 1, '4': 1, '5': 9, '10': 'searchId'},
  ],
};

/// Descriptor for `GetSavedCbirResultsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSavedCbirResultsRequestDescriptor =
    $convert.base64Decode(
        'ChpHZXRTYXZlZENiaXJSZXN1bHRzUmVxdWVzdBIbCglzZWFyY2hfaWQYASABKAlSCHNlYXJjaE'
        'lk');

@$core.Deprecated('Use cbirSavedResultsResponseDescriptor instead')
const CbirSavedResultsResponse$json = {
  '1': 'CbirSavedResultsResponse',
  '2': [
    {
      '1': 'results',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.CbirResult',
      '10': 'results'
    },
  ],
};

/// Descriptor for `CbirSavedResultsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cbirSavedResultsResponseDescriptor =
    $convert.base64Decode(
        'ChhDYmlyU2F2ZWRSZXN1bHRzUmVzcG9uc2USNQoHcmVzdWx0cxgBIAMoCzIbLndlZGRpbmcudX'
        'Nlci52MS5DYmlyUmVzdWx0UgdyZXN1bHRz');

@$core.Deprecated('Use saveCbirSearchRequestDescriptor instead')
const SaveCbirSearchRequest$json = {
  '1': 'SaveCbirSearchRequest',
  '2': [
    {'1': 'query_image_url', '3': 1, '4': 1, '5': 9, '10': 'queryImageUrl'},
    {
      '1': 'results',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.CbirSearchResultItemInput',
      '10': 'results'
    },
  ],
};

/// Descriptor for `SaveCbirSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List saveCbirSearchRequestDescriptor = $convert.base64Decode(
    'ChVTYXZlQ2JpclNlYXJjaFJlcXVlc3QSJgoPcXVlcnlfaW1hZ2VfdXJsGAEgASgJUg1xdWVyeU'
    'ltYWdlVXJsEkQKB3Jlc3VsdHMYAiADKAsyKi53ZWRkaW5nLnVzZXIudjEuQ2JpclNlYXJjaFJl'
    'c3VsdEl0ZW1JbnB1dFIHcmVzdWx0cw==');

@$core.Deprecated('Use cbirSearchResultItemInputDescriptor instead')
const CbirSearchResultItemInput$json = {
  '1': 'CbirSearchResultItemInput',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 9, '10': 'type'},
    {'1': 'item_id', '3': 2, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'similarity', '3': 3, '4': 1, '5': 1, '10': 'similarity'},
    {'1': 'score', '3': 4, '4': 1, '5': 1, '10': 'score'},
  ],
};

/// Descriptor for `CbirSearchResultItemInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cbirSearchResultItemInputDescriptor = $convert.base64Decode(
    'ChlDYmlyU2VhcmNoUmVzdWx0SXRlbUlucHV0EhIKBHR5cGUYASABKAlSBHR5cGUSFwoHaXRlbV'
    '9pZBgCIAEoCVIGaXRlbUlkEh4KCnNpbWlsYXJpdHkYAyABKAFSCnNpbWlsYXJpdHkSFAoFc2Nv'
    'cmUYBCABKAFSBXNjb3Jl');

@$core.Deprecated('Use deleteCbirSearchRequestDescriptor instead')
const DeleteCbirSearchRequest$json = {
  '1': 'DeleteCbirSearchRequest',
  '2': [
    {'1': 'search_id', '3': 1, '4': 1, '5': 9, '10': 'searchId'},
  ],
};

/// Descriptor for `DeleteCbirSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteCbirSearchRequestDescriptor =
    $convert.base64Decode(
        'ChdEZWxldGVDYmlyU2VhcmNoUmVxdWVzdBIbCglzZWFyY2hfaWQYASABKAlSCHNlYXJjaElk');

@$core.Deprecated('Use deleteCbirSearchResponseDescriptor instead')
const DeleteCbirSearchResponse$json = {
  '1': 'DeleteCbirSearchResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `DeleteCbirSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteCbirSearchResponseDescriptor =
    $convert.base64Decode(
        'ChhEZWxldGVDYmlyU2VhcmNoUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIYCg'
        'dtZXNzYWdlGAIgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use clearCbirHistoryRequestDescriptor instead')
const ClearCbirHistoryRequest$json = {
  '1': 'ClearCbirHistoryRequest',
};

/// Descriptor for `ClearCbirHistoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clearCbirHistoryRequestDescriptor =
    $convert.base64Decode('ChdDbGVhckNiaXJIaXN0b3J5UmVxdWVzdA==');

@$core.Deprecated('Use clearCbirHistoryResponseDescriptor instead')
const ClearCbirHistoryResponse$json = {
  '1': 'ClearCbirHistoryResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `ClearCbirHistoryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clearCbirHistoryResponseDescriptor =
    $convert.base64Decode(
        'ChhDbGVhckNiaXJIaXN0b3J5UmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIYCg'
        'dtZXNzYWdlGAIgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use submitCbirFeedbackRequestDescriptor instead')
const SubmitCbirFeedbackRequest$json = {
  '1': 'SubmitCbirFeedbackRequest',
  '2': [
    {'1': 'search_id', '3': 1, '4': 1, '5': 9, '10': 'searchId'},
    {'1': 'item_id', '3': 2, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'item_type', '3': 3, '4': 1, '5': 9, '10': 'itemType'},
    {'1': 'is_relevant', '3': 4, '4': 1, '5': 8, '10': 'isRelevant'},
    {'1': 'feedback', '3': 5, '4': 1, '5': 9, '10': 'feedback'},
  ],
};

/// Descriptor for `SubmitCbirFeedbackRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List submitCbirFeedbackRequestDescriptor = $convert.base64Decode(
    'ChlTdWJtaXRDYmlyRmVlZGJhY2tSZXF1ZXN0EhsKCXNlYXJjaF9pZBgBIAEoCVIIc2VhcmNoSW'
    'QSFwoHaXRlbV9pZBgCIAEoCVIGaXRlbUlkEhsKCWl0ZW1fdHlwZRgDIAEoCVIIaXRlbVR5cGUS'
    'HwoLaXNfcmVsZXZhbnQYBCABKAhSCmlzUmVsZXZhbnQSGgoIZmVlZGJhY2sYBSABKAlSCGZlZW'
    'RiYWNr');

@$core.Deprecated('Use submitCbirFeedbackResponseDescriptor instead')
const SubmitCbirFeedbackResponse$json = {
  '1': 'SubmitCbirFeedbackResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `SubmitCbirFeedbackResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List submitCbirFeedbackResponseDescriptor =
    $convert.base64Decode(
        'ChpTdWJtaXRDYmlyRmVlZGJhY2tSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEh'
        'gKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2U=');

@$core.Deprecated('Use rebuildCbirIndexRequestDescriptor instead')
const RebuildCbirIndexRequest$json = {
  '1': 'RebuildCbirIndexRequest',
};

/// Descriptor for `RebuildCbirIndexRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rebuildCbirIndexRequestDescriptor =
    $convert.base64Decode('ChdSZWJ1aWxkQ2JpckluZGV4UmVxdWVzdA==');

@$core.Deprecated('Use addToCbirIndexRequestDescriptor instead')
const AddToCbirIndexRequest$json = {
  '1': 'AddToCbirIndexRequest',
  '2': [
    {'1': 'media_id', '3': 1, '4': 1, '5': 9, '10': 'mediaId'},
    {'1': 'image_url', '3': 2, '4': 1, '5': 9, '10': 'imageUrl'},
    {'1': 'type', '3': 3, '4': 1, '5': 9, '10': 'type'},
    {
      '1': 'metadata',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.MetaData',
      '10': 'metadata'
    },
  ],
};

/// Descriptor for `AddToCbirIndexRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addToCbirIndexRequestDescriptor = $convert.base64Decode(
    'ChVBZGRUb0NiaXJJbmRleFJlcXVlc3QSGQoIbWVkaWFfaWQYASABKAlSB21lZGlhSWQSGwoJaW'
    '1hZ2VfdXJsGAIgASgJUghpbWFnZVVybBISCgR0eXBlGAMgASgJUgR0eXBlEjUKCG1ldGFkYXRh'
    'GAQgASgLMhkud2VkZGluZy51c2VyLnYxLk1ldGFEYXRhUghtZXRhZGF0YQ==');

@$core.Deprecated('Use removeFromCbirIndexRequestDescriptor instead')
const RemoveFromCbirIndexRequest$json = {
  '1': 'RemoveFromCbirIndexRequest',
  '2': [
    {'1': 'media_id', '3': 1, '4': 1, '5': 9, '10': 'mediaId'},
  ],
};

/// Descriptor for `RemoveFromCbirIndexRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeFromCbirIndexRequestDescriptor =
    $convert.base64Decode(
        'ChpSZW1vdmVGcm9tQ2JpckluZGV4UmVxdWVzdBIZCghtZWRpYV9pZBgBIAEoCVIHbWVkaWFJZA'
        '==');

@$core.Deprecated('Use cbirIndexResultDescriptor instead')
const CbirIndexResult$json = {
  '1': 'CbirIndexResult',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'affected_count', '3': 3, '4': 1, '5': 5, '10': 'affectedCount'},
    {'1': 'processing_time', '3': 4, '4': 1, '5': 1, '10': 'processingTime'},
  ],
};

/// Descriptor for `CbirIndexResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cbirIndexResultDescriptor = $convert.base64Decode(
    'Cg9DYmlySW5kZXhSZXN1bHQSGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIYCgdtZXNzYWdlGA'
    'IgASgJUgdtZXNzYWdlEiUKDmFmZmVjdGVkX2NvdW50GAMgASgFUg1hZmZlY3RlZENvdW50EicK'
    'D3Byb2Nlc3NpbmdfdGltZRgEIAEoAVIOcHJvY2Vzc2luZ1RpbWU=');

@$core.Deprecated('Use healthCheckRequestDescriptor instead')
const HealthCheckRequest$json = {
  '1': 'HealthCheckRequest',
};

/// Descriptor for `HealthCheckRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List healthCheckRequestDescriptor =
    $convert.base64Decode('ChJIZWFsdGhDaGVja1JlcXVlc3Q=');

@$core.Deprecated('Use healthCheckResponseDescriptor instead')
const HealthCheckResponse$json = {
  '1': 'HealthCheckResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {
      '1': 'data',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.CbirHealthData',
      '10': 'data'
    },
  ],
};

/// Descriptor for `HealthCheckResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List healthCheckResponseDescriptor = $convert.base64Decode(
    'ChNIZWFsdGhDaGVja1Jlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSGAoHbWVzc2'
    'FnZRgCIAEoCVIHbWVzc2FnZRIzCgRkYXRhGAMgASgLMh8ud2VkZGluZy51c2VyLnYxLkNiaXJI'
    'ZWFsdGhEYXRhUgRkYXRh');

@$core.Deprecated('Use cbirHealthDataDescriptor instead')
const CbirHealthData$json = {
  '1': 'CbirHealthData',
  '2': [
    {'1': 'mode', '3': 1, '4': 1, '5': 9, '10': 'mode'},
    {'1': 'server_status', '3': 2, '4': 1, '5': 9, '10': 'serverStatus'},
    {'1': 'version', '3': 3, '4': 1, '5': 9, '10': 'version'},
    {'1': 'method', '3': 4, '4': 1, '5': 9, '10': 'method'},
    {'1': 'metric', '3': 5, '4': 1, '5': 9, '10': 'metric'},
    {'1': 'capabilities', '3': 6, '4': 3, '5': 9, '10': 'capabilities'},
  ],
};

/// Descriptor for `CbirHealthData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cbirHealthDataDescriptor = $convert.base64Decode(
    'Cg5DYmlySGVhbHRoRGF0YRISCgRtb2RlGAEgASgJUgRtb2RlEiMKDXNlcnZlcl9zdGF0dXMYAi'
    'ABKAlSDHNlcnZlclN0YXR1cxIYCgd2ZXJzaW9uGAMgASgJUgd2ZXJzaW9uEhYKBm1ldGhvZBgE'
    'IAEoCVIGbWV0aG9kEhYKBm1ldHJpYxgFIAEoCVIGbWV0cmljEiIKDGNhcGFiaWxpdGllcxgGIA'
    'MoCVIMY2FwYWJpbGl0aWVz');

@$core.Deprecated('Use evaluateRequestDescriptor instead')
const EvaluateRequest$json = {
  '1': 'EvaluateRequest',
};

/// Descriptor for `EvaluateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List evaluateRequestDescriptor =
    $convert.base64Decode('Cg9FdmFsdWF0ZVJlcXVlc3Q=');

@$core.Deprecated('Use evaluateResponseDescriptor instead')
const EvaluateResponse$json = {
  '1': 'EvaluateResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {
      '1': 'metrics',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.EvaluateMetric',
      '10': 'metrics'
    },
  ],
};

/// Descriptor for `EvaluateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List evaluateResponseDescriptor = $convert.base64Decode(
    'ChBFdmFsdWF0ZVJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSGAoHbWVzc2FnZR'
    'gCIAEoCVIHbWVzc2FnZRI5CgdtZXRyaWNzGAMgAygLMh8ud2VkZGluZy51c2VyLnYxLkV2YWx1'
    'YXRlTWV0cmljUgdtZXRyaWNz');

@$core.Deprecated('Use evaluateMetricDescriptor instead')
const EvaluateMetric$json = {
  '1': 'EvaluateMetric',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
  ],
};

/// Descriptor for `EvaluateMetric`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List evaluateMetricDescriptor = $convert.base64Decode(
    'Cg5FdmFsdWF0ZU1ldHJpYxISCgRuYW1lGAEgASgJUgRuYW1lEhQKBXZhbHVlGAIgASgBUgV2YW'
    'x1ZRIgCgtkZXNjcmlwdGlvbhgDIAEoCVILZGVzY3JpcHRpb24=');

@$core.Deprecated('Use cbirResultDescriptor instead')
const CbirResult$json = {
  '1': 'CbirResult',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 9, '10': 'type'},
    {'1': 'similarity', '3': 2, '4': 1, '5': 1, '10': 'similarity'},
    {'1': 'score', '3': 3, '4': 1, '5': 1, '10': 'score'},
    {
      '1': 'data',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.CbirResultData',
      '10': 'data'
    },
  ],
};

/// Descriptor for `CbirResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cbirResultDescriptor = $convert.base64Decode(
    'CgpDYmlyUmVzdWx0EhIKBHR5cGUYASABKAlSBHR5cGUSHgoKc2ltaWxhcml0eRgCIAEoAVIKc2'
    'ltaWxhcml0eRIUCgVzY29yZRgDIAEoAVIFc2NvcmUSMwoEZGF0YRgEIAEoCzIfLndlZGRpbmcu'
    'dXNlci52MS5DYmlyUmVzdWx0RGF0YVIEZGF0YQ==');

@$core.Deprecated('Use cbirResultDataDescriptor instead')
const CbirResultData$json = {
  '1': 'CbirResultData',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'slug', '3': 3, '4': 1, '5': 9, '10': 'slug'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {'1': 'price', '3': 5, '4': 1, '5': 1, '10': 'price'},
    {'1': 'discount_price', '3': 6, '4': 1, '5': 1, '10': 'discountPrice'},
    {'1': 'final_price', '3': 7, '4': 1, '5': 1, '10': 'finalPrice'},
    {'1': 'image_url', '3': 8, '4': 1, '5': 9, '10': 'imageUrl'},
    {'1': 'category', '3': 9, '4': 1, '5': 9, '10': 'category'},
    {
      '1': 'category_obj',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.Category',
      '10': 'categoryObj'
    },
    {'1': 'is_available', '3': 11, '4': 1, '5': 8, '10': 'isAvailable'},
  ],
};

/// Descriptor for `CbirResultData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cbirResultDataDescriptor = $convert.base64Decode(
    'Cg5DYmlyUmVzdWx0RGF0YRIOCgJpZBgBIAEoCVICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRISCg'
    'RzbHVnGAMgASgJUgRzbHVnEiAKC2Rlc2NyaXB0aW9uGAQgASgJUgtkZXNjcmlwdGlvbhIUCgVw'
    'cmljZRgFIAEoAVIFcHJpY2USJQoOZGlzY291bnRfcHJpY2UYBiABKAFSDWRpc2NvdW50UHJpY2'
    'USHwoLZmluYWxfcHJpY2UYByABKAFSCmZpbmFsUHJpY2USGwoJaW1hZ2VfdXJsGAggASgJUghp'
    'bWFnZVVybBIaCghjYXRlZ29yeRgJIAEoCVIIY2F0ZWdvcnkSPAoMY2F0ZWdvcnlfb2JqGAogAS'
    'gLMhkud2VkZGluZy51c2VyLnYxLkNhdGVnb3J5UgtjYXRlZ29yeU9iahIhCgxpc19hdmFpbGFi'
    'bGUYCyABKAhSC2lzQXZhaWxhYmxl');
