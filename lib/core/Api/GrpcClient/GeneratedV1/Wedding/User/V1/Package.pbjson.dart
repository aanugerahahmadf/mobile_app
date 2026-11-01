// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/package.proto.

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

@$core.Deprecated('Use getPackageRequestDescriptor instead')
const GetPackageRequest$json = {
  '1': 'GetPackageRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `GetPackageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPackageRequestDescriptor =
    $convert.base64Decode('ChFHZXRQYWNrYWdlUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQ=');

@$core.Deprecated('Use getPackageBySlugRequestDescriptor instead')
const GetPackageBySlugRequest$json = {
  '1': 'GetPackageBySlugRequest',
  '2': [
    {'1': 'slug', '3': 1, '4': 1, '5': 9, '10': 'slug'},
  ],
};

/// Descriptor for `GetPackageBySlugRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPackageBySlugRequestDescriptor =
    $convert.base64Decode(
        'ChdHZXRQYWNrYWdlQnlTbHVnUmVxdWVzdBISCgRzbHVnGAEgASgJUgRzbHVn');

@$core.Deprecated('Use listPackagesRequestDescriptor instead')
const ListPackagesRequest$json = {
  '1': 'ListPackagesRequest',
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
    {'1': 'featured', '3': 3, '4': 1, '5': 8, '10': 'featured'},
    {'1': 'min_price', '3': 4, '4': 1, '5': 1, '10': 'minPrice'},
    {'1': 'max_price', '3': 5, '4': 1, '5': 1, '10': 'maxPrice'},
    {'1': 'active', '3': 6, '4': 1, '5': 8, '10': 'active'},
    {'1': 'sort_by', '3': 7, '4': 1, '5': 9, '10': 'sortBy'},
    {
      '1': 'sort_direction',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.wedding.user.v1.SortDirection',
      '10': 'sortDirection'
    },
  ],
};

/// Descriptor for `ListPackagesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPackagesRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0UGFja2FnZXNSZXF1ZXN0EkIKCnBhZ2luYXRpb24YASABKAsyIi53ZWRkaW5nLnVzZX'
    'IudjEuUGFnaW5hdGlvblJlcXVlc3RSCnBhZ2luYXRpb24SHwoLY2F0ZWdvcnlfaWQYAiABKAlS'
    'CmNhdGVnb3J5SWQSGgoIZmVhdHVyZWQYAyABKAhSCGZlYXR1cmVkEhsKCW1pbl9wcmljZRgEIA'
    'EoAVIIbWluUHJpY2USGwoJbWF4X3ByaWNlGAUgASgBUghtYXhQcmljZRIWCgZhY3RpdmUYBiAB'
    'KAhSBmFjdGl2ZRIXCgdzb3J0X2J5GAcgASgJUgZzb3J0QnkSRQoOc29ydF9kaXJlY3Rpb24YCC'
    'ABKA4yHi53ZWRkaW5nLnVzZXIudjEuU29ydERpcmVjdGlvblINc29ydERpcmVjdGlvbg==');

@$core.Deprecated('Use packageListResponseDescriptor instead')
const PackageListResponse$json = {
  '1': 'PackageListResponse',
  '2': [
    {
      '1': 'packages',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.Package',
      '10': 'packages'
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

/// Descriptor for `PackageListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packageListResponseDescriptor = $convert.base64Decode(
    'ChNQYWNrYWdlTGlzdFJlc3BvbnNlEjQKCHBhY2thZ2VzGAEgAygLMhgud2VkZGluZy51c2VyLn'
    'YxLlBhY2thZ2VSCHBhY2thZ2VzEkMKCnBhZ2luYXRpb24YAiABKAsyIy53ZWRkaW5nLnVzZXIu'
    'djEuUGFnaW5hdGlvblJlc3BvbnNlUgpwYWdpbmF0aW9u');

@$core.Deprecated('Use getFeaturedPackagesRequestDescriptor instead')
const GetFeaturedPackagesRequest$json = {
  '1': 'GetFeaturedPackagesRequest',
  '2': [
    {'1': 'limit', '3': 1, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `GetFeaturedPackagesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFeaturedPackagesRequestDescriptor =
    $convert.base64Decode(
        'ChpHZXRGZWF0dXJlZFBhY2thZ2VzUmVxdWVzdBIUCgVsaW1pdBgBIAEoBVIFbGltaXQ=');

@$core.Deprecated('Use getOnSalePackagesRequestDescriptor instead')
const GetOnSalePackagesRequest$json = {
  '1': 'GetOnSalePackagesRequest',
  '2': [
    {'1': 'limit', '3': 1, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `GetOnSalePackagesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getOnSalePackagesRequestDescriptor =
    $convert.base64Decode(
        'ChhHZXRPblNhbGVQYWNrYWdlc1JlcXVlc3QSFAoFbGltaXQYASABKAVSBWxpbWl0');

@$core.Deprecated('Use getPackagesByCategoryRequestDescriptor instead')
const GetPackagesByCategoryRequest$json = {
  '1': 'GetPackagesByCategoryRequest',
  '2': [
    {'1': 'category_id', '3': 1, '4': 1, '5': 9, '10': 'categoryId'},
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `GetPackagesByCategoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPackagesByCategoryRequestDescriptor =
    $convert.base64Decode(
        'ChxHZXRQYWNrYWdlc0J5Q2F0ZWdvcnlSZXF1ZXN0Eh8KC2NhdGVnb3J5X2lkGAEgASgJUgpjYX'
        'RlZ29yeUlkEhQKBWxpbWl0GAIgASgFUgVsaW1pdA==');

@$core.Deprecated('Use getPackagesByCapacityRequestDescriptor instead')
const GetPackagesByCapacityRequest$json = {
  '1': 'GetPackagesByCapacityRequest',
  '2': [
    {'1': 'min_capacity', '3': 1, '4': 1, '5': 5, '10': 'minCapacity'},
    {'1': 'max_capacity', '3': 2, '4': 1, '5': 5, '10': 'maxCapacity'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `GetPackagesByCapacityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPackagesByCapacityRequestDescriptor =
    $convert.base64Decode(
        'ChxHZXRQYWNrYWdlc0J5Q2FwYWNpdHlSZXF1ZXN0EiEKDG1pbl9jYXBhY2l0eRgBIAEoBVILbW'
        'luQ2FwYWNpdHkSIQoMbWF4X2NhcGFjaXR5GAIgASgFUgttYXhDYXBhY2l0eRIUCgVsaW1pdBgD'
        'IAEoBVIFbGltaXQ=');

@$core.Deprecated('Use getRelatedPackagesRequestDescriptor instead')
const GetRelatedPackagesRequest$json = {
  '1': 'GetRelatedPackagesRequest',
  '2': [
    {'1': 'package_id', '3': 1, '4': 1, '5': 9, '10': 'packageId'},
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `GetRelatedPackagesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRelatedPackagesRequestDescriptor =
    $convert.base64Decode(
        'ChlHZXRSZWxhdGVkUGFja2FnZXNSZXF1ZXN0Eh0KCnBhY2thZ2VfaWQYASABKAlSCXBhY2thZ2'
        'VJZBIUCgVsaW1pdBgCIAEoBVIFbGltaXQ=');

@$core.Deprecated('Use searchPackagesRequestDescriptor instead')
const SearchPackagesRequest$json = {
  '1': 'SearchPackagesRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `SearchPackagesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchPackagesRequestDescriptor = $convert.base64Decode(
    'ChVTZWFyY2hQYWNrYWdlc1JlcXVlc3QSFAoFcXVlcnkYASABKAlSBXF1ZXJ5EhQKBWxpbWl0GA'
    'IgASgFUgVsaW1pdA==');

@$core.Deprecated('Use getPackageStatsRequestDescriptor instead')
const GetPackageStatsRequest$json = {
  '1': 'GetPackageStatsRequest',
};

/// Descriptor for `GetPackageStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPackageStatsRequestDescriptor =
    $convert.base64Decode('ChZHZXRQYWNrYWdlU3RhdHNSZXF1ZXN0');

@$core.Deprecated('Use packageStatsDescriptor instead')
const PackageStats$json = {
  '1': 'PackageStats',
  '2': [
    {'1': 'total_packages', '3': 1, '4': 1, '5': 5, '10': 'totalPackages'},
    {'1': 'active_packages', '3': 2, '4': 1, '5': 5, '10': 'activePackages'},
    {
      '1': 'featured_packages',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'featuredPackages'
    },
    {'1': 'on_sale_packages', '3': 4, '4': 1, '5': 5, '10': 'onSalePackages'},
    {'1': 'total_value', '3': 5, '4': 1, '5': 1, '10': 'totalValue'},
    {
      '1': 'by_category',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.CategoryPackageCount',
      '10': 'byCategory'
    },
    {
      '1': 'by_capacity',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.CapacityPackageCount',
      '10': 'byCapacity'
    },
  ],
};

/// Descriptor for `PackageStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packageStatsDescriptor = $convert.base64Decode(
    'CgxQYWNrYWdlU3RhdHMSJQoOdG90YWxfcGFja2FnZXMYASABKAVSDXRvdGFsUGFja2FnZXMSJw'
    'oPYWN0aXZlX3BhY2thZ2VzGAIgASgFUg5hY3RpdmVQYWNrYWdlcxIrChFmZWF0dXJlZF9wYWNr'
    'YWdlcxgDIAEoBVIQZmVhdHVyZWRQYWNrYWdlcxIoChBvbl9zYWxlX3BhY2thZ2VzGAQgASgFUg'
    '5vblNhbGVQYWNrYWdlcxIfCgt0b3RhbF92YWx1ZRgFIAEoAVIKdG90YWxWYWx1ZRJGCgtieV9j'
    'YXRlZ29yeRgGIAMoCzIlLndlZGRpbmcudXNlci52MS5DYXRlZ29yeVBhY2thZ2VDb3VudFIKYn'
    'lDYXRlZ29yeRJGCgtieV9jYXBhY2l0eRgHIAMoCzIlLndlZGRpbmcudXNlci52MS5DYXBhY2l0'
    'eVBhY2thZ2VDb3VudFIKYnlDYXBhY2l0eQ==');

@$core.Deprecated('Use categoryPackageCountDescriptor instead')
const CategoryPackageCount$json = {
  '1': 'CategoryPackageCount',
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

/// Descriptor for `CategoryPackageCount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List categoryPackageCountDescriptor = $convert.base64Decode(
    'ChRDYXRlZ29yeVBhY2thZ2VDb3VudBI1CghjYXRlZ29yeRgBIAEoCzIZLndlZGRpbmcudXNlci'
    '52MS5DYXRlZ29yeVIIY2F0ZWdvcnkSFAoFY291bnQYAiABKAVSBWNvdW50');

@$core.Deprecated('Use capacityPackageCountDescriptor instead')
const CapacityPackageCount$json = {
  '1': 'CapacityPackageCount',
  '2': [
    {'1': 'min_capacity', '3': 1, '4': 1, '5': 5, '10': 'minCapacity'},
    {'1': 'max_capacity', '3': 2, '4': 1, '5': 5, '10': 'maxCapacity'},
    {'1': 'count', '3': 3, '4': 1, '5': 5, '10': 'count'},
  ],
};

/// Descriptor for `CapacityPackageCount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List capacityPackageCountDescriptor = $convert.base64Decode(
    'ChRDYXBhY2l0eVBhY2thZ2VDb3VudBIhCgxtaW5fY2FwYWNpdHkYASABKAVSC21pbkNhcGFjaX'
    'R5EiEKDG1heF9jYXBhY2l0eRgCIAEoBVILbWF4Q2FwYWNpdHkSFAoFY291bnQYAyABKAVSBWNv'
    'dW50');

@$core.Deprecated('Use packageDescriptor instead')
const Package$json = {
  '1': 'Package',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'slug', '3': 3, '4': 1, '5': 9, '10': 'slug'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {'1': 'price', '3': 5, '4': 1, '5': 1, '10': 'price'},
    {'1': 'discount_price', '3': 6, '4': 1, '5': 1, '10': 'discountPrice'},
    {'1': 'final_price', '3': 7, '4': 1, '5': 1, '10': 'finalPrice'},
    {'1': 'is_active', '3': 8, '4': 1, '5': 8, '10': 'isActive'},
    {'1': 'is_featured', '3': 9, '4': 1, '5': 8, '10': 'isFeatured'},
    {'1': 'image_url', '3': 10, '4': 1, '5': 9, '10': 'imageUrl'},
    {'1': 'features', '3': 11, '4': 3, '5': 9, '10': 'features'},
    {'1': 'theme', '3': 12, '4': 1, '5': 9, '10': 'theme'},
    {'1': 'color', '3': 13, '4': 1, '5': 9, '10': 'color'},
    {'1': 'min_capacity', '3': 14, '4': 1, '5': 5, '10': 'minCapacity'},
    {'1': 'max_capacity', '3': 15, '4': 1, '5': 5, '10': 'maxCapacity'},
    {
      '1': 'category',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.Category',
      '10': 'category'
    },
    {'1': 'average_rating', '3': 17, '4': 1, '5': 1, '10': 'averageRating'},
    {
      '1': 'reviews',
      '3': 18,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.Review',
      '10': 'reviews'
    },
    {'1': 'created_at', '3': 19, '4': 1, '5': 9, '10': 'createdAt'},
    {'1': 'updated_at', '3': 20, '4': 1, '5': 9, '10': 'updatedAt'},
  ],
};

/// Descriptor for `Package`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packageDescriptor = $convert.base64Decode(
    'CgdQYWNrYWdlEg4KAmlkGAEgASgJUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEhIKBHNsdWcYAy'
    'ABKAlSBHNsdWcSIAoLZGVzY3JpcHRpb24YBCABKAlSC2Rlc2NyaXB0aW9uEhQKBXByaWNlGAUg'
    'ASgBUgVwcmljZRIlCg5kaXNjb3VudF9wcmljZRgGIAEoAVINZGlzY291bnRQcmljZRIfCgtmaW'
    '5hbF9wcmljZRgHIAEoAVIKZmluYWxQcmljZRIbCglpc19hY3RpdmUYCCABKAhSCGlzQWN0aXZl'
    'Eh8KC2lzX2ZlYXR1cmVkGAkgASgIUgppc0ZlYXR1cmVkEhsKCWltYWdlX3VybBgKIAEoCVIIaW'
    '1hZ2VVcmwSGgoIZmVhdHVyZXMYCyADKAlSCGZlYXR1cmVzEhQKBXRoZW1lGAwgASgJUgV0aGVt'
    'ZRIUCgVjb2xvchgNIAEoCVIFY29sb3ISIQoMbWluX2NhcGFjaXR5GA4gASgFUgttaW5DYXBhY2'
    'l0eRIhCgxtYXhfY2FwYWNpdHkYDyABKAVSC21heENhcGFjaXR5EjUKCGNhdGVnb3J5GBAgASgL'
    'Mhkud2VkZGluZy51c2VyLnYxLkNhdGVnb3J5UghjYXRlZ29yeRIlCg5hdmVyYWdlX3JhdGluZx'
    'gRIAEoAVINYXZlcmFnZVJhdGluZxIxCgdyZXZpZXdzGBIgAygLMhcud2VkZGluZy51c2VyLnYx'
    'LlJldmlld1IHcmV2aWV3cxIdCgpjcmVhdGVkX2F0GBMgASgJUgljcmVhdGVkQXQSHQoKdXBkYX'
    'RlZF9hdBgUIAEoCVIJdXBkYXRlZEF0');
