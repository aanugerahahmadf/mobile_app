// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/category.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GetCategoryRequest extends $pb.GeneratedMessage {
  factory GetCategoryRequest({
    $core.String? id,
  }) {
    final result = GetCategoryRequest._();
    if (id != null) result.id = id;
    return result;
  }

  GetCategoryRequest._();

  factory GetCategoryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCategoryRequest()..mergeFromBuffer(data, registry);
  factory GetCategoryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCategoryRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCategoryRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetCategoryRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCategoryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCategoryRequest copyWith(void Function(GetCategoryRequest) updates) =>
      super.copyWith((message) => updates(message as GetCategoryRequest))
          as GetCategoryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetCategoryRequest() / GetCategoryRequest.new instead')
  static GetCategoryRequest create() => GetCategoryRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetCategoryRequest._();
  @$core.override
  GetCategoryRequest createEmptyInstance() => GetCategoryRequest._();
  @$core.pragma('dart2js:noInline')
  static GetCategoryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCategoryRequest>(
          GetCategoryRequest.$_createMessage);
  static GetCategoryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class GetCategoryBySlugRequest extends $pb.GeneratedMessage {
  factory GetCategoryBySlugRequest({
    $core.String? slug,
  }) {
    final result = GetCategoryBySlugRequest._();
    if (slug != null) result.slug = slug;
    return result;
  }

  GetCategoryBySlugRequest._();

  factory GetCategoryBySlugRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCategoryBySlugRequest()..mergeFromBuffer(data, registry);
  factory GetCategoryBySlugRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCategoryBySlugRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCategoryBySlugRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetCategoryBySlugRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'slug')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCategoryBySlugRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCategoryBySlugRequest copyWith(
          void Function(GetCategoryBySlugRequest) updates) =>
      super.copyWith((message) => updates(message as GetCategoryBySlugRequest))
          as GetCategoryBySlugRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetCategoryBySlugRequest() / GetCategoryBySlugRequest.new instead')
  static GetCategoryBySlugRequest create() => GetCategoryBySlugRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetCategoryBySlugRequest._();
  @$core.override
  GetCategoryBySlugRequest createEmptyInstance() =>
      GetCategoryBySlugRequest._();
  @$core.pragma('dart2js:noInline')
  static GetCategoryBySlugRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCategoryBySlugRequest>(
          GetCategoryBySlugRequest.$_createMessage);
  static GetCategoryBySlugRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get slug => $_getSZ(0);
  @$pb.TagNumber(1)
  set slug($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSlug() => $_has(0);
  @$pb.TagNumber(1)
  void clearSlug() => $_clearField(1);
}

class ListCategoriesRequest extends $pb.GeneratedMessage {
  factory ListCategoriesRequest({
    $1.PaginationRequest? pagination,
    $core.bool? active,
    $core.String? parentId,
  }) {
    final result = ListCategoriesRequest._();
    if (pagination != null) result.pagination = pagination;
    if (active != null) result.active = active;
    if (parentId != null) result.parentId = parentId;
    return result;
  }

  ListCategoriesRequest._();

  factory ListCategoriesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCategoriesRequest()..mergeFromBuffer(data, registry);
  factory ListCategoriesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCategoriesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCategoriesRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ListCategoriesRequest.$_createMessage)
    ..aOM<$1.PaginationRequest>(1, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginationRequest.$_createMessage)
    ..aOB(2, _omitFieldNames ? '' : 'active')
    ..aOS(3, _omitFieldNames ? '' : 'parentId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCategoriesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCategoriesRequest copyWith(
          void Function(ListCategoriesRequest) updates) =>
      super.copyWith((message) => updates(message as ListCategoriesRequest))
          as ListCategoriesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListCategoriesRequest() / ListCategoriesRequest.new instead')
  static ListCategoriesRequest create() => ListCategoriesRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListCategoriesRequest._();
  @$core.override
  ListCategoriesRequest createEmptyInstance() => ListCategoriesRequest._();
  @$core.pragma('dart2js:noInline')
  static ListCategoriesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCategoriesRequest>(
          ListCategoriesRequest.$_createMessage);
  static ListCategoriesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.PaginationRequest get pagination => $_getN(0);
  @$pb.TagNumber(1)
  set pagination($1.PaginationRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPagination() => $_has(0);
  @$pb.TagNumber(1)
  void clearPagination() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.PaginationRequest ensurePagination() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get active => $_getBF(1);
  @$pb.TagNumber(2)
  set active($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasActive() => $_has(1);
  @$pb.TagNumber(2)
  void clearActive() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get parentId => $_getSZ(2);
  @$pb.TagNumber(3)
  set parentId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasParentId() => $_has(2);
  @$pb.TagNumber(3)
  void clearParentId() => $_clearField(3);
}

class CategoryListResponse extends $pb.GeneratedMessage {
  factory CategoryListResponse({
    $core.Iterable<Category>? categories,
    $1.PaginationResponse? pagination,
  }) {
    final result = CategoryListResponse._();
    if (categories != null) result.categories.addAll(categories);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  CategoryListResponse._();

  factory CategoryListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CategoryListResponse()..mergeFromBuffer(data, registry);
  factory CategoryListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CategoryListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CategoryListResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: CategoryListResponse.$_createMessage)
    ..pPM<Category>(1, _omitFieldNames ? '' : 'categories',
        subBuilder: Category.$_createMessage)
    ..aOM<$1.PaginationResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginationResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CategoryListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CategoryListResponse copyWith(void Function(CategoryListResponse) updates) =>
      super.copyWith((message) => updates(message as CategoryListResponse))
          as CategoryListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CategoryListResponse() / CategoryListResponse.new instead')
  static CategoryListResponse create() => CategoryListResponse._();
  static $pb.GeneratedMessage $_createMessage() => CategoryListResponse._();
  @$core.override
  CategoryListResponse createEmptyInstance() => CategoryListResponse._();
  @$core.pragma('dart2js:noInline')
  static CategoryListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CategoryListResponse>(
          CategoryListResponse.$_createMessage);
  static CategoryListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Category> get categories => $_getList(0);

  @$pb.TagNumber(2)
  $1.PaginationResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.PaginationResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.PaginationResponse ensurePagination() => $_ensure(1);
}

class GetAllCategoriesRequest extends $pb.GeneratedMessage {
  factory GetAllCategoriesRequest({
    $core.bool? active,
  }) {
    final result = GetAllCategoriesRequest._();
    if (active != null) result.active = active;
    return result;
  }

  GetAllCategoriesRequest._();

  factory GetAllCategoriesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetAllCategoriesRequest()..mergeFromBuffer(data, registry);
  factory GetAllCategoriesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetAllCategoriesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAllCategoriesRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetAllCategoriesRequest.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'active')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAllCategoriesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAllCategoriesRequest copyWith(
          void Function(GetAllCategoriesRequest) updates) =>
      super.copyWith((message) => updates(message as GetAllCategoriesRequest))
          as GetAllCategoriesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetAllCategoriesRequest() / GetAllCategoriesRequest.new instead')
  static GetAllCategoriesRequest create() => GetAllCategoriesRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetAllCategoriesRequest._();
  @$core.override
  GetAllCategoriesRequest createEmptyInstance() => GetAllCategoriesRequest._();
  @$core.pragma('dart2js:noInline')
  static GetAllCategoriesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAllCategoriesRequest>(
          GetAllCategoriesRequest.$_createMessage);
  static GetAllCategoriesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get active => $_getBF(0);
  @$pb.TagNumber(1)
  set active($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasActive() => $_has(0);
  @$pb.TagNumber(1)
  void clearActive() => $_clearField(1);
}

class GetCategoryTreeRequest extends $pb.GeneratedMessage {
  factory GetCategoryTreeRequest() => GetCategoryTreeRequest._();

  GetCategoryTreeRequest._();

  factory GetCategoryTreeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCategoryTreeRequest()..mergeFromBuffer(data, registry);
  factory GetCategoryTreeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCategoryTreeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCategoryTreeRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetCategoryTreeRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCategoryTreeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCategoryTreeRequest copyWith(
          void Function(GetCategoryTreeRequest) updates) =>
      super.copyWith((message) => updates(message as GetCategoryTreeRequest))
          as GetCategoryTreeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetCategoryTreeRequest() / GetCategoryTreeRequest.new instead')
  static GetCategoryTreeRequest create() => GetCategoryTreeRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetCategoryTreeRequest._();
  @$core.override
  GetCategoryTreeRequest createEmptyInstance() => GetCategoryTreeRequest._();
  @$core.pragma('dart2js:noInline')
  static GetCategoryTreeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCategoryTreeRequest>(
          GetCategoryTreeRequest.$_createMessage);
  static GetCategoryTreeRequest? _defaultInstance;
}

class CategoryTreeResponse extends $pb.GeneratedMessage {
  factory CategoryTreeResponse({
    $core.Iterable<CategoryTree>? categories,
  }) {
    final result = CategoryTreeResponse._();
    if (categories != null) result.categories.addAll(categories);
    return result;
  }

  CategoryTreeResponse._();

  factory CategoryTreeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CategoryTreeResponse()..mergeFromBuffer(data, registry);
  factory CategoryTreeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CategoryTreeResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CategoryTreeResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: CategoryTreeResponse.$_createMessage)
    ..pPM<CategoryTree>(1, _omitFieldNames ? '' : 'categories',
        subBuilder: CategoryTree.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CategoryTreeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CategoryTreeResponse copyWith(void Function(CategoryTreeResponse) updates) =>
      super.copyWith((message) => updates(message as CategoryTreeResponse))
          as CategoryTreeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CategoryTreeResponse() / CategoryTreeResponse.new instead')
  static CategoryTreeResponse create() => CategoryTreeResponse._();
  static $pb.GeneratedMessage $_createMessage() => CategoryTreeResponse._();
  @$core.override
  CategoryTreeResponse createEmptyInstance() => CategoryTreeResponse._();
  @$core.pragma('dart2js:noInline')
  static CategoryTreeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CategoryTreeResponse>(
          CategoryTreeResponse.$_createMessage);
  static CategoryTreeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CategoryTree> get categories => $_getList(0);
}

class GetCategoriesWithCountsRequest extends $pb.GeneratedMessage {
  factory GetCategoriesWithCountsRequest({
    $core.bool? active,
  }) {
    final result = GetCategoriesWithCountsRequest._();
    if (active != null) result.active = active;
    return result;
  }

  GetCategoriesWithCountsRequest._();

  factory GetCategoriesWithCountsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCategoriesWithCountsRequest()..mergeFromBuffer(data, registry);
  factory GetCategoriesWithCountsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCategoriesWithCountsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCategoriesWithCountsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetCategoriesWithCountsRequest.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'active')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCategoriesWithCountsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCategoriesWithCountsRequest copyWith(
          void Function(GetCategoriesWithCountsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetCategoriesWithCountsRequest))
          as GetCategoriesWithCountsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetCategoriesWithCountsRequest() / GetCategoriesWithCountsRequest.new instead')
  static GetCategoriesWithCountsRequest create() =>
      GetCategoriesWithCountsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetCategoriesWithCountsRequest._();
  @$core.override
  GetCategoriesWithCountsRequest createEmptyInstance() =>
      GetCategoriesWithCountsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetCategoriesWithCountsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCategoriesWithCountsRequest>(
          GetCategoriesWithCountsRequest.$_createMessage);
  static GetCategoriesWithCountsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get active => $_getBF(0);
  @$pb.TagNumber(1)
  set active($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasActive() => $_has(0);
  @$pb.TagNumber(1)
  void clearActive() => $_clearField(1);
}

class CategoryWithCountsResponse extends $pb.GeneratedMessage {
  factory CategoryWithCountsResponse({
    $core.Iterable<CategoryWithCounts>? categories,
  }) {
    final result = CategoryWithCountsResponse._();
    if (categories != null) result.categories.addAll(categories);
    return result;
  }

  CategoryWithCountsResponse._();

  factory CategoryWithCountsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CategoryWithCountsResponse()..mergeFromBuffer(data, registry);
  factory CategoryWithCountsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CategoryWithCountsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CategoryWithCountsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: CategoryWithCountsResponse.$_createMessage)
    ..pPM<CategoryWithCounts>(1, _omitFieldNames ? '' : 'categories',
        subBuilder: CategoryWithCounts.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CategoryWithCountsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CategoryWithCountsResponse copyWith(
          void Function(CategoryWithCountsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CategoryWithCountsResponse))
          as CategoryWithCountsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CategoryWithCountsResponse() / CategoryWithCountsResponse.new instead')
  static CategoryWithCountsResponse create() => CategoryWithCountsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CategoryWithCountsResponse._();
  @$core.override
  CategoryWithCountsResponse createEmptyInstance() =>
      CategoryWithCountsResponse._();
  @$core.pragma('dart2js:noInline')
  static CategoryWithCountsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CategoryWithCountsResponse>(
          CategoryWithCountsResponse.$_createMessage);
  static CategoryWithCountsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CategoryWithCounts> get categories => $_getList(0);
}

class Category extends $pb.GeneratedMessage {
  factory Category({
    $core.String? id,
    $core.String? name,
    $core.String? slug,
    $core.String? description,
    $core.String? imageUrl,
    $core.bool? isActive,
    Category? parent,
    $core.Iterable<Category>? children,
    $core.String? createdAt,
    $core.String? updatedAt,
  }) {
    final result = Category._();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (slug != null) result.slug = slug;
    if (description != null) result.description = description;
    if (imageUrl != null) result.imageUrl = imageUrl;
    if (isActive != null) result.isActive = isActive;
    if (parent != null) result.parent = parent;
    if (children != null) result.children.addAll(children);
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  Category._();

  factory Category.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Category()..mergeFromBuffer(data, registry);
  factory Category.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Category()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Category',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: Category.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'slug')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOS(5, _omitFieldNames ? '' : 'imageUrl')
    ..aOB(6, _omitFieldNames ? '' : 'isActive')
    ..aOM<Category>(7, _omitFieldNames ? '' : 'parent',
        subBuilder: Category.$_createMessage)
    ..pPM<Category>(8, _omitFieldNames ? '' : 'children',
        subBuilder: Category.$_createMessage)
    ..aOS(9, _omitFieldNames ? '' : 'createdAt')
    ..aOS(10, _omitFieldNames ? '' : 'updatedAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Category clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Category copyWith(void Function(Category) updates) =>
      super.copyWith((message) => updates(message as Category)) as Category;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Category() / Category.new instead')
  static Category create() => Category._();
  static $pb.GeneratedMessage $_createMessage() => Category._();
  @$core.override
  Category createEmptyInstance() => Category._();
  @$core.pragma('dart2js:noInline')
  static Category getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Category>(Category.$_createMessage);
  static Category? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get slug => $_getSZ(2);
  @$pb.TagNumber(3)
  set slug($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSlug() => $_has(2);
  @$pb.TagNumber(3)
  void clearSlug() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get imageUrl => $_getSZ(4);
  @$pb.TagNumber(5)
  set imageUrl($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasImageUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearImageUrl() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isActive => $_getBF(5);
  @$pb.TagNumber(6)
  set isActive($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsActive() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsActive() => $_clearField(6);

  @$pb.TagNumber(7)
  Category get parent => $_getN(6);
  @$pb.TagNumber(7)
  set parent(Category value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasParent() => $_has(6);
  @$pb.TagNumber(7)
  void clearParent() => $_clearField(7);
  @$pb.TagNumber(7)
  Category ensureParent() => $_ensure(6);

  @$pb.TagNumber(8)
  $pb.PbList<Category> get children => $_getList(7);

  @$pb.TagNumber(9)
  $core.String get createdAt => $_getSZ(8);
  @$pb.TagNumber(9)
  set createdAt($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCreatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreatedAt() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get updatedAt => $_getSZ(9);
  @$pb.TagNumber(10)
  set updatedAt($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasUpdatedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearUpdatedAt() => $_clearField(10);
}

class CategoryTree extends $pb.GeneratedMessage {
  factory CategoryTree({
    Category? category,
    $core.Iterable<CategoryTree>? children,
  }) {
    final result = CategoryTree._();
    if (category != null) result.category = category;
    if (children != null) result.children.addAll(children);
    return result;
  }

  CategoryTree._();

  factory CategoryTree.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CategoryTree()..mergeFromBuffer(data, registry);
  factory CategoryTree.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CategoryTree()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CategoryTree',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: CategoryTree.$_createMessage)
    ..aOM<Category>(1, _omitFieldNames ? '' : 'category',
        subBuilder: Category.$_createMessage)
    ..pPM<CategoryTree>(2, _omitFieldNames ? '' : 'children',
        subBuilder: CategoryTree.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CategoryTree clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CategoryTree copyWith(void Function(CategoryTree) updates) =>
      super.copyWith((message) => updates(message as CategoryTree))
          as CategoryTree;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CategoryTree() / CategoryTree.new instead')
  static CategoryTree create() => CategoryTree._();
  static $pb.GeneratedMessage $_createMessage() => CategoryTree._();
  @$core.override
  CategoryTree createEmptyInstance() => CategoryTree._();
  @$core.pragma('dart2js:noInline')
  static CategoryTree getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CategoryTree>(
          CategoryTree.$_createMessage);
  static CategoryTree? _defaultInstance;

  @$pb.TagNumber(1)
  Category get category => $_getN(0);
  @$pb.TagNumber(1)
  set category(Category value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCategory() => $_has(0);
  @$pb.TagNumber(1)
  void clearCategory() => $_clearField(1);
  @$pb.TagNumber(1)
  Category ensureCategory() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<CategoryTree> get children => $_getList(1);
}

class CategoryWithCounts extends $pb.GeneratedMessage {
  factory CategoryWithCounts({
    Category? category,
    $core.int? catalogCount,
    $core.int? packageCount,
    $core.int? totalItems,
  }) {
    final result = CategoryWithCounts._();
    if (category != null) result.category = category;
    if (catalogCount != null) result.catalogCount = catalogCount;
    if (packageCount != null) result.packageCount = packageCount;
    if (totalItems != null) result.totalItems = totalItems;
    return result;
  }

  CategoryWithCounts._();

  factory CategoryWithCounts.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CategoryWithCounts()..mergeFromBuffer(data, registry);
  factory CategoryWithCounts.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CategoryWithCounts()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CategoryWithCounts',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: CategoryWithCounts.$_createMessage)
    ..aOM<Category>(1, _omitFieldNames ? '' : 'category',
        subBuilder: Category.$_createMessage)
    ..aI(2, _omitFieldNames ? '' : 'catalogCount')
    ..aI(3, _omitFieldNames ? '' : 'packageCount')
    ..aI(4, _omitFieldNames ? '' : 'totalItems')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CategoryWithCounts clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CategoryWithCounts copyWith(void Function(CategoryWithCounts) updates) =>
      super.copyWith((message) => updates(message as CategoryWithCounts))
          as CategoryWithCounts;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CategoryWithCounts() / CategoryWithCounts.new instead')
  static CategoryWithCounts create() => CategoryWithCounts._();
  static $pb.GeneratedMessage $_createMessage() => CategoryWithCounts._();
  @$core.override
  CategoryWithCounts createEmptyInstance() => CategoryWithCounts._();
  @$core.pragma('dart2js:noInline')
  static CategoryWithCounts getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CategoryWithCounts>(
          CategoryWithCounts.$_createMessage);
  static CategoryWithCounts? _defaultInstance;

  @$pb.TagNumber(1)
  Category get category => $_getN(0);
  @$pb.TagNumber(1)
  set category(Category value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCategory() => $_has(0);
  @$pb.TagNumber(1)
  void clearCategory() => $_clearField(1);
  @$pb.TagNumber(1)
  Category ensureCategory() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get catalogCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set catalogCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCatalogCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearCatalogCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get packageCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set packageCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPackageCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearPackageCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get totalItems => $_getIZ(3);
  @$pb.TagNumber(4)
  set totalItems($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTotalItems() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalItems() => $_clearField(4);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
