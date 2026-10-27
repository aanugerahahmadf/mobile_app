// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/cbir.proto.

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

import 'cbir.pb.dart' as $0;

export 'cbir.pb.dart';

/// CBIR Service
@$pb.GrpcServiceName('wedding.user.v1.CbirService')
class CbirServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  CbirServiceClient(super.channel, {super.options, super.interceptors});

  /// Search similar items using image (unary)
  $grpc.ResponseFuture<$0.CbirSearchResponse> searchSimilar(
    $0.SearchSimilarRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$searchSimilar, request, options: options);
  }

  /// Search similar items using one buffered image chunk. RoadRunner's PHP
  /// transport supports unary RPCs; clients should upload the complete payload
  /// (or use SearchSimilar for the normal path).
  $grpc.ResponseFuture<$0.CbirSearchResponse> searchSimilarStream(
    $0.SearchSimilarChunkRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$searchSimilarStream, request, options: options);
  }

  /// Arithmetic search (combine two images)
  $grpc.ResponseFuture<$0.CbirSearchResponse> arithmeticSearch(
    $0.ArithmeticSearchRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$arithmeticSearch, request, options: options);
  }

  /// Get available arithmetic operations
  $grpc.ResponseFuture<$0.ArithmeticOpsResponse> getArithmeticOps(
    $0.GetArithmeticOpsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getArithmeticOps, request, options: options);
  }

  /// Get CBIR index statistics
  $grpc.ResponseFuture<$0.CbirStats> getStats(
    $0.GetCbirStatsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getStats, request, options: options);
  }

  /// Get CBIR search history
  $grpc.ResponseFuture<$0.CbirHistoryResponse> getHistory(
    $0.GetCbirHistoryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getHistory, request, options: options);
  }

  /// Get saved CBIR results
  $grpc.ResponseFuture<$0.CbirSavedResultsResponse> getSavedResults(
    $0.GetSavedCbirResultsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSavedResults, request, options: options);
  }

  /// Save CBIR search to history
  $grpc.ResponseFuture<$0.CbirHistory> saveSearch(
    $0.SaveCbirSearchRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$saveSearch, request, options: options);
  }

  /// Delete CBIR search from history
  $grpc.ResponseFuture<$0.DeleteCbirSearchResponse> deleteSearch(
    $0.DeleteCbirSearchRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteSearch, request, options: options);
  }

  /// Clear CBIR history
  $grpc.ResponseFuture<$0.ClearCbirHistoryResponse> clearHistory(
    $0.ClearCbirHistoryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$clearHistory, request, options: options);
  }

  /// Submit feedback on CBIR results
  $grpc.ResponseFuture<$0.SubmitCbirFeedbackResponse> submitFeedback(
    $0.SubmitCbirFeedbackRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$submitFeedback, request, options: options);
  }

  /// Admin: Rebuild CBIR index
  $grpc.ResponseFuture<$0.CbirIndexResult> rebuildIndex(
    $0.RebuildCbirIndexRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$rebuildIndex, request, options: options);
  }

  /// Admin: Add image to CBIR index
  $grpc.ResponseFuture<$0.CbirIndexResult> addToIndex(
    $0.AddToCbirIndexRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$addToIndex, request, options: options);
  }

  /// Admin: Remove image from CBIR index
  $grpc.ResponseFuture<$0.CbirIndexResult> removeFromIndex(
    $0.RemoveFromCbirIndexRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$removeFromIndex, request, options: options);
  }

  /// Health check
  $grpc.ResponseFuture<$0.HealthCheckResponse> healthCheck(
    $0.HealthCheckRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$healthCheck, request, options: options);
  }

  /// Evaluate CBIR performance
  $grpc.ResponseFuture<$0.EvaluateResponse> evaluate(
    $0.EvaluateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$evaluate, request, options: options);
  }

  // method descriptors

  static final _$searchSimilar =
      $grpc.ClientMethod<$0.SearchSimilarRequest, $0.CbirSearchResponse>(
          '/wedding.user.v1.CbirService/SearchSimilar',
          ($0.SearchSimilarRequest value) => value.writeToBuffer(),
          $0.CbirSearchResponse.fromBuffer);
  static final _$searchSimilarStream =
      $grpc.ClientMethod<$0.SearchSimilarChunkRequest, $0.CbirSearchResponse>(
          '/wedding.user.v1.CbirService/SearchSimilarStream',
          ($0.SearchSimilarChunkRequest value) => value.writeToBuffer(),
          $0.CbirSearchResponse.fromBuffer);
  static final _$arithmeticSearch =
      $grpc.ClientMethod<$0.ArithmeticSearchRequest, $0.CbirSearchResponse>(
          '/wedding.user.v1.CbirService/ArithmeticSearch',
          ($0.ArithmeticSearchRequest value) => value.writeToBuffer(),
          $0.CbirSearchResponse.fromBuffer);
  static final _$getArithmeticOps =
      $grpc.ClientMethod<$0.GetArithmeticOpsRequest, $0.ArithmeticOpsResponse>(
          '/wedding.user.v1.CbirService/GetArithmeticOps',
          ($0.GetArithmeticOpsRequest value) => value.writeToBuffer(),
          $0.ArithmeticOpsResponse.fromBuffer);
  static final _$getStats =
      $grpc.ClientMethod<$0.GetCbirStatsRequest, $0.CbirStats>(
          '/wedding.user.v1.CbirService/GetStats',
          ($0.GetCbirStatsRequest value) => value.writeToBuffer(),
          $0.CbirStats.fromBuffer);
  static final _$getHistory =
      $grpc.ClientMethod<$0.GetCbirHistoryRequest, $0.CbirHistoryResponse>(
          '/wedding.user.v1.CbirService/GetHistory',
          ($0.GetCbirHistoryRequest value) => value.writeToBuffer(),
          $0.CbirHistoryResponse.fromBuffer);
  static final _$getSavedResults = $grpc.ClientMethod<
          $0.GetSavedCbirResultsRequest, $0.CbirSavedResultsResponse>(
      '/wedding.user.v1.CbirService/GetSavedResults',
      ($0.GetSavedCbirResultsRequest value) => value.writeToBuffer(),
      $0.CbirSavedResultsResponse.fromBuffer);
  static final _$saveSearch =
      $grpc.ClientMethod<$0.SaveCbirSearchRequest, $0.CbirHistory>(
          '/wedding.user.v1.CbirService/SaveSearch',
          ($0.SaveCbirSearchRequest value) => value.writeToBuffer(),
          $0.CbirHistory.fromBuffer);
  static final _$deleteSearch = $grpc.ClientMethod<$0.DeleteCbirSearchRequest,
          $0.DeleteCbirSearchResponse>(
      '/wedding.user.v1.CbirService/DeleteSearch',
      ($0.DeleteCbirSearchRequest value) => value.writeToBuffer(),
      $0.DeleteCbirSearchResponse.fromBuffer);
  static final _$clearHistory = $grpc.ClientMethod<$0.ClearCbirHistoryRequest,
          $0.ClearCbirHistoryResponse>(
      '/wedding.user.v1.CbirService/ClearHistory',
      ($0.ClearCbirHistoryRequest value) => value.writeToBuffer(),
      $0.ClearCbirHistoryResponse.fromBuffer);
  static final _$submitFeedback = $grpc.ClientMethod<
          $0.SubmitCbirFeedbackRequest, $0.SubmitCbirFeedbackResponse>(
      '/wedding.user.v1.CbirService/SubmitFeedback',
      ($0.SubmitCbirFeedbackRequest value) => value.writeToBuffer(),
      $0.SubmitCbirFeedbackResponse.fromBuffer);
  static final _$rebuildIndex =
      $grpc.ClientMethod<$0.RebuildCbirIndexRequest, $0.CbirIndexResult>(
          '/wedding.user.v1.CbirService/RebuildIndex',
          ($0.RebuildCbirIndexRequest value) => value.writeToBuffer(),
          $0.CbirIndexResult.fromBuffer);
  static final _$addToIndex =
      $grpc.ClientMethod<$0.AddToCbirIndexRequest, $0.CbirIndexResult>(
          '/wedding.user.v1.CbirService/AddToIndex',
          ($0.AddToCbirIndexRequest value) => value.writeToBuffer(),
          $0.CbirIndexResult.fromBuffer);
  static final _$removeFromIndex =
      $grpc.ClientMethod<$0.RemoveFromCbirIndexRequest, $0.CbirIndexResult>(
          '/wedding.user.v1.CbirService/RemoveFromIndex',
          ($0.RemoveFromCbirIndexRequest value) => value.writeToBuffer(),
          $0.CbirIndexResult.fromBuffer);
  static final _$healthCheck =
      $grpc.ClientMethod<$0.HealthCheckRequest, $0.HealthCheckResponse>(
          '/wedding.user.v1.CbirService/HealthCheck',
          ($0.HealthCheckRequest value) => value.writeToBuffer(),
          $0.HealthCheckResponse.fromBuffer);
  static final _$evaluate =
      $grpc.ClientMethod<$0.EvaluateRequest, $0.EvaluateResponse>(
          '/wedding.user.v1.CbirService/Evaluate',
          ($0.EvaluateRequest value) => value.writeToBuffer(),
          $0.EvaluateResponse.fromBuffer);
}

@$pb.GrpcServiceName('wedding.user.v1.CbirService')
abstract class CbirServiceBase extends $grpc.Service {
  $core.String get $name => 'wedding.user.v1.CbirService';

  CbirServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.SearchSimilarRequest, $0.CbirSearchResponse>(
            'SearchSimilar',
            searchSimilar_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.SearchSimilarRequest.fromBuffer(value),
            ($0.CbirSearchResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SearchSimilarChunkRequest,
            $0.CbirSearchResponse>(
        'SearchSimilarStream',
        searchSimilarStream_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SearchSimilarChunkRequest.fromBuffer(value),
        ($0.CbirSearchResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ArithmeticSearchRequest, $0.CbirSearchResponse>(
            'ArithmeticSearch',
            arithmeticSearch_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ArithmeticSearchRequest.fromBuffer(value),
            ($0.CbirSearchResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetArithmeticOpsRequest,
            $0.ArithmeticOpsResponse>(
        'GetArithmeticOps',
        getArithmeticOps_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetArithmeticOpsRequest.fromBuffer(value),
        ($0.ArithmeticOpsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetCbirStatsRequest, $0.CbirStats>(
        'GetStats',
        getStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetCbirStatsRequest.fromBuffer(value),
        ($0.CbirStats value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetCbirHistoryRequest, $0.CbirHistoryResponse>(
            'GetHistory',
            getHistory_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetCbirHistoryRequest.fromBuffer(value),
            ($0.CbirHistoryResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetSavedCbirResultsRequest,
            $0.CbirSavedResultsResponse>(
        'GetSavedResults',
        getSavedResults_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetSavedCbirResultsRequest.fromBuffer(value),
        ($0.CbirSavedResultsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SaveCbirSearchRequest, $0.CbirHistory>(
        'SaveSearch',
        saveSearch_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SaveCbirSearchRequest.fromBuffer(value),
        ($0.CbirHistory value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteCbirSearchRequest,
            $0.DeleteCbirSearchResponse>(
        'DeleteSearch',
        deleteSearch_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DeleteCbirSearchRequest.fromBuffer(value),
        ($0.DeleteCbirSearchResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ClearCbirHistoryRequest,
            $0.ClearCbirHistoryResponse>(
        'ClearHistory',
        clearHistory_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ClearCbirHistoryRequest.fromBuffer(value),
        ($0.ClearCbirHistoryResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SubmitCbirFeedbackRequest,
            $0.SubmitCbirFeedbackResponse>(
        'SubmitFeedback',
        submitFeedback_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SubmitCbirFeedbackRequest.fromBuffer(value),
        ($0.SubmitCbirFeedbackResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.RebuildCbirIndexRequest, $0.CbirIndexResult>(
            'RebuildIndex',
            rebuildIndex_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.RebuildCbirIndexRequest.fromBuffer(value),
            ($0.CbirIndexResult value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.AddToCbirIndexRequest, $0.CbirIndexResult>(
            'AddToIndex',
            addToIndex_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.AddToCbirIndexRequest.fromBuffer(value),
            ($0.CbirIndexResult value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.RemoveFromCbirIndexRequest, $0.CbirIndexResult>(
            'RemoveFromIndex',
            removeFromIndex_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.RemoveFromCbirIndexRequest.fromBuffer(value),
            ($0.CbirIndexResult value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.HealthCheckRequest, $0.HealthCheckResponse>(
            'HealthCheck',
            healthCheck_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.HealthCheckRequest.fromBuffer(value),
            ($0.HealthCheckResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.EvaluateRequest, $0.EvaluateResponse>(
        'Evaluate',
        evaluate_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.EvaluateRequest.fromBuffer(value),
        ($0.EvaluateResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.CbirSearchResponse> searchSimilar_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SearchSimilarRequest> $request) async {
    return searchSimilar($call, await $request);
  }

  $async.Future<$0.CbirSearchResponse> searchSimilar(
      $grpc.ServiceCall call, $0.SearchSimilarRequest request);

  $async.Future<$0.CbirSearchResponse> searchSimilarStream_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SearchSimilarChunkRequest> $request) async {
    return searchSimilarStream($call, await $request);
  }

  $async.Future<$0.CbirSearchResponse> searchSimilarStream(
      $grpc.ServiceCall call, $0.SearchSimilarChunkRequest request);

  $async.Future<$0.CbirSearchResponse> arithmeticSearch_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ArithmeticSearchRequest> $request) async {
    return arithmeticSearch($call, await $request);
  }

  $async.Future<$0.CbirSearchResponse> arithmeticSearch(
      $grpc.ServiceCall call, $0.ArithmeticSearchRequest request);

  $async.Future<$0.ArithmeticOpsResponse> getArithmeticOps_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetArithmeticOpsRequest> $request) async {
    return getArithmeticOps($call, await $request);
  }

  $async.Future<$0.ArithmeticOpsResponse> getArithmeticOps(
      $grpc.ServiceCall call, $0.GetArithmeticOpsRequest request);

  $async.Future<$0.CbirStats> getStats_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetCbirStatsRequest> $request) async {
    return getStats($call, await $request);
  }

  $async.Future<$0.CbirStats> getStats(
      $grpc.ServiceCall call, $0.GetCbirStatsRequest request);

  $async.Future<$0.CbirHistoryResponse> getHistory_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetCbirHistoryRequest> $request) async {
    return getHistory($call, await $request);
  }

  $async.Future<$0.CbirHistoryResponse> getHistory(
      $grpc.ServiceCall call, $0.GetCbirHistoryRequest request);

  $async.Future<$0.CbirSavedResultsResponse> getSavedResults_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetSavedCbirResultsRequest> $request) async {
    return getSavedResults($call, await $request);
  }

  $async.Future<$0.CbirSavedResultsResponse> getSavedResults(
      $grpc.ServiceCall call, $0.GetSavedCbirResultsRequest request);

  $async.Future<$0.CbirHistory> saveSearch_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SaveCbirSearchRequest> $request) async {
    return saveSearch($call, await $request);
  }

  $async.Future<$0.CbirHistory> saveSearch(
      $grpc.ServiceCall call, $0.SaveCbirSearchRequest request);

  $async.Future<$0.DeleteCbirSearchResponse> deleteSearch_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DeleteCbirSearchRequest> $request) async {
    return deleteSearch($call, await $request);
  }

  $async.Future<$0.DeleteCbirSearchResponse> deleteSearch(
      $grpc.ServiceCall call, $0.DeleteCbirSearchRequest request);

  $async.Future<$0.ClearCbirHistoryResponse> clearHistory_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ClearCbirHistoryRequest> $request) async {
    return clearHistory($call, await $request);
  }

  $async.Future<$0.ClearCbirHistoryResponse> clearHistory(
      $grpc.ServiceCall call, $0.ClearCbirHistoryRequest request);

  $async.Future<$0.SubmitCbirFeedbackResponse> submitFeedback_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SubmitCbirFeedbackRequest> $request) async {
    return submitFeedback($call, await $request);
  }

  $async.Future<$0.SubmitCbirFeedbackResponse> submitFeedback(
      $grpc.ServiceCall call, $0.SubmitCbirFeedbackRequest request);

  $async.Future<$0.CbirIndexResult> rebuildIndex_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RebuildCbirIndexRequest> $request) async {
    return rebuildIndex($call, await $request);
  }

  $async.Future<$0.CbirIndexResult> rebuildIndex(
      $grpc.ServiceCall call, $0.RebuildCbirIndexRequest request);

  $async.Future<$0.CbirIndexResult> addToIndex_Pre($grpc.ServiceCall $call,
      $async.Future<$0.AddToCbirIndexRequest> $request) async {
    return addToIndex($call, await $request);
  }

  $async.Future<$0.CbirIndexResult> addToIndex(
      $grpc.ServiceCall call, $0.AddToCbirIndexRequest request);

  $async.Future<$0.CbirIndexResult> removeFromIndex_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RemoveFromCbirIndexRequest> $request) async {
    return removeFromIndex($call, await $request);
  }

  $async.Future<$0.CbirIndexResult> removeFromIndex(
      $grpc.ServiceCall call, $0.RemoveFromCbirIndexRequest request);

  $async.Future<$0.HealthCheckResponse> healthCheck_Pre($grpc.ServiceCall $call,
      $async.Future<$0.HealthCheckRequest> $request) async {
    return healthCheck($call, await $request);
  }

  $async.Future<$0.HealthCheckResponse> healthCheck(
      $grpc.ServiceCall call, $0.HealthCheckRequest request);

  $async.Future<$0.EvaluateResponse> evaluate_Pre($grpc.ServiceCall $call,
      $async.Future<$0.EvaluateRequest> $request) async {
    return evaluate($call, await $request);
  }

  $async.Future<$0.EvaluateResponse> evaluate(
      $grpc.ServiceCall call, $0.EvaluateRequest request);
}
