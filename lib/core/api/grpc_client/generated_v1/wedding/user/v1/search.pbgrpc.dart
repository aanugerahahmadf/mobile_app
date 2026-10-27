// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/search.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'search.pb.dart' as $0;

export 'search.pb.dart';

/// Search Service
@$pb.GrpcServiceName('wedding.user.v1.SearchService')
class SearchServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  SearchServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.SearchResponse> search(
    $0.SearchRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$search, request, options: options);
  }

  $grpc.ResponseFuture<$0.SearchSuggestionsResponse> getSuggestions(
    $0.GetSuggestionsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSuggestions, request, options: options);
  }

  $grpc.ResponseFuture<$0.PopularSearchesResponse> getPopularSearches(
    $0.GetPopularSearchesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPopularSearches, request, options: options);
  }

  $grpc.ResponseFuture<$0.SearchFiltersResponse> getFilters(
    $0.GetFiltersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getFilters, request, options: options);
  }

  // method descriptors

  static final _$search =
      $grpc.ClientMethod<$0.SearchRequest, $0.SearchResponse>(
          '/wedding.user.v1.SearchService/Search',
          ($0.SearchRequest value) => value.writeToBuffer(),
          $0.SearchResponse.fromBuffer);
  static final _$getSuggestions = $grpc.ClientMethod<$0.GetSuggestionsRequest,
          $0.SearchSuggestionsResponse>(
      '/wedding.user.v1.SearchService/GetSuggestions',
      ($0.GetSuggestionsRequest value) => value.writeToBuffer(),
      $0.SearchSuggestionsResponse.fromBuffer);
  static final _$getPopularSearches = $grpc.ClientMethod<
          $0.GetPopularSearchesRequest, $0.PopularSearchesResponse>(
      '/wedding.user.v1.SearchService/GetPopularSearches',
      ($0.GetPopularSearchesRequest value) => value.writeToBuffer(),
      $0.PopularSearchesResponse.fromBuffer);
  static final _$getFilters =
      $grpc.ClientMethod<$0.GetFiltersRequest, $0.SearchFiltersResponse>(
          '/wedding.user.v1.SearchService/GetFilters',
          ($0.GetFiltersRequest value) => value.writeToBuffer(),
          $0.SearchFiltersResponse.fromBuffer);
}

@$pb.GrpcServiceName('wedding.user.v1.SearchService')
abstract class SearchServiceBase extends $grpc.Service {
  $core.String get $name => 'wedding.user.v1.SearchService';

  SearchServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.SearchRequest, $0.SearchResponse>(
        'Search',
        search_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SearchRequest.fromBuffer(value),
        ($0.SearchResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetSuggestionsRequest,
            $0.SearchSuggestionsResponse>(
        'GetSuggestions',
        getSuggestions_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetSuggestionsRequest.fromBuffer(value),
        ($0.SearchSuggestionsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetPopularSearchesRequest,
            $0.PopularSearchesResponse>(
        'GetPopularSearches',
        getPopularSearches_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetPopularSearchesRequest.fromBuffer(value),
        ($0.PopularSearchesResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetFiltersRequest, $0.SearchFiltersResponse>(
            'GetFilters',
            getFilters_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetFiltersRequest.fromBuffer(value),
            ($0.SearchFiltersResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.SearchResponse> search_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.SearchRequest> $request) async {
    return search($call, await $request);
  }

  $async.Future<$0.SearchResponse> search(
      $grpc.ServiceCall call, $0.SearchRequest request);

  $async.Future<$0.SearchSuggestionsResponse> getSuggestions_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetSuggestionsRequest> $request) async {
    return getSuggestions($call, await $request);
  }

  $async.Future<$0.SearchSuggestionsResponse> getSuggestions(
      $grpc.ServiceCall call, $0.GetSuggestionsRequest request);

  $async.Future<$0.PopularSearchesResponse> getPopularSearches_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetPopularSearchesRequest> $request) async {
    return getPopularSearches($call, await $request);
  }

  $async.Future<$0.PopularSearchesResponse> getPopularSearches(
      $grpc.ServiceCall call, $0.GetPopularSearchesRequest request);

  $async.Future<$0.SearchFiltersResponse> getFilters_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetFiltersRequest> $request) async {
    return getFilters($call, await $request);
  }

  $async.Future<$0.SearchFiltersResponse> getFilters(
      $grpc.ServiceCall call, $0.GetFiltersRequest request);
}
