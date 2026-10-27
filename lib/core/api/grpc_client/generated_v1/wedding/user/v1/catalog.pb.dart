// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/catalog.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'auth.pb.dart' as $3;
import 'category.pb.dart' as $2;
import 'common.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GetCatalogRequest extends $pb.GeneratedMessage {
  factory GetCatalogRequest({
    $core.String? id,
  }) {
    final result = GetCatalogRequest._();
    if (id != null) result.id = id;
    return result;
  }

  GetCatalogRequest._();

  factory GetCatalogRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCatalogRequest()..mergeFromBuffer(data, registry);
  factory GetCatalogRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCatalogRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCatalogRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetCatalogRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCatalogRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCatalogRequest copyWith(void Function(GetCatalogRequest) updates) =>
      super.copyWith((message) => updates(message as GetCatalogRequest))
          as GetCatalogRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetCatalogRequest() / GetCatalogRequest.new instead')
  static GetCatalogRequest create() => GetCatalogRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetCatalogRequest._();
  @$core.override
  GetCatalogRequest createEmptyInstance() => GetCatalogRequest._();
  @$core.pragma('dart2js:noInline')
  static GetCatalogRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCatalogRequest>(
          GetCatalogRequest.$_createMessage);
  static GetCatalogRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class GetCatalogBySlugRequest extends $pb.GeneratedMessage {
  factory GetCatalogBySlugRequest({
    $core.String? slug,
  }) {
    final result = GetCatalogBySlugRequest._();
    if (slug != null) result.slug = slug;
    return result;
  }

  GetCatalogBySlugRequest._();

  factory GetCatalogBySlugRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCatalogBySlugRequest()..mergeFromBuffer(data, registry);
  factory GetCatalogBySlugRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCatalogBySlugRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCatalogBySlugRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetCatalogBySlugRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'slug')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCatalogBySlugRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCatalogBySlugRequest copyWith(
          void Function(GetCatalogBySlugRequest) updates) =>
      super.copyWith((message) => updates(message as GetCatalogBySlugRequest))
          as GetCatalogBySlugRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetCatalogBySlugRequest() / GetCatalogBySlugRequest.new instead')
  static GetCatalogBySlugRequest create() => GetCatalogBySlugRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetCatalogBySlugRequest._();
  @$core.override
  GetCatalogBySlugRequest createEmptyInstance() => GetCatalogBySlugRequest._();
  @$core.pragma('dart2js:noInline')
  static GetCatalogBySlugRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCatalogBySlugRequest>(
          GetCatalogBySlugRequest.$_createMessage);
  static GetCatalogBySlugRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get slug => $_getSZ(0);
  @$pb.TagNumber(1)
  set slug($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSlug() => $_has(0);
  @$pb.TagNumber(1)
  void clearSlug() => $_clearField(1);
}

class ListCatalogsRequest extends $pb.GeneratedMessage {
  factory ListCatalogsRequest({
    $1.PaginationRequest? pagination,
    $core.String? categoryId,
    $core.String? theme,
    $core.double? minPrice,
    $core.double? maxPrice,
    $core.String? search,
    $core.bool? active,
    $core.bool? withTierCount,
    $core.String? sortBy,
    $1.SortDirection? sortDirection,
  }) {
    final result = ListCatalogsRequest._();
    if (pagination != null) result.pagination = pagination;
    if (categoryId != null) result.categoryId = categoryId;
    if (theme != null) result.theme = theme;
    if (minPrice != null) result.minPrice = minPrice;
    if (maxPrice != null) result.maxPrice = maxPrice;
    if (search != null) result.search = search;
    if (active != null) result.active = active;
    if (withTierCount != null) result.withTierCount = withTierCount;
    if (sortBy != null) result.sortBy = sortBy;
    if (sortDirection != null) result.sortDirection = sortDirection;
    return result;
  }

  ListCatalogsRequest._();

  factory ListCatalogsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCatalogsRequest()..mergeFromBuffer(data, registry);
  factory ListCatalogsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCatalogsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCatalogsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ListCatalogsRequest.$_createMessage)
    ..aOM<$1.PaginationRequest>(1, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginationRequest.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'categoryId')
    ..aOS(3, _omitFieldNames ? '' : 'theme')
    ..aD(4, _omitFieldNames ? '' : 'minPrice')
    ..aD(5, _omitFieldNames ? '' : 'maxPrice')
    ..aOS(6, _omitFieldNames ? '' : 'search')
    ..aOB(7, _omitFieldNames ? '' : 'active')
    ..aOB(8, _omitFieldNames ? '' : 'withTierCount')
    ..aOS(9, _omitFieldNames ? '' : 'sortBy')
    ..aE<$1.SortDirection>(10, _omitFieldNames ? '' : 'sortDirection',
        enumValues: $1.SortDirection.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCatalogsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCatalogsRequest copyWith(void Function(ListCatalogsRequest) updates) =>
      super.copyWith((message) => updates(message as ListCatalogsRequest))
          as ListCatalogsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ListCatalogsRequest() / ListCatalogsRequest.new instead')
  static ListCatalogsRequest create() => ListCatalogsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListCatalogsRequest._();
  @$core.override
  ListCatalogsRequest createEmptyInstance() => ListCatalogsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListCatalogsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCatalogsRequest>(
          ListCatalogsRequest.$_createMessage);
  static ListCatalogsRequest? _defaultInstance;

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
  $core.String get categoryId => $_getSZ(1);
  @$pb.TagNumber(2)
  set categoryId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCategoryId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCategoryId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get theme => $_getSZ(2);
  @$pb.TagNumber(3)
  set theme($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTheme() => $_has(2);
  @$pb.TagNumber(3)
  void clearTheme() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get minPrice => $_getN(3);
  @$pb.TagNumber(4)
  set minPrice($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMinPrice() => $_has(3);
  @$pb.TagNumber(4)
  void clearMinPrice() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get maxPrice => $_getN(4);
  @$pb.TagNumber(5)
  set maxPrice($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMaxPrice() => $_has(4);
  @$pb.TagNumber(5)
  void clearMaxPrice() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get search => $_getSZ(5);
  @$pb.TagNumber(6)
  set search($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSearch() => $_has(5);
  @$pb.TagNumber(6)
  void clearSearch() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get active => $_getBF(6);
  @$pb.TagNumber(7)
  set active($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasActive() => $_has(6);
  @$pb.TagNumber(7)
  void clearActive() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get withTierCount => $_getBF(7);
  @$pb.TagNumber(8)
  set withTierCount($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasWithTierCount() => $_has(7);
  @$pb.TagNumber(8)
  void clearWithTierCount() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get sortBy => $_getSZ(8);
  @$pb.TagNumber(9)
  set sortBy($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSortBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearSortBy() => $_clearField(9);

  @$pb.TagNumber(10)
  $1.SortDirection get sortDirection => $_getN(9);
  @$pb.TagNumber(10)
  set sortDirection($1.SortDirection value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasSortDirection() => $_has(9);
  @$pb.TagNumber(10)
  void clearSortDirection() => $_clearField(10);
}

class CatalogListResponse extends $pb.GeneratedMessage {
  factory CatalogListResponse({
    $core.Iterable<Catalog>? catalogs,
    $1.PaginationResponse? pagination,
  }) {
    final result = CatalogListResponse._();
    if (catalogs != null) result.catalogs.addAll(catalogs);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  CatalogListResponse._();

  factory CatalogListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CatalogListResponse()..mergeFromBuffer(data, registry);
  factory CatalogListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CatalogListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CatalogListResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: CatalogListResponse.$_createMessage)
    ..pPM<Catalog>(1, _omitFieldNames ? '' : 'catalogs',
        subBuilder: Catalog.$_createMessage)
    ..aOM<$1.PaginationResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginationResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CatalogListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CatalogListResponse copyWith(void Function(CatalogListResponse) updates) =>
      super.copyWith((message) => updates(message as CatalogListResponse))
          as CatalogListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use CatalogListResponse() / CatalogListResponse.new instead')
  static CatalogListResponse create() => CatalogListResponse._();
  static $pb.GeneratedMessage $_createMessage() => CatalogListResponse._();
  @$core.override
  CatalogListResponse createEmptyInstance() => CatalogListResponse._();
  @$core.pragma('dart2js:noInline')
  static CatalogListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CatalogListResponse>(
          CatalogListResponse.$_createMessage);
  static CatalogListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Catalog> get catalogs => $_getList(0);

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

class GetFeaturedCatalogsRequest extends $pb.GeneratedMessage {
  factory GetFeaturedCatalogsRequest({
    $core.int? limit,
  }) {
    final result = GetFeaturedCatalogsRequest._();
    if (limit != null) result.limit = limit;
    return result;
  }

  GetFeaturedCatalogsRequest._();

  factory GetFeaturedCatalogsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetFeaturedCatalogsRequest()..mergeFromBuffer(data, registry);
  factory GetFeaturedCatalogsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetFeaturedCatalogsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFeaturedCatalogsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetFeaturedCatalogsRequest.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFeaturedCatalogsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFeaturedCatalogsRequest copyWith(
          void Function(GetFeaturedCatalogsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetFeaturedCatalogsRequest))
          as GetFeaturedCatalogsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetFeaturedCatalogsRequest() / GetFeaturedCatalogsRequest.new instead')
  static GetFeaturedCatalogsRequest create() => GetFeaturedCatalogsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetFeaturedCatalogsRequest._();
  @$core.override
  GetFeaturedCatalogsRequest createEmptyInstance() =>
      GetFeaturedCatalogsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetFeaturedCatalogsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetFeaturedCatalogsRequest>(
          GetFeaturedCatalogsRequest.$_createMessage);
  static GetFeaturedCatalogsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get limit => $_getIZ(0);
  @$pb.TagNumber(1)
  set limit($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLimit() => $_has(0);
  @$pb.TagNumber(1)
  void clearLimit() => $_clearField(1);
}

class GetOnSaleCatalogsRequest extends $pb.GeneratedMessage {
  factory GetOnSaleCatalogsRequest({
    $core.int? limit,
  }) {
    final result = GetOnSaleCatalogsRequest._();
    if (limit != null) result.limit = limit;
    return result;
  }

  GetOnSaleCatalogsRequest._();

  factory GetOnSaleCatalogsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetOnSaleCatalogsRequest()..mergeFromBuffer(data, registry);
  factory GetOnSaleCatalogsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetOnSaleCatalogsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetOnSaleCatalogsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetOnSaleCatalogsRequest.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOnSaleCatalogsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOnSaleCatalogsRequest copyWith(
          void Function(GetOnSaleCatalogsRequest) updates) =>
      super.copyWith((message) => updates(message as GetOnSaleCatalogsRequest))
          as GetOnSaleCatalogsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetOnSaleCatalogsRequest() / GetOnSaleCatalogsRequest.new instead')
  static GetOnSaleCatalogsRequest create() => GetOnSaleCatalogsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetOnSaleCatalogsRequest._();
  @$core.override
  GetOnSaleCatalogsRequest createEmptyInstance() =>
      GetOnSaleCatalogsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetOnSaleCatalogsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetOnSaleCatalogsRequest>(
          GetOnSaleCatalogsRequest.$_createMessage);
  static GetOnSaleCatalogsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get limit => $_getIZ(0);
  @$pb.TagNumber(1)
  set limit($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLimit() => $_has(0);
  @$pb.TagNumber(1)
  void clearLimit() => $_clearField(1);
}

class GetCatalogsByCategoryRequest extends $pb.GeneratedMessage {
  factory GetCatalogsByCategoryRequest({
    $core.String? categoryId,
    $core.int? limit,
  }) {
    final result = GetCatalogsByCategoryRequest._();
    if (categoryId != null) result.categoryId = categoryId;
    if (limit != null) result.limit = limit;
    return result;
  }

  GetCatalogsByCategoryRequest._();

  factory GetCatalogsByCategoryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCatalogsByCategoryRequest()..mergeFromBuffer(data, registry);
  factory GetCatalogsByCategoryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCatalogsByCategoryRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCatalogsByCategoryRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetCatalogsByCategoryRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'categoryId')
    ..aI(2, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCatalogsByCategoryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCatalogsByCategoryRequest copyWith(
          void Function(GetCatalogsByCategoryRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetCatalogsByCategoryRequest))
          as GetCatalogsByCategoryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetCatalogsByCategoryRequest() / GetCatalogsByCategoryRequest.new instead')
  static GetCatalogsByCategoryRequest create() =>
      GetCatalogsByCategoryRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetCatalogsByCategoryRequest._();
  @$core.override
  GetCatalogsByCategoryRequest createEmptyInstance() =>
      GetCatalogsByCategoryRequest._();
  @$core.pragma('dart2js:noInline')
  static GetCatalogsByCategoryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCatalogsByCategoryRequest>(
          GetCatalogsByCategoryRequest.$_createMessage);
  static GetCatalogsByCategoryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get categoryId => $_getSZ(0);
  @$pb.TagNumber(1)
  set categoryId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCategoryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCategoryId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => $_clearField(2);
}

class GetRelatedCatalogsRequest extends $pb.GeneratedMessage {
  factory GetRelatedCatalogsRequest({
    $core.String? catalogId,
    $core.int? limit,
  }) {
    final result = GetRelatedCatalogsRequest._();
    if (catalogId != null) result.catalogId = catalogId;
    if (limit != null) result.limit = limit;
    return result;
  }

  GetRelatedCatalogsRequest._();

  factory GetRelatedCatalogsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetRelatedCatalogsRequest()..mergeFromBuffer(data, registry);
  factory GetRelatedCatalogsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetRelatedCatalogsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRelatedCatalogsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetRelatedCatalogsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'catalogId')
    ..aI(2, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRelatedCatalogsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRelatedCatalogsRequest copyWith(
          void Function(GetRelatedCatalogsRequest) updates) =>
      super.copyWith((message) => updates(message as GetRelatedCatalogsRequest))
          as GetRelatedCatalogsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetRelatedCatalogsRequest() / GetRelatedCatalogsRequest.new instead')
  static GetRelatedCatalogsRequest create() => GetRelatedCatalogsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetRelatedCatalogsRequest._();
  @$core.override
  GetRelatedCatalogsRequest createEmptyInstance() =>
      GetRelatedCatalogsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetRelatedCatalogsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRelatedCatalogsRequest>(
          GetRelatedCatalogsRequest.$_createMessage);
  static GetRelatedCatalogsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get catalogId => $_getSZ(0);
  @$pb.TagNumber(1)
  set catalogId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCatalogId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCatalogId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => $_clearField(2);
}

class SearchCatalogsRequest extends $pb.GeneratedMessage {
  factory SearchCatalogsRequest({
    $core.String? query,
    $core.int? limit,
  }) {
    final result = SearchCatalogsRequest._();
    if (query != null) result.query = query;
    if (limit != null) result.limit = limit;
    return result;
  }

  SearchCatalogsRequest._();

  factory SearchCatalogsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchCatalogsRequest()..mergeFromBuffer(data, registry);
  factory SearchCatalogsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchCatalogsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchCatalogsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: SearchCatalogsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'query')
    ..aI(2, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchCatalogsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchCatalogsRequest copyWith(
          void Function(SearchCatalogsRequest) updates) =>
      super.copyWith((message) => updates(message as SearchCatalogsRequest))
          as SearchCatalogsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SearchCatalogsRequest() / SearchCatalogsRequest.new instead')
  static SearchCatalogsRequest create() => SearchCatalogsRequest._();
  static $pb.GeneratedMessage $_createMessage() => SearchCatalogsRequest._();
  @$core.override
  SearchCatalogsRequest createEmptyInstance() => SearchCatalogsRequest._();
  @$core.pragma('dart2js:noInline')
  static SearchCatalogsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchCatalogsRequest>(
          SearchCatalogsRequest.$_createMessage);
  static SearchCatalogsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get query => $_getSZ(0);
  @$pb.TagNumber(1)
  set query($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQuery() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuery() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => $_clearField(2);
}

class GetCatalogTiersRequest extends $pb.GeneratedMessage {
  factory GetCatalogTiersRequest({
    $core.String? catalogId,
  }) {
    final result = GetCatalogTiersRequest._();
    if (catalogId != null) result.catalogId = catalogId;
    return result;
  }

  GetCatalogTiersRequest._();

  factory GetCatalogTiersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCatalogTiersRequest()..mergeFromBuffer(data, registry);
  factory GetCatalogTiersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCatalogTiersRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCatalogTiersRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetCatalogTiersRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'catalogId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCatalogTiersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCatalogTiersRequest copyWith(
          void Function(GetCatalogTiersRequest) updates) =>
      super.copyWith((message) => updates(message as GetCatalogTiersRequest))
          as GetCatalogTiersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetCatalogTiersRequest() / GetCatalogTiersRequest.new instead')
  static GetCatalogTiersRequest create() => GetCatalogTiersRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetCatalogTiersRequest._();
  @$core.override
  GetCatalogTiersRequest createEmptyInstance() => GetCatalogTiersRequest._();
  @$core.pragma('dart2js:noInline')
  static GetCatalogTiersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCatalogTiersRequest>(
          GetCatalogTiersRequest.$_createMessage);
  static GetCatalogTiersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get catalogId => $_getSZ(0);
  @$pb.TagNumber(1)
  set catalogId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCatalogId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCatalogId() => $_clearField(1);
}

class GetCatalogStatsRequest extends $pb.GeneratedMessage {
  factory GetCatalogStatsRequest() => GetCatalogStatsRequest._();

  GetCatalogStatsRequest._();

  factory GetCatalogStatsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCatalogStatsRequest()..mergeFromBuffer(data, registry);
  factory GetCatalogStatsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCatalogStatsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCatalogStatsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetCatalogStatsRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCatalogStatsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCatalogStatsRequest copyWith(
          void Function(GetCatalogStatsRequest) updates) =>
      super.copyWith((message) => updates(message as GetCatalogStatsRequest))
          as GetCatalogStatsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetCatalogStatsRequest() / GetCatalogStatsRequest.new instead')
  static GetCatalogStatsRequest create() => GetCatalogStatsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetCatalogStatsRequest._();
  @$core.override
  GetCatalogStatsRequest createEmptyInstance() => GetCatalogStatsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetCatalogStatsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCatalogStatsRequest>(
          GetCatalogStatsRequest.$_createMessage);
  static GetCatalogStatsRequest? _defaultInstance;
}

class CatalogStats extends $pb.GeneratedMessage {
  factory CatalogStats({
    $core.int? totalCatalogs,
    $core.int? activeCatalogs,
    $core.int? featuredCatalogs,
    $core.int? outOfStockCatalogs,
    $core.int? lowStockCatalogs,
    $core.double? totalValue,
    $core.Iterable<CategoryCatalogCount>? byCategory,
  }) {
    final result = CatalogStats._();
    if (totalCatalogs != null) result.totalCatalogs = totalCatalogs;
    if (activeCatalogs != null) result.activeCatalogs = activeCatalogs;
    if (featuredCatalogs != null) result.featuredCatalogs = featuredCatalogs;
    if (outOfStockCatalogs != null)
      result.outOfStockCatalogs = outOfStockCatalogs;
    if (lowStockCatalogs != null) result.lowStockCatalogs = lowStockCatalogs;
    if (totalValue != null) result.totalValue = totalValue;
    if (byCategory != null) result.byCategory.addAll(byCategory);
    return result;
  }

  CatalogStats._();

  factory CatalogStats.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CatalogStats()..mergeFromBuffer(data, registry);
  factory CatalogStats.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CatalogStats()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CatalogStats',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: CatalogStats.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'totalCatalogs')
    ..aI(2, _omitFieldNames ? '' : 'activeCatalogs')
    ..aI(3, _omitFieldNames ? '' : 'featuredCatalogs')
    ..aI(4, _omitFieldNames ? '' : 'outOfStockCatalogs')
    ..aI(5, _omitFieldNames ? '' : 'lowStockCatalogs')
    ..aD(6, _omitFieldNames ? '' : 'totalValue')
    ..pPM<CategoryCatalogCount>(7, _omitFieldNames ? '' : 'byCategory',
        subBuilder: CategoryCatalogCount.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CatalogStats clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CatalogStats copyWith(void Function(CatalogStats) updates) =>
      super.copyWith((message) => updates(message as CatalogStats))
          as CatalogStats;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CatalogStats() / CatalogStats.new instead')
  static CatalogStats create() => CatalogStats._();
  static $pb.GeneratedMessage $_createMessage() => CatalogStats._();
  @$core.override
  CatalogStats createEmptyInstance() => CatalogStats._();
  @$core.pragma('dart2js:noInline')
  static CatalogStats getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CatalogStats>(
          CatalogStats.$_createMessage);
  static CatalogStats? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get totalCatalogs => $_getIZ(0);
  @$pb.TagNumber(1)
  set totalCatalogs($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotalCatalogs() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalCatalogs() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get activeCatalogs => $_getIZ(1);
  @$pb.TagNumber(2)
  set activeCatalogs($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasActiveCatalogs() => $_has(1);
  @$pb.TagNumber(2)
  void clearActiveCatalogs() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get featuredCatalogs => $_getIZ(2);
  @$pb.TagNumber(3)
  set featuredCatalogs($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFeaturedCatalogs() => $_has(2);
  @$pb.TagNumber(3)
  void clearFeaturedCatalogs() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get outOfStockCatalogs => $_getIZ(3);
  @$pb.TagNumber(4)
  set outOfStockCatalogs($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOutOfStockCatalogs() => $_has(3);
  @$pb.TagNumber(4)
  void clearOutOfStockCatalogs() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get lowStockCatalogs => $_getIZ(4);
  @$pb.TagNumber(5)
  set lowStockCatalogs($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLowStockCatalogs() => $_has(4);
  @$pb.TagNumber(5)
  void clearLowStockCatalogs() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get totalValue => $_getN(5);
  @$pb.TagNumber(6)
  set totalValue($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTotalValue() => $_has(5);
  @$pb.TagNumber(6)
  void clearTotalValue() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<CategoryCatalogCount> get byCategory => $_getList(6);
}

class CategoryCatalogCount extends $pb.GeneratedMessage {
  factory CategoryCatalogCount({
    $2.Category? category,
    $core.int? count,
  }) {
    final result = CategoryCatalogCount._();
    if (category != null) result.category = category;
    if (count != null) result.count = count;
    return result;
  }

  CategoryCatalogCount._();

  factory CategoryCatalogCount.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CategoryCatalogCount()..mergeFromBuffer(data, registry);
  factory CategoryCatalogCount.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CategoryCatalogCount()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CategoryCatalogCount',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: CategoryCatalogCount.$_createMessage)
    ..aOM<$2.Category>(1, _omitFieldNames ? '' : 'category',
        subBuilder: $2.Category.$_createMessage)
    ..aI(2, _omitFieldNames ? '' : 'count')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CategoryCatalogCount clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CategoryCatalogCount copyWith(void Function(CategoryCatalogCount) updates) =>
      super.copyWith((message) => updates(message as CategoryCatalogCount))
          as CategoryCatalogCount;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CategoryCatalogCount() / CategoryCatalogCount.new instead')
  static CategoryCatalogCount create() => CategoryCatalogCount._();
  static $pb.GeneratedMessage $_createMessage() => CategoryCatalogCount._();
  @$core.override
  CategoryCatalogCount createEmptyInstance() => CategoryCatalogCount._();
  @$core.pragma('dart2js:noInline')
  static CategoryCatalogCount getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CategoryCatalogCount>(
          CategoryCatalogCount.$_createMessage);
  static CategoryCatalogCount? _defaultInstance;

  @$pb.TagNumber(1)
  $2.Category get category => $_getN(0);
  @$pb.TagNumber(1)
  set category($2.Category value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCategory() => $_has(0);
  @$pb.TagNumber(1)
  void clearCategory() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.Category ensureCategory() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get count => $_getIZ(1);
  @$pb.TagNumber(2)
  set count($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearCount() => $_clearField(2);
}

class Catalog extends $pb.GeneratedMessage {
  factory Catalog({
    $core.String? id,
    $core.String? name,
    $core.String? slug,
    $core.String? description,
    $core.double? price,
    $core.double? discountPrice,
    $core.double? finalPrice,
    $core.int? stock,
    $core.bool? isActive,
    $core.bool? isFeatured,
    $core.bool? isOutOfStock,
    $core.String? imageUrl,
    $core.String? videoUrl,
    $core.Iterable<$core.String>? features,
    $core.String? theme,
    $core.String? color,
    $core.int? minCapacity,
    $core.int? maxCapacity,
    $2.Category? category,
    $core.double? averageRating,
    $core.Iterable<Review>? reviews,
    $core.Iterable<CatalogTier>? tiers,
    $core.String? createdAt,
    $core.String? updatedAt,
  }) {
    final result = Catalog._();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (slug != null) result.slug = slug;
    if (description != null) result.description = description;
    if (price != null) result.price = price;
    if (discountPrice != null) result.discountPrice = discountPrice;
    if (finalPrice != null) result.finalPrice = finalPrice;
    if (stock != null) result.stock = stock;
    if (isActive != null) result.isActive = isActive;
    if (isFeatured != null) result.isFeatured = isFeatured;
    if (isOutOfStock != null) result.isOutOfStock = isOutOfStock;
    if (imageUrl != null) result.imageUrl = imageUrl;
    if (videoUrl != null) result.videoUrl = videoUrl;
    if (features != null) result.features.addAll(features);
    if (theme != null) result.theme = theme;
    if (color != null) result.color = color;
    if (minCapacity != null) result.minCapacity = minCapacity;
    if (maxCapacity != null) result.maxCapacity = maxCapacity;
    if (category != null) result.category = category;
    if (averageRating != null) result.averageRating = averageRating;
    if (reviews != null) result.reviews.addAll(reviews);
    if (tiers != null) result.tiers.addAll(tiers);
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  Catalog._();

  factory Catalog.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Catalog()..mergeFromBuffer(data, registry);
  factory Catalog.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Catalog()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Catalog',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: Catalog.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'slug')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aD(5, _omitFieldNames ? '' : 'price')
    ..aD(6, _omitFieldNames ? '' : 'discountPrice')
    ..aD(7, _omitFieldNames ? '' : 'finalPrice')
    ..aI(8, _omitFieldNames ? '' : 'stock')
    ..aOB(9, _omitFieldNames ? '' : 'isActive')
    ..aOB(10, _omitFieldNames ? '' : 'isFeatured')
    ..aOB(11, _omitFieldNames ? '' : 'isOutOfStock')
    ..aOS(12, _omitFieldNames ? '' : 'imageUrl')
    ..aOS(13, _omitFieldNames ? '' : 'videoUrl')
    ..pPS(14, _omitFieldNames ? '' : 'features')
    ..aOS(15, _omitFieldNames ? '' : 'theme')
    ..aOS(16, _omitFieldNames ? '' : 'color')
    ..aI(17, _omitFieldNames ? '' : 'minCapacity')
    ..aI(18, _omitFieldNames ? '' : 'maxCapacity')
    ..aOM<$2.Category>(19, _omitFieldNames ? '' : 'category',
        subBuilder: $2.Category.$_createMessage)
    ..aD(20, _omitFieldNames ? '' : 'averageRating')
    ..pPM<Review>(21, _omitFieldNames ? '' : 'reviews',
        subBuilder: Review.$_createMessage)
    ..pPM<CatalogTier>(22, _omitFieldNames ? '' : 'tiers',
        subBuilder: CatalogTier.$_createMessage)
    ..aOS(23, _omitFieldNames ? '' : 'createdAt')
    ..aOS(24, _omitFieldNames ? '' : 'updatedAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Catalog clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Catalog copyWith(void Function(Catalog) updates) =>
      super.copyWith((message) => updates(message as Catalog)) as Catalog;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Catalog() / Catalog.new instead')
  static Catalog create() => Catalog._();
  static $pb.GeneratedMessage $_createMessage() => Catalog._();
  @$core.override
  Catalog createEmptyInstance() => Catalog._();
  @$core.pragma('dart2js:noInline')
  static Catalog getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Catalog>(Catalog.$_createMessage);
  static Catalog? _defaultInstance;

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
  $core.double get price => $_getN(4);
  @$pb.TagNumber(5)
  set price($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPrice() => $_has(4);
  @$pb.TagNumber(5)
  void clearPrice() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get discountPrice => $_getN(5);
  @$pb.TagNumber(6)
  set discountPrice($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDiscountPrice() => $_has(5);
  @$pb.TagNumber(6)
  void clearDiscountPrice() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get finalPrice => $_getN(6);
  @$pb.TagNumber(7)
  set finalPrice($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFinalPrice() => $_has(6);
  @$pb.TagNumber(7)
  void clearFinalPrice() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get stock => $_getIZ(7);
  @$pb.TagNumber(8)
  set stock($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasStock() => $_has(7);
  @$pb.TagNumber(8)
  void clearStock() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get isActive => $_getBF(8);
  @$pb.TagNumber(9)
  set isActive($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasIsActive() => $_has(8);
  @$pb.TagNumber(9)
  void clearIsActive() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get isFeatured => $_getBF(9);
  @$pb.TagNumber(10)
  set isFeatured($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasIsFeatured() => $_has(9);
  @$pb.TagNumber(10)
  void clearIsFeatured() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get isOutOfStock => $_getBF(10);
  @$pb.TagNumber(11)
  set isOutOfStock($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasIsOutOfStock() => $_has(10);
  @$pb.TagNumber(11)
  void clearIsOutOfStock() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get imageUrl => $_getSZ(11);
  @$pb.TagNumber(12)
  set imageUrl($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasImageUrl() => $_has(11);
  @$pb.TagNumber(12)
  void clearImageUrl() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get videoUrl => $_getSZ(12);
  @$pb.TagNumber(13)
  set videoUrl($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasVideoUrl() => $_has(12);
  @$pb.TagNumber(13)
  void clearVideoUrl() => $_clearField(13);

  @$pb.TagNumber(14)
  $pb.PbList<$core.String> get features => $_getList(13);

  @$pb.TagNumber(15)
  $core.String get theme => $_getSZ(14);
  @$pb.TagNumber(15)
  set theme($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasTheme() => $_has(14);
  @$pb.TagNumber(15)
  void clearTheme() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get color => $_getSZ(15);
  @$pb.TagNumber(16)
  set color($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasColor() => $_has(15);
  @$pb.TagNumber(16)
  void clearColor() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.int get minCapacity => $_getIZ(16);
  @$pb.TagNumber(17)
  set minCapacity($core.int value) => $_setSignedInt32(16, value);
  @$pb.TagNumber(17)
  $core.bool hasMinCapacity() => $_has(16);
  @$pb.TagNumber(17)
  void clearMinCapacity() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.int get maxCapacity => $_getIZ(17);
  @$pb.TagNumber(18)
  set maxCapacity($core.int value) => $_setSignedInt32(17, value);
  @$pb.TagNumber(18)
  $core.bool hasMaxCapacity() => $_has(17);
  @$pb.TagNumber(18)
  void clearMaxCapacity() => $_clearField(18);

  @$pb.TagNumber(19)
  $2.Category get category => $_getN(18);
  @$pb.TagNumber(19)
  set category($2.Category value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasCategory() => $_has(18);
  @$pb.TagNumber(19)
  void clearCategory() => $_clearField(19);
  @$pb.TagNumber(19)
  $2.Category ensureCategory() => $_ensure(18);

  @$pb.TagNumber(20)
  $core.double get averageRating => $_getN(19);
  @$pb.TagNumber(20)
  set averageRating($core.double value) => $_setDouble(19, value);
  @$pb.TagNumber(20)
  $core.bool hasAverageRating() => $_has(19);
  @$pb.TagNumber(20)
  void clearAverageRating() => $_clearField(20);

  @$pb.TagNumber(21)
  $pb.PbList<Review> get reviews => $_getList(20);

  @$pb.TagNumber(22)
  $pb.PbList<CatalogTier> get tiers => $_getList(21);

  @$pb.TagNumber(23)
  $core.String get createdAt => $_getSZ(22);
  @$pb.TagNumber(23)
  set createdAt($core.String value) => $_setString(22, value);
  @$pb.TagNumber(23)
  $core.bool hasCreatedAt() => $_has(22);
  @$pb.TagNumber(23)
  void clearCreatedAt() => $_clearField(23);

  @$pb.TagNumber(24)
  $core.String get updatedAt => $_getSZ(23);
  @$pb.TagNumber(24)
  set updatedAt($core.String value) => $_setString(23, value);
  @$pb.TagNumber(24)
  $core.bool hasUpdatedAt() => $_has(23);
  @$pb.TagNumber(24)
  void clearUpdatedAt() => $_clearField(24);
}

class CatalogTier extends $pb.GeneratedMessage {
  factory CatalogTier({
    $core.String? id,
    $core.String? catalogId,
    $core.String? name,
    $core.String? description,
    $core.double? price,
    $core.double? discountPrice,
    $core.double? finalPrice,
    $core.int? stock,
    $core.Iterable<$core.String>? features,
    $core.int? sortOrder,
    $core.String? imageUrl,
  }) {
    final result = CatalogTier._();
    if (id != null) result.id = id;
    if (catalogId != null) result.catalogId = catalogId;
    if (name != null) result.name = name;
    if (description != null) result.description = description;
    if (price != null) result.price = price;
    if (discountPrice != null) result.discountPrice = discountPrice;
    if (finalPrice != null) result.finalPrice = finalPrice;
    if (stock != null) result.stock = stock;
    if (features != null) result.features.addAll(features);
    if (sortOrder != null) result.sortOrder = sortOrder;
    if (imageUrl != null) result.imageUrl = imageUrl;
    return result;
  }

  CatalogTier._();

  factory CatalogTier.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CatalogTier()..mergeFromBuffer(data, registry);
  factory CatalogTier.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CatalogTier()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CatalogTier',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: CatalogTier.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'catalogId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aD(5, _omitFieldNames ? '' : 'price')
    ..aD(6, _omitFieldNames ? '' : 'discountPrice')
    ..aD(7, _omitFieldNames ? '' : 'finalPrice')
    ..aI(8, _omitFieldNames ? '' : 'stock')
    ..pPS(9, _omitFieldNames ? '' : 'features')
    ..aI(10, _omitFieldNames ? '' : 'sortOrder')
    ..aOS(11, _omitFieldNames ? '' : 'imageUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CatalogTier clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CatalogTier copyWith(void Function(CatalogTier) updates) =>
      super.copyWith((message) => updates(message as CatalogTier))
          as CatalogTier;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CatalogTier() / CatalogTier.new instead')
  static CatalogTier create() => CatalogTier._();
  static $pb.GeneratedMessage $_createMessage() => CatalogTier._();
  @$core.override
  CatalogTier createEmptyInstance() => CatalogTier._();
  @$core.pragma('dart2js:noInline')
  static CatalogTier getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CatalogTier>(
          CatalogTier.$_createMessage);
  static CatalogTier? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get catalogId => $_getSZ(1);
  @$pb.TagNumber(2)
  set catalogId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCatalogId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCatalogId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get price => $_getN(4);
  @$pb.TagNumber(5)
  set price($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPrice() => $_has(4);
  @$pb.TagNumber(5)
  void clearPrice() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get discountPrice => $_getN(5);
  @$pb.TagNumber(6)
  set discountPrice($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDiscountPrice() => $_has(5);
  @$pb.TagNumber(6)
  void clearDiscountPrice() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get finalPrice => $_getN(6);
  @$pb.TagNumber(7)
  set finalPrice($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFinalPrice() => $_has(6);
  @$pb.TagNumber(7)
  void clearFinalPrice() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get stock => $_getIZ(7);
  @$pb.TagNumber(8)
  set stock($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasStock() => $_has(7);
  @$pb.TagNumber(8)
  void clearStock() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get features => $_getList(8);

  @$pb.TagNumber(10)
  $core.int get sortOrder => $_getIZ(9);
  @$pb.TagNumber(10)
  set sortOrder($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasSortOrder() => $_has(9);
  @$pb.TagNumber(10)
  void clearSortOrder() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get imageUrl => $_getSZ(10);
  @$pb.TagNumber(11)
  set imageUrl($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasImageUrl() => $_has(10);
  @$pb.TagNumber(11)
  void clearImageUrl() => $_clearField(11);
}

class Review extends $pb.GeneratedMessage {
  factory Review({
    $core.String? id,
    $core.String? userId,
    $core.String? catalogId,
    $core.String? packageId,
    $core.int? rating,
    $core.String? title,
    $core.String? comment,
    $core.Iterable<$core.String>? photos,
    $core.int? helpfulCount,
    $core.bool? isAnonymous,
    $core.bool? isVerifiedPurchase,
    $1.ReviewStatus? status,
    ReviewReply? reply,
    $core.String? createdAt,
    $core.String? updatedAt,
  }) {
    final result = Review._();
    if (id != null) result.id = id;
    if (userId != null) result.userId = userId;
    if (catalogId != null) result.catalogId = catalogId;
    if (packageId != null) result.packageId = packageId;
    if (rating != null) result.rating = rating;
    if (title != null) result.title = title;
    if (comment != null) result.comment = comment;
    if (photos != null) result.photos.addAll(photos);
    if (helpfulCount != null) result.helpfulCount = helpfulCount;
    if (isAnonymous != null) result.isAnonymous = isAnonymous;
    if (isVerifiedPurchase != null)
      result.isVerifiedPurchase = isVerifiedPurchase;
    if (status != null) result.status = status;
    if (reply != null) result.reply = reply;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  Review._();

  factory Review.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Review()..mergeFromBuffer(data, registry);
  factory Review.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Review()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Review',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: Review.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..aOS(3, _omitFieldNames ? '' : 'catalogId')
    ..aOS(4, _omitFieldNames ? '' : 'packageId')
    ..aI(5, _omitFieldNames ? '' : 'rating')
    ..aOS(6, _omitFieldNames ? '' : 'title')
    ..aOS(7, _omitFieldNames ? '' : 'comment')
    ..pPS(8, _omitFieldNames ? '' : 'photos')
    ..aI(9, _omitFieldNames ? '' : 'helpfulCount')
    ..aOB(10, _omitFieldNames ? '' : 'isAnonymous')
    ..aOB(11, _omitFieldNames ? '' : 'isVerifiedPurchase')
    ..aE<$1.ReviewStatus>(12, _omitFieldNames ? '' : 'status',
        enumValues: $1.ReviewStatus.values)
    ..aOM<ReviewReply>(13, _omitFieldNames ? '' : 'reply',
        subBuilder: ReviewReply.$_createMessage)
    ..aOS(14, _omitFieldNames ? '' : 'createdAt')
    ..aOS(15, _omitFieldNames ? '' : 'updatedAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Review clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Review copyWith(void Function(Review) updates) =>
      super.copyWith((message) => updates(message as Review)) as Review;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Review() / Review.new instead')
  static Review create() => Review._();
  static $pb.GeneratedMessage $_createMessage() => Review._();
  @$core.override
  Review createEmptyInstance() => Review._();
  @$core.pragma('dart2js:noInline')
  static Review getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Review>(Review.$_createMessage);
  static Review? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get catalogId => $_getSZ(2);
  @$pb.TagNumber(3)
  set catalogId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCatalogId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCatalogId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get packageId => $_getSZ(3);
  @$pb.TagNumber(4)
  set packageId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPackageId() => $_has(3);
  @$pb.TagNumber(4)
  void clearPackageId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get rating => $_getIZ(4);
  @$pb.TagNumber(5)
  set rating($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRating() => $_has(4);
  @$pb.TagNumber(5)
  void clearRating() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get title => $_getSZ(5);
  @$pb.TagNumber(6)
  set title($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTitle() => $_has(5);
  @$pb.TagNumber(6)
  void clearTitle() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get comment => $_getSZ(6);
  @$pb.TagNumber(7)
  set comment($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasComment() => $_has(6);
  @$pb.TagNumber(7)
  void clearComment() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get photos => $_getList(7);

  @$pb.TagNumber(9)
  $core.int get helpfulCount => $_getIZ(8);
  @$pb.TagNumber(9)
  set helpfulCount($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasHelpfulCount() => $_has(8);
  @$pb.TagNumber(9)
  void clearHelpfulCount() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get isAnonymous => $_getBF(9);
  @$pb.TagNumber(10)
  set isAnonymous($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasIsAnonymous() => $_has(9);
  @$pb.TagNumber(10)
  void clearIsAnonymous() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get isVerifiedPurchase => $_getBF(10);
  @$pb.TagNumber(11)
  set isVerifiedPurchase($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasIsVerifiedPurchase() => $_has(10);
  @$pb.TagNumber(11)
  void clearIsVerifiedPurchase() => $_clearField(11);

  @$pb.TagNumber(12)
  $1.ReviewStatus get status => $_getN(11);
  @$pb.TagNumber(12)
  set status($1.ReviewStatus value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasStatus() => $_has(11);
  @$pb.TagNumber(12)
  void clearStatus() => $_clearField(12);

  @$pb.TagNumber(13)
  ReviewReply get reply => $_getN(12);
  @$pb.TagNumber(13)
  set reply(ReviewReply value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasReply() => $_has(12);
  @$pb.TagNumber(13)
  void clearReply() => $_clearField(13);
  @$pb.TagNumber(13)
  ReviewReply ensureReply() => $_ensure(12);

  @$pb.TagNumber(14)
  $core.String get createdAt => $_getSZ(13);
  @$pb.TagNumber(14)
  set createdAt($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasCreatedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearCreatedAt() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get updatedAt => $_getSZ(14);
  @$pb.TagNumber(15)
  set updatedAt($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasUpdatedAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearUpdatedAt() => $_clearField(15);
}

class ReviewReply extends $pb.GeneratedMessage {
  factory ReviewReply({
    $core.String? id,
    $core.String? reviewId,
    $core.String? content,
    $3.User? createdBy,
    $core.String? createdAt,
  }) {
    final result = ReviewReply._();
    if (id != null) result.id = id;
    if (reviewId != null) result.reviewId = reviewId;
    if (content != null) result.content = content;
    if (createdBy != null) result.createdBy = createdBy;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  ReviewReply._();

  factory ReviewReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReviewReply()..mergeFromBuffer(data, registry);
  factory ReviewReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReviewReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReviewReply',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ReviewReply.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'reviewId')
    ..aOS(3, _omitFieldNames ? '' : 'content')
    ..aOM<$3.User>(4, _omitFieldNames ? '' : 'createdBy',
        subBuilder: $3.User.$_createMessage)
    ..aOS(5, _omitFieldNames ? '' : 'createdAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewReply copyWith(void Function(ReviewReply) updates) =>
      super.copyWith((message) => updates(message as ReviewReply))
          as ReviewReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ReviewReply() / ReviewReply.new instead')
  static ReviewReply create() => ReviewReply._();
  static $pb.GeneratedMessage $_createMessage() => ReviewReply._();
  @$core.override
  ReviewReply createEmptyInstance() => ReviewReply._();
  @$core.pragma('dart2js:noInline')
  static ReviewReply getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReviewReply>(
          ReviewReply.$_createMessage);
  static ReviewReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reviewId => $_getSZ(1);
  @$pb.TagNumber(2)
  set reviewId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReviewId() => $_has(1);
  @$pb.TagNumber(2)
  void clearReviewId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get content => $_getSZ(2);
  @$pb.TagNumber(3)
  set content($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasContent() => $_has(2);
  @$pb.TagNumber(3)
  void clearContent() => $_clearField(3);

  @$pb.TagNumber(4)
  $3.User get createdBy => $_getN(3);
  @$pb.TagNumber(4)
  set createdBy($3.User value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCreatedBy() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreatedBy() => $_clearField(4);
  @$pb.TagNumber(4)
  $3.User ensureCreatedBy() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get createdAt => $_getSZ(4);
  @$pb.TagNumber(5)
  set createdAt($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCreatedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreatedAt() => $_clearField(5);
}

class CatalogTiersResponse extends $pb.GeneratedMessage {
  factory CatalogTiersResponse({
    $core.Iterable<CatalogTier>? tiers,
    CatalogMeta? meta,
  }) {
    final result = CatalogTiersResponse._();
    if (tiers != null) result.tiers.addAll(tiers);
    if (meta != null) result.meta = meta;
    return result;
  }

  CatalogTiersResponse._();

  factory CatalogTiersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CatalogTiersResponse()..mergeFromBuffer(data, registry);
  factory CatalogTiersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CatalogTiersResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CatalogTiersResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: CatalogTiersResponse.$_createMessage)
    ..pPM<CatalogTier>(1, _omitFieldNames ? '' : 'tiers',
        subBuilder: CatalogTier.$_createMessage)
    ..aOM<CatalogMeta>(2, _omitFieldNames ? '' : 'meta',
        subBuilder: CatalogMeta.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CatalogTiersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CatalogTiersResponse copyWith(void Function(CatalogTiersResponse) updates) =>
      super.copyWith((message) => updates(message as CatalogTiersResponse))
          as CatalogTiersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CatalogTiersResponse() / CatalogTiersResponse.new instead')
  static CatalogTiersResponse create() => CatalogTiersResponse._();
  static $pb.GeneratedMessage $_createMessage() => CatalogTiersResponse._();
  @$core.override
  CatalogTiersResponse createEmptyInstance() => CatalogTiersResponse._();
  @$core.pragma('dart2js:noInline')
  static CatalogTiersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CatalogTiersResponse>(
          CatalogTiersResponse.$_createMessage);
  static CatalogTiersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CatalogTier> get tiers => $_getList(0);

  @$pb.TagNumber(2)
  CatalogMeta get meta => $_getN(1);
  @$pb.TagNumber(2)
  set meta(CatalogMeta value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMeta() => $_has(1);
  @$pb.TagNumber(2)
  void clearMeta() => $_clearField(2);
  @$pb.TagNumber(2)
  CatalogMeta ensureMeta() => $_ensure(1);
}

class CatalogMeta extends $pb.GeneratedMessage {
  factory CatalogMeta({
    $core.String? catalogId,
    $core.String? catalogName,
    $core.int? total,
  }) {
    final result = CatalogMeta._();
    if (catalogId != null) result.catalogId = catalogId;
    if (catalogName != null) result.catalogName = catalogName;
    if (total != null) result.total = total;
    return result;
  }

  CatalogMeta._();

  factory CatalogMeta.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CatalogMeta()..mergeFromBuffer(data, registry);
  factory CatalogMeta.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CatalogMeta()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CatalogMeta',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: CatalogMeta.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'catalogId')
    ..aOS(2, _omitFieldNames ? '' : 'catalogName')
    ..aI(3, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CatalogMeta clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CatalogMeta copyWith(void Function(CatalogMeta) updates) =>
      super.copyWith((message) => updates(message as CatalogMeta))
          as CatalogMeta;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CatalogMeta() / CatalogMeta.new instead')
  static CatalogMeta create() => CatalogMeta._();
  static $pb.GeneratedMessage $_createMessage() => CatalogMeta._();
  @$core.override
  CatalogMeta createEmptyInstance() => CatalogMeta._();
  @$core.pragma('dart2js:noInline')
  static CatalogMeta getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CatalogMeta>(
          CatalogMeta.$_createMessage);
  static CatalogMeta? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get catalogId => $_getSZ(0);
  @$pb.TagNumber(1)
  set catalogId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCatalogId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCatalogId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get catalogName => $_getSZ(1);
  @$pb.TagNumber(2)
  set catalogName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCatalogName() => $_has(1);
  @$pb.TagNumber(2)
  void clearCatalogName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get total => $_getIZ(2);
  @$pb.TagNumber(3)
  set total($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotal() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotal() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
