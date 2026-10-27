// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/package.proto.

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

import 'package.pb.dart' as $0;

export 'package.pb.dart';

/// Package Service
@$pb.GrpcServiceName('wedding.user.v1.PackageService')
class PackageServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  PackageServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.Package> getPackage(
    $0.GetPackageRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPackage, request, options: options);
  }

  $grpc.ResponseFuture<$0.Package> getPackageBySlug(
    $0.GetPackageBySlugRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPackageBySlug, request, options: options);
  }

  $grpc.ResponseFuture<$0.PackageListResponse> listPackages(
    $0.ListPackagesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listPackages, request, options: options);
  }

  $grpc.ResponseFuture<$0.PackageListResponse> getFeaturedPackages(
    $0.GetFeaturedPackagesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getFeaturedPackages, request, options: options);
  }

  $grpc.ResponseFuture<$0.PackageListResponse> getOnSalePackages(
    $0.GetOnSalePackagesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getOnSalePackages, request, options: options);
  }

  $grpc.ResponseFuture<$0.PackageListResponse> getPackagesByCategory(
    $0.GetPackagesByCategoryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPackagesByCategory, request, options: options);
  }

  $grpc.ResponseFuture<$0.PackageListResponse> getPackagesByCapacity(
    $0.GetPackagesByCapacityRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPackagesByCapacity, request, options: options);
  }

  $grpc.ResponseFuture<$0.PackageListResponse> getRelatedPackages(
    $0.GetRelatedPackagesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRelatedPackages, request, options: options);
  }

  $grpc.ResponseFuture<$0.PackageListResponse> searchPackages(
    $0.SearchPackagesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$searchPackages, request, options: options);
  }

  $grpc.ResponseFuture<$0.PackageStats> getPackageStats(
    $0.GetPackageStatsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPackageStats, request, options: options);
  }

  // method descriptors

  static final _$getPackage =
      $grpc.ClientMethod<$0.GetPackageRequest, $0.Package>(
          '/wedding.user.v1.PackageService/GetPackage',
          ($0.GetPackageRequest value) => value.writeToBuffer(),
          $0.Package.fromBuffer);
  static final _$getPackageBySlug =
      $grpc.ClientMethod<$0.GetPackageBySlugRequest, $0.Package>(
          '/wedding.user.v1.PackageService/GetPackageBySlug',
          ($0.GetPackageBySlugRequest value) => value.writeToBuffer(),
          $0.Package.fromBuffer);
  static final _$listPackages =
      $grpc.ClientMethod<$0.ListPackagesRequest, $0.PackageListResponse>(
          '/wedding.user.v1.PackageService/ListPackages',
          ($0.ListPackagesRequest value) => value.writeToBuffer(),
          $0.PackageListResponse.fromBuffer);
  static final _$getFeaturedPackages =
      $grpc.ClientMethod<$0.GetFeaturedPackagesRequest, $0.PackageListResponse>(
          '/wedding.user.v1.PackageService/GetFeaturedPackages',
          ($0.GetFeaturedPackagesRequest value) => value.writeToBuffer(),
          $0.PackageListResponse.fromBuffer);
  static final _$getOnSalePackages =
      $grpc.ClientMethod<$0.GetOnSalePackagesRequest, $0.PackageListResponse>(
          '/wedding.user.v1.PackageService/GetOnSalePackages',
          ($0.GetOnSalePackagesRequest value) => value.writeToBuffer(),
          $0.PackageListResponse.fromBuffer);
  static final _$getPackagesByCategory = $grpc.ClientMethod<
          $0.GetPackagesByCategoryRequest, $0.PackageListResponse>(
      '/wedding.user.v1.PackageService/GetPackagesByCategory',
      ($0.GetPackagesByCategoryRequest value) => value.writeToBuffer(),
      $0.PackageListResponse.fromBuffer);
  static final _$getPackagesByCapacity = $grpc.ClientMethod<
          $0.GetPackagesByCapacityRequest, $0.PackageListResponse>(
      '/wedding.user.v1.PackageService/GetPackagesByCapacity',
      ($0.GetPackagesByCapacityRequest value) => value.writeToBuffer(),
      $0.PackageListResponse.fromBuffer);
  static final _$getRelatedPackages =
      $grpc.ClientMethod<$0.GetRelatedPackagesRequest, $0.PackageListResponse>(
          '/wedding.user.v1.PackageService/GetRelatedPackages',
          ($0.GetRelatedPackagesRequest value) => value.writeToBuffer(),
          $0.PackageListResponse.fromBuffer);
  static final _$searchPackages =
      $grpc.ClientMethod<$0.SearchPackagesRequest, $0.PackageListResponse>(
          '/wedding.user.v1.PackageService/SearchPackages',
          ($0.SearchPackagesRequest value) => value.writeToBuffer(),
          $0.PackageListResponse.fromBuffer);
  static final _$getPackageStats =
      $grpc.ClientMethod<$0.GetPackageStatsRequest, $0.PackageStats>(
          '/wedding.user.v1.PackageService/GetPackageStats',
          ($0.GetPackageStatsRequest value) => value.writeToBuffer(),
          $0.PackageStats.fromBuffer);
}

@$pb.GrpcServiceName('wedding.user.v1.PackageService')
abstract class PackageServiceBase extends $grpc.Service {
  $core.String get $name => 'wedding.user.v1.PackageService';

  PackageServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetPackageRequest, $0.Package>(
        'GetPackage',
        getPackage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetPackageRequest.fromBuffer(value),
        ($0.Package value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetPackageBySlugRequest, $0.Package>(
        'GetPackageBySlug',
        getPackageBySlug_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetPackageBySlugRequest.fromBuffer(value),
        ($0.Package value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListPackagesRequest, $0.PackageListResponse>(
            'ListPackages',
            listPackages_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListPackagesRequest.fromBuffer(value),
            ($0.PackageListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetFeaturedPackagesRequest,
            $0.PackageListResponse>(
        'GetFeaturedPackages',
        getFeaturedPackages_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetFeaturedPackagesRequest.fromBuffer(value),
        ($0.PackageListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetOnSalePackagesRequest,
            $0.PackageListResponse>(
        'GetOnSalePackages',
        getOnSalePackages_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetOnSalePackagesRequest.fromBuffer(value),
        ($0.PackageListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetPackagesByCategoryRequest,
            $0.PackageListResponse>(
        'GetPackagesByCategory',
        getPackagesByCategory_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetPackagesByCategoryRequest.fromBuffer(value),
        ($0.PackageListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetPackagesByCapacityRequest,
            $0.PackageListResponse>(
        'GetPackagesByCapacity',
        getPackagesByCapacity_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetPackagesByCapacityRequest.fromBuffer(value),
        ($0.PackageListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetRelatedPackagesRequest,
            $0.PackageListResponse>(
        'GetRelatedPackages',
        getRelatedPackages_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetRelatedPackagesRequest.fromBuffer(value),
        ($0.PackageListResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.SearchPackagesRequest, $0.PackageListResponse>(
            'SearchPackages',
            searchPackages_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.SearchPackagesRequest.fromBuffer(value),
            ($0.PackageListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetPackageStatsRequest, $0.PackageStats>(
        'GetPackageStats',
        getPackageStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetPackageStatsRequest.fromBuffer(value),
        ($0.PackageStats value) => value.writeToBuffer()));
  }

  $async.Future<$0.Package> getPackage_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetPackageRequest> $request) async {
    return getPackage($call, await $request);
  }

  $async.Future<$0.Package> getPackage(
      $grpc.ServiceCall call, $0.GetPackageRequest request);

  $async.Future<$0.Package> getPackageBySlug_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetPackageBySlugRequest> $request) async {
    return getPackageBySlug($call, await $request);
  }

  $async.Future<$0.Package> getPackageBySlug(
      $grpc.ServiceCall call, $0.GetPackageBySlugRequest request);

  $async.Future<$0.PackageListResponse> listPackages_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListPackagesRequest> $request) async {
    return listPackages($call, await $request);
  }

  $async.Future<$0.PackageListResponse> listPackages(
      $grpc.ServiceCall call, $0.ListPackagesRequest request);

  $async.Future<$0.PackageListResponse> getFeaturedPackages_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetFeaturedPackagesRequest> $request) async {
    return getFeaturedPackages($call, await $request);
  }

  $async.Future<$0.PackageListResponse> getFeaturedPackages(
      $grpc.ServiceCall call, $0.GetFeaturedPackagesRequest request);

  $async.Future<$0.PackageListResponse> getOnSalePackages_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetOnSalePackagesRequest> $request) async {
    return getOnSalePackages($call, await $request);
  }

  $async.Future<$0.PackageListResponse> getOnSalePackages(
      $grpc.ServiceCall call, $0.GetOnSalePackagesRequest request);

  $async.Future<$0.PackageListResponse> getPackagesByCategory_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetPackagesByCategoryRequest> $request) async {
    return getPackagesByCategory($call, await $request);
  }

  $async.Future<$0.PackageListResponse> getPackagesByCategory(
      $grpc.ServiceCall call, $0.GetPackagesByCategoryRequest request);

  $async.Future<$0.PackageListResponse> getPackagesByCapacity_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetPackagesByCapacityRequest> $request) async {
    return getPackagesByCapacity($call, await $request);
  }

  $async.Future<$0.PackageListResponse> getPackagesByCapacity(
      $grpc.ServiceCall call, $0.GetPackagesByCapacityRequest request);

  $async.Future<$0.PackageListResponse> getRelatedPackages_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetRelatedPackagesRequest> $request) async {
    return getRelatedPackages($call, await $request);
  }

  $async.Future<$0.PackageListResponse> getRelatedPackages(
      $grpc.ServiceCall call, $0.GetRelatedPackagesRequest request);

  $async.Future<$0.PackageListResponse> searchPackages_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SearchPackagesRequest> $request) async {
    return searchPackages($call, await $request);
  }

  $async.Future<$0.PackageListResponse> searchPackages(
      $grpc.ServiceCall call, $0.SearchPackagesRequest request);

  $async.Future<$0.PackageStats> getPackageStats_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetPackageStatsRequest> $request) async {
    return getPackageStats($call, await $request);
  }

  $async.Future<$0.PackageStats> getPackageStats(
      $grpc.ServiceCall call, $0.GetPackageStatsRequest request);
}
