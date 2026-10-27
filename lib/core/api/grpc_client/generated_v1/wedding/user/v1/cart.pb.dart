// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/cart.proto.

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
import 'package.pb.dart' as $5;
import 'voucher.pb.dart' as $3;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GetMyCartRequest extends $pb.GeneratedMessage {
  factory GetMyCartRequest() => GetMyCartRequest._();

  GetMyCartRequest._();

  factory GetMyCartRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMyCartRequest()..mergeFromBuffer(data, registry);
  factory GetMyCartRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMyCartRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMyCartRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetMyCartRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMyCartRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMyCartRequest copyWith(void Function(GetMyCartRequest) updates) =>
      super.copyWith((message) => updates(message as GetMyCartRequest))
          as GetMyCartRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetMyCartRequest() / GetMyCartRequest.new instead')
  static GetMyCartRequest create() => GetMyCartRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetMyCartRequest._();
  @$core.override
  GetMyCartRequest createEmptyInstance() => GetMyCartRequest._();
  @$core.pragma('dart2js:noInline')
  static GetMyCartRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetMyCartRequest>(
          GetMyCartRequest.$_createMessage);
  static GetMyCartRequest? _defaultInstance;
}

class AddToCartRequest extends $pb.GeneratedMessage {
  factory AddToCartRequest({
    $core.String? catalogId,
    $core.String? packageId,
    $core.int? quantity,
    $1.MetaData? options,
  }) {
    final result = AddToCartRequest._();
    if (catalogId != null) result.catalogId = catalogId;
    if (packageId != null) result.packageId = packageId;
    if (quantity != null) result.quantity = quantity;
    if (options != null) result.options = options;
    return result;
  }

  AddToCartRequest._();

  factory AddToCartRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AddToCartRequest()..mergeFromBuffer(data, registry);
  factory AddToCartRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AddToCartRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddToCartRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: AddToCartRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'catalogId')
    ..aOS(2, _omitFieldNames ? '' : 'packageId')
    ..aI(3, _omitFieldNames ? '' : 'quantity')
    ..aOM<$1.MetaData>(4, _omitFieldNames ? '' : 'options',
        subBuilder: $1.MetaData.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddToCartRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddToCartRequest copyWith(void Function(AddToCartRequest) updates) =>
      super.copyWith((message) => updates(message as AddToCartRequest))
          as AddToCartRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AddToCartRequest() / AddToCartRequest.new instead')
  static AddToCartRequest create() => AddToCartRequest._();
  static $pb.GeneratedMessage $_createMessage() => AddToCartRequest._();
  @$core.override
  AddToCartRequest createEmptyInstance() => AddToCartRequest._();
  @$core.pragma('dart2js:noInline')
  static AddToCartRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddToCartRequest>(
          AddToCartRequest.$_createMessage);
  static AddToCartRequest? _defaultInstance;

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
  $1.MetaData get options => $_getN(3);
  @$pb.TagNumber(4)
  set options($1.MetaData value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasOptions() => $_has(3);
  @$pb.TagNumber(4)
  void clearOptions() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.MetaData ensureOptions() => $_ensure(3);
}

class UpdateCartItemRequest extends $pb.GeneratedMessage {
  factory UpdateCartItemRequest({
    $core.String? cartItemId,
    $core.int? quantity,
    $1.MetaData? options,
  }) {
    final result = UpdateCartItemRequest._();
    if (cartItemId != null) result.cartItemId = cartItemId;
    if (quantity != null) result.quantity = quantity;
    if (options != null) result.options = options;
    return result;
  }

  UpdateCartItemRequest._();

  factory UpdateCartItemRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateCartItemRequest()..mergeFromBuffer(data, registry);
  factory UpdateCartItemRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateCartItemRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateCartItemRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: UpdateCartItemRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'cartItemId')
    ..aI(2, _omitFieldNames ? '' : 'quantity')
    ..aOM<$1.MetaData>(3, _omitFieldNames ? '' : 'options',
        subBuilder: $1.MetaData.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateCartItemRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateCartItemRequest copyWith(
          void Function(UpdateCartItemRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateCartItemRequest))
          as UpdateCartItemRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateCartItemRequest() / UpdateCartItemRequest.new instead')
  static UpdateCartItemRequest create() => UpdateCartItemRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdateCartItemRequest._();
  @$core.override
  UpdateCartItemRequest createEmptyInstance() => UpdateCartItemRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateCartItemRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateCartItemRequest>(
          UpdateCartItemRequest.$_createMessage);
  static UpdateCartItemRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cartItemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set cartItemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCartItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCartItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get quantity => $_getIZ(1);
  @$pb.TagNumber(2)
  set quantity($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuantity() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuantity() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.MetaData get options => $_getN(2);
  @$pb.TagNumber(3)
  set options($1.MetaData value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasOptions() => $_has(2);
  @$pb.TagNumber(3)
  void clearOptions() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.MetaData ensureOptions() => $_ensure(2);
}

class RemoveFromCartRequest extends $pb.GeneratedMessage {
  factory RemoveFromCartRequest({
    $core.String? cartItemId,
  }) {
    final result = RemoveFromCartRequest._();
    if (cartItemId != null) result.cartItemId = cartItemId;
    return result;
  }

  RemoveFromCartRequest._();

  factory RemoveFromCartRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemoveFromCartRequest()..mergeFromBuffer(data, registry);
  factory RemoveFromCartRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemoveFromCartRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemoveFromCartRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: RemoveFromCartRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'cartItemId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveFromCartRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveFromCartRequest copyWith(
          void Function(RemoveFromCartRequest) updates) =>
      super.copyWith((message) => updates(message as RemoveFromCartRequest))
          as RemoveFromCartRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RemoveFromCartRequest() / RemoveFromCartRequest.new instead')
  static RemoveFromCartRequest create() => RemoveFromCartRequest._();
  static $pb.GeneratedMessage $_createMessage() => RemoveFromCartRequest._();
  @$core.override
  RemoveFromCartRequest createEmptyInstance() => RemoveFromCartRequest._();
  @$core.pragma('dart2js:noInline')
  static RemoveFromCartRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemoveFromCartRequest>(
          RemoveFromCartRequest.$_createMessage);
  static RemoveFromCartRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cartItemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set cartItemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCartItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCartItemId() => $_clearField(1);
}

class ClearCartRequest extends $pb.GeneratedMessage {
  factory ClearCartRequest() => ClearCartRequest._();

  ClearCartRequest._();

  factory ClearCartRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClearCartRequest()..mergeFromBuffer(data, registry);
  factory ClearCartRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClearCartRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClearCartRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ClearCartRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearCartRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearCartRequest copyWith(void Function(ClearCartRequest) updates) =>
      super.copyWith((message) => updates(message as ClearCartRequest))
          as ClearCartRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ClearCartRequest() / ClearCartRequest.new instead')
  static ClearCartRequest create() => ClearCartRequest._();
  static $pb.GeneratedMessage $_createMessage() => ClearCartRequest._();
  @$core.override
  ClearCartRequest createEmptyInstance() => ClearCartRequest._();
  @$core.pragma('dart2js:noInline')
  static ClearCartRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClearCartRequest>(
          ClearCartRequest.$_createMessage);
  static ClearCartRequest? _defaultInstance;
}

class ApplyVoucherToCartRequest extends $pb.GeneratedMessage {
  factory ApplyVoucherToCartRequest({
    $core.String? code,
  }) {
    final result = ApplyVoucherToCartRequest._();
    if (code != null) result.code = code;
    return result;
  }

  ApplyVoucherToCartRequest._();

  factory ApplyVoucherToCartRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ApplyVoucherToCartRequest()..mergeFromBuffer(data, registry);
  factory ApplyVoucherToCartRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ApplyVoucherToCartRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApplyVoucherToCartRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ApplyVoucherToCartRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApplyVoucherToCartRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApplyVoucherToCartRequest copyWith(
          void Function(ApplyVoucherToCartRequest) updates) =>
      super.copyWith((message) => updates(message as ApplyVoucherToCartRequest))
          as ApplyVoucherToCartRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ApplyVoucherToCartRequest() / ApplyVoucherToCartRequest.new instead')
  static ApplyVoucherToCartRequest create() => ApplyVoucherToCartRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ApplyVoucherToCartRequest._();
  @$core.override
  ApplyVoucherToCartRequest createEmptyInstance() =>
      ApplyVoucherToCartRequest._();
  @$core.pragma('dart2js:noInline')
  static ApplyVoucherToCartRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApplyVoucherToCartRequest>(
          ApplyVoucherToCartRequest.$_createMessage);
  static ApplyVoucherToCartRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);
}

class RemoveVoucherFromCartRequest extends $pb.GeneratedMessage {
  factory RemoveVoucherFromCartRequest() => RemoveVoucherFromCartRequest._();

  RemoveVoucherFromCartRequest._();

  factory RemoveVoucherFromCartRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemoveVoucherFromCartRequest()..mergeFromBuffer(data, registry);
  factory RemoveVoucherFromCartRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemoveVoucherFromCartRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemoveVoucherFromCartRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: RemoveVoucherFromCartRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveVoucherFromCartRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveVoucherFromCartRequest copyWith(
          void Function(RemoveVoucherFromCartRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RemoveVoucherFromCartRequest))
          as RemoveVoucherFromCartRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RemoveVoucherFromCartRequest() / RemoveVoucherFromCartRequest.new instead')
  static RemoveVoucherFromCartRequest create() =>
      RemoveVoucherFromCartRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      RemoveVoucherFromCartRequest._();
  @$core.override
  RemoveVoucherFromCartRequest createEmptyInstance() =>
      RemoveVoucherFromCartRequest._();
  @$core.pragma('dart2js:noInline')
  static RemoveVoucherFromCartRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemoveVoucherFromCartRequest>(
          RemoveVoucherFromCartRequest.$_createMessage);
  static RemoveVoucherFromCartRequest? _defaultInstance;
}

class SyncCartRequest extends $pb.GeneratedMessage {
  factory SyncCartRequest({
    $core.Iterable<SyncCartItemInput>? items,
  }) {
    final result = SyncCartRequest._();
    if (items != null) result.items.addAll(items);
    return result;
  }

  SyncCartRequest._();

  factory SyncCartRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SyncCartRequest()..mergeFromBuffer(data, registry);
  factory SyncCartRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SyncCartRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SyncCartRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: SyncCartRequest.$_createMessage)
    ..pPM<SyncCartItemInput>(1, _omitFieldNames ? '' : 'items',
        subBuilder: SyncCartItemInput.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncCartRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncCartRequest copyWith(void Function(SyncCartRequest) updates) =>
      super.copyWith((message) => updates(message as SyncCartRequest))
          as SyncCartRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SyncCartRequest() / SyncCartRequest.new instead')
  static SyncCartRequest create() => SyncCartRequest._();
  static $pb.GeneratedMessage $_createMessage() => SyncCartRequest._();
  @$core.override
  SyncCartRequest createEmptyInstance() => SyncCartRequest._();
  @$core.pragma('dart2js:noInline')
  static SyncCartRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncCartRequest>(
          SyncCartRequest.$_createMessage);
  static SyncCartRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SyncCartItemInput> get items => $_getList(0);
}

class EstimateShippingRequest extends $pb.GeneratedMessage {
  factory EstimateShippingRequest({
    $core.String? addressId,
  }) {
    final result = EstimateShippingRequest._();
    if (addressId != null) result.addressId = addressId;
    return result;
  }

  EstimateShippingRequest._();

  factory EstimateShippingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EstimateShippingRequest()..mergeFromBuffer(data, registry);
  factory EstimateShippingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EstimateShippingRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EstimateShippingRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: EstimateShippingRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'addressId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EstimateShippingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EstimateShippingRequest copyWith(
          void Function(EstimateShippingRequest) updates) =>
      super.copyWith((message) => updates(message as EstimateShippingRequest))
          as EstimateShippingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use EstimateShippingRequest() / EstimateShippingRequest.new instead')
  static EstimateShippingRequest create() => EstimateShippingRequest._();
  static $pb.GeneratedMessage $_createMessage() => EstimateShippingRequest._();
  @$core.override
  EstimateShippingRequest createEmptyInstance() => EstimateShippingRequest._();
  @$core.pragma('dart2js:noInline')
  static EstimateShippingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EstimateShippingRequest>(
          EstimateShippingRequest.$_createMessage);
  static EstimateShippingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get addressId => $_getSZ(0);
  @$pb.TagNumber(1)
  set addressId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAddressId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddressId() => $_clearField(1);
}

class Cart extends $pb.GeneratedMessage {
  factory Cart({
    $core.String? id,
    $2.User? user,
    $core.Iterable<CartItem>? items,
    $core.double? subtotal,
    $core.double? discount,
    $3.Voucher? voucher,
    $core.double? shippingCost,
    $core.double? tax,
    $core.double? total,
    $core.int? itemCount,
    $core.String? updatedAt,
  }) {
    final result = Cart._();
    if (id != null) result.id = id;
    if (user != null) result.user = user;
    if (items != null) result.items.addAll(items);
    if (subtotal != null) result.subtotal = subtotal;
    if (discount != null) result.discount = discount;
    if (voucher != null) result.voucher = voucher;
    if (shippingCost != null) result.shippingCost = shippingCost;
    if (tax != null) result.tax = tax;
    if (total != null) result.total = total;
    if (itemCount != null) result.itemCount = itemCount;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  Cart._();

  factory Cart.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Cart()..mergeFromBuffer(data, registry);
  factory Cart.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Cart()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Cart',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: Cart.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOM<$2.User>(2, _omitFieldNames ? '' : 'user',
        subBuilder: $2.User.$_createMessage)
    ..pPM<CartItem>(3, _omitFieldNames ? '' : 'items',
        subBuilder: CartItem.$_createMessage)
    ..aD(4, _omitFieldNames ? '' : 'subtotal')
    ..aD(5, _omitFieldNames ? '' : 'discount')
    ..aOM<$3.Voucher>(6, _omitFieldNames ? '' : 'voucher',
        subBuilder: $3.Voucher.$_createMessage)
    ..aD(7, _omitFieldNames ? '' : 'shippingCost')
    ..aD(8, _omitFieldNames ? '' : 'tax')
    ..aD(9, _omitFieldNames ? '' : 'total')
    ..aI(10, _omitFieldNames ? '' : 'itemCount')
    ..aOS(11, _omitFieldNames ? '' : 'updatedAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Cart clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Cart copyWith(void Function(Cart) updates) =>
      super.copyWith((message) => updates(message as Cart)) as Cart;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Cart() / Cart.new instead')
  static Cart create() => Cart._();
  static $pb.GeneratedMessage $_createMessage() => Cart._();
  @$core.override
  Cart createEmptyInstance() => Cart._();
  @$core.pragma('dart2js:noInline')
  static Cart getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Cart>(Cart.$_createMessage);
  static Cart? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $2.User get user => $_getN(1);
  @$pb.TagNumber(2)
  set user($2.User value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearUser() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.User ensureUser() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<CartItem> get items => $_getList(2);

  @$pb.TagNumber(4)
  $core.double get subtotal => $_getN(3);
  @$pb.TagNumber(4)
  set subtotal($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSubtotal() => $_has(3);
  @$pb.TagNumber(4)
  void clearSubtotal() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get discount => $_getN(4);
  @$pb.TagNumber(5)
  set discount($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDiscount() => $_has(4);
  @$pb.TagNumber(5)
  void clearDiscount() => $_clearField(5);

  @$pb.TagNumber(6)
  $3.Voucher get voucher => $_getN(5);
  @$pb.TagNumber(6)
  set voucher($3.Voucher value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasVoucher() => $_has(5);
  @$pb.TagNumber(6)
  void clearVoucher() => $_clearField(6);
  @$pb.TagNumber(6)
  $3.Voucher ensureVoucher() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.double get shippingCost => $_getN(6);
  @$pb.TagNumber(7)
  set shippingCost($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasShippingCost() => $_has(6);
  @$pb.TagNumber(7)
  void clearShippingCost() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get tax => $_getN(7);
  @$pb.TagNumber(8)
  set tax($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTax() => $_has(7);
  @$pb.TagNumber(8)
  void clearTax() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get total => $_getN(8);
  @$pb.TagNumber(9)
  set total($core.double value) => $_setDouble(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTotal() => $_has(8);
  @$pb.TagNumber(9)
  void clearTotal() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get itemCount => $_getIZ(9);
  @$pb.TagNumber(10)
  set itemCount($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasItemCount() => $_has(9);
  @$pb.TagNumber(10)
  void clearItemCount() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get updatedAt => $_getSZ(10);
  @$pb.TagNumber(11)
  set updatedAt($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasUpdatedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearUpdatedAt() => $_clearField(11);
}

class CartItem extends $pb.GeneratedMessage {
  factory CartItem({
    $core.String? id,
    $2.User? user,
    $4.Catalog? catalog,
    $5.Package? package,
    $core.int? quantity,
    $core.double? subtotal,
    $1.MetaData? options,
    $core.String? createdAt,
    $core.String? updatedAt,
  }) {
    final result = CartItem._();
    if (id != null) result.id = id;
    if (user != null) result.user = user;
    if (catalog != null) result.catalog = catalog;
    if (package != null) result.package = package;
    if (quantity != null) result.quantity = quantity;
    if (subtotal != null) result.subtotal = subtotal;
    if (options != null) result.options = options;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  CartItem._();

  factory CartItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CartItem()..mergeFromBuffer(data, registry);
  factory CartItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CartItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CartItem',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: CartItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOM<$2.User>(2, _omitFieldNames ? '' : 'user',
        subBuilder: $2.User.$_createMessage)
    ..aOM<$4.Catalog>(3, _omitFieldNames ? '' : 'catalog',
        subBuilder: $4.Catalog.$_createMessage)
    ..aOM<$5.Package>(4, _omitFieldNames ? '' : 'package',
        subBuilder: $5.Package.$_createMessage)
    ..aI(5, _omitFieldNames ? '' : 'quantity')
    ..aD(6, _omitFieldNames ? '' : 'subtotal')
    ..aOM<$1.MetaData>(7, _omitFieldNames ? '' : 'options',
        subBuilder: $1.MetaData.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'createdAt')
    ..aOS(9, _omitFieldNames ? '' : 'updatedAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CartItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CartItem copyWith(void Function(CartItem) updates) =>
      super.copyWith((message) => updates(message as CartItem)) as CartItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CartItem() / CartItem.new instead')
  static CartItem create() => CartItem._();
  static $pb.GeneratedMessage $_createMessage() => CartItem._();
  @$core.override
  CartItem createEmptyInstance() => CartItem._();
  @$core.pragma('dart2js:noInline')
  static CartItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CartItem>(CartItem.$_createMessage);
  static CartItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $2.User get user => $_getN(1);
  @$pb.TagNumber(2)
  set user($2.User value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearUser() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.User ensureUser() => $_ensure(1);

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
  $core.int get quantity => $_getIZ(4);
  @$pb.TagNumber(5)
  set quantity($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasQuantity() => $_has(4);
  @$pb.TagNumber(5)
  void clearQuantity() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get subtotal => $_getN(5);
  @$pb.TagNumber(6)
  set subtotal($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSubtotal() => $_has(5);
  @$pb.TagNumber(6)
  void clearSubtotal() => $_clearField(6);

  @$pb.TagNumber(7)
  $1.MetaData get options => $_getN(6);
  @$pb.TagNumber(7)
  set options($1.MetaData value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasOptions() => $_has(6);
  @$pb.TagNumber(7)
  void clearOptions() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.MetaData ensureOptions() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get createdAt => $_getSZ(7);
  @$pb.TagNumber(8)
  set createdAt($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCreatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreatedAt() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get updatedAt => $_getSZ(8);
  @$pb.TagNumber(9)
  set updatedAt($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasUpdatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearUpdatedAt() => $_clearField(9);
}

class ShippingEstimate extends $pb.GeneratedMessage {
  factory ShippingEstimate({
    $core.double? cost,
    $core.int? estimatedDays,
    $core.String? method,
    $core.bool? available,
  }) {
    final result = ShippingEstimate._();
    if (cost != null) result.cost = cost;
    if (estimatedDays != null) result.estimatedDays = estimatedDays;
    if (method != null) result.method = method;
    if (available != null) result.available = available;
    return result;
  }

  ShippingEstimate._();

  factory ShippingEstimate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ShippingEstimate()..mergeFromBuffer(data, registry);
  factory ShippingEstimate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ShippingEstimate()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ShippingEstimate',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ShippingEstimate.$_createMessage)
    ..aD(1, _omitFieldNames ? '' : 'cost')
    ..aI(2, _omitFieldNames ? '' : 'estimatedDays')
    ..aOS(3, _omitFieldNames ? '' : 'method')
    ..aOB(4, _omitFieldNames ? '' : 'available')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShippingEstimate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShippingEstimate copyWith(void Function(ShippingEstimate) updates) =>
      super.copyWith((message) => updates(message as ShippingEstimate))
          as ShippingEstimate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ShippingEstimate() / ShippingEstimate.new instead')
  static ShippingEstimate create() => ShippingEstimate._();
  static $pb.GeneratedMessage $_createMessage() => ShippingEstimate._();
  @$core.override
  ShippingEstimate createEmptyInstance() => ShippingEstimate._();
  @$core.pragma('dart2js:noInline')
  static ShippingEstimate getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ShippingEstimate>(
          ShippingEstimate.$_createMessage);
  static ShippingEstimate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get cost => $_getN(0);
  @$pb.TagNumber(1)
  set cost($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCost() => $_has(0);
  @$pb.TagNumber(1)
  void clearCost() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get estimatedDays => $_getIZ(1);
  @$pb.TagNumber(2)
  set estimatedDays($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEstimatedDays() => $_has(1);
  @$pb.TagNumber(2)
  void clearEstimatedDays() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get method => $_getSZ(2);
  @$pb.TagNumber(3)
  set method($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMethod() => $_has(2);
  @$pb.TagNumber(3)
  void clearMethod() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get available => $_getBF(3);
  @$pb.TagNumber(4)
  set available($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAvailable() => $_has(3);
  @$pb.TagNumber(4)
  void clearAvailable() => $_clearField(4);
}

class RemoveFromCartResponse extends $pb.GeneratedMessage {
  factory RemoveFromCartResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = RemoveFromCartResponse._();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  RemoveFromCartResponse._();

  factory RemoveFromCartResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemoveFromCartResponse()..mergeFromBuffer(data, registry);
  factory RemoveFromCartResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemoveFromCartResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemoveFromCartResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: RemoveFromCartResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveFromCartResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveFromCartResponse copyWith(
          void Function(RemoveFromCartResponse) updates) =>
      super.copyWith((message) => updates(message as RemoveFromCartResponse))
          as RemoveFromCartResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RemoveFromCartResponse() / RemoveFromCartResponse.new instead')
  static RemoveFromCartResponse create() => RemoveFromCartResponse._();
  static $pb.GeneratedMessage $_createMessage() => RemoveFromCartResponse._();
  @$core.override
  RemoveFromCartResponse createEmptyInstance() => RemoveFromCartResponse._();
  @$core.pragma('dart2js:noInline')
  static RemoveFromCartResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemoveFromCartResponse>(
          RemoveFromCartResponse.$_createMessage);
  static RemoveFromCartResponse? _defaultInstance;

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

class ClearCartResponse extends $pb.GeneratedMessage {
  factory ClearCartResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = ClearCartResponse._();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  ClearCartResponse._();

  factory ClearCartResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClearCartResponse()..mergeFromBuffer(data, registry);
  factory ClearCartResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClearCartResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClearCartResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ClearCartResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearCartResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearCartResponse copyWith(void Function(ClearCartResponse) updates) =>
      super.copyWith((message) => updates(message as ClearCartResponse))
          as ClearCartResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ClearCartResponse() / ClearCartResponse.new instead')
  static ClearCartResponse create() => ClearCartResponse._();
  static $pb.GeneratedMessage $_createMessage() => ClearCartResponse._();
  @$core.override
  ClearCartResponse createEmptyInstance() => ClearCartResponse._();
  @$core.pragma('dart2js:noInline')
  static ClearCartResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClearCartResponse>(
          ClearCartResponse.$_createMessage);
  static ClearCartResponse? _defaultInstance;

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

class SyncCartItemInput extends $pb.GeneratedMessage {
  factory SyncCartItemInput({
    $core.String? catalogId,
    $core.String? packageId,
    $core.int? quantity,
    $1.MetaData? options,
  }) {
    final result = SyncCartItemInput._();
    if (catalogId != null) result.catalogId = catalogId;
    if (packageId != null) result.packageId = packageId;
    if (quantity != null) result.quantity = quantity;
    if (options != null) result.options = options;
    return result;
  }

  SyncCartItemInput._();

  factory SyncCartItemInput.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SyncCartItemInput()..mergeFromBuffer(data, registry);
  factory SyncCartItemInput.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SyncCartItemInput()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SyncCartItemInput',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: SyncCartItemInput.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'catalogId')
    ..aOS(2, _omitFieldNames ? '' : 'packageId')
    ..aI(3, _omitFieldNames ? '' : 'quantity')
    ..aOM<$1.MetaData>(4, _omitFieldNames ? '' : 'options',
        subBuilder: $1.MetaData.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncCartItemInput clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncCartItemInput copyWith(void Function(SyncCartItemInput) updates) =>
      super.copyWith((message) => updates(message as SyncCartItemInput))
          as SyncCartItemInput;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SyncCartItemInput() / SyncCartItemInput.new instead')
  static SyncCartItemInput create() => SyncCartItemInput._();
  static $pb.GeneratedMessage $_createMessage() => SyncCartItemInput._();
  @$core.override
  SyncCartItemInput createEmptyInstance() => SyncCartItemInput._();
  @$core.pragma('dart2js:noInline')
  static SyncCartItemInput getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncCartItemInput>(
          SyncCartItemInput.$_createMessage);
  static SyncCartItemInput? _defaultInstance;

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
  $1.MetaData get options => $_getN(3);
  @$pb.TagNumber(4)
  set options($1.MetaData value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasOptions() => $_has(3);
  @$pb.TagNumber(4)
  void clearOptions() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.MetaData ensureOptions() => $_ensure(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
