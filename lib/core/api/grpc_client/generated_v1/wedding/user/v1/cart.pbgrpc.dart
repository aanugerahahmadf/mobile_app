// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/cart.proto.

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

import 'cart.pb.dart' as $0;

export 'cart.pb.dart';

/// Cart Service
@$pb.GrpcServiceName('wedding.user.v1.CartService')
class CartServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  CartServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.Cart> getMyCart(
    $0.GetMyCartRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getMyCart, request, options: options);
  }

  $grpc.ResponseFuture<$0.CartItem> addToCart(
    $0.AddToCartRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$addToCart, request, options: options);
  }

  $grpc.ResponseFuture<$0.CartItem> updateCartItem(
    $0.UpdateCartItemRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateCartItem, request, options: options);
  }

  $grpc.ResponseFuture<$0.RemoveFromCartResponse> removeFromCart(
    $0.RemoveFromCartRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$removeFromCart, request, options: options);
  }

  $grpc.ResponseFuture<$0.ClearCartResponse> clearCart(
    $0.ClearCartRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$clearCart, request, options: options);
  }

  $grpc.ResponseFuture<$0.Cart> applyVoucherToCart(
    $0.ApplyVoucherToCartRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$applyVoucherToCart, request, options: options);
  }

  $grpc.ResponseFuture<$0.Cart> removeVoucherFromCart(
    $0.RemoveVoucherFromCartRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$removeVoucherFromCart, request, options: options);
  }

  $grpc.ResponseFuture<$0.Cart> syncCart(
    $0.SyncCartRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$syncCart, request, options: options);
  }

  $grpc.ResponseFuture<$0.ShippingEstimate> estimateShipping(
    $0.EstimateShippingRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$estimateShipping, request, options: options);
  }

  // method descriptors

  static final _$getMyCart = $grpc.ClientMethod<$0.GetMyCartRequest, $0.Cart>(
      '/wedding.user.v1.CartService/GetMyCart',
      ($0.GetMyCartRequest value) => value.writeToBuffer(),
      $0.Cart.fromBuffer);
  static final _$addToCart =
      $grpc.ClientMethod<$0.AddToCartRequest, $0.CartItem>(
          '/wedding.user.v1.CartService/AddToCart',
          ($0.AddToCartRequest value) => value.writeToBuffer(),
          $0.CartItem.fromBuffer);
  static final _$updateCartItem =
      $grpc.ClientMethod<$0.UpdateCartItemRequest, $0.CartItem>(
          '/wedding.user.v1.CartService/UpdateCartItem',
          ($0.UpdateCartItemRequest value) => value.writeToBuffer(),
          $0.CartItem.fromBuffer);
  static final _$removeFromCart =
      $grpc.ClientMethod<$0.RemoveFromCartRequest, $0.RemoveFromCartResponse>(
          '/wedding.user.v1.CartService/RemoveFromCart',
          ($0.RemoveFromCartRequest value) => value.writeToBuffer(),
          $0.RemoveFromCartResponse.fromBuffer);
  static final _$clearCart =
      $grpc.ClientMethod<$0.ClearCartRequest, $0.ClearCartResponse>(
          '/wedding.user.v1.CartService/ClearCart',
          ($0.ClearCartRequest value) => value.writeToBuffer(),
          $0.ClearCartResponse.fromBuffer);
  static final _$applyVoucherToCart =
      $grpc.ClientMethod<$0.ApplyVoucherToCartRequest, $0.Cart>(
          '/wedding.user.v1.CartService/ApplyVoucherToCart',
          ($0.ApplyVoucherToCartRequest value) => value.writeToBuffer(),
          $0.Cart.fromBuffer);
  static final _$removeVoucherFromCart =
      $grpc.ClientMethod<$0.RemoveVoucherFromCartRequest, $0.Cart>(
          '/wedding.user.v1.CartService/RemoveVoucherFromCart',
          ($0.RemoveVoucherFromCartRequest value) => value.writeToBuffer(),
          $0.Cart.fromBuffer);
  static final _$syncCart = $grpc.ClientMethod<$0.SyncCartRequest, $0.Cart>(
      '/wedding.user.v1.CartService/SyncCart',
      ($0.SyncCartRequest value) => value.writeToBuffer(),
      $0.Cart.fromBuffer);
  static final _$estimateShipping =
      $grpc.ClientMethod<$0.EstimateShippingRequest, $0.ShippingEstimate>(
          '/wedding.user.v1.CartService/EstimateShipping',
          ($0.EstimateShippingRequest value) => value.writeToBuffer(),
          $0.ShippingEstimate.fromBuffer);
}

@$pb.GrpcServiceName('wedding.user.v1.CartService')
abstract class CartServiceBase extends $grpc.Service {
  $core.String get $name => 'wedding.user.v1.CartService';

  CartServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetMyCartRequest, $0.Cart>(
        'GetMyCart',
        getMyCart_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetMyCartRequest.fromBuffer(value),
        ($0.Cart value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AddToCartRequest, $0.CartItem>(
        'AddToCart',
        addToCart_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.AddToCartRequest.fromBuffer(value),
        ($0.CartItem value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateCartItemRequest, $0.CartItem>(
        'UpdateCartItem',
        updateCartItem_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateCartItemRequest.fromBuffer(value),
        ($0.CartItem value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RemoveFromCartRequest,
            $0.RemoveFromCartResponse>(
        'RemoveFromCart',
        removeFromCart_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RemoveFromCartRequest.fromBuffer(value),
        ($0.RemoveFromCartResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ClearCartRequest, $0.ClearCartResponse>(
        'ClearCart',
        clearCart_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ClearCartRequest.fromBuffer(value),
        ($0.ClearCartResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ApplyVoucherToCartRequest, $0.Cart>(
        'ApplyVoucherToCart',
        applyVoucherToCart_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ApplyVoucherToCartRequest.fromBuffer(value),
        ($0.Cart value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RemoveVoucherFromCartRequest, $0.Cart>(
        'RemoveVoucherFromCart',
        removeVoucherFromCart_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RemoveVoucherFromCartRequest.fromBuffer(value),
        ($0.Cart value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SyncCartRequest, $0.Cart>(
        'SyncCart',
        syncCart_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SyncCartRequest.fromBuffer(value),
        ($0.Cart value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.EstimateShippingRequest, $0.ShippingEstimate>(
            'EstimateShipping',
            estimateShipping_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.EstimateShippingRequest.fromBuffer(value),
            ($0.ShippingEstimate value) => value.writeToBuffer()));
  }

  $async.Future<$0.Cart> getMyCart_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetMyCartRequest> $request) async {
    return getMyCart($call, await $request);
  }

  $async.Future<$0.Cart> getMyCart(
      $grpc.ServiceCall call, $0.GetMyCartRequest request);

  $async.Future<$0.CartItem> addToCart_Pre($grpc.ServiceCall $call,
      $async.Future<$0.AddToCartRequest> $request) async {
    return addToCart($call, await $request);
  }

  $async.Future<$0.CartItem> addToCart(
      $grpc.ServiceCall call, $0.AddToCartRequest request);

  $async.Future<$0.CartItem> updateCartItem_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateCartItemRequest> $request) async {
    return updateCartItem($call, await $request);
  }

  $async.Future<$0.CartItem> updateCartItem(
      $grpc.ServiceCall call, $0.UpdateCartItemRequest request);

  $async.Future<$0.RemoveFromCartResponse> removeFromCart_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RemoveFromCartRequest> $request) async {
    return removeFromCart($call, await $request);
  }

  $async.Future<$0.RemoveFromCartResponse> removeFromCart(
      $grpc.ServiceCall call, $0.RemoveFromCartRequest request);

  $async.Future<$0.ClearCartResponse> clearCart_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ClearCartRequest> $request) async {
    return clearCart($call, await $request);
  }

  $async.Future<$0.ClearCartResponse> clearCart(
      $grpc.ServiceCall call, $0.ClearCartRequest request);

  $async.Future<$0.Cart> applyVoucherToCart_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ApplyVoucherToCartRequest> $request) async {
    return applyVoucherToCart($call, await $request);
  }

  $async.Future<$0.Cart> applyVoucherToCart(
      $grpc.ServiceCall call, $0.ApplyVoucherToCartRequest request);

  $async.Future<$0.Cart> removeVoucherFromCart_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RemoveVoucherFromCartRequest> $request) async {
    return removeVoucherFromCart($call, await $request);
  }

  $async.Future<$0.Cart> removeVoucherFromCart(
      $grpc.ServiceCall call, $0.RemoveVoucherFromCartRequest request);

  $async.Future<$0.Cart> syncCart_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SyncCartRequest> $request) async {
    return syncCart($call, await $request);
  }

  $async.Future<$0.Cart> syncCart(
      $grpc.ServiceCall call, $0.SyncCartRequest request);

  $async.Future<$0.ShippingEstimate> estimateShipping_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.EstimateShippingRequest> $request) async {
    return estimateShipping($call, await $request);
  }

  $async.Future<$0.ShippingEstimate> estimateShipping(
      $grpc.ServiceCall call, $0.EstimateShippingRequest request);
}
