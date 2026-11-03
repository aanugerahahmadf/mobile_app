// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/order.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use getMyOrdersRequestDescriptor instead')
const GetMyOrdersRequest$json = {
  '1': 'GetMyOrdersRequest',
  '2': [
    {
      '1': 'pagination',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.PaginationRequest',
      '10': 'pagination'
    },
    {'1': 'status', '3': 2, '4': 1, '5': 9, '10': 'status'},
  ],
};

/// Descriptor for `GetMyOrdersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMyOrdersRequestDescriptor = $convert.base64Decode(
    'ChJHZXRNeU9yZGVyc1JlcXVlc3QSQgoKcGFnaW5hdGlvbhgBIAEoCzIiLndlZGRpbmcudXNlci'
    '52MS5QYWdpbmF0aW9uUmVxdWVzdFIKcGFnaW5hdGlvbhIWCgZzdGF0dXMYAiABKAlSBnN0YXR1'
    'cw==');

@$core.Deprecated('Use getOrderRequestDescriptor instead')
const GetOrderRequest$json = {
  '1': 'GetOrderRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `GetOrderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getOrderRequestDescriptor =
    $convert.base64Decode('Cg9HZXRPcmRlclJlcXVlc3QSDgoCaWQYASABKAlSAmlk');

@$core.Deprecated('Use getOrderByNumberRequestDescriptor instead')
const GetOrderByNumberRequest$json = {
  '1': 'GetOrderByNumberRequest',
  '2': [
    {'1': 'order_number', '3': 1, '4': 1, '5': 9, '10': 'orderNumber'},
  ],
};

/// Descriptor for `GetOrderByNumberRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getOrderByNumberRequestDescriptor =
    $convert.base64Decode(
        'ChdHZXRPcmRlckJ5TnVtYmVyUmVxdWVzdBIhCgxvcmRlcl9udW1iZXIYASABKAlSC29yZGVyTn'
        'VtYmVy');

@$core.Deprecated('Use getOrdersRequestDescriptor instead')
const GetOrdersRequest$json = {
  '1': 'GetOrdersRequest',
  '2': [
    {
      '1': 'pagination',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.PaginationRequest',
      '10': 'pagination'
    },
    {'1': 'status', '3': 2, '4': 1, '5': 9, '10': 'status'},
    {'1': 'payment_status', '3': 3, '4': 1, '5': 9, '10': 'paymentStatus'},
    {'1': 'user_id', '3': 4, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'date_from', '3': 5, '4': 1, '5': 9, '10': 'dateFrom'},
    {'1': 'date_to', '3': 6, '4': 1, '5': 9, '10': 'dateTo'},
  ],
};

/// Descriptor for `GetOrdersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getOrdersRequestDescriptor = $convert.base64Decode(
    'ChBHZXRPcmRlcnNSZXF1ZXN0EkIKCnBhZ2luYXRpb24YASABKAsyIi53ZWRkaW5nLnVzZXIudj'
    'EuUGFnaW5hdGlvblJlcXVlc3RSCnBhZ2luYXRpb24SFgoGc3RhdHVzGAIgASgJUgZzdGF0dXMS'
    'JQoOcGF5bWVudF9zdGF0dXMYAyABKAlSDXBheW1lbnRTdGF0dXMSFwoHdXNlcl9pZBgEIAEoCV'
    'IGdXNlcklkEhsKCWRhdGVfZnJvbRgFIAEoCVIIZGF0ZUZyb20SFwoHZGF0ZV90bxgGIAEoCVIG'
    'ZGF0ZVRv');

@$core.Deprecated('Use getOrderStatsRequestDescriptor instead')
const GetOrderStatsRequest$json = {
  '1': 'GetOrderStatsRequest',
};

/// Descriptor for `GetOrderStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getOrderStatsRequestDescriptor =
    $convert.base64Decode('ChRHZXRPcmRlclN0YXRzUmVxdWVzdA==');

@$core.Deprecated('Use getOrderTimelineRequestDescriptor instead')
const GetOrderTimelineRequest$json = {
  '1': 'GetOrderTimelineRequest',
  '2': [
    {'1': 'order_id', '3': 1, '4': 1, '5': 9, '10': 'orderId'},
  ],
};

/// Descriptor for `GetOrderTimelineRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getOrderTimelineRequestDescriptor =
    $convert.base64Decode(
        'ChdHZXRPcmRlclRpbWVsaW5lUmVxdWVzdBIZCghvcmRlcl9pZBgBIAEoCVIHb3JkZXJJZA==');

@$core.Deprecated('Use createOrderRequestDescriptor instead')
const CreateOrderRequest$json = {
  '1': 'CreateOrderRequest',
  '2': [
    {'1': 'catalog_id', '3': 1, '4': 1, '5': 9, '10': 'catalogId'},
    {'1': 'package_id', '3': 2, '4': 1, '5': 9, '10': 'packageId'},
    {'1': 'quantity', '3': 3, '4': 1, '5': 5, '10': 'quantity'},
    {'1': 'booking_date', '3': 4, '4': 1, '5': 9, '10': 'bookingDate'},
    {'1': 'notes', '3': 5, '4': 1, '5': 9, '10': 'notes'},
    {'1': 'address_id', '3': 6, '4': 1, '5': 9, '10': 'addressId'},
    {'1': 'voucher_code', '3': 7, '4': 1, '5': 9, '10': 'voucherCode'},
    {
      '1': 'payment_method',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.wedding.user.v1.PaymentMethod',
      '10': 'paymentMethod'
    },
    {
      '1': 'custom_options',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.MetaData',
      '10': 'customOptions'
    },
  ],
};

/// Descriptor for `CreateOrderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createOrderRequestDescriptor = $convert.base64Decode(
    'ChJDcmVhdGVPcmRlclJlcXVlc3QSHQoKY2F0YWxvZ19pZBgBIAEoCVIJY2F0YWxvZ0lkEh0KCn'
    'BhY2thZ2VfaWQYAiABKAlSCXBhY2thZ2VJZBIaCghxdWFudGl0eRgDIAEoBVIIcXVhbnRpdHkS'
    'IQoMYm9va2luZ19kYXRlGAQgASgJUgtib29raW5nRGF0ZRIUCgVub3RlcxgFIAEoCVIFbm90ZX'
    'MSHQoKYWRkcmVzc19pZBgGIAEoCVIJYWRkcmVzc0lkEiEKDHZvdWNoZXJfY29kZRgHIAEoCVIL'
    'dm91Y2hlckNvZGUSRQoOcGF5bWVudF9tZXRob2QYCCABKA4yHi53ZWRkaW5nLnVzZXIudjEuUG'
    'F5bWVudE1ldGhvZFINcGF5bWVudE1ldGhvZBJACg5jdXN0b21fb3B0aW9ucxgJIAEoCzIZLndl'
    'ZGRpbmcudXNlci52MS5NZXRhRGF0YVINY3VzdG9tT3B0aW9ucw==');

@$core.Deprecated('Use cancelOrderRequestDescriptor instead')
const CancelOrderRequest$json = {
  '1': 'CancelOrderRequest',
  '2': [
    {'1': 'order_id', '3': 1, '4': 1, '5': 9, '10': 'orderId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'reason_detail', '3': 3, '4': 1, '5': 9, '10': 'reasonDetail'},
  ],
};

/// Descriptor for `CancelOrderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelOrderRequestDescriptor = $convert.base64Decode(
    'ChJDYW5jZWxPcmRlclJlcXVlc3QSGQoIb3JkZXJfaWQYASABKAlSB29yZGVySWQSFgoGcmVhc2'
    '9uGAIgASgJUgZyZWFzb24SIwoNcmVhc29uX2RldGFpbBgDIAEoCVIMcmVhc29uRGV0YWls');

@$core.Deprecated('Use reorderRequestDescriptor instead')
const ReorderRequest$json = {
  '1': 'ReorderRequest',
  '2': [
    {'1': 'order_id', '3': 1, '4': 1, '5': 9, '10': 'orderId'},
  ],
};

/// Descriptor for `ReorderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reorderRequestDescriptor = $convert.base64Decode(
    'Cg5SZW9yZGVyUmVxdWVzdBIZCghvcmRlcl9pZBgBIAEoCVIHb3JkZXJJZA==');

@$core.Deprecated('Use updateOrderRequestDescriptor instead')
const UpdateOrderRequest$json = {
  '1': 'UpdateOrderRequest',
  '2': [
    {'1': 'order_id', '3': 1, '4': 1, '5': 9, '10': 'orderId'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.wedding.user.v1.OrderStatus',
      '10': 'status'
    },
    {
      '1': 'payment_status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.wedding.user.v1.PaymentStatus',
      '10': 'paymentStatus'
    },
    {'1': 'notes', '3': 4, '4': 1, '5': 9, '10': 'notes'},
    {'1': 'tracking_number', '3': 5, '4': 1, '5': 9, '10': 'trackingNumber'},
    {
      '1': 'estimated_delivery',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'estimatedDelivery'
    },
  ],
};

/// Descriptor for `UpdateOrderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateOrderRequestDescriptor = $convert.base64Decode(
    'ChJVcGRhdGVPcmRlclJlcXVlc3QSGQoIb3JkZXJfaWQYASABKAlSB29yZGVySWQSNAoGc3RhdH'
    'VzGAIgASgOMhwud2VkZGluZy51c2VyLnYxLk9yZGVyU3RhdHVzUgZzdGF0dXMSRQoOcGF5bWVu'
    'dF9zdGF0dXMYAyABKA4yHi53ZWRkaW5nLnVzZXIudjEuUGF5bWVudFN0YXR1c1INcGF5bWVudF'
    'N0YXR1cxIUCgVub3RlcxgEIAEoCVIFbm90ZXMSJwoPdHJhY2tpbmdfbnVtYmVyGAUgASgJUg50'
    'cmFja2luZ051bWJlchItChJlc3RpbWF0ZWRfZGVsaXZlcnkYBiABKAlSEWVzdGltYXRlZERlbG'
    'l2ZXJ5');

@$core.Deprecated('Use updateOrderStatusRequestDescriptor instead')
const UpdateOrderStatusRequest$json = {
  '1': 'UpdateOrderStatusRequest',
  '2': [
    {'1': 'order_id', '3': 1, '4': 1, '5': 9, '10': 'orderId'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.wedding.user.v1.OrderStatus',
      '10': 'status'
    },
  ],
};

/// Descriptor for `UpdateOrderStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateOrderStatusRequestDescriptor =
    $convert.base64Decode(
        'ChhVcGRhdGVPcmRlclN0YXR1c1JlcXVlc3QSGQoIb3JkZXJfaWQYASABKAlSB29yZGVySWQSNA'
        'oGc3RhdHVzGAIgASgOMhwud2VkZGluZy51c2VyLnYxLk9yZGVyU3RhdHVzUgZzdGF0dXM=');

@$core.Deprecated('Use updatePaymentStatusRequestDescriptor instead')
const UpdatePaymentStatusRequest$json = {
  '1': 'UpdatePaymentStatusRequest',
  '2': [
    {'1': 'order_id', '3': 1, '4': 1, '5': 9, '10': 'orderId'},
    {
      '1': 'payment_status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.wedding.user.v1.PaymentStatus',
      '10': 'paymentStatus'
    },
  ],
};

/// Descriptor for `UpdatePaymentStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatePaymentStatusRequestDescriptor =
    $convert.base64Decode(
        'ChpVcGRhdGVQYXltZW50U3RhdHVzUmVxdWVzdBIZCghvcmRlcl9pZBgBIAEoCVIHb3JkZXJJZB'
        'JFCg5wYXltZW50X3N0YXR1cxgCIAEoDjIeLndlZGRpbmcudXNlci52MS5QYXltZW50U3RhdHVz'
        'Ug1wYXltZW50U3RhdHVz');

@$core.Deprecated('Use processPaymentRequestDescriptor instead')
const ProcessPaymentRequest$json = {
  '1': 'ProcessPaymentRequest',
  '2': [
    {'1': 'order_id', '3': 1, '4': 1, '5': 9, '10': 'orderId'},
    {
      '1': 'payment_data',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.MetaData',
      '10': 'paymentData'
    },
  ],
};

/// Descriptor for `ProcessPaymentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List processPaymentRequestDescriptor = $convert.base64Decode(
    'ChVQcm9jZXNzUGF5bWVudFJlcXVlc3QSGQoIb3JkZXJfaWQYASABKAlSB29yZGVySWQSPAoMcG'
    'F5bWVudF9kYXRhGAIgASgLMhkud2VkZGluZy51c2VyLnYxLk1ldGFEYXRhUgtwYXltZW50RGF0'
    'YQ==');

@$core.Deprecated('Use requestRefundRequestDescriptor instead')
const RequestRefundRequest$json = {
  '1': 'RequestRefundRequest',
  '2': [
    {'1': 'order_id', '3': 1, '4': 1, '5': 9, '10': 'orderId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'amount', '3': 3, '4': 1, '5': 1, '10': 'amount'},
  ],
};

/// Descriptor for `RequestRefundRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestRefundRequestDescriptor = $convert.base64Decode(
    'ChRSZXF1ZXN0UmVmdW5kUmVxdWVzdBIZCghvcmRlcl9pZBgBIAEoCVIHb3JkZXJJZBIWCgZyZW'
    'Fzb24YAiABKAlSBnJlYXNvbhIWCgZhbW91bnQYAyABKAFSBmFtb3VudA==');

@$core.Deprecated('Use orderListResponseDescriptor instead')
const OrderListResponse$json = {
  '1': 'OrderListResponse',
  '2': [
    {
      '1': 'orders',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.Order',
      '10': 'orders'
    },
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.PaginationResponse',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `OrderListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderListResponseDescriptor = $convert.base64Decode(
    'ChFPcmRlckxpc3RSZXNwb25zZRIuCgZvcmRlcnMYASADKAsyFi53ZWRkaW5nLnVzZXIudjEuT3'
    'JkZXJSBm9yZGVycxJDCgpwYWdpbmF0aW9uGAIgASgLMiMud2VkZGluZy51c2VyLnYxLlBhZ2lu'
    'YXRpb25SZXNwb25zZVIKcGFnaW5hdGlvbg==');

@$core.Deprecated('Use orderTimelineResponseDescriptor instead')
const OrderTimelineResponse$json = {
  '1': 'OrderTimelineResponse',
  '2': [
    {
      '1': 'timeline',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.OrderTimeline',
      '10': 'timeline'
    },
  ],
};

/// Descriptor for `OrderTimelineResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderTimelineResponseDescriptor = $convert.base64Decode(
    'ChVPcmRlclRpbWVsaW5lUmVzcG9uc2USOgoIdGltZWxpbmUYASADKAsyHi53ZWRkaW5nLnVzZX'
    'IudjEuT3JkZXJUaW1lbGluZVIIdGltZWxpbmU=');

@$core.Deprecated('Use orderStatsDescriptor instead')
const OrderStats$json = {
  '1': 'OrderStats',
  '2': [
    {'1': 'total_orders', '3': 1, '4': 1, '5': 5, '10': 'totalOrders'},
    {'1': 'pending_orders', '3': 2, '4': 1, '5': 5, '10': 'pendingOrders'},
    {'1': 'confirmed_orders', '3': 3, '4': 1, '5': 5, '10': 'confirmedOrders'},
    {
      '1': 'processing_orders',
      '3': 4,
      '4': 1,
      '5': 5,
      '10': 'processingOrders'
    },
    {'1': 'shipped_orders', '3': 5, '4': 1, '5': 5, '10': 'shippedOrders'},
    {'1': 'delivered_orders', '3': 6, '4': 1, '5': 5, '10': 'deliveredOrders'},
    {'1': 'cancelled_orders', '3': 7, '4': 1, '5': 5, '10': 'cancelledOrders'},
    {'1': 'total_revenue', '3': 8, '4': 1, '5': 1, '10': 'totalRevenue'},
    {'1': 'pending_revenue', '3': 9, '4': 1, '5': 1, '10': 'pendingRevenue'},
    {
      '1': 'this_month_revenue',
      '3': 10,
      '4': 1,
      '5': 1,
      '10': 'thisMonthRevenue'
    },
    {
      '1': 'average_order_value',
      '3': 11,
      '4': 1,
      '5': 1,
      '10': 'averageOrderValue'
    },
    {
      '1': 'by_status',
      '3': 12,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.OrderStatusCount',
      '10': 'byStatus'
    },
    {
      '1': 'by_payment_status',
      '3': 13,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.OrderPaymentStatusCount',
      '10': 'byPaymentStatus'
    },
  ],
};

/// Descriptor for `OrderStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderStatsDescriptor = $convert.base64Decode(
    'CgpPcmRlclN0YXRzEiEKDHRvdGFsX29yZGVycxgBIAEoBVILdG90YWxPcmRlcnMSJQoOcGVuZG'
    'luZ19vcmRlcnMYAiABKAVSDXBlbmRpbmdPcmRlcnMSKQoQY29uZmlybWVkX29yZGVycxgDIAEo'
    'BVIPY29uZmlybWVkT3JkZXJzEisKEXByb2Nlc3Npbmdfb3JkZXJzGAQgASgFUhBwcm9jZXNzaW'
    '5nT3JkZXJzEiUKDnNoaXBwZWRfb3JkZXJzGAUgASgFUg1zaGlwcGVkT3JkZXJzEikKEGRlbGl2'
    'ZXJlZF9vcmRlcnMYBiABKAVSD2RlbGl2ZXJlZE9yZGVycxIpChBjYW5jZWxsZWRfb3JkZXJzGA'
    'cgASgFUg9jYW5jZWxsZWRPcmRlcnMSIwoNdG90YWxfcmV2ZW51ZRgIIAEoAVIMdG90YWxSZXZl'
    'bnVlEicKD3BlbmRpbmdfcmV2ZW51ZRgJIAEoAVIOcGVuZGluZ1JldmVudWUSLAoSdGhpc19tb2'
    '50aF9yZXZlbnVlGAogASgBUhB0aGlzTW9udGhSZXZlbnVlEi4KE2F2ZXJhZ2Vfb3JkZXJfdmFs'
    'dWUYCyABKAFSEWF2ZXJhZ2VPcmRlclZhbHVlEj4KCWJ5X3N0YXR1cxgMIAMoCzIhLndlZGRpbm'
    'cudXNlci52MS5PcmRlclN0YXR1c0NvdW50UghieVN0YXR1cxJUChFieV9wYXltZW50X3N0YXR1'
    'cxgNIAMoCzIoLndlZGRpbmcudXNlci52MS5PcmRlclBheW1lbnRTdGF0dXNDb3VudFIPYnlQYX'
    'ltZW50U3RhdHVz');

@$core.Deprecated('Use orderDescriptor instead')
const Order$json = {
  '1': 'Order',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'order_number', '3': 2, '4': 1, '5': 9, '10': 'orderNumber'},
    {
      '1': 'user',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.User',
      '10': 'user'
    },
    {
      '1': 'package',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.Package',
      '10': 'package'
    },
    {
      '1': 'catalog',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.Catalog',
      '10': 'catalog'
    },
    {'1': 'total_price', '3': 6, '4': 1, '5': 1, '10': 'totalPrice'},
    {'1': 'status', '3': 7, '4': 1, '5': 9, '10': 'status'},
    {'1': 'payment_status', '3': 8, '4': 1, '5': 9, '10': 'paymentStatus'},
    {'1': 'booking_date', '3': 9, '4': 1, '5': 9, '10': 'bookingDate'},
    {'1': 'quantity', '3': 10, '4': 1, '5': 5, '10': 'quantity'},
    {'1': 'notes', '3': 11, '4': 1, '5': 9, '10': 'notes'},
    {
      '1': 'address',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.OrderAddress',
      '10': 'address'
    },
    {
      '1': 'voucher',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.Voucher',
      '10': 'voucher'
    },
    {
      '1': 'payment',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.OrderPayment',
      '10': 'payment'
    },
    {
      '1': 'timeline',
      '3': 15,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.OrderTimeline',
      '10': 'timeline'
    },
    {'1': 'created_at', '3': 16, '4': 1, '5': 9, '10': 'createdAt'},
    {'1': 'updated_at', '3': 17, '4': 1, '5': 9, '10': 'updatedAt'},
  ],
};

/// Descriptor for `Order`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderDescriptor = $convert.base64Decode(
    'CgVPcmRlchIOCgJpZBgBIAEoCVICaWQSIQoMb3JkZXJfbnVtYmVyGAIgASgJUgtvcmRlck51bW'
    'JlchIpCgR1c2VyGAMgASgLMhUud2VkZGluZy51c2VyLnYxLlVzZXJSBHVzZXISMgoHcGFja2Fn'
    'ZRgEIAEoCzIYLndlZGRpbmcudXNlci52MS5QYWNrYWdlUgdwYWNrYWdlEjIKB2NhdGFsb2cYBS'
    'ABKAsyGC53ZWRkaW5nLnVzZXIudjEuQ2F0YWxvZ1IHY2F0YWxvZxIfCgt0b3RhbF9wcmljZRgG'
    'IAEoAVIKdG90YWxQcmljZRIWCgZzdGF0dXMYByABKAlSBnN0YXR1cxIlCg5wYXltZW50X3N0YX'
    'R1cxgIIAEoCVINcGF5bWVudFN0YXR1cxIhCgxib29raW5nX2RhdGUYCSABKAlSC2Jvb2tpbmdE'
    'YXRlEhoKCHF1YW50aXR5GAogASgFUghxdWFudGl0eRIUCgVub3RlcxgLIAEoCVIFbm90ZXMSNw'
    'oHYWRkcmVzcxgMIAEoCzIdLndlZGRpbmcudXNlci52MS5PcmRlckFkZHJlc3NSB2FkZHJlc3MS'
    'MgoHdm91Y2hlchgNIAEoCzIYLndlZGRpbmcudXNlci52MS5Wb3VjaGVyUgd2b3VjaGVyEjcKB3'
    'BheW1lbnQYDiABKAsyHS53ZWRkaW5nLnVzZXIudjEuT3JkZXJQYXltZW50UgdwYXltZW50EjoK'
    'CHRpbWVsaW5lGA8gAygLMh4ud2VkZGluZy51c2VyLnYxLk9yZGVyVGltZWxpbmVSCHRpbWVsaW'
    '5lEh0KCmNyZWF0ZWRfYXQYECABKAlSCWNyZWF0ZWRBdBIdCgp1cGRhdGVkX2F0GBEgASgJUgl1'
    'cGRhdGVkQXQ=');

@$core.Deprecated('Use orderAddressDescriptor instead')
const OrderAddress$json = {
  '1': 'OrderAddress',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'phone', '3': 3, '4': 1, '5': 9, '10': 'phone'},
    {'1': 'address', '3': 4, '4': 1, '5': 9, '10': 'address'},
    {'1': 'city', '3': 5, '4': 1, '5': 9, '10': 'city'},
    {'1': 'province', '3': 6, '4': 1, '5': 9, '10': 'province'},
    {'1': 'postal_code', '3': 7, '4': 1, '5': 9, '10': 'postalCode'},
    {'1': 'is_default', '3': 8, '4': 1, '5': 8, '10': 'isDefault'},
  ],
};

/// Descriptor for `OrderAddress`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderAddressDescriptor = $convert.base64Decode(
    'CgxPcmRlckFkZHJlc3MSDgoCaWQYASABKAlSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSFAoFcG'
    'hvbmUYAyABKAlSBXBob25lEhgKB2FkZHJlc3MYBCABKAlSB2FkZHJlc3MSEgoEY2l0eRgFIAEo'
    'CVIEY2l0eRIaCghwcm92aW5jZRgGIAEoCVIIcHJvdmluY2USHwoLcG9zdGFsX2NvZGUYByABKA'
    'lSCnBvc3RhbENvZGUSHQoKaXNfZGVmYXVsdBgIIAEoCFIJaXNEZWZhdWx0');

@$core.Deprecated('Use orderPaymentDescriptor instead')
const OrderPayment$json = {
  '1': 'OrderPayment',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'method', '3': 2, '4': 1, '5': 9, '10': 'method'},
    {'1': 'status', '3': 3, '4': 1, '5': 9, '10': 'status'},
    {'1': 'amount', '3': 4, '4': 1, '5': 1, '10': 'amount'},
    {'1': 'paid_at', '3': 5, '4': 1, '5': 9, '10': 'paidAt'},
    {'1': 'transaction_id', '3': 6, '4': 1, '5': 9, '10': 'transactionId'},
    {'1': 'proof_url', '3': 7, '4': 1, '5': 9, '10': 'proofUrl'},
  ],
};

/// Descriptor for `OrderPayment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderPaymentDescriptor = $convert.base64Decode(
    'CgxPcmRlclBheW1lbnQSDgoCaWQYASABKAlSAmlkEhYKBm1ldGhvZBgCIAEoCVIGbWV0aG9kEh'
    'YKBnN0YXR1cxgDIAEoCVIGc3RhdHVzEhYKBmFtb3VudBgEIAEoAVIGYW1vdW50EhcKB3BhaWRf'
    'YXQYBSABKAlSBnBhaWRBdBIlCg50cmFuc2FjdGlvbl9pZBgGIAEoCVINdHJhbnNhY3Rpb25JZB'
    'IbCglwcm9vZl91cmwYByABKAlSCHByb29mVXJs');

@$core.Deprecated('Use orderTimelineDescriptor instead')
const OrderTimeline$json = {
  '1': 'OrderTimeline',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'order_id', '3': 2, '4': 1, '5': 9, '10': 'orderId'},
    {'1': 'status', '3': 3, '4': 1, '5': 9, '10': 'status'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'metadata',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.MetaData',
      '10': 'metadata'
    },
    {'1': 'created_at', '3': 6, '4': 1, '5': 9, '10': 'createdAt'},
    {
      '1': 'created_by',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.User',
      '10': 'createdBy'
    },
  ],
};

/// Descriptor for `OrderTimeline`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderTimelineDescriptor = $convert.base64Decode(
    'Cg1PcmRlclRpbWVsaW5lEg4KAmlkGAEgASgJUgJpZBIZCghvcmRlcl9pZBgCIAEoCVIHb3JkZX'
    'JJZBIWCgZzdGF0dXMYAyABKAlSBnN0YXR1cxIgCgtkZXNjcmlwdGlvbhgEIAEoCVILZGVzY3Jp'
    'cHRpb24SNQoIbWV0YWRhdGEYBSABKAsyGS53ZWRkaW5nLnVzZXIudjEuTWV0YURhdGFSCG1ldG'
    'FkYXRhEh0KCmNyZWF0ZWRfYXQYBiABKAlSCWNyZWF0ZWRBdBI0CgpjcmVhdGVkX2J5GAcgASgL'
    'MhUud2VkZGluZy51c2VyLnYxLlVzZXJSCWNyZWF0ZWRCeQ==');

@$core.Deprecated('Use orderStatusCountDescriptor instead')
const OrderStatusCount$json = {
  '1': 'OrderStatusCount',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 9, '10': 'status'},
    {'1': 'count', '3': 2, '4': 1, '5': 5, '10': 'count'},
  ],
};

/// Descriptor for `OrderStatusCount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderStatusCountDescriptor = $convert.base64Decode(
    'ChBPcmRlclN0YXR1c0NvdW50EhYKBnN0YXR1cxgBIAEoCVIGc3RhdHVzEhQKBWNvdW50GAIgAS'
    'gFUgVjb3VudA==');

@$core.Deprecated('Use orderPaymentStatusCountDescriptor instead')
const OrderPaymentStatusCount$json = {
  '1': 'OrderPaymentStatusCount',
  '2': [
    {'1': 'payment_status', '3': 1, '4': 1, '5': 9, '10': 'paymentStatus'},
    {'1': 'count', '3': 2, '4': 1, '5': 5, '10': 'count'},
  ],
};

/// Descriptor for `OrderPaymentStatusCount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderPaymentStatusCountDescriptor =
    $convert.base64Decode(
        'ChdPcmRlclBheW1lbnRTdGF0dXNDb3VudBIlCg5wYXltZW50X3N0YXR1cxgBIAEoCVINcGF5bW'
        'VudFN0YXR1cxIUCgVjb3VudBgCIAEoBVIFY291bnQ=');

@$core.Deprecated('Use paymentResultDescriptor instead')
const PaymentResult$json = {
  '1': 'PaymentResult',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {
      '1': 'order',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.Order',
      '10': 'order'
    },
    {'1': 'redirect_url', '3': 3, '4': 1, '5': 9, '10': 'redirectUrl'},
    {'1': 'message', '3': 4, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `PaymentResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paymentResultDescriptor = $convert.base64Decode(
    'Cg1QYXltZW50UmVzdWx0EhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSLAoFb3JkZXIYAiABKA'
    'syFi53ZWRkaW5nLnVzZXIudjEuT3JkZXJSBW9yZGVyEiEKDHJlZGlyZWN0X3VybBgDIAEoCVIL'
    'cmVkaXJlY3RVcmwSGAoHbWVzc2FnZRgEIAEoCVIHbWVzc2FnZQ==');

@$core.Deprecated('Use refundRequestResponseDescriptor instead')
const RefundRequestResponse$json = {
  '1': 'RefundRequestResponse',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {
      '1': 'order',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.Order',
      '10': 'order'
    },
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'amount', '3': 4, '4': 1, '5': 1, '10': 'amount'},
    {
      '1': 'status',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.wedding.user.v1.RefundStatus',
      '10': 'status'
    },
    {'1': 'requested_at', '3': 6, '4': 1, '5': 9, '10': 'requestedAt'},
    {'1': 'processed_at', '3': 7, '4': 1, '5': 9, '10': 'processedAt'},
  ],
};

/// Descriptor for `RefundRequestResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refundRequestResponseDescriptor = $convert.base64Decode(
    'ChVSZWZ1bmRSZXF1ZXN0UmVzcG9uc2USDgoCaWQYASABKAlSAmlkEiwKBW9yZGVyGAIgASgLMh'
    'Yud2VkZGluZy51c2VyLnYxLk9yZGVyUgVvcmRlchIWCgZyZWFzb24YAyABKAlSBnJlYXNvbhIW'
    'CgZhbW91bnQYBCABKAFSBmFtb3VudBI1CgZzdGF0dXMYBSABKA4yHS53ZWRkaW5nLnVzZXIudj'
    'EuUmVmdW5kU3RhdHVzUgZzdGF0dXMSIQoMcmVxdWVzdGVkX2F0GAYgASgJUgtyZXF1ZXN0ZWRB'
    'dBIhCgxwcm9jZXNzZWRfYXQYByABKAlSC3Byb2Nlc3NlZEF0');

@$core.Deprecated('Use invoiceDescriptor instead')
const Invoice$json = {
  '1': 'Invoice',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {
      '1': 'order',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.Order',
      '10': 'order'
    },
    {'1': 'invoice_number', '3': 3, '4': 1, '5': 9, '10': 'invoiceNumber'},
    {'1': 'pdf_url', '3': 4, '4': 1, '5': 9, '10': 'pdfUrl'},
    {'1': 'issued_at', '3': 5, '4': 1, '5': 9, '10': 'issuedAt'},
    {'1': 'due_at', '3': 6, '4': 1, '5': 9, '10': 'dueAt'},
    {'1': 'status', '3': 7, '4': 1, '5': 9, '10': 'status'},
  ],
};

/// Descriptor for `Invoice`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List invoiceDescriptor = $convert.base64Decode(
    'CgdJbnZvaWNlEg4KAmlkGAEgASgJUgJpZBIsCgVvcmRlchgCIAEoCzIWLndlZGRpbmcudXNlci'
    '52MS5PcmRlclIFb3JkZXISJQoOaW52b2ljZV9udW1iZXIYAyABKAlSDWludm9pY2VOdW1iZXIS'
    'FwoHcGRmX3VybBgEIAEoCVIGcGRmVXJsEhsKCWlzc3VlZF9hdBgFIAEoCVIIaXNzdWVkQXQSFQ'
    'oGZHVlX2F0GAYgASgJUgVkdWVBdBIWCgZzdGF0dXMYByABKAlSBnN0YXR1cw==');
