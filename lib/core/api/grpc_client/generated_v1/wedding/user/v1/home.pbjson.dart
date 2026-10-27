// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/home.proto.

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

@$core.Deprecated('Use getHomeDataRequestDescriptor instead')
const GetHomeDataRequest$json = {
  '1': 'GetHomeDataRequest',
};

/// Descriptor for `GetHomeDataRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getHomeDataRequestDescriptor =
    $convert.base64Decode('ChJHZXRIb21lRGF0YVJlcXVlc3Q=');

@$core.Deprecated('Use homeDataDescriptor instead')
const HomeData$json = {
  '1': 'HomeData',
  '2': [
    {
      '1': 'featured_catalogs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.Catalog',
      '10': 'featuredCatalogs'
    },
    {
      '1': 'featured_packages',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.Package',
      '10': 'featuredPackages'
    },
    {
      '1': 'on_sale_catalogs',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.Catalog',
      '10': 'onSaleCatalogs'
    },
    {
      '1': 'on_sale_packages',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.Package',
      '10': 'onSalePackages'
    },
    {
      '1': 'categories',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.Category',
      '10': 'categories'
    },
    {
      '1': 'hero_banners',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.HeroBanner',
      '10': 'heroBanners'
    },
    {
      '1': 'promotions',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.Promotion',
      '10': 'promotions'
    },
    {
      '1': 'stats',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.HomeStats',
      '10': 'stats'
    },
  ],
};

/// Descriptor for `HomeData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List homeDataDescriptor = $convert.base64Decode(
    'CghIb21lRGF0YRJFChFmZWF0dXJlZF9jYXRhbG9ncxgBIAMoCzIYLndlZGRpbmcudXNlci52MS'
    '5DYXRhbG9nUhBmZWF0dXJlZENhdGFsb2dzEkUKEWZlYXR1cmVkX3BhY2thZ2VzGAIgAygLMhgu'
    'd2VkZGluZy51c2VyLnYxLlBhY2thZ2VSEGZlYXR1cmVkUGFja2FnZXMSQgoQb25fc2FsZV9jYX'
    'RhbG9ncxgDIAMoCzIYLndlZGRpbmcudXNlci52MS5DYXRhbG9nUg5vblNhbGVDYXRhbG9ncxJC'
    'ChBvbl9zYWxlX3BhY2thZ2VzGAQgAygLMhgud2VkZGluZy51c2VyLnYxLlBhY2thZ2VSDm9uU2'
    'FsZVBhY2thZ2VzEjkKCmNhdGVnb3JpZXMYBSADKAsyGS53ZWRkaW5nLnVzZXIudjEuQ2F0ZWdv'
    'cnlSCmNhdGVnb3JpZXMSPgoMaGVyb19iYW5uZXJzGAYgAygLMhsud2VkZGluZy51c2VyLnYxLk'
    'hlcm9CYW5uZXJSC2hlcm9CYW5uZXJzEjoKCnByb21vdGlvbnMYByADKAsyGi53ZWRkaW5nLnVz'
    'ZXIudjEuUHJvbW90aW9uUgpwcm9tb3Rpb25zEjAKBXN0YXRzGAggASgLMhoud2VkZGluZy51c2'
    'VyLnYxLkhvbWVTdGF0c1IFc3RhdHM=');

@$core.Deprecated('Use getHeroBannersRequestDescriptor instead')
const GetHeroBannersRequest$json = {
  '1': 'GetHeroBannersRequest',
};

/// Descriptor for `GetHeroBannersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getHeroBannersRequestDescriptor =
    $convert.base64Decode('ChVHZXRIZXJvQmFubmVyc1JlcXVlc3Q=');

@$core.Deprecated('Use heroBannersResponseDescriptor instead')
const HeroBannersResponse$json = {
  '1': 'HeroBannersResponse',
  '2': [
    {
      '1': 'banners',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.HeroBanner',
      '10': 'banners'
    },
  ],
};

/// Descriptor for `HeroBannersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List heroBannersResponseDescriptor = $convert.base64Decode(
    'ChNIZXJvQmFubmVyc1Jlc3BvbnNlEjUKB2Jhbm5lcnMYASADKAsyGy53ZWRkaW5nLnVzZXIudj'
    'EuSGVyb0Jhbm5lclIHYmFubmVycw==');

@$core.Deprecated('Use getPromotionsRequestDescriptor instead')
const GetPromotionsRequest$json = {
  '1': 'GetPromotionsRequest',
  '2': [
    {'1': 'limit', '3': 1, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `GetPromotionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPromotionsRequestDescriptor =
    $convert.base64Decode(
        'ChRHZXRQcm9tb3Rpb25zUmVxdWVzdBIUCgVsaW1pdBgBIAEoBVIFbGltaXQ=');

@$core.Deprecated('Use promotionsResponseDescriptor instead')
const PromotionsResponse$json = {
  '1': 'PromotionsResponse',
  '2': [
    {
      '1': 'promotions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.Promotion',
      '10': 'promotions'
    },
  ],
};

/// Descriptor for `PromotionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List promotionsResponseDescriptor = $convert.base64Decode(
    'ChJQcm9tb3Rpb25zUmVzcG9uc2USOgoKcHJvbW90aW9ucxgBIAMoCzIaLndlZGRpbmcudXNlci'
    '52MS5Qcm9tb3Rpb25SCnByb21vdGlvbnM=');

@$core.Deprecated('Use heroBannerDescriptor instead')
const HeroBanner$json = {
  '1': 'HeroBanner',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'subtitle', '3': 3, '4': 1, '5': 9, '10': 'subtitle'},
    {'1': 'image_url', '3': 4, '4': 1, '5': 9, '10': 'imageUrl'},
    {'1': 'link_url', '3': 5, '4': 1, '5': 9, '10': 'linkUrl'},
    {'1': 'link_type', '3': 6, '4': 1, '5': 9, '10': 'linkType'},
    {'1': 'link_id', '3': 7, '4': 1, '5': 9, '10': 'linkId'},
    {'1': 'position', '3': 8, '4': 1, '5': 5, '10': 'position'},
    {'1': 'is_active', '3': 9, '4': 1, '5': 8, '10': 'isActive'},
  ],
};

/// Descriptor for `HeroBanner`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List heroBannerDescriptor = $convert.base64Decode(
    'CgpIZXJvQmFubmVyEg4KAmlkGAEgASgJUgJpZBIUCgV0aXRsZRgCIAEoCVIFdGl0bGUSGgoIc3'
    'VidGl0bGUYAyABKAlSCHN1YnRpdGxlEhsKCWltYWdlX3VybBgEIAEoCVIIaW1hZ2VVcmwSGQoI'
    'bGlua191cmwYBSABKAlSB2xpbmtVcmwSGwoJbGlua190eXBlGAYgASgJUghsaW5rVHlwZRIXCg'
    'dsaW5rX2lkGAcgASgJUgZsaW5rSWQSGgoIcG9zaXRpb24YCCABKAVSCHBvc2l0aW9uEhsKCWlz'
    'X2FjdGl2ZRgJIAEoCFIIaXNBY3RpdmU=');

@$core.Deprecated('Use promotionDescriptor instead')
const Promotion$json = {
  '1': 'Promotion',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'image_url', '3': 4, '4': 1, '5': 9, '10': 'imageUrl'},
    {'1': 'discount_percent', '3': 5, '4': 1, '5': 5, '10': 'discountPercent'},
    {'1': 'code', '3': 6, '4': 1, '5': 9, '10': 'code'},
    {'1': 'valid_from', '3': 7, '4': 1, '5': 9, '10': 'validFrom'},
    {'1': 'valid_until', '3': 8, '4': 1, '5': 9, '10': 'validUntil'},
    {'1': 'is_active', '3': 9, '4': 1, '5': 8, '10': 'isActive'},
  ],
};

/// Descriptor for `Promotion`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List promotionDescriptor = $convert.base64Decode(
    'CglQcm9tb3Rpb24SDgoCaWQYASABKAlSAmlkEhQKBXRpdGxlGAIgASgJUgV0aXRsZRIgCgtkZX'
    'NjcmlwdGlvbhgDIAEoCVILZGVzY3JpcHRpb24SGwoJaW1hZ2VfdXJsGAQgASgJUghpbWFnZVVy'
    'bBIpChBkaXNjb3VudF9wZXJjZW50GAUgASgFUg9kaXNjb3VudFBlcmNlbnQSEgoEY29kZRgGIA'
    'EoCVIEY29kZRIdCgp2YWxpZF9mcm9tGAcgASgJUgl2YWxpZEZyb20SHwoLdmFsaWRfdW50aWwY'
    'CCABKAlSCnZhbGlkVW50aWwSGwoJaXNfYWN0aXZlGAkgASgIUghpc0FjdGl2ZQ==');

@$core.Deprecated('Use homeStatsDescriptor instead')
const HomeStats$json = {
  '1': 'HomeStats',
  '2': [
    {'1': 'total_catalogs', '3': 1, '4': 1, '5': 5, '10': 'totalCatalogs'},
    {'1': 'total_packages', '3': 2, '4': 1, '5': 5, '10': 'totalPackages'},
    {'1': 'total_categories', '3': 3, '4': 1, '5': 5, '10': 'totalCategories'},
    {'1': 'happy_customers', '3': 4, '4': 1, '5': 5, '10': 'happyCustomers'},
  ],
};

/// Descriptor for `HomeStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List homeStatsDescriptor = $convert.base64Decode(
    'CglIb21lU3RhdHMSJQoOdG90YWxfY2F0YWxvZ3MYASABKAVSDXRvdGFsQ2F0YWxvZ3MSJQoOdG'
    '90YWxfcGFja2FnZXMYAiABKAVSDXRvdGFsUGFja2FnZXMSKQoQdG90YWxfY2F0ZWdvcmllcxgD'
    'IAEoBVIPdG90YWxDYXRlZ29yaWVzEicKD2hhcHB5X2N1c3RvbWVycxgEIAEoBVIOaGFwcHlDdX'
    'N0b21lcnM=');
