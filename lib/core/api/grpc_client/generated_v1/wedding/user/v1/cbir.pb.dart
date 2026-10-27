// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/cbir.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'category.pb.dart' as $2;
import 'common.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// Search Similar
class SearchSimilarRequest extends $pb.GeneratedMessage {
  factory SearchSimilarRequest({
    $core.List<$core.int>? image,
    $core.String? mimeType,
  }) {
    final result = SearchSimilarRequest._();
    if (image != null) result.image = image;
    if (mimeType != null) result.mimeType = mimeType;
    return result;
  }

  SearchSimilarRequest._();

  factory SearchSimilarRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchSimilarRequest()..mergeFromBuffer(data, registry);
  factory SearchSimilarRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchSimilarRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchSimilarRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: SearchSimilarRequest.$_createMessage)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'image', $pb.PbFieldType.OY)
    ..aOS(2, _omitFieldNames ? '' : 'mimeType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchSimilarRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchSimilarRequest copyWith(void Function(SearchSimilarRequest) updates) =>
      super.copyWith((message) => updates(message as SearchSimilarRequest))
          as SearchSimilarRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SearchSimilarRequest() / SearchSimilarRequest.new instead')
  static SearchSimilarRequest create() => SearchSimilarRequest._();
  static $pb.GeneratedMessage $_createMessage() => SearchSimilarRequest._();
  @$core.override
  SearchSimilarRequest createEmptyInstance() => SearchSimilarRequest._();
  @$core.pragma('dart2js:noInline')
  static SearchSimilarRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchSimilarRequest>(
          SearchSimilarRequest.$_createMessage);
  static SearchSimilarRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get image => $_getN(0);
  @$pb.TagNumber(1)
  set image($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasImage() => $_has(0);
  @$pb.TagNumber(1)
  void clearImage() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get mimeType => $_getSZ(1);
  @$pb.TagNumber(2)
  set mimeType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMimeType() => $_has(1);
  @$pb.TagNumber(2)
  void clearMimeType() => $_clearField(2);
}

class SearchSimilarChunkRequest extends $pb.GeneratedMessage {
  factory SearchSimilarChunkRequest({
    $core.List<$core.int>? chunk,
    $core.int? chunkIndex,
    $core.int? totalChunks,
    $core.String? mimeType,
  }) {
    final result = SearchSimilarChunkRequest._();
    if (chunk != null) result.chunk = chunk;
    if (chunkIndex != null) result.chunkIndex = chunkIndex;
    if (totalChunks != null) result.totalChunks = totalChunks;
    if (mimeType != null) result.mimeType = mimeType;
    return result;
  }

  SearchSimilarChunkRequest._();

  factory SearchSimilarChunkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchSimilarChunkRequest()..mergeFromBuffer(data, registry);
  factory SearchSimilarChunkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchSimilarChunkRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchSimilarChunkRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: SearchSimilarChunkRequest.$_createMessage)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'chunk', $pb.PbFieldType.OY)
    ..aI(2, _omitFieldNames ? '' : 'chunkIndex')
    ..aI(3, _omitFieldNames ? '' : 'totalChunks')
    ..aOS(4, _omitFieldNames ? '' : 'mimeType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchSimilarChunkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchSimilarChunkRequest copyWith(
          void Function(SearchSimilarChunkRequest) updates) =>
      super.copyWith((message) => updates(message as SearchSimilarChunkRequest))
          as SearchSimilarChunkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SearchSimilarChunkRequest() / SearchSimilarChunkRequest.new instead')
  static SearchSimilarChunkRequest create() => SearchSimilarChunkRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SearchSimilarChunkRequest._();
  @$core.override
  SearchSimilarChunkRequest createEmptyInstance() =>
      SearchSimilarChunkRequest._();
  @$core.pragma('dart2js:noInline')
  static SearchSimilarChunkRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchSimilarChunkRequest>(
          SearchSimilarChunkRequest.$_createMessage);
  static SearchSimilarChunkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chunk => $_getN(0);
  @$pb.TagNumber(1)
  set chunk($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChunk() => $_has(0);
  @$pb.TagNumber(1)
  void clearChunk() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get chunkIndex => $_getIZ(1);
  @$pb.TagNumber(2)
  set chunkIndex($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasChunkIndex() => $_has(1);
  @$pb.TagNumber(2)
  void clearChunkIndex() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get totalChunks => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalChunks($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalChunks() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalChunks() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get mimeType => $_getSZ(3);
  @$pb.TagNumber(4)
  set mimeType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMimeType() => $_has(3);
  @$pb.TagNumber(4)
  void clearMimeType() => $_clearField(4);
}

class CbirSearchResponse extends $pb.GeneratedMessage {
  factory CbirSearchResponse({
    $core.bool? success,
    $core.String? message,
    $core.Iterable<CbirResult>? results,
    $core.int? totalResults,
    $core.double? queryTimeSeconds,
  }) {
    final result = CbirSearchResponse._();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    if (results != null) result.results.addAll(results);
    if (totalResults != null) result.totalResults = totalResults;
    if (queryTimeSeconds != null) result.queryTimeSeconds = queryTimeSeconds;
    return result;
  }

  CbirSearchResponse._();

  factory CbirSearchResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CbirSearchResponse()..mergeFromBuffer(data, registry);
  factory CbirSearchResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CbirSearchResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CbirSearchResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: CbirSearchResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..pPM<CbirResult>(3, _omitFieldNames ? '' : 'results',
        subBuilder: CbirResult.$_createMessage)
    ..aI(4, _omitFieldNames ? '' : 'totalResults')
    ..aD(5, _omitFieldNames ? '' : 'queryTimeSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CbirSearchResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CbirSearchResponse copyWith(void Function(CbirSearchResponse) updates) =>
      super.copyWith((message) => updates(message as CbirSearchResponse))
          as CbirSearchResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CbirSearchResponse() / CbirSearchResponse.new instead')
  static CbirSearchResponse create() => CbirSearchResponse._();
  static $pb.GeneratedMessage $_createMessage() => CbirSearchResponse._();
  @$core.override
  CbirSearchResponse createEmptyInstance() => CbirSearchResponse._();
  @$core.pragma('dart2js:noInline')
  static CbirSearchResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CbirSearchResponse>(
          CbirSearchResponse.$_createMessage);
  static CbirSearchResponse? _defaultInstance;

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

  @$pb.TagNumber(3)
  $pb.PbList<CbirResult> get results => $_getList(2);

  @$pb.TagNumber(4)
  $core.int get totalResults => $_getIZ(3);
  @$pb.TagNumber(4)
  set totalResults($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTotalResults() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalResults() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get queryTimeSeconds => $_getN(4);
  @$pb.TagNumber(5)
  set queryTimeSeconds($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasQueryTimeSeconds() => $_has(4);
  @$pb.TagNumber(5)
  void clearQueryTimeSeconds() => $_clearField(5);
}

/// Arithmetic Search
class ArithmeticSearchRequest extends $pb.GeneratedMessage {
  factory ArithmeticSearchRequest({
    $core.List<$core.int>? image1,
    $core.String? mimeType1,
    $core.List<$core.int>? image2,
    $core.String? mimeType2,
    $core.String? operation,
    $core.Iterable<$core.double>? weights,
  }) {
    final result = ArithmeticSearchRequest._();
    if (image1 != null) result.image1 = image1;
    if (mimeType1 != null) result.mimeType1 = mimeType1;
    if (image2 != null) result.image2 = image2;
    if (mimeType2 != null) result.mimeType2 = mimeType2;
    if (operation != null) result.operation = operation;
    if (weights != null) result.weights.addAll(weights);
    return result;
  }

  ArithmeticSearchRequest._();

  factory ArithmeticSearchRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ArithmeticSearchRequest()..mergeFromBuffer(data, registry);
  factory ArithmeticSearchRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ArithmeticSearchRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ArithmeticSearchRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ArithmeticSearchRequest.$_createMessage)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'image1', $pb.PbFieldType.OY,
        protoName: 'image_1')
    ..aOS(2, _omitFieldNames ? '' : 'mimeType1', protoName: 'mime_type_1')
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'image2', $pb.PbFieldType.OY,
        protoName: 'image_2')
    ..aOS(4, _omitFieldNames ? '' : 'mimeType2', protoName: 'mime_type_2')
    ..aOS(5, _omitFieldNames ? '' : 'operation')
    ..p<$core.double>(6, _omitFieldNames ? '' : 'weights', $pb.PbFieldType.KD)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArithmeticSearchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArithmeticSearchRequest copyWith(
          void Function(ArithmeticSearchRequest) updates) =>
      super.copyWith((message) => updates(message as ArithmeticSearchRequest))
          as ArithmeticSearchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ArithmeticSearchRequest() / ArithmeticSearchRequest.new instead')
  static ArithmeticSearchRequest create() => ArithmeticSearchRequest._();
  static $pb.GeneratedMessage $_createMessage() => ArithmeticSearchRequest._();
  @$core.override
  ArithmeticSearchRequest createEmptyInstance() => ArithmeticSearchRequest._();
  @$core.pragma('dart2js:noInline')
  static ArithmeticSearchRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ArithmeticSearchRequest>(
          ArithmeticSearchRequest.$_createMessage);
  static ArithmeticSearchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get image1 => $_getN(0);
  @$pb.TagNumber(1)
  set image1($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasImage1() => $_has(0);
  @$pb.TagNumber(1)
  void clearImage1() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get mimeType1 => $_getSZ(1);
  @$pb.TagNumber(2)
  set mimeType1($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMimeType1() => $_has(1);
  @$pb.TagNumber(2)
  void clearMimeType1() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get image2 => $_getN(2);
  @$pb.TagNumber(3)
  set image2($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasImage2() => $_has(2);
  @$pb.TagNumber(3)
  void clearImage2() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get mimeType2 => $_getSZ(3);
  @$pb.TagNumber(4)
  set mimeType2($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMimeType2() => $_has(3);
  @$pb.TagNumber(4)
  void clearMimeType2() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get operation => $_getSZ(4);
  @$pb.TagNumber(5)
  set operation($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOperation() => $_has(4);
  @$pb.TagNumber(5)
  void clearOperation() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.double> get weights => $_getList(5);
}

class GetArithmeticOpsRequest extends $pb.GeneratedMessage {
  factory GetArithmeticOpsRequest() => GetArithmeticOpsRequest._();

  GetArithmeticOpsRequest._();

  factory GetArithmeticOpsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetArithmeticOpsRequest()..mergeFromBuffer(data, registry);
  factory GetArithmeticOpsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetArithmeticOpsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetArithmeticOpsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetArithmeticOpsRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetArithmeticOpsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetArithmeticOpsRequest copyWith(
          void Function(GetArithmeticOpsRequest) updates) =>
      super.copyWith((message) => updates(message as GetArithmeticOpsRequest))
          as GetArithmeticOpsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetArithmeticOpsRequest() / GetArithmeticOpsRequest.new instead')
  static GetArithmeticOpsRequest create() => GetArithmeticOpsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetArithmeticOpsRequest._();
  @$core.override
  GetArithmeticOpsRequest createEmptyInstance() => GetArithmeticOpsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetArithmeticOpsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetArithmeticOpsRequest>(
          GetArithmeticOpsRequest.$_createMessage);
  static GetArithmeticOpsRequest? _defaultInstance;
}

class ArithmeticOpsResponse extends $pb.GeneratedMessage {
  factory ArithmeticOpsResponse({
    $core.Iterable<ArithmeticOp>? ops,
  }) {
    final result = ArithmeticOpsResponse._();
    if (ops != null) result.ops.addAll(ops);
    return result;
  }

  ArithmeticOpsResponse._();

  factory ArithmeticOpsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ArithmeticOpsResponse()..mergeFromBuffer(data, registry);
  factory ArithmeticOpsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ArithmeticOpsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ArithmeticOpsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ArithmeticOpsResponse.$_createMessage)
    ..pPM<ArithmeticOp>(1, _omitFieldNames ? '' : 'ops',
        subBuilder: ArithmeticOp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArithmeticOpsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArithmeticOpsResponse copyWith(
          void Function(ArithmeticOpsResponse) updates) =>
      super.copyWith((message) => updates(message as ArithmeticOpsResponse))
          as ArithmeticOpsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ArithmeticOpsResponse() / ArithmeticOpsResponse.new instead')
  static ArithmeticOpsResponse create() => ArithmeticOpsResponse._();
  static $pb.GeneratedMessage $_createMessage() => ArithmeticOpsResponse._();
  @$core.override
  ArithmeticOpsResponse createEmptyInstance() => ArithmeticOpsResponse._();
  @$core.pragma('dart2js:noInline')
  static ArithmeticOpsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ArithmeticOpsResponse>(
          ArithmeticOpsResponse.$_createMessage);
  static ArithmeticOpsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ArithmeticOp> get ops => $_getList(0);
}

class ArithmeticOp extends $pb.GeneratedMessage {
  factory ArithmeticOp({
    $core.String? name,
    $core.String? description,
    $core.int? minImages,
    $core.int? maxImages,
    $core.bool? supportsWeights,
  }) {
    final result = ArithmeticOp._();
    if (name != null) result.name = name;
    if (description != null) result.description = description;
    if (minImages != null) result.minImages = minImages;
    if (maxImages != null) result.maxImages = maxImages;
    if (supportsWeights != null) result.supportsWeights = supportsWeights;
    return result;
  }

  ArithmeticOp._();

  factory ArithmeticOp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ArithmeticOp()..mergeFromBuffer(data, registry);
  factory ArithmeticOp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ArithmeticOp()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ArithmeticOp',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ArithmeticOp.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'description')
    ..aI(3, _omitFieldNames ? '' : 'minImages')
    ..aI(4, _omitFieldNames ? '' : 'maxImages')
    ..aOB(5, _omitFieldNames ? '' : 'supportsWeights')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArithmeticOp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArithmeticOp copyWith(void Function(ArithmeticOp) updates) =>
      super.copyWith((message) => updates(message as ArithmeticOp))
          as ArithmeticOp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ArithmeticOp() / ArithmeticOp.new instead')
  static ArithmeticOp create() => ArithmeticOp._();
  static $pb.GeneratedMessage $_createMessage() => ArithmeticOp._();
  @$core.override
  ArithmeticOp createEmptyInstance() => ArithmeticOp._();
  @$core.pragma('dart2js:noInline')
  static ArithmeticOp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ArithmeticOp>(
          ArithmeticOp.$_createMessage);
  static ArithmeticOp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get description => $_getSZ(1);
  @$pb.TagNumber(2)
  set description($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescription() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get minImages => $_getIZ(2);
  @$pb.TagNumber(3)
  set minImages($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMinImages() => $_has(2);
  @$pb.TagNumber(3)
  void clearMinImages() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get maxImages => $_getIZ(3);
  @$pb.TagNumber(4)
  set maxImages($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMaxImages() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaxImages() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get supportsWeights => $_getBF(4);
  @$pb.TagNumber(5)
  set supportsWeights($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSupportsWeights() => $_has(4);
  @$pb.TagNumber(5)
  void clearSupportsWeights() => $_clearField(5);
}

/// Stats
class GetCbirStatsRequest extends $pb.GeneratedMessage {
  factory GetCbirStatsRequest() => GetCbirStatsRequest._();

  GetCbirStatsRequest._();

  factory GetCbirStatsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCbirStatsRequest()..mergeFromBuffer(data, registry);
  factory GetCbirStatsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCbirStatsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCbirStatsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetCbirStatsRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCbirStatsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCbirStatsRequest copyWith(void Function(GetCbirStatsRequest) updates) =>
      super.copyWith((message) => updates(message as GetCbirStatsRequest))
          as GetCbirStatsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use GetCbirStatsRequest() / GetCbirStatsRequest.new instead')
  static GetCbirStatsRequest create() => GetCbirStatsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetCbirStatsRequest._();
  @$core.override
  GetCbirStatsRequest createEmptyInstance() => GetCbirStatsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetCbirStatsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCbirStatsRequest>(
          GetCbirStatsRequest.$_createMessage);
  static GetCbirStatsRequest? _defaultInstance;
}

class CbirStats extends $pb.GeneratedMessage {
  factory CbirStats({
    $core.int? totalImages,
    $core.int? totalFeatures,
    $core.String? databaseSize,
    $core.String? lastUpdated,
  }) {
    final result = CbirStats._();
    if (totalImages != null) result.totalImages = totalImages;
    if (totalFeatures != null) result.totalFeatures = totalFeatures;
    if (databaseSize != null) result.databaseSize = databaseSize;
    if (lastUpdated != null) result.lastUpdated = lastUpdated;
    return result;
  }

  CbirStats._();

  factory CbirStats.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CbirStats()..mergeFromBuffer(data, registry);
  factory CbirStats.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CbirStats()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CbirStats',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: CbirStats.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'totalImages')
    ..aI(2, _omitFieldNames ? '' : 'totalFeatures')
    ..aOS(3, _omitFieldNames ? '' : 'databaseSize')
    ..aOS(4, _omitFieldNames ? '' : 'lastUpdated')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CbirStats clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CbirStats copyWith(void Function(CbirStats) updates) =>
      super.copyWith((message) => updates(message as CbirStats)) as CbirStats;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CbirStats() / CbirStats.new instead')
  static CbirStats create() => CbirStats._();
  static $pb.GeneratedMessage $_createMessage() => CbirStats._();
  @$core.override
  CbirStats createEmptyInstance() => CbirStats._();
  @$core.pragma('dart2js:noInline')
  static CbirStats getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CbirStats>(CbirStats.$_createMessage);
  static CbirStats? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get totalImages => $_getIZ(0);
  @$pb.TagNumber(1)
  set totalImages($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotalImages() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalImages() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get totalFeatures => $_getIZ(1);
  @$pb.TagNumber(2)
  set totalFeatures($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalFeatures() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalFeatures() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get databaseSize => $_getSZ(2);
  @$pb.TagNumber(3)
  set databaseSize($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDatabaseSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearDatabaseSize() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get lastUpdated => $_getSZ(3);
  @$pb.TagNumber(4)
  set lastUpdated($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLastUpdated() => $_has(3);
  @$pb.TagNumber(4)
  void clearLastUpdated() => $_clearField(4);
}

/// History
class GetCbirHistoryRequest extends $pb.GeneratedMessage {
  factory GetCbirHistoryRequest({
    $1.PaginationRequest? pagination,
  }) {
    final result = GetCbirHistoryRequest._();
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  GetCbirHistoryRequest._();

  factory GetCbirHistoryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCbirHistoryRequest()..mergeFromBuffer(data, registry);
  factory GetCbirHistoryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCbirHistoryRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCbirHistoryRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetCbirHistoryRequest.$_createMessage)
    ..aOM<$1.PaginationRequest>(1, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginationRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCbirHistoryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCbirHistoryRequest copyWith(
          void Function(GetCbirHistoryRequest) updates) =>
      super.copyWith((message) => updates(message as GetCbirHistoryRequest))
          as GetCbirHistoryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetCbirHistoryRequest() / GetCbirHistoryRequest.new instead')
  static GetCbirHistoryRequest create() => GetCbirHistoryRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetCbirHistoryRequest._();
  @$core.override
  GetCbirHistoryRequest createEmptyInstance() => GetCbirHistoryRequest._();
  @$core.pragma('dart2js:noInline')
  static GetCbirHistoryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCbirHistoryRequest>(
          GetCbirHistoryRequest.$_createMessage);
  static GetCbirHistoryRequest? _defaultInstance;

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

class CbirHistoryResponse extends $pb.GeneratedMessage {
  factory CbirHistoryResponse({
    $core.Iterable<CbirHistory>? history,
    $1.PaginationResponse? pagination,
  }) {
    final result = CbirHistoryResponse._();
    if (history != null) result.history.addAll(history);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  CbirHistoryResponse._();

  factory CbirHistoryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CbirHistoryResponse()..mergeFromBuffer(data, registry);
  factory CbirHistoryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CbirHistoryResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CbirHistoryResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: CbirHistoryResponse.$_createMessage)
    ..pPM<CbirHistory>(1, _omitFieldNames ? '' : 'history',
        subBuilder: CbirHistory.$_createMessage)
    ..aOM<$1.PaginationResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginationResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CbirHistoryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CbirHistoryResponse copyWith(void Function(CbirHistoryResponse) updates) =>
      super.copyWith((message) => updates(message as CbirHistoryResponse))
          as CbirHistoryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use CbirHistoryResponse() / CbirHistoryResponse.new instead')
  static CbirHistoryResponse create() => CbirHistoryResponse._();
  static $pb.GeneratedMessage $_createMessage() => CbirHistoryResponse._();
  @$core.override
  CbirHistoryResponse createEmptyInstance() => CbirHistoryResponse._();
  @$core.pragma('dart2js:noInline')
  static CbirHistoryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CbirHistoryResponse>(
          CbirHistoryResponse.$_createMessage);
  static CbirHistoryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CbirHistory> get history => $_getList(0);

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

class CbirHistory extends $pb.GeneratedMessage {
  factory CbirHistory({
    $core.String? id,
    $core.String? userId,
    $core.String? queryImageUrl,
    $core.Iterable<CbirHistoryResult>? results,
    $core.int? resultsCount,
    $core.double? topSimilarity,
    $core.String? createdAt,
  }) {
    final result = CbirHistory._();
    if (id != null) result.id = id;
    if (userId != null) result.userId = userId;
    if (queryImageUrl != null) result.queryImageUrl = queryImageUrl;
    if (results != null) result.results.addAll(results);
    if (resultsCount != null) result.resultsCount = resultsCount;
    if (topSimilarity != null) result.topSimilarity = topSimilarity;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  CbirHistory._();

  factory CbirHistory.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CbirHistory()..mergeFromBuffer(data, registry);
  factory CbirHistory.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CbirHistory()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CbirHistory',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: CbirHistory.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..aOS(3, _omitFieldNames ? '' : 'queryImageUrl')
    ..pPM<CbirHistoryResult>(4, _omitFieldNames ? '' : 'results',
        subBuilder: CbirHistoryResult.$_createMessage)
    ..aI(5, _omitFieldNames ? '' : 'resultsCount')
    ..aD(6, _omitFieldNames ? '' : 'topSimilarity')
    ..aOS(7, _omitFieldNames ? '' : 'createdAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CbirHistory clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CbirHistory copyWith(void Function(CbirHistory) updates) =>
      super.copyWith((message) => updates(message as CbirHistory))
          as CbirHistory;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CbirHistory() / CbirHistory.new instead')
  static CbirHistory create() => CbirHistory._();
  static $pb.GeneratedMessage $_createMessage() => CbirHistory._();
  @$core.override
  CbirHistory createEmptyInstance() => CbirHistory._();
  @$core.pragma('dart2js:noInline')
  static CbirHistory getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CbirHistory>(
          CbirHistory.$_createMessage);
  static CbirHistory? _defaultInstance;

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
  $core.String get queryImageUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set queryImageUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQueryImageUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearQueryImageUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<CbirHistoryResult> get results => $_getList(3);

  @$pb.TagNumber(5)
  $core.int get resultsCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set resultsCount($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasResultsCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearResultsCount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get topSimilarity => $_getN(5);
  @$pb.TagNumber(6)
  set topSimilarity($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTopSimilarity() => $_has(5);
  @$pb.TagNumber(6)
  void clearTopSimilarity() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get createdAt => $_getSZ(6);
  @$pb.TagNumber(7)
  set createdAt($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCreatedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreatedAt() => $_clearField(7);
}

class CbirHistoryResult extends $pb.GeneratedMessage {
  factory CbirHistoryResult({
    $core.String? type,
    $core.String? itemId,
    $core.double? similarity,
    $core.double? score,
    CbirResultData? item,
  }) {
    final result = CbirHistoryResult._();
    if (type != null) result.type = type;
    if (itemId != null) result.itemId = itemId;
    if (similarity != null) result.similarity = similarity;
    if (score != null) result.score = score;
    if (item != null) result.item = item;
    return result;
  }

  CbirHistoryResult._();

  factory CbirHistoryResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CbirHistoryResult()..mergeFromBuffer(data, registry);
  factory CbirHistoryResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CbirHistoryResult()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CbirHistoryResult',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: CbirHistoryResult.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'type')
    ..aOS(2, _omitFieldNames ? '' : 'itemId')
    ..aD(3, _omitFieldNames ? '' : 'similarity')
    ..aD(4, _omitFieldNames ? '' : 'score')
    ..aOM<CbirResultData>(5, _omitFieldNames ? '' : 'item',
        subBuilder: CbirResultData.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CbirHistoryResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CbirHistoryResult copyWith(void Function(CbirHistoryResult) updates) =>
      super.copyWith((message) => updates(message as CbirHistoryResult))
          as CbirHistoryResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CbirHistoryResult() / CbirHistoryResult.new instead')
  static CbirHistoryResult create() => CbirHistoryResult._();
  static $pb.GeneratedMessage $_createMessage() => CbirHistoryResult._();
  @$core.override
  CbirHistoryResult createEmptyInstance() => CbirHistoryResult._();
  @$core.pragma('dart2js:noInline')
  static CbirHistoryResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CbirHistoryResult>(
          CbirHistoryResult.$_createMessage);
  static CbirHistoryResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get type => $_getSZ(0);
  @$pb.TagNumber(1)
  set type($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get itemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set itemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get similarity => $_getN(2);
  @$pb.TagNumber(3)
  set similarity($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSimilarity() => $_has(2);
  @$pb.TagNumber(3)
  void clearSimilarity() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get score => $_getN(3);
  @$pb.TagNumber(4)
  set score($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasScore() => $_has(3);
  @$pb.TagNumber(4)
  void clearScore() => $_clearField(4);

  @$pb.TagNumber(5)
  CbirResultData get item => $_getN(4);
  @$pb.TagNumber(5)
  set item(CbirResultData value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasItem() => $_has(4);
  @$pb.TagNumber(5)
  void clearItem() => $_clearField(5);
  @$pb.TagNumber(5)
  CbirResultData ensureItem() => $_ensure(4);
}

class GetSavedCbirResultsRequest extends $pb.GeneratedMessage {
  factory GetSavedCbirResultsRequest({
    $core.String? searchId,
  }) {
    final result = GetSavedCbirResultsRequest._();
    if (searchId != null) result.searchId = searchId;
    return result;
  }

  GetSavedCbirResultsRequest._();

  factory GetSavedCbirResultsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSavedCbirResultsRequest()..mergeFromBuffer(data, registry);
  factory GetSavedCbirResultsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSavedCbirResultsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSavedCbirResultsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetSavedCbirResultsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'searchId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSavedCbirResultsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSavedCbirResultsRequest copyWith(
          void Function(GetSavedCbirResultsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetSavedCbirResultsRequest))
          as GetSavedCbirResultsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetSavedCbirResultsRequest() / GetSavedCbirResultsRequest.new instead')
  static GetSavedCbirResultsRequest create() => GetSavedCbirResultsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetSavedCbirResultsRequest._();
  @$core.override
  GetSavedCbirResultsRequest createEmptyInstance() =>
      GetSavedCbirResultsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetSavedCbirResultsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSavedCbirResultsRequest>(
          GetSavedCbirResultsRequest.$_createMessage);
  static GetSavedCbirResultsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get searchId => $_getSZ(0);
  @$pb.TagNumber(1)
  set searchId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSearchId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSearchId() => $_clearField(1);
}

class CbirSavedResultsResponse extends $pb.GeneratedMessage {
  factory CbirSavedResultsResponse({
    $core.Iterable<CbirResult>? results,
  }) {
    final result = CbirSavedResultsResponse._();
    if (results != null) result.results.addAll(results);
    return result;
  }

  CbirSavedResultsResponse._();

  factory CbirSavedResultsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CbirSavedResultsResponse()..mergeFromBuffer(data, registry);
  factory CbirSavedResultsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CbirSavedResultsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CbirSavedResultsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: CbirSavedResultsResponse.$_createMessage)
    ..pPM<CbirResult>(1, _omitFieldNames ? '' : 'results',
        subBuilder: CbirResult.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CbirSavedResultsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CbirSavedResultsResponse copyWith(
          void Function(CbirSavedResultsResponse) updates) =>
      super.copyWith((message) => updates(message as CbirSavedResultsResponse))
          as CbirSavedResultsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CbirSavedResultsResponse() / CbirSavedResultsResponse.new instead')
  static CbirSavedResultsResponse create() => CbirSavedResultsResponse._();
  static $pb.GeneratedMessage $_createMessage() => CbirSavedResultsResponse._();
  @$core.override
  CbirSavedResultsResponse createEmptyInstance() =>
      CbirSavedResultsResponse._();
  @$core.pragma('dart2js:noInline')
  static CbirSavedResultsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CbirSavedResultsResponse>(
          CbirSavedResultsResponse.$_createMessage);
  static CbirSavedResultsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CbirResult> get results => $_getList(0);
}

class SaveCbirSearchRequest extends $pb.GeneratedMessage {
  factory SaveCbirSearchRequest({
    $core.String? queryImageUrl,
    $core.Iterable<CbirSearchResultItemInput>? results,
  }) {
    final result = SaveCbirSearchRequest._();
    if (queryImageUrl != null) result.queryImageUrl = queryImageUrl;
    if (results != null) result.results.addAll(results);
    return result;
  }

  SaveCbirSearchRequest._();

  factory SaveCbirSearchRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SaveCbirSearchRequest()..mergeFromBuffer(data, registry);
  factory SaveCbirSearchRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SaveCbirSearchRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SaveCbirSearchRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: SaveCbirSearchRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'queryImageUrl')
    ..pPM<CbirSearchResultItemInput>(2, _omitFieldNames ? '' : 'results',
        subBuilder: CbirSearchResultItemInput.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SaveCbirSearchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SaveCbirSearchRequest copyWith(
          void Function(SaveCbirSearchRequest) updates) =>
      super.copyWith((message) => updates(message as SaveCbirSearchRequest))
          as SaveCbirSearchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SaveCbirSearchRequest() / SaveCbirSearchRequest.new instead')
  static SaveCbirSearchRequest create() => SaveCbirSearchRequest._();
  static $pb.GeneratedMessage $_createMessage() => SaveCbirSearchRequest._();
  @$core.override
  SaveCbirSearchRequest createEmptyInstance() => SaveCbirSearchRequest._();
  @$core.pragma('dart2js:noInline')
  static SaveCbirSearchRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SaveCbirSearchRequest>(
          SaveCbirSearchRequest.$_createMessage);
  static SaveCbirSearchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get queryImageUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set queryImageUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQueryImageUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearQueryImageUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<CbirSearchResultItemInput> get results => $_getList(1);
}

class CbirSearchResultItemInput extends $pb.GeneratedMessage {
  factory CbirSearchResultItemInput({
    $core.String? type,
    $core.String? itemId,
    $core.double? similarity,
    $core.double? score,
  }) {
    final result = CbirSearchResultItemInput._();
    if (type != null) result.type = type;
    if (itemId != null) result.itemId = itemId;
    if (similarity != null) result.similarity = similarity;
    if (score != null) result.score = score;
    return result;
  }

  CbirSearchResultItemInput._();

  factory CbirSearchResultItemInput.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CbirSearchResultItemInput()..mergeFromBuffer(data, registry);
  factory CbirSearchResultItemInput.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CbirSearchResultItemInput()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CbirSearchResultItemInput',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: CbirSearchResultItemInput.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'type')
    ..aOS(2, _omitFieldNames ? '' : 'itemId')
    ..aD(3, _omitFieldNames ? '' : 'similarity')
    ..aD(4, _omitFieldNames ? '' : 'score')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CbirSearchResultItemInput clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CbirSearchResultItemInput copyWith(
          void Function(CbirSearchResultItemInput) updates) =>
      super.copyWith((message) => updates(message as CbirSearchResultItemInput))
          as CbirSearchResultItemInput;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CbirSearchResultItemInput() / CbirSearchResultItemInput.new instead')
  static CbirSearchResultItemInput create() => CbirSearchResultItemInput._();
  static $pb.GeneratedMessage $_createMessage() =>
      CbirSearchResultItemInput._();
  @$core.override
  CbirSearchResultItemInput createEmptyInstance() =>
      CbirSearchResultItemInput._();
  @$core.pragma('dart2js:noInline')
  static CbirSearchResultItemInput getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CbirSearchResultItemInput>(
          CbirSearchResultItemInput.$_createMessage);
  static CbirSearchResultItemInput? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get type => $_getSZ(0);
  @$pb.TagNumber(1)
  set type($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get itemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set itemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get similarity => $_getN(2);
  @$pb.TagNumber(3)
  set similarity($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSimilarity() => $_has(2);
  @$pb.TagNumber(3)
  void clearSimilarity() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get score => $_getN(3);
  @$pb.TagNumber(4)
  set score($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasScore() => $_has(3);
  @$pb.TagNumber(4)
  void clearScore() => $_clearField(4);
}

class DeleteCbirSearchRequest extends $pb.GeneratedMessage {
  factory DeleteCbirSearchRequest({
    $core.String? searchId,
  }) {
    final result = DeleteCbirSearchRequest._();
    if (searchId != null) result.searchId = searchId;
    return result;
  }

  DeleteCbirSearchRequest._();

  factory DeleteCbirSearchRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteCbirSearchRequest()..mergeFromBuffer(data, registry);
  factory DeleteCbirSearchRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteCbirSearchRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteCbirSearchRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: DeleteCbirSearchRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'searchId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteCbirSearchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteCbirSearchRequest copyWith(
          void Function(DeleteCbirSearchRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteCbirSearchRequest))
          as DeleteCbirSearchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DeleteCbirSearchRequest() / DeleteCbirSearchRequest.new instead')
  static DeleteCbirSearchRequest create() => DeleteCbirSearchRequest._();
  static $pb.GeneratedMessage $_createMessage() => DeleteCbirSearchRequest._();
  @$core.override
  DeleteCbirSearchRequest createEmptyInstance() => DeleteCbirSearchRequest._();
  @$core.pragma('dart2js:noInline')
  static DeleteCbirSearchRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteCbirSearchRequest>(
          DeleteCbirSearchRequest.$_createMessage);
  static DeleteCbirSearchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get searchId => $_getSZ(0);
  @$pb.TagNumber(1)
  set searchId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSearchId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSearchId() => $_clearField(1);
}

class DeleteCbirSearchResponse extends $pb.GeneratedMessage {
  factory DeleteCbirSearchResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = DeleteCbirSearchResponse._();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  DeleteCbirSearchResponse._();

  factory DeleteCbirSearchResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteCbirSearchResponse()..mergeFromBuffer(data, registry);
  factory DeleteCbirSearchResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteCbirSearchResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteCbirSearchResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: DeleteCbirSearchResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteCbirSearchResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteCbirSearchResponse copyWith(
          void Function(DeleteCbirSearchResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteCbirSearchResponse))
          as DeleteCbirSearchResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DeleteCbirSearchResponse() / DeleteCbirSearchResponse.new instead')
  static DeleteCbirSearchResponse create() => DeleteCbirSearchResponse._();
  static $pb.GeneratedMessage $_createMessage() => DeleteCbirSearchResponse._();
  @$core.override
  DeleteCbirSearchResponse createEmptyInstance() =>
      DeleteCbirSearchResponse._();
  @$core.pragma('dart2js:noInline')
  static DeleteCbirSearchResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteCbirSearchResponse>(
          DeleteCbirSearchResponse.$_createMessage);
  static DeleteCbirSearchResponse? _defaultInstance;

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

class ClearCbirHistoryRequest extends $pb.GeneratedMessage {
  factory ClearCbirHistoryRequest() => ClearCbirHistoryRequest._();

  ClearCbirHistoryRequest._();

  factory ClearCbirHistoryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClearCbirHistoryRequest()..mergeFromBuffer(data, registry);
  factory ClearCbirHistoryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClearCbirHistoryRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClearCbirHistoryRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ClearCbirHistoryRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearCbirHistoryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearCbirHistoryRequest copyWith(
          void Function(ClearCbirHistoryRequest) updates) =>
      super.copyWith((message) => updates(message as ClearCbirHistoryRequest))
          as ClearCbirHistoryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ClearCbirHistoryRequest() / ClearCbirHistoryRequest.new instead')
  static ClearCbirHistoryRequest create() => ClearCbirHistoryRequest._();
  static $pb.GeneratedMessage $_createMessage() => ClearCbirHistoryRequest._();
  @$core.override
  ClearCbirHistoryRequest createEmptyInstance() => ClearCbirHistoryRequest._();
  @$core.pragma('dart2js:noInline')
  static ClearCbirHistoryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClearCbirHistoryRequest>(
          ClearCbirHistoryRequest.$_createMessage);
  static ClearCbirHistoryRequest? _defaultInstance;
}

class ClearCbirHistoryResponse extends $pb.GeneratedMessage {
  factory ClearCbirHistoryResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = ClearCbirHistoryResponse._();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  ClearCbirHistoryResponse._();

  factory ClearCbirHistoryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClearCbirHistoryResponse()..mergeFromBuffer(data, registry);
  factory ClearCbirHistoryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClearCbirHistoryResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClearCbirHistoryResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ClearCbirHistoryResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearCbirHistoryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearCbirHistoryResponse copyWith(
          void Function(ClearCbirHistoryResponse) updates) =>
      super.copyWith((message) => updates(message as ClearCbirHistoryResponse))
          as ClearCbirHistoryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ClearCbirHistoryResponse() / ClearCbirHistoryResponse.new instead')
  static ClearCbirHistoryResponse create() => ClearCbirHistoryResponse._();
  static $pb.GeneratedMessage $_createMessage() => ClearCbirHistoryResponse._();
  @$core.override
  ClearCbirHistoryResponse createEmptyInstance() =>
      ClearCbirHistoryResponse._();
  @$core.pragma('dart2js:noInline')
  static ClearCbirHistoryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClearCbirHistoryResponse>(
          ClearCbirHistoryResponse.$_createMessage);
  static ClearCbirHistoryResponse? _defaultInstance;

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

class SubmitCbirFeedbackRequest extends $pb.GeneratedMessage {
  factory SubmitCbirFeedbackRequest({
    $core.String? searchId,
    $core.String? itemId,
    $core.String? itemType,
    $core.bool? isRelevant,
    $core.String? feedback,
  }) {
    final result = SubmitCbirFeedbackRequest._();
    if (searchId != null) result.searchId = searchId;
    if (itemId != null) result.itemId = itemId;
    if (itemType != null) result.itemType = itemType;
    if (isRelevant != null) result.isRelevant = isRelevant;
    if (feedback != null) result.feedback = feedback;
    return result;
  }

  SubmitCbirFeedbackRequest._();

  factory SubmitCbirFeedbackRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SubmitCbirFeedbackRequest()..mergeFromBuffer(data, registry);
  factory SubmitCbirFeedbackRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SubmitCbirFeedbackRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubmitCbirFeedbackRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: SubmitCbirFeedbackRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'searchId')
    ..aOS(2, _omitFieldNames ? '' : 'itemId')
    ..aOS(3, _omitFieldNames ? '' : 'itemType')
    ..aOB(4, _omitFieldNames ? '' : 'isRelevant')
    ..aOS(5, _omitFieldNames ? '' : 'feedback')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubmitCbirFeedbackRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubmitCbirFeedbackRequest copyWith(
          void Function(SubmitCbirFeedbackRequest) updates) =>
      super.copyWith((message) => updates(message as SubmitCbirFeedbackRequest))
          as SubmitCbirFeedbackRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SubmitCbirFeedbackRequest() / SubmitCbirFeedbackRequest.new instead')
  static SubmitCbirFeedbackRequest create() => SubmitCbirFeedbackRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SubmitCbirFeedbackRequest._();
  @$core.override
  SubmitCbirFeedbackRequest createEmptyInstance() =>
      SubmitCbirFeedbackRequest._();
  @$core.pragma('dart2js:noInline')
  static SubmitCbirFeedbackRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubmitCbirFeedbackRequest>(
          SubmitCbirFeedbackRequest.$_createMessage);
  static SubmitCbirFeedbackRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get searchId => $_getSZ(0);
  @$pb.TagNumber(1)
  set searchId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSearchId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSearchId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get itemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set itemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get itemType => $_getSZ(2);
  @$pb.TagNumber(3)
  set itemType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasItemType() => $_has(2);
  @$pb.TagNumber(3)
  void clearItemType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isRelevant => $_getBF(3);
  @$pb.TagNumber(4)
  set isRelevant($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsRelevant() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsRelevant() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get feedback => $_getSZ(4);
  @$pb.TagNumber(5)
  set feedback($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFeedback() => $_has(4);
  @$pb.TagNumber(5)
  void clearFeedback() => $_clearField(5);
}

class SubmitCbirFeedbackResponse extends $pb.GeneratedMessage {
  factory SubmitCbirFeedbackResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = SubmitCbirFeedbackResponse._();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  SubmitCbirFeedbackResponse._();

  factory SubmitCbirFeedbackResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SubmitCbirFeedbackResponse()..mergeFromBuffer(data, registry);
  factory SubmitCbirFeedbackResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SubmitCbirFeedbackResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubmitCbirFeedbackResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: SubmitCbirFeedbackResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubmitCbirFeedbackResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubmitCbirFeedbackResponse copyWith(
          void Function(SubmitCbirFeedbackResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SubmitCbirFeedbackResponse))
          as SubmitCbirFeedbackResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SubmitCbirFeedbackResponse() / SubmitCbirFeedbackResponse.new instead')
  static SubmitCbirFeedbackResponse create() => SubmitCbirFeedbackResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SubmitCbirFeedbackResponse._();
  @$core.override
  SubmitCbirFeedbackResponse createEmptyInstance() =>
      SubmitCbirFeedbackResponse._();
  @$core.pragma('dart2js:noInline')
  static SubmitCbirFeedbackResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubmitCbirFeedbackResponse>(
          SubmitCbirFeedbackResponse.$_createMessage);
  static SubmitCbirFeedbackResponse? _defaultInstance;

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

/// Admin operations
class RebuildCbirIndexRequest extends $pb.GeneratedMessage {
  factory RebuildCbirIndexRequest() => RebuildCbirIndexRequest._();

  RebuildCbirIndexRequest._();

  factory RebuildCbirIndexRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RebuildCbirIndexRequest()..mergeFromBuffer(data, registry);
  factory RebuildCbirIndexRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RebuildCbirIndexRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RebuildCbirIndexRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: RebuildCbirIndexRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RebuildCbirIndexRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RebuildCbirIndexRequest copyWith(
          void Function(RebuildCbirIndexRequest) updates) =>
      super.copyWith((message) => updates(message as RebuildCbirIndexRequest))
          as RebuildCbirIndexRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RebuildCbirIndexRequest() / RebuildCbirIndexRequest.new instead')
  static RebuildCbirIndexRequest create() => RebuildCbirIndexRequest._();
  static $pb.GeneratedMessage $_createMessage() => RebuildCbirIndexRequest._();
  @$core.override
  RebuildCbirIndexRequest createEmptyInstance() => RebuildCbirIndexRequest._();
  @$core.pragma('dart2js:noInline')
  static RebuildCbirIndexRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RebuildCbirIndexRequest>(
          RebuildCbirIndexRequest.$_createMessage);
  static RebuildCbirIndexRequest? _defaultInstance;
}

class AddToCbirIndexRequest extends $pb.GeneratedMessage {
  factory AddToCbirIndexRequest({
    $core.String? mediaId,
    $core.String? imageUrl,
    $core.String? type,
    $1.MetaData? metadata,
  }) {
    final result = AddToCbirIndexRequest._();
    if (mediaId != null) result.mediaId = mediaId;
    if (imageUrl != null) result.imageUrl = imageUrl;
    if (type != null) result.type = type;
    if (metadata != null) result.metadata = metadata;
    return result;
  }

  AddToCbirIndexRequest._();

  factory AddToCbirIndexRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AddToCbirIndexRequest()..mergeFromBuffer(data, registry);
  factory AddToCbirIndexRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AddToCbirIndexRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddToCbirIndexRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: AddToCbirIndexRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'mediaId')
    ..aOS(2, _omitFieldNames ? '' : 'imageUrl')
    ..aOS(3, _omitFieldNames ? '' : 'type')
    ..aOM<$1.MetaData>(4, _omitFieldNames ? '' : 'metadata',
        subBuilder: $1.MetaData.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddToCbirIndexRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddToCbirIndexRequest copyWith(
          void Function(AddToCbirIndexRequest) updates) =>
      super.copyWith((message) => updates(message as AddToCbirIndexRequest))
          as AddToCbirIndexRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use AddToCbirIndexRequest() / AddToCbirIndexRequest.new instead')
  static AddToCbirIndexRequest create() => AddToCbirIndexRequest._();
  static $pb.GeneratedMessage $_createMessage() => AddToCbirIndexRequest._();
  @$core.override
  AddToCbirIndexRequest createEmptyInstance() => AddToCbirIndexRequest._();
  @$core.pragma('dart2js:noInline')
  static AddToCbirIndexRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddToCbirIndexRequest>(
          AddToCbirIndexRequest.$_createMessage);
  static AddToCbirIndexRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mediaId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mediaId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMediaId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMediaId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get imageUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set imageUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasImageUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearImageUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get type => $_getSZ(2);
  @$pb.TagNumber(3)
  set type($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);

  @$pb.TagNumber(4)
  $1.MetaData get metadata => $_getN(3);
  @$pb.TagNumber(4)
  set metadata($1.MetaData value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMetadata() => $_has(3);
  @$pb.TagNumber(4)
  void clearMetadata() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.MetaData ensureMetadata() => $_ensure(3);
}

class RemoveFromCbirIndexRequest extends $pb.GeneratedMessage {
  factory RemoveFromCbirIndexRequest({
    $core.String? mediaId,
  }) {
    final result = RemoveFromCbirIndexRequest._();
    if (mediaId != null) result.mediaId = mediaId;
    return result;
  }

  RemoveFromCbirIndexRequest._();

  factory RemoveFromCbirIndexRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemoveFromCbirIndexRequest()..mergeFromBuffer(data, registry);
  factory RemoveFromCbirIndexRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemoveFromCbirIndexRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemoveFromCbirIndexRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: RemoveFromCbirIndexRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'mediaId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveFromCbirIndexRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveFromCbirIndexRequest copyWith(
          void Function(RemoveFromCbirIndexRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RemoveFromCbirIndexRequest))
          as RemoveFromCbirIndexRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RemoveFromCbirIndexRequest() / RemoveFromCbirIndexRequest.new instead')
  static RemoveFromCbirIndexRequest create() => RemoveFromCbirIndexRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      RemoveFromCbirIndexRequest._();
  @$core.override
  RemoveFromCbirIndexRequest createEmptyInstance() =>
      RemoveFromCbirIndexRequest._();
  @$core.pragma('dart2js:noInline')
  static RemoveFromCbirIndexRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemoveFromCbirIndexRequest>(
          RemoveFromCbirIndexRequest.$_createMessage);
  static RemoveFromCbirIndexRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mediaId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mediaId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMediaId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMediaId() => $_clearField(1);
}

class CbirIndexResult extends $pb.GeneratedMessage {
  factory CbirIndexResult({
    $core.bool? success,
    $core.String? message,
    $core.int? affectedCount,
    $core.double? processingTime,
  }) {
    final result = CbirIndexResult._();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    if (affectedCount != null) result.affectedCount = affectedCount;
    if (processingTime != null) result.processingTime = processingTime;
    return result;
  }

  CbirIndexResult._();

  factory CbirIndexResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CbirIndexResult()..mergeFromBuffer(data, registry);
  factory CbirIndexResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CbirIndexResult()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CbirIndexResult',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: CbirIndexResult.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aI(3, _omitFieldNames ? '' : 'affectedCount')
    ..aD(4, _omitFieldNames ? '' : 'processingTime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CbirIndexResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CbirIndexResult copyWith(void Function(CbirIndexResult) updates) =>
      super.copyWith((message) => updates(message as CbirIndexResult))
          as CbirIndexResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CbirIndexResult() / CbirIndexResult.new instead')
  static CbirIndexResult create() => CbirIndexResult._();
  static $pb.GeneratedMessage $_createMessage() => CbirIndexResult._();
  @$core.override
  CbirIndexResult createEmptyInstance() => CbirIndexResult._();
  @$core.pragma('dart2js:noInline')
  static CbirIndexResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CbirIndexResult>(
          CbirIndexResult.$_createMessage);
  static CbirIndexResult? _defaultInstance;

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

  @$pb.TagNumber(3)
  $core.int get affectedCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set affectedCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAffectedCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAffectedCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get processingTime => $_getN(3);
  @$pb.TagNumber(4)
  set processingTime($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasProcessingTime() => $_has(3);
  @$pb.TagNumber(4)
  void clearProcessingTime() => $_clearField(4);
}

/// Health
class HealthCheckRequest extends $pb.GeneratedMessage {
  factory HealthCheckRequest() => HealthCheckRequest._();

  HealthCheckRequest._();

  factory HealthCheckRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HealthCheckRequest()..mergeFromBuffer(data, registry);
  factory HealthCheckRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HealthCheckRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HealthCheckRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: HealthCheckRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HealthCheckRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HealthCheckRequest copyWith(void Function(HealthCheckRequest) updates) =>
      super.copyWith((message) => updates(message as HealthCheckRequest))
          as HealthCheckRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use HealthCheckRequest() / HealthCheckRequest.new instead')
  static HealthCheckRequest create() => HealthCheckRequest._();
  static $pb.GeneratedMessage $_createMessage() => HealthCheckRequest._();
  @$core.override
  HealthCheckRequest createEmptyInstance() => HealthCheckRequest._();
  @$core.pragma('dart2js:noInline')
  static HealthCheckRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HealthCheckRequest>(
          HealthCheckRequest.$_createMessage);
  static HealthCheckRequest? _defaultInstance;
}

class HealthCheckResponse extends $pb.GeneratedMessage {
  factory HealthCheckResponse({
    $core.bool? success,
    $core.String? message,
    CbirHealthData? data,
  }) {
    final result = HealthCheckResponse._();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    if (data != null) result.data = data;
    return result;
  }

  HealthCheckResponse._();

  factory HealthCheckResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HealthCheckResponse()..mergeFromBuffer(data, registry);
  factory HealthCheckResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HealthCheckResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HealthCheckResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: HealthCheckResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOM<CbirHealthData>(3, _omitFieldNames ? '' : 'data',
        subBuilder: CbirHealthData.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HealthCheckResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HealthCheckResponse copyWith(void Function(HealthCheckResponse) updates) =>
      super.copyWith((message) => updates(message as HealthCheckResponse))
          as HealthCheckResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use HealthCheckResponse() / HealthCheckResponse.new instead')
  static HealthCheckResponse create() => HealthCheckResponse._();
  static $pb.GeneratedMessage $_createMessage() => HealthCheckResponse._();
  @$core.override
  HealthCheckResponse createEmptyInstance() => HealthCheckResponse._();
  @$core.pragma('dart2js:noInline')
  static HealthCheckResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HealthCheckResponse>(
          HealthCheckResponse.$_createMessage);
  static HealthCheckResponse? _defaultInstance;

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

  @$pb.TagNumber(3)
  CbirHealthData get data => $_getN(2);
  @$pb.TagNumber(3)
  set data(CbirHealthData value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasData() => $_has(2);
  @$pb.TagNumber(3)
  void clearData() => $_clearField(3);
  @$pb.TagNumber(3)
  CbirHealthData ensureData() => $_ensure(2);
}

class CbirHealthData extends $pb.GeneratedMessage {
  factory CbirHealthData({
    $core.String? mode,
    $core.String? serverStatus,
    $core.String? version,
    $core.String? method,
    $core.String? metric,
    $core.Iterable<$core.String>? capabilities,
  }) {
    final result = CbirHealthData._();
    if (mode != null) result.mode = mode;
    if (serverStatus != null) result.serverStatus = serverStatus;
    if (version != null) result.version = version;
    if (method != null) result.method = method;
    if (metric != null) result.metric = metric;
    if (capabilities != null) result.capabilities.addAll(capabilities);
    return result;
  }

  CbirHealthData._();

  factory CbirHealthData.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CbirHealthData()..mergeFromBuffer(data, registry);
  factory CbirHealthData.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CbirHealthData()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CbirHealthData',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: CbirHealthData.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'mode')
    ..aOS(2, _omitFieldNames ? '' : 'serverStatus')
    ..aOS(3, _omitFieldNames ? '' : 'version')
    ..aOS(4, _omitFieldNames ? '' : 'method')
    ..aOS(5, _omitFieldNames ? '' : 'metric')
    ..pPS(6, _omitFieldNames ? '' : 'capabilities')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CbirHealthData clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CbirHealthData copyWith(void Function(CbirHealthData) updates) =>
      super.copyWith((message) => updates(message as CbirHealthData))
          as CbirHealthData;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CbirHealthData() / CbirHealthData.new instead')
  static CbirHealthData create() => CbirHealthData._();
  static $pb.GeneratedMessage $_createMessage() => CbirHealthData._();
  @$core.override
  CbirHealthData createEmptyInstance() => CbirHealthData._();
  @$core.pragma('dart2js:noInline')
  static CbirHealthData getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CbirHealthData>(
          CbirHealthData.$_createMessage);
  static CbirHealthData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mode => $_getSZ(0);
  @$pb.TagNumber(1)
  set mode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMode() => $_has(0);
  @$pb.TagNumber(1)
  void clearMode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get serverStatus => $_getSZ(1);
  @$pb.TagNumber(2)
  set serverStatus($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasServerStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearServerStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get version => $_getSZ(2);
  @$pb.TagNumber(3)
  set version($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersion() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get method => $_getSZ(3);
  @$pb.TagNumber(4)
  set method($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMethod() => $_has(3);
  @$pb.TagNumber(4)
  void clearMethod() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get metric => $_getSZ(4);
  @$pb.TagNumber(5)
  set metric($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMetric() => $_has(4);
  @$pb.TagNumber(5)
  void clearMetric() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get capabilities => $_getList(5);
}

/// Evaluate
class EvaluateRequest extends $pb.GeneratedMessage {
  factory EvaluateRequest() => EvaluateRequest._();

  EvaluateRequest._();

  factory EvaluateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EvaluateRequest()..mergeFromBuffer(data, registry);
  factory EvaluateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EvaluateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EvaluateRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: EvaluateRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvaluateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvaluateRequest copyWith(void Function(EvaluateRequest) updates) =>
      super.copyWith((message) => updates(message as EvaluateRequest))
          as EvaluateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use EvaluateRequest() / EvaluateRequest.new instead')
  static EvaluateRequest create() => EvaluateRequest._();
  static $pb.GeneratedMessage $_createMessage() => EvaluateRequest._();
  @$core.override
  EvaluateRequest createEmptyInstance() => EvaluateRequest._();
  @$core.pragma('dart2js:noInline')
  static EvaluateRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EvaluateRequest>(
          EvaluateRequest.$_createMessage);
  static EvaluateRequest? _defaultInstance;
}

class EvaluateResponse extends $pb.GeneratedMessage {
  factory EvaluateResponse({
    $core.bool? success,
    $core.String? message,
    $core.Iterable<EvaluateMetric>? metrics,
  }) {
    final result = EvaluateResponse._();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    if (metrics != null) result.metrics.addAll(metrics);
    return result;
  }

  EvaluateResponse._();

  factory EvaluateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EvaluateResponse()..mergeFromBuffer(data, registry);
  factory EvaluateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EvaluateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EvaluateResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: EvaluateResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..pPM<EvaluateMetric>(3, _omitFieldNames ? '' : 'metrics',
        subBuilder: EvaluateMetric.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvaluateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvaluateResponse copyWith(void Function(EvaluateResponse) updates) =>
      super.copyWith((message) => updates(message as EvaluateResponse))
          as EvaluateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use EvaluateResponse() / EvaluateResponse.new instead')
  static EvaluateResponse create() => EvaluateResponse._();
  static $pb.GeneratedMessage $_createMessage() => EvaluateResponse._();
  @$core.override
  EvaluateResponse createEmptyInstance() => EvaluateResponse._();
  @$core.pragma('dart2js:noInline')
  static EvaluateResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EvaluateResponse>(
          EvaluateResponse.$_createMessage);
  static EvaluateResponse? _defaultInstance;

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

  @$pb.TagNumber(3)
  $pb.PbList<EvaluateMetric> get metrics => $_getList(2);
}

class EvaluateMetric extends $pb.GeneratedMessage {
  factory EvaluateMetric({
    $core.String? name,
    $core.double? value,
    $core.String? description,
  }) {
    final result = EvaluateMetric._();
    if (name != null) result.name = name;
    if (value != null) result.value = value;
    if (description != null) result.description = description;
    return result;
  }

  EvaluateMetric._();

  factory EvaluateMetric.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EvaluateMetric()..mergeFromBuffer(data, registry);
  factory EvaluateMetric.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EvaluateMetric()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EvaluateMetric',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: EvaluateMetric.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aD(2, _omitFieldNames ? '' : 'value')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvaluateMetric clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvaluateMetric copyWith(void Function(EvaluateMetric) updates) =>
      super.copyWith((message) => updates(message as EvaluateMetric))
          as EvaluateMetric;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use EvaluateMetric() / EvaluateMetric.new instead')
  static EvaluateMetric create() => EvaluateMetric._();
  static $pb.GeneratedMessage $_createMessage() => EvaluateMetric._();
  @$core.override
  EvaluateMetric createEmptyInstance() => EvaluateMetric._();
  @$core.pragma('dart2js:noInline')
  static EvaluateMetric getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EvaluateMetric>(
          EvaluateMetric.$_createMessage);
  static EvaluateMetric? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get value => $_getN(1);
  @$pb.TagNumber(2)
  set value($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);
}

/// Result types
class CbirResult extends $pb.GeneratedMessage {
  factory CbirResult({
    $core.String? type,
    $core.double? similarity,
    $core.double? score,
    CbirResultData? data,
  }) {
    final result = CbirResult._();
    if (type != null) result.type = type;
    if (similarity != null) result.similarity = similarity;
    if (score != null) result.score = score;
    if (data != null) result.data = data;
    return result;
  }

  CbirResult._();

  factory CbirResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CbirResult()..mergeFromBuffer(data, registry);
  factory CbirResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CbirResult()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CbirResult',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: CbirResult.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'type')
    ..aD(2, _omitFieldNames ? '' : 'similarity')
    ..aD(3, _omitFieldNames ? '' : 'score')
    ..aOM<CbirResultData>(4, _omitFieldNames ? '' : 'data',
        subBuilder: CbirResultData.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CbirResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CbirResult copyWith(void Function(CbirResult) updates) =>
      super.copyWith((message) => updates(message as CbirResult)) as CbirResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CbirResult() / CbirResult.new instead')
  static CbirResult create() => CbirResult._();
  static $pb.GeneratedMessage $_createMessage() => CbirResult._();
  @$core.override
  CbirResult createEmptyInstance() => CbirResult._();
  @$core.pragma('dart2js:noInline')
  static CbirResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CbirResult>(CbirResult.$_createMessage);
  static CbirResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get type => $_getSZ(0);
  @$pb.TagNumber(1)
  set type($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get similarity => $_getN(1);
  @$pb.TagNumber(2)
  set similarity($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSimilarity() => $_has(1);
  @$pb.TagNumber(2)
  void clearSimilarity() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get score => $_getN(2);
  @$pb.TagNumber(3)
  set score($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasScore() => $_has(2);
  @$pb.TagNumber(3)
  void clearScore() => $_clearField(3);

  @$pb.TagNumber(4)
  CbirResultData get data => $_getN(3);
  @$pb.TagNumber(4)
  set data(CbirResultData value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasData() => $_has(3);
  @$pb.TagNumber(4)
  void clearData() => $_clearField(4);
  @$pb.TagNumber(4)
  CbirResultData ensureData() => $_ensure(3);
}

class CbirResultData extends $pb.GeneratedMessage {
  factory CbirResultData({
    $core.String? id,
    $core.String? name,
    $core.String? slug,
    $core.String? description,
    $core.double? price,
    $core.double? discountPrice,
    $core.double? finalPrice,
    $core.String? imageUrl,
    $core.String? category,
    $2.Category? categoryObj,
    $core.bool? isAvailable,
  }) {
    final result = CbirResultData._();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (slug != null) result.slug = slug;
    if (description != null) result.description = description;
    if (price != null) result.price = price;
    if (discountPrice != null) result.discountPrice = discountPrice;
    if (finalPrice != null) result.finalPrice = finalPrice;
    if (imageUrl != null) result.imageUrl = imageUrl;
    if (category != null) result.category = category;
    if (categoryObj != null) result.categoryObj = categoryObj;
    if (isAvailable != null) result.isAvailable = isAvailable;
    return result;
  }

  CbirResultData._();

  factory CbirResultData.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CbirResultData()..mergeFromBuffer(data, registry);
  factory CbirResultData.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CbirResultData()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CbirResultData',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: CbirResultData.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'slug')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aD(5, _omitFieldNames ? '' : 'price')
    ..aD(6, _omitFieldNames ? '' : 'discountPrice')
    ..aD(7, _omitFieldNames ? '' : 'finalPrice')
    ..aOS(8, _omitFieldNames ? '' : 'imageUrl')
    ..aOS(9, _omitFieldNames ? '' : 'category')
    ..aOM<$2.Category>(10, _omitFieldNames ? '' : 'categoryObj',
        subBuilder: $2.Category.$_createMessage)
    ..aOB(11, _omitFieldNames ? '' : 'isAvailable')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CbirResultData clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CbirResultData copyWith(void Function(CbirResultData) updates) =>
      super.copyWith((message) => updates(message as CbirResultData))
          as CbirResultData;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CbirResultData() / CbirResultData.new instead')
  static CbirResultData create() => CbirResultData._();
  static $pb.GeneratedMessage $_createMessage() => CbirResultData._();
  @$core.override
  CbirResultData createEmptyInstance() => CbirResultData._();
  @$core.pragma('dart2js:noInline')
  static CbirResultData getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CbirResultData>(
          CbirResultData.$_createMessage);
  static CbirResultData? _defaultInstance;

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
  $core.String get imageUrl => $_getSZ(7);
  @$pb.TagNumber(8)
  set imageUrl($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasImageUrl() => $_has(7);
  @$pb.TagNumber(8)
  void clearImageUrl() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get category => $_getSZ(8);
  @$pb.TagNumber(9)
  set category($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCategory() => $_has(8);
  @$pb.TagNumber(9)
  void clearCategory() => $_clearField(9);

  @$pb.TagNumber(10)
  $2.Category get categoryObj => $_getN(9);
  @$pb.TagNumber(10)
  set categoryObj($2.Category value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasCategoryObj() => $_has(9);
  @$pb.TagNumber(10)
  void clearCategoryObj() => $_clearField(10);
  @$pb.TagNumber(10)
  $2.Category ensureCategoryObj() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.bool get isAvailable => $_getBF(10);
  @$pb.TagNumber(11)
  set isAvailable($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasIsAvailable() => $_has(10);
  @$pb.TagNumber(11)
  void clearIsAvailable() => $_clearField(11);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
