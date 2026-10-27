// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/review.proto.

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

import 'catalog.pb.dart' as $1;
import 'review.pb.dart' as $0;

export 'review.pb.dart';

/// Review Service
@$pb.GrpcServiceName('wedding.user.v1.ReviewService')
class ReviewServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ReviewServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.ReviewListResponse> getCatalogReviews(
    $0.GetCatalogReviewsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getCatalogReviews, request, options: options);
  }

  $grpc.ResponseFuture<$0.ReviewListResponse> getPackageReviews(
    $0.GetPackageReviewsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPackageReviews, request, options: options);
  }

  $grpc.ResponseFuture<$0.ReviewListResponse> getMyReviews(
    $0.GetMyReviewsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getMyReviews, request, options: options);
  }

  $grpc.ResponseFuture<$1.Review> getReview(
    $0.GetReviewRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getReview, request, options: options);
  }

  $grpc.ResponseFuture<$0.ReviewStats> getReviewStats(
    $0.GetReviewStatsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getReviewStats, request, options: options);
  }

  $grpc.ResponseFuture<$0.ReviewListResponse> getFeaturedReviews(
    $0.GetFeaturedReviewsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getFeaturedReviews, request, options: options);
  }

  $grpc.ResponseFuture<$0.ReviewListResponse> getAllReviews(
    $0.GetAllReviewsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getAllReviews, request, options: options);
  }

  $grpc.ResponseFuture<$1.Review> createReview(
    $0.CreateReviewRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createReview, request, options: options);
  }

  $grpc.ResponseFuture<$1.Review> updateReview(
    $0.UpdateReviewRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateReview, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeleteReviewResponse> deleteReview(
    $0.DeleteReviewRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteReview, request, options: options);
  }

  $grpc.ResponseFuture<$1.Review> addReviewPhoto(
    $0.AddReviewPhotoRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$addReviewPhoto, request, options: options);
  }

  $grpc.ResponseFuture<$1.Review> removeReviewPhoto(
    $0.RemoveReviewPhotoRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$removeReviewPhoto, request, options: options);
  }

  $grpc.ResponseFuture<$1.Review> markReviewHelpful(
    $0.MarkReviewHelpfulRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$markReviewHelpful, request, options: options);
  }

  $grpc.ResponseFuture<$1.Review> unmarkReviewHelpful(
    $0.UnmarkReviewHelpfulRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$unmarkReviewHelpful, request, options: options);
  }

  $grpc.ResponseFuture<$1.Review> moderateReview(
    $0.ModerateReviewRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$moderateReview, request, options: options);
  }

  $grpc.ResponseFuture<$1.Review> replyToReview(
    $0.ReplyToReviewRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$replyToReview, request, options: options);
  }

  $grpc.ResponseFuture<$0.ReviewReport> reportReview(
    $0.ReportReviewRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$reportReview, request, options: options);
  }

  // method descriptors

  static final _$getCatalogReviews =
      $grpc.ClientMethod<$0.GetCatalogReviewsRequest, $0.ReviewListResponse>(
          '/wedding.user.v1.ReviewService/GetCatalogReviews',
          ($0.GetCatalogReviewsRequest value) => value.writeToBuffer(),
          $0.ReviewListResponse.fromBuffer);
  static final _$getPackageReviews =
      $grpc.ClientMethod<$0.GetPackageReviewsRequest, $0.ReviewListResponse>(
          '/wedding.user.v1.ReviewService/GetPackageReviews',
          ($0.GetPackageReviewsRequest value) => value.writeToBuffer(),
          $0.ReviewListResponse.fromBuffer);
  static final _$getMyReviews =
      $grpc.ClientMethod<$0.GetMyReviewsRequest, $0.ReviewListResponse>(
          '/wedding.user.v1.ReviewService/GetMyReviews',
          ($0.GetMyReviewsRequest value) => value.writeToBuffer(),
          $0.ReviewListResponse.fromBuffer);
  static final _$getReview = $grpc.ClientMethod<$0.GetReviewRequest, $1.Review>(
      '/wedding.user.v1.ReviewService/GetReview',
      ($0.GetReviewRequest value) => value.writeToBuffer(),
      $1.Review.fromBuffer);
  static final _$getReviewStats =
      $grpc.ClientMethod<$0.GetReviewStatsRequest, $0.ReviewStats>(
          '/wedding.user.v1.ReviewService/GetReviewStats',
          ($0.GetReviewStatsRequest value) => value.writeToBuffer(),
          $0.ReviewStats.fromBuffer);
  static final _$getFeaturedReviews =
      $grpc.ClientMethod<$0.GetFeaturedReviewsRequest, $0.ReviewListResponse>(
          '/wedding.user.v1.ReviewService/GetFeaturedReviews',
          ($0.GetFeaturedReviewsRequest value) => value.writeToBuffer(),
          $0.ReviewListResponse.fromBuffer);
  static final _$getAllReviews =
      $grpc.ClientMethod<$0.GetAllReviewsRequest, $0.ReviewListResponse>(
          '/wedding.user.v1.ReviewService/GetAllReviews',
          ($0.GetAllReviewsRequest value) => value.writeToBuffer(),
          $0.ReviewListResponse.fromBuffer);
  static final _$createReview =
      $grpc.ClientMethod<$0.CreateReviewRequest, $1.Review>(
          '/wedding.user.v1.ReviewService/CreateReview',
          ($0.CreateReviewRequest value) => value.writeToBuffer(),
          $1.Review.fromBuffer);
  static final _$updateReview =
      $grpc.ClientMethod<$0.UpdateReviewRequest, $1.Review>(
          '/wedding.user.v1.ReviewService/UpdateReview',
          ($0.UpdateReviewRequest value) => value.writeToBuffer(),
          $1.Review.fromBuffer);
  static final _$deleteReview =
      $grpc.ClientMethod<$0.DeleteReviewRequest, $0.DeleteReviewResponse>(
          '/wedding.user.v1.ReviewService/DeleteReview',
          ($0.DeleteReviewRequest value) => value.writeToBuffer(),
          $0.DeleteReviewResponse.fromBuffer);
  static final _$addReviewPhoto =
      $grpc.ClientMethod<$0.AddReviewPhotoRequest, $1.Review>(
          '/wedding.user.v1.ReviewService/AddReviewPhoto',
          ($0.AddReviewPhotoRequest value) => value.writeToBuffer(),
          $1.Review.fromBuffer);
  static final _$removeReviewPhoto =
      $grpc.ClientMethod<$0.RemoveReviewPhotoRequest, $1.Review>(
          '/wedding.user.v1.ReviewService/RemoveReviewPhoto',
          ($0.RemoveReviewPhotoRequest value) => value.writeToBuffer(),
          $1.Review.fromBuffer);
  static final _$markReviewHelpful =
      $grpc.ClientMethod<$0.MarkReviewHelpfulRequest, $1.Review>(
          '/wedding.user.v1.ReviewService/MarkReviewHelpful',
          ($0.MarkReviewHelpfulRequest value) => value.writeToBuffer(),
          $1.Review.fromBuffer);
  static final _$unmarkReviewHelpful =
      $grpc.ClientMethod<$0.UnmarkReviewHelpfulRequest, $1.Review>(
          '/wedding.user.v1.ReviewService/UnmarkReviewHelpful',
          ($0.UnmarkReviewHelpfulRequest value) => value.writeToBuffer(),
          $1.Review.fromBuffer);
  static final _$moderateReview =
      $grpc.ClientMethod<$0.ModerateReviewRequest, $1.Review>(
          '/wedding.user.v1.ReviewService/ModerateReview',
          ($0.ModerateReviewRequest value) => value.writeToBuffer(),
          $1.Review.fromBuffer);
  static final _$replyToReview =
      $grpc.ClientMethod<$0.ReplyToReviewRequest, $1.Review>(
          '/wedding.user.v1.ReviewService/ReplyToReview',
          ($0.ReplyToReviewRequest value) => value.writeToBuffer(),
          $1.Review.fromBuffer);
  static final _$reportReview =
      $grpc.ClientMethod<$0.ReportReviewRequest, $0.ReviewReport>(
          '/wedding.user.v1.ReviewService/ReportReview',
          ($0.ReportReviewRequest value) => value.writeToBuffer(),
          $0.ReviewReport.fromBuffer);
}

@$pb.GrpcServiceName('wedding.user.v1.ReviewService')
abstract class ReviewServiceBase extends $grpc.Service {
  $core.String get $name => 'wedding.user.v1.ReviewService';

  ReviewServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.GetCatalogReviewsRequest, $0.ReviewListResponse>(
            'GetCatalogReviews',
            getCatalogReviews_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetCatalogReviewsRequest.fromBuffer(value),
            ($0.ReviewListResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetPackageReviewsRequest, $0.ReviewListResponse>(
            'GetPackageReviews',
            getPackageReviews_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetPackageReviewsRequest.fromBuffer(value),
            ($0.ReviewListResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetMyReviewsRequest, $0.ReviewListResponse>(
            'GetMyReviews',
            getMyReviews_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetMyReviewsRequest.fromBuffer(value),
            ($0.ReviewListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetReviewRequest, $1.Review>(
        'GetReview',
        getReview_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetReviewRequest.fromBuffer(value),
        ($1.Review value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetReviewStatsRequest, $0.ReviewStats>(
        'GetReviewStats',
        getReviewStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetReviewStatsRequest.fromBuffer(value),
        ($0.ReviewStats value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetFeaturedReviewsRequest,
            $0.ReviewListResponse>(
        'GetFeaturedReviews',
        getFeaturedReviews_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetFeaturedReviewsRequest.fromBuffer(value),
        ($0.ReviewListResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetAllReviewsRequest, $0.ReviewListResponse>(
            'GetAllReviews',
            getAllReviews_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetAllReviewsRequest.fromBuffer(value),
            ($0.ReviewListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CreateReviewRequest, $1.Review>(
        'CreateReview',
        createReview_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CreateReviewRequest.fromBuffer(value),
        ($1.Review value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateReviewRequest, $1.Review>(
        'UpdateReview',
        updateReview_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateReviewRequest.fromBuffer(value),
        ($1.Review value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.DeleteReviewRequest, $0.DeleteReviewResponse>(
            'DeleteReview',
            deleteReview_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.DeleteReviewRequest.fromBuffer(value),
            ($0.DeleteReviewResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AddReviewPhotoRequest, $1.Review>(
        'AddReviewPhoto',
        addReviewPhoto_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.AddReviewPhotoRequest.fromBuffer(value),
        ($1.Review value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RemoveReviewPhotoRequest, $1.Review>(
        'RemoveReviewPhoto',
        removeReviewPhoto_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RemoveReviewPhotoRequest.fromBuffer(value),
        ($1.Review value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.MarkReviewHelpfulRequest, $1.Review>(
        'MarkReviewHelpful',
        markReviewHelpful_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.MarkReviewHelpfulRequest.fromBuffer(value),
        ($1.Review value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UnmarkReviewHelpfulRequest, $1.Review>(
        'UnmarkReviewHelpful',
        unmarkReviewHelpful_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UnmarkReviewHelpfulRequest.fromBuffer(value),
        ($1.Review value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ModerateReviewRequest, $1.Review>(
        'ModerateReview',
        moderateReview_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ModerateReviewRequest.fromBuffer(value),
        ($1.Review value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ReplyToReviewRequest, $1.Review>(
        'ReplyToReview',
        replyToReview_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ReplyToReviewRequest.fromBuffer(value),
        ($1.Review value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ReportReviewRequest, $0.ReviewReport>(
        'ReportReview',
        reportReview_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ReportReviewRequest.fromBuffer(value),
        ($0.ReviewReport value) => value.writeToBuffer()));
  }

  $async.Future<$0.ReviewListResponse> getCatalogReviews_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetCatalogReviewsRequest> $request) async {
    return getCatalogReviews($call, await $request);
  }

  $async.Future<$0.ReviewListResponse> getCatalogReviews(
      $grpc.ServiceCall call, $0.GetCatalogReviewsRequest request);

  $async.Future<$0.ReviewListResponse> getPackageReviews_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetPackageReviewsRequest> $request) async {
    return getPackageReviews($call, await $request);
  }

  $async.Future<$0.ReviewListResponse> getPackageReviews(
      $grpc.ServiceCall call, $0.GetPackageReviewsRequest request);

  $async.Future<$0.ReviewListResponse> getMyReviews_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetMyReviewsRequest> $request) async {
    return getMyReviews($call, await $request);
  }

  $async.Future<$0.ReviewListResponse> getMyReviews(
      $grpc.ServiceCall call, $0.GetMyReviewsRequest request);

  $async.Future<$1.Review> getReview_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetReviewRequest> $request) async {
    return getReview($call, await $request);
  }

  $async.Future<$1.Review> getReview(
      $grpc.ServiceCall call, $0.GetReviewRequest request);

  $async.Future<$0.ReviewStats> getReviewStats_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetReviewStatsRequest> $request) async {
    return getReviewStats($call, await $request);
  }

  $async.Future<$0.ReviewStats> getReviewStats(
      $grpc.ServiceCall call, $0.GetReviewStatsRequest request);

  $async.Future<$0.ReviewListResponse> getFeaturedReviews_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetFeaturedReviewsRequest> $request) async {
    return getFeaturedReviews($call, await $request);
  }

  $async.Future<$0.ReviewListResponse> getFeaturedReviews(
      $grpc.ServiceCall call, $0.GetFeaturedReviewsRequest request);

  $async.Future<$0.ReviewListResponse> getAllReviews_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetAllReviewsRequest> $request) async {
    return getAllReviews($call, await $request);
  }

  $async.Future<$0.ReviewListResponse> getAllReviews(
      $grpc.ServiceCall call, $0.GetAllReviewsRequest request);

  $async.Future<$1.Review> createReview_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CreateReviewRequest> $request) async {
    return createReview($call, await $request);
  }

  $async.Future<$1.Review> createReview(
      $grpc.ServiceCall call, $0.CreateReviewRequest request);

  $async.Future<$1.Review> updateReview_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateReviewRequest> $request) async {
    return updateReview($call, await $request);
  }

  $async.Future<$1.Review> updateReview(
      $grpc.ServiceCall call, $0.UpdateReviewRequest request);

  $async.Future<$0.DeleteReviewResponse> deleteReview_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DeleteReviewRequest> $request) async {
    return deleteReview($call, await $request);
  }

  $async.Future<$0.DeleteReviewResponse> deleteReview(
      $grpc.ServiceCall call, $0.DeleteReviewRequest request);

  $async.Future<$1.Review> addReviewPhoto_Pre($grpc.ServiceCall $call,
      $async.Future<$0.AddReviewPhotoRequest> $request) async {
    return addReviewPhoto($call, await $request);
  }

  $async.Future<$1.Review> addReviewPhoto(
      $grpc.ServiceCall call, $0.AddReviewPhotoRequest request);

  $async.Future<$1.Review> removeReviewPhoto_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RemoveReviewPhotoRequest> $request) async {
    return removeReviewPhoto($call, await $request);
  }

  $async.Future<$1.Review> removeReviewPhoto(
      $grpc.ServiceCall call, $0.RemoveReviewPhotoRequest request);

  $async.Future<$1.Review> markReviewHelpful_Pre($grpc.ServiceCall $call,
      $async.Future<$0.MarkReviewHelpfulRequest> $request) async {
    return markReviewHelpful($call, await $request);
  }

  $async.Future<$1.Review> markReviewHelpful(
      $grpc.ServiceCall call, $0.MarkReviewHelpfulRequest request);

  $async.Future<$1.Review> unmarkReviewHelpful_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UnmarkReviewHelpfulRequest> $request) async {
    return unmarkReviewHelpful($call, await $request);
  }

  $async.Future<$1.Review> unmarkReviewHelpful(
      $grpc.ServiceCall call, $0.UnmarkReviewHelpfulRequest request);

  $async.Future<$1.Review> moderateReview_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ModerateReviewRequest> $request) async {
    return moderateReview($call, await $request);
  }

  $async.Future<$1.Review> moderateReview(
      $grpc.ServiceCall call, $0.ModerateReviewRequest request);

  $async.Future<$1.Review> replyToReview_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ReplyToReviewRequest> $request) async {
    return replyToReview($call, await $request);
  }

  $async.Future<$1.Review> replyToReview(
      $grpc.ServiceCall call, $0.ReplyToReviewRequest request);

  $async.Future<$0.ReviewReport> reportReview_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ReportReviewRequest> $request) async {
    return reportReview($call, await $request);
  }

  $async.Future<$0.ReviewReport> reportReview(
      $grpc.ServiceCall call, $0.ReportReviewRequest request);
}
