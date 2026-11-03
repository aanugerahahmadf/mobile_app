// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/search.proto.

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

@$core.Deprecated('Use searchRequestDescriptor instead')
const SearchRequest$json = {
  '1': 'SearchRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {
      '1': 'type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.wedding.user.v1.SearchType',
      '10': 'type'
    },
    {
      '1': 'pagination',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.PaginationRequest',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `SearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchRequestDescriptor = $convert.base64Decode(
    'Cg1TZWFyY2hSZXF1ZXN0EhQKBXF1ZXJ5GAEgASgJUgVxdWVyeRIvCgR0eXBlGAIgASgOMhsud2'
    'VkZGluZy51c2VyLnYxLlNlYXJjaFR5cGVSBHR5cGUSQgoKcGFnaW5hdGlvbhgDIAEoCzIiLndl'
    'ZGRpbmcudXNlci52MS5QYWdpbmF0aW9uUmVxdWVzdFIKcGFnaW5hdGlvbg==');

@$core.Deprecated('Use searchResponseDescriptor instead')
const SearchResponse$json = {
  '1': 'SearchResponse',
  '2': [
    {
      '1': 'results',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.SearchResult',
      '10': 'results'
    },
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.PaginationResponse',
      '10': 'pagination'
    },
    {'1': 'took', '3': 3, '4': 1, '5': 1, '10': 'took'},
  ],
};

/// Descriptor for `SearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchResponseDescriptor = $convert.base64Decode(
    'Cg5TZWFyY2hSZXNwb25zZRI3CgdyZXN1bHRzGAEgAygLMh0ud2VkZGluZy51c2VyLnYxLlNlYX'
    'JjaFJlc3VsdFIHcmVzdWx0cxJDCgpwYWdpbmF0aW9uGAIgASgLMiMud2VkZGluZy51c2VyLnYx'
    'LlBhZ2luYXRpb25SZXNwb25zZVIKcGFnaW5hdGlvbhISCgR0b29rGAMgASgBUgR0b29r');

@$core.Deprecated('Use getSuggestionsRequestDescriptor instead')
const GetSuggestionsRequest$json = {
  '1': 'GetSuggestionsRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `GetSuggestionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSuggestionsRequestDescriptor = $convert.base64Decode(
    'ChVHZXRTdWdnZXN0aW9uc1JlcXVlc3QSFAoFcXVlcnkYASABKAlSBXF1ZXJ5EhQKBWxpbWl0GA'
    'IgASgFUgVsaW1pdA==');

@$core.Deprecated('Use searchSuggestionsResponseDescriptor instead')
const SearchSuggestionsResponse$json = {
  '1': 'SearchSuggestionsResponse',
  '2': [
    {
      '1': 'suggestions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.SearchSuggestion',
      '10': 'suggestions'
    },
  ],
};

/// Descriptor for `SearchSuggestionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchSuggestionsResponseDescriptor =
    $convert.base64Decode(
        'ChlTZWFyY2hTdWdnZXN0aW9uc1Jlc3BvbnNlEkMKC3N1Z2dlc3Rpb25zGAEgAygLMiEud2VkZG'
        'luZy51c2VyLnYxLlNlYXJjaFN1Z2dlc3Rpb25SC3N1Z2dlc3Rpb25z');

@$core.Deprecated('Use getPopularSearchesRequestDescriptor instead')
const GetPopularSearchesRequest$json = {
  '1': 'GetPopularSearchesRequest',
  '2': [
    {'1': 'limit', '3': 1, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `GetPopularSearchesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPopularSearchesRequestDescriptor =
    $convert.base64Decode(
        'ChlHZXRQb3B1bGFyU2VhcmNoZXNSZXF1ZXN0EhQKBWxpbWl0GAEgASgFUgVsaW1pdA==');

@$core.Deprecated('Use popularSearchesResponseDescriptor instead')
const PopularSearchesResponse$json = {
  '1': 'PopularSearchesResponse',
  '2': [
    {
      '1': 'searches',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.PopularSearch',
      '10': 'searches'
    },
  ],
};

/// Descriptor for `PopularSearchesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List popularSearchesResponseDescriptor =
    $convert.base64Decode(
        'ChdQb3B1bGFyU2VhcmNoZXNSZXNwb25zZRI6CghzZWFyY2hlcxgBIAMoCzIeLndlZGRpbmcudX'
        'Nlci52MS5Qb3B1bGFyU2VhcmNoUghzZWFyY2hlcw==');

@$core.Deprecated('Use getFiltersRequestDescriptor instead')
const GetFiltersRequest$json = {
  '1': 'GetFiltersRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'category_id', '3': 2, '4': 1, '5': 9, '10': 'categoryId'},
  ],
};

/// Descriptor for `GetFiltersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFiltersRequestDescriptor = $convert.base64Decode(
    'ChFHZXRGaWx0ZXJzUmVxdWVzdBIUCgVxdWVyeRgBIAEoCVIFcXVlcnkSHwoLY2F0ZWdvcnlfaW'
    'QYAiABKAlSCmNhdGVnb3J5SWQ=');

@$core.Deprecated('Use searchFiltersResponseDescriptor instead')
const SearchFiltersResponse$json = {
  '1': 'SearchFiltersResponse',
  '2': [
    {
      '1': 'filters',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.SearchFilters',
      '10': 'filters'
    },
  ],
};

/// Descriptor for `SearchFiltersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchFiltersResponseDescriptor = $convert.base64Decode(
    'ChVTZWFyY2hGaWx0ZXJzUmVzcG9uc2USOAoHZmlsdGVycxgBIAEoCzIeLndlZGRpbmcudXNlci'
    '52MS5TZWFyY2hGaWx0ZXJzUgdmaWx0ZXJz');

@$core.Deprecated('Use searchResultDescriptor instead')
const SearchResult$json = {
  '1': 'SearchResult',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'type', '3': 2, '4': 1, '5': 9, '10': 'type'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'slug', '3': 4, '4': 1, '5': 9, '10': 'slug'},
    {'1': 'price', '3': 5, '4': 1, '5': 1, '10': 'price'},
    {'1': 'image_url', '3': 6, '4': 1, '5': 9, '10': 'imageUrl'},
    {'1': 'category', '3': 7, '4': 1, '5': 9, '10': 'category'},
  ],
};

/// Descriptor for `SearchResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchResultDescriptor = $convert.base64Decode(
    'CgxTZWFyY2hSZXN1bHQSDgoCaWQYASABKAlSAmlkEhIKBHR5cGUYAiABKAlSBHR5cGUSEgoEbm'
    'FtZRgDIAEoCVIEbmFtZRISCgRzbHVnGAQgASgJUgRzbHVnEhQKBXByaWNlGAUgASgBUgVwcmlj'
    'ZRIbCglpbWFnZV91cmwYBiABKAlSCGltYWdlVXJsEhoKCGNhdGVnb3J5GAcgASgJUghjYXRlZ2'
    '9yeQ==');

@$core.Deprecated('Use searchSuggestionDescriptor instead')
const SearchSuggestion$json = {
  '1': 'SearchSuggestion',
  '2': [
    {'1': 'text', '3': 1, '4': 1, '5': 9, '10': 'text'},
    {
      '1': 'type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.wedding.user.v1.SearchSuggestionType',
      '10': 'type'
    },
    {'1': 'count', '3': 3, '4': 1, '5': 5, '10': 'count'},
    {'1': 'image_url', '3': 4, '4': 1, '5': 9, '10': 'imageUrl'},
  ],
};

/// Descriptor for `SearchSuggestion`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchSuggestionDescriptor = $convert.base64Decode(
    'ChBTZWFyY2hTdWdnZXN0aW9uEhIKBHRleHQYASABKAlSBHRleHQSOQoEdHlwZRgCIAEoDjIlLn'
    'dlZGRpbmcudXNlci52MS5TZWFyY2hTdWdnZXN0aW9uVHlwZVIEdHlwZRIUCgVjb3VudBgDIAEo'
    'BVIFY291bnQSGwoJaW1hZ2VfdXJsGAQgASgJUghpbWFnZVVybA==');

@$core.Deprecated('Use popularSearchDescriptor instead')
const PopularSearch$json = {
  '1': 'PopularSearch',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'count', '3': 2, '4': 1, '5': 5, '10': 'count'},
    {'1': 'trend', '3': 3, '4': 1, '5': 9, '10': 'trend'},
  ],
};

/// Descriptor for `PopularSearch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List popularSearchDescriptor = $convert.base64Decode(
    'Cg1Qb3B1bGFyU2VhcmNoEhQKBXF1ZXJ5GAEgASgJUgVxdWVyeRIUCgVjb3VudBgCIAEoBVIFY2'
    '91bnQSFAoFdHJlbmQYAyABKAlSBXRyZW5k');

@$core.Deprecated('Use searchFiltersDescriptor instead')
const SearchFilters$json = {
  '1': 'SearchFilters',
  '2': [
    {
      '1': 'categories',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.CategoryFilter',
      '10': 'categories'
    },
    {
      '1': 'price_range',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.PriceRange',
      '10': 'priceRange'
    },
    {'1': 'themes', '3': 3, '4': 3, '5': 9, '10': 'themes'},
    {'1': 'colors', '3': 4, '4': 3, '5': 9, '10': 'colors'},
    {'1': 'min_capacity', '3': 5, '4': 1, '5': 5, '10': 'minCapacity'},
    {'1': 'max_capacity', '3': 6, '4': 1, '5': 5, '10': 'maxCapacity'},
  ],
};

/// Descriptor for `SearchFilters`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchFiltersDescriptor = $convert.base64Decode(
    'Cg1TZWFyY2hGaWx0ZXJzEj8KCmNhdGVnb3JpZXMYASADKAsyHy53ZWRkaW5nLnVzZXIudjEuQ2'
    'F0ZWdvcnlGaWx0ZXJSCmNhdGVnb3JpZXMSPAoLcHJpY2VfcmFuZ2UYAiABKAsyGy53ZWRkaW5n'
    'LnVzZXIudjEuUHJpY2VSYW5nZVIKcHJpY2VSYW5nZRIWCgZ0aGVtZXMYAyADKAlSBnRoZW1lcx'
    'IWCgZjb2xvcnMYBCADKAlSBmNvbG9ycxIhCgxtaW5fY2FwYWNpdHkYBSABKAVSC21pbkNhcGFj'
    'aXR5EiEKDG1heF9jYXBhY2l0eRgGIAEoBVILbWF4Q2FwYWNpdHk=');

@$core.Deprecated('Use categoryFilterDescriptor instead')
const CategoryFilter$json = {
  '1': 'CategoryFilter',
  '2': [
    {
      '1': 'category',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.Category',
      '10': 'category'
    },
    {'1': 'count', '3': 2, '4': 1, '5': 5, '10': 'count'},
  ],
};

/// Descriptor for `CategoryFilter`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List categoryFilterDescriptor = $convert.base64Decode(
    'Cg5DYXRlZ29yeUZpbHRlchI1CghjYXRlZ29yeRgBIAEoCzIZLndlZGRpbmcudXNlci52MS5DYX'
    'RlZ29yeVIIY2F0ZWdvcnkSFAoFY291bnQYAiABKAVSBWNvdW50');
