// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/order.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'auth.pb.dart' as $2;
import 'catalog.pb.dart' as $4;
import 'common.pb.dart' as $1;
import 'package.pb.dart' as $3;
import 'voucher.pb.dart' as $5;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GetMyOrdersRequest extends $pb.GeneratedMessage {
  factory GetMyOrdersRequest({
    $1.PaginationRequest? pagination,
    $core.String? status,
  }) {
    final result = GetMyOrdersRequest._();
    if (pagination != null) result.pagination = pagination;
    if (status != null) result.status = status;
    return result;
  }

  GetMyOrdersRequest._();

  factory GetMyOrdersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMyOrdersRequest()..mergeFromBuffer(data, registry);
  factory GetMyOrdersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMyOrdersRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMyOrdersRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetMyOrdersRequest.$_createMessage)
    ..aOM<$1.PaginationRequest>(1, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginationRequest.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'status')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMyOrdersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMyOrdersRequest copyWith(void Function(GetMyOrdersRequest) updates) =>
      super.copyWith((message) => updates(message as GetMyOrdersRequest))
          as GetMyOrdersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetMyOrdersRequest() / GetMyOrdersRequest.new instead')
  static GetMyOrdersRequest create() => GetMyOrdersRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetMyOrdersRequest._();
  @$core.override
  GetMyOrdersRequest createEmptyInstance() => GetMyOrdersRequest._();
  @$core.pragma('dart2js:noInline')
  static GetMyOrdersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMyOrdersRequest>(
          GetMyOrdersRequest.$_createMessage);
  static GetMyOrdersRequest? _defaultInstance;

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
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);
}

class GetOrderRequest extends $pb.GeneratedMessage {
  factory GetOrderRequest({
    $core.String? id,
  }) {
    final result = GetOrderRequest._();
    if (id != null) result.id = id;
    return result;
  }

  GetOrderRequest._();

  factory GetOrderRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetOrderRequest()..mergeFromBuffer(data, registry);
  factory GetOrderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetOrderRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetOrderRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetOrderRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOrderRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOrderRequest copyWith(void Function(GetOrderRequest) updates) =>
      super.copyWith((message) => updates(message as GetOrderRequest))
          as GetOrderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetOrderRequest() / GetOrderRequest.new instead')
  static GetOrderRequest create() => GetOrderRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetOrderRequest._();
  @$core.override
  GetOrderRequest createEmptyInstance() => GetOrderRequest._();
  @$core.pragma('dart2js:noInline')
  static GetOrderRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetOrderRequest>(
          GetOrderRequest.$_createMessage);
  static GetOrderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class GetOrderByNumberRequest extends $pb.GeneratedMessage {
  factory GetOrderByNumberRequest({
    $core.String? orderNumber,
  }) {
    final result = GetOrderByNumberRequest._();
    if (orderNumber != null) result.orderNumber = orderNumber;
    return result;
  }

  GetOrderByNumberRequest._();

  factory GetOrderByNumberRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetOrderByNumberRequest()..mergeFromBuffer(data, registry);
  factory GetOrderByNumberRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetOrderByNumberRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetOrderByNumberRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetOrderByNumberRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'orderNumber')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOrderByNumberRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOrderByNumberRequest copyWith(
          void Function(GetOrderByNumberRequest) updates) =>
      super.copyWith((message) => updates(message as GetOrderByNumberRequest))
          as GetOrderByNumberRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetOrderByNumberRequest() / GetOrderByNumberRequest.new instead')
  static GetOrderByNumberRequest create() => GetOrderByNumberRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetOrderByNumberRequest._();
  @$core.override
  GetOrderByNumberRequest createEmptyInstance() => GetOrderByNumberRequest._();
  @$core.pragma('dart2js:noInline')
  static GetOrderByNumberRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetOrderByNumberRequest>(
          GetOrderByNumberRequest.$_createMessage);
  static GetOrderByNumberRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderNumber => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderNumber($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderNumber() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderNumber() => $_clearField(1);
}

class GetOrdersRequest extends $pb.GeneratedMessage {
  factory GetOrdersRequest({
    $1.PaginationRequest? pagination,
    $core.String? status,
    $core.String? paymentStatus,
    $core.String? userId,
    $core.String? dateFrom,
    $core.String? dateTo,
  }) {
    final result = GetOrdersRequest._();
    if (pagination != null) result.pagination = pagination;
    if (status != null) result.status = status;
    if (paymentStatus != null) result.paymentStatus = paymentStatus;
    if (userId != null) result.userId = userId;
    if (dateFrom != null) result.dateFrom = dateFrom;
    if (dateTo != null) result.dateTo = dateTo;
    return result;
  }

  GetOrdersRequest._();

  factory GetOrdersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetOrdersRequest()..mergeFromBuffer(data, registry);
  factory GetOrdersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetOrdersRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetOrdersRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetOrdersRequest.$_createMessage)
    ..aOM<$1.PaginationRequest>(1, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginationRequest.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'status')
    ..aOS(3, _omitFieldNames ? '' : 'paymentStatus')
    ..aOS(4, _omitFieldNames ? '' : 'userId')
    ..aOS(5, _omitFieldNames ? '' : 'dateFrom')
    ..aOS(6, _omitFieldNames ? '' : 'dateTo')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOrdersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOrdersRequest copyWith(void Function(GetOrdersRequest) updates) =>
      super.copyWith((message) => updates(message as GetOrdersRequest))
          as GetOrdersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetOrdersRequest() / GetOrdersRequest.new instead')
  static GetOrdersRequest create() => GetOrdersRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetOrdersRequest._();
  @$core.override
  GetOrdersRequest createEmptyInstance() => GetOrdersRequest._();
  @$core.pragma('dart2js:noInline')
  static GetOrdersRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetOrdersRequest>(
          GetOrdersRequest.$_createMessage);
  static GetOrdersRequest? _defaultInstance;

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
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get paymentStatus => $_getSZ(2);
  @$pb.TagNumber(3)
  set paymentStatus($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPaymentStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearPaymentStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get userId => $_getSZ(3);
  @$pb.TagNumber(4)
  set userId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUserId() => $_has(3);
  @$pb.TagNumber(4)
  void clearUserId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get dateFrom => $_getSZ(4);
  @$pb.TagNumber(5)
  set dateFrom($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDateFrom() => $_has(4);
  @$pb.TagNumber(5)
  void clearDateFrom() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get dateTo => $_getSZ(5);
  @$pb.TagNumber(6)
  set dateTo($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDateTo() => $_has(5);
  @$pb.TagNumber(6)
  void clearDateTo() => $_clearField(6);
}

class GetOrderStatsRequest extends $pb.GeneratedMessage {
  factory GetOrderStatsRequest() => GetOrderStatsRequest._();

  GetOrderStatsRequest._();

  factory GetOrderStatsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetOrderStatsRequest()..mergeFromBuffer(data, registry);
  factory GetOrderStatsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetOrderStatsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetOrderStatsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetOrderStatsRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOrderStatsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOrderStatsRequest copyWith(void Function(GetOrderStatsRequest) updates) =>
      super.copyWith((message) => updates(message as GetOrderStatsRequest))
          as GetOrderStatsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetOrderStatsRequest() / GetOrderStatsRequest.new instead')
  static GetOrderStatsRequest create() => GetOrderStatsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetOrderStatsRequest._();
  @$core.override
  GetOrderStatsRequest createEmptyInstance() => GetOrderStatsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetOrderStatsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetOrderStatsRequest>(
          GetOrderStatsRequest.$_createMessage);
  static GetOrderStatsRequest? _defaultInstance;
}

class GetOrderTimelineRequest extends $pb.GeneratedMessage {
  factory GetOrderTimelineRequest({
    $core.String? orderId,
  }) {
    final result = GetOrderTimelineRequest._();
    if (orderId != null) result.orderId = orderId;
    return result;
  }

  GetOrderTimelineRequest._();

  factory GetOrderTimelineRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetOrderTimelineRequest()..mergeFromBuffer(data, registry);
  factory GetOrderTimelineRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetOrderTimelineRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetOrderTimelineRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetOrderTimelineRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'orderId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOrderTimelineRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOrderTimelineRequest copyWith(
          void Function(GetOrderTimelineRequest) updates) =>
      super.copyWith((message) => updates(message as GetOrderTimelineRequest))
          as GetOrderTimelineRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetOrderTimelineRequest() / GetOrderTimelineRequest.new instead')
  static GetOrderTimelineRequest create() => GetOrderTimelineRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetOrderTimelineRequest._();
  @$core.override
  GetOrderTimelineRequest createEmptyInstance() => GetOrderTimelineRequest._();
  @$core.pragma('dart2js:noInline')
  static GetOrderTimelineRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetOrderTimelineRequest>(
          GetOrderTimelineRequest.$_createMessage);
  static GetOrderTimelineRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);
}

class CreateOrderRequest extends $pb.GeneratedMessage {
  factory CreateOrderRequest({
    $core.String? catalogId,
    $core.String? packageId,
    $core.int? quantity,
    $core.String? bookingDate,
    $core.String? notes,
    $core.String? addressId,
    $core.String? voucherCode,
    $1.PaymentMethod? paymentMethod,
    $1.MetaData? customOptions,
  }) {
    final result = CreateOrderRequest._();
    if (catalogId != null) result.catalogId = catalogId;
    if (packageId != null) result.packageId = packageId;
    if (quantity != null) result.quantity = quantity;
    if (bookingDate != null) result.bookingDate = bookingDate;
    if (notes != null) result.notes = notes;
    if (addressId != null) result.addressId = addressId;
    if (voucherCode != null) result.voucherCode = voucherCode;
    if (paymentMethod != null) result.paymentMethod = paymentMethod;
    if (customOptions != null) result.customOptions = customOptions;
    return result;
  }

  CreateOrderRequest._();

  factory CreateOrderRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateOrderRequest()..mergeFromBuffer(data, registry);
  factory CreateOrderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateOrderRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateOrderRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: CreateOrderRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'catalogId')
    ..aOS(2, _omitFieldNames ? '' : 'packageId')
    ..aI(3, _omitFieldNames ? '' : 'quantity')
    ..aOS(4, _omitFieldNames ? '' : 'bookingDate')
    ..aOS(5, _omitFieldNames ? '' : 'notes')
    ..aOS(6, _omitFieldNames ? '' : 'addressId')
    ..aOS(7, _omitFieldNames ? '' : 'voucherCode')
    ..aE<$1.PaymentMethod>(8, _omitFieldNames ? '' : 'paymentMethod',
        enumValues: $1.PaymentMethod.values)
    ..aOM<$1.MetaData>(9, _omitFieldNames ? '' : 'customOptions',
        subBuilder: $1.MetaData.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateOrderRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateOrderRequest copyWith(void Function(CreateOrderRequest) updates) =>
      super.copyWith((message) => updates(message as CreateOrderRequest))
          as CreateOrderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CreateOrderRequest() / CreateOrderRequest.new instead')
  static CreateOrderRequest create() => CreateOrderRequest._();
  static $pb.GeneratedMessage $_createMessage() => CreateOrderRequest._();
  @$core.override
  CreateOrderRequest createEmptyInstance() => CreateOrderRequest._();
  @$core.pragma('dart2js:noInline')
  static CreateOrderRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateOrderRequest>(
          CreateOrderRequest.$_createMessage);
  static CreateOrderRequest? _defaultInstance;

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
  $core.int get quantity => $_getIZ(2);
  @$pb.TagNumber(3)
  set quantity($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQuantity() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuantity() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get bookingDate => $_getSZ(3);
  @$pb.TagNumber(4)
  set bookingDate($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBookingDate() => $_has(3);
  @$pb.TagNumber(4)
  void clearBookingDate() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get notes => $_getSZ(4);
  @$pb.TagNumber(5)
  set notes($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNotes() => $_has(4);
  @$pb.TagNumber(5)
  void clearNotes() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get addressId => $_getSZ(5);
  @$pb.TagNumber(6)
  set addressId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAddressId() => $_has(5);
  @$pb.TagNumber(6)
  void clearAddressId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get voucherCode => $_getSZ(6);
  @$pb.TagNumber(7)
  set voucherCode($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasVoucherCode() => $_has(6);
  @$pb.TagNumber(7)
  void clearVoucherCode() => $_clearField(7);

  @$pb.TagNumber(8)
  $1.PaymentMethod get paymentMethod => $_getN(7);
  @$pb.TagNumber(8)
  set paymentMethod($1.PaymentMethod value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPaymentMethod() => $_has(7);
  @$pb.TagNumber(8)
  void clearPaymentMethod() => $_clearField(8);

  @$pb.TagNumber(9)
  $1.MetaData get customOptions => $_getN(8);
  @$pb.TagNumber(9)
  set customOptions($1.MetaData value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasCustomOptions() => $_has(8);
  @$pb.TagNumber(9)
  void clearCustomOptions() => $_clearField(9);
  @$pb.TagNumber(9)
  $1.MetaData ensureCustomOptions() => $_ensure(8);
}

class CancelOrderRequest extends $pb.GeneratedMessage {
  factory CancelOrderRequest({
    $core.String? orderId,
    $core.String? reason,
    $core.String? reasonDetail,
  }) {
    final result = CancelOrderRequest._();
    if (orderId != null) result.orderId = orderId;
    if (reason != null) result.reason = reason;
    if (reasonDetail != null) result.reasonDetail = reasonDetail;
    return result;
  }

  CancelOrderRequest._();

  factory CancelOrderRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelOrderRequest()..mergeFromBuffer(data, registry);
  factory CancelOrderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelOrderRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelOrderRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: CancelOrderRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'orderId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..aOS(3, _omitFieldNames ? '' : 'reasonDetail')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelOrderRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelOrderRequest copyWith(void Function(CancelOrderRequest) updates) =>
      super.copyWith((message) => updates(message as CancelOrderRequest))
          as CancelOrderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CancelOrderRequest() / CancelOrderRequest.new instead')
  static CancelOrderRequest create() => CancelOrderRequest._();
  static $pb.GeneratedMessage $_createMessage() => CancelOrderRequest._();
  @$core.override
  CancelOrderRequest createEmptyInstance() => CancelOrderRequest._();
  @$core.pragma('dart2js:noInline')
  static CancelOrderRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelOrderRequest>(
          CancelOrderRequest.$_createMessage);
  static CancelOrderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reasonDetail => $_getSZ(2);
  @$pb.TagNumber(3)
  set reasonDetail($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReasonDetail() => $_has(2);
  @$pb.TagNumber(3)
  void clearReasonDetail() => $_clearField(3);
}

class ReorderRequest extends $pb.GeneratedMessage {
  factory ReorderRequest({
    $core.String? orderId,
  }) {
    final result = ReorderRequest._();
    if (orderId != null) result.orderId = orderId;
    return result;
  }

  ReorderRequest._();

  factory ReorderRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReorderRequest()..mergeFromBuffer(data, registry);
  factory ReorderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReorderRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReorderRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ReorderRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'orderId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReorderRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReorderRequest copyWith(void Function(ReorderRequest) updates) =>
      super.copyWith((message) => updates(message as ReorderRequest))
          as ReorderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ReorderRequest() / ReorderRequest.new instead')
  static ReorderRequest create() => ReorderRequest._();
  static $pb.GeneratedMessage $_createMessage() => ReorderRequest._();
  @$core.override
  ReorderRequest createEmptyInstance() => ReorderRequest._();
  @$core.pragma('dart2js:noInline')
  static ReorderRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReorderRequest>(
          ReorderRequest.$_createMessage);
  static ReorderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);
}

class UpdateOrderRequest extends $pb.GeneratedMessage {
  factory UpdateOrderRequest({
    $core.String? orderId,
    $1.OrderStatus? status,
    $1.PaymentStatus? paymentStatus,
    $core.String? notes,
    $core.String? trackingNumber,
    $core.String? estimatedDelivery,
  }) {
    final result = UpdateOrderRequest._();
    if (orderId != null) result.orderId = orderId;
    if (status != null) result.status = status;
    if (paymentStatus != null) result.paymentStatus = paymentStatus;
    if (notes != null) result.notes = notes;
    if (trackingNumber != null) result.trackingNumber = trackingNumber;
    if (estimatedDelivery != null) result.estimatedDelivery = estimatedDelivery;
    return result;
  }

  UpdateOrderRequest._();

  factory UpdateOrderRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateOrderRequest()..mergeFromBuffer(data, registry);
  factory UpdateOrderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateOrderRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateOrderRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: UpdateOrderRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'orderId')
    ..aE<$1.OrderStatus>(2, _omitFieldNames ? '' : 'status',
        enumValues: $1.OrderStatus.values)
    ..aE<$1.PaymentStatus>(3, _omitFieldNames ? '' : 'paymentStatus',
        enumValues: $1.PaymentStatus.values)
    ..aOS(4, _omitFieldNames ? '' : 'notes')
    ..aOS(5, _omitFieldNames ? '' : 'trackingNumber')
    ..aOS(6, _omitFieldNames ? '' : 'estimatedDelivery')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateOrderRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateOrderRequest copyWith(void Function(UpdateOrderRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateOrderRequest))
          as UpdateOrderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UpdateOrderRequest() / UpdateOrderRequest.new instead')
  static UpdateOrderRequest create() => UpdateOrderRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdateOrderRequest._();
  @$core.override
  UpdateOrderRequest createEmptyInstance() => UpdateOrderRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateOrderRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateOrderRequest>(
          UpdateOrderRequest.$_createMessage);
  static UpdateOrderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.OrderStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status($1.OrderStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.PaymentStatus get paymentStatus => $_getN(2);
  @$pb.TagNumber(3)
  set paymentStatus($1.PaymentStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPaymentStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearPaymentStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get notes => $_getSZ(3);
  @$pb.TagNumber(4)
  set notes($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNotes() => $_has(3);
  @$pb.TagNumber(4)
  void clearNotes() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get trackingNumber => $_getSZ(4);
  @$pb.TagNumber(5)
  set trackingNumber($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTrackingNumber() => $_has(4);
  @$pb.TagNumber(5)
  void clearTrackingNumber() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get estimatedDelivery => $_getSZ(5);
  @$pb.TagNumber(6)
  set estimatedDelivery($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEstimatedDelivery() => $_has(5);
  @$pb.TagNumber(6)
  void clearEstimatedDelivery() => $_clearField(6);
}

class UpdateOrderStatusRequest extends $pb.GeneratedMessage {
  factory UpdateOrderStatusRequest({
    $core.String? orderId,
    $1.OrderStatus? status,
  }) {
    final result = UpdateOrderStatusRequest._();
    if (orderId != null) result.orderId = orderId;
    if (status != null) result.status = status;
    return result;
  }

  UpdateOrderStatusRequest._();

  factory UpdateOrderStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateOrderStatusRequest()..mergeFromBuffer(data, registry);
  factory UpdateOrderStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateOrderStatusRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateOrderStatusRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: UpdateOrderStatusRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'orderId')
    ..aE<$1.OrderStatus>(2, _omitFieldNames ? '' : 'status',
        enumValues: $1.OrderStatus.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateOrderStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateOrderStatusRequest copyWith(
          void Function(UpdateOrderStatusRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateOrderStatusRequest))
          as UpdateOrderStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateOrderStatusRequest() / UpdateOrderStatusRequest.new instead')
  static UpdateOrderStatusRequest create() => UpdateOrderStatusRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdateOrderStatusRequest._();
  @$core.override
  UpdateOrderStatusRequest createEmptyInstance() =>
      UpdateOrderStatusRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateOrderStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateOrderStatusRequest>(
          UpdateOrderStatusRequest.$_createMessage);
  static UpdateOrderStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.OrderStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status($1.OrderStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);
}

class UpdatePaymentStatusRequest extends $pb.GeneratedMessage {
  factory UpdatePaymentStatusRequest({
    $core.String? orderId,
    $1.PaymentStatus? paymentStatus,
  }) {
    final result = UpdatePaymentStatusRequest._();
    if (orderId != null) result.orderId = orderId;
    if (paymentStatus != null) result.paymentStatus = paymentStatus;
    return result;
  }

  UpdatePaymentStatusRequest._();

  factory UpdatePaymentStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdatePaymentStatusRequest()..mergeFromBuffer(data, registry);
  factory UpdatePaymentStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdatePaymentStatusRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdatePaymentStatusRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: UpdatePaymentStatusRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'orderId')
    ..aE<$1.PaymentStatus>(2, _omitFieldNames ? '' : 'paymentStatus',
        enumValues: $1.PaymentStatus.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePaymentStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePaymentStatusRequest copyWith(
          void Function(UpdatePaymentStatusRequest) updates) =>
      super.copyWith(
              (message) => updates(message as UpdatePaymentStatusRequest))
          as UpdatePaymentStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdatePaymentStatusRequest() / UpdatePaymentStatusRequest.new instead')
  static UpdatePaymentStatusRequest create() => UpdatePaymentStatusRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      UpdatePaymentStatusRequest._();
  @$core.override
  UpdatePaymentStatusRequest createEmptyInstance() =>
      UpdatePaymentStatusRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdatePaymentStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdatePaymentStatusRequest>(
          UpdatePaymentStatusRequest.$_createMessage);
  static UpdatePaymentStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.PaymentStatus get paymentStatus => $_getN(1);
  @$pb.TagNumber(2)
  set paymentStatus($1.PaymentStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPaymentStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearPaymentStatus() => $_clearField(2);
}

class ProcessPaymentRequest extends $pb.GeneratedMessage {
  factory ProcessPaymentRequest({
    $core.String? orderId,
    $1.MetaData? paymentData,
  }) {
    final result = ProcessPaymentRequest._();
    if (orderId != null) result.orderId = orderId;
    if (paymentData != null) result.paymentData = paymentData;
    return result;
  }

  ProcessPaymentRequest._();

  factory ProcessPaymentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProcessPaymentRequest()..mergeFromBuffer(data, registry);
  factory ProcessPaymentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProcessPaymentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProcessPaymentRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ProcessPaymentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'orderId')
    ..aOM<$1.MetaData>(2, _omitFieldNames ? '' : 'paymentData',
        subBuilder: $1.MetaData.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProcessPaymentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProcessPaymentRequest copyWith(
          void Function(ProcessPaymentRequest) updates) =>
      super.copyWith((message) => updates(message as ProcessPaymentRequest))
          as ProcessPaymentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ProcessPaymentRequest() / ProcessPaymentRequest.new instead')
  static ProcessPaymentRequest create() => ProcessPaymentRequest._();
  static $pb.GeneratedMessage $_createMessage() => ProcessPaymentRequest._();
  @$core.override
  ProcessPaymentRequest createEmptyInstance() => ProcessPaymentRequest._();
  @$core.pragma('dart2js:noInline')
  static ProcessPaymentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProcessPaymentRequest>(
          ProcessPaymentRequest.$_createMessage);
  static ProcessPaymentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.MetaData get paymentData => $_getN(1);
  @$pb.TagNumber(2)
  set paymentData($1.MetaData value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPaymentData() => $_has(1);
  @$pb.TagNumber(2)
  void clearPaymentData() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.MetaData ensurePaymentData() => $_ensure(1);
}

class RequestRefundRequest extends $pb.GeneratedMessage {
  factory RequestRefundRequest({
    $core.String? orderId,
    $core.String? reason,
    $core.double? amount,
  }) {
    final result = RequestRefundRequest._();
    if (orderId != null) result.orderId = orderId;
    if (reason != null) result.reason = reason;
    if (amount != null) result.amount = amount;
    return result;
  }

  RequestRefundRequest._();

  factory RequestRefundRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RequestRefundRequest()..mergeFromBuffer(data, registry);
  factory RequestRefundRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RequestRefundRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestRefundRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: RequestRefundRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'orderId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..aD(3, _omitFieldNames ? '' : 'amount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestRefundRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestRefundRequest copyWith(void Function(RequestRefundRequest) updates) =>
      super.copyWith((message) => updates(message as RequestRefundRequest))
          as RequestRefundRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RequestRefundRequest() / RequestRefundRequest.new instead')
  static RequestRefundRequest create() => RequestRefundRequest._();
  static $pb.GeneratedMessage $_createMessage() => RequestRefundRequest._();
  @$core.override
  RequestRefundRequest createEmptyInstance() => RequestRefundRequest._();
  @$core.pragma('dart2js:noInline')
  static RequestRefundRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestRefundRequest>(
          RequestRefundRequest.$_createMessage);
  static RequestRefundRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get amount => $_getN(2);
  @$pb.TagNumber(3)
  set amount($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => $_clearField(3);
}

class OrderListResponse extends $pb.GeneratedMessage {
  factory OrderListResponse({
    $core.Iterable<Order>? orders,
    $1.PaginationResponse? pagination,
  }) {
    final result = OrderListResponse._();
    if (orders != null) result.orders.addAll(orders);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  OrderListResponse._();

  factory OrderListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderListResponse()..mergeFromBuffer(data, registry);
  factory OrderListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderListResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: OrderListResponse.$_createMessage)
    ..pPM<Order>(1, _omitFieldNames ? '' : 'orders',
        subBuilder: Order.$_createMessage)
    ..aOM<$1.PaginationResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginationResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderListResponse copyWith(void Function(OrderListResponse) updates) =>
      super.copyWith((message) => updates(message as OrderListResponse))
          as OrderListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use OrderListResponse() / OrderListResponse.new instead')
  static OrderListResponse create() => OrderListResponse._();
  static $pb.GeneratedMessage $_createMessage() => OrderListResponse._();
  @$core.override
  OrderListResponse createEmptyInstance() => OrderListResponse._();
  @$core.pragma('dart2js:noInline')
  static OrderListResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OrderListResponse>(
          OrderListResponse.$_createMessage);
  static OrderListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Order> get orders => $_getList(0);

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

class OrderTimelineResponse extends $pb.GeneratedMessage {
  factory OrderTimelineResponse({
    $core.Iterable<OrderTimeline>? timeline,
  }) {
    final result = OrderTimelineResponse._();
    if (timeline != null) result.timeline.addAll(timeline);
    return result;
  }

  OrderTimelineResponse._();

  factory OrderTimelineResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderTimelineResponse()..mergeFromBuffer(data, registry);
  factory OrderTimelineResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderTimelineResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderTimelineResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: OrderTimelineResponse.$_createMessage)
    ..pPM<OrderTimeline>(1, _omitFieldNames ? '' : 'timeline',
        subBuilder: OrderTimeline.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderTimelineResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderTimelineResponse copyWith(
          void Function(OrderTimelineResponse) updates) =>
      super.copyWith((message) => updates(message as OrderTimelineResponse))
          as OrderTimelineResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OrderTimelineResponse() / OrderTimelineResponse.new instead')
  static OrderTimelineResponse create() => OrderTimelineResponse._();
  static $pb.GeneratedMessage $_createMessage() => OrderTimelineResponse._();
  @$core.override
  OrderTimelineResponse createEmptyInstance() => OrderTimelineResponse._();
  @$core.pragma('dart2js:noInline')
  static OrderTimelineResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrderTimelineResponse>(
          OrderTimelineResponse.$_createMessage);
  static OrderTimelineResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<OrderTimeline> get timeline => $_getList(0);
}

class OrderStats extends $pb.GeneratedMessage {
  factory OrderStats({
    $core.int? totalOrders,
    $core.int? pendingOrders,
    $core.int? confirmedOrders,
    $core.int? processingOrders,
    $core.int? shippedOrders,
    $core.int? deliveredOrders,
    $core.int? cancelledOrders,
    $core.double? totalRevenue,
    $core.double? pendingRevenue,
    $core.double? thisMonthRevenue,
    $core.double? averageOrderValue,
    $core.Iterable<OrderStatusCount>? byStatus,
    $core.Iterable<OrderPaymentStatusCount>? byPaymentStatus,
  }) {
    final result = OrderStats._();
    if (totalOrders != null) result.totalOrders = totalOrders;
    if (pendingOrders != null) result.pendingOrders = pendingOrders;
    if (confirmedOrders != null) result.confirmedOrders = confirmedOrders;
    if (processingOrders != null) result.processingOrders = processingOrders;
    if (shippedOrders != null) result.shippedOrders = shippedOrders;
    if (deliveredOrders != null) result.deliveredOrders = deliveredOrders;
    if (cancelledOrders != null) result.cancelledOrders = cancelledOrders;
    if (totalRevenue != null) result.totalRevenue = totalRevenue;
    if (pendingRevenue != null) result.pendingRevenue = pendingRevenue;
    if (thisMonthRevenue != null) result.thisMonthRevenue = thisMonthRevenue;
    if (averageOrderValue != null) result.averageOrderValue = averageOrderValue;
    if (byStatus != null) result.byStatus.addAll(byStatus);
    if (byPaymentStatus != null) result.byPaymentStatus.addAll(byPaymentStatus);
    return result;
  }

  OrderStats._();

  factory OrderStats.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderStats()..mergeFromBuffer(data, registry);
  factory OrderStats.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderStats()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderStats',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: OrderStats.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'totalOrders')
    ..aI(2, _omitFieldNames ? '' : 'pendingOrders')
    ..aI(3, _omitFieldNames ? '' : 'confirmedOrders')
    ..aI(4, _omitFieldNames ? '' : 'processingOrders')
    ..aI(5, _omitFieldNames ? '' : 'shippedOrders')
    ..aI(6, _omitFieldNames ? '' : 'deliveredOrders')
    ..aI(7, _omitFieldNames ? '' : 'cancelledOrders')
    ..aD(8, _omitFieldNames ? '' : 'totalRevenue')
    ..aD(9, _omitFieldNames ? '' : 'pendingRevenue')
    ..aD(10, _omitFieldNames ? '' : 'thisMonthRevenue')
    ..aD(11, _omitFieldNames ? '' : 'averageOrderValue')
    ..pPM<OrderStatusCount>(12, _omitFieldNames ? '' : 'byStatus',
        subBuilder: OrderStatusCount.$_createMessage)
    ..pPM<OrderPaymentStatusCount>(13, _omitFieldNames ? '' : 'byPaymentStatus',
        subBuilder: OrderPaymentStatusCount.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderStats clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderStats copyWith(void Function(OrderStats) updates) =>
      super.copyWith((message) => updates(message as OrderStats)) as OrderStats;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use OrderStats() / OrderStats.new instead')
  static OrderStats create() => OrderStats._();
  static $pb.GeneratedMessage $_createMessage() => OrderStats._();
  @$core.override
  OrderStats createEmptyInstance() => OrderStats._();
  @$core.pragma('dart2js:noInline')
  static OrderStats getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrderStats>(OrderStats.$_createMessage);
  static OrderStats? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get totalOrders => $_getIZ(0);
  @$pb.TagNumber(1)
  set totalOrders($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotalOrders() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalOrders() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pendingOrders => $_getIZ(1);
  @$pb.TagNumber(2)
  set pendingOrders($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPendingOrders() => $_has(1);
  @$pb.TagNumber(2)
  void clearPendingOrders() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get confirmedOrders => $_getIZ(2);
  @$pb.TagNumber(3)
  set confirmedOrders($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasConfirmedOrders() => $_has(2);
  @$pb.TagNumber(3)
  void clearConfirmedOrders() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get processingOrders => $_getIZ(3);
  @$pb.TagNumber(4)
  set processingOrders($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasProcessingOrders() => $_has(3);
  @$pb.TagNumber(4)
  void clearProcessingOrders() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get shippedOrders => $_getIZ(4);
  @$pb.TagNumber(5)
  set shippedOrders($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasShippedOrders() => $_has(4);
  @$pb.TagNumber(5)
  void clearShippedOrders() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get deliveredOrders => $_getIZ(5);
  @$pb.TagNumber(6)
  set deliveredOrders($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDeliveredOrders() => $_has(5);
  @$pb.TagNumber(6)
  void clearDeliveredOrders() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get cancelledOrders => $_getIZ(6);
  @$pb.TagNumber(7)
  set cancelledOrders($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCancelledOrders() => $_has(6);
  @$pb.TagNumber(7)
  void clearCancelledOrders() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get totalRevenue => $_getN(7);
  @$pb.TagNumber(8)
  set totalRevenue($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTotalRevenue() => $_has(7);
  @$pb.TagNumber(8)
  void clearTotalRevenue() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get pendingRevenue => $_getN(8);
  @$pb.TagNumber(9)
  set pendingRevenue($core.double value) => $_setDouble(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPendingRevenue() => $_has(8);
  @$pb.TagNumber(9)
  void clearPendingRevenue() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get thisMonthRevenue => $_getN(9);
  @$pb.TagNumber(10)
  set thisMonthRevenue($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasThisMonthRevenue() => $_has(9);
  @$pb.TagNumber(10)
  void clearThisMonthRevenue() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get averageOrderValue => $_getN(10);
  @$pb.TagNumber(11)
  set averageOrderValue($core.double value) => $_setDouble(10, value);
  @$pb.TagNumber(11)
  $core.bool hasAverageOrderValue() => $_has(10);
  @$pb.TagNumber(11)
  void clearAverageOrderValue() => $_clearField(11);

  @$pb.TagNumber(12)
  $pb.PbList<OrderStatusCount> get byStatus => $_getList(11);

  @$pb.TagNumber(13)
  $pb.PbList<OrderPaymentStatusCount> get byPaymentStatus => $_getList(12);
}

class Order extends $pb.GeneratedMessage {
  factory Order({
    $core.String? id,
    $core.String? orderNumber,
    $2.User? user,
    $3.Package? package,
    $4.Catalog? catalog,
    $core.double? totalPrice,
    $core.String? status,
    $core.String? paymentStatus,
    $core.String? bookingDate,
    $core.int? quantity,
    $core.String? notes,
    OrderAddress? address,
    $5.Voucher? voucher,
    OrderPayment? payment,
    $core.Iterable<OrderTimeline>? timeline,
    $core.String? createdAt,
    $core.String? updatedAt,
  }) {
    final result = Order._();
    if (id != null) result.id = id;
    if (orderNumber != null) result.orderNumber = orderNumber;
    if (user != null) result.user = user;
    if (package != null) result.package = package;
    if (catalog != null) result.catalog = catalog;
    if (totalPrice != null) result.totalPrice = totalPrice;
    if (status != null) result.status = status;
    if (paymentStatus != null) result.paymentStatus = paymentStatus;
    if (bookingDate != null) result.bookingDate = bookingDate;
    if (quantity != null) result.quantity = quantity;
    if (notes != null) result.notes = notes;
    if (address != null) result.address = address;
    if (voucher != null) result.voucher = voucher;
    if (payment != null) result.payment = payment;
    if (timeline != null) result.timeline.addAll(timeline);
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  Order._();

  factory Order.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Order()..mergeFromBuffer(data, registry);
  factory Order.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Order()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Order',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: Order.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'orderNumber')
    ..aOM<$2.User>(3, _omitFieldNames ? '' : 'user',
        subBuilder: $2.User.$_createMessage)
    ..aOM<$3.Package>(4, _omitFieldNames ? '' : 'package',
        subBuilder: $3.Package.$_createMessage)
    ..aOM<$4.Catalog>(5, _omitFieldNames ? '' : 'catalog',
        subBuilder: $4.Catalog.$_createMessage)
    ..aD(6, _omitFieldNames ? '' : 'totalPrice')
    ..aOS(7, _omitFieldNames ? '' : 'status')
    ..aOS(8, _omitFieldNames ? '' : 'paymentStatus')
    ..aOS(9, _omitFieldNames ? '' : 'bookingDate')
    ..aI(10, _omitFieldNames ? '' : 'quantity')
    ..aOS(11, _omitFieldNames ? '' : 'notes')
    ..aOM<OrderAddress>(12, _omitFieldNames ? '' : 'address',
        subBuilder: OrderAddress.$_createMessage)
    ..aOM<$5.Voucher>(13, _omitFieldNames ? '' : 'voucher',
        subBuilder: $5.Voucher.$_createMessage)
    ..aOM<OrderPayment>(14, _omitFieldNames ? '' : 'payment',
        subBuilder: OrderPayment.$_createMessage)
    ..pPM<OrderTimeline>(15, _omitFieldNames ? '' : 'timeline',
        subBuilder: OrderTimeline.$_createMessage)
    ..aOS(16, _omitFieldNames ? '' : 'createdAt')
    ..aOS(17, _omitFieldNames ? '' : 'updatedAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Order clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Order copyWith(void Function(Order) updates) =>
      super.copyWith((message) => updates(message as Order)) as Order;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Order() / Order.new instead')
  static Order create() => Order._();
  static $pb.GeneratedMessage $_createMessage() => Order._();
  @$core.override
  Order createEmptyInstance() => Order._();
  @$core.pragma('dart2js:noInline')
  static Order getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Order>(Order.$_createMessage);
  static Order? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get orderNumber => $_getSZ(1);
  @$pb.TagNumber(2)
  set orderNumber($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOrderNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrderNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  $2.User get user => $_getN(2);
  @$pb.TagNumber(3)
  set user($2.User value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasUser() => $_has(2);
  @$pb.TagNumber(3)
  void clearUser() => $_clearField(3);
  @$pb.TagNumber(3)
  $2.User ensureUser() => $_ensure(2);

  @$pb.TagNumber(4)
  $3.Package get package => $_getN(3);
  @$pb.TagNumber(4)
  set package($3.Package value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPackage() => $_has(3);
  @$pb.TagNumber(4)
  void clearPackage() => $_clearField(4);
  @$pb.TagNumber(4)
  $3.Package ensurePackage() => $_ensure(3);

  @$pb.TagNumber(5)
  $4.Catalog get catalog => $_getN(4);
  @$pb.TagNumber(5)
  set catalog($4.Catalog value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCatalog() => $_has(4);
  @$pb.TagNumber(5)
  void clearCatalog() => $_clearField(5);
  @$pb.TagNumber(5)
  $4.Catalog ensureCatalog() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.double get totalPrice => $_getN(5);
  @$pb.TagNumber(6)
  set totalPrice($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTotalPrice() => $_has(5);
  @$pb.TagNumber(6)
  void clearTotalPrice() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get status => $_getSZ(6);
  @$pb.TagNumber(7)
  set status($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasStatus() => $_has(6);
  @$pb.TagNumber(7)
  void clearStatus() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get paymentStatus => $_getSZ(7);
  @$pb.TagNumber(8)
  set paymentStatus($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPaymentStatus() => $_has(7);
  @$pb.TagNumber(8)
  void clearPaymentStatus() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get bookingDate => $_getSZ(8);
  @$pb.TagNumber(9)
  set bookingDate($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasBookingDate() => $_has(8);
  @$pb.TagNumber(9)
  void clearBookingDate() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get quantity => $_getIZ(9);
  @$pb.TagNumber(10)
  set quantity($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasQuantity() => $_has(9);
  @$pb.TagNumber(10)
  void clearQuantity() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get notes => $_getSZ(10);
  @$pb.TagNumber(11)
  set notes($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasNotes() => $_has(10);
  @$pb.TagNumber(11)
  void clearNotes() => $_clearField(11);

  @$pb.TagNumber(12)
  OrderAddress get address => $_getN(11);
  @$pb.TagNumber(12)
  set address(OrderAddress value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasAddress() => $_has(11);
  @$pb.TagNumber(12)
  void clearAddress() => $_clearField(12);
  @$pb.TagNumber(12)
  OrderAddress ensureAddress() => $_ensure(11);

  @$pb.TagNumber(13)
  $5.Voucher get voucher => $_getN(12);
  @$pb.TagNumber(13)
  set voucher($5.Voucher value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasVoucher() => $_has(12);
  @$pb.TagNumber(13)
  void clearVoucher() => $_clearField(13);
  @$pb.TagNumber(13)
  $5.Voucher ensureVoucher() => $_ensure(12);

  @$pb.TagNumber(14)
  OrderPayment get payment => $_getN(13);
  @$pb.TagNumber(14)
  set payment(OrderPayment value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasPayment() => $_has(13);
  @$pb.TagNumber(14)
  void clearPayment() => $_clearField(14);
  @$pb.TagNumber(14)
  OrderPayment ensurePayment() => $_ensure(13);

  @$pb.TagNumber(15)
  $pb.PbList<OrderTimeline> get timeline => $_getList(14);

  @$pb.TagNumber(16)
  $core.String get createdAt => $_getSZ(15);
  @$pb.TagNumber(16)
  set createdAt($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasCreatedAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearCreatedAt() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get updatedAt => $_getSZ(16);
  @$pb.TagNumber(17)
  set updatedAt($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasUpdatedAt() => $_has(16);
  @$pb.TagNumber(17)
  void clearUpdatedAt() => $_clearField(17);
}

class OrderAddress extends $pb.GeneratedMessage {
  factory OrderAddress({
    $core.String? id,
    $core.String? name,
    $core.String? phone,
    $core.String? address,
    $core.String? city,
    $core.String? province,
    $core.String? postalCode,
    $core.bool? isDefault,
  }) {
    final result = OrderAddress._();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (phone != null) result.phone = phone;
    if (address != null) result.address = address;
    if (city != null) result.city = city;
    if (province != null) result.province = province;
    if (postalCode != null) result.postalCode = postalCode;
    if (isDefault != null) result.isDefault = isDefault;
    return result;
  }

  OrderAddress._();

  factory OrderAddress.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderAddress()..mergeFromBuffer(data, registry);
  factory OrderAddress.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderAddress()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderAddress',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: OrderAddress.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'phone')
    ..aOS(4, _omitFieldNames ? '' : 'address')
    ..aOS(5, _omitFieldNames ? '' : 'city')
    ..aOS(6, _omitFieldNames ? '' : 'province')
    ..aOS(7, _omitFieldNames ? '' : 'postalCode')
    ..aOB(8, _omitFieldNames ? '' : 'isDefault')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderAddress clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderAddress copyWith(void Function(OrderAddress) updates) =>
      super.copyWith((message) => updates(message as OrderAddress))
          as OrderAddress;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use OrderAddress() / OrderAddress.new instead')
  static OrderAddress create() => OrderAddress._();
  static $pb.GeneratedMessage $_createMessage() => OrderAddress._();
  @$core.override
  OrderAddress createEmptyInstance() => OrderAddress._();
  @$core.pragma('dart2js:noInline')
  static OrderAddress getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OrderAddress>(
          OrderAddress.$_createMessage);
  static OrderAddress? _defaultInstance;

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
  $core.String get phone => $_getSZ(2);
  @$pb.TagNumber(3)
  set phone($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPhone() => $_has(2);
  @$pb.TagNumber(3)
  void clearPhone() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get address => $_getSZ(3);
  @$pb.TagNumber(4)
  set address($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAddress() => $_has(3);
  @$pb.TagNumber(4)
  void clearAddress() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get city => $_getSZ(4);
  @$pb.TagNumber(5)
  set city($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCity() => $_has(4);
  @$pb.TagNumber(5)
  void clearCity() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get province => $_getSZ(5);
  @$pb.TagNumber(6)
  set province($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasProvince() => $_has(5);
  @$pb.TagNumber(6)
  void clearProvince() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get postalCode => $_getSZ(6);
  @$pb.TagNumber(7)
  set postalCode($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPostalCode() => $_has(6);
  @$pb.TagNumber(7)
  void clearPostalCode() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get isDefault => $_getBF(7);
  @$pb.TagNumber(8)
  set isDefault($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIsDefault() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsDefault() => $_clearField(8);
}

class OrderPayment extends $pb.GeneratedMessage {
  factory OrderPayment({
    $core.String? id,
    $core.String? method,
    $core.String? status,
    $core.double? amount,
    $core.String? paidAt,
    $core.String? transactionId,
    $core.String? proofUrl,
  }) {
    final result = OrderPayment._();
    if (id != null) result.id = id;
    if (method != null) result.method = method;
    if (status != null) result.status = status;
    if (amount != null) result.amount = amount;
    if (paidAt != null) result.paidAt = paidAt;
    if (transactionId != null) result.transactionId = transactionId;
    if (proofUrl != null) result.proofUrl = proofUrl;
    return result;
  }

  OrderPayment._();

  factory OrderPayment.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderPayment()..mergeFromBuffer(data, registry);
  factory OrderPayment.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderPayment()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderPayment',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: OrderPayment.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'method')
    ..aOS(3, _omitFieldNames ? '' : 'status')
    ..aD(4, _omitFieldNames ? '' : 'amount')
    ..aOS(5, _omitFieldNames ? '' : 'paidAt')
    ..aOS(6, _omitFieldNames ? '' : 'transactionId')
    ..aOS(7, _omitFieldNames ? '' : 'proofUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderPayment clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderPayment copyWith(void Function(OrderPayment) updates) =>
      super.copyWith((message) => updates(message as OrderPayment))
          as OrderPayment;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use OrderPayment() / OrderPayment.new instead')
  static OrderPayment create() => OrderPayment._();
  static $pb.GeneratedMessage $_createMessage() => OrderPayment._();
  @$core.override
  OrderPayment createEmptyInstance() => OrderPayment._();
  @$core.pragma('dart2js:noInline')
  static OrderPayment getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OrderPayment>(
          OrderPayment.$_createMessage);
  static OrderPayment? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get method => $_getSZ(1);
  @$pb.TagNumber(2)
  set method($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMethod() => $_has(1);
  @$pb.TagNumber(2)
  void clearMethod() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get status => $_getSZ(2);
  @$pb.TagNumber(3)
  set status($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get amount => $_getN(3);
  @$pb.TagNumber(4)
  set amount($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearAmount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get paidAt => $_getSZ(4);
  @$pb.TagNumber(5)
  set paidAt($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPaidAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearPaidAt() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get transactionId => $_getSZ(5);
  @$pb.TagNumber(6)
  set transactionId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTransactionId() => $_has(5);
  @$pb.TagNumber(6)
  void clearTransactionId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get proofUrl => $_getSZ(6);
  @$pb.TagNumber(7)
  set proofUrl($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasProofUrl() => $_has(6);
  @$pb.TagNumber(7)
  void clearProofUrl() => $_clearField(7);
}

class OrderTimeline extends $pb.GeneratedMessage {
  factory OrderTimeline({
    $core.String? id,
    $core.String? orderId,
    $core.String? status,
    $core.String? description,
    $1.MetaData? metadata,
    $core.String? createdAt,
    $2.User? createdBy,
  }) {
    final result = OrderTimeline._();
    if (id != null) result.id = id;
    if (orderId != null) result.orderId = orderId;
    if (status != null) result.status = status;
    if (description != null) result.description = description;
    if (metadata != null) result.metadata = metadata;
    if (createdAt != null) result.createdAt = createdAt;
    if (createdBy != null) result.createdBy = createdBy;
    return result;
  }

  OrderTimeline._();

  factory OrderTimeline.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderTimeline()..mergeFromBuffer(data, registry);
  factory OrderTimeline.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderTimeline()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderTimeline',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: OrderTimeline.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'orderId')
    ..aOS(3, _omitFieldNames ? '' : 'status')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOM<$1.MetaData>(5, _omitFieldNames ? '' : 'metadata',
        subBuilder: $1.MetaData.$_createMessage)
    ..aOS(6, _omitFieldNames ? '' : 'createdAt')
    ..aOM<$2.User>(7, _omitFieldNames ? '' : 'createdBy',
        subBuilder: $2.User.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderTimeline clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderTimeline copyWith(void Function(OrderTimeline) updates) =>
      super.copyWith((message) => updates(message as OrderTimeline))
          as OrderTimeline;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use OrderTimeline() / OrderTimeline.new instead')
  static OrderTimeline create() => OrderTimeline._();
  static $pb.GeneratedMessage $_createMessage() => OrderTimeline._();
  @$core.override
  OrderTimeline createEmptyInstance() => OrderTimeline._();
  @$core.pragma('dart2js:noInline')
  static OrderTimeline getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OrderTimeline>(
          OrderTimeline.$_createMessage);
  static OrderTimeline? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get orderId => $_getSZ(1);
  @$pb.TagNumber(2)
  set orderId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOrderId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrderId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get status => $_getSZ(2);
  @$pb.TagNumber(3)
  set status($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.MetaData get metadata => $_getN(4);
  @$pb.TagNumber(5)
  set metadata($1.MetaData value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasMetadata() => $_has(4);
  @$pb.TagNumber(5)
  void clearMetadata() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.MetaData ensureMetadata() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get createdAt => $_getSZ(5);
  @$pb.TagNumber(6)
  set createdAt($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCreatedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreatedAt() => $_clearField(6);

  @$pb.TagNumber(7)
  $2.User get createdBy => $_getN(6);
  @$pb.TagNumber(7)
  set createdBy($2.User value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCreatedBy() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreatedBy() => $_clearField(7);
  @$pb.TagNumber(7)
  $2.User ensureCreatedBy() => $_ensure(6);
}

class OrderStatusCount extends $pb.GeneratedMessage {
  factory OrderStatusCount({
    $core.String? status,
    $core.int? count,
  }) {
    final result = OrderStatusCount._();
    if (status != null) result.status = status;
    if (count != null) result.count = count;
    return result;
  }

  OrderStatusCount._();

  factory OrderStatusCount.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderStatusCount()..mergeFromBuffer(data, registry);
  factory OrderStatusCount.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderStatusCount()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderStatusCount',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: OrderStatusCount.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'status')
    ..aI(2, _omitFieldNames ? '' : 'count')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderStatusCount clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderStatusCount copyWith(void Function(OrderStatusCount) updates) =>
      super.copyWith((message) => updates(message as OrderStatusCount))
          as OrderStatusCount;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use OrderStatusCount() / OrderStatusCount.new instead')
  static OrderStatusCount create() => OrderStatusCount._();
  static $pb.GeneratedMessage $_createMessage() => OrderStatusCount._();
  @$core.override
  OrderStatusCount createEmptyInstance() => OrderStatusCount._();
  @$core.pragma('dart2js:noInline')
  static OrderStatusCount getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OrderStatusCount>(
          OrderStatusCount.$_createMessage);
  static OrderStatusCount? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get status => $_getSZ(0);
  @$pb.TagNumber(1)
  set status($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get count => $_getIZ(1);
  @$pb.TagNumber(2)
  set count($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearCount() => $_clearField(2);
}

class OrderPaymentStatusCount extends $pb.GeneratedMessage {
  factory OrderPaymentStatusCount({
    $core.String? paymentStatus,
    $core.int? count,
  }) {
    final result = OrderPaymentStatusCount._();
    if (paymentStatus != null) result.paymentStatus = paymentStatus;
    if (count != null) result.count = count;
    return result;
  }

  OrderPaymentStatusCount._();

  factory OrderPaymentStatusCount.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderPaymentStatusCount()..mergeFromBuffer(data, registry);
  factory OrderPaymentStatusCount.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderPaymentStatusCount()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderPaymentStatusCount',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: OrderPaymentStatusCount.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'paymentStatus')
    ..aI(2, _omitFieldNames ? '' : 'count')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderPaymentStatusCount clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderPaymentStatusCount copyWith(
          void Function(OrderPaymentStatusCount) updates) =>
      super.copyWith((message) => updates(message as OrderPaymentStatusCount))
          as OrderPaymentStatusCount;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OrderPaymentStatusCount() / OrderPaymentStatusCount.new instead')
  static OrderPaymentStatusCount create() => OrderPaymentStatusCount._();
  static $pb.GeneratedMessage $_createMessage() => OrderPaymentStatusCount._();
  @$core.override
  OrderPaymentStatusCount createEmptyInstance() => OrderPaymentStatusCount._();
  @$core.pragma('dart2js:noInline')
  static OrderPaymentStatusCount getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrderPaymentStatusCount>(
          OrderPaymentStatusCount.$_createMessage);
  static OrderPaymentStatusCount? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get paymentStatus => $_getSZ(0);
  @$pb.TagNumber(1)
  set paymentStatus($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPaymentStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearPaymentStatus() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get count => $_getIZ(1);
  @$pb.TagNumber(2)
  set count($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearCount() => $_clearField(2);
}

class PaymentResult extends $pb.GeneratedMessage {
  factory PaymentResult({
    $core.bool? success,
    Order? order,
    $core.String? redirectUrl,
    $core.String? message,
  }) {
    final result = PaymentResult._();
    if (success != null) result.success = success;
    if (order != null) result.order = order;
    if (redirectUrl != null) result.redirectUrl = redirectUrl;
    if (message != null) result.message = message;
    return result;
  }

  PaymentResult._();

  factory PaymentResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaymentResult()..mergeFromBuffer(data, registry);
  factory PaymentResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaymentResult()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PaymentResult',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: PaymentResult.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOM<Order>(2, _omitFieldNames ? '' : 'order',
        subBuilder: Order.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'redirectUrl')
    ..aOS(4, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaymentResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaymentResult copyWith(void Function(PaymentResult) updates) =>
      super.copyWith((message) => updates(message as PaymentResult))
          as PaymentResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PaymentResult() / PaymentResult.new instead')
  static PaymentResult create() => PaymentResult._();
  static $pb.GeneratedMessage $_createMessage() => PaymentResult._();
  @$core.override
  PaymentResult createEmptyInstance() => PaymentResult._();
  @$core.pragma('dart2js:noInline')
  static PaymentResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PaymentResult>(
          PaymentResult.$_createMessage);
  static PaymentResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  Order get order => $_getN(1);
  @$pb.TagNumber(2)
  set order(Order value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOrder() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrder() => $_clearField(2);
  @$pb.TagNumber(2)
  Order ensureOrder() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get redirectUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set redirectUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRedirectUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearRedirectUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get message => $_getSZ(3);
  @$pb.TagNumber(4)
  set message($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMessage() => $_has(3);
  @$pb.TagNumber(4)
  void clearMessage() => $_clearField(4);
}

class RefundRequestResponse extends $pb.GeneratedMessage {
  factory RefundRequestResponse({
    $core.String? id,
    Order? order,
    $core.String? reason,
    $core.double? amount,
    $1.RefundStatus? status,
    $core.String? requestedAt,
    $core.String? processedAt,
  }) {
    final result = RefundRequestResponse._();
    if (id != null) result.id = id;
    if (order != null) result.order = order;
    if (reason != null) result.reason = reason;
    if (amount != null) result.amount = amount;
    if (status != null) result.status = status;
    if (requestedAt != null) result.requestedAt = requestedAt;
    if (processedAt != null) result.processedAt = processedAt;
    return result;
  }

  RefundRequestResponse._();

  factory RefundRequestResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RefundRequestResponse()..mergeFromBuffer(data, registry);
  factory RefundRequestResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RefundRequestResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RefundRequestResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: RefundRequestResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOM<Order>(2, _omitFieldNames ? '' : 'order',
        subBuilder: Order.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..aD(4, _omitFieldNames ? '' : 'amount')
    ..aE<$1.RefundStatus>(5, _omitFieldNames ? '' : 'status',
        enumValues: $1.RefundStatus.values)
    ..aOS(6, _omitFieldNames ? '' : 'requestedAt')
    ..aOS(7, _omitFieldNames ? '' : 'processedAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefundRequestResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefundRequestResponse copyWith(
          void Function(RefundRequestResponse) updates) =>
      super.copyWith((message) => updates(message as RefundRequestResponse))
          as RefundRequestResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RefundRequestResponse() / RefundRequestResponse.new instead')
  static RefundRequestResponse create() => RefundRequestResponse._();
  static $pb.GeneratedMessage $_createMessage() => RefundRequestResponse._();
  @$core.override
  RefundRequestResponse createEmptyInstance() => RefundRequestResponse._();
  @$core.pragma('dart2js:noInline')
  static RefundRequestResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RefundRequestResponse>(
          RefundRequestResponse.$_createMessage);
  static RefundRequestResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  Order get order => $_getN(1);
  @$pb.TagNumber(2)
  set order(Order value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOrder() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrder() => $_clearField(2);
  @$pb.TagNumber(2)
  Order ensureOrder() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get amount => $_getN(3);
  @$pb.TagNumber(4)
  set amount($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearAmount() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.RefundStatus get status => $_getN(4);
  @$pb.TagNumber(5)
  set status($1.RefundStatus value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get requestedAt => $_getSZ(5);
  @$pb.TagNumber(6)
  set requestedAt($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRequestedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearRequestedAt() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get processedAt => $_getSZ(6);
  @$pb.TagNumber(7)
  set processedAt($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasProcessedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearProcessedAt() => $_clearField(7);
}

class Invoice extends $pb.GeneratedMessage {
  factory Invoice({
    $core.String? id,
    Order? order,
    $core.String? invoiceNumber,
    $core.String? pdfUrl,
    $core.String? issuedAt,
    $core.String? dueAt,
    $core.String? status,
  }) {
    final result = Invoice._();
    if (id != null) result.id = id;
    if (order != null) result.order = order;
    if (invoiceNumber != null) result.invoiceNumber = invoiceNumber;
    if (pdfUrl != null) result.pdfUrl = pdfUrl;
    if (issuedAt != null) result.issuedAt = issuedAt;
    if (dueAt != null) result.dueAt = dueAt;
    if (status != null) result.status = status;
    return result;
  }

  Invoice._();

  factory Invoice.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Invoice()..mergeFromBuffer(data, registry);
  factory Invoice.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Invoice()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Invoice',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: Invoice.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOM<Order>(2, _omitFieldNames ? '' : 'order',
        subBuilder: Order.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'invoiceNumber')
    ..aOS(4, _omitFieldNames ? '' : 'pdfUrl')
    ..aOS(5, _omitFieldNames ? '' : 'issuedAt')
    ..aOS(6, _omitFieldNames ? '' : 'dueAt')
    ..aOS(7, _omitFieldNames ? '' : 'status')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Invoice clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Invoice copyWith(void Function(Invoice) updates) =>
      super.copyWith((message) => updates(message as Invoice)) as Invoice;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Invoice() / Invoice.new instead')
  static Invoice create() => Invoice._();
  static $pb.GeneratedMessage $_createMessage() => Invoice._();
  @$core.override
  Invoice createEmptyInstance() => Invoice._();
  @$core.pragma('dart2js:noInline')
  static Invoice getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Invoice>(Invoice.$_createMessage);
  static Invoice? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  Order get order => $_getN(1);
  @$pb.TagNumber(2)
  set order(Order value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOrder() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrder() => $_clearField(2);
  @$pb.TagNumber(2)
  Order ensureOrder() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get invoiceNumber => $_getSZ(2);
  @$pb.TagNumber(3)
  set invoiceNumber($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasInvoiceNumber() => $_has(2);
  @$pb.TagNumber(3)
  void clearInvoiceNumber() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get pdfUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set pdfUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPdfUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearPdfUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get issuedAt => $_getSZ(4);
  @$pb.TagNumber(5)
  set issuedAt($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIssuedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearIssuedAt() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get dueAt => $_getSZ(5);
  @$pb.TagNumber(6)
  set dueAt($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDueAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearDueAt() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get status => $_getSZ(6);
  @$pb.TagNumber(7)
  set status($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasStatus() => $_has(6);
  @$pb.TagNumber(7)
  void clearStatus() => $_clearField(7);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
