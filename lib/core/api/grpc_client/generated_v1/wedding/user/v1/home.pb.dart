// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/home.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'catalog.pb.dart' as $1;
import 'category.pb.dart' as $3;
import 'package.pb.dart' as $2;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GetHomeDataRequest extends $pb.GeneratedMessage {
  factory GetHomeDataRequest() => GetHomeDataRequest._();

  GetHomeDataRequest._();

  factory GetHomeDataRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetHomeDataRequest()..mergeFromBuffer(data, registry);
  factory GetHomeDataRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetHomeDataRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetHomeDataRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetHomeDataRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHomeDataRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHomeDataRequest copyWith(void Function(GetHomeDataRequest) updates) =>
      super.copyWith((message) => updates(message as GetHomeDataRequest))
          as GetHomeDataRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetHomeDataRequest() / GetHomeDataRequest.new instead')
  static GetHomeDataRequest create() => GetHomeDataRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetHomeDataRequest._();
  @$core.override
  GetHomeDataRequest createEmptyInstance() => GetHomeDataRequest._();
  @$core.pragma('dart2js:noInline')
  static GetHomeDataRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetHomeDataRequest>(
          GetHomeDataRequest.$_createMessage);
  static GetHomeDataRequest? _defaultInstance;
}

class HomeData extends $pb.GeneratedMessage {
  factory HomeData({
    $core.Iterable<$1.Catalog>? featuredCatalogs,
    $core.Iterable<$2.Package>? featuredPackages,
    $core.Iterable<$1.Catalog>? onSaleCatalogs,
    $core.Iterable<$2.Package>? onSalePackages,
    $core.Iterable<$3.Category>? categories,
    $core.Iterable<HeroBanner>? heroBanners,
    $core.Iterable<Promotion>? promotions,
    HomeStats? stats,
  }) {
    final result = HomeData._();
    if (featuredCatalogs != null)
      result.featuredCatalogs.addAll(featuredCatalogs);
    if (featuredPackages != null)
      result.featuredPackages.addAll(featuredPackages);
    if (onSaleCatalogs != null) result.onSaleCatalogs.addAll(onSaleCatalogs);
    if (onSalePackages != null) result.onSalePackages.addAll(onSalePackages);
    if (categories != null) result.categories.addAll(categories);
    if (heroBanners != null) result.heroBanners.addAll(heroBanners);
    if (promotions != null) result.promotions.addAll(promotions);
    if (stats != null) result.stats = stats;
    return result;
  }

  HomeData._();

  factory HomeData.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HomeData()..mergeFromBuffer(data, registry);
  factory HomeData.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HomeData()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HomeData',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: HomeData.$_createMessage)
    ..pPM<$1.Catalog>(1, _omitFieldNames ? '' : 'featuredCatalogs',
        subBuilder: $1.Catalog.$_createMessage)
    ..pPM<$2.Package>(2, _omitFieldNames ? '' : 'featuredPackages',
        subBuilder: $2.Package.$_createMessage)
    ..pPM<$1.Catalog>(3, _omitFieldNames ? '' : 'onSaleCatalogs',
        subBuilder: $1.Catalog.$_createMessage)
    ..pPM<$2.Package>(4, _omitFieldNames ? '' : 'onSalePackages',
        subBuilder: $2.Package.$_createMessage)
    ..pPM<$3.Category>(5, _omitFieldNames ? '' : 'categories',
        subBuilder: $3.Category.$_createMessage)
    ..pPM<HeroBanner>(6, _omitFieldNames ? '' : 'heroBanners',
        subBuilder: HeroBanner.$_createMessage)
    ..pPM<Promotion>(7, _omitFieldNames ? '' : 'promotions',
        subBuilder: Promotion.$_createMessage)
    ..aOM<HomeStats>(8, _omitFieldNames ? '' : 'stats',
        subBuilder: HomeStats.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HomeData clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HomeData copyWith(void Function(HomeData) updates) =>
      super.copyWith((message) => updates(message as HomeData)) as HomeData;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use HomeData() / HomeData.new instead')
  static HomeData create() => HomeData._();
  static $pb.GeneratedMessage $_createMessage() => HomeData._();
  @$core.override
  HomeData createEmptyInstance() => HomeData._();
  @$core.pragma('dart2js:noInline')
  static HomeData getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HomeData>(HomeData.$_createMessage);
  static HomeData? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$1.Catalog> get featuredCatalogs => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<$2.Package> get featuredPackages => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<$1.Catalog> get onSaleCatalogs => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<$2.Package> get onSalePackages => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<$3.Category> get categories => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<HeroBanner> get heroBanners => $_getList(5);

  @$pb.TagNumber(7)
  $pb.PbList<Promotion> get promotions => $_getList(6);

  @$pb.TagNumber(8)
  HomeStats get stats => $_getN(7);
  @$pb.TagNumber(8)
  set stats(HomeStats value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasStats() => $_has(7);
  @$pb.TagNumber(8)
  void clearStats() => $_clearField(8);
  @$pb.TagNumber(8)
  HomeStats ensureStats() => $_ensure(7);
}

class GetHeroBannersRequest extends $pb.GeneratedMessage {
  factory GetHeroBannersRequest() => GetHeroBannersRequest._();

  GetHeroBannersRequest._();

  factory GetHeroBannersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetHeroBannersRequest()..mergeFromBuffer(data, registry);
  factory GetHeroBannersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetHeroBannersRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetHeroBannersRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetHeroBannersRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHeroBannersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHeroBannersRequest copyWith(
          void Function(GetHeroBannersRequest) updates) =>
      super.copyWith((message) => updates(message as GetHeroBannersRequest))
          as GetHeroBannersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetHeroBannersRequest() / GetHeroBannersRequest.new instead')
  static GetHeroBannersRequest create() => GetHeroBannersRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetHeroBannersRequest._();
  @$core.override
  GetHeroBannersRequest createEmptyInstance() => GetHeroBannersRequest._();
  @$core.pragma('dart2js:noInline')
  static GetHeroBannersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetHeroBannersRequest>(
          GetHeroBannersRequest.$_createMessage);
  static GetHeroBannersRequest? _defaultInstance;
}

class HeroBannersResponse extends $pb.GeneratedMessage {
  factory HeroBannersResponse({
    $core.Iterable<HeroBanner>? banners,
  }) {
    final result = HeroBannersResponse._();
    if (banners != null) result.banners.addAll(banners);
    return result;
  }

  HeroBannersResponse._();

  factory HeroBannersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HeroBannersResponse()..mergeFromBuffer(data, registry);
  factory HeroBannersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HeroBannersResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HeroBannersResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: HeroBannersResponse.$_createMessage)
    ..pPM<HeroBanner>(1, _omitFieldNames ? '' : 'banners',
        subBuilder: HeroBanner.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HeroBannersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HeroBannersResponse copyWith(void Function(HeroBannersResponse) updates) =>
      super.copyWith((message) => updates(message as HeroBannersResponse))
          as HeroBannersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use HeroBannersResponse() / HeroBannersResponse.new instead')
  static HeroBannersResponse create() => HeroBannersResponse._();
  static $pb.GeneratedMessage $_createMessage() => HeroBannersResponse._();
  @$core.override
  HeroBannersResponse createEmptyInstance() => HeroBannersResponse._();
  @$core.pragma('dart2js:noInline')
  static HeroBannersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HeroBannersResponse>(
          HeroBannersResponse.$_createMessage);
  static HeroBannersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<HeroBanner> get banners => $_getList(0);
}

class GetPromotionsRequest extends $pb.GeneratedMessage {
  factory GetPromotionsRequest({
    $core.int? limit,
  }) {
    final result = GetPromotionsRequest._();
    if (limit != null) result.limit = limit;
    return result;
  }

  GetPromotionsRequest._();

  factory GetPromotionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPromotionsRequest()..mergeFromBuffer(data, registry);
  factory GetPromotionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPromotionsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPromotionsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetPromotionsRequest.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPromotionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPromotionsRequest copyWith(void Function(GetPromotionsRequest) updates) =>
      super.copyWith((message) => updates(message as GetPromotionsRequest))
          as GetPromotionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPromotionsRequest() / GetPromotionsRequest.new instead')
  static GetPromotionsRequest create() => GetPromotionsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetPromotionsRequest._();
  @$core.override
  GetPromotionsRequest createEmptyInstance() => GetPromotionsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetPromotionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPromotionsRequest>(
          GetPromotionsRequest.$_createMessage);
  static GetPromotionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get limit => $_getIZ(0);
  @$pb.TagNumber(1)
  set limit($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLimit() => $_has(0);
  @$pb.TagNumber(1)
  void clearLimit() => $_clearField(1);
}

class PromotionsResponse extends $pb.GeneratedMessage {
  factory PromotionsResponse({
    $core.Iterable<Promotion>? promotions,
  }) {
    final result = PromotionsResponse._();
    if (promotions != null) result.promotions.addAll(promotions);
    return result;
  }

  PromotionsResponse._();

  factory PromotionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PromotionsResponse()..mergeFromBuffer(data, registry);
  factory PromotionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PromotionsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PromotionsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: PromotionsResponse.$_createMessage)
    ..pPM<Promotion>(1, _omitFieldNames ? '' : 'promotions',
        subBuilder: Promotion.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PromotionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PromotionsResponse copyWith(void Function(PromotionsResponse) updates) =>
      super.copyWith((message) => updates(message as PromotionsResponse))
          as PromotionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PromotionsResponse() / PromotionsResponse.new instead')
  static PromotionsResponse create() => PromotionsResponse._();
  static $pb.GeneratedMessage $_createMessage() => PromotionsResponse._();
  @$core.override
  PromotionsResponse createEmptyInstance() => PromotionsResponse._();
  @$core.pragma('dart2js:noInline')
  static PromotionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PromotionsResponse>(
          PromotionsResponse.$_createMessage);
  static PromotionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Promotion> get promotions => $_getList(0);
}

class HeroBanner extends $pb.GeneratedMessage {
  factory HeroBanner({
    $core.String? id,
    $core.String? title,
    $core.String? subtitle,
    $core.String? imageUrl,
    $core.String? linkUrl,
    $core.String? linkType,
    $core.String? linkId,
    $core.int? position,
    $core.bool? isActive,
  }) {
    final result = HeroBanner._();
    if (id != null) result.id = id;
    if (title != null) result.title = title;
    if (subtitle != null) result.subtitle = subtitle;
    if (imageUrl != null) result.imageUrl = imageUrl;
    if (linkUrl != null) result.linkUrl = linkUrl;
    if (linkType != null) result.linkType = linkType;
    if (linkId != null) result.linkId = linkId;
    if (position != null) result.position = position;
    if (isActive != null) result.isActive = isActive;
    return result;
  }

  HeroBanner._();

  factory HeroBanner.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HeroBanner()..mergeFromBuffer(data, registry);
  factory HeroBanner.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HeroBanner()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HeroBanner',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: HeroBanner.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'subtitle')
    ..aOS(4, _omitFieldNames ? '' : 'imageUrl')
    ..aOS(5, _omitFieldNames ? '' : 'linkUrl')
    ..aOS(6, _omitFieldNames ? '' : 'linkType')
    ..aOS(7, _omitFieldNames ? '' : 'linkId')
    ..aI(8, _omitFieldNames ? '' : 'position')
    ..aOB(9, _omitFieldNames ? '' : 'isActive')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HeroBanner clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HeroBanner copyWith(void Function(HeroBanner) updates) =>
      super.copyWith((message) => updates(message as HeroBanner)) as HeroBanner;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use HeroBanner() / HeroBanner.new instead')
  static HeroBanner create() => HeroBanner._();
  static $pb.GeneratedMessage $_createMessage() => HeroBanner._();
  @$core.override
  HeroBanner createEmptyInstance() => HeroBanner._();
  @$core.pragma('dart2js:noInline')
  static HeroBanner getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HeroBanner>(HeroBanner.$_createMessage);
  static HeroBanner? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get subtitle => $_getSZ(2);
  @$pb.TagNumber(3)
  set subtitle($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSubtitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearSubtitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get imageUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set imageUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasImageUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearImageUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get linkUrl => $_getSZ(4);
  @$pb.TagNumber(5)
  set linkUrl($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLinkUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearLinkUrl() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get linkType => $_getSZ(5);
  @$pb.TagNumber(6)
  set linkType($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLinkType() => $_has(5);
  @$pb.TagNumber(6)
  void clearLinkType() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get linkId => $_getSZ(6);
  @$pb.TagNumber(7)
  set linkId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasLinkId() => $_has(6);
  @$pb.TagNumber(7)
  void clearLinkId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get position => $_getIZ(7);
  @$pb.TagNumber(8)
  set position($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPosition() => $_has(7);
  @$pb.TagNumber(8)
  void clearPosition() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get isActive => $_getBF(8);
  @$pb.TagNumber(9)
  set isActive($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasIsActive() => $_has(8);
  @$pb.TagNumber(9)
  void clearIsActive() => $_clearField(9);
}

class Promotion extends $pb.GeneratedMessage {
  factory Promotion({
    $core.String? id,
    $core.String? title,
    $core.String? description,
    $core.String? imageUrl,
    $core.int? discountPercent,
    $core.String? code,
    $core.String? validFrom,
    $core.String? validUntil,
    $core.bool? isActive,
  }) {
    final result = Promotion._();
    if (id != null) result.id = id;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (imageUrl != null) result.imageUrl = imageUrl;
    if (discountPercent != null) result.discountPercent = discountPercent;
    if (code != null) result.code = code;
    if (validFrom != null) result.validFrom = validFrom;
    if (validUntil != null) result.validUntil = validUntil;
    if (isActive != null) result.isActive = isActive;
    return result;
  }

  Promotion._();

  factory Promotion.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Promotion()..mergeFromBuffer(data, registry);
  factory Promotion.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Promotion()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Promotion',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: Promotion.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..aOS(4, _omitFieldNames ? '' : 'imageUrl')
    ..aI(5, _omitFieldNames ? '' : 'discountPercent')
    ..aOS(6, _omitFieldNames ? '' : 'code')
    ..aOS(7, _omitFieldNames ? '' : 'validFrom')
    ..aOS(8, _omitFieldNames ? '' : 'validUntil')
    ..aOB(9, _omitFieldNames ? '' : 'isActive')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Promotion clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Promotion copyWith(void Function(Promotion) updates) =>
      super.copyWith((message) => updates(message as Promotion)) as Promotion;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Promotion() / Promotion.new instead')
  static Promotion create() => Promotion._();
  static $pb.GeneratedMessage $_createMessage() => Promotion._();
  @$core.override
  Promotion createEmptyInstance() => Promotion._();
  @$core.pragma('dart2js:noInline')
  static Promotion getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Promotion>(Promotion.$_createMessage);
  static Promotion? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get imageUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set imageUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasImageUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearImageUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get discountPercent => $_getIZ(4);
  @$pb.TagNumber(5)
  set discountPercent($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDiscountPercent() => $_has(4);
  @$pb.TagNumber(5)
  void clearDiscountPercent() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get code => $_getSZ(5);
  @$pb.TagNumber(6)
  set code($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCode() => $_has(5);
  @$pb.TagNumber(6)
  void clearCode() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get validFrom => $_getSZ(6);
  @$pb.TagNumber(7)
  set validFrom($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasValidFrom() => $_has(6);
  @$pb.TagNumber(7)
  void clearValidFrom() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get validUntil => $_getSZ(7);
  @$pb.TagNumber(8)
  set validUntil($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasValidUntil() => $_has(7);
  @$pb.TagNumber(8)
  void clearValidUntil() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get isActive => $_getBF(8);
  @$pb.TagNumber(9)
  set isActive($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasIsActive() => $_has(8);
  @$pb.TagNumber(9)
  void clearIsActive() => $_clearField(9);
}

class HomeStats extends $pb.GeneratedMessage {
  factory HomeStats({
    $core.int? totalCatalogs,
    $core.int? totalPackages,
    $core.int? totalCategories,
    $core.int? happyCustomers,
  }) {
    final result = HomeStats._();
    if (totalCatalogs != null) result.totalCatalogs = totalCatalogs;
    if (totalPackages != null) result.totalPackages = totalPackages;
    if (totalCategories != null) result.totalCategories = totalCategories;
    if (happyCustomers != null) result.happyCustomers = happyCustomers;
    return result;
  }

  HomeStats._();

  factory HomeStats.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HomeStats()..mergeFromBuffer(data, registry);
  factory HomeStats.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HomeStats()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HomeStats',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: HomeStats.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'totalCatalogs')
    ..aI(2, _omitFieldNames ? '' : 'totalPackages')
    ..aI(3, _omitFieldNames ? '' : 'totalCategories')
    ..aI(4, _omitFieldNames ? '' : 'happyCustomers')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HomeStats clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HomeStats copyWith(void Function(HomeStats) updates) =>
      super.copyWith((message) => updates(message as HomeStats)) as HomeStats;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use HomeStats() / HomeStats.new instead')
  static HomeStats create() => HomeStats._();
  static $pb.GeneratedMessage $_createMessage() => HomeStats._();
  @$core.override
  HomeStats createEmptyInstance() => HomeStats._();
  @$core.pragma('dart2js:noInline')
  static HomeStats getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HomeStats>(HomeStats.$_createMessage);
  static HomeStats? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get totalCatalogs => $_getIZ(0);
  @$pb.TagNumber(1)
  set totalCatalogs($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotalCatalogs() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalCatalogs() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get totalPackages => $_getIZ(1);
  @$pb.TagNumber(2)
  set totalPackages($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalPackages() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalPackages() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get totalCategories => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalCategories($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalCategories() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalCategories() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get happyCustomers => $_getIZ(3);
  @$pb.TagNumber(4)
  set happyCustomers($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHappyCustomers() => $_has(3);
  @$pb.TagNumber(4)
  void clearHappyCustomers() => $_clearField(4);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
