// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/category.proto.

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

@$core.Deprecated('Use getCategoryRequestDescriptor instead')
const GetCategoryRequest$json = {
  '1': 'GetCategoryRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `GetCategoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCategoryRequestDescriptor =
    $convert.base64Decode('ChJHZXRDYXRlZ29yeVJlcXVlc3QSDgoCaWQYASABKAlSAmlk');

@$core.Deprecated('Use getCategoryBySlugRequestDescriptor instead')
const GetCategoryBySlugRequest$json = {
  '1': 'GetCategoryBySlugRequest',
  '2': [
    {'1': 'slug', '3': 1, '4': 1, '5': 9, '10': 'slug'},
  ],
};

/// Descriptor for `GetCategoryBySlugRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCategoryBySlugRequestDescriptor =
    $convert.base64Decode(
        'ChhHZXRDYXRlZ29yeUJ5U2x1Z1JlcXVlc3QSEgoEc2x1ZxgBIAEoCVIEc2x1Zw==');

@$core.Deprecated('Use listCategoriesRequestDescriptor instead')
const ListCategoriesRequest$json = {
  '1': 'ListCategoriesRequest',
  '2': [
    {
      '1': 'pagination',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.PaginationRequest',
      '10': 'pagination'
    },
    {'1': 'active', '3': 2, '4': 1, '5': 8, '10': 'active'},
    {'1': 'parent_id', '3': 3, '4': 1, '5': 9, '10': 'parentId'},
  ],
};

/// Descriptor for `ListCategoriesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCategoriesRequestDescriptor = $convert.base64Decode(
    'ChVMaXN0Q2F0ZWdvcmllc1JlcXVlc3QSQgoKcGFnaW5hdGlvbhgBIAEoCzIiLndlZGRpbmcudX'
    'Nlci52MS5QYWdpbmF0aW9uUmVxdWVzdFIKcGFnaW5hdGlvbhIWCgZhY3RpdmUYAiABKAhSBmFj'
    'dGl2ZRIbCglwYXJlbnRfaWQYAyABKAlSCHBhcmVudElk');

@$core.Deprecated('Use categoryListResponseDescriptor instead')
const CategoryListResponse$json = {
  '1': 'CategoryListResponse',
  '2': [
    {
      '1': 'categories',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.Category',
      '10': 'categories'
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

/// Descriptor for `CategoryListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List categoryListResponseDescriptor = $convert.base64Decode(
    'ChRDYXRlZ29yeUxpc3RSZXNwb25zZRI5CgpjYXRlZ29yaWVzGAEgAygLMhkud2VkZGluZy51c2'
    'VyLnYxLkNhdGVnb3J5UgpjYXRlZ29yaWVzEkMKCnBhZ2luYXRpb24YAiABKAsyIy53ZWRkaW5n'
    'LnVzZXIudjEuUGFnaW5hdGlvblJlc3BvbnNlUgpwYWdpbmF0aW9u');

@$core.Deprecated('Use getAllCategoriesRequestDescriptor instead')
const GetAllCategoriesRequest$json = {
  '1': 'GetAllCategoriesRequest',
  '2': [
    {'1': 'active', '3': 1, '4': 1, '5': 8, '10': 'active'},
  ],
};

/// Descriptor for `GetAllCategoriesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAllCategoriesRequestDescriptor =
    $convert.base64Decode(
        'ChdHZXRBbGxDYXRlZ29yaWVzUmVxdWVzdBIWCgZhY3RpdmUYASABKAhSBmFjdGl2ZQ==');

@$core.Deprecated('Use getCategoryTreeRequestDescriptor instead')
const GetCategoryTreeRequest$json = {
  '1': 'GetCategoryTreeRequest',
};

/// Descriptor for `GetCategoryTreeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCategoryTreeRequestDescriptor =
    $convert.base64Decode('ChZHZXRDYXRlZ29yeVRyZWVSZXF1ZXN0');

@$core.Deprecated('Use categoryTreeResponseDescriptor instead')
const CategoryTreeResponse$json = {
  '1': 'CategoryTreeResponse',
  '2': [
    {
      '1': 'categories',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.CategoryTree',
      '10': 'categories'
    },
  ],
};

/// Descriptor for `CategoryTreeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List categoryTreeResponseDescriptor = $convert.base64Decode(
    'ChRDYXRlZ29yeVRyZWVSZXNwb25zZRI9CgpjYXRlZ29yaWVzGAEgAygLMh0ud2VkZGluZy51c2'
    'VyLnYxLkNhdGVnb3J5VHJlZVIKY2F0ZWdvcmllcw==');

@$core.Deprecated('Use getCategoriesWithCountsRequestDescriptor instead')
const GetCategoriesWithCountsRequest$json = {
  '1': 'GetCategoriesWithCountsRequest',
  '2': [
    {'1': 'active', '3': 1, '4': 1, '5': 8, '10': 'active'},
  ],
};

/// Descriptor for `GetCategoriesWithCountsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCategoriesWithCountsRequestDescriptor =
    $convert.base64Decode(
        'Ch5HZXRDYXRlZ29yaWVzV2l0aENvdW50c1JlcXVlc3QSFgoGYWN0aXZlGAEgASgIUgZhY3Rpdm'
        'U=');

@$core.Deprecated('Use categoryWithCountsResponseDescriptor instead')
const CategoryWithCountsResponse$json = {
  '1': 'CategoryWithCountsResponse',
  '2': [
    {
      '1': 'categories',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.CategoryWithCounts',
      '10': 'categories'
    },
  ],
};

/// Descriptor for `CategoryWithCountsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List categoryWithCountsResponseDescriptor =
    $convert.base64Decode(
        'ChpDYXRlZ29yeVdpdGhDb3VudHNSZXNwb25zZRJDCgpjYXRlZ29yaWVzGAEgAygLMiMud2VkZG'
        'luZy51c2VyLnYxLkNhdGVnb3J5V2l0aENvdW50c1IKY2F0ZWdvcmllcw==');

@$core.Deprecated('Use categoryDescriptor instead')
const Category$json = {
  '1': 'Category',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'slug', '3': 3, '4': 1, '5': 9, '10': 'slug'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {'1': 'image_url', '3': 5, '4': 1, '5': 9, '10': 'imageUrl'},
    {'1': 'is_active', '3': 6, '4': 1, '5': 8, '10': 'isActive'},
    {
      '1': 'parent',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.Category',
      '10': 'parent'
    },
    {
      '1': 'children',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.Category',
      '10': 'children'
    },
    {'1': 'created_at', '3': 9, '4': 1, '5': 9, '10': 'createdAt'},
    {'1': 'updated_at', '3': 10, '4': 1, '5': 9, '10': 'updatedAt'},
  ],
};

/// Descriptor for `Category`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List categoryDescriptor = $convert.base64Decode(
    'CghDYXRlZ29yeRIOCgJpZBgBIAEoCVICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRISCgRzbHVnGA'
    'MgASgJUgRzbHVnEiAKC2Rlc2NyaXB0aW9uGAQgASgJUgtkZXNjcmlwdGlvbhIbCglpbWFnZV91'
    'cmwYBSABKAlSCGltYWdlVXJsEhsKCWlzX2FjdGl2ZRgGIAEoCFIIaXNBY3RpdmUSMQoGcGFyZW'
    '50GAcgASgLMhkud2VkZGluZy51c2VyLnYxLkNhdGVnb3J5UgZwYXJlbnQSNQoIY2hpbGRyZW4Y'
    'CCADKAsyGS53ZWRkaW5nLnVzZXIudjEuQ2F0ZWdvcnlSCGNoaWxkcmVuEh0KCmNyZWF0ZWRfYX'
    'QYCSABKAlSCWNyZWF0ZWRBdBIdCgp1cGRhdGVkX2F0GAogASgJUgl1cGRhdGVkQXQ=');

@$core.Deprecated('Use categoryTreeDescriptor instead')
const CategoryTree$json = {
  '1': 'CategoryTree',
  '2': [
    {
      '1': 'category',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.Category',
      '10': 'category'
    },
    {
      '1': 'children',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.CategoryTree',
      '10': 'children'
    },
  ],
};

/// Descriptor for `CategoryTree`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List categoryTreeDescriptor = $convert.base64Decode(
    'CgxDYXRlZ29yeVRyZWUSNQoIY2F0ZWdvcnkYASABKAsyGS53ZWRkaW5nLnVzZXIudjEuQ2F0ZW'
    'dvcnlSCGNhdGVnb3J5EjkKCGNoaWxkcmVuGAIgAygLMh0ud2VkZGluZy51c2VyLnYxLkNhdGVn'
    'b3J5VHJlZVIIY2hpbGRyZW4=');

@$core.Deprecated('Use categoryWithCountsDescriptor instead')
const CategoryWithCounts$json = {
  '1': 'CategoryWithCounts',
  '2': [
    {
      '1': 'category',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.Category',
      '10': 'category'
    },
    {'1': 'catalog_count', '3': 2, '4': 1, '5': 5, '10': 'catalogCount'},
    {'1': 'package_count', '3': 3, '4': 1, '5': 5, '10': 'packageCount'},
    {'1': 'total_items', '3': 4, '4': 1, '5': 5, '10': 'totalItems'},
  ],
};

/// Descriptor for `CategoryWithCounts`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List categoryWithCountsDescriptor = $convert.base64Decode(
    'ChJDYXRlZ29yeVdpdGhDb3VudHMSNQoIY2F0ZWdvcnkYASABKAsyGS53ZWRkaW5nLnVzZXIudj'
    'EuQ2F0ZWdvcnlSCGNhdGVnb3J5EiMKDWNhdGFsb2dfY291bnQYAiABKAVSDGNhdGFsb2dDb3Vu'
    'dBIjCg1wYWNrYWdlX2NvdW50GAMgASgFUgxwYWNrYWdlQ291bnQSHwoLdG90YWxfaXRlbXMYBC'
    'ABKAVSCnRvdGFsSXRlbXM=');
