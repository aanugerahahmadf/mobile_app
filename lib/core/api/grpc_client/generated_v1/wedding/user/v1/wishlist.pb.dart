// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/wishlist.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'auth.pb.dart' as $3;
import 'catalog.pb.dart' as $4;
import 'common.pb.dart' as $2;
import 'package.pb.dart' as $5;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GetMyWishlistRequest extends $pb.GeneratedMessage {
  factory GetMyWishlistRequest({
    $2.PaginationRequest? pagination,
  }) {
    final result = GetMyWishlistRequest._();
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  GetMyWishlistRequest._();

  factory GetMyWishlistRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMyWishlistRequest()..mergeFromBuffer(data, registry);
  factory GetMyWishlistRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMyWishlistRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMyWishlistRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetMyWishlistRequest.$_createMessage)
    ..aOM<$2.PaginationRequest>(1, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.PaginationRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMyWishlistRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMyWishlistRequest copyWith(void Function(GetMyWishlistRequest) updates) =>
      super.copyWith((message) => updates(message as GetMyWishlistRequest))
          as GetMyWishlistRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetMyWishlistRequest() / GetMyWishlistRequest.new instead')
  static GetMyWishlistRequest create() => GetMyWishlistRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetMyWishlistRequest._();
  @$core.override
  GetMyWishlistRequest createEmptyInstance() => GetMyWishlistRequest._();
  @$core.pragma('dart2js:noInline')
  static GetMyWishlistRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMyWishlistRequest>(
          GetMyWishlistRequest.$_createMessage);
  static GetMyWishlistRequest? _defaultInstance;

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

class IsInWishlistRequest extends $pb.GeneratedMessage {
  factory IsInWishlistRequest({
    $core.String? catalogId,
    $core.String? packageId,
  }) {
    final result = IsInWishlistRequest._();
    if (catalogId != null) result.catalogId = catalogId;
    if (packageId != null) result.packageId = packageId;
    return result;
  }

  IsInWishlistRequest._();

  factory IsInWishlistRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IsInWishlistRequest()..mergeFromBuffer(data, registry);
  factory IsInWishlistRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IsInWishlistRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IsInWishlistRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: IsInWishlistRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'catalogId')
    ..aOS(2, _omitFieldNames ? '' : 'packageId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IsInWishlistRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IsInWishlistRequest copyWith(void Function(IsInWishlistRequest) updates) =>
      super.copyWith((message) => updates(message as IsInWishlistRequest))
          as IsInWishlistRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use IsInWishlistRequest() / IsInWishlistRequest.new instead')
  static IsInWishlistRequest create() => IsInWishlistRequest._();
  static $pb.GeneratedMessage $_createMessage() => IsInWishlistRequest._();
  @$core.override
  IsInWishlistRequest createEmptyInstance() => IsInWishlistRequest._();
  @$core.pragma('dart2js:noInline')
  static IsInWishlistRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IsInWishlistRequest>(
          IsInWishlistRequest.$_createMessage);
  static IsInWishlistRequest? _defaultInstance;

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

class ToggleWishlistRequest extends $pb.GeneratedMessage {
  factory ToggleWishlistRequest({
    $core.String? catalogId,
    $core.String? packageId,
  }) {
    final result = ToggleWishlistRequest._();
    if (catalogId != null) result.catalogId = catalogId;
    if (packageId != null) result.packageId = packageId;
    return result;
  }

  ToggleWishlistRequest._();

  factory ToggleWishlistRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ToggleWishlistRequest()..mergeFromBuffer(data, registry);
  factory ToggleWishlistRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ToggleWishlistRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToggleWishlistRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ToggleWishlistRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'catalogId')
    ..aOS(2, _omitFieldNames ? '' : 'packageId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToggleWishlistRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToggleWishlistRequest copyWith(
          void Function(ToggleWishlistRequest) updates) =>
      super.copyWith((message) => updates(message as ToggleWishlistRequest))
          as ToggleWishlistRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ToggleWishlistRequest() / ToggleWishlistRequest.new instead')
  static ToggleWishlistRequest create() => ToggleWishlistRequest._();
  static $pb.GeneratedMessage $_createMessage() => ToggleWishlistRequest._();
  @$core.override
  ToggleWishlistRequest createEmptyInstance() => ToggleWishlistRequest._();
  @$core.pragma('dart2js:noInline')
  static ToggleWishlistRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ToggleWishlistRequest>(
          ToggleWishlistRequest.$_createMessage);
  static ToggleWishlistRequest? _defaultInstance;

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

class AddToWishlistRequest extends $pb.GeneratedMessage {
  factory AddToWishlistRequest({
    $core.String? catalogId,
    $core.String? packageId,
  }) {
    final result = AddToWishlistRequest._();
    if (catalogId != null) result.catalogId = catalogId;
    if (packageId != null) result.packageId = packageId;
    return result;
  }

  AddToWishlistRequest._();

  factory AddToWishlistRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AddToWishlistRequest()..mergeFromBuffer(data, registry);
  factory AddToWishlistRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AddToWishlistRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddToWishlistRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: AddToWishlistRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'catalogId')
    ..aOS(2, _omitFieldNames ? '' : 'packageId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddToWishlistRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddToWishlistRequest copyWith(void Function(AddToWishlistRequest) updates) =>
      super.copyWith((message) => updates(message as AddToWishlistRequest))
          as AddToWishlistRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use AddToWishlistRequest() / AddToWishlistRequest.new instead')
  static AddToWishlistRequest create() => AddToWishlistRequest._();
  static $pb.GeneratedMessage $_createMessage() => AddToWishlistRequest._();
  @$core.override
  AddToWishlistRequest createEmptyInstance() => AddToWishlistRequest._();
  @$core.pragma('dart2js:noInline')
  static AddToWishlistRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddToWishlistRequest>(
          AddToWishlistRequest.$_createMessage);
  static AddToWishlistRequest? _defaultInstance;

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

class RemoveFromWishlistRequest extends $pb.GeneratedMessage {
  factory RemoveFromWishlistRequest({
    $core.String? wishlistId,
  }) {
    final result = RemoveFromWishlistRequest._();
    if (wishlistId != null) result.wishlistId = wishlistId;
    return result;
  }

  RemoveFromWishlistRequest._();

  factory RemoveFromWishlistRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemoveFromWishlistRequest()..mergeFromBuffer(data, registry);
  factory RemoveFromWishlistRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemoveFromWishlistRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemoveFromWishlistRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: RemoveFromWishlistRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'wishlistId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveFromWishlistRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveFromWishlistRequest copyWith(
          void Function(RemoveFromWishlistRequest) updates) =>
      super.copyWith((message) => updates(message as RemoveFromWishlistRequest))
          as RemoveFromWishlistRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RemoveFromWishlistRequest() / RemoveFromWishlistRequest.new instead')
  static RemoveFromWishlistRequest create() => RemoveFromWishlistRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      RemoveFromWishlistRequest._();
  @$core.override
  RemoveFromWishlistRequest createEmptyInstance() =>
      RemoveFromWishlistRequest._();
  @$core.pragma('dart2js:noInline')
  static RemoveFromWishlistRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemoveFromWishlistRequest>(
          RemoveFromWishlistRequest.$_createMessage);
  static RemoveFromWishlistRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get wishlistId => $_getSZ(0);
  @$pb.TagNumber(1)
  set wishlistId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWishlistId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWishlistId() => $_clearField(1);
}

class ClearWishlistRequest extends $pb.GeneratedMessage {
  factory ClearWishlistRequest() => ClearWishlistRequest._();

  ClearWishlistRequest._();

  factory ClearWishlistRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClearWishlistRequest()..mergeFromBuffer(data, registry);
  factory ClearWishlistRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClearWishlistRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClearWishlistRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ClearWishlistRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearWishlistRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearWishlistRequest copyWith(void Function(ClearWishlistRequest) updates) =>
      super.copyWith((message) => updates(message as ClearWishlistRequest))
          as ClearWishlistRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ClearWishlistRequest() / ClearWishlistRequest.new instead')
  static ClearWishlistRequest create() => ClearWishlistRequest._();
  static $pb.GeneratedMessage $_createMessage() => ClearWishlistRequest._();
  @$core.override
  ClearWishlistRequest createEmptyInstance() => ClearWishlistRequest._();
  @$core.pragma('dart2js:noInline')
  static ClearWishlistRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClearWishlistRequest>(
          ClearWishlistRequest.$_createMessage);
  static ClearWishlistRequest? _defaultInstance;
}

class MoveToCartRequest extends $pb.GeneratedMessage {
  factory MoveToCartRequest({
    $core.String? wishlistId,
    $core.int? quantity,
  }) {
    final result = MoveToCartRequest._();
    if (wishlistId != null) result.wishlistId = wishlistId;
    if (quantity != null) result.quantity = quantity;
    return result;
  }

  MoveToCartRequest._();

  factory MoveToCartRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MoveToCartRequest()..mergeFromBuffer(data, registry);
  factory MoveToCartRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MoveToCartRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MoveToCartRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: MoveToCartRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'wishlistId')
    ..aI(2, _omitFieldNames ? '' : 'quantity')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoveToCartRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoveToCartRequest copyWith(void Function(MoveToCartRequest) updates) =>
      super.copyWith((message) => updates(message as MoveToCartRequest))
          as MoveToCartRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use MoveToCartRequest() / MoveToCartRequest.new instead')
  static MoveToCartRequest create() => MoveToCartRequest._();
  static $pb.GeneratedMessage $_createMessage() => MoveToCartRequest._();
  @$core.override
  MoveToCartRequest createEmptyInstance() => MoveToCartRequest._();
  @$core.pragma('dart2js:noInline')
  static MoveToCartRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MoveToCartRequest>(
          MoveToCartRequest.$_createMessage);
  static MoveToCartRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get wishlistId => $_getSZ(0);
  @$pb.TagNumber(1)
  set wishlistId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWishlistId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWishlistId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get quantity => $_getIZ(1);
  @$pb.TagNumber(2)
  set quantity($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuantity() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuantity() => $_clearField(2);
}

class ShareWishlistRequest extends $pb.GeneratedMessage {
  factory ShareWishlistRequest() => ShareWishlistRequest._();

  ShareWishlistRequest._();

  factory ShareWishlistRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ShareWishlistRequest()..mergeFromBuffer(data, registry);
  factory ShareWishlistRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ShareWishlistRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ShareWishlistRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ShareWishlistRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareWishlistRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareWishlistRequest copyWith(void Function(ShareWishlistRequest) updates) =>
      super.copyWith((message) => updates(message as ShareWishlistRequest))
          as ShareWishlistRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ShareWishlistRequest() / ShareWishlistRequest.new instead')
  static ShareWishlistRequest create() => ShareWishlistRequest._();
  static $pb.GeneratedMessage $_createMessage() => ShareWishlistRequest._();
  @$core.override
  ShareWishlistRequest createEmptyInstance() => ShareWishlistRequest._();
  @$core.pragma('dart2js:noInline')
  static ShareWishlistRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ShareWishlistRequest>(
          ShareWishlistRequest.$_createMessage);
  static ShareWishlistRequest? _defaultInstance;
}

class WishlistListResponse extends $pb.GeneratedMessage {
  factory WishlistListResponse({
    $core.Iterable<Wishlist>? wishlist,
    $2.PaginationResponse? pagination,
  }) {
    final result = WishlistListResponse._();
    if (wishlist != null) result.wishlist.addAll(wishlist);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  WishlistListResponse._();

  factory WishlistListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WishlistListResponse()..mergeFromBuffer(data, registry);
  factory WishlistListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WishlistListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WishlistListResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: WishlistListResponse.$_createMessage)
    ..pPM<Wishlist>(1, _omitFieldNames ? '' : 'wishlist',
        subBuilder: Wishlist.$_createMessage)
    ..aOM<$2.PaginationResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.PaginationResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WishlistListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WishlistListResponse copyWith(void Function(WishlistListResponse) updates) =>
      super.copyWith((message) => updates(message as WishlistListResponse))
          as WishlistListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WishlistListResponse() / WishlistListResponse.new instead')
  static WishlistListResponse create() => WishlistListResponse._();
  static $pb.GeneratedMessage $_createMessage() => WishlistListResponse._();
  @$core.override
  WishlistListResponse createEmptyInstance() => WishlistListResponse._();
  @$core.pragma('dart2js:noInline')
  static WishlistListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WishlistListResponse>(
          WishlistListResponse.$_createMessage);
  static WishlistListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Wishlist> get wishlist => $_getList(0);

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

class Wishlist extends $pb.GeneratedMessage {
  factory Wishlist({
    $core.String? id,
    $3.User? user,
    $4.Catalog? catalog,
    $5.Package? package,
    $core.String? createdAt,
  }) {
    final result = Wishlist._();
    if (id != null) result.id = id;
    if (user != null) result.user = user;
    if (catalog != null) result.catalog = catalog;
    if (package != null) result.package = package;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  Wishlist._();

  factory Wishlist.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Wishlist()..mergeFromBuffer(data, registry);
  factory Wishlist.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Wishlist()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Wishlist',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: Wishlist.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOM<$3.User>(2, _omitFieldNames ? '' : 'user',
        subBuilder: $3.User.$_createMessage)
    ..aOM<$4.Catalog>(3, _omitFieldNames ? '' : 'catalog',
        subBuilder: $4.Catalog.$_createMessage)
    ..aOM<$5.Package>(4, _omitFieldNames ? '' : 'package',
        subBuilder: $5.Package.$_createMessage)
    ..aOS(5, _omitFieldNames ? '' : 'createdAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Wishlist clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Wishlist copyWith(void Function(Wishlist) updates) =>
      super.copyWith((message) => updates(message as Wishlist)) as Wishlist;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Wishlist() / Wishlist.new instead')
  static Wishlist create() => Wishlist._();
  static $pb.GeneratedMessage $_createMessage() => Wishlist._();
  @$core.override
  Wishlist createEmptyInstance() => Wishlist._();
  @$core.pragma('dart2js:noInline')
  static Wishlist getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Wishlist>(Wishlist.$_createMessage);
  static Wishlist? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $3.User get user => $_getN(1);
  @$pb.TagNumber(2)
  set user($3.User value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearUser() => $_clearField(2);
  @$pb.TagNumber(2)
  $3.User ensureUser() => $_ensure(1);

  @$pb.TagNumber(3)
  $4.Catalog get catalog => $_getN(2);
  @$pb.TagNumber(3)
  set catalog($4.Catalog value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCatalog() => $_has(2);
  @$pb.TagNumber(3)
  void clearCatalog() => $_clearField(3);
  @$pb.TagNumber(3)
  $4.Catalog ensureCatalog() => $_ensure(2);

  @$pb.TagNumber(4)
  $5.Package get package => $_getN(3);
  @$pb.TagNumber(4)
  set package($5.Package value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPackage() => $_has(3);
  @$pb.TagNumber(4)
  void clearPackage() => $_clearField(4);
  @$pb.TagNumber(4)
  $5.Package ensurePackage() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get createdAt => $_getSZ(4);
  @$pb.TagNumber(5)
  set createdAt($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCreatedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreatedAt() => $_clearField(5);
}

class IsInWishlistResponse extends $pb.GeneratedMessage {
  factory IsInWishlistResponse({
    $core.bool? inWishlist,
  }) {
    final result = IsInWishlistResponse._();
    if (inWishlist != null) result.inWishlist = inWishlist;
    return result;
  }

  IsInWishlistResponse._();

  factory IsInWishlistResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IsInWishlistResponse()..mergeFromBuffer(data, registry);
  factory IsInWishlistResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IsInWishlistResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IsInWishlistResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: IsInWishlistResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'inWishlist')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IsInWishlistResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IsInWishlistResponse copyWith(void Function(IsInWishlistResponse) updates) =>
      super.copyWith((message) => updates(message as IsInWishlistResponse))
          as IsInWishlistResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use IsInWishlistResponse() / IsInWishlistResponse.new instead')
  static IsInWishlistResponse create() => IsInWishlistResponse._();
  static $pb.GeneratedMessage $_createMessage() => IsInWishlistResponse._();
  @$core.override
  IsInWishlistResponse createEmptyInstance() => IsInWishlistResponse._();
  @$core.pragma('dart2js:noInline')
  static IsInWishlistResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IsInWishlistResponse>(
          IsInWishlistResponse.$_createMessage);
  static IsInWishlistResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get inWishlist => $_getBF(0);
  @$pb.TagNumber(1)
  set inWishlist($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInWishlist() => $_has(0);
  @$pb.TagNumber(1)
  void clearInWishlist() => $_clearField(1);
}

class WishlistActionResponse extends $pb.GeneratedMessage {
  factory WishlistActionResponse({
    Wishlist? wishlist,
    $2.WishlistActionType? action,
    $core.String? message,
  }) {
    final result = WishlistActionResponse._();
    if (wishlist != null) result.wishlist = wishlist;
    if (action != null) result.action = action;
    if (message != null) result.message = message;
    return result;
  }

  WishlistActionResponse._();

  factory WishlistActionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WishlistActionResponse()..mergeFromBuffer(data, registry);
  factory WishlistActionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WishlistActionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WishlistActionResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: WishlistActionResponse.$_createMessage)
    ..aOM<Wishlist>(1, _omitFieldNames ? '' : 'wishlist',
        subBuilder: Wishlist.$_createMessage)
    ..aE<$2.WishlistActionType>(2, _omitFieldNames ? '' : 'action',
        enumValues: $2.WishlistActionType.values)
    ..aOS(3, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WishlistActionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WishlistActionResponse copyWith(
          void Function(WishlistActionResponse) updates) =>
      super.copyWith((message) => updates(message as WishlistActionResponse))
          as WishlistActionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WishlistActionResponse() / WishlistActionResponse.new instead')
  static WishlistActionResponse create() => WishlistActionResponse._();
  static $pb.GeneratedMessage $_createMessage() => WishlistActionResponse._();
  @$core.override
  WishlistActionResponse createEmptyInstance() => WishlistActionResponse._();
  @$core.pragma('dart2js:noInline')
  static WishlistActionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WishlistActionResponse>(
          WishlistActionResponse.$_createMessage);
  static WishlistActionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Wishlist get wishlist => $_getN(0);
  @$pb.TagNumber(1)
  set wishlist(Wishlist value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWishlist() => $_has(0);
  @$pb.TagNumber(1)
  void clearWishlist() => $_clearField(1);
  @$pb.TagNumber(1)
  Wishlist ensureWishlist() => $_ensure(0);

  @$pb.TagNumber(2)
  $2.WishlistActionType get action => $_getN(1);
  @$pb.TagNumber(2)
  set action($2.WishlistActionType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAction() => $_has(1);
  @$pb.TagNumber(2)
  void clearAction() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get message => $_getSZ(2);
  @$pb.TagNumber(3)
  set message($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessage() => $_clearField(3);
}

class RemoveFromWishlistResponse extends $pb.GeneratedMessage {
  factory RemoveFromWishlistResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = RemoveFromWishlistResponse._();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  RemoveFromWishlistResponse._();

  factory RemoveFromWishlistResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemoveFromWishlistResponse()..mergeFromBuffer(data, registry);
  factory RemoveFromWishlistResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemoveFromWishlistResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemoveFromWishlistResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: RemoveFromWishlistResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveFromWishlistResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveFromWishlistResponse copyWith(
          void Function(RemoveFromWishlistResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RemoveFromWishlistResponse))
          as RemoveFromWishlistResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RemoveFromWishlistResponse() / RemoveFromWishlistResponse.new instead')
  static RemoveFromWishlistResponse create() => RemoveFromWishlistResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      RemoveFromWishlistResponse._();
  @$core.override
  RemoveFromWishlistResponse createEmptyInstance() =>
      RemoveFromWishlistResponse._();
  @$core.pragma('dart2js:noInline')
  static RemoveFromWishlistResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemoveFromWishlistResponse>(
          RemoveFromWishlistResponse.$_createMessage);
  static RemoveFromWishlistResponse? _defaultInstance;

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

class ClearWishlistResponse extends $pb.GeneratedMessage {
  factory ClearWishlistResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = ClearWishlistResponse._();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  ClearWishlistResponse._();

  factory ClearWishlistResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClearWishlistResponse()..mergeFromBuffer(data, registry);
  factory ClearWishlistResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClearWishlistResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClearWishlistResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ClearWishlistResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearWishlistResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearWishlistResponse copyWith(
          void Function(ClearWishlistResponse) updates) =>
      super.copyWith((message) => updates(message as ClearWishlistResponse))
          as ClearWishlistResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ClearWishlistResponse() / ClearWishlistResponse.new instead')
  static ClearWishlistResponse create() => ClearWishlistResponse._();
  static $pb.GeneratedMessage $_createMessage() => ClearWishlistResponse._();
  @$core.override
  ClearWishlistResponse createEmptyInstance() => ClearWishlistResponse._();
  @$core.pragma('dart2js:noInline')
  static ClearWishlistResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClearWishlistResponse>(
          ClearWishlistResponse.$_createMessage);
  static ClearWishlistResponse? _defaultInstance;

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

class WishlistShare extends $pb.GeneratedMessage {
  factory WishlistShare({
    $core.String? shareToken,
    $core.String? shareUrl,
    $core.String? expiresAt,
  }) {
    final result = WishlistShare._();
    if (shareToken != null) result.shareToken = shareToken;
    if (shareUrl != null) result.shareUrl = shareUrl;
    if (expiresAt != null) result.expiresAt = expiresAt;
    return result;
  }

  WishlistShare._();

  factory WishlistShare.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WishlistShare()..mergeFromBuffer(data, registry);
  factory WishlistShare.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WishlistShare()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WishlistShare',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: WishlistShare.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'shareToken')
    ..aOS(2, _omitFieldNames ? '' : 'shareUrl')
    ..aOS(3, _omitFieldNames ? '' : 'expiresAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WishlistShare clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WishlistShare copyWith(void Function(WishlistShare) updates) =>
      super.copyWith((message) => updates(message as WishlistShare))
          as WishlistShare;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use WishlistShare() / WishlistShare.new instead')
  static WishlistShare create() => WishlistShare._();
  static $pb.GeneratedMessage $_createMessage() => WishlistShare._();
  @$core.override
  WishlistShare createEmptyInstance() => WishlistShare._();
  @$core.pragma('dart2js:noInline')
  static WishlistShare getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WishlistShare>(
          WishlistShare.$_createMessage);
  static WishlistShare? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get shareToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set shareToken($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasShareToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearShareToken() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get shareUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set shareUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasShareUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearShareUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get expiresAt => $_getSZ(2);
  @$pb.TagNumber(3)
  set expiresAt($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpiresAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpiresAt() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
