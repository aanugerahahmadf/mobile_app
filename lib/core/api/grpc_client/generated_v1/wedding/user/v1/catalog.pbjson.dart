// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/catalog.proto.

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

@$core.Deprecated('Use getCatalogRequestDescriptor instead')
const GetCatalogRequest$json = {
  '1': 'GetCatalogRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `GetCatalogRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCatalogRequestDescriptor =
    $convert.base64Decode('ChFHZXRDYXRhbG9nUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQ=');

@$core.Deprecated('Use getCatalogBySlugRequestDescriptor instead')
const GetCatalogBySlugRequest$json = {
  '1': 'GetCatalogBySlugRequest',
  '2': [
    {'1': 'slug', '3': 1, '4': 1, '5': 9, '10': 'slug'},
  ],
};

/// Descriptor for `GetCatalogBySlugRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCatalogBySlugRequestDescriptor =
    $convert.base64Decode(
        'ChdHZXRDYXRhbG9nQnlTbHVnUmVxdWVzdBISCgRzbHVnGAEgASgJUgRzbHVn');

@$core.Deprecated('Use listCatalogsRequestDescriptor instead')
const ListCatalogsRequest$json = {
  '1': 'ListCatalogsRequest',
  '2': [
    {
      '1': 'pagination',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.PaginationRequest',
      '10': 'pagination'
    },
    {'1': 'category_id', '3': 2, '4': 1, '5': 9, '10': 'categoryId'},
    {'1': 'theme', '3': 3, '4': 1, '5': 9, '10': 'theme'},
    {'1': 'min_price', '3': 4, '4': 1, '5': 1, '10': 'minPrice'},
    {'1': 'max_price', '3': 5, '4': 1, '5': 1, '10': 'maxPrice'},
    {'1': 'search', '3': 6, '4': 1, '5': 9, '10': 'search'},
    {'1': 'active', '3': 7, '4': 1, '5': 8, '10': 'active'},
    {'1': 'with_tier_count', '3': 8, '4': 1, '5': 8, '10': 'withTierCount'},
    {'1': 'sort_by', '3': 9, '4': 1, '5': 9, '10': 'sortBy'},
    {
      '1': 'sort_direction',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.wedding.user.v1.SortDirection',
      '10': 'sortDirection'
    },
  ],
};

/// Descriptor for `ListCatalogsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCatalogsRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0Q2F0YWxvZ3NSZXF1ZXN0EkIKCnBhZ2luYXRpb24YASABKAsyIi53ZWRkaW5nLnVzZX'
    'IudjEuUGFnaW5hdGlvblJlcXVlc3RSCnBhZ2luYXRpb24SHwoLY2F0ZWdvcnlfaWQYAiABKAlS'
    'CmNhdGVnb3J5SWQSFAoFdGhlbWUYAyABKAlSBXRoZW1lEhsKCW1pbl9wcmljZRgEIAEoAVIIbW'
    'luUHJpY2USGwoJbWF4X3ByaWNlGAUgASgBUghtYXhQcmljZRIWCgZzZWFyY2gYBiABKAlSBnNl'
    'YXJjaBIWCgZhY3RpdmUYByABKAhSBmFjdGl2ZRImCg93aXRoX3RpZXJfY291bnQYCCABKAhSDX'
    'dpdGhUaWVyQ291bnQSFwoHc29ydF9ieRgJIAEoCVIGc29ydEJ5EkUKDnNvcnRfZGlyZWN0aW9u'
    'GAogASgOMh4ud2VkZGluZy51c2VyLnYxLlNvcnREaXJlY3Rpb25SDXNvcnREaXJlY3Rpb24=');

@$core.Deprecated('Use catalogListResponseDescriptor instead')
const CatalogListResponse$json = {
  '1': 'CatalogListResponse',
  '2': [
    {
      '1': 'catalogs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.Catalog',
      '10': 'catalogs'
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

/// Descriptor for `CatalogListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List catalogListResponseDescriptor = $convert.base64Decode(
    'ChNDYXRhbG9nTGlzdFJlc3BvbnNlEjQKCGNhdGFsb2dzGAEgAygLMhgud2VkZGluZy51c2VyLn'
    'YxLkNhdGFsb2dSCGNhdGFsb2dzEkMKCnBhZ2luYXRpb24YAiABKAsyIy53ZWRkaW5nLnVzZXIu'
    'djEuUGFnaW5hdGlvblJlc3BvbnNlUgpwYWdpbmF0aW9u');

@$core.Deprecated('Use getFeaturedCatalogsRequestDescriptor instead')
const GetFeaturedCatalogsRequest$json = {
  '1': 'GetFeaturedCatalogsRequest',
  '2': [
    {'1': 'limit', '3': 1, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `GetFeaturedCatalogsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFeaturedCatalogsRequestDescriptor =
    $convert.base64Decode(
        'ChpHZXRGZWF0dXJlZENhdGFsb2dzUmVxdWVzdBIUCgVsaW1pdBgBIAEoBVIFbGltaXQ=');

@$core.Deprecated('Use getOnSaleCatalogsRequestDescriptor instead')
const GetOnSaleCatalogsRequest$json = {
  '1': 'GetOnSaleCatalogsRequest',
  '2': [
    {'1': 'limit', '3': 1, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `GetOnSaleCatalogsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getOnSaleCatalogsRequestDescriptor =
    $convert.base64Decode(
        'ChhHZXRPblNhbGVDYXRhbG9nc1JlcXVlc3QSFAoFbGltaXQYASABKAVSBWxpbWl0');

@$core.Deprecated('Use getCatalogsByCategoryRequestDescriptor instead')
const GetCatalogsByCategoryRequest$json = {
  '1': 'GetCatalogsByCategoryRequest',
  '2': [
    {'1': 'category_id', '3': 1, '4': 1, '5': 9, '10': 'categoryId'},
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `GetCatalogsByCategoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCatalogsByCategoryRequestDescriptor =
    $convert.base64Decode(
        'ChxHZXRDYXRhbG9nc0J5Q2F0ZWdvcnlSZXF1ZXN0Eh8KC2NhdGVnb3J5X2lkGAEgASgJUgpjYX'
        'RlZ29yeUlkEhQKBWxpbWl0GAIgASgFUgVsaW1pdA==');

@$core.Deprecated('Use getRelatedCatalogsRequestDescriptor instead')
const GetRelatedCatalogsRequest$json = {
  '1': 'GetRelatedCatalogsRequest',
  '2': [
    {'1': 'catalog_id', '3': 1, '4': 1, '5': 9, '10': 'catalogId'},
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `GetRelatedCatalogsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRelatedCatalogsRequestDescriptor =
    $convert.base64Decode(
        'ChlHZXRSZWxhdGVkQ2F0YWxvZ3NSZXF1ZXN0Eh0KCmNhdGFsb2dfaWQYASABKAlSCWNhdGFsb2'
        'dJZBIUCgVsaW1pdBgCIAEoBVIFbGltaXQ=');

@$core.Deprecated('Use searchCatalogsRequestDescriptor instead')
const SearchCatalogsRequest$json = {
  '1': 'SearchCatalogsRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `SearchCatalogsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchCatalogsRequestDescriptor = $convert.base64Decode(
    'ChVTZWFyY2hDYXRhbG9nc1JlcXVlc3QSFAoFcXVlcnkYASABKAlSBXF1ZXJ5EhQKBWxpbWl0GA'
    'IgASgFUgVsaW1pdA==');

@$core.Deprecated('Use getCatalogTiersRequestDescriptor instead')
const GetCatalogTiersRequest$json = {
  '1': 'GetCatalogTiersRequest',
  '2': [
    {'1': 'catalog_id', '3': 1, '4': 1, '5': 9, '10': 'catalogId'},
  ],
};

/// Descriptor for `GetCatalogTiersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCatalogTiersRequestDescriptor =
    $convert.base64Decode(
        'ChZHZXRDYXRhbG9nVGllcnNSZXF1ZXN0Eh0KCmNhdGFsb2dfaWQYASABKAlSCWNhdGFsb2dJZA'
        '==');

@$core.Deprecated('Use getCatalogStatsRequestDescriptor instead')
const GetCatalogStatsRequest$json = {
  '1': 'GetCatalogStatsRequest',
};

/// Descriptor for `GetCatalogStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCatalogStatsRequestDescriptor =
    $convert.base64Decode('ChZHZXRDYXRhbG9nU3RhdHNSZXF1ZXN0');

@$core.Deprecated('Use catalogStatsDescriptor instead')
const CatalogStats$json = {
  '1': 'CatalogStats',
  '2': [
    {'1': 'total_catalogs', '3': 1, '4': 1, '5': 5, '10': 'totalCatalogs'},
    {'1': 'active_catalogs', '3': 2, '4': 1, '5': 5, '10': 'activeCatalogs'},
    {
      '1': 'featured_catalogs',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'featuredCatalogs'
    },
    {
      '1': 'out_of_stock_catalogs',
      '3': 4,
      '4': 1,
      '5': 5,
      '10': 'outOfStockCatalogs'
    },
    {
      '1': 'low_stock_catalogs',
      '3': 5,
      '4': 1,
      '5': 5,
      '10': 'lowStockCatalogs'
    },
    {'1': 'total_value', '3': 6, '4': 1, '5': 1, '10': 'totalValue'},
    {
      '1': 'by_category',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.CategoryCatalogCount',
      '10': 'byCategory'
    },
  ],
};

/// Descriptor for `CatalogStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List catalogStatsDescriptor = $convert.base64Decode(
    'CgxDYXRhbG9nU3RhdHMSJQoOdG90YWxfY2F0YWxvZ3MYASABKAVSDXRvdGFsQ2F0YWxvZ3MSJw'
    'oPYWN0aXZlX2NhdGFsb2dzGAIgASgFUg5hY3RpdmVDYXRhbG9ncxIrChFmZWF0dXJlZF9jYXRh'
    'bG9ncxgDIAEoBVIQZmVhdHVyZWRDYXRhbG9ncxIxChVvdXRfb2Zfc3RvY2tfY2F0YWxvZ3MYBC'
    'ABKAVSEm91dE9mU3RvY2tDYXRhbG9ncxIsChJsb3dfc3RvY2tfY2F0YWxvZ3MYBSABKAVSEGxv'
    'd1N0b2NrQ2F0YWxvZ3MSHwoLdG90YWxfdmFsdWUYBiABKAFSCnRvdGFsVmFsdWUSRgoLYnlfY2'
    'F0ZWdvcnkYByADKAsyJS53ZWRkaW5nLnVzZXIudjEuQ2F0ZWdvcnlDYXRhbG9nQ291bnRSCmJ5'
    'Q2F0ZWdvcnk=');

@$core.Deprecated('Use categoryCatalogCountDescriptor instead')
const CategoryCatalogCount$json = {
  '1': 'CategoryCatalogCount',
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

/// Descriptor for `CategoryCatalogCount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List categoryCatalogCountDescriptor = $convert.base64Decode(
    'ChRDYXRlZ29yeUNhdGFsb2dDb3VudBI1CghjYXRlZ29yeRgBIAEoCzIZLndlZGRpbmcudXNlci'
    '52MS5DYXRlZ29yeVIIY2F0ZWdvcnkSFAoFY291bnQYAiABKAVSBWNvdW50');

@$core.Deprecated('Use catalogDescriptor instead')
const Catalog$json = {
  '1': 'Catalog',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'slug', '3': 3, '4': 1, '5': 9, '10': 'slug'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {'1': 'price', '3': 5, '4': 1, '5': 1, '10': 'price'},
    {'1': 'discount_price', '3': 6, '4': 1, '5': 1, '10': 'discountPrice'},
    {'1': 'final_price', '3': 7, '4': 1, '5': 1, '10': 'finalPrice'},
    {'1': 'stock', '3': 8, '4': 1, '5': 5, '10': 'stock'},
    {'1': 'is_active', '3': 9, '4': 1, '5': 8, '10': 'isActive'},
    {'1': 'is_featured', '3': 10, '4': 1, '5': 8, '10': 'isFeatured'},
    {'1': 'is_out_of_stock', '3': 11, '4': 1, '5': 8, '10': 'isOutOfStock'},
    {'1': 'image_url', '3': 12, '4': 1, '5': 9, '10': 'imageUrl'},
    {'1': 'video_url', '3': 13, '4': 1, '5': 9, '10': 'videoUrl'},
    {'1': 'features', '3': 14, '4': 3, '5': 9, '10': 'features'},
    {'1': 'theme', '3': 15, '4': 1, '5': 9, '10': 'theme'},
    {'1': 'color', '3': 16, '4': 1, '5': 9, '10': 'color'},
    {'1': 'min_capacity', '3': 17, '4': 1, '5': 5, '10': 'minCapacity'},
    {'1': 'max_capacity', '3': 18, '4': 1, '5': 5, '10': 'maxCapacity'},
    {
      '1': 'category',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.Category',
      '10': 'category'
    },
    {'1': 'average_rating', '3': 20, '4': 1, '5': 1, '10': 'averageRating'},
    {
      '1': 'reviews',
      '3': 21,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.Review',
      '10': 'reviews'
    },
    {
      '1': 'tiers',
      '3': 22,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.CatalogTier',
      '10': 'tiers'
    },
    {'1': 'created_at', '3': 23, '4': 1, '5': 9, '10': 'createdAt'},
    {'1': 'updated_at', '3': 24, '4': 1, '5': 9, '10': 'updatedAt'},
  ],
};

/// Descriptor for `Catalog`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List catalogDescriptor = $convert.base64Decode(
    'CgdDYXRhbG9nEg4KAmlkGAEgASgJUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEhIKBHNsdWcYAy'
    'ABKAlSBHNsdWcSIAoLZGVzY3JpcHRpb24YBCABKAlSC2Rlc2NyaXB0aW9uEhQKBXByaWNlGAUg'
    'ASgBUgVwcmljZRIlCg5kaXNjb3VudF9wcmljZRgGIAEoAVINZGlzY291bnRQcmljZRIfCgtmaW'
    '5hbF9wcmljZRgHIAEoAVIKZmluYWxQcmljZRIUCgVzdG9jaxgIIAEoBVIFc3RvY2sSGwoJaXNf'
    'YWN0aXZlGAkgASgIUghpc0FjdGl2ZRIfCgtpc19mZWF0dXJlZBgKIAEoCFIKaXNGZWF0dXJlZB'
    'IlCg9pc19vdXRfb2Zfc3RvY2sYCyABKAhSDGlzT3V0T2ZTdG9jaxIbCglpbWFnZV91cmwYDCAB'
    'KAlSCGltYWdlVXJsEhsKCXZpZGVvX3VybBgNIAEoCVIIdmlkZW9VcmwSGgoIZmVhdHVyZXMYDi'
    'ADKAlSCGZlYXR1cmVzEhQKBXRoZW1lGA8gASgJUgV0aGVtZRIUCgVjb2xvchgQIAEoCVIFY29s'
    'b3ISIQoMbWluX2NhcGFjaXR5GBEgASgFUgttaW5DYXBhY2l0eRIhCgxtYXhfY2FwYWNpdHkYEi'
    'ABKAVSC21heENhcGFjaXR5EjUKCGNhdGVnb3J5GBMgASgLMhkud2VkZGluZy51c2VyLnYxLkNh'
    'dGVnb3J5UghjYXRlZ29yeRIlCg5hdmVyYWdlX3JhdGluZxgUIAEoAVINYXZlcmFnZVJhdGluZx'
    'IxCgdyZXZpZXdzGBUgAygLMhcud2VkZGluZy51c2VyLnYxLlJldmlld1IHcmV2aWV3cxIyCgV0'
    'aWVycxgWIAMoCzIcLndlZGRpbmcudXNlci52MS5DYXRhbG9nVGllclIFdGllcnMSHQoKY3JlYX'
    'RlZF9hdBgXIAEoCVIJY3JlYXRlZEF0Eh0KCnVwZGF0ZWRfYXQYGCABKAlSCXVwZGF0ZWRBdA==');

@$core.Deprecated('Use catalogTierDescriptor instead')
const CatalogTier$json = {
  '1': 'CatalogTier',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'catalog_id', '3': 2, '4': 1, '5': 9, '10': 'catalogId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {'1': 'price', '3': 5, '4': 1, '5': 1, '10': 'price'},
    {'1': 'discount_price', '3': 6, '4': 1, '5': 1, '10': 'discountPrice'},
    {'1': 'final_price', '3': 7, '4': 1, '5': 1, '10': 'finalPrice'},
    {'1': 'stock', '3': 8, '4': 1, '5': 5, '10': 'stock'},
    {'1': 'features', '3': 9, '4': 3, '5': 9, '10': 'features'},
    {'1': 'sort_order', '3': 10, '4': 1, '5': 5, '10': 'sortOrder'},
    {'1': 'image_url', '3': 11, '4': 1, '5': 9, '10': 'imageUrl'},
  ],
};

/// Descriptor for `CatalogTier`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List catalogTierDescriptor = $convert.base64Decode(
    'CgtDYXRhbG9nVGllchIOCgJpZBgBIAEoCVICaWQSHQoKY2F0YWxvZ19pZBgCIAEoCVIJY2F0YW'
    'xvZ0lkEhIKBG5hbWUYAyABKAlSBG5hbWUSIAoLZGVzY3JpcHRpb24YBCABKAlSC2Rlc2NyaXB0'
    'aW9uEhQKBXByaWNlGAUgASgBUgVwcmljZRIlCg5kaXNjb3VudF9wcmljZRgGIAEoAVINZGlzY2'
    '91bnRQcmljZRIfCgtmaW5hbF9wcmljZRgHIAEoAVIKZmluYWxQcmljZRIUCgVzdG9jaxgIIAEo'
    'BVIFc3RvY2sSGgoIZmVhdHVyZXMYCSADKAlSCGZlYXR1cmVzEh0KCnNvcnRfb3JkZXIYCiABKA'
    'VSCXNvcnRPcmRlchIbCglpbWFnZV91cmwYCyABKAlSCGltYWdlVXJs');

@$core.Deprecated('Use reviewDescriptor instead')
const Review$json = {
  '1': 'Review',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'catalog_id', '3': 3, '4': 1, '5': 9, '10': 'catalogId'},
    {'1': 'package_id', '3': 4, '4': 1, '5': 9, '10': 'packageId'},
    {'1': 'rating', '3': 5, '4': 1, '5': 5, '10': 'rating'},
    {'1': 'title', '3': 6, '4': 1, '5': 9, '10': 'title'},
    {'1': 'comment', '3': 7, '4': 1, '5': 9, '10': 'comment'},
    {'1': 'photos', '3': 8, '4': 3, '5': 9, '10': 'photos'},
    {'1': 'helpful_count', '3': 9, '4': 1, '5': 5, '10': 'helpfulCount'},
    {'1': 'is_anonymous', '3': 10, '4': 1, '5': 8, '10': 'isAnonymous'},
    {
      '1': 'is_verified_purchase',
      '3': 11,
      '4': 1,
      '5': 8,
      '10': 'isVerifiedPurchase'
    },
    {
      '1': 'status',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.wedding.user.v1.ReviewStatus',
      '10': 'status'
    },
    {
      '1': 'reply',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.ReviewReply',
      '10': 'reply'
    },
    {'1': 'created_at', '3': 14, '4': 1, '5': 9, '10': 'createdAt'},
    {'1': 'updated_at', '3': 15, '4': 1, '5': 9, '10': 'updatedAt'},
  ],
};

/// Descriptor for `Review`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reviewDescriptor = $convert.base64Decode(
    'CgZSZXZpZXcSDgoCaWQYASABKAlSAmlkEhcKB3VzZXJfaWQYAiABKAlSBnVzZXJJZBIdCgpjYX'
    'RhbG9nX2lkGAMgASgJUgljYXRhbG9nSWQSHQoKcGFja2FnZV9pZBgEIAEoCVIJcGFja2FnZUlk'
    'EhYKBnJhdGluZxgFIAEoBVIGcmF0aW5nEhQKBXRpdGxlGAYgASgJUgV0aXRsZRIYCgdjb21tZW'
    '50GAcgASgJUgdjb21tZW50EhYKBnBob3RvcxgIIAMoCVIGcGhvdG9zEiMKDWhlbHBmdWxfY291'
    'bnQYCSABKAVSDGhlbHBmdWxDb3VudBIhCgxpc19hbm9ueW1vdXMYCiABKAhSC2lzQW5vbnltb3'
    'VzEjAKFGlzX3ZlcmlmaWVkX3B1cmNoYXNlGAsgASgIUhJpc1ZlcmlmaWVkUHVyY2hhc2USNQoG'
    'c3RhdHVzGAwgASgOMh0ud2VkZGluZy51c2VyLnYxLlJldmlld1N0YXR1c1IGc3RhdHVzEjIKBX'
    'JlcGx5GA0gASgLMhwud2VkZGluZy51c2VyLnYxLlJldmlld1JlcGx5UgVyZXBseRIdCgpjcmVh'
    'dGVkX2F0GA4gASgJUgljcmVhdGVkQXQSHQoKdXBkYXRlZF9hdBgPIAEoCVIJdXBkYXRlZEF0');

@$core.Deprecated('Use reviewReplyDescriptor instead')
const ReviewReply$json = {
  '1': 'ReviewReply',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'review_id', '3': 2, '4': 1, '5': 9, '10': 'reviewId'},
    {'1': 'content', '3': 3, '4': 1, '5': 9, '10': 'content'},
    {
      '1': 'created_by',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.User',
      '10': 'createdBy'
    },
    {'1': 'created_at', '3': 5, '4': 1, '5': 9, '10': 'createdAt'},
  ],
};

/// Descriptor for `ReviewReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reviewReplyDescriptor = $convert.base64Decode(
    'CgtSZXZpZXdSZXBseRIOCgJpZBgBIAEoCVICaWQSGwoJcmV2aWV3X2lkGAIgASgJUghyZXZpZX'
    'dJZBIYCgdjb250ZW50GAMgASgJUgdjb250ZW50EjQKCmNyZWF0ZWRfYnkYBCABKAsyFS53ZWRk'
    'aW5nLnVzZXIudjEuVXNlclIJY3JlYXRlZEJ5Eh0KCmNyZWF0ZWRfYXQYBSABKAlSCWNyZWF0ZW'
    'RBdA==');

@$core.Deprecated('Use catalogTiersResponseDescriptor instead')
const CatalogTiersResponse$json = {
  '1': 'CatalogTiersResponse',
  '2': [
    {
      '1': 'tiers',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.CatalogTier',
      '10': 'tiers'
    },
    {
      '1': 'meta',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.CatalogMeta',
      '10': 'meta'
    },
  ],
};

/// Descriptor for `CatalogTiersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List catalogTiersResponseDescriptor = $convert.base64Decode(
    'ChRDYXRhbG9nVGllcnNSZXNwb25zZRIyCgV0aWVycxgBIAMoCzIcLndlZGRpbmcudXNlci52MS'
    '5DYXRhbG9nVGllclIFdGllcnMSMAoEbWV0YRgCIAEoCzIcLndlZGRpbmcudXNlci52MS5DYXRh'
    'bG9nTWV0YVIEbWV0YQ==');

@$core.Deprecated('Use catalogMetaDescriptor instead')
const CatalogMeta$json = {
  '1': 'CatalogMeta',
  '2': [
    {'1': 'catalog_id', '3': 1, '4': 1, '5': 9, '10': 'catalogId'},
    {'1': 'catalog_name', '3': 2, '4': 1, '5': 9, '10': 'catalogName'},
    {'1': 'total', '3': 3, '4': 1, '5': 5, '10': 'total'},
  ],
};

/// Descriptor for `CatalogMeta`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List catalogMetaDescriptor = $convert.base64Decode(
    'CgtDYXRhbG9nTWV0YRIdCgpjYXRhbG9nX2lkGAEgASgJUgljYXRhbG9nSWQSIQoMY2F0YWxvZ1'
    '9uYW1lGAIgASgJUgtjYXRhbG9nTmFtZRIUCgV0b3RhbBgDIAEoBVIFdG90YWw=');
