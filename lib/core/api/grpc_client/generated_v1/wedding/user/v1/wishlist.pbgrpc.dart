// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/wishlist.proto.

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

import 'cart.pb.dart' as $1;
import 'wishlist.pb.dart' as $0;

export 'wishlist.pb.dart';

/// Wishlist Service
@$pb.GrpcServiceName('wedding.user.v1.WishlistService')
class WishlistServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  WishlistServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.WishlistListResponse> getMyWishlist(
    $0.GetMyWishlistRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getMyWishlist, request, options: options);
  }

  $grpc.ResponseFuture<$0.IsInWishlistResponse> isInWishlist(
    $0.IsInWishlistRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$isInWishlist, request, options: options);
  }

  $grpc.ResponseFuture<$0.WishlistActionResponse> toggleWishlist(
    $0.ToggleWishlistRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$toggleWishlist, request, options: options);
  }

  $grpc.ResponseFuture<$0.Wishlist> addToWishlist(
    $0.AddToWishlistRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$addToWishlist, request, options: options);
  }

  $grpc.ResponseFuture<$0.RemoveFromWishlistResponse> removeFromWishlist(
    $0.RemoveFromWishlistRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$removeFromWishlist, request, options: options);
  }

  $grpc.ResponseFuture<$0.ClearWishlistResponse> clearWishlist(
    $0.ClearWishlistRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$clearWishlist, request, options: options);
  }

  $grpc.ResponseFuture<$1.CartItem> moveToCart(
    $0.MoveToCartRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$moveToCart, request, options: options);
  }

  $grpc.ResponseFuture<$0.WishlistShare> shareWishlist(
    $0.ShareWishlistRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$shareWishlist, request, options: options);
  }

  // method descriptors

  static final _$getMyWishlist =
      $grpc.ClientMethod<$0.GetMyWishlistRequest, $0.WishlistListResponse>(
          '/wedding.user.v1.WishlistService/GetMyWishlist',
          ($0.GetMyWishlistRequest value) => value.writeToBuffer(),
          $0.WishlistListResponse.fromBuffer);
  static final _$isInWishlist =
      $grpc.ClientMethod<$0.IsInWishlistRequest, $0.IsInWishlistResponse>(
          '/wedding.user.v1.WishlistService/IsInWishlist',
          ($0.IsInWishlistRequest value) => value.writeToBuffer(),
          $0.IsInWishlistResponse.fromBuffer);
  static final _$toggleWishlist =
      $grpc.ClientMethod<$0.ToggleWishlistRequest, $0.WishlistActionResponse>(
          '/wedding.user.v1.WishlistService/ToggleWishlist',
          ($0.ToggleWishlistRequest value) => value.writeToBuffer(),
          $0.WishlistActionResponse.fromBuffer);
  static final _$addToWishlist =
      $grpc.ClientMethod<$0.AddToWishlistRequest, $0.Wishlist>(
          '/wedding.user.v1.WishlistService/AddToWishlist',
          ($0.AddToWishlistRequest value) => value.writeToBuffer(),
          $0.Wishlist.fromBuffer);
  static final _$removeFromWishlist = $grpc.ClientMethod<
          $0.RemoveFromWishlistRequest, $0.RemoveFromWishlistResponse>(
      '/wedding.user.v1.WishlistService/RemoveFromWishlist',
      ($0.RemoveFromWishlistRequest value) => value.writeToBuffer(),
      $0.RemoveFromWishlistResponse.fromBuffer);
  static final _$clearWishlist =
      $grpc.ClientMethod<$0.ClearWishlistRequest, $0.ClearWishlistResponse>(
          '/wedding.user.v1.WishlistService/ClearWishlist',
          ($0.ClearWishlistRequest value) => value.writeToBuffer(),
          $0.ClearWishlistResponse.fromBuffer);
  static final _$moveToCart =
      $grpc.ClientMethod<$0.MoveToCartRequest, $1.CartItem>(
          '/wedding.user.v1.WishlistService/MoveToCart',
          ($0.MoveToCartRequest value) => value.writeToBuffer(),
          $1.CartItem.fromBuffer);
  static final _$shareWishlist =
      $grpc.ClientMethod<$0.ShareWishlistRequest, $0.WishlistShare>(
          '/wedding.user.v1.WishlistService/ShareWishlist',
          ($0.ShareWishlistRequest value) => value.writeToBuffer(),
          $0.WishlistShare.fromBuffer);
}

@$pb.GrpcServiceName('wedding.user.v1.WishlistService')
abstract class WishlistServiceBase extends $grpc.Service {
  $core.String get $name => 'wedding.user.v1.WishlistService';

  WishlistServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.GetMyWishlistRequest, $0.WishlistListResponse>(
            'GetMyWishlist',
            getMyWishlist_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetMyWishlistRequest.fromBuffer(value),
            ($0.WishlistListResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.IsInWishlistRequest, $0.IsInWishlistResponse>(
            'IsInWishlist',
            isInWishlist_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.IsInWishlistRequest.fromBuffer(value),
            ($0.IsInWishlistResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ToggleWishlistRequest,
            $0.WishlistActionResponse>(
        'ToggleWishlist',
        toggleWishlist_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ToggleWishlistRequest.fromBuffer(value),
        ($0.WishlistActionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AddToWishlistRequest, $0.Wishlist>(
        'AddToWishlist',
        addToWishlist_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.AddToWishlistRequest.fromBuffer(value),
        ($0.Wishlist value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RemoveFromWishlistRequest,
            $0.RemoveFromWishlistResponse>(
        'RemoveFromWishlist',
        removeFromWishlist_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RemoveFromWishlistRequest.fromBuffer(value),
        ($0.RemoveFromWishlistResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ClearWishlistRequest, $0.ClearWishlistResponse>(
            'ClearWishlist',
            clearWishlist_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ClearWishlistRequest.fromBuffer(value),
            ($0.ClearWishlistResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.MoveToCartRequest, $1.CartItem>(
        'MoveToCart',
        moveToCart_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.MoveToCartRequest.fromBuffer(value),
        ($1.CartItem value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ShareWishlistRequest, $0.WishlistShare>(
        'ShareWishlist',
        shareWishlist_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ShareWishlistRequest.fromBuffer(value),
        ($0.WishlistShare value) => value.writeToBuffer()));
  }

  $async.Future<$0.WishlistListResponse> getMyWishlist_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetMyWishlistRequest> $request) async {
    return getMyWishlist($call, await $request);
  }

  $async.Future<$0.WishlistListResponse> getMyWishlist(
      $grpc.ServiceCall call, $0.GetMyWishlistRequest request);

  $async.Future<$0.IsInWishlistResponse> isInWishlist_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.IsInWishlistRequest> $request) async {
    return isInWishlist($call, await $request);
  }

  $async.Future<$0.IsInWishlistResponse> isInWishlist(
      $grpc.ServiceCall call, $0.IsInWishlistRequest request);

  $async.Future<$0.WishlistActionResponse> toggleWishlist_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ToggleWishlistRequest> $request) async {
    return toggleWishlist($call, await $request);
  }

  $async.Future<$0.WishlistActionResponse> toggleWishlist(
      $grpc.ServiceCall call, $0.ToggleWishlistRequest request);

  $async.Future<$0.Wishlist> addToWishlist_Pre($grpc.ServiceCall $call,
      $async.Future<$0.AddToWishlistRequest> $request) async {
    return addToWishlist($call, await $request);
  }

  $async.Future<$0.Wishlist> addToWishlist(
      $grpc.ServiceCall call, $0.AddToWishlistRequest request);

  $async.Future<$0.RemoveFromWishlistResponse> removeFromWishlist_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RemoveFromWishlistRequest> $request) async {
    return removeFromWishlist($call, await $request);
  }

  $async.Future<$0.RemoveFromWishlistResponse> removeFromWishlist(
      $grpc.ServiceCall call, $0.RemoveFromWishlistRequest request);

  $async.Future<$0.ClearWishlistResponse> clearWishlist_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ClearWishlistRequest> $request) async {
    return clearWishlist($call, await $request);
  }

  $async.Future<$0.ClearWishlistResponse> clearWishlist(
      $grpc.ServiceCall call, $0.ClearWishlistRequest request);

  $async.Future<$1.CartItem> moveToCart_Pre($grpc.ServiceCall $call,
      $async.Future<$0.MoveToCartRequest> $request) async {
    return moveToCart($call, await $request);
  }

  $async.Future<$1.CartItem> moveToCart(
      $grpc.ServiceCall call, $0.MoveToCartRequest request);

  $async.Future<$0.WishlistShare> shareWishlist_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ShareWishlistRequest> $request) async {
    return shareWishlist($call, await $request);
  }

  $async.Future<$0.WishlistShare> shareWishlist(
      $grpc.ServiceCall call, $0.ShareWishlistRequest request);
}
