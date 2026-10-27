// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/package.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'catalog.pb.dart' as $3;
import 'category.pb.dart' as $2;
import 'common.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GetPackageRequest extends $pb.GeneratedMessage {
  factory GetPackageRequest({
    $core.String? id,
  }) {
    final result = GetPackageRequest._();
    if (id != null) result.id = id;
    return result;
  }

  GetPackageRequest._();

  factory GetPackageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPackageRequest()..mergeFromBuffer(data, registry);
  factory GetPackageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPackageRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPackageRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetPackageRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPackageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPackageRequest copyWith(void Function(GetPackageRequest) updates) =>
      super.copyWith((message) => updates(message as GetPackageRequest))
          as GetPackageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetPackageRequest() / GetPackageRequest.new instead')
  static GetPackageRequest create() => GetPackageRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetPackageRequest._();
  @$core.override
  GetPackageRequest createEmptyInstance() => GetPackageRequest._();
  @$core.pragma('dart2js:noInline')
  static GetPackageRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetPackageRequest>(
          GetPackageRequest.$_createMessage);
  static GetPackageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class GetPackageBySlugRequest extends $pb.GeneratedMessage {
  factory GetPackageBySlugRequest({
    $core.String? slug,
  }) {
    final result = GetPackageBySlugRequest._();
    if (slug != null) result.slug = slug;
    return result;
  }

  GetPackageBySlugRequest._();

  factory GetPackageBySlugRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPackageBySlugRequest()..mergeFromBuffer(data, registry);
  factory GetPackageBySlugRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPackageBySlugRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPackageBySlugRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetPackageBySlugRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'slug')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPackageBySlugRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPackageBySlugRequest copyWith(
          void Function(GetPackageBySlugRequest) updates) =>
      super.copyWith((message) => updates(message as GetPackageBySlugRequest))
          as GetPackageBySlugRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPackageBySlugRequest() / GetPackageBySlugRequest.new instead')
  static GetPackageBySlugRequest create() => GetPackageBySlugRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetPackageBySlugRequest._();
  @$core.override
  GetPackageBySlugRequest createEmptyInstance() => GetPackageBySlugRequest._();
  @$core.pragma('dart2js:noInline')
  static GetPackageBySlugRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPackageBySlugRequest>(
          GetPackageBySlugRequest.$_createMessage);
  static GetPackageBySlugRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get slug => $_getSZ(0);
  @$pb.TagNumber(1)
  set slug($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSlug() => $_has(0);
  @$pb.TagNumber(1)
  void clearSlug() => $_clearField(1);
}

class ListPackagesRequest extends $pb.GeneratedMessage {
  factory ListPackagesRequest({
    $1.PaginationRequest? pagination,
    $core.String? categoryId,
    $core.bool? featured,
    $core.double? minPrice,
    $core.double? maxPrice,
    $core.bool? active,
    $core.String? sortBy,
    $1.SortDirection? sortDirection,
  }) {
    final result = ListPackagesRequest._();
    if (pagination != null) result.pagination = pagination;
    if (categoryId != null) result.categoryId = categoryId;
    if (featured != null) result.featured = featured;
    if (minPrice != null) result.minPrice = minPrice;
    if (maxPrice != null) result.maxPrice = maxPrice;
    if (active != null) result.active = active;
    if (sortBy != null) result.sortBy = sortBy;
    if (sortDirection != null) result.sortDirection = sortDirection;
    return result;
  }

  ListPackagesRequest._();

  factory ListPackagesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPackagesRequest()..mergeFromBuffer(data, registry);
  factory ListPackagesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPackagesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPackagesRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ListPackagesRequest.$_createMessage)
    ..aOM<$1.PaginationRequest>(1, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginationRequest.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'categoryId')
    ..aOB(3, _omitFieldNames ? '' : 'featured')
    ..aD(4, _omitFieldNames ? '' : 'minPrice')
    ..aD(5, _omitFieldNames ? '' : 'maxPrice')
    ..aOB(6, _omitFieldNames ? '' : 'active')
    ..aOS(7, _omitFieldNames ? '' : 'sortBy')
    ..aE<$1.SortDirection>(8, _omitFieldNames ? '' : 'sortDirection',
        enumValues: $1.SortDirection.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPackagesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPackagesRequest copyWith(void Function(ListPackagesRequest) updates) =>
      super.copyWith((message) => updates(message as ListPackagesRequest))
          as ListPackagesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ListPackagesRequest() / ListPackagesRequest.new instead')
  static ListPackagesRequest create() => ListPackagesRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListPackagesRequest._();
  @$core.override
  ListPackagesRequest createEmptyInstance() => ListPackagesRequest._();
  @$core.pragma('dart2js:noInline')
  static ListPackagesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPackagesRequest>(
          ListPackagesRequest.$_createMessage);
  static ListPackagesRequest? _defaultInstance;

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
  $core.bool get featured => $_getBF(2);
  @$pb.TagNumber(3)
  set featured($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFeatured() => $_has(2);
  @$pb.TagNumber(3)
  void clearFeatured() => $_clearField(3);

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
  $core.bool get active => $_getBF(5);
  @$pb.TagNumber(6)
  set active($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasActive() => $_has(5);
  @$pb.TagNumber(6)
  void clearActive() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get sortBy => $_getSZ(6);
  @$pb.TagNumber(7)
  set sortBy($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSortBy() => $_has(6);
  @$pb.TagNumber(7)
  void clearSortBy() => $_clearField(7);

  @$pb.TagNumber(8)
  $1.SortDirection get sortDirection => $_getN(7);
  @$pb.TagNumber(8)
  set sortDirection($1.SortDirection value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasSortDirection() => $_has(7);
  @$pb.TagNumber(8)
  void clearSortDirection() => $_clearField(8);
}

class PackageListResponse extends $pb.GeneratedMessage {
  factory PackageListResponse({
    $core.Iterable<Package>? packages,
    $1.PaginationResponse? pagination,
  }) {
    final result = PackageListResponse._();
    if (packages != null) result.packages.addAll(packages);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  PackageListResponse._();

  factory PackageListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PackageListResponse()..mergeFromBuffer(data, registry);
  factory PackageListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PackageListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PackageListResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: PackageListResponse.$_createMessage)
    ..pPM<Package>(1, _omitFieldNames ? '' : 'packages',
        subBuilder: Package.$_createMessage)
    ..aOM<$1.PaginationResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginationResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PackageListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PackageListResponse copyWith(void Function(PackageListResponse) updates) =>
      super.copyWith((message) => updates(message as PackageListResponse))
          as PackageListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use PackageListResponse() / PackageListResponse.new instead')
  static PackageListResponse create() => PackageListResponse._();
  static $pb.GeneratedMessage $_createMessage() => PackageListResponse._();
  @$core.override
  PackageListResponse createEmptyInstance() => PackageListResponse._();
  @$core.pragma('dart2js:noInline')
  static PackageListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PackageListResponse>(
          PackageListResponse.$_createMessage);
  static PackageListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Package> get packages => $_getList(0);

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

class GetFeaturedPackagesRequest extends $pb.GeneratedMessage {
  factory GetFeaturedPackagesRequest({
    $core.int? limit,
  }) {
    final result = GetFeaturedPackagesRequest._();
    if (limit != null) result.limit = limit;
    return result;
  }

  GetFeaturedPackagesRequest._();

  factory GetFeaturedPackagesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetFeaturedPackagesRequest()..mergeFromBuffer(data, registry);
  factory GetFeaturedPackagesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetFeaturedPackagesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFeaturedPackagesRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetFeaturedPackagesRequest.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFeaturedPackagesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFeaturedPackagesRequest copyWith(
          void Function(GetFeaturedPackagesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetFeaturedPackagesRequest))
          as GetFeaturedPackagesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetFeaturedPackagesRequest() / GetFeaturedPackagesRequest.new instead')
  static GetFeaturedPackagesRequest create() => GetFeaturedPackagesRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetFeaturedPackagesRequest._();
  @$core.override
  GetFeaturedPackagesRequest createEmptyInstance() =>
      GetFeaturedPackagesRequest._();
  @$core.pragma('dart2js:noInline')
  static GetFeaturedPackagesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetFeaturedPackagesRequest>(
          GetFeaturedPackagesRequest.$_createMessage);
  static GetFeaturedPackagesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get limit => $_getIZ(0);
  @$pb.TagNumber(1)
  set limit($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLimit() => $_has(0);
  @$pb.TagNumber(1)
  void clearLimit() => $_clearField(1);
}

class GetOnSalePackagesRequest extends $pb.GeneratedMessage {
  factory GetOnSalePackagesRequest({
    $core.int? limit,
  }) {
    final result = GetOnSalePackagesRequest._();
    if (limit != null) result.limit = limit;
    return result;
  }

  GetOnSalePackagesRequest._();

  factory GetOnSalePackagesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetOnSalePackagesRequest()..mergeFromBuffer(data, registry);
  factory GetOnSalePackagesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetOnSalePackagesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetOnSalePackagesRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetOnSalePackagesRequest.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOnSalePackagesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOnSalePackagesRequest copyWith(
          void Function(GetOnSalePackagesRequest) updates) =>
      super.copyWith((message) => updates(message as GetOnSalePackagesRequest))
          as GetOnSalePackagesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetOnSalePackagesRequest() / GetOnSalePackagesRequest.new instead')
  static GetOnSalePackagesRequest create() => GetOnSalePackagesRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetOnSalePackagesRequest._();
  @$core.override
  GetOnSalePackagesRequest createEmptyInstance() =>
      GetOnSalePackagesRequest._();
  @$core.pragma('dart2js:noInline')
  static GetOnSalePackagesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetOnSalePackagesRequest>(
          GetOnSalePackagesRequest.$_createMessage);
  static GetOnSalePackagesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get limit => $_getIZ(0);
  @$pb.TagNumber(1)
  set limit($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLimit() => $_has(0);
  @$pb.TagNumber(1)
  void clearLimit() => $_clearField(1);
}

class GetPackagesByCategoryRequest extends $pb.GeneratedMessage {
  factory GetPackagesByCategoryRequest({
    $core.String? categoryId,
    $core.int? limit,
  }) {
    final result = GetPackagesByCategoryRequest._();
    if (categoryId != null) result.categoryId = categoryId;
    if (limit != null) result.limit = limit;
    return result;
  }

  GetPackagesByCategoryRequest._();

  factory GetPackagesByCategoryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPackagesByCategoryRequest()..mergeFromBuffer(data, registry);
  factory GetPackagesByCategoryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPackagesByCategoryRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPackagesByCategoryRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetPackagesByCategoryRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'categoryId')
    ..aI(2, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPackagesByCategoryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPackagesByCategoryRequest copyWith(
          void Function(GetPackagesByCategoryRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetPackagesByCategoryRequest))
          as GetPackagesByCategoryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPackagesByCategoryRequest() / GetPackagesByCategoryRequest.new instead')
  static GetPackagesByCategoryRequest create() =>
      GetPackagesByCategoryRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetPackagesByCategoryRequest._();
  @$core.override
  GetPackagesByCategoryRequest createEmptyInstance() =>
      GetPackagesByCategoryRequest._();
  @$core.pragma('dart2js:noInline')
  static GetPackagesByCategoryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPackagesByCategoryRequest>(
          GetPackagesByCategoryRequest.$_createMessage);
  static GetPackagesByCategoryRequest? _defaultInstance;

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

class GetPackagesByCapacityRequest extends $pb.GeneratedMessage {
  factory GetPackagesByCapacityRequest({
    $core.int? minCapacity,
    $core.int? maxCapacity,
    $core.int? limit,
  }) {
    final result = GetPackagesByCapacityRequest._();
    if (minCapacity != null) result.minCapacity = minCapacity;
    if (maxCapacity != null) result.maxCapacity = maxCapacity;
    if (limit != null) result.limit = limit;
    return result;
  }

  GetPackagesByCapacityRequest._();

  factory GetPackagesByCapacityRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPackagesByCapacityRequest()..mergeFromBuffer(data, registry);
  factory GetPackagesByCapacityRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPackagesByCapacityRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPackagesByCapacityRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetPackagesByCapacityRequest.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'minCapacity')
    ..aI(2, _omitFieldNames ? '' : 'maxCapacity')
    ..aI(3, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPackagesByCapacityRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPackagesByCapacityRequest copyWith(
          void Function(GetPackagesByCapacityRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetPackagesByCapacityRequest))
          as GetPackagesByCapacityRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPackagesByCapacityRequest() / GetPackagesByCapacityRequest.new instead')
  static GetPackagesByCapacityRequest create() =>
      GetPackagesByCapacityRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetPackagesByCapacityRequest._();
  @$core.override
  GetPackagesByCapacityRequest createEmptyInstance() =>
      GetPackagesByCapacityRequest._();
  @$core.pragma('dart2js:noInline')
  static GetPackagesByCapacityRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPackagesByCapacityRequest>(
          GetPackagesByCapacityRequest.$_createMessage);
  static GetPackagesByCapacityRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get minCapacity => $_getIZ(0);
  @$pb.TagNumber(1)
  set minCapacity($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMinCapacity() => $_has(0);
  @$pb.TagNumber(1)
  void clearMinCapacity() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get maxCapacity => $_getIZ(1);
  @$pb.TagNumber(2)
  set maxCapacity($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMaxCapacity() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxCapacity() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);
}

class GetRelatedPackagesRequest extends $pb.GeneratedMessage {
  factory GetRelatedPackagesRequest({
    $core.String? packageId,
    $core.int? limit,
  }) {
    final result = GetRelatedPackagesRequest._();
    if (packageId != null) result.packageId = packageId;
    if (limit != null) result.limit = limit;
    return result;
  }

  GetRelatedPackagesRequest._();

  factory GetRelatedPackagesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetRelatedPackagesRequest()..mergeFromBuffer(data, registry);
  factory GetRelatedPackagesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetRelatedPackagesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRelatedPackagesRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetRelatedPackagesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'packageId')
    ..aI(2, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRelatedPackagesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRelatedPackagesRequest copyWith(
          void Function(GetRelatedPackagesRequest) updates) =>
      super.copyWith((message) => updates(message as GetRelatedPackagesRequest))
          as GetRelatedPackagesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetRelatedPackagesRequest() / GetRelatedPackagesRequest.new instead')
  static GetRelatedPackagesRequest create() => GetRelatedPackagesRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetRelatedPackagesRequest._();
  @$core.override
  GetRelatedPackagesRequest createEmptyInstance() =>
      GetRelatedPackagesRequest._();
  @$core.pragma('dart2js:noInline')
  static GetRelatedPackagesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRelatedPackagesRequest>(
          GetRelatedPackagesRequest.$_createMessage);
  static GetRelatedPackagesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get packageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set packageId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPackageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPackageId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => $_clearField(2);
}

class SearchPackagesRequest extends $pb.GeneratedMessage {
  factory SearchPackagesRequest({
    $core.String? query,
    $core.int? limit,
  }) {
    final result = SearchPackagesRequest._();
    if (query != null) result.query = query;
    if (limit != null) result.limit = limit;
    return result;
  }

  SearchPackagesRequest._();

  factory SearchPackagesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchPackagesRequest()..mergeFromBuffer(data, registry);
  factory SearchPackagesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchPackagesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchPackagesRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: SearchPackagesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'query')
    ..aI(2, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchPackagesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchPackagesRequest copyWith(
          void Function(SearchPackagesRequest) updates) =>
      super.copyWith((message) => updates(message as SearchPackagesRequest))
          as SearchPackagesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SearchPackagesRequest() / SearchPackagesRequest.new instead')
  static SearchPackagesRequest create() => SearchPackagesRequest._();
  static $pb.GeneratedMessage $_createMessage() => SearchPackagesRequest._();
  @$core.override
  SearchPackagesRequest createEmptyInstance() => SearchPackagesRequest._();
  @$core.pragma('dart2js:noInline')
  static SearchPackagesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchPackagesRequest>(
          SearchPackagesRequest.$_createMessage);
  static SearchPackagesRequest? _defaultInstance;

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

class GetPackageStatsRequest extends $pb.GeneratedMessage {
  factory GetPackageStatsRequest() => GetPackageStatsRequest._();

  GetPackageStatsRequest._();

  factory GetPackageStatsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPackageStatsRequest()..mergeFromBuffer(data, registry);
  factory GetPackageStatsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPackageStatsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPackageStatsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetPackageStatsRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPackageStatsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPackageStatsRequest copyWith(
          void Function(GetPackageStatsRequest) updates) =>
      super.copyWith((message) => updates(message as GetPackageStatsRequest))
          as GetPackageStatsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPackageStatsRequest() / GetPackageStatsRequest.new instead')
  static GetPackageStatsRequest create() => GetPackageStatsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetPackageStatsRequest._();
  @$core.override
  GetPackageStatsRequest createEmptyInstance() => GetPackageStatsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetPackageStatsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPackageStatsRequest>(
          GetPackageStatsRequest.$_createMessage);
  static GetPackageStatsRequest? _defaultInstance;
}

class PackageStats extends $pb.GeneratedMessage {
  factory PackageStats({
    $core.int? totalPackages,
    $core.int? activePackages,
    $core.int? featuredPackages,
    $core.int? onSalePackages,
    $core.double? totalValue,
    $core.Iterable<CategoryPackageCount>? byCategory,
    $core.Iterable<CapacityPackageCount>? byCapacity,
  }) {
    final result = PackageStats._();
    if (totalPackages != null) result.totalPackages = totalPackages;
    if (activePackages != null) result.activePackages = activePackages;
    if (featuredPackages != null) result.featuredPackages = featuredPackages;
    if (onSalePackages != null) result.onSalePackages = onSalePackages;
    if (totalValue != null) result.totalValue = totalValue;
    if (byCategory != null) result.byCategory.addAll(byCategory);
    if (byCapacity != null) result.byCapacity.addAll(byCapacity);
    return result;
  }

  PackageStats._();

  factory PackageStats.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PackageStats()..mergeFromBuffer(data, registry);
  factory PackageStats.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PackageStats()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PackageStats',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: PackageStats.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'totalPackages')
    ..aI(2, _omitFieldNames ? '' : 'activePackages')
    ..aI(3, _omitFieldNames ? '' : 'featuredPackages')
    ..aI(4, _omitFieldNames ? '' : 'onSalePackages')
    ..aD(5, _omitFieldNames ? '' : 'totalValue')
    ..pPM<CategoryPackageCount>(6, _omitFieldNames ? '' : 'byCategory',
        subBuilder: CategoryPackageCount.$_createMessage)
    ..pPM<CapacityPackageCount>(7, _omitFieldNames ? '' : 'byCapacity',
        subBuilder: CapacityPackageCount.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PackageStats clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PackageStats copyWith(void Function(PackageStats) updates) =>
      super.copyWith((message) => updates(message as PackageStats))
          as PackageStats;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PackageStats() / PackageStats.new instead')
  static PackageStats create() => PackageStats._();
  static $pb.GeneratedMessage $_createMessage() => PackageStats._();
  @$core.override
  PackageStats createEmptyInstance() => PackageStats._();
  @$core.pragma('dart2js:noInline')
  static PackageStats getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PackageStats>(
          PackageStats.$_createMessage);
  static PackageStats? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get totalPackages => $_getIZ(0);
  @$pb.TagNumber(1)
  set totalPackages($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotalPackages() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalPackages() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get activePackages => $_getIZ(1);
  @$pb.TagNumber(2)
  set activePackages($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasActivePackages() => $_has(1);
  @$pb.TagNumber(2)
  void clearActivePackages() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get featuredPackages => $_getIZ(2);
  @$pb.TagNumber(3)
  set featuredPackages($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFeaturedPackages() => $_has(2);
  @$pb.TagNumber(3)
  void clearFeaturedPackages() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get onSalePackages => $_getIZ(3);
  @$pb.TagNumber(4)
  set onSalePackages($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOnSalePackages() => $_has(3);
  @$pb.TagNumber(4)
  void clearOnSalePackages() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get totalValue => $_getN(4);
  @$pb.TagNumber(5)
  set totalValue($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTotalValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearTotalValue() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<CategoryPackageCount> get byCategory => $_getList(5);

  @$pb.TagNumber(7)
  $pb.PbList<CapacityPackageCount> get byCapacity => $_getList(6);
}

class CategoryPackageCount extends $pb.GeneratedMessage {
  factory CategoryPackageCount({
    $2.Category? category,
    $core.int? count,
  }) {
    final result = CategoryPackageCount._();
    if (category != null) result.category = category;
    if (count != null) result.count = count;
    return result;
  }

  CategoryPackageCount._();

  factory CategoryPackageCount.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CategoryPackageCount()..mergeFromBuffer(data, registry);
  factory CategoryPackageCount.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CategoryPackageCount()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CategoryPackageCount',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: CategoryPackageCount.$_createMessage)
    ..aOM<$2.Category>(1, _omitFieldNames ? '' : 'category',
        subBuilder: $2.Category.$_createMessage)
    ..aI(2, _omitFieldNames ? '' : 'count')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CategoryPackageCount clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CategoryPackageCount copyWith(void Function(CategoryPackageCount) updates) =>
      super.copyWith((message) => updates(message as CategoryPackageCount))
          as CategoryPackageCount;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CategoryPackageCount() / CategoryPackageCount.new instead')
  static CategoryPackageCount create() => CategoryPackageCount._();
  static $pb.GeneratedMessage $_createMessage() => CategoryPackageCount._();
  @$core.override
  CategoryPackageCount createEmptyInstance() => CategoryPackageCount._();
  @$core.pragma('dart2js:noInline')
  static CategoryPackageCount getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CategoryPackageCount>(
          CategoryPackageCount.$_createMessage);
  static CategoryPackageCount? _defaultInstance;

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

class CapacityPackageCount extends $pb.GeneratedMessage {
  factory CapacityPackageCount({
    $core.int? minCapacity,
    $core.int? maxCapacity,
    $core.int? count,
  }) {
    final result = CapacityPackageCount._();
    if (minCapacity != null) result.minCapacity = minCapacity;
    if (maxCapacity != null) result.maxCapacity = maxCapacity;
    if (count != null) result.count = count;
    return result;
  }

  CapacityPackageCount._();

  factory CapacityPackageCount.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CapacityPackageCount()..mergeFromBuffer(data, registry);
  factory CapacityPackageCount.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CapacityPackageCount()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CapacityPackageCount',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: CapacityPackageCount.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'minCapacity')
    ..aI(2, _omitFieldNames ? '' : 'maxCapacity')
    ..aI(3, _omitFieldNames ? '' : 'count')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CapacityPackageCount clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CapacityPackageCount copyWith(void Function(CapacityPackageCount) updates) =>
      super.copyWith((message) => updates(message as CapacityPackageCount))
          as CapacityPackageCount;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CapacityPackageCount() / CapacityPackageCount.new instead')
  static CapacityPackageCount create() => CapacityPackageCount._();
  static $pb.GeneratedMessage $_createMessage() => CapacityPackageCount._();
  @$core.override
  CapacityPackageCount createEmptyInstance() => CapacityPackageCount._();
  @$core.pragma('dart2js:noInline')
  static CapacityPackageCount getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CapacityPackageCount>(
          CapacityPackageCount.$_createMessage);
  static CapacityPackageCount? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get minCapacity => $_getIZ(0);
  @$pb.TagNumber(1)
  set minCapacity($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMinCapacity() => $_has(0);
  @$pb.TagNumber(1)
  void clearMinCapacity() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get maxCapacity => $_getIZ(1);
  @$pb.TagNumber(2)
  set maxCapacity($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMaxCapacity() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxCapacity() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get count => $_getIZ(2);
  @$pb.TagNumber(3)
  set count($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearCount() => $_clearField(3);
}

class Package extends $pb.GeneratedMessage {
  factory Package({
    $core.String? id,
    $core.String? name,
    $core.String? slug,
    $core.String? description,
    $core.double? price,
    $core.double? discountPrice,
    $core.double? finalPrice,
    $core.bool? isActive,
    $core.bool? isFeatured,
    $core.String? imageUrl,
    $core.Iterable<$core.String>? features,
    $core.String? theme,
    $core.String? color,
    $core.int? minCapacity,
    $core.int? maxCapacity,
    $2.Category? category,
    $core.double? averageRating,
    $core.Iterable<$3.Review>? reviews,
    $core.String? createdAt,
    $core.String? updatedAt,
  }) {
    final result = Package._();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (slug != null) result.slug = slug;
    if (description != null) result.description = description;
    if (price != null) result.price = price;
    if (discountPrice != null) result.discountPrice = discountPrice;
    if (finalPrice != null) result.finalPrice = finalPrice;
    if (isActive != null) result.isActive = isActive;
    if (isFeatured != null) result.isFeatured = isFeatured;
    if (imageUrl != null) result.imageUrl = imageUrl;
    if (features != null) result.features.addAll(features);
    if (theme != null) result.theme = theme;
    if (color != null) result.color = color;
    if (minCapacity != null) result.minCapacity = minCapacity;
    if (maxCapacity != null) result.maxCapacity = maxCapacity;
    if (category != null) result.category = category;
    if (averageRating != null) result.averageRating = averageRating;
    if (reviews != null) result.reviews.addAll(reviews);
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  Package._();

  factory Package.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Package()..mergeFromBuffer(data, registry);
  factory Package.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Package()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Package',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: Package.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'slug')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aD(5, _omitFieldNames ? '' : 'price')
    ..aD(6, _omitFieldNames ? '' : 'discountPrice')
    ..aD(7, _omitFieldNames ? '' : 'finalPrice')
    ..aOB(8, _omitFieldNames ? '' : 'isActive')
    ..aOB(9, _omitFieldNames ? '' : 'isFeatured')
    ..aOS(10, _omitFieldNames ? '' : 'imageUrl')
    ..pPS(11, _omitFieldNames ? '' : 'features')
    ..aOS(12, _omitFieldNames ? '' : 'theme')
    ..aOS(13, _omitFieldNames ? '' : 'color')
    ..aI(14, _omitFieldNames ? '' : 'minCapacity')
    ..aI(15, _omitFieldNames ? '' : 'maxCapacity')
    ..aOM<$2.Category>(16, _omitFieldNames ? '' : 'category',
        subBuilder: $2.Category.$_createMessage)
    ..aD(17, _omitFieldNames ? '' : 'averageRating')
    ..pPM<$3.Review>(18, _omitFieldNames ? '' : 'reviews',
        subBuilder: $3.Review.$_createMessage)
    ..aOS(19, _omitFieldNames ? '' : 'createdAt')
    ..aOS(20, _omitFieldNames ? '' : 'updatedAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Package clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Package copyWith(void Function(Package) updates) =>
      super.copyWith((message) => updates(message as Package)) as Package;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Package() / Package.new instead')
  static Package create() => Package._();
  static $pb.GeneratedMessage $_createMessage() => Package._();
  @$core.override
  Package createEmptyInstance() => Package._();
  @$core.pragma('dart2js:noInline')
  static Package getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Package>(Package.$_createMessage);
  static Package? _defaultInstance;

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
  $core.bool get isActive => $_getBF(7);
  @$pb.TagNumber(8)
  set isActive($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIsActive() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsActive() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get isFeatured => $_getBF(8);
  @$pb.TagNumber(9)
  set isFeatured($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasIsFeatured() => $_has(8);
  @$pb.TagNumber(9)
  void clearIsFeatured() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get imageUrl => $_getSZ(9);
  @$pb.TagNumber(10)
  set imageUrl($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasImageUrl() => $_has(9);
  @$pb.TagNumber(10)
  void clearImageUrl() => $_clearField(10);

  @$pb.TagNumber(11)
  $pb.PbList<$core.String> get features => $_getList(10);

  @$pb.TagNumber(12)
  $core.String get theme => $_getSZ(11);
  @$pb.TagNumber(12)
  set theme($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasTheme() => $_has(11);
  @$pb.TagNumber(12)
  void clearTheme() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get color => $_getSZ(12);
  @$pb.TagNumber(13)
  set color($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasColor() => $_has(12);
  @$pb.TagNumber(13)
  void clearColor() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.int get minCapacity => $_getIZ(13);
  @$pb.TagNumber(14)
  set minCapacity($core.int value) => $_setSignedInt32(13, value);
  @$pb.TagNumber(14)
  $core.bool hasMinCapacity() => $_has(13);
  @$pb.TagNumber(14)
  void clearMinCapacity() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.int get maxCapacity => $_getIZ(14);
  @$pb.TagNumber(15)
  set maxCapacity($core.int value) => $_setSignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasMaxCapacity() => $_has(14);
  @$pb.TagNumber(15)
  void clearMaxCapacity() => $_clearField(15);

  @$pb.TagNumber(16)
  $2.Category get category => $_getN(15);
  @$pb.TagNumber(16)
  set category($2.Category value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasCategory() => $_has(15);
  @$pb.TagNumber(16)
  void clearCategory() => $_clearField(16);
  @$pb.TagNumber(16)
  $2.Category ensureCategory() => $_ensure(15);

  @$pb.TagNumber(17)
  $core.double get averageRating => $_getN(16);
  @$pb.TagNumber(17)
  set averageRating($core.double value) => $_setDouble(16, value);
  @$pb.TagNumber(17)
  $core.bool hasAverageRating() => $_has(16);
  @$pb.TagNumber(17)
  void clearAverageRating() => $_clearField(17);

  @$pb.TagNumber(18)
  $pb.PbList<$3.Review> get reviews => $_getList(17);

  @$pb.TagNumber(19)
  $core.String get createdAt => $_getSZ(18);
  @$pb.TagNumber(19)
  set createdAt($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasCreatedAt() => $_has(18);
  @$pb.TagNumber(19)
  void clearCreatedAt() => $_clearField(19);

  @$pb.TagNumber(20)
  $core.String get updatedAt => $_getSZ(19);
  @$pb.TagNumber(20)
  set updatedAt($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasUpdatedAt() => $_has(19);
  @$pb.TagNumber(20)
  void clearUpdatedAt() => $_clearField(20);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
