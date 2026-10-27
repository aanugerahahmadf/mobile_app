// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/voucher.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'auth.pb.dart' as $5;
import 'catalog.pb.dart' as $2;
import 'category.pb.dart' as $4;
import 'common.pb.dart' as $1;
import 'package.pb.dart' as $3;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GetMyVouchersRequest extends $pb.GeneratedMessage {
  factory GetMyVouchersRequest({
    $1.PaginationRequest? pagination,
  }) {
    final result = GetMyVouchersRequest._();
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  GetMyVouchersRequest._();

  factory GetMyVouchersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMyVouchersRequest()..mergeFromBuffer(data, registry);
  factory GetMyVouchersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMyVouchersRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMyVouchersRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetMyVouchersRequest.$_createMessage)
    ..aOM<$1.PaginationRequest>(1, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginationRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMyVouchersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMyVouchersRequest copyWith(void Function(GetMyVouchersRequest) updates) =>
      super.copyWith((message) => updates(message as GetMyVouchersRequest))
          as GetMyVouchersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetMyVouchersRequest() / GetMyVouchersRequest.new instead')
  static GetMyVouchersRequest create() => GetMyVouchersRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetMyVouchersRequest._();
  @$core.override
  GetMyVouchersRequest createEmptyInstance() => GetMyVouchersRequest._();
  @$core.pragma('dart2js:noInline')
  static GetMyVouchersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMyVouchersRequest>(
          GetMyVouchersRequest.$_createMessage);
  static GetMyVouchersRequest? _defaultInstance;

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
}

class GetVoucherByCodeRequest extends $pb.GeneratedMessage {
  factory GetVoucherByCodeRequest({
    $core.String? code,
  }) {
    final result = GetVoucherByCodeRequest._();
    if (code != null) result.code = code;
    return result;
  }

  GetVoucherByCodeRequest._();

  factory GetVoucherByCodeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetVoucherByCodeRequest()..mergeFromBuffer(data, registry);
  factory GetVoucherByCodeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetVoucherByCodeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetVoucherByCodeRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetVoucherByCodeRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetVoucherByCodeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetVoucherByCodeRequest copyWith(
          void Function(GetVoucherByCodeRequest) updates) =>
      super.copyWith((message) => updates(message as GetVoucherByCodeRequest))
          as GetVoucherByCodeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetVoucherByCodeRequest() / GetVoucherByCodeRequest.new instead')
  static GetVoucherByCodeRequest create() => GetVoucherByCodeRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetVoucherByCodeRequest._();
  @$core.override
  GetVoucherByCodeRequest createEmptyInstance() => GetVoucherByCodeRequest._();
  @$core.pragma('dart2js:noInline')
  static GetVoucherByCodeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetVoucherByCodeRequest>(
          GetVoucherByCodeRequest.$_createMessage);
  static GetVoucherByCodeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);
}

class ListVouchersRequest extends $pb.GeneratedMessage {
  factory ListVouchersRequest({
    $1.PaginationRequest? pagination,
    $core.String? code,
    $core.bool? active,
    $core.bool? isGlobal,
  }) {
    final result = ListVouchersRequest._();
    if (pagination != null) result.pagination = pagination;
    if (code != null) result.code = code;
    if (active != null) result.active = active;
    if (isGlobal != null) result.isGlobal = isGlobal;
    return result;
  }

  ListVouchersRequest._();

  factory ListVouchersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListVouchersRequest()..mergeFromBuffer(data, registry);
  factory ListVouchersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListVouchersRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListVouchersRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ListVouchersRequest.$_createMessage)
    ..aOM<$1.PaginationRequest>(1, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginationRequest.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOB(3, _omitFieldNames ? '' : 'active')
    ..aOB(4, _omitFieldNames ? '' : 'isGlobal')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListVouchersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListVouchersRequest copyWith(void Function(ListVouchersRequest) updates) =>
      super.copyWith((message) => updates(message as ListVouchersRequest))
          as ListVouchersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ListVouchersRequest() / ListVouchersRequest.new instead')
  static ListVouchersRequest create() => ListVouchersRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListVouchersRequest._();
  @$core.override
  ListVouchersRequest createEmptyInstance() => ListVouchersRequest._();
  @$core.pragma('dart2js:noInline')
  static ListVouchersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListVouchersRequest>(
          ListVouchersRequest.$_createMessage);
  static ListVouchersRequest? _defaultInstance;

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
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get active => $_getBF(2);
  @$pb.TagNumber(3)
  set active($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasActive() => $_has(2);
  @$pb.TagNumber(3)
  void clearActive() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isGlobal => $_getBF(3);
  @$pb.TagNumber(4)
  set isGlobal($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsGlobal() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsGlobal() => $_clearField(4);
}

class GetVoucherStatsRequest extends $pb.GeneratedMessage {
  factory GetVoucherStatsRequest({
    $core.String? voucherId,
  }) {
    final result = GetVoucherStatsRequest._();
    if (voucherId != null) result.voucherId = voucherId;
    return result;
  }

  GetVoucherStatsRequest._();

  factory GetVoucherStatsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetVoucherStatsRequest()..mergeFromBuffer(data, registry);
  factory GetVoucherStatsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetVoucherStatsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetVoucherStatsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetVoucherStatsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'voucherId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetVoucherStatsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetVoucherStatsRequest copyWith(
          void Function(GetVoucherStatsRequest) updates) =>
      super.copyWith((message) => updates(message as GetVoucherStatsRequest))
          as GetVoucherStatsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetVoucherStatsRequest() / GetVoucherStatsRequest.new instead')
  static GetVoucherStatsRequest create() => GetVoucherStatsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetVoucherStatsRequest._();
  @$core.override
  GetVoucherStatsRequest createEmptyInstance() => GetVoucherStatsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetVoucherStatsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetVoucherStatsRequest>(
          GetVoucherStatsRequest.$_createMessage);
  static GetVoucherStatsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get voucherId => $_getSZ(0);
  @$pb.TagNumber(1)
  set voucherId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVoucherId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVoucherId() => $_clearField(1);
}

class ValidateVoucherRequest extends $pb.GeneratedMessage {
  factory ValidateVoucherRequest({
    $core.String? code,
    $core.double? cartTotal,
    $core.Iterable<ValidateVoucherItemInput>? items,
  }) {
    final result = ValidateVoucherRequest._();
    if (code != null) result.code = code;
    if (cartTotal != null) result.cartTotal = cartTotal;
    if (items != null) result.items.addAll(items);
    return result;
  }

  ValidateVoucherRequest._();

  factory ValidateVoucherRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ValidateVoucherRequest()..mergeFromBuffer(data, registry);
  factory ValidateVoucherRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ValidateVoucherRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ValidateVoucherRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ValidateVoucherRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aD(2, _omitFieldNames ? '' : 'cartTotal')
    ..pPM<ValidateVoucherItemInput>(3, _omitFieldNames ? '' : 'items',
        subBuilder: ValidateVoucherItemInput.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ValidateVoucherRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ValidateVoucherRequest copyWith(
          void Function(ValidateVoucherRequest) updates) =>
      super.copyWith((message) => updates(message as ValidateVoucherRequest))
          as ValidateVoucherRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ValidateVoucherRequest() / ValidateVoucherRequest.new instead')
  static ValidateVoucherRequest create() => ValidateVoucherRequest._();
  static $pb.GeneratedMessage $_createMessage() => ValidateVoucherRequest._();
  @$core.override
  ValidateVoucherRequest createEmptyInstance() => ValidateVoucherRequest._();
  @$core.pragma('dart2js:noInline')
  static ValidateVoucherRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ValidateVoucherRequest>(
          ValidateVoucherRequest.$_createMessage);
  static ValidateVoucherRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get cartTotal => $_getN(1);
  @$pb.TagNumber(2)
  set cartTotal($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCartTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearCartTotal() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<ValidateVoucherItemInput> get items => $_getList(2);
}

class CreateVoucherRequest extends $pb.GeneratedMessage {
  factory CreateVoucherRequest({
    $core.String? name,
    $core.String? code,
    $core.String? description,
    $core.double? discountAmount,
    $1.DiscountType? discountType,
    $core.double? minPurchase,
    $core.double? maxDiscount,
    $core.int? usageLimit,
    $core.int? usageLimitPerUser,
    $core.String? validFrom,
    $core.String? validUntil,
    $core.bool? isGlobal,
    $core.Iterable<$core.String>? applicableCatalogs,
    $core.Iterable<$core.String>? applicablePackages,
    $core.Iterable<$core.String>? applicableCategories,
    $core.Iterable<$core.String>? excludedCatalogs,
    $core.Iterable<$core.String>? excludedPackages,
    $core.Iterable<$core.String>? excludedCategories,
    $core.Iterable<$core.String>? userIds,
  }) {
    final result = CreateVoucherRequest._();
    if (name != null) result.name = name;
    if (code != null) result.code = code;
    if (description != null) result.description = description;
    if (discountAmount != null) result.discountAmount = discountAmount;
    if (discountType != null) result.discountType = discountType;
    if (minPurchase != null) result.minPurchase = minPurchase;
    if (maxDiscount != null) result.maxDiscount = maxDiscount;
    if (usageLimit != null) result.usageLimit = usageLimit;
    if (usageLimitPerUser != null) result.usageLimitPerUser = usageLimitPerUser;
    if (validFrom != null) result.validFrom = validFrom;
    if (validUntil != null) result.validUntil = validUntil;
    if (isGlobal != null) result.isGlobal = isGlobal;
    if (applicableCatalogs != null)
      result.applicableCatalogs.addAll(applicableCatalogs);
    if (applicablePackages != null)
      result.applicablePackages.addAll(applicablePackages);
    if (applicableCategories != null)
      result.applicableCategories.addAll(applicableCategories);
    if (excludedCatalogs != null)
      result.excludedCatalogs.addAll(excludedCatalogs);
    if (excludedPackages != null)
      result.excludedPackages.addAll(excludedPackages);
    if (excludedCategories != null)
      result.excludedCategories.addAll(excludedCategories);
    if (userIds != null) result.userIds.addAll(userIds);
    return result;
  }

  CreateVoucherRequest._();

  factory CreateVoucherRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateVoucherRequest()..mergeFromBuffer(data, registry);
  factory CreateVoucherRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateVoucherRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateVoucherRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: CreateVoucherRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..aD(4, _omitFieldNames ? '' : 'discountAmount')
    ..aE<$1.DiscountType>(5, _omitFieldNames ? '' : 'discountType',
        enumValues: $1.DiscountType.values)
    ..aD(6, _omitFieldNames ? '' : 'minPurchase')
    ..aD(7, _omitFieldNames ? '' : 'maxDiscount')
    ..aI(8, _omitFieldNames ? '' : 'usageLimit')
    ..aI(9, _omitFieldNames ? '' : 'usageLimitPerUser')
    ..aOS(10, _omitFieldNames ? '' : 'validFrom')
    ..aOS(11, _omitFieldNames ? '' : 'validUntil')
    ..aOB(12, _omitFieldNames ? '' : 'isGlobal')
    ..pPS(13, _omitFieldNames ? '' : 'applicableCatalogs')
    ..pPS(14, _omitFieldNames ? '' : 'applicablePackages')
    ..pPS(15, _omitFieldNames ? '' : 'applicableCategories')
    ..pPS(16, _omitFieldNames ? '' : 'excludedCatalogs')
    ..pPS(17, _omitFieldNames ? '' : 'excludedPackages')
    ..pPS(18, _omitFieldNames ? '' : 'excludedCategories')
    ..pPS(19, _omitFieldNames ? '' : 'userIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateVoucherRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateVoucherRequest copyWith(void Function(CreateVoucherRequest) updates) =>
      super.copyWith((message) => updates(message as CreateVoucherRequest))
          as CreateVoucherRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateVoucherRequest() / CreateVoucherRequest.new instead')
  static CreateVoucherRequest create() => CreateVoucherRequest._();
  static $pb.GeneratedMessage $_createMessage() => CreateVoucherRequest._();
  @$core.override
  CreateVoucherRequest createEmptyInstance() => CreateVoucherRequest._();
  @$core.pragma('dart2js:noInline')
  static CreateVoucherRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateVoucherRequest>(
          CreateVoucherRequest.$_createMessage);
  static CreateVoucherRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get discountAmount => $_getN(3);
  @$pb.TagNumber(4)
  set discountAmount($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDiscountAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearDiscountAmount() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.DiscountType get discountType => $_getN(4);
  @$pb.TagNumber(5)
  set discountType($1.DiscountType value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasDiscountType() => $_has(4);
  @$pb.TagNumber(5)
  void clearDiscountType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get minPurchase => $_getN(5);
  @$pb.TagNumber(6)
  set minPurchase($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMinPurchase() => $_has(5);
  @$pb.TagNumber(6)
  void clearMinPurchase() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get maxDiscount => $_getN(6);
  @$pb.TagNumber(7)
  set maxDiscount($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMaxDiscount() => $_has(6);
  @$pb.TagNumber(7)
  void clearMaxDiscount() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get usageLimit => $_getIZ(7);
  @$pb.TagNumber(8)
  set usageLimit($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasUsageLimit() => $_has(7);
  @$pb.TagNumber(8)
  void clearUsageLimit() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get usageLimitPerUser => $_getIZ(8);
  @$pb.TagNumber(9)
  set usageLimitPerUser($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasUsageLimitPerUser() => $_has(8);
  @$pb.TagNumber(9)
  void clearUsageLimitPerUser() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get validFrom => $_getSZ(9);
  @$pb.TagNumber(10)
  set validFrom($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasValidFrom() => $_has(9);
  @$pb.TagNumber(10)
  void clearValidFrom() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get validUntil => $_getSZ(10);
  @$pb.TagNumber(11)
  set validUntil($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasValidUntil() => $_has(10);
  @$pb.TagNumber(11)
  void clearValidUntil() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get isGlobal => $_getBF(11);
  @$pb.TagNumber(12)
  set isGlobal($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasIsGlobal() => $_has(11);
  @$pb.TagNumber(12)
  void clearIsGlobal() => $_clearField(12);

  @$pb.TagNumber(13)
  $pb.PbList<$core.String> get applicableCatalogs => $_getList(12);

  @$pb.TagNumber(14)
  $pb.PbList<$core.String> get applicablePackages => $_getList(13);

  @$pb.TagNumber(15)
  $pb.PbList<$core.String> get applicableCategories => $_getList(14);

  @$pb.TagNumber(16)
  $pb.PbList<$core.String> get excludedCatalogs => $_getList(15);

  @$pb.TagNumber(17)
  $pb.PbList<$core.String> get excludedPackages => $_getList(16);

  @$pb.TagNumber(18)
  $pb.PbList<$core.String> get excludedCategories => $_getList(17);

  @$pb.TagNumber(19)
  $pb.PbList<$core.String> get userIds => $_getList(18);
}

class UpdateVoucherRequest extends $pb.GeneratedMessage {
  factory UpdateVoucherRequest({
    $core.String? id,
    $core.String? name,
    $core.String? description,
    $core.double? discountAmount,
    $1.DiscountType? discountType,
    $core.double? minPurchase,
    $core.double? maxDiscount,
    $core.int? usageLimit,
    $core.int? usageLimitPerUser,
    $core.String? validFrom,
    $core.String? validUntil,
    $core.bool? isActive,
    $core.bool? isGlobal,
    $core.Iterable<$core.String>? applicableCatalogs,
    $core.Iterable<$core.String>? applicablePackages,
    $core.Iterable<$core.String>? applicableCategories,
    $core.Iterable<$core.String>? excludedCatalogs,
    $core.Iterable<$core.String>? excludedPackages,
    $core.Iterable<$core.String>? excludedCategories,
    $core.Iterable<$core.String>? userIds,
  }) {
    final result = UpdateVoucherRequest._();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (description != null) result.description = description;
    if (discountAmount != null) result.discountAmount = discountAmount;
    if (discountType != null) result.discountType = discountType;
    if (minPurchase != null) result.minPurchase = minPurchase;
    if (maxDiscount != null) result.maxDiscount = maxDiscount;
    if (usageLimit != null) result.usageLimit = usageLimit;
    if (usageLimitPerUser != null) result.usageLimitPerUser = usageLimitPerUser;
    if (validFrom != null) result.validFrom = validFrom;
    if (validUntil != null) result.validUntil = validUntil;
    if (isActive != null) result.isActive = isActive;
    if (isGlobal != null) result.isGlobal = isGlobal;
    if (applicableCatalogs != null)
      result.applicableCatalogs.addAll(applicableCatalogs);
    if (applicablePackages != null)
      result.applicablePackages.addAll(applicablePackages);
    if (applicableCategories != null)
      result.applicableCategories.addAll(applicableCategories);
    if (excludedCatalogs != null)
      result.excludedCatalogs.addAll(excludedCatalogs);
    if (excludedPackages != null)
      result.excludedPackages.addAll(excludedPackages);
    if (excludedCategories != null)
      result.excludedCategories.addAll(excludedCategories);
    if (userIds != null) result.userIds.addAll(userIds);
    return result;
  }

  UpdateVoucherRequest._();

  factory UpdateVoucherRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateVoucherRequest()..mergeFromBuffer(data, registry);
  factory UpdateVoucherRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateVoucherRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateVoucherRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: UpdateVoucherRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..aD(4, _omitFieldNames ? '' : 'discountAmount')
    ..aE<$1.DiscountType>(5, _omitFieldNames ? '' : 'discountType',
        enumValues: $1.DiscountType.values)
    ..aD(6, _omitFieldNames ? '' : 'minPurchase')
    ..aD(7, _omitFieldNames ? '' : 'maxDiscount')
    ..aI(8, _omitFieldNames ? '' : 'usageLimit')
    ..aI(9, _omitFieldNames ? '' : 'usageLimitPerUser')
    ..aOS(10, _omitFieldNames ? '' : 'validFrom')
    ..aOS(11, _omitFieldNames ? '' : 'validUntil')
    ..aOB(12, _omitFieldNames ? '' : 'isActive')
    ..aOB(13, _omitFieldNames ? '' : 'isGlobal')
    ..pPS(14, _omitFieldNames ? '' : 'applicableCatalogs')
    ..pPS(15, _omitFieldNames ? '' : 'applicablePackages')
    ..pPS(16, _omitFieldNames ? '' : 'applicableCategories')
    ..pPS(17, _omitFieldNames ? '' : 'excludedCatalogs')
    ..pPS(18, _omitFieldNames ? '' : 'excludedPackages')
    ..pPS(19, _omitFieldNames ? '' : 'excludedCategories')
    ..pPS(20, _omitFieldNames ? '' : 'userIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateVoucherRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateVoucherRequest copyWith(void Function(UpdateVoucherRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateVoucherRequest))
          as UpdateVoucherRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateVoucherRequest() / UpdateVoucherRequest.new instead')
  static UpdateVoucherRequest create() => UpdateVoucherRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdateVoucherRequest._();
  @$core.override
  UpdateVoucherRequest createEmptyInstance() => UpdateVoucherRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateVoucherRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateVoucherRequest>(
          UpdateVoucherRequest.$_createMessage);
  static UpdateVoucherRequest? _defaultInstance;

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
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get discountAmount => $_getN(3);
  @$pb.TagNumber(4)
  set discountAmount($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDiscountAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearDiscountAmount() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.DiscountType get discountType => $_getN(4);
  @$pb.TagNumber(5)
  set discountType($1.DiscountType value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasDiscountType() => $_has(4);
  @$pb.TagNumber(5)
  void clearDiscountType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get minPurchase => $_getN(5);
  @$pb.TagNumber(6)
  set minPurchase($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMinPurchase() => $_has(5);
  @$pb.TagNumber(6)
  void clearMinPurchase() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get maxDiscount => $_getN(6);
  @$pb.TagNumber(7)
  set maxDiscount($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMaxDiscount() => $_has(6);
  @$pb.TagNumber(7)
  void clearMaxDiscount() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get usageLimit => $_getIZ(7);
  @$pb.TagNumber(8)
  set usageLimit($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasUsageLimit() => $_has(7);
  @$pb.TagNumber(8)
  void clearUsageLimit() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get usageLimitPerUser => $_getIZ(8);
  @$pb.TagNumber(9)
  set usageLimitPerUser($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasUsageLimitPerUser() => $_has(8);
  @$pb.TagNumber(9)
  void clearUsageLimitPerUser() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get validFrom => $_getSZ(9);
  @$pb.TagNumber(10)
  set validFrom($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasValidFrom() => $_has(9);
  @$pb.TagNumber(10)
  void clearValidFrom() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get validUntil => $_getSZ(10);
  @$pb.TagNumber(11)
  set validUntil($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasValidUntil() => $_has(10);
  @$pb.TagNumber(11)
  void clearValidUntil() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get isActive => $_getBF(11);
  @$pb.TagNumber(12)
  set isActive($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasIsActive() => $_has(11);
  @$pb.TagNumber(12)
  void clearIsActive() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.bool get isGlobal => $_getBF(12);
  @$pb.TagNumber(13)
  set isGlobal($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasIsGlobal() => $_has(12);
  @$pb.TagNumber(13)
  void clearIsGlobal() => $_clearField(13);

  @$pb.TagNumber(14)
  $pb.PbList<$core.String> get applicableCatalogs => $_getList(13);

  @$pb.TagNumber(15)
  $pb.PbList<$core.String> get applicablePackages => $_getList(14);

  @$pb.TagNumber(16)
  $pb.PbList<$core.String> get applicableCategories => $_getList(15);

  @$pb.TagNumber(17)
  $pb.PbList<$core.String> get excludedCatalogs => $_getList(16);

  @$pb.TagNumber(18)
  $pb.PbList<$core.String> get excludedPackages => $_getList(17);

  @$pb.TagNumber(19)
  $pb.PbList<$core.String> get excludedCategories => $_getList(18);

  @$pb.TagNumber(20)
  $pb.PbList<$core.String> get userIds => $_getList(19);
}

class DeleteVoucherRequest extends $pb.GeneratedMessage {
  factory DeleteVoucherRequest({
    $core.String? id,
  }) {
    final result = DeleteVoucherRequest._();
    if (id != null) result.id = id;
    return result;
  }

  DeleteVoucherRequest._();

  factory DeleteVoucherRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteVoucherRequest()..mergeFromBuffer(data, registry);
  factory DeleteVoucherRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteVoucherRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteVoucherRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: DeleteVoucherRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteVoucherRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteVoucherRequest copyWith(void Function(DeleteVoucherRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteVoucherRequest))
          as DeleteVoucherRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DeleteVoucherRequest() / DeleteVoucherRequest.new instead')
  static DeleteVoucherRequest create() => DeleteVoucherRequest._();
  static $pb.GeneratedMessage $_createMessage() => DeleteVoucherRequest._();
  @$core.override
  DeleteVoucherRequest createEmptyInstance() => DeleteVoucherRequest._();
  @$core.pragma('dart2js:noInline')
  static DeleteVoucherRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteVoucherRequest>(
          DeleteVoucherRequest.$_createMessage);
  static DeleteVoucherRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class ToggleVoucherStatusRequest extends $pb.GeneratedMessage {
  factory ToggleVoucherStatusRequest({
    $core.String? id,
  }) {
    final result = ToggleVoucherStatusRequest._();
    if (id != null) result.id = id;
    return result;
  }

  ToggleVoucherStatusRequest._();

  factory ToggleVoucherStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ToggleVoucherStatusRequest()..mergeFromBuffer(data, registry);
  factory ToggleVoucherStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ToggleVoucherStatusRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToggleVoucherStatusRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ToggleVoucherStatusRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToggleVoucherStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToggleVoucherStatusRequest copyWith(
          void Function(ToggleVoucherStatusRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ToggleVoucherStatusRequest))
          as ToggleVoucherStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ToggleVoucherStatusRequest() / ToggleVoucherStatusRequest.new instead')
  static ToggleVoucherStatusRequest create() => ToggleVoucherStatusRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ToggleVoucherStatusRequest._();
  @$core.override
  ToggleVoucherStatusRequest createEmptyInstance() =>
      ToggleVoucherStatusRequest._();
  @$core.pragma('dart2js:noInline')
  static ToggleVoucherStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ToggleVoucherStatusRequest>(
          ToggleVoucherStatusRequest.$_createMessage);
  static ToggleVoucherStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class BulkCreateVouchersRequest extends $pb.GeneratedMessage {
  factory BulkCreateVouchersRequest({
    $core.String? prefix,
    $core.int? count,
    $core.double? discountAmount,
    $1.DiscountType? discountType,
    $core.double? minPurchase,
    $core.double? maxDiscount,
    $core.int? usageLimit,
    $core.int? usageLimitPerUser,
    $core.String? validFrom,
    $core.String? validUntil,
    $core.int? length,
  }) {
    final result = BulkCreateVouchersRequest._();
    if (prefix != null) result.prefix = prefix;
    if (count != null) result.count = count;
    if (discountAmount != null) result.discountAmount = discountAmount;
    if (discountType != null) result.discountType = discountType;
    if (minPurchase != null) result.minPurchase = minPurchase;
    if (maxDiscount != null) result.maxDiscount = maxDiscount;
    if (usageLimit != null) result.usageLimit = usageLimit;
    if (usageLimitPerUser != null) result.usageLimitPerUser = usageLimitPerUser;
    if (validFrom != null) result.validFrom = validFrom;
    if (validUntil != null) result.validUntil = validUntil;
    if (length != null) result.length = length;
    return result;
  }

  BulkCreateVouchersRequest._();

  factory BulkCreateVouchersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BulkCreateVouchersRequest()..mergeFromBuffer(data, registry);
  factory BulkCreateVouchersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BulkCreateVouchersRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BulkCreateVouchersRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: BulkCreateVouchersRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'prefix')
    ..aI(2, _omitFieldNames ? '' : 'count')
    ..aD(3, _omitFieldNames ? '' : 'discountAmount')
    ..aE<$1.DiscountType>(4, _omitFieldNames ? '' : 'discountType',
        enumValues: $1.DiscountType.values)
    ..aD(5, _omitFieldNames ? '' : 'minPurchase')
    ..aD(6, _omitFieldNames ? '' : 'maxDiscount')
    ..aI(7, _omitFieldNames ? '' : 'usageLimit')
    ..aI(8, _omitFieldNames ? '' : 'usageLimitPerUser')
    ..aOS(9, _omitFieldNames ? '' : 'validFrom')
    ..aOS(10, _omitFieldNames ? '' : 'validUntil')
    ..aI(11, _omitFieldNames ? '' : 'length')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BulkCreateVouchersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BulkCreateVouchersRequest copyWith(
          void Function(BulkCreateVouchersRequest) updates) =>
      super.copyWith((message) => updates(message as BulkCreateVouchersRequest))
          as BulkCreateVouchersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use BulkCreateVouchersRequest() / BulkCreateVouchersRequest.new instead')
  static BulkCreateVouchersRequest create() => BulkCreateVouchersRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      BulkCreateVouchersRequest._();
  @$core.override
  BulkCreateVouchersRequest createEmptyInstance() =>
      BulkCreateVouchersRequest._();
  @$core.pragma('dart2js:noInline')
  static BulkCreateVouchersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BulkCreateVouchersRequest>(
          BulkCreateVouchersRequest.$_createMessage);
  static BulkCreateVouchersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get prefix => $_getSZ(0);
  @$pb.TagNumber(1)
  set prefix($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPrefix() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrefix() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get count => $_getIZ(1);
  @$pb.TagNumber(2)
  set count($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get discountAmount => $_getN(2);
  @$pb.TagNumber(3)
  set discountAmount($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDiscountAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearDiscountAmount() => $_clearField(3);

  @$pb.TagNumber(4)
  $1.DiscountType get discountType => $_getN(3);
  @$pb.TagNumber(4)
  set discountType($1.DiscountType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDiscountType() => $_has(3);
  @$pb.TagNumber(4)
  void clearDiscountType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get minPurchase => $_getN(4);
  @$pb.TagNumber(5)
  set minPurchase($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMinPurchase() => $_has(4);
  @$pb.TagNumber(5)
  void clearMinPurchase() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get maxDiscount => $_getN(5);
  @$pb.TagNumber(6)
  set maxDiscount($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMaxDiscount() => $_has(5);
  @$pb.TagNumber(6)
  void clearMaxDiscount() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get usageLimit => $_getIZ(6);
  @$pb.TagNumber(7)
  set usageLimit($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasUsageLimit() => $_has(6);
  @$pb.TagNumber(7)
  void clearUsageLimit() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get usageLimitPerUser => $_getIZ(7);
  @$pb.TagNumber(8)
  set usageLimitPerUser($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasUsageLimitPerUser() => $_has(7);
  @$pb.TagNumber(8)
  void clearUsageLimitPerUser() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get validFrom => $_getSZ(8);
  @$pb.TagNumber(9)
  set validFrom($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasValidFrom() => $_has(8);
  @$pb.TagNumber(9)
  void clearValidFrom() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get validUntil => $_getSZ(9);
  @$pb.TagNumber(10)
  set validUntil($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasValidUntil() => $_has(9);
  @$pb.TagNumber(10)
  void clearValidUntil() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get length => $_getIZ(10);
  @$pb.TagNumber(11)
  set length($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasLength() => $_has(10);
  @$pb.TagNumber(11)
  void clearLength() => $_clearField(11);
}

class ExportVoucherCodesRequest extends $pb.GeneratedMessage {
  factory ExportVoucherCodesRequest({
    $core.String? voucherId,
  }) {
    final result = ExportVoucherCodesRequest._();
    if (voucherId != null) result.voucherId = voucherId;
    return result;
  }

  ExportVoucherCodesRequest._();

  factory ExportVoucherCodesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExportVoucherCodesRequest()..mergeFromBuffer(data, registry);
  factory ExportVoucherCodesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExportVoucherCodesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExportVoucherCodesRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ExportVoucherCodesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'voucherId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExportVoucherCodesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExportVoucherCodesRequest copyWith(
          void Function(ExportVoucherCodesRequest) updates) =>
      super.copyWith((message) => updates(message as ExportVoucherCodesRequest))
          as ExportVoucherCodesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ExportVoucherCodesRequest() / ExportVoucherCodesRequest.new instead')
  static ExportVoucherCodesRequest create() => ExportVoucherCodesRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ExportVoucherCodesRequest._();
  @$core.override
  ExportVoucherCodesRequest createEmptyInstance() =>
      ExportVoucherCodesRequest._();
  @$core.pragma('dart2js:noInline')
  static ExportVoucherCodesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExportVoucherCodesRequest>(
          ExportVoucherCodesRequest.$_createMessage);
  static ExportVoucherCodesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get voucherId => $_getSZ(0);
  @$pb.TagNumber(1)
  set voucherId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVoucherId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVoucherId() => $_clearField(1);
}

class VoucherListResponse extends $pb.GeneratedMessage {
  factory VoucherListResponse({
    $core.Iterable<Voucher>? vouchers,
    $1.PaginationResponse? pagination,
  }) {
    final result = VoucherListResponse._();
    if (vouchers != null) result.vouchers.addAll(vouchers);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  VoucherListResponse._();

  factory VoucherListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoucherListResponse()..mergeFromBuffer(data, registry);
  factory VoucherListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoucherListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VoucherListResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: VoucherListResponse.$_createMessage)
    ..pPM<Voucher>(1, _omitFieldNames ? '' : 'vouchers',
        subBuilder: Voucher.$_createMessage)
    ..aOM<$1.PaginationResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginationResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoucherListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoucherListResponse copyWith(void Function(VoucherListResponse) updates) =>
      super.copyWith((message) => updates(message as VoucherListResponse))
          as VoucherListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use VoucherListResponse() / VoucherListResponse.new instead')
  static VoucherListResponse create() => VoucherListResponse._();
  static $pb.GeneratedMessage $_createMessage() => VoucherListResponse._();
  @$core.override
  VoucherListResponse createEmptyInstance() => VoucherListResponse._();
  @$core.pragma('dart2js:noInline')
  static VoucherListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VoucherListResponse>(
          VoucherListResponse.$_createMessage);
  static VoucherListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Voucher> get vouchers => $_getList(0);

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

class Voucher extends $pb.GeneratedMessage {
  factory Voucher({
    $core.String? id,
    $core.String? name,
    $core.String? code,
    $core.String? description,
    $core.bool? isActive,
    $core.bool? isGlobal,
    $core.int? maxUses,
    $core.int? usesCount,
    $core.String? expiresAt,
    $core.double? discountAmount,
    $1.DiscountType? discountType,
    $core.double? minPurchase,
    $core.double? maxDiscount,
    $core.Iterable<$2.Catalog>? applicableCatalogs,
    $core.Iterable<$3.Package>? applicablePackages,
    $core.Iterable<$4.Category>? applicableCategories,
    $core.Iterable<$2.Catalog>? excludedCatalogs,
    $core.Iterable<$3.Package>? excludedPackages,
    $core.Iterable<$4.Category>? excludedCategories,
    $core.Iterable<$5.User>? users,
    $core.String? createdAt,
    $core.String? updatedAt,
  }) {
    final result = Voucher._();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (code != null) result.code = code;
    if (description != null) result.description = description;
    if (isActive != null) result.isActive = isActive;
    if (isGlobal != null) result.isGlobal = isGlobal;
    if (maxUses != null) result.maxUses = maxUses;
    if (usesCount != null) result.usesCount = usesCount;
    if (expiresAt != null) result.expiresAt = expiresAt;
    if (discountAmount != null) result.discountAmount = discountAmount;
    if (discountType != null) result.discountType = discountType;
    if (minPurchase != null) result.minPurchase = minPurchase;
    if (maxDiscount != null) result.maxDiscount = maxDiscount;
    if (applicableCatalogs != null)
      result.applicableCatalogs.addAll(applicableCatalogs);
    if (applicablePackages != null)
      result.applicablePackages.addAll(applicablePackages);
    if (applicableCategories != null)
      result.applicableCategories.addAll(applicableCategories);
    if (excludedCatalogs != null)
      result.excludedCatalogs.addAll(excludedCatalogs);
    if (excludedPackages != null)
      result.excludedPackages.addAll(excludedPackages);
    if (excludedCategories != null)
      result.excludedCategories.addAll(excludedCategories);
    if (users != null) result.users.addAll(users);
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  Voucher._();

  factory Voucher.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Voucher()..mergeFromBuffer(data, registry);
  factory Voucher.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Voucher()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Voucher',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: Voucher.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'code')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOB(5, _omitFieldNames ? '' : 'isActive')
    ..aOB(6, _omitFieldNames ? '' : 'isGlobal')
    ..aI(7, _omitFieldNames ? '' : 'maxUses')
    ..aI(8, _omitFieldNames ? '' : 'usesCount')
    ..aOS(9, _omitFieldNames ? '' : 'expiresAt')
    ..aD(10, _omitFieldNames ? '' : 'discountAmount')
    ..aE<$1.DiscountType>(11, _omitFieldNames ? '' : 'discountType',
        enumValues: $1.DiscountType.values)
    ..aD(12, _omitFieldNames ? '' : 'minPurchase')
    ..aD(13, _omitFieldNames ? '' : 'maxDiscount')
    ..pPM<$2.Catalog>(14, _omitFieldNames ? '' : 'applicableCatalogs',
        subBuilder: $2.Catalog.$_createMessage)
    ..pPM<$3.Package>(15, _omitFieldNames ? '' : 'applicablePackages',
        subBuilder: $3.Package.$_createMessage)
    ..pPM<$4.Category>(16, _omitFieldNames ? '' : 'applicableCategories',
        subBuilder: $4.Category.$_createMessage)
    ..pPM<$2.Catalog>(17, _omitFieldNames ? '' : 'excludedCatalogs',
        subBuilder: $2.Catalog.$_createMessage)
    ..pPM<$3.Package>(18, _omitFieldNames ? '' : 'excludedPackages',
        subBuilder: $3.Package.$_createMessage)
    ..pPM<$4.Category>(19, _omitFieldNames ? '' : 'excludedCategories',
        subBuilder: $4.Category.$_createMessage)
    ..pPM<$5.User>(20, _omitFieldNames ? '' : 'users',
        subBuilder: $5.User.$_createMessage)
    ..aOS(21, _omitFieldNames ? '' : 'createdAt')
    ..aOS(22, _omitFieldNames ? '' : 'updatedAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Voucher clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Voucher copyWith(void Function(Voucher) updates) =>
      super.copyWith((message) => updates(message as Voucher)) as Voucher;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Voucher() / Voucher.new instead')
  static Voucher create() => Voucher._();
  static $pb.GeneratedMessage $_createMessage() => Voucher._();
  @$core.override
  Voucher createEmptyInstance() => Voucher._();
  @$core.pragma('dart2js:noInline')
  static Voucher getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Voucher>(Voucher.$_createMessage);
  static Voucher? _defaultInstance;

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
  $core.String get code => $_getSZ(2);
  @$pb.TagNumber(3)
  set code($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get isActive => $_getBF(4);
  @$pb.TagNumber(5)
  set isActive($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsActive() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsActive() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isGlobal => $_getBF(5);
  @$pb.TagNumber(6)
  set isGlobal($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsGlobal() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsGlobal() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get maxUses => $_getIZ(6);
  @$pb.TagNumber(7)
  set maxUses($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMaxUses() => $_has(6);
  @$pb.TagNumber(7)
  void clearMaxUses() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get usesCount => $_getIZ(7);
  @$pb.TagNumber(8)
  set usesCount($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasUsesCount() => $_has(7);
  @$pb.TagNumber(8)
  void clearUsesCount() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get expiresAt => $_getSZ(8);
  @$pb.TagNumber(9)
  set expiresAt($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasExpiresAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearExpiresAt() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get discountAmount => $_getN(9);
  @$pb.TagNumber(10)
  set discountAmount($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasDiscountAmount() => $_has(9);
  @$pb.TagNumber(10)
  void clearDiscountAmount() => $_clearField(10);

  @$pb.TagNumber(11)
  $1.DiscountType get discountType => $_getN(10);
  @$pb.TagNumber(11)
  set discountType($1.DiscountType value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasDiscountType() => $_has(10);
  @$pb.TagNumber(11)
  void clearDiscountType() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.double get minPurchase => $_getN(11);
  @$pb.TagNumber(12)
  set minPurchase($core.double value) => $_setDouble(11, value);
  @$pb.TagNumber(12)
  $core.bool hasMinPurchase() => $_has(11);
  @$pb.TagNumber(12)
  void clearMinPurchase() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.double get maxDiscount => $_getN(12);
  @$pb.TagNumber(13)
  set maxDiscount($core.double value) => $_setDouble(12, value);
  @$pb.TagNumber(13)
  $core.bool hasMaxDiscount() => $_has(12);
  @$pb.TagNumber(13)
  void clearMaxDiscount() => $_clearField(13);

  @$pb.TagNumber(14)
  $pb.PbList<$2.Catalog> get applicableCatalogs => $_getList(13);

  @$pb.TagNumber(15)
  $pb.PbList<$3.Package> get applicablePackages => $_getList(14);

  @$pb.TagNumber(16)
  $pb.PbList<$4.Category> get applicableCategories => $_getList(15);

  @$pb.TagNumber(17)
  $pb.PbList<$2.Catalog> get excludedCatalogs => $_getList(16);

  @$pb.TagNumber(18)
  $pb.PbList<$3.Package> get excludedPackages => $_getList(17);

  @$pb.TagNumber(19)
  $pb.PbList<$4.Category> get excludedCategories => $_getList(18);

  @$pb.TagNumber(20)
  $pb.PbList<$5.User> get users => $_getList(19);

  @$pb.TagNumber(21)
  $core.String get createdAt => $_getSZ(20);
  @$pb.TagNumber(21)
  set createdAt($core.String value) => $_setString(20, value);
  @$pb.TagNumber(21)
  $core.bool hasCreatedAt() => $_has(20);
  @$pb.TagNumber(21)
  void clearCreatedAt() => $_clearField(21);

  @$pb.TagNumber(22)
  $core.String get updatedAt => $_getSZ(21);
  @$pb.TagNumber(22)
  set updatedAt($core.String value) => $_setString(21, value);
  @$pb.TagNumber(22)
  $core.bool hasUpdatedAt() => $_has(21);
  @$pb.TagNumber(22)
  void clearUpdatedAt() => $_clearField(22);
}

class VoucherValidation extends $pb.GeneratedMessage {
  factory VoucherValidation({
    $core.bool? valid,
    Voucher? voucher,
    $core.double? discount,
    $core.String? message,
    $core.Iterable<ValidatedItem>? appliedItems,
  }) {
    final result = VoucherValidation._();
    if (valid != null) result.valid = valid;
    if (voucher != null) result.voucher = voucher;
    if (discount != null) result.discount = discount;
    if (message != null) result.message = message;
    if (appliedItems != null) result.appliedItems.addAll(appliedItems);
    return result;
  }

  VoucherValidation._();

  factory VoucherValidation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoucherValidation()..mergeFromBuffer(data, registry);
  factory VoucherValidation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoucherValidation()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VoucherValidation',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: VoucherValidation.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'valid')
    ..aOM<Voucher>(2, _omitFieldNames ? '' : 'voucher',
        subBuilder: Voucher.$_createMessage)
    ..aD(3, _omitFieldNames ? '' : 'discount')
    ..aOS(4, _omitFieldNames ? '' : 'message')
    ..pPM<ValidatedItem>(5, _omitFieldNames ? '' : 'appliedItems',
        subBuilder: ValidatedItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoucherValidation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoucherValidation copyWith(void Function(VoucherValidation) updates) =>
      super.copyWith((message) => updates(message as VoucherValidation))
          as VoucherValidation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use VoucherValidation() / VoucherValidation.new instead')
  static VoucherValidation create() => VoucherValidation._();
  static $pb.GeneratedMessage $_createMessage() => VoucherValidation._();
  @$core.override
  VoucherValidation createEmptyInstance() => VoucherValidation._();
  @$core.pragma('dart2js:noInline')
  static VoucherValidation getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VoucherValidation>(
          VoucherValidation.$_createMessage);
  static VoucherValidation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get valid => $_getBF(0);
  @$pb.TagNumber(1)
  set valid($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValid() => $_has(0);
  @$pb.TagNumber(1)
  void clearValid() => $_clearField(1);

  @$pb.TagNumber(2)
  Voucher get voucher => $_getN(1);
  @$pb.TagNumber(2)
  set voucher(Voucher value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasVoucher() => $_has(1);
  @$pb.TagNumber(2)
  void clearVoucher() => $_clearField(2);
  @$pb.TagNumber(2)
  Voucher ensureVoucher() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.double get discount => $_getN(2);
  @$pb.TagNumber(3)
  set discount($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDiscount() => $_has(2);
  @$pb.TagNumber(3)
  void clearDiscount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get message => $_getSZ(3);
  @$pb.TagNumber(4)
  set message($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMessage() => $_has(3);
  @$pb.TagNumber(4)
  void clearMessage() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<ValidatedItem> get appliedItems => $_getList(4);
}

class ValidatedItem extends $pb.GeneratedMessage {
  factory ValidatedItem({
    $core.String? id,
    $core.String? type,
    $core.double? originalPrice,
    $core.double? discountedPrice,
    $core.double? discount,
  }) {
    final result = ValidatedItem._();
    if (id != null) result.id = id;
    if (type != null) result.type = type;
    if (originalPrice != null) result.originalPrice = originalPrice;
    if (discountedPrice != null) result.discountedPrice = discountedPrice;
    if (discount != null) result.discount = discount;
    return result;
  }

  ValidatedItem._();

  factory ValidatedItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ValidatedItem()..mergeFromBuffer(data, registry);
  factory ValidatedItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ValidatedItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ValidatedItem',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ValidatedItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'type')
    ..aD(3, _omitFieldNames ? '' : 'originalPrice')
    ..aD(4, _omitFieldNames ? '' : 'discountedPrice')
    ..aD(5, _omitFieldNames ? '' : 'discount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ValidatedItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ValidatedItem copyWith(void Function(ValidatedItem) updates) =>
      super.copyWith((message) => updates(message as ValidatedItem))
          as ValidatedItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ValidatedItem() / ValidatedItem.new instead')
  static ValidatedItem create() => ValidatedItem._();
  static $pb.GeneratedMessage $_createMessage() => ValidatedItem._();
  @$core.override
  ValidatedItem createEmptyInstance() => ValidatedItem._();
  @$core.pragma('dart2js:noInline')
  static ValidatedItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ValidatedItem>(
          ValidatedItem.$_createMessage);
  static ValidatedItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get type => $_getSZ(1);
  @$pb.TagNumber(2)
  set type($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get originalPrice => $_getN(2);
  @$pb.TagNumber(3)
  set originalPrice($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOriginalPrice() => $_has(2);
  @$pb.TagNumber(3)
  void clearOriginalPrice() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get discountedPrice => $_getN(3);
  @$pb.TagNumber(4)
  set discountedPrice($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDiscountedPrice() => $_has(3);
  @$pb.TagNumber(4)
  void clearDiscountedPrice() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get discount => $_getN(4);
  @$pb.TagNumber(5)
  set discount($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDiscount() => $_has(4);
  @$pb.TagNumber(5)
  void clearDiscount() => $_clearField(5);
}

class VoucherStats extends $pb.GeneratedMessage {
  factory VoucherStats({
    Voucher? voucher,
    $core.int? totalUses,
    $core.int? remainingUses,
    $core.Iterable<VoucherUserUsage>? usageByUser,
    $core.double? revenueImpact,
  }) {
    final result = VoucherStats._();
    if (voucher != null) result.voucher = voucher;
    if (totalUses != null) result.totalUses = totalUses;
    if (remainingUses != null) result.remainingUses = remainingUses;
    if (usageByUser != null) result.usageByUser.addAll(usageByUser);
    if (revenueImpact != null) result.revenueImpact = revenueImpact;
    return result;
  }

  VoucherStats._();

  factory VoucherStats.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoucherStats()..mergeFromBuffer(data, registry);
  factory VoucherStats.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoucherStats()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VoucherStats',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: VoucherStats.$_createMessage)
    ..aOM<Voucher>(1, _omitFieldNames ? '' : 'voucher',
        subBuilder: Voucher.$_createMessage)
    ..aI(2, _omitFieldNames ? '' : 'totalUses')
    ..aI(3, _omitFieldNames ? '' : 'remainingUses')
    ..pPM<VoucherUserUsage>(4, _omitFieldNames ? '' : 'usageByUser',
        subBuilder: VoucherUserUsage.$_createMessage)
    ..aD(5, _omitFieldNames ? '' : 'revenueImpact')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoucherStats clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoucherStats copyWith(void Function(VoucherStats) updates) =>
      super.copyWith((message) => updates(message as VoucherStats))
          as VoucherStats;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use VoucherStats() / VoucherStats.new instead')
  static VoucherStats create() => VoucherStats._();
  static $pb.GeneratedMessage $_createMessage() => VoucherStats._();
  @$core.override
  VoucherStats createEmptyInstance() => VoucherStats._();
  @$core.pragma('dart2js:noInline')
  static VoucherStats getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VoucherStats>(
          VoucherStats.$_createMessage);
  static VoucherStats? _defaultInstance;

  @$pb.TagNumber(1)
  Voucher get voucher => $_getN(0);
  @$pb.TagNumber(1)
  set voucher(Voucher value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVoucher() => $_has(0);
  @$pb.TagNumber(1)
  void clearVoucher() => $_clearField(1);
  @$pb.TagNumber(1)
  Voucher ensureVoucher() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get totalUses => $_getIZ(1);
  @$pb.TagNumber(2)
  set totalUses($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalUses() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalUses() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get remainingUses => $_getIZ(2);
  @$pb.TagNumber(3)
  set remainingUses($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRemainingUses() => $_has(2);
  @$pb.TagNumber(3)
  void clearRemainingUses() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<VoucherUserUsage> get usageByUser => $_getList(3);

  @$pb.TagNumber(5)
  $core.double get revenueImpact => $_getN(4);
  @$pb.TagNumber(5)
  set revenueImpact($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRevenueImpact() => $_has(4);
  @$pb.TagNumber(5)
  void clearRevenueImpact() => $_clearField(5);
}

class VoucherUserUsage extends $pb.GeneratedMessage {
  factory VoucherUserUsage({
    $5.User? user,
    $core.int? usesCount,
    $core.String? firstUsedAt,
    $core.String? lastUsedAt,
  }) {
    final result = VoucherUserUsage._();
    if (user != null) result.user = user;
    if (usesCount != null) result.usesCount = usesCount;
    if (firstUsedAt != null) result.firstUsedAt = firstUsedAt;
    if (lastUsedAt != null) result.lastUsedAt = lastUsedAt;
    return result;
  }

  VoucherUserUsage._();

  factory VoucherUserUsage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoucherUserUsage()..mergeFromBuffer(data, registry);
  factory VoucherUserUsage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoucherUserUsage()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VoucherUserUsage',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: VoucherUserUsage.$_createMessage)
    ..aOM<$5.User>(1, _omitFieldNames ? '' : 'user',
        subBuilder: $5.User.$_createMessage)
    ..aI(2, _omitFieldNames ? '' : 'usesCount')
    ..aOS(3, _omitFieldNames ? '' : 'firstUsedAt')
    ..aOS(4, _omitFieldNames ? '' : 'lastUsedAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoucherUserUsage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoucherUserUsage copyWith(void Function(VoucherUserUsage) updates) =>
      super.copyWith((message) => updates(message as VoucherUserUsage))
          as VoucherUserUsage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use VoucherUserUsage() / VoucherUserUsage.new instead')
  static VoucherUserUsage create() => VoucherUserUsage._();
  static $pb.GeneratedMessage $_createMessage() => VoucherUserUsage._();
  @$core.override
  VoucherUserUsage createEmptyInstance() => VoucherUserUsage._();
  @$core.pragma('dart2js:noInline')
  static VoucherUserUsage getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VoucherUserUsage>(
          VoucherUserUsage.$_createMessage);
  static VoucherUserUsage? _defaultInstance;

  @$pb.TagNumber(1)
  $5.User get user => $_getN(0);
  @$pb.TagNumber(1)
  set user($5.User value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => $_clearField(1);
  @$pb.TagNumber(1)
  $5.User ensureUser() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get usesCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set usesCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUsesCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsesCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get firstUsedAt => $_getSZ(2);
  @$pb.TagNumber(3)
  set firstUsedAt($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFirstUsedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearFirstUsedAt() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get lastUsedAt => $_getSZ(3);
  @$pb.TagNumber(4)
  set lastUsedAt($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLastUsedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearLastUsedAt() => $_clearField(4);
}

class VoucherExport extends $pb.GeneratedMessage {
  factory VoucherExport({
    Voucher? voucher,
    $core.Iterable<$core.String>? codes,
    $core.String? csvUrl,
    $core.String? exportedAt,
  }) {
    final result = VoucherExport._();
    if (voucher != null) result.voucher = voucher;
    if (codes != null) result.codes.addAll(codes);
    if (csvUrl != null) result.csvUrl = csvUrl;
    if (exportedAt != null) result.exportedAt = exportedAt;
    return result;
  }

  VoucherExport._();

  factory VoucherExport.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoucherExport()..mergeFromBuffer(data, registry);
  factory VoucherExport.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoucherExport()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VoucherExport',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: VoucherExport.$_createMessage)
    ..aOM<Voucher>(1, _omitFieldNames ? '' : 'voucher',
        subBuilder: Voucher.$_createMessage)
    ..pPS(2, _omitFieldNames ? '' : 'codes')
    ..aOS(3, _omitFieldNames ? '' : 'csvUrl')
    ..aOS(4, _omitFieldNames ? '' : 'exportedAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoucherExport clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoucherExport copyWith(void Function(VoucherExport) updates) =>
      super.copyWith((message) => updates(message as VoucherExport))
          as VoucherExport;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use VoucherExport() / VoucherExport.new instead')
  static VoucherExport create() => VoucherExport._();
  static $pb.GeneratedMessage $_createMessage() => VoucherExport._();
  @$core.override
  VoucherExport createEmptyInstance() => VoucherExport._();
  @$core.pragma('dart2js:noInline')
  static VoucherExport getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VoucherExport>(
          VoucherExport.$_createMessage);
  static VoucherExport? _defaultInstance;

  @$pb.TagNumber(1)
  Voucher get voucher => $_getN(0);
  @$pb.TagNumber(1)
  set voucher(Voucher value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVoucher() => $_has(0);
  @$pb.TagNumber(1)
  void clearVoucher() => $_clearField(1);
  @$pb.TagNumber(1)
  Voucher ensureVoucher() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get codes => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get csvUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set csvUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCsvUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearCsvUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get exportedAt => $_getSZ(3);
  @$pb.TagNumber(4)
  set exportedAt($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExportedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearExportedAt() => $_clearField(4);
}

class DeleteVoucherResponse extends $pb.GeneratedMessage {
  factory DeleteVoucherResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = DeleteVoucherResponse._();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  DeleteVoucherResponse._();

  factory DeleteVoucherResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteVoucherResponse()..mergeFromBuffer(data, registry);
  factory DeleteVoucherResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteVoucherResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteVoucherResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: DeleteVoucherResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteVoucherResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteVoucherResponse copyWith(
          void Function(DeleteVoucherResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteVoucherResponse))
          as DeleteVoucherResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DeleteVoucherResponse() / DeleteVoucherResponse.new instead')
  static DeleteVoucherResponse create() => DeleteVoucherResponse._();
  static $pb.GeneratedMessage $_createMessage() => DeleteVoucherResponse._();
  @$core.override
  DeleteVoucherResponse createEmptyInstance() => DeleteVoucherResponse._();
  @$core.pragma('dart2js:noInline')
  static DeleteVoucherResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteVoucherResponse>(
          DeleteVoucherResponse.$_createMessage);
  static DeleteVoucherResponse? _defaultInstance;

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

class ValidateVoucherItemInput extends $pb.GeneratedMessage {
  factory ValidateVoucherItemInput({
    $core.String? id,
    $core.String? type,
    $core.int? quantity,
    $core.double? price,
  }) {
    final result = ValidateVoucherItemInput._();
    if (id != null) result.id = id;
    if (type != null) result.type = type;
    if (quantity != null) result.quantity = quantity;
    if (price != null) result.price = price;
    return result;
  }

  ValidateVoucherItemInput._();

  factory ValidateVoucherItemInput.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ValidateVoucherItemInput()..mergeFromBuffer(data, registry);
  factory ValidateVoucherItemInput.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ValidateVoucherItemInput()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ValidateVoucherItemInput',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ValidateVoucherItemInput.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'type')
    ..aI(3, _omitFieldNames ? '' : 'quantity')
    ..aD(4, _omitFieldNames ? '' : 'price')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ValidateVoucherItemInput clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ValidateVoucherItemInput copyWith(
          void Function(ValidateVoucherItemInput) updates) =>
      super.copyWith((message) => updates(message as ValidateVoucherItemInput))
          as ValidateVoucherItemInput;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ValidateVoucherItemInput() / ValidateVoucherItemInput.new instead')
  static ValidateVoucherItemInput create() => ValidateVoucherItemInput._();
  static $pb.GeneratedMessage $_createMessage() => ValidateVoucherItemInput._();
  @$core.override
  ValidateVoucherItemInput createEmptyInstance() =>
      ValidateVoucherItemInput._();
  @$core.pragma('dart2js:noInline')
  static ValidateVoucherItemInput getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ValidateVoucherItemInput>(
          ValidateVoucherItemInput.$_createMessage);
  static ValidateVoucherItemInput? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get type => $_getSZ(1);
  @$pb.TagNumber(2)
  set type($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get quantity => $_getIZ(2);
  @$pb.TagNumber(3)
  set quantity($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQuantity() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuantity() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get price => $_getN(3);
  @$pb.TagNumber(4)
  set price($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPrice() => $_has(3);
  @$pb.TagNumber(4)
  void clearPrice() => $_clearField(4);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
