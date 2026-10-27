// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/home.proto.

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

import 'home.pb.dart' as $0;

export 'home.pb.dart';

/// Home Service
@$pb.GrpcServiceName('wedding.user.v1.HomeService')
class HomeServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  HomeServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.HomeData> getHomeData(
    $0.GetHomeDataRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getHomeData, request, options: options);
  }

  $grpc.ResponseFuture<$0.HeroBannersResponse> getHeroBanners(
    $0.GetHeroBannersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getHeroBanners, request, options: options);
  }

  $grpc.ResponseFuture<$0.PromotionsResponse> getPromotions(
    $0.GetPromotionsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPromotions, request, options: options);
  }

  // method descriptors

  static final _$getHomeData =
      $grpc.ClientMethod<$0.GetHomeDataRequest, $0.HomeData>(
          '/wedding.user.v1.HomeService/GetHomeData',
          ($0.GetHomeDataRequest value) => value.writeToBuffer(),
          $0.HomeData.fromBuffer);
  static final _$getHeroBanners =
      $grpc.ClientMethod<$0.GetHeroBannersRequest, $0.HeroBannersResponse>(
          '/wedding.user.v1.HomeService/GetHeroBanners',
          ($0.GetHeroBannersRequest value) => value.writeToBuffer(),
          $0.HeroBannersResponse.fromBuffer);
  static final _$getPromotions =
      $grpc.ClientMethod<$0.GetPromotionsRequest, $0.PromotionsResponse>(
          '/wedding.user.v1.HomeService/GetPromotions',
          ($0.GetPromotionsRequest value) => value.writeToBuffer(),
          $0.PromotionsResponse.fromBuffer);
}

@$pb.GrpcServiceName('wedding.user.v1.HomeService')
abstract class HomeServiceBase extends $grpc.Service {
  $core.String get $name => 'wedding.user.v1.HomeService';

  HomeServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetHomeDataRequest, $0.HomeData>(
        'GetHomeData',
        getHomeData_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetHomeDataRequest.fromBuffer(value),
        ($0.HomeData value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetHeroBannersRequest, $0.HeroBannersResponse>(
            'GetHeroBanners',
            getHeroBanners_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetHeroBannersRequest.fromBuffer(value),
            ($0.HeroBannersResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetPromotionsRequest, $0.PromotionsResponse>(
            'GetPromotions',
            getPromotions_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetPromotionsRequest.fromBuffer(value),
            ($0.PromotionsResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.HomeData> getHomeData_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetHomeDataRequest> $request) async {
    return getHomeData($call, await $request);
  }

  $async.Future<$0.HomeData> getHomeData(
      $grpc.ServiceCall call, $0.GetHomeDataRequest request);

  $async.Future<$0.HeroBannersResponse> getHeroBanners_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetHeroBannersRequest> $request) async {
    return getHeroBanners($call, await $request);
  }

  $async.Future<$0.HeroBannersResponse> getHeroBanners(
      $grpc.ServiceCall call, $0.GetHeroBannersRequest request);

  $async.Future<$0.PromotionsResponse> getPromotions_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetPromotionsRequest> $request) async {
    return getPromotions($call, await $request);
  }

  $async.Future<$0.PromotionsResponse> getPromotions(
      $grpc.ServiceCall call, $0.GetPromotionsRequest request);
}
