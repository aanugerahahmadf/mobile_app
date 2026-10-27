// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/order.proto.

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

import 'order.pb.dart' as $0;

export 'order.pb.dart';

/// Order Service
@$pb.GrpcServiceName('wedding.user.v1.OrderService')
class OrderServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  OrderServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.OrderListResponse> getMyOrders(
    $0.GetMyOrdersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getMyOrders, request, options: options);
  }

  $grpc.ResponseFuture<$0.Order> getOrder(
    $0.GetOrderRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getOrder, request, options: options);
  }

  $grpc.ResponseFuture<$0.Order> getOrderByNumber(
    $0.GetOrderByNumberRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getOrderByNumber, request, options: options);
  }

  $grpc.ResponseFuture<$0.OrderListResponse> getOrders(
    $0.GetOrdersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getOrders, request, options: options);
  }

  $grpc.ResponseFuture<$0.OrderStats> getOrderStats(
    $0.GetOrderStatsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getOrderStats, request, options: options);
  }

  $grpc.ResponseFuture<$0.OrderTimelineResponse> getOrderTimeline(
    $0.GetOrderTimelineRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getOrderTimeline, request, options: options);
  }

  $grpc.ResponseFuture<$0.Order> createOrder(
    $0.CreateOrderRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createOrder, request, options: options);
  }

  $grpc.ResponseFuture<$0.Order> cancelOrder(
    $0.CancelOrderRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$cancelOrder, request, options: options);
  }

  $grpc.ResponseFuture<$0.Order> reorder(
    $0.ReorderRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$reorder, request, options: options);
  }

  $grpc.ResponseFuture<$0.Order> updateOrder(
    $0.UpdateOrderRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateOrder, request, options: options);
  }

  $grpc.ResponseFuture<$0.Order> updateOrderStatus(
    $0.UpdateOrderStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateOrderStatus, request, options: options);
  }

  $grpc.ResponseFuture<$0.Order> updatePaymentStatus(
    $0.UpdatePaymentStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updatePaymentStatus, request, options: options);
  }

  $grpc.ResponseFuture<$0.PaymentResult> processPayment(
    $0.ProcessPaymentRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$processPayment, request, options: options);
  }

  $grpc.ResponseFuture<$0.RefundRequestResponse> requestRefund(
    $0.RequestRefundRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$requestRefund, request, options: options);
  }

  // method descriptors

  static final _$getMyOrders =
      $grpc.ClientMethod<$0.GetMyOrdersRequest, $0.OrderListResponse>(
          '/wedding.user.v1.OrderService/GetMyOrders',
          ($0.GetMyOrdersRequest value) => value.writeToBuffer(),
          $0.OrderListResponse.fromBuffer);
  static final _$getOrder = $grpc.ClientMethod<$0.GetOrderRequest, $0.Order>(
      '/wedding.user.v1.OrderService/GetOrder',
      ($0.GetOrderRequest value) => value.writeToBuffer(),
      $0.Order.fromBuffer);
  static final _$getOrderByNumber =
      $grpc.ClientMethod<$0.GetOrderByNumberRequest, $0.Order>(
          '/wedding.user.v1.OrderService/GetOrderByNumber',
          ($0.GetOrderByNumberRequest value) => value.writeToBuffer(),
          $0.Order.fromBuffer);
  static final _$getOrders =
      $grpc.ClientMethod<$0.GetOrdersRequest, $0.OrderListResponse>(
          '/wedding.user.v1.OrderService/GetOrders',
          ($0.GetOrdersRequest value) => value.writeToBuffer(),
          $0.OrderListResponse.fromBuffer);
  static final _$getOrderStats =
      $grpc.ClientMethod<$0.GetOrderStatsRequest, $0.OrderStats>(
          '/wedding.user.v1.OrderService/GetOrderStats',
          ($0.GetOrderStatsRequest value) => value.writeToBuffer(),
          $0.OrderStats.fromBuffer);
  static final _$getOrderTimeline =
      $grpc.ClientMethod<$0.GetOrderTimelineRequest, $0.OrderTimelineResponse>(
          '/wedding.user.v1.OrderService/GetOrderTimeline',
          ($0.GetOrderTimelineRequest value) => value.writeToBuffer(),
          $0.OrderTimelineResponse.fromBuffer);
  static final _$createOrder =
      $grpc.ClientMethod<$0.CreateOrderRequest, $0.Order>(
          '/wedding.user.v1.OrderService/CreateOrder',
          ($0.CreateOrderRequest value) => value.writeToBuffer(),
          $0.Order.fromBuffer);
  static final _$cancelOrder =
      $grpc.ClientMethod<$0.CancelOrderRequest, $0.Order>(
          '/wedding.user.v1.OrderService/CancelOrder',
          ($0.CancelOrderRequest value) => value.writeToBuffer(),
          $0.Order.fromBuffer);
  static final _$reorder = $grpc.ClientMethod<$0.ReorderRequest, $0.Order>(
      '/wedding.user.v1.OrderService/Reorder',
      ($0.ReorderRequest value) => value.writeToBuffer(),
      $0.Order.fromBuffer);
  static final _$updateOrder =
      $grpc.ClientMethod<$0.UpdateOrderRequest, $0.Order>(
          '/wedding.user.v1.OrderService/UpdateOrder',
          ($0.UpdateOrderRequest value) => value.writeToBuffer(),
          $0.Order.fromBuffer);
  static final _$updateOrderStatus =
      $grpc.ClientMethod<$0.UpdateOrderStatusRequest, $0.Order>(
          '/wedding.user.v1.OrderService/UpdateOrderStatus',
          ($0.UpdateOrderStatusRequest value) => value.writeToBuffer(),
          $0.Order.fromBuffer);
  static final _$updatePaymentStatus =
      $grpc.ClientMethod<$0.UpdatePaymentStatusRequest, $0.Order>(
          '/wedding.user.v1.OrderService/UpdatePaymentStatus',
          ($0.UpdatePaymentStatusRequest value) => value.writeToBuffer(),
          $0.Order.fromBuffer);
  static final _$processPayment =
      $grpc.ClientMethod<$0.ProcessPaymentRequest, $0.PaymentResult>(
          '/wedding.user.v1.OrderService/ProcessPayment',
          ($0.ProcessPaymentRequest value) => value.writeToBuffer(),
          $0.PaymentResult.fromBuffer);
  static final _$requestRefund =
      $grpc.ClientMethod<$0.RequestRefundRequest, $0.RefundRequestResponse>(
          '/wedding.user.v1.OrderService/RequestRefund',
          ($0.RequestRefundRequest value) => value.writeToBuffer(),
          $0.RefundRequestResponse.fromBuffer);
}

@$pb.GrpcServiceName('wedding.user.v1.OrderService')
abstract class OrderServiceBase extends $grpc.Service {
  $core.String get $name => 'wedding.user.v1.OrderService';

  OrderServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetMyOrdersRequest, $0.OrderListResponse>(
        'GetMyOrders',
        getMyOrders_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetMyOrdersRequest.fromBuffer(value),
        ($0.OrderListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetOrderRequest, $0.Order>(
        'GetOrder',
        getOrder_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetOrderRequest.fromBuffer(value),
        ($0.Order value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetOrderByNumberRequest, $0.Order>(
        'GetOrderByNumber',
        getOrderByNumber_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetOrderByNumberRequest.fromBuffer(value),
        ($0.Order value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetOrdersRequest, $0.OrderListResponse>(
        'GetOrders',
        getOrders_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetOrdersRequest.fromBuffer(value),
        ($0.OrderListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetOrderStatsRequest, $0.OrderStats>(
        'GetOrderStats',
        getOrderStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetOrderStatsRequest.fromBuffer(value),
        ($0.OrderStats value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetOrderTimelineRequest,
            $0.OrderTimelineResponse>(
        'GetOrderTimeline',
        getOrderTimeline_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetOrderTimelineRequest.fromBuffer(value),
        ($0.OrderTimelineResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CreateOrderRequest, $0.Order>(
        'CreateOrder',
        createOrder_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CreateOrderRequest.fromBuffer(value),
        ($0.Order value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CancelOrderRequest, $0.Order>(
        'CancelOrder',
        cancelOrder_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CancelOrderRequest.fromBuffer(value),
        ($0.Order value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ReorderRequest, $0.Order>(
        'Reorder',
        reorder_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ReorderRequest.fromBuffer(value),
        ($0.Order value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateOrderRequest, $0.Order>(
        'UpdateOrder',
        updateOrder_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateOrderRequest.fromBuffer(value),
        ($0.Order value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateOrderStatusRequest, $0.Order>(
        'UpdateOrderStatus',
        updateOrderStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateOrderStatusRequest.fromBuffer(value),
        ($0.Order value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdatePaymentStatusRequest, $0.Order>(
        'UpdatePaymentStatus',
        updatePaymentStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdatePaymentStatusRequest.fromBuffer(value),
        ($0.Order value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ProcessPaymentRequest, $0.PaymentResult>(
        'ProcessPayment',
        processPayment_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ProcessPaymentRequest.fromBuffer(value),
        ($0.PaymentResult value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.RequestRefundRequest, $0.RefundRequestResponse>(
            'RequestRefund',
            requestRefund_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.RequestRefundRequest.fromBuffer(value),
            ($0.RefundRequestResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.OrderListResponse> getMyOrders_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetMyOrdersRequest> $request) async {
    return getMyOrders($call, await $request);
  }

  $async.Future<$0.OrderListResponse> getMyOrders(
      $grpc.ServiceCall call, $0.GetMyOrdersRequest request);

  $async.Future<$0.Order> getOrder_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetOrderRequest> $request) async {
    return getOrder($call, await $request);
  }

  $async.Future<$0.Order> getOrder(
      $grpc.ServiceCall call, $0.GetOrderRequest request);

  $async.Future<$0.Order> getOrderByNumber_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetOrderByNumberRequest> $request) async {
    return getOrderByNumber($call, await $request);
  }

  $async.Future<$0.Order> getOrderByNumber(
      $grpc.ServiceCall call, $0.GetOrderByNumberRequest request);

  $async.Future<$0.OrderListResponse> getOrders_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetOrdersRequest> $request) async {
    return getOrders($call, await $request);
  }

  $async.Future<$0.OrderListResponse> getOrders(
      $grpc.ServiceCall call, $0.GetOrdersRequest request);

  $async.Future<$0.OrderStats> getOrderStats_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetOrderStatsRequest> $request) async {
    return getOrderStats($call, await $request);
  }

  $async.Future<$0.OrderStats> getOrderStats(
      $grpc.ServiceCall call, $0.GetOrderStatsRequest request);

  $async.Future<$0.OrderTimelineResponse> getOrderTimeline_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetOrderTimelineRequest> $request) async {
    return getOrderTimeline($call, await $request);
  }

  $async.Future<$0.OrderTimelineResponse> getOrderTimeline(
      $grpc.ServiceCall call, $0.GetOrderTimelineRequest request);

  $async.Future<$0.Order> createOrder_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CreateOrderRequest> $request) async {
    return createOrder($call, await $request);
  }

  $async.Future<$0.Order> createOrder(
      $grpc.ServiceCall call, $0.CreateOrderRequest request);

  $async.Future<$0.Order> cancelOrder_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CancelOrderRequest> $request) async {
    return cancelOrder($call, await $request);
  }

  $async.Future<$0.Order> cancelOrder(
      $grpc.ServiceCall call, $0.CancelOrderRequest request);

  $async.Future<$0.Order> reorder_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ReorderRequest> $request) async {
    return reorder($call, await $request);
  }

  $async.Future<$0.Order> reorder(
      $grpc.ServiceCall call, $0.ReorderRequest request);

  $async.Future<$0.Order> updateOrder_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateOrderRequest> $request) async {
    return updateOrder($call, await $request);
  }

  $async.Future<$0.Order> updateOrder(
      $grpc.ServiceCall call, $0.UpdateOrderRequest request);

  $async.Future<$0.Order> updateOrderStatus_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateOrderStatusRequest> $request) async {
    return updateOrderStatus($call, await $request);
  }

  $async.Future<$0.Order> updateOrderStatus(
      $grpc.ServiceCall call, $0.UpdateOrderStatusRequest request);

  $async.Future<$0.Order> updatePaymentStatus_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdatePaymentStatusRequest> $request) async {
    return updatePaymentStatus($call, await $request);
  }

  $async.Future<$0.Order> updatePaymentStatus(
      $grpc.ServiceCall call, $0.UpdatePaymentStatusRequest request);

  $async.Future<$0.PaymentResult> processPayment_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ProcessPaymentRequest> $request) async {
    return processPayment($call, await $request);
  }

  $async.Future<$0.PaymentResult> processPayment(
      $grpc.ServiceCall call, $0.ProcessPaymentRequest request);

  $async.Future<$0.RefundRequestResponse> requestRefund_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RequestRefundRequest> $request) async {
    return requestRefund($call, await $request);
  }

  $async.Future<$0.RefundRequestResponse> requestRefund(
      $grpc.ServiceCall call, $0.RequestRefundRequest request);
}
