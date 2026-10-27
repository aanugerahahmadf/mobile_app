// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/search.proto.

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

class SearchRequest extends $pb.GeneratedMessage {
  factory SearchRequest({
    $core.String? query,
    $1.SearchType? type,
    $1.PaginationRequest? pagination,
  }) {
    final result = SearchRequest._();
    if (query != null) result.query = query;
    if (type != null) result.type = type;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  SearchRequest._();

  factory SearchRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchRequest()..mergeFromBuffer(data, registry);
  factory SearchRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: SearchRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'query')
    ..aE<$1.SearchType>(2, _omitFieldNames ? '' : 'type',
        enumValues: $1.SearchType.values)
    ..aOM<$1.PaginationRequest>(3, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginationRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchRequest copyWith(void Function(SearchRequest) updates) =>
      super.copyWith((message) => updates(message as SearchRequest))
          as SearchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SearchRequest() / SearchRequest.new instead')
  static SearchRequest create() => SearchRequest._();
  static $pb.GeneratedMessage $_createMessage() => SearchRequest._();
  @$core.override
  SearchRequest createEmptyInstance() => SearchRequest._();
  @$core.pragma('dart2js:noInline')
  static SearchRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SearchRequest>(
          SearchRequest.$_createMessage);
  static SearchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get query => $_getSZ(0);
  @$pb.TagNumber(1)
  set query($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQuery() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuery() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.SearchType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type($1.SearchType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.PaginationRequest get pagination => $_getN(2);
  @$pb.TagNumber(3)
  set pagination($1.PaginationRequest value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPagination() => $_has(2);
  @$pb.TagNumber(3)
  void clearPagination() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.PaginationRequest ensurePagination() => $_ensure(2);
}

class SearchResponse extends $pb.GeneratedMessage {
  factory SearchResponse({
    $core.Iterable<SearchResult>? results,
    $1.PaginationResponse? pagination,
    $core.double? took,
  }) {
    final result = SearchResponse._();
    if (results != null) result.results.addAll(results);
    if (pagination != null) result.pagination = pagination;
    if (took != null) result.took = took;
    return result;
  }

  SearchResponse._();

  factory SearchResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchResponse()..mergeFromBuffer(data, registry);
  factory SearchResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: SearchResponse.$_createMessage)
    ..pPM<SearchResult>(1, _omitFieldNames ? '' : 'results',
        subBuilder: SearchResult.$_createMessage)
    ..aOM<$1.PaginationResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginationResponse.$_createMessage)
    ..aD(3, _omitFieldNames ? '' : 'took')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchResponse copyWith(void Function(SearchResponse) updates) =>
      super.copyWith((message) => updates(message as SearchResponse))
          as SearchResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SearchResponse() / SearchResponse.new instead')
  static SearchResponse create() => SearchResponse._();
  static $pb.GeneratedMessage $_createMessage() => SearchResponse._();
  @$core.override
  SearchResponse createEmptyInstance() => SearchResponse._();
  @$core.pragma('dart2js:noInline')
  static SearchResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SearchResponse>(
          SearchResponse.$_createMessage);
  static SearchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SearchResult> get results => $_getList(0);

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

  @$pb.TagNumber(3)
  $core.double get took => $_getN(2);
  @$pb.TagNumber(3)
  set took($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTook() => $_has(2);
  @$pb.TagNumber(3)
  void clearTook() => $_clearField(3);
}

class GetSuggestionsRequest extends $pb.GeneratedMessage {
  factory GetSuggestionsRequest({
    $core.String? query,
    $core.int? limit,
  }) {
    final result = GetSuggestionsRequest._();
    if (query != null) result.query = query;
    if (limit != null) result.limit = limit;
    return result;
  }

  GetSuggestionsRequest._();

  factory GetSuggestionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSuggestionsRequest()..mergeFromBuffer(data, registry);
  factory GetSuggestionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSuggestionsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSuggestionsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetSuggestionsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'query')
    ..aI(2, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSuggestionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSuggestionsRequest copyWith(
          void Function(GetSuggestionsRequest) updates) =>
      super.copyWith((message) => updates(message as GetSuggestionsRequest))
          as GetSuggestionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetSuggestionsRequest() / GetSuggestionsRequest.new instead')
  static GetSuggestionsRequest create() => GetSuggestionsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetSuggestionsRequest._();
  @$core.override
  GetSuggestionsRequest createEmptyInstance() => GetSuggestionsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetSuggestionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSuggestionsRequest>(
          GetSuggestionsRequest.$_createMessage);
  static GetSuggestionsRequest? _defaultInstance;

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

class SearchSuggestionsResponse extends $pb.GeneratedMessage {
  factory SearchSuggestionsResponse({
    $core.Iterable<SearchSuggestion>? suggestions,
  }) {
    final result = SearchSuggestionsResponse._();
    if (suggestions != null) result.suggestions.addAll(suggestions);
    return result;
  }

  SearchSuggestionsResponse._();

  factory SearchSuggestionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchSuggestionsResponse()..mergeFromBuffer(data, registry);
  factory SearchSuggestionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchSuggestionsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchSuggestionsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: SearchSuggestionsResponse.$_createMessage)
    ..pPM<SearchSuggestion>(1, _omitFieldNames ? '' : 'suggestions',
        subBuilder: SearchSuggestion.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchSuggestionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchSuggestionsResponse copyWith(
          void Function(SearchSuggestionsResponse) updates) =>
      super.copyWith((message) => updates(message as SearchSuggestionsResponse))
          as SearchSuggestionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SearchSuggestionsResponse() / SearchSuggestionsResponse.new instead')
  static SearchSuggestionsResponse create() => SearchSuggestionsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SearchSuggestionsResponse._();
  @$core.override
  SearchSuggestionsResponse createEmptyInstance() =>
      SearchSuggestionsResponse._();
  @$core.pragma('dart2js:noInline')
  static SearchSuggestionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchSuggestionsResponse>(
          SearchSuggestionsResponse.$_createMessage);
  static SearchSuggestionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SearchSuggestion> get suggestions => $_getList(0);
}

class GetPopularSearchesRequest extends $pb.GeneratedMessage {
  factory GetPopularSearchesRequest({
    $core.int? limit,
  }) {
    final result = GetPopularSearchesRequest._();
    if (limit != null) result.limit = limit;
    return result;
  }

  GetPopularSearchesRequest._();

  factory GetPopularSearchesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPopularSearchesRequest()..mergeFromBuffer(data, registry);
  factory GetPopularSearchesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPopularSearchesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPopularSearchesRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetPopularSearchesRequest.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPopularSearchesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPopularSearchesRequest copyWith(
          void Function(GetPopularSearchesRequest) updates) =>
      super.copyWith((message) => updates(message as GetPopularSearchesRequest))
          as GetPopularSearchesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPopularSearchesRequest() / GetPopularSearchesRequest.new instead')
  static GetPopularSearchesRequest create() => GetPopularSearchesRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetPopularSearchesRequest._();
  @$core.override
  GetPopularSearchesRequest createEmptyInstance() =>
      GetPopularSearchesRequest._();
  @$core.pragma('dart2js:noInline')
  static GetPopularSearchesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPopularSearchesRequest>(
          GetPopularSearchesRequest.$_createMessage);
  static GetPopularSearchesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get limit => $_getIZ(0);
  @$pb.TagNumber(1)
  set limit($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLimit() => $_has(0);
  @$pb.TagNumber(1)
  void clearLimit() => $_clearField(1);
}

class PopularSearchesResponse extends $pb.GeneratedMessage {
  factory PopularSearchesResponse({
    $core.Iterable<PopularSearch>? searches,
  }) {
    final result = PopularSearchesResponse._();
    if (searches != null) result.searches.addAll(searches);
    return result;
  }

  PopularSearchesResponse._();

  factory PopularSearchesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PopularSearchesResponse()..mergeFromBuffer(data, registry);
  factory PopularSearchesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PopularSearchesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PopularSearchesResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: PopularSearchesResponse.$_createMessage)
    ..pPM<PopularSearch>(1, _omitFieldNames ? '' : 'searches',
        subBuilder: PopularSearch.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PopularSearchesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PopularSearchesResponse copyWith(
          void Function(PopularSearchesResponse) updates) =>
      super.copyWith((message) => updates(message as PopularSearchesResponse))
          as PopularSearchesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PopularSearchesResponse() / PopularSearchesResponse.new instead')
  static PopularSearchesResponse create() => PopularSearchesResponse._();
  static $pb.GeneratedMessage $_createMessage() => PopularSearchesResponse._();
  @$core.override
  PopularSearchesResponse createEmptyInstance() => PopularSearchesResponse._();
  @$core.pragma('dart2js:noInline')
  static PopularSearchesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PopularSearchesResponse>(
          PopularSearchesResponse.$_createMessage);
  static PopularSearchesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PopularSearch> get searches => $_getList(0);
}

class GetFiltersRequest extends $pb.GeneratedMessage {
  factory GetFiltersRequest({
    $core.String? query,
    $core.String? categoryId,
  }) {
    final result = GetFiltersRequest._();
    if (query != null) result.query = query;
    if (categoryId != null) result.categoryId = categoryId;
    return result;
  }

  GetFiltersRequest._();

  factory GetFiltersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetFiltersRequest()..mergeFromBuffer(data, registry);
  factory GetFiltersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetFiltersRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFiltersRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetFiltersRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'query')
    ..aOS(2, _omitFieldNames ? '' : 'categoryId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFiltersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFiltersRequest copyWith(void Function(GetFiltersRequest) updates) =>
      super.copyWith((message) => updates(message as GetFiltersRequest))
          as GetFiltersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetFiltersRequest() / GetFiltersRequest.new instead')
  static GetFiltersRequest create() => GetFiltersRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetFiltersRequest._();
  @$core.override
  GetFiltersRequest createEmptyInstance() => GetFiltersRequest._();
  @$core.pragma('dart2js:noInline')
  static GetFiltersRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetFiltersRequest>(
          GetFiltersRequest.$_createMessage);
  static GetFiltersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get query => $_getSZ(0);
  @$pb.TagNumber(1)
  set query($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQuery() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuery() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get categoryId => $_getSZ(1);
  @$pb.TagNumber(2)
  set categoryId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCategoryId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCategoryId() => $_clearField(2);
}

class SearchFiltersResponse extends $pb.GeneratedMessage {
  factory SearchFiltersResponse({
    SearchFilters? filters,
  }) {
    final result = SearchFiltersResponse._();
    if (filters != null) result.filters = filters;
    return result;
  }

  SearchFiltersResponse._();

  factory SearchFiltersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchFiltersResponse()..mergeFromBuffer(data, registry);
  factory SearchFiltersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchFiltersResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchFiltersResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: SearchFiltersResponse.$_createMessage)
    ..aOM<SearchFilters>(1, _omitFieldNames ? '' : 'filters',
        subBuilder: SearchFilters.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchFiltersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchFiltersResponse copyWith(
          void Function(SearchFiltersResponse) updates) =>
      super.copyWith((message) => updates(message as SearchFiltersResponse))
          as SearchFiltersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SearchFiltersResponse() / SearchFiltersResponse.new instead')
  static SearchFiltersResponse create() => SearchFiltersResponse._();
  static $pb.GeneratedMessage $_createMessage() => SearchFiltersResponse._();
  @$core.override
  SearchFiltersResponse createEmptyInstance() => SearchFiltersResponse._();
  @$core.pragma('dart2js:noInline')
  static SearchFiltersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchFiltersResponse>(
          SearchFiltersResponse.$_createMessage);
  static SearchFiltersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SearchFilters get filters => $_getN(0);
  @$pb.TagNumber(1)
  set filters(SearchFilters value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFilters() => $_has(0);
  @$pb.TagNumber(1)
  void clearFilters() => $_clearField(1);
  @$pb.TagNumber(1)
  SearchFilters ensureFilters() => $_ensure(0);
}

class SearchResult extends $pb.GeneratedMessage {
  factory SearchResult({
    $core.String? id,
    $core.String? type,
    $core.String? name,
    $core.String? slug,
    $core.double? price,
    $core.String? imageUrl,
    $core.String? category,
  }) {
    final result = SearchResult._();
    if (id != null) result.id = id;
    if (type != null) result.type = type;
    if (name != null) result.name = name;
    if (slug != null) result.slug = slug;
    if (price != null) result.price = price;
    if (imageUrl != null) result.imageUrl = imageUrl;
    if (category != null) result.category = category;
    return result;
  }

  SearchResult._();

  factory SearchResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchResult()..mergeFromBuffer(data, registry);
  factory SearchResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchResult()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchResult',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: SearchResult.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'type')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'slug')
    ..aD(5, _omitFieldNames ? '' : 'price')
    ..aOS(6, _omitFieldNames ? '' : 'imageUrl')
    ..aOS(7, _omitFieldNames ? '' : 'category')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchResult copyWith(void Function(SearchResult) updates) =>
      super.copyWith((message) => updates(message as SearchResult))
          as SearchResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SearchResult() / SearchResult.new instead')
  static SearchResult create() => SearchResult._();
  static $pb.GeneratedMessage $_createMessage() => SearchResult._();
  @$core.override
  SearchResult createEmptyInstance() => SearchResult._();
  @$core.pragma('dart2js:noInline')
  static SearchResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SearchResult>(
          SearchResult.$_createMessage);
  static SearchResult? _defaultInstance;

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
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get slug => $_getSZ(3);
  @$pb.TagNumber(4)
  set slug($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSlug() => $_has(3);
  @$pb.TagNumber(4)
  void clearSlug() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get price => $_getN(4);
  @$pb.TagNumber(5)
  set price($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPrice() => $_has(4);
  @$pb.TagNumber(5)
  void clearPrice() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get imageUrl => $_getSZ(5);
  @$pb.TagNumber(6)
  set imageUrl($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasImageUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearImageUrl() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get category => $_getSZ(6);
  @$pb.TagNumber(7)
  set category($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCategory() => $_has(6);
  @$pb.TagNumber(7)
  void clearCategory() => $_clearField(7);
}

class SearchSuggestion extends $pb.GeneratedMessage {
  factory SearchSuggestion({
    $core.String? text,
    $1.SearchSuggestionType? type,
    $core.int? count,
    $core.String? imageUrl,
  }) {
    final result = SearchSuggestion._();
    if (text != null) result.text = text;
    if (type != null) result.type = type;
    if (count != null) result.count = count;
    if (imageUrl != null) result.imageUrl = imageUrl;
    return result;
  }

  SearchSuggestion._();

  factory SearchSuggestion.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchSuggestion()..mergeFromBuffer(data, registry);
  factory SearchSuggestion.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchSuggestion()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchSuggestion',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: SearchSuggestion.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aE<$1.SearchSuggestionType>(2, _omitFieldNames ? '' : 'type',
        enumValues: $1.SearchSuggestionType.values)
    ..aI(3, _omitFieldNames ? '' : 'count')
    ..aOS(4, _omitFieldNames ? '' : 'imageUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchSuggestion clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchSuggestion copyWith(void Function(SearchSuggestion) updates) =>
      super.copyWith((message) => updates(message as SearchSuggestion))
          as SearchSuggestion;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SearchSuggestion() / SearchSuggestion.new instead')
  static SearchSuggestion create() => SearchSuggestion._();
  static $pb.GeneratedMessage $_createMessage() => SearchSuggestion._();
  @$core.override
  SearchSuggestion createEmptyInstance() => SearchSuggestion._();
  @$core.pragma('dart2js:noInline')
  static SearchSuggestion getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SearchSuggestion>(
          SearchSuggestion.$_createMessage);
  static SearchSuggestion? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.SearchSuggestionType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type($1.SearchSuggestionType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get count => $_getIZ(2);
  @$pb.TagNumber(3)
  set count($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get imageUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set imageUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasImageUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearImageUrl() => $_clearField(4);
}

class PopularSearch extends $pb.GeneratedMessage {
  factory PopularSearch({
    $core.String? query,
    $core.int? count,
    $core.String? trend,
  }) {
    final result = PopularSearch._();
    if (query != null) result.query = query;
    if (count != null) result.count = count;
    if (trend != null) result.trend = trend;
    return result;
  }

  PopularSearch._();

  factory PopularSearch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PopularSearch()..mergeFromBuffer(data, registry);
  factory PopularSearch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PopularSearch()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PopularSearch',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: PopularSearch.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'query')
    ..aI(2, _omitFieldNames ? '' : 'count')
    ..aOS(3, _omitFieldNames ? '' : 'trend')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PopularSearch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PopularSearch copyWith(void Function(PopularSearch) updates) =>
      super.copyWith((message) => updates(message as PopularSearch))
          as PopularSearch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PopularSearch() / PopularSearch.new instead')
  static PopularSearch create() => PopularSearch._();
  static $pb.GeneratedMessage $_createMessage() => PopularSearch._();
  @$core.override
  PopularSearch createEmptyInstance() => PopularSearch._();
  @$core.pragma('dart2js:noInline')
  static PopularSearch getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PopularSearch>(
          PopularSearch.$_createMessage);
  static PopularSearch? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get query => $_getSZ(0);
  @$pb.TagNumber(1)
  set query($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQuery() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuery() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get count => $_getIZ(1);
  @$pb.TagNumber(2)
  set count($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get trend => $_getSZ(2);
  @$pb.TagNumber(3)
  set trend($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTrend() => $_has(2);
  @$pb.TagNumber(3)
  void clearTrend() => $_clearField(3);
}

class SearchFilters extends $pb.GeneratedMessage {
  factory SearchFilters({
    $core.Iterable<CategoryFilter>? categories,
    $1.PriceRange? priceRange,
    $core.Iterable<$core.String>? themes,
    $core.Iterable<$core.String>? colors,
    $core.int? minCapacity,
    $core.int? maxCapacity,
  }) {
    final result = SearchFilters._();
    if (categories != null) result.categories.addAll(categories);
    if (priceRange != null) result.priceRange = priceRange;
    if (themes != null) result.themes.addAll(themes);
    if (colors != null) result.colors.addAll(colors);
    if (minCapacity != null) result.minCapacity = minCapacity;
    if (maxCapacity != null) result.maxCapacity = maxCapacity;
    return result;
  }

  SearchFilters._();

  factory SearchFilters.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchFilters()..mergeFromBuffer(data, registry);
  factory SearchFilters.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchFilters()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchFilters',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: SearchFilters.$_createMessage)
    ..pPM<CategoryFilter>(1, _omitFieldNames ? '' : 'categories',
        subBuilder: CategoryFilter.$_createMessage)
    ..aOM<$1.PriceRange>(2, _omitFieldNames ? '' : 'priceRange',
        subBuilder: $1.PriceRange.$_createMessage)
    ..pPS(3, _omitFieldNames ? '' : 'themes')
    ..pPS(4, _omitFieldNames ? '' : 'colors')
    ..aI(5, _omitFieldNames ? '' : 'minCapacity')
    ..aI(6, _omitFieldNames ? '' : 'maxCapacity')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchFilters clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchFilters copyWith(void Function(SearchFilters) updates) =>
      super.copyWith((message) => updates(message as SearchFilters))
          as SearchFilters;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SearchFilters() / SearchFilters.new instead')
  static SearchFilters create() => SearchFilters._();
  static $pb.GeneratedMessage $_createMessage() => SearchFilters._();
  @$core.override
  SearchFilters createEmptyInstance() => SearchFilters._();
  @$core.pragma('dart2js:noInline')
  static SearchFilters getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SearchFilters>(
          SearchFilters.$_createMessage);
  static SearchFilters? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CategoryFilter> get categories => $_getList(0);

  @$pb.TagNumber(2)
  $1.PriceRange get priceRange => $_getN(1);
  @$pb.TagNumber(2)
  set priceRange($1.PriceRange value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPriceRange() => $_has(1);
  @$pb.TagNumber(2)
  void clearPriceRange() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.PriceRange ensurePriceRange() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get themes => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get colors => $_getList(3);

  @$pb.TagNumber(5)
  $core.int get minCapacity => $_getIZ(4);
  @$pb.TagNumber(5)
  set minCapacity($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMinCapacity() => $_has(4);
  @$pb.TagNumber(5)
  void clearMinCapacity() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get maxCapacity => $_getIZ(5);
  @$pb.TagNumber(6)
  set maxCapacity($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMaxCapacity() => $_has(5);
  @$pb.TagNumber(6)
  void clearMaxCapacity() => $_clearField(6);
}

class CategoryFilter extends $pb.GeneratedMessage {
  factory CategoryFilter({
    $2.Category? category,
    $core.int? count,
  }) {
    final result = CategoryFilter._();
    if (category != null) result.category = category;
    if (count != null) result.count = count;
    return result;
  }

  CategoryFilter._();

  factory CategoryFilter.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CategoryFilter()..mergeFromBuffer(data, registry);
  factory CategoryFilter.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CategoryFilter()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CategoryFilter',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: CategoryFilter.$_createMessage)
    ..aOM<$2.Category>(1, _omitFieldNames ? '' : 'category',
        subBuilder: $2.Category.$_createMessage)
    ..aI(2, _omitFieldNames ? '' : 'count')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CategoryFilter clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CategoryFilter copyWith(void Function(CategoryFilter) updates) =>
      super.copyWith((message) => updates(message as CategoryFilter))
          as CategoryFilter;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CategoryFilter() / CategoryFilter.new instead')
  static CategoryFilter create() => CategoryFilter._();
  static $pb.GeneratedMessage $_createMessage() => CategoryFilter._();
  @$core.override
  CategoryFilter createEmptyInstance() => CategoryFilter._();
  @$core.pragma('dart2js:noInline')
  static CategoryFilter getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CategoryFilter>(
          CategoryFilter.$_createMessage);
  static CategoryFilter? _defaultInstance;

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

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
