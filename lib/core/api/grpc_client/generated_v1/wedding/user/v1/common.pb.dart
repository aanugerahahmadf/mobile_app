// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/common.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'common.pbenum.dart';

class PaginationRequest extends $pb.GeneratedMessage {
  factory PaginationRequest({
    $core.int? page,
    $core.int? perPage,
  }) {
    final result = PaginationRequest._();
    if (page != null) result.page = page;
    if (perPage != null) result.perPage = perPage;
    return result;
  }

  PaginationRequest._();

  factory PaginationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaginationRequest()..mergeFromBuffer(data, registry);
  factory PaginationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaginationRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PaginationRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: PaginationRequest.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'page')
    ..aI(2, _omitFieldNames ? '' : 'perPage')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaginationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaginationRequest copyWith(void Function(PaginationRequest) updates) =>
      super.copyWith((message) => updates(message as PaginationRequest))
          as PaginationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PaginationRequest() / PaginationRequest.new instead')
  static PaginationRequest create() => PaginationRequest._();
  static $pb.GeneratedMessage $_createMessage() => PaginationRequest._();
  @$core.override
  PaginationRequest createEmptyInstance() => PaginationRequest._();
  @$core.pragma('dart2js:noInline')
  static PaginationRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PaginationRequest>(
          PaginationRequest.$_createMessage);
  static PaginationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get page => $_getIZ(0);
  @$pb.TagNumber(1)
  set page($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPage() => $_has(0);
  @$pb.TagNumber(1)
  void clearPage() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get perPage => $_getIZ(1);
  @$pb.TagNumber(2)
  set perPage($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPerPage() => $_has(1);
  @$pb.TagNumber(2)
  void clearPerPage() => $_clearField(2);
}

class PaginationResponse extends $pb.GeneratedMessage {
  factory PaginationResponse({
    $core.int? currentPage,
    $core.int? lastPage,
    $core.int? perPage,
    $core.int? total,
    $core.bool? hasMorePages,
  }) {
    final result = PaginationResponse._();
    if (currentPage != null) result.currentPage = currentPage;
    if (lastPage != null) result.lastPage = lastPage;
    if (perPage != null) result.perPage = perPage;
    if (total != null) result.total = total;
    if (hasMorePages != null) result.hasMorePages = hasMorePages;
    return result;
  }

  PaginationResponse._();

  factory PaginationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaginationResponse()..mergeFromBuffer(data, registry);
  factory PaginationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaginationResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PaginationResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: PaginationResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'currentPage')
    ..aI(2, _omitFieldNames ? '' : 'lastPage')
    ..aI(3, _omitFieldNames ? '' : 'perPage')
    ..aI(4, _omitFieldNames ? '' : 'total')
    ..aOB(5, _omitFieldNames ? '' : 'hasMorePages')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaginationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaginationResponse copyWith(void Function(PaginationResponse) updates) =>
      super.copyWith((message) => updates(message as PaginationResponse))
          as PaginationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PaginationResponse() / PaginationResponse.new instead')
  static PaginationResponse create() => PaginationResponse._();
  static $pb.GeneratedMessage $_createMessage() => PaginationResponse._();
  @$core.override
  PaginationResponse createEmptyInstance() => PaginationResponse._();
  @$core.pragma('dart2js:noInline')
  static PaginationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PaginationResponse>(
          PaginationResponse.$_createMessage);
  static PaginationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get currentPage => $_getIZ(0);
  @$pb.TagNumber(1)
  set currentPage($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCurrentPage() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrentPage() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get lastPage => $_getIZ(1);
  @$pb.TagNumber(2)
  set lastPage($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLastPage() => $_has(1);
  @$pb.TagNumber(2)
  void clearLastPage() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get perPage => $_getIZ(2);
  @$pb.TagNumber(3)
  set perPage($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPerPage() => $_has(2);
  @$pb.TagNumber(3)
  void clearPerPage() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get total => $_getIZ(3);
  @$pb.TagNumber(4)
  set total($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTotal() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotal() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get hasMorePages => $_getBF(4);
  @$pb.TagNumber(5)
  set hasMorePages($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasHasMorePages() => $_has(4);
  @$pb.TagNumber(5)
  void clearHasMorePages() => $_clearField(5);
}

class DateRange extends $pb.GeneratedMessage {
  factory DateRange({
    $core.String? from,
    $core.String? to,
  }) {
    final result = DateRange._();
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    return result;
  }

  DateRange._();

  factory DateRange.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DateRange()..mergeFromBuffer(data, registry);
  factory DateRange.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DateRange()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DateRange',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: DateRange.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'from')
    ..aOS(2, _omitFieldNames ? '' : 'to')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DateRange clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DateRange copyWith(void Function(DateRange) updates) =>
      super.copyWith((message) => updates(message as DateRange)) as DateRange;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DateRange() / DateRange.new instead')
  static DateRange create() => DateRange._();
  static $pb.GeneratedMessage $_createMessage() => DateRange._();
  @$core.override
  DateRange createEmptyInstance() => DateRange._();
  @$core.pragma('dart2js:noInline')
  static DateRange getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DateRange>(DateRange.$_createMessage);
  static DateRange? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get from => $_getSZ(0);
  @$pb.TagNumber(1)
  set from($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFrom() => $_has(0);
  @$pb.TagNumber(1)
  void clearFrom() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get to => $_getSZ(1);
  @$pb.TagNumber(2)
  set to($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTo() => $_has(1);
  @$pb.TagNumber(2)
  void clearTo() => $_clearField(2);
}

class PriceRange extends $pb.GeneratedMessage {
  factory PriceRange({
    $core.double? min,
    $core.double? max,
  }) {
    final result = PriceRange._();
    if (min != null) result.min = min;
    if (max != null) result.max = max;
    return result;
  }

  PriceRange._();

  factory PriceRange.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PriceRange()..mergeFromBuffer(data, registry);
  factory PriceRange.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PriceRange()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PriceRange',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: PriceRange.$_createMessage)
    ..aD(1, _omitFieldNames ? '' : 'min')
    ..aD(2, _omitFieldNames ? '' : 'max')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PriceRange clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PriceRange copyWith(void Function(PriceRange) updates) =>
      super.copyWith((message) => updates(message as PriceRange)) as PriceRange;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PriceRange() / PriceRange.new instead')
  static PriceRange create() => PriceRange._();
  static $pb.GeneratedMessage $_createMessage() => PriceRange._();
  @$core.override
  PriceRange createEmptyInstance() => PriceRange._();
  @$core.pragma('dart2js:noInline')
  static PriceRange getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PriceRange>(PriceRange.$_createMessage);
  static PriceRange? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get min => $_getN(0);
  @$pb.TagNumber(1)
  set min($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMin() => $_has(0);
  @$pb.TagNumber(1)
  void clearMin() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get max => $_getN(1);
  @$pb.TagNumber(2)
  set max($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMax() => $_has(1);
  @$pb.TagNumber(2)
  void clearMax() => $_clearField(2);
}

class CapacityRange extends $pb.GeneratedMessage {
  factory CapacityRange({
    $core.int? min,
    $core.int? max,
  }) {
    final result = CapacityRange._();
    if (min != null) result.min = min;
    if (max != null) result.max = max;
    return result;
  }

  CapacityRange._();

  factory CapacityRange.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CapacityRange()..mergeFromBuffer(data, registry);
  factory CapacityRange.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CapacityRange()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CapacityRange',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: CapacityRange.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'min')
    ..aI(2, _omitFieldNames ? '' : 'max')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CapacityRange clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CapacityRange copyWith(void Function(CapacityRange) updates) =>
      super.copyWith((message) => updates(message as CapacityRange))
          as CapacityRange;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CapacityRange() / CapacityRange.new instead')
  static CapacityRange create() => CapacityRange._();
  static $pb.GeneratedMessage $_createMessage() => CapacityRange._();
  @$core.override
  CapacityRange createEmptyInstance() => CapacityRange._();
  @$core.pragma('dart2js:noInline')
  static CapacityRange getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CapacityRange>(
          CapacityRange.$_createMessage);
  static CapacityRange? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get min => $_getIZ(0);
  @$pb.TagNumber(1)
  set min($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMin() => $_has(0);
  @$pb.TagNumber(1)
  void clearMin() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get max => $_getIZ(1);
  @$pb.TagNumber(2)
  set max($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMax() => $_has(1);
  @$pb.TagNumber(2)
  void clearMax() => $_clearField(2);
}

class ImageInfo extends $pb.GeneratedMessage {
  factory ImageInfo({
    $core.String? url,
    $core.String? alt,
    $core.int? sortOrder,
  }) {
    final result = ImageInfo._();
    if (url != null) result.url = url;
    if (alt != null) result.alt = alt;
    if (sortOrder != null) result.sortOrder = sortOrder;
    return result;
  }

  ImageInfo._();

  factory ImageInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ImageInfo()..mergeFromBuffer(data, registry);
  factory ImageInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ImageInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ImageInfo',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ImageInfo.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..aOS(2, _omitFieldNames ? '' : 'alt')
    ..aI(3, _omitFieldNames ? '' : 'sortOrder')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImageInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImageInfo copyWith(void Function(ImageInfo) updates) =>
      super.copyWith((message) => updates(message as ImageInfo)) as ImageInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ImageInfo() / ImageInfo.new instead')
  static ImageInfo create() => ImageInfo._();
  static $pb.GeneratedMessage $_createMessage() => ImageInfo._();
  @$core.override
  ImageInfo createEmptyInstance() => ImageInfo._();
  @$core.pragma('dart2js:noInline')
  static ImageInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ImageInfo>(ImageInfo.$_createMessage);
  static ImageInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get alt => $_getSZ(1);
  @$pb.TagNumber(2)
  set alt($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAlt() => $_has(1);
  @$pb.TagNumber(2)
  void clearAlt() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get sortOrder => $_getIZ(2);
  @$pb.TagNumber(3)
  set sortOrder($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSortOrder() => $_has(2);
  @$pb.TagNumber(3)
  void clearSortOrder() => $_clearField(3);
}

class MetaData extends $pb.GeneratedMessage {
  factory MetaData({
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? data,
  }) {
    final result = MetaData._();
    if (data != null) result.data.addEntries(data);
    return result;
  }

  MetaData._();

  factory MetaData.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MetaData()..mergeFromBuffer(data, registry);
  factory MetaData.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MetaData()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MetaData',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: MetaData.$_createMessage)
    ..m<$core.String, $core.String>(1, _omitFieldNames ? '' : 'data',
        entryClassName: 'MetaData.DataEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('wedding.user.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetaData clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetaData copyWith(void Function(MetaData) updates) =>
      super.copyWith((message) => updates(message as MetaData)) as MetaData;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use MetaData() / MetaData.new instead')
  static MetaData create() => MetaData._();
  static $pb.GeneratedMessage $_createMessage() => MetaData._();
  @$core.override
  MetaData createEmptyInstance() => MetaData._();
  @$core.pragma('dart2js:noInline')
  static MetaData getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MetaData>(MetaData.$_createMessage);
  static MetaData? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.String, $core.String> get data => $_getMap(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
