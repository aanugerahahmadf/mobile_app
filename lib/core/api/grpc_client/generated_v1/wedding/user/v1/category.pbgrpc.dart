// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/category.proto.

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

import 'category.pb.dart' as $0;

export 'category.pb.dart';

/// Category Service
@$pb.GrpcServiceName('wedding.user.v1.CategoryService')
class CategoryServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  CategoryServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.Category> getCategory(
    $0.GetCategoryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getCategory, request, options: options);
  }

  $grpc.ResponseFuture<$0.Category> getCategoryBySlug(
    $0.GetCategoryBySlugRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getCategoryBySlug, request, options: options);
  }

  $grpc.ResponseFuture<$0.CategoryListResponse> listCategories(
    $0.ListCategoriesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listCategories, request, options: options);
  }

  $grpc.ResponseFuture<$0.CategoryListResponse> getAllCategories(
    $0.GetAllCategoriesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getAllCategories, request, options: options);
  }

  $grpc.ResponseFuture<$0.CategoryTreeResponse> getCategoryTree(
    $0.GetCategoryTreeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getCategoryTree, request, options: options);
  }

  $grpc.ResponseFuture<$0.CategoryWithCountsResponse> getCategoriesWithCounts(
    $0.GetCategoriesWithCountsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getCategoriesWithCounts, request,
        options: options);
  }

  // method descriptors

  static final _$getCategory =
      $grpc.ClientMethod<$0.GetCategoryRequest, $0.Category>(
          '/wedding.user.v1.CategoryService/GetCategory',
          ($0.GetCategoryRequest value) => value.writeToBuffer(),
          $0.Category.fromBuffer);
  static final _$getCategoryBySlug =
      $grpc.ClientMethod<$0.GetCategoryBySlugRequest, $0.Category>(
          '/wedding.user.v1.CategoryService/GetCategoryBySlug',
          ($0.GetCategoryBySlugRequest value) => value.writeToBuffer(),
          $0.Category.fromBuffer);
  static final _$listCategories =
      $grpc.ClientMethod<$0.ListCategoriesRequest, $0.CategoryListResponse>(
          '/wedding.user.v1.CategoryService/ListCategories',
          ($0.ListCategoriesRequest value) => value.writeToBuffer(),
          $0.CategoryListResponse.fromBuffer);
  static final _$getAllCategories =
      $grpc.ClientMethod<$0.GetAllCategoriesRequest, $0.CategoryListResponse>(
          '/wedding.user.v1.CategoryService/GetAllCategories',
          ($0.GetAllCategoriesRequest value) => value.writeToBuffer(),
          $0.CategoryListResponse.fromBuffer);
  static final _$getCategoryTree =
      $grpc.ClientMethod<$0.GetCategoryTreeRequest, $0.CategoryTreeResponse>(
          '/wedding.user.v1.CategoryService/GetCategoryTree',
          ($0.GetCategoryTreeRequest value) => value.writeToBuffer(),
          $0.CategoryTreeResponse.fromBuffer);
  static final _$getCategoriesWithCounts = $grpc.ClientMethod<
          $0.GetCategoriesWithCountsRequest, $0.CategoryWithCountsResponse>(
      '/wedding.user.v1.CategoryService/GetCategoriesWithCounts',
      ($0.GetCategoriesWithCountsRequest value) => value.writeToBuffer(),
      $0.CategoryWithCountsResponse.fromBuffer);
}

@$pb.GrpcServiceName('wedding.user.v1.CategoryService')
abstract class CategoryServiceBase extends $grpc.Service {
  $core.String get $name => 'wedding.user.v1.CategoryService';

  CategoryServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetCategoryRequest, $0.Category>(
        'GetCategory',
        getCategory_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetCategoryRequest.fromBuffer(value),
        ($0.Category value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetCategoryBySlugRequest, $0.Category>(
        'GetCategoryBySlug',
        getCategoryBySlug_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetCategoryBySlugRequest.fromBuffer(value),
        ($0.Category value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListCategoriesRequest, $0.CategoryListResponse>(
            'ListCategories',
            listCategories_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListCategoriesRequest.fromBuffer(value),
            ($0.CategoryListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetAllCategoriesRequest,
            $0.CategoryListResponse>(
        'GetAllCategories',
        getAllCategories_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetAllCategoriesRequest.fromBuffer(value),
        ($0.CategoryListResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetCategoryTreeRequest, $0.CategoryTreeResponse>(
            'GetCategoryTree',
            getCategoryTree_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetCategoryTreeRequest.fromBuffer(value),
            ($0.CategoryTreeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetCategoriesWithCountsRequest,
            $0.CategoryWithCountsResponse>(
        'GetCategoriesWithCounts',
        getCategoriesWithCounts_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetCategoriesWithCountsRequest.fromBuffer(value),
        ($0.CategoryWithCountsResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.Category> getCategory_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetCategoryRequest> $request) async {
    return getCategory($call, await $request);
  }

  $async.Future<$0.Category> getCategory(
      $grpc.ServiceCall call, $0.GetCategoryRequest request);

  $async.Future<$0.Category> getCategoryBySlug_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetCategoryBySlugRequest> $request) async {
    return getCategoryBySlug($call, await $request);
  }

  $async.Future<$0.Category> getCategoryBySlug(
      $grpc.ServiceCall call, $0.GetCategoryBySlugRequest request);

  $async.Future<$0.CategoryListResponse> listCategories_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListCategoriesRequest> $request) async {
    return listCategories($call, await $request);
  }

  $async.Future<$0.CategoryListResponse> listCategories(
      $grpc.ServiceCall call, $0.ListCategoriesRequest request);

  $async.Future<$0.CategoryListResponse> getAllCategories_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetAllCategoriesRequest> $request) async {
    return getAllCategories($call, await $request);
  }

  $async.Future<$0.CategoryListResponse> getAllCategories(
      $grpc.ServiceCall call, $0.GetAllCategoriesRequest request);

  $async.Future<$0.CategoryTreeResponse> getCategoryTree_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetCategoryTreeRequest> $request) async {
    return getCategoryTree($call, await $request);
  }

  $async.Future<$0.CategoryTreeResponse> getCategoryTree(
      $grpc.ServiceCall call, $0.GetCategoryTreeRequest request);

  $async.Future<$0.CategoryWithCountsResponse> getCategoriesWithCounts_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetCategoriesWithCountsRequest> $request) async {
    return getCategoriesWithCounts($call, await $request);
  }

  $async.Future<$0.CategoryWithCountsResponse> getCategoriesWithCounts(
      $grpc.ServiceCall call, $0.GetCategoriesWithCountsRequest request);
}
