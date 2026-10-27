// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/review.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'auth.pb.dart' as $3;
import 'catalog.pb.dart' as $1;
import 'common.pb.dart' as $2;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GetCatalogReviewsRequest extends $pb.GeneratedMessage {
  factory GetCatalogReviewsRequest({
    $core.String? catalogId,
    $2.PaginationRequest? pagination,
    $core.int? rating,
  }) {
    final result = GetCatalogReviewsRequest._();
    if (catalogId != null) result.catalogId = catalogId;
    if (pagination != null) result.pagination = pagination;
    if (rating != null) result.rating = rating;
    return result;
  }

  GetCatalogReviewsRequest._();

  factory GetCatalogReviewsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCatalogReviewsRequest()..mergeFromBuffer(data, registry);
  factory GetCatalogReviewsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCatalogReviewsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCatalogReviewsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetCatalogReviewsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'catalogId')
    ..aOM<$2.PaginationRequest>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.PaginationRequest.$_createMessage)
    ..aI(3, _omitFieldNames ? '' : 'rating')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCatalogReviewsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCatalogReviewsRequest copyWith(
          void Function(GetCatalogReviewsRequest) updates) =>
      super.copyWith((message) => updates(message as GetCatalogReviewsRequest))
          as GetCatalogReviewsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetCatalogReviewsRequest() / GetCatalogReviewsRequest.new instead')
  static GetCatalogReviewsRequest create() => GetCatalogReviewsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetCatalogReviewsRequest._();
  @$core.override
  GetCatalogReviewsRequest createEmptyInstance() =>
      GetCatalogReviewsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetCatalogReviewsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCatalogReviewsRequest>(
          GetCatalogReviewsRequest.$_createMessage);
  static GetCatalogReviewsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get catalogId => $_getSZ(0);
  @$pb.TagNumber(1)
  set catalogId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCatalogId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCatalogId() => $_clearField(1);

  @$pb.TagNumber(2)
  $2.PaginationRequest get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.PaginationRequest value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.PaginationRequest ensurePagination() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get rating => $_getIZ(2);
  @$pb.TagNumber(3)
  set rating($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRating() => $_has(2);
  @$pb.TagNumber(3)
  void clearRating() => $_clearField(3);
}

class GetPackageReviewsRequest extends $pb.GeneratedMessage {
  factory GetPackageReviewsRequest({
    $core.String? packageId,
    $2.PaginationRequest? pagination,
    $core.int? rating,
  }) {
    final result = GetPackageReviewsRequest._();
    if (packageId != null) result.packageId = packageId;
    if (pagination != null) result.pagination = pagination;
    if (rating != null) result.rating = rating;
    return result;
  }

  GetPackageReviewsRequest._();

  factory GetPackageReviewsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPackageReviewsRequest()..mergeFromBuffer(data, registry);
  factory GetPackageReviewsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPackageReviewsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPackageReviewsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetPackageReviewsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'packageId')
    ..aOM<$2.PaginationRequest>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.PaginationRequest.$_createMessage)
    ..aI(3, _omitFieldNames ? '' : 'rating')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPackageReviewsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPackageReviewsRequest copyWith(
          void Function(GetPackageReviewsRequest) updates) =>
      super.copyWith((message) => updates(message as GetPackageReviewsRequest))
          as GetPackageReviewsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPackageReviewsRequest() / GetPackageReviewsRequest.new instead')
  static GetPackageReviewsRequest create() => GetPackageReviewsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetPackageReviewsRequest._();
  @$core.override
  GetPackageReviewsRequest createEmptyInstance() =>
      GetPackageReviewsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetPackageReviewsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPackageReviewsRequest>(
          GetPackageReviewsRequest.$_createMessage);
  static GetPackageReviewsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get packageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set packageId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPackageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPackageId() => $_clearField(1);

  @$pb.TagNumber(2)
  $2.PaginationRequest get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.PaginationRequest value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.PaginationRequest ensurePagination() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get rating => $_getIZ(2);
  @$pb.TagNumber(3)
  set rating($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRating() => $_has(2);
  @$pb.TagNumber(3)
  void clearRating() => $_clearField(3);
}

class GetMyReviewsRequest extends $pb.GeneratedMessage {
  factory GetMyReviewsRequest({
    $2.PaginationRequest? pagination,
  }) {
    final result = GetMyReviewsRequest._();
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  GetMyReviewsRequest._();

  factory GetMyReviewsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMyReviewsRequest()..mergeFromBuffer(data, registry);
  factory GetMyReviewsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMyReviewsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMyReviewsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetMyReviewsRequest.$_createMessage)
    ..aOM<$2.PaginationRequest>(1, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.PaginationRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMyReviewsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMyReviewsRequest copyWith(void Function(GetMyReviewsRequest) updates) =>
      super.copyWith((message) => updates(message as GetMyReviewsRequest))
          as GetMyReviewsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use GetMyReviewsRequest() / GetMyReviewsRequest.new instead')
  static GetMyReviewsRequest create() => GetMyReviewsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetMyReviewsRequest._();
  @$core.override
  GetMyReviewsRequest createEmptyInstance() => GetMyReviewsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetMyReviewsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMyReviewsRequest>(
          GetMyReviewsRequest.$_createMessage);
  static GetMyReviewsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.PaginationRequest get pagination => $_getN(0);
  @$pb.TagNumber(1)
  set pagination($2.PaginationRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPagination() => $_has(0);
  @$pb.TagNumber(1)
  void clearPagination() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.PaginationRequest ensurePagination() => $_ensure(0);
}

class GetReviewRequest extends $pb.GeneratedMessage {
  factory GetReviewRequest({
    $core.String? id,
  }) {
    final result = GetReviewRequest._();
    if (id != null) result.id = id;
    return result;
  }

  GetReviewRequest._();

  factory GetReviewRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetReviewRequest()..mergeFromBuffer(data, registry);
  factory GetReviewRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetReviewRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetReviewRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetReviewRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReviewRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReviewRequest copyWith(void Function(GetReviewRequest) updates) =>
      super.copyWith((message) => updates(message as GetReviewRequest))
          as GetReviewRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetReviewRequest() / GetReviewRequest.new instead')
  static GetReviewRequest create() => GetReviewRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetReviewRequest._();
  @$core.override
  GetReviewRequest createEmptyInstance() => GetReviewRequest._();
  @$core.pragma('dart2js:noInline')
  static GetReviewRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetReviewRequest>(
          GetReviewRequest.$_createMessage);
  static GetReviewRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class GetReviewStatsRequest extends $pb.GeneratedMessage {
  factory GetReviewStatsRequest({
    $core.String? catalogId,
    $core.String? packageId,
  }) {
    final result = GetReviewStatsRequest._();
    if (catalogId != null) result.catalogId = catalogId;
    if (packageId != null) result.packageId = packageId;
    return result;
  }

  GetReviewStatsRequest._();

  factory GetReviewStatsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetReviewStatsRequest()..mergeFromBuffer(data, registry);
  factory GetReviewStatsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetReviewStatsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetReviewStatsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetReviewStatsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'catalogId')
    ..aOS(2, _omitFieldNames ? '' : 'packageId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReviewStatsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReviewStatsRequest copyWith(
          void Function(GetReviewStatsRequest) updates) =>
      super.copyWith((message) => updates(message as GetReviewStatsRequest))
          as GetReviewStatsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetReviewStatsRequest() / GetReviewStatsRequest.new instead')
  static GetReviewStatsRequest create() => GetReviewStatsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetReviewStatsRequest._();
  @$core.override
  GetReviewStatsRequest createEmptyInstance() => GetReviewStatsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetReviewStatsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetReviewStatsRequest>(
          GetReviewStatsRequest.$_createMessage);
  static GetReviewStatsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get catalogId => $_getSZ(0);
  @$pb.TagNumber(1)
  set catalogId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCatalogId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCatalogId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get packageId => $_getSZ(1);
  @$pb.TagNumber(2)
  set packageId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPackageId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPackageId() => $_clearField(2);
}

class GetFeaturedReviewsRequest extends $pb.GeneratedMessage {
  factory GetFeaturedReviewsRequest({
    $core.int? limit,
  }) {
    final result = GetFeaturedReviewsRequest._();
    if (limit != null) result.limit = limit;
    return result;
  }

  GetFeaturedReviewsRequest._();

  factory GetFeaturedReviewsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetFeaturedReviewsRequest()..mergeFromBuffer(data, registry);
  factory GetFeaturedReviewsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetFeaturedReviewsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFeaturedReviewsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetFeaturedReviewsRequest.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFeaturedReviewsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFeaturedReviewsRequest copyWith(
          void Function(GetFeaturedReviewsRequest) updates) =>
      super.copyWith((message) => updates(message as GetFeaturedReviewsRequest))
          as GetFeaturedReviewsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetFeaturedReviewsRequest() / GetFeaturedReviewsRequest.new instead')
  static GetFeaturedReviewsRequest create() => GetFeaturedReviewsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetFeaturedReviewsRequest._();
  @$core.override
  GetFeaturedReviewsRequest createEmptyInstance() =>
      GetFeaturedReviewsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetFeaturedReviewsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetFeaturedReviewsRequest>(
          GetFeaturedReviewsRequest.$_createMessage);
  static GetFeaturedReviewsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get limit => $_getIZ(0);
  @$pb.TagNumber(1)
  set limit($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLimit() => $_has(0);
  @$pb.TagNumber(1)
  void clearLimit() => $_clearField(1);
}

class GetAllReviewsRequest extends $pb.GeneratedMessage {
  factory GetAllReviewsRequest({
    $2.PaginationRequest? pagination,
    $core.String? status,
    $core.int? rating,
  }) {
    final result = GetAllReviewsRequest._();
    if (pagination != null) result.pagination = pagination;
    if (status != null) result.status = status;
    if (rating != null) result.rating = rating;
    return result;
  }

  GetAllReviewsRequest._();

  factory GetAllReviewsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetAllReviewsRequest()..mergeFromBuffer(data, registry);
  factory GetAllReviewsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetAllReviewsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAllReviewsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetAllReviewsRequest.$_createMessage)
    ..aOM<$2.PaginationRequest>(1, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.PaginationRequest.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'status')
    ..aI(3, _omitFieldNames ? '' : 'rating')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAllReviewsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAllReviewsRequest copyWith(void Function(GetAllReviewsRequest) updates) =>
      super.copyWith((message) => updates(message as GetAllReviewsRequest))
          as GetAllReviewsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetAllReviewsRequest() / GetAllReviewsRequest.new instead')
  static GetAllReviewsRequest create() => GetAllReviewsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetAllReviewsRequest._();
  @$core.override
  GetAllReviewsRequest createEmptyInstance() => GetAllReviewsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetAllReviewsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAllReviewsRequest>(
          GetAllReviewsRequest.$_createMessage);
  static GetAllReviewsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.PaginationRequest get pagination => $_getN(0);
  @$pb.TagNumber(1)
  set pagination($2.PaginationRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPagination() => $_has(0);
  @$pb.TagNumber(1)
  void clearPagination() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.PaginationRequest ensurePagination() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get rating => $_getIZ(2);
  @$pb.TagNumber(3)
  set rating($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRating() => $_has(2);
  @$pb.TagNumber(3)
  void clearRating() => $_clearField(3);
}

class CreateReviewRequest extends $pb.GeneratedMessage {
  factory CreateReviewRequest({
    $core.String? catalogId,
    $core.String? packageId,
    $core.String? orderId,
    $core.int? rating,
    $core.String? title,
    $core.String? comment,
    $core.Iterable<$core.String>? photos,
    $core.bool? isAnonymous,
  }) {
    final result = CreateReviewRequest._();
    if (catalogId != null) result.catalogId = catalogId;
    if (packageId != null) result.packageId = packageId;
    if (orderId != null) result.orderId = orderId;
    if (rating != null) result.rating = rating;
    if (title != null) result.title = title;
    if (comment != null) result.comment = comment;
    if (photos != null) result.photos.addAll(photos);
    if (isAnonymous != null) result.isAnonymous = isAnonymous;
    return result;
  }

  CreateReviewRequest._();

  factory CreateReviewRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateReviewRequest()..mergeFromBuffer(data, registry);
  factory CreateReviewRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateReviewRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateReviewRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: CreateReviewRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'catalogId')
    ..aOS(2, _omitFieldNames ? '' : 'packageId')
    ..aOS(3, _omitFieldNames ? '' : 'orderId')
    ..aI(4, _omitFieldNames ? '' : 'rating')
    ..aOS(5, _omitFieldNames ? '' : 'title')
    ..aOS(6, _omitFieldNames ? '' : 'comment')
    ..pPS(7, _omitFieldNames ? '' : 'photos')
    ..aOB(8, _omitFieldNames ? '' : 'isAnonymous')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateReviewRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateReviewRequest copyWith(void Function(CreateReviewRequest) updates) =>
      super.copyWith((message) => updates(message as CreateReviewRequest))
          as CreateReviewRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use CreateReviewRequest() / CreateReviewRequest.new instead')
  static CreateReviewRequest create() => CreateReviewRequest._();
  static $pb.GeneratedMessage $_createMessage() => CreateReviewRequest._();
  @$core.override
  CreateReviewRequest createEmptyInstance() => CreateReviewRequest._();
  @$core.pragma('dart2js:noInline')
  static CreateReviewRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateReviewRequest>(
          CreateReviewRequest.$_createMessage);
  static CreateReviewRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get catalogId => $_getSZ(0);
  @$pb.TagNumber(1)
  set catalogId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCatalogId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCatalogId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get packageId => $_getSZ(1);
  @$pb.TagNumber(2)
  set packageId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPackageId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPackageId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get orderId => $_getSZ(2);
  @$pb.TagNumber(3)
  set orderId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOrderId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOrderId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get rating => $_getIZ(3);
  @$pb.TagNumber(4)
  set rating($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRating() => $_has(3);
  @$pb.TagNumber(4)
  void clearRating() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get title => $_getSZ(4);
  @$pb.TagNumber(5)
  set title($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTitle() => $_has(4);
  @$pb.TagNumber(5)
  void clearTitle() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get comment => $_getSZ(5);
  @$pb.TagNumber(6)
  set comment($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasComment() => $_has(5);
  @$pb.TagNumber(6)
  void clearComment() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get photos => $_getList(6);

  @$pb.TagNumber(8)
  $core.bool get isAnonymous => $_getBF(7);
  @$pb.TagNumber(8)
  set isAnonymous($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIsAnonymous() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsAnonymous() => $_clearField(8);
}

class UpdateReviewRequest extends $pb.GeneratedMessage {
  factory UpdateReviewRequest({
    $core.String? reviewId,
    $core.int? rating,
    $core.String? title,
    $core.String? comment,
    $core.Iterable<$core.String>? photos,
    $core.bool? isAnonymous,
  }) {
    final result = UpdateReviewRequest._();
    if (reviewId != null) result.reviewId = reviewId;
    if (rating != null) result.rating = rating;
    if (title != null) result.title = title;
    if (comment != null) result.comment = comment;
    if (photos != null) result.photos.addAll(photos);
    if (isAnonymous != null) result.isAnonymous = isAnonymous;
    return result;
  }

  UpdateReviewRequest._();

  factory UpdateReviewRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateReviewRequest()..mergeFromBuffer(data, registry);
  factory UpdateReviewRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateReviewRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateReviewRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: UpdateReviewRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'reviewId')
    ..aI(2, _omitFieldNames ? '' : 'rating')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'comment')
    ..pPS(5, _omitFieldNames ? '' : 'photos')
    ..aOB(6, _omitFieldNames ? '' : 'isAnonymous')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateReviewRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateReviewRequest copyWith(void Function(UpdateReviewRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateReviewRequest))
          as UpdateReviewRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use UpdateReviewRequest() / UpdateReviewRequest.new instead')
  static UpdateReviewRequest create() => UpdateReviewRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdateReviewRequest._();
  @$core.override
  UpdateReviewRequest createEmptyInstance() => UpdateReviewRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateReviewRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateReviewRequest>(
          UpdateReviewRequest.$_createMessage);
  static UpdateReviewRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reviewId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reviewId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReviewId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReviewId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get rating => $_getIZ(1);
  @$pb.TagNumber(2)
  set rating($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRating() => $_has(1);
  @$pb.TagNumber(2)
  void clearRating() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get comment => $_getSZ(3);
  @$pb.TagNumber(4)
  set comment($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasComment() => $_has(3);
  @$pb.TagNumber(4)
  void clearComment() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get photos => $_getList(4);

  @$pb.TagNumber(6)
  $core.bool get isAnonymous => $_getBF(5);
  @$pb.TagNumber(6)
  set isAnonymous($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsAnonymous() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsAnonymous() => $_clearField(6);
}

class DeleteReviewRequest extends $pb.GeneratedMessage {
  factory DeleteReviewRequest({
    $core.String? reviewId,
  }) {
    final result = DeleteReviewRequest._();
    if (reviewId != null) result.reviewId = reviewId;
    return result;
  }

  DeleteReviewRequest._();

  factory DeleteReviewRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteReviewRequest()..mergeFromBuffer(data, registry);
  factory DeleteReviewRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteReviewRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteReviewRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: DeleteReviewRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'reviewId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteReviewRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteReviewRequest copyWith(void Function(DeleteReviewRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteReviewRequest))
          as DeleteReviewRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use DeleteReviewRequest() / DeleteReviewRequest.new instead')
  static DeleteReviewRequest create() => DeleteReviewRequest._();
  static $pb.GeneratedMessage $_createMessage() => DeleteReviewRequest._();
  @$core.override
  DeleteReviewRequest createEmptyInstance() => DeleteReviewRequest._();
  @$core.pragma('dart2js:noInline')
  static DeleteReviewRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteReviewRequest>(
          DeleteReviewRequest.$_createMessage);
  static DeleteReviewRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reviewId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reviewId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReviewId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReviewId() => $_clearField(1);
}

class AddReviewPhotoRequest extends $pb.GeneratedMessage {
  factory AddReviewPhotoRequest({
    $core.String? reviewId,
    $core.String? url,
    $core.String? caption,
  }) {
    final result = AddReviewPhotoRequest._();
    if (reviewId != null) result.reviewId = reviewId;
    if (url != null) result.url = url;
    if (caption != null) result.caption = caption;
    return result;
  }

  AddReviewPhotoRequest._();

  factory AddReviewPhotoRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AddReviewPhotoRequest()..mergeFromBuffer(data, registry);
  factory AddReviewPhotoRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AddReviewPhotoRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddReviewPhotoRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: AddReviewPhotoRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'reviewId')
    ..aOS(2, _omitFieldNames ? '' : 'url')
    ..aOS(3, _omitFieldNames ? '' : 'caption')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddReviewPhotoRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddReviewPhotoRequest copyWith(
          void Function(AddReviewPhotoRequest) updates) =>
      super.copyWith((message) => updates(message as AddReviewPhotoRequest))
          as AddReviewPhotoRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use AddReviewPhotoRequest() / AddReviewPhotoRequest.new instead')
  static AddReviewPhotoRequest create() => AddReviewPhotoRequest._();
  static $pb.GeneratedMessage $_createMessage() => AddReviewPhotoRequest._();
  @$core.override
  AddReviewPhotoRequest createEmptyInstance() => AddReviewPhotoRequest._();
  @$core.pragma('dart2js:noInline')
  static AddReviewPhotoRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddReviewPhotoRequest>(
          AddReviewPhotoRequest.$_createMessage);
  static AddReviewPhotoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reviewId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reviewId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReviewId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReviewId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get url => $_getSZ(1);
  @$pb.TagNumber(2)
  set url($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get caption => $_getSZ(2);
  @$pb.TagNumber(3)
  set caption($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCaption() => $_has(2);
  @$pb.TagNumber(3)
  void clearCaption() => $_clearField(3);
}

class RemoveReviewPhotoRequest extends $pb.GeneratedMessage {
  factory RemoveReviewPhotoRequest({
    $core.String? reviewId,
    $core.String? photoUrl,
  }) {
    final result = RemoveReviewPhotoRequest._();
    if (reviewId != null) result.reviewId = reviewId;
    if (photoUrl != null) result.photoUrl = photoUrl;
    return result;
  }

  RemoveReviewPhotoRequest._();

  factory RemoveReviewPhotoRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemoveReviewPhotoRequest()..mergeFromBuffer(data, registry);
  factory RemoveReviewPhotoRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemoveReviewPhotoRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemoveReviewPhotoRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: RemoveReviewPhotoRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'reviewId')
    ..aOS(2, _omitFieldNames ? '' : 'photoUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveReviewPhotoRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveReviewPhotoRequest copyWith(
          void Function(RemoveReviewPhotoRequest) updates) =>
      super.copyWith((message) => updates(message as RemoveReviewPhotoRequest))
          as RemoveReviewPhotoRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RemoveReviewPhotoRequest() / RemoveReviewPhotoRequest.new instead')
  static RemoveReviewPhotoRequest create() => RemoveReviewPhotoRequest._();
  static $pb.GeneratedMessage $_createMessage() => RemoveReviewPhotoRequest._();
  @$core.override
  RemoveReviewPhotoRequest createEmptyInstance() =>
      RemoveReviewPhotoRequest._();
  @$core.pragma('dart2js:noInline')
  static RemoveReviewPhotoRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemoveReviewPhotoRequest>(
          RemoveReviewPhotoRequest.$_createMessage);
  static RemoveReviewPhotoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reviewId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reviewId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReviewId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReviewId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get photoUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set photoUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPhotoUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearPhotoUrl() => $_clearField(2);
}

class MarkReviewHelpfulRequest extends $pb.GeneratedMessage {
  factory MarkReviewHelpfulRequest({
    $core.String? reviewId,
  }) {
    final result = MarkReviewHelpfulRequest._();
    if (reviewId != null) result.reviewId = reviewId;
    return result;
  }

  MarkReviewHelpfulRequest._();

  factory MarkReviewHelpfulRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkReviewHelpfulRequest()..mergeFromBuffer(data, registry);
  factory MarkReviewHelpfulRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkReviewHelpfulRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkReviewHelpfulRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: MarkReviewHelpfulRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'reviewId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkReviewHelpfulRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkReviewHelpfulRequest copyWith(
          void Function(MarkReviewHelpfulRequest) updates) =>
      super.copyWith((message) => updates(message as MarkReviewHelpfulRequest))
          as MarkReviewHelpfulRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MarkReviewHelpfulRequest() / MarkReviewHelpfulRequest.new instead')
  static MarkReviewHelpfulRequest create() => MarkReviewHelpfulRequest._();
  static $pb.GeneratedMessage $_createMessage() => MarkReviewHelpfulRequest._();
  @$core.override
  MarkReviewHelpfulRequest createEmptyInstance() =>
      MarkReviewHelpfulRequest._();
  @$core.pragma('dart2js:noInline')
  static MarkReviewHelpfulRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MarkReviewHelpfulRequest>(
          MarkReviewHelpfulRequest.$_createMessage);
  static MarkReviewHelpfulRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reviewId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reviewId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReviewId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReviewId() => $_clearField(1);
}

class UnmarkReviewHelpfulRequest extends $pb.GeneratedMessage {
  factory UnmarkReviewHelpfulRequest({
    $core.String? reviewId,
  }) {
    final result = UnmarkReviewHelpfulRequest._();
    if (reviewId != null) result.reviewId = reviewId;
    return result;
  }

  UnmarkReviewHelpfulRequest._();

  factory UnmarkReviewHelpfulRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UnmarkReviewHelpfulRequest()..mergeFromBuffer(data, registry);
  factory UnmarkReviewHelpfulRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UnmarkReviewHelpfulRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnmarkReviewHelpfulRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: UnmarkReviewHelpfulRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'reviewId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnmarkReviewHelpfulRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnmarkReviewHelpfulRequest copyWith(
          void Function(UnmarkReviewHelpfulRequest) updates) =>
      super.copyWith(
              (message) => updates(message as UnmarkReviewHelpfulRequest))
          as UnmarkReviewHelpfulRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UnmarkReviewHelpfulRequest() / UnmarkReviewHelpfulRequest.new instead')
  static UnmarkReviewHelpfulRequest create() => UnmarkReviewHelpfulRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      UnmarkReviewHelpfulRequest._();
  @$core.override
  UnmarkReviewHelpfulRequest createEmptyInstance() =>
      UnmarkReviewHelpfulRequest._();
  @$core.pragma('dart2js:noInline')
  static UnmarkReviewHelpfulRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UnmarkReviewHelpfulRequest>(
          UnmarkReviewHelpfulRequest.$_createMessage);
  static UnmarkReviewHelpfulRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reviewId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reviewId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReviewId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReviewId() => $_clearField(1);
}

class ModerateReviewRequest extends $pb.GeneratedMessage {
  factory ModerateReviewRequest({
    $core.String? reviewId,
    $2.ReviewStatus? status,
    $core.String? moderationNote,
  }) {
    final result = ModerateReviewRequest._();
    if (reviewId != null) result.reviewId = reviewId;
    if (status != null) result.status = status;
    if (moderationNote != null) result.moderationNote = moderationNote;
    return result;
  }

  ModerateReviewRequest._();

  factory ModerateReviewRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModerateReviewRequest()..mergeFromBuffer(data, registry);
  factory ModerateReviewRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModerateReviewRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ModerateReviewRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ModerateReviewRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'reviewId')
    ..aE<$2.ReviewStatus>(2, _omitFieldNames ? '' : 'status',
        enumValues: $2.ReviewStatus.values)
    ..aOS(3, _omitFieldNames ? '' : 'moderationNote')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModerateReviewRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModerateReviewRequest copyWith(
          void Function(ModerateReviewRequest) updates) =>
      super.copyWith((message) => updates(message as ModerateReviewRequest))
          as ModerateReviewRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ModerateReviewRequest() / ModerateReviewRequest.new instead')
  static ModerateReviewRequest create() => ModerateReviewRequest._();
  static $pb.GeneratedMessage $_createMessage() => ModerateReviewRequest._();
  @$core.override
  ModerateReviewRequest createEmptyInstance() => ModerateReviewRequest._();
  @$core.pragma('dart2js:noInline')
  static ModerateReviewRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ModerateReviewRequest>(
          ModerateReviewRequest.$_createMessage);
  static ModerateReviewRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reviewId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reviewId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReviewId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReviewId() => $_clearField(1);

  @$pb.TagNumber(2)
  $2.ReviewStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status($2.ReviewStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get moderationNote => $_getSZ(2);
  @$pb.TagNumber(3)
  set moderationNote($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasModerationNote() => $_has(2);
  @$pb.TagNumber(3)
  void clearModerationNote() => $_clearField(3);
}

class ReplyToReviewRequest extends $pb.GeneratedMessage {
  factory ReplyToReviewRequest({
    $core.String? reviewId,
    $core.String? reply,
  }) {
    final result = ReplyToReviewRequest._();
    if (reviewId != null) result.reviewId = reviewId;
    if (reply != null) result.reply = reply;
    return result;
  }

  ReplyToReviewRequest._();

  factory ReplyToReviewRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReplyToReviewRequest()..mergeFromBuffer(data, registry);
  factory ReplyToReviewRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReplyToReviewRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReplyToReviewRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ReplyToReviewRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'reviewId')
    ..aOS(2, _omitFieldNames ? '' : 'reply')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyToReviewRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyToReviewRequest copyWith(void Function(ReplyToReviewRequest) updates) =>
      super.copyWith((message) => updates(message as ReplyToReviewRequest))
          as ReplyToReviewRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReplyToReviewRequest() / ReplyToReviewRequest.new instead')
  static ReplyToReviewRequest create() => ReplyToReviewRequest._();
  static $pb.GeneratedMessage $_createMessage() => ReplyToReviewRequest._();
  @$core.override
  ReplyToReviewRequest createEmptyInstance() => ReplyToReviewRequest._();
  @$core.pragma('dart2js:noInline')
  static ReplyToReviewRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReplyToReviewRequest>(
          ReplyToReviewRequest.$_createMessage);
  static ReplyToReviewRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reviewId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reviewId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReviewId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReviewId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reply => $_getSZ(1);
  @$pb.TagNumber(2)
  set reply($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReply() => $_has(1);
  @$pb.TagNumber(2)
  void clearReply() => $_clearField(2);
}

class ReportReviewRequest extends $pb.GeneratedMessage {
  factory ReportReviewRequest({
    $core.String? reviewId,
    $2.ReportReason? reason,
    $core.String? description,
  }) {
    final result = ReportReviewRequest._();
    if (reviewId != null) result.reviewId = reviewId;
    if (reason != null) result.reason = reason;
    if (description != null) result.description = description;
    return result;
  }

  ReportReviewRequest._();

  factory ReportReviewRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReportReviewRequest()..mergeFromBuffer(data, registry);
  factory ReportReviewRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReportReviewRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReportReviewRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ReportReviewRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'reviewId')
    ..aE<$2.ReportReason>(2, _omitFieldNames ? '' : 'reason',
        enumValues: $2.ReportReason.values)
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportReviewRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportReviewRequest copyWith(void Function(ReportReviewRequest) updates) =>
      super.copyWith((message) => updates(message as ReportReviewRequest))
          as ReportReviewRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ReportReviewRequest() / ReportReviewRequest.new instead')
  static ReportReviewRequest create() => ReportReviewRequest._();
  static $pb.GeneratedMessage $_createMessage() => ReportReviewRequest._();
  @$core.override
  ReportReviewRequest createEmptyInstance() => ReportReviewRequest._();
  @$core.pragma('dart2js:noInline')
  static ReportReviewRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReportReviewRequest>(
          ReportReviewRequest.$_createMessage);
  static ReportReviewRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reviewId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reviewId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReviewId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReviewId() => $_clearField(1);

  @$pb.TagNumber(2)
  $2.ReportReason get reason => $_getN(1);
  @$pb.TagNumber(2)
  set reason($2.ReportReason value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);
}

class ReviewListResponse extends $pb.GeneratedMessage {
  factory ReviewListResponse({
    $core.Iterable<$1.Review>? reviews,
    $2.PaginationResponse? pagination,
  }) {
    final result = ReviewListResponse._();
    if (reviews != null) result.reviews.addAll(reviews);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ReviewListResponse._();

  factory ReviewListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReviewListResponse()..mergeFromBuffer(data, registry);
  factory ReviewListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReviewListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReviewListResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ReviewListResponse.$_createMessage)
    ..pPM<$1.Review>(1, _omitFieldNames ? '' : 'reviews',
        subBuilder: $1.Review.$_createMessage)
    ..aOM<$2.PaginationResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.PaginationResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewListResponse copyWith(void Function(ReviewListResponse) updates) =>
      super.copyWith((message) => updates(message as ReviewListResponse))
          as ReviewListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ReviewListResponse() / ReviewListResponse.new instead')
  static ReviewListResponse create() => ReviewListResponse._();
  static $pb.GeneratedMessage $_createMessage() => ReviewListResponse._();
  @$core.override
  ReviewListResponse createEmptyInstance() => ReviewListResponse._();
  @$core.pragma('dart2js:noInline')
  static ReviewListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReviewListResponse>(
          ReviewListResponse.$_createMessage);
  static ReviewListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$1.Review> get reviews => $_getList(0);

  @$pb.TagNumber(2)
  $2.PaginationResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.PaginationResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.PaginationResponse ensurePagination() => $_ensure(1);
}

class ReviewStats extends $pb.GeneratedMessage {
  factory ReviewStats({
    $core.int? totalReviews,
    $core.double? averageRating,
    $core.Iterable<RatingCount>? ratingDistribution,
    $core.int? withPhotos,
    $core.int? verifiedPurchases,
  }) {
    final result = ReviewStats._();
    if (totalReviews != null) result.totalReviews = totalReviews;
    if (averageRating != null) result.averageRating = averageRating;
    if (ratingDistribution != null)
      result.ratingDistribution.addAll(ratingDistribution);
    if (withPhotos != null) result.withPhotos = withPhotos;
    if (verifiedPurchases != null) result.verifiedPurchases = verifiedPurchases;
    return result;
  }

  ReviewStats._();

  factory ReviewStats.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReviewStats()..mergeFromBuffer(data, registry);
  factory ReviewStats.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReviewStats()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReviewStats',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ReviewStats.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'totalReviews')
    ..aD(2, _omitFieldNames ? '' : 'averageRating')
    ..pPM<RatingCount>(3, _omitFieldNames ? '' : 'ratingDistribution',
        subBuilder: RatingCount.$_createMessage)
    ..aI(4, _omitFieldNames ? '' : 'withPhotos')
    ..aI(5, _omitFieldNames ? '' : 'verifiedPurchases')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewStats clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewStats copyWith(void Function(ReviewStats) updates) =>
      super.copyWith((message) => updates(message as ReviewStats))
          as ReviewStats;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ReviewStats() / ReviewStats.new instead')
  static ReviewStats create() => ReviewStats._();
  static $pb.GeneratedMessage $_createMessage() => ReviewStats._();
  @$core.override
  ReviewStats createEmptyInstance() => ReviewStats._();
  @$core.pragma('dart2js:noInline')
  static ReviewStats getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReviewStats>(
          ReviewStats.$_createMessage);
  static ReviewStats? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get totalReviews => $_getIZ(0);
  @$pb.TagNumber(1)
  set totalReviews($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotalReviews() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalReviews() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get averageRating => $_getN(1);
  @$pb.TagNumber(2)
  set averageRating($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAverageRating() => $_has(1);
  @$pb.TagNumber(2)
  void clearAverageRating() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<RatingCount> get ratingDistribution => $_getList(2);

  @$pb.TagNumber(4)
  $core.int get withPhotos => $_getIZ(3);
  @$pb.TagNumber(4)
  set withPhotos($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWithPhotos() => $_has(3);
  @$pb.TagNumber(4)
  void clearWithPhotos() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get verifiedPurchases => $_getIZ(4);
  @$pb.TagNumber(5)
  set verifiedPurchases($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVerifiedPurchases() => $_has(4);
  @$pb.TagNumber(5)
  void clearVerifiedPurchases() => $_clearField(5);
}

class RatingCount extends $pb.GeneratedMessage {
  factory RatingCount({
    $core.int? rating,
    $core.int? count,
    $core.double? percentage,
  }) {
    final result = RatingCount._();
    if (rating != null) result.rating = rating;
    if (count != null) result.count = count;
    if (percentage != null) result.percentage = percentage;
    return result;
  }

  RatingCount._();

  factory RatingCount.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RatingCount()..mergeFromBuffer(data, registry);
  factory RatingCount.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RatingCount()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RatingCount',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: RatingCount.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'rating')
    ..aI(2, _omitFieldNames ? '' : 'count')
    ..aD(3, _omitFieldNames ? '' : 'percentage')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RatingCount clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RatingCount copyWith(void Function(RatingCount) updates) =>
      super.copyWith((message) => updates(message as RatingCount))
          as RatingCount;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RatingCount() / RatingCount.new instead')
  static RatingCount create() => RatingCount._();
  static $pb.GeneratedMessage $_createMessage() => RatingCount._();
  @$core.override
  RatingCount createEmptyInstance() => RatingCount._();
  @$core.pragma('dart2js:noInline')
  static RatingCount getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RatingCount>(
          RatingCount.$_createMessage);
  static RatingCount? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get rating => $_getIZ(0);
  @$pb.TagNumber(1)
  set rating($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRating() => $_has(0);
  @$pb.TagNumber(1)
  void clearRating() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get count => $_getIZ(1);
  @$pb.TagNumber(2)
  set count($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get percentage => $_getN(2);
  @$pb.TagNumber(3)
  set percentage($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPercentage() => $_has(2);
  @$pb.TagNumber(3)
  void clearPercentage() => $_clearField(3);
}

class ReviewReport extends $pb.GeneratedMessage {
  factory ReviewReport({
    $core.String? id,
    $1.Review? review,
    $3.User? reporter,
    $2.ReportReason? reason,
    $core.String? description,
    $2.ReportStatus? status,
    $core.String? createdAt,
    $core.String? reviewedAt,
    $3.User? reviewedBy,
  }) {
    final result = ReviewReport._();
    if (id != null) result.id = id;
    if (review != null) result.review = review;
    if (reporter != null) result.reporter = reporter;
    if (reason != null) result.reason = reason;
    if (description != null) result.description = description;
    if (status != null) result.status = status;
    if (createdAt != null) result.createdAt = createdAt;
    if (reviewedAt != null) result.reviewedAt = reviewedAt;
    if (reviewedBy != null) result.reviewedBy = reviewedBy;
    return result;
  }

  ReviewReport._();

  factory ReviewReport.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReviewReport()..mergeFromBuffer(data, registry);
  factory ReviewReport.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReviewReport()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReviewReport',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ReviewReport.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOM<$1.Review>(2, _omitFieldNames ? '' : 'review',
        subBuilder: $1.Review.$_createMessage)
    ..aOM<$3.User>(3, _omitFieldNames ? '' : 'reporter',
        subBuilder: $3.User.$_createMessage)
    ..aE<$2.ReportReason>(4, _omitFieldNames ? '' : 'reason',
        enumValues: $2.ReportReason.values)
    ..aOS(5, _omitFieldNames ? '' : 'description')
    ..aE<$2.ReportStatus>(6, _omitFieldNames ? '' : 'status',
        enumValues: $2.ReportStatus.values)
    ..aOS(7, _omitFieldNames ? '' : 'createdAt')
    ..aOS(8, _omitFieldNames ? '' : 'reviewedAt')
    ..aOM<$3.User>(9, _omitFieldNames ? '' : 'reviewedBy',
        subBuilder: $3.User.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewReport clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewReport copyWith(void Function(ReviewReport) updates) =>
      super.copyWith((message) => updates(message as ReviewReport))
          as ReviewReport;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ReviewReport() / ReviewReport.new instead')
  static ReviewReport create() => ReviewReport._();
  static $pb.GeneratedMessage $_createMessage() => ReviewReport._();
  @$core.override
  ReviewReport createEmptyInstance() => ReviewReport._();
  @$core.pragma('dart2js:noInline')
  static ReviewReport getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReviewReport>(
          ReviewReport.$_createMessage);
  static ReviewReport? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.Review get review => $_getN(1);
  @$pb.TagNumber(2)
  set review($1.Review value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasReview() => $_has(1);
  @$pb.TagNumber(2)
  void clearReview() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Review ensureReview() => $_ensure(1);

  @$pb.TagNumber(3)
  $3.User get reporter => $_getN(2);
  @$pb.TagNumber(3)
  set reporter($3.User value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasReporter() => $_has(2);
  @$pb.TagNumber(3)
  void clearReporter() => $_clearField(3);
  @$pb.TagNumber(3)
  $3.User ensureReporter() => $_ensure(2);

  @$pb.TagNumber(4)
  $2.ReportReason get reason => $_getN(3);
  @$pb.TagNumber(4)
  set reason($2.ReportReason value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get description => $_getSZ(4);
  @$pb.TagNumber(5)
  set description($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDescription() => $_has(4);
  @$pb.TagNumber(5)
  void clearDescription() => $_clearField(5);

  @$pb.TagNumber(6)
  $2.ReportStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status($2.ReportStatus value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get createdAt => $_getSZ(6);
  @$pb.TagNumber(7)
  set createdAt($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCreatedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreatedAt() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get reviewedAt => $_getSZ(7);
  @$pb.TagNumber(8)
  set reviewedAt($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasReviewedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearReviewedAt() => $_clearField(8);

  @$pb.TagNumber(9)
  $3.User get reviewedBy => $_getN(8);
  @$pb.TagNumber(9)
  set reviewedBy($3.User value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasReviewedBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearReviewedBy() => $_clearField(9);
  @$pb.TagNumber(9)
  $3.User ensureReviewedBy() => $_ensure(8);
}

class DeleteReviewResponse extends $pb.GeneratedMessage {
  factory DeleteReviewResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = DeleteReviewResponse._();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  DeleteReviewResponse._();

  factory DeleteReviewResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteReviewResponse()..mergeFromBuffer(data, registry);
  factory DeleteReviewResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteReviewResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteReviewResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: DeleteReviewResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteReviewResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteReviewResponse copyWith(void Function(DeleteReviewResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteReviewResponse))
          as DeleteReviewResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DeleteReviewResponse() / DeleteReviewResponse.new instead')
  static DeleteReviewResponse create() => DeleteReviewResponse._();
  static $pb.GeneratedMessage $_createMessage() => DeleteReviewResponse._();
  @$core.override
  DeleteReviewResponse createEmptyInstance() => DeleteReviewResponse._();
  @$core.pragma('dart2js:noInline')
  static DeleteReviewResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteReviewResponse>(
          DeleteReviewResponse.$_createMessage);
  static DeleteReviewResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
