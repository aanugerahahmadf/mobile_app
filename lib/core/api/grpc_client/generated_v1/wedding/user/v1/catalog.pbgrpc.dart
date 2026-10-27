// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/catalog.proto.

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

import 'catalog.pb.dart' as $0;

export 'catalog.pb.dart';

/// Catalog Service
@$pb.GrpcServiceName('wedding.user.v1.CatalogService')
class CatalogServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  CatalogServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.Catalog> getCatalog(
    $0.GetCatalogRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getCatalog, request, options: options);
  }

  $grpc.ResponseFuture<$0.Catalog> getCatalogBySlug(
    $0.GetCatalogBySlugRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getCatalogBySlug, request, options: options);
  }

  $grpc.ResponseFuture<$0.CatalogListResponse> listCatalogs(
    $0.ListCatalogsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listCatalogs, request, options: options);
  }

  $grpc.ResponseFuture<$0.CatalogListResponse> getFeaturedCatalogs(
    $0.GetFeaturedCatalogsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getFeaturedCatalogs, request, options: options);
  }

  $grpc.ResponseFuture<$0.CatalogListResponse> getOnSaleCatalogs(
    $0.GetOnSaleCatalogsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getOnSaleCatalogs, request, options: options);
  }

  $grpc.ResponseFuture<$0.CatalogListResponse> getCatalogsByCategory(
    $0.GetCatalogsByCategoryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getCatalogsByCategory, request, options: options);
  }

  $grpc.ResponseFuture<$0.CatalogListResponse> getRelatedCatalogs(
    $0.GetRelatedCatalogsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRelatedCatalogs, request, options: options);
  }

  $grpc.ResponseFuture<$0.CatalogListResponse> searchCatalogs(
    $0.SearchCatalogsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$searchCatalogs, request, options: options);
  }

  $grpc.ResponseFuture<$0.CatalogTiersResponse> getCatalogTiers(
    $0.GetCatalogTiersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getCatalogTiers, request, options: options);
  }

  $grpc.ResponseFuture<$0.CatalogStats> getCatalogStats(
    $0.GetCatalogStatsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getCatalogStats, request, options: options);
  }

  // method descriptors

  static final _$getCatalog =
      $grpc.ClientMethod<$0.GetCatalogRequest, $0.Catalog>(
          '/wedding.user.v1.CatalogService/GetCatalog',
          ($0.GetCatalogRequest value) => value.writeToBuffer(),
          $0.Catalog.fromBuffer);
  static final _$getCatalogBySlug =
      $grpc.ClientMethod<$0.GetCatalogBySlugRequest, $0.Catalog>(
          '/wedding.user.v1.CatalogService/GetCatalogBySlug',
          ($0.GetCatalogBySlugRequest value) => value.writeToBuffer(),
          $0.Catalog.fromBuffer);
  static final _$listCatalogs =
      $grpc.ClientMethod<$0.ListCatalogsRequest, $0.CatalogListResponse>(
          '/wedding.user.v1.CatalogService/ListCatalogs',
          ($0.ListCatalogsRequest value) => value.writeToBuffer(),
          $0.CatalogListResponse.fromBuffer);
  static final _$getFeaturedCatalogs =
      $grpc.ClientMethod<$0.GetFeaturedCatalogsRequest, $0.CatalogListResponse>(
          '/wedding.user.v1.CatalogService/GetFeaturedCatalogs',
          ($0.GetFeaturedCatalogsRequest value) => value.writeToBuffer(),
          $0.CatalogListResponse.fromBuffer);
  static final _$getOnSaleCatalogs =
      $grpc.ClientMethod<$0.GetOnSaleCatalogsRequest, $0.CatalogListResponse>(
          '/wedding.user.v1.CatalogService/GetOnSaleCatalogs',
          ($0.GetOnSaleCatalogsRequest value) => value.writeToBuffer(),
          $0.CatalogListResponse.fromBuffer);
  static final _$getCatalogsByCategory = $grpc.ClientMethod<
          $0.GetCatalogsByCategoryRequest, $0.CatalogListResponse>(
      '/wedding.user.v1.CatalogService/GetCatalogsByCategory',
      ($0.GetCatalogsByCategoryRequest value) => value.writeToBuffer(),
      $0.CatalogListResponse.fromBuffer);
  static final _$getRelatedCatalogs =
      $grpc.ClientMethod<$0.GetRelatedCatalogsRequest, $0.CatalogListResponse>(
          '/wedding.user.v1.CatalogService/GetRelatedCatalogs',
          ($0.GetRelatedCatalogsRequest value) => value.writeToBuffer(),
          $0.CatalogListResponse.fromBuffer);
  static final _$searchCatalogs =
      $grpc.ClientMethod<$0.SearchCatalogsRequest, $0.CatalogListResponse>(
          '/wedding.user.v1.CatalogService/SearchCatalogs',
          ($0.SearchCatalogsRequest value) => value.writeToBuffer(),
          $0.CatalogListResponse.fromBuffer);
  static final _$getCatalogTiers =
      $grpc.ClientMethod<$0.GetCatalogTiersRequest, $0.CatalogTiersResponse>(
          '/wedding.user.v1.CatalogService/GetCatalogTiers',
          ($0.GetCatalogTiersRequest value) => value.writeToBuffer(),
          $0.CatalogTiersResponse.fromBuffer);
  static final _$getCatalogStats =
      $grpc.ClientMethod<$0.GetCatalogStatsRequest, $0.CatalogStats>(
          '/wedding.user.v1.CatalogService/GetCatalogStats',
          ($0.GetCatalogStatsRequest value) => value.writeToBuffer(),
          $0.CatalogStats.fromBuffer);
}

@$pb.GrpcServiceName('wedding.user.v1.CatalogService')
abstract class CatalogServiceBase extends $grpc.Service {
  $core.String get $name => 'wedding.user.v1.CatalogService';

  CatalogServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetCatalogRequest, $0.Catalog>(
        'GetCatalog',
        getCatalog_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetCatalogRequest.fromBuffer(value),
        ($0.Catalog value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetCatalogBySlugRequest, $0.Catalog>(
        'GetCatalogBySlug',
        getCatalogBySlug_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetCatalogBySlugRequest.fromBuffer(value),
        ($0.Catalog value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListCatalogsRequest, $0.CatalogListResponse>(
            'ListCatalogs',
            listCatalogs_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListCatalogsRequest.fromBuffer(value),
            ($0.CatalogListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetFeaturedCatalogsRequest,
            $0.CatalogListResponse>(
        'GetFeaturedCatalogs',
        getFeaturedCatalogs_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetFeaturedCatalogsRequest.fromBuffer(value),
        ($0.CatalogListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetOnSaleCatalogsRequest,
            $0.CatalogListResponse>(
        'GetOnSaleCatalogs',
        getOnSaleCatalogs_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetOnSaleCatalogsRequest.fromBuffer(value),
        ($0.CatalogListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetCatalogsByCategoryRequest,
            $0.CatalogListResponse>(
        'GetCatalogsByCategory',
        getCatalogsByCategory_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetCatalogsByCategoryRequest.fromBuffer(value),
        ($0.CatalogListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetRelatedCatalogsRequest,
            $0.CatalogListResponse>(
        'GetRelatedCatalogs',
        getRelatedCatalogs_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetRelatedCatalogsRequest.fromBuffer(value),
        ($0.CatalogListResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.SearchCatalogsRequest, $0.CatalogListResponse>(
            'SearchCatalogs',
            searchCatalogs_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.SearchCatalogsRequest.fromBuffer(value),
            ($0.CatalogListResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetCatalogTiersRequest, $0.CatalogTiersResponse>(
            'GetCatalogTiers',
            getCatalogTiers_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetCatalogTiersRequest.fromBuffer(value),
            ($0.CatalogTiersResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetCatalogStatsRequest, $0.CatalogStats>(
        'GetCatalogStats',
        getCatalogStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetCatalogStatsRequest.fromBuffer(value),
        ($0.CatalogStats value) => value.writeToBuffer()));
  }

  $async.Future<$0.Catalog> getCatalog_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetCatalogRequest> $request) async {
    return getCatalog($call, await $request);
  }

  $async.Future<$0.Catalog> getCatalog(
      $grpc.ServiceCall call, $0.GetCatalogRequest request);

  $async.Future<$0.Catalog> getCatalogBySlug_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetCatalogBySlugRequest> $request) async {
    return getCatalogBySlug($call, await $request);
  }

  $async.Future<$0.Catalog> getCatalogBySlug(
      $grpc.ServiceCall call, $0.GetCatalogBySlugRequest request);

  $async.Future<$0.CatalogListResponse> listCatalogs_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListCatalogsRequest> $request) async {
    return listCatalogs($call, await $request);
  }

  $async.Future<$0.CatalogListResponse> listCatalogs(
      $grpc.ServiceCall call, $0.ListCatalogsRequest request);

  $async.Future<$0.CatalogListResponse> getFeaturedCatalogs_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetFeaturedCatalogsRequest> $request) async {
    return getFeaturedCatalogs($call, await $request);
  }

  $async.Future<$0.CatalogListResponse> getFeaturedCatalogs(
      $grpc.ServiceCall call, $0.GetFeaturedCatalogsRequest request);

  $async.Future<$0.CatalogListResponse> getOnSaleCatalogs_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetOnSaleCatalogsRequest> $request) async {
    return getOnSaleCatalogs($call, await $request);
  }

  $async.Future<$0.CatalogListResponse> getOnSaleCatalogs(
      $grpc.ServiceCall call, $0.GetOnSaleCatalogsRequest request);

  $async.Future<$0.CatalogListResponse> getCatalogsByCategory_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetCatalogsByCategoryRequest> $request) async {
    return getCatalogsByCategory($call, await $request);
  }

  $async.Future<$0.CatalogListResponse> getCatalogsByCategory(
      $grpc.ServiceCall call, $0.GetCatalogsByCategoryRequest request);

  $async.Future<$0.CatalogListResponse> getRelatedCatalogs_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetRelatedCatalogsRequest> $request) async {
    return getRelatedCatalogs($call, await $request);
  }

  $async.Future<$0.CatalogListResponse> getRelatedCatalogs(
      $grpc.ServiceCall call, $0.GetRelatedCatalogsRequest request);

  $async.Future<$0.CatalogListResponse> searchCatalogs_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SearchCatalogsRequest> $request) async {
    return searchCatalogs($call, await $request);
  }

  $async.Future<$0.CatalogListResponse> searchCatalogs(
      $grpc.ServiceCall call, $0.SearchCatalogsRequest request);

  $async.Future<$0.CatalogTiersResponse> getCatalogTiers_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetCatalogTiersRequest> $request) async {
    return getCatalogTiers($call, await $request);
  }

  $async.Future<$0.CatalogTiersResponse> getCatalogTiers(
      $grpc.ServiceCall call, $0.GetCatalogTiersRequest request);

  $async.Future<$0.CatalogStats> getCatalogStats_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetCatalogStatsRequest> $request) async {
    return getCatalogStats($call, await $request);
  }

  $async.Future<$0.CatalogStats> getCatalogStats(
      $grpc.ServiceCall call, $0.GetCatalogStatsRequest request);
}
