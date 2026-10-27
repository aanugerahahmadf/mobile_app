// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/voucher.proto.

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

import 'voucher.pb.dart' as $0;

export 'voucher.pb.dart';

/// Voucher Service
@$pb.GrpcServiceName('wedding.user.v1.VoucherService')
class VoucherServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  VoucherServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.VoucherListResponse> getMyVouchers(
    $0.GetMyVouchersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getMyVouchers, request, options: options);
  }

  $grpc.ResponseFuture<$0.Voucher> getVoucherByCode(
    $0.GetVoucherByCodeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getVoucherByCode, request, options: options);
  }

  $grpc.ResponseFuture<$0.VoucherListResponse> listVouchers(
    $0.ListVouchersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listVouchers, request, options: options);
  }

  $grpc.ResponseFuture<$0.VoucherStats> getVoucherStats(
    $0.GetVoucherStatsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getVoucherStats, request, options: options);
  }

  $grpc.ResponseFuture<$0.VoucherValidation> validateVoucher(
    $0.ValidateVoucherRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$validateVoucher, request, options: options);
  }

  $grpc.ResponseFuture<$0.Voucher> createVoucher(
    $0.CreateVoucherRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createVoucher, request, options: options);
  }

  $grpc.ResponseFuture<$0.Voucher> updateVoucher(
    $0.UpdateVoucherRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateVoucher, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeleteVoucherResponse> deleteVoucher(
    $0.DeleteVoucherRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteVoucher, request, options: options);
  }

  $grpc.ResponseFuture<$0.Voucher> toggleVoucherStatus(
    $0.ToggleVoucherStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$toggleVoucherStatus, request, options: options);
  }

  $grpc.ResponseFuture<$0.VoucherListResponse> bulkCreateVouchers(
    $0.BulkCreateVouchersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$bulkCreateVouchers, request, options: options);
  }

  $grpc.ResponseFuture<$0.VoucherExport> exportVoucherCodes(
    $0.ExportVoucherCodesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$exportVoucherCodes, request, options: options);
  }

  // method descriptors

  static final _$getMyVouchers =
      $grpc.ClientMethod<$0.GetMyVouchersRequest, $0.VoucherListResponse>(
          '/wedding.user.v1.VoucherService/GetMyVouchers',
          ($0.GetMyVouchersRequest value) => value.writeToBuffer(),
          $0.VoucherListResponse.fromBuffer);
  static final _$getVoucherByCode =
      $grpc.ClientMethod<$0.GetVoucherByCodeRequest, $0.Voucher>(
          '/wedding.user.v1.VoucherService/GetVoucherByCode',
          ($0.GetVoucherByCodeRequest value) => value.writeToBuffer(),
          $0.Voucher.fromBuffer);
  static final _$listVouchers =
      $grpc.ClientMethod<$0.ListVouchersRequest, $0.VoucherListResponse>(
          '/wedding.user.v1.VoucherService/ListVouchers',
          ($0.ListVouchersRequest value) => value.writeToBuffer(),
          $0.VoucherListResponse.fromBuffer);
  static final _$getVoucherStats =
      $grpc.ClientMethod<$0.GetVoucherStatsRequest, $0.VoucherStats>(
          '/wedding.user.v1.VoucherService/GetVoucherStats',
          ($0.GetVoucherStatsRequest value) => value.writeToBuffer(),
          $0.VoucherStats.fromBuffer);
  static final _$validateVoucher =
      $grpc.ClientMethod<$0.ValidateVoucherRequest, $0.VoucherValidation>(
          '/wedding.user.v1.VoucherService/ValidateVoucher',
          ($0.ValidateVoucherRequest value) => value.writeToBuffer(),
          $0.VoucherValidation.fromBuffer);
  static final _$createVoucher =
      $grpc.ClientMethod<$0.CreateVoucherRequest, $0.Voucher>(
          '/wedding.user.v1.VoucherService/CreateVoucher',
          ($0.CreateVoucherRequest value) => value.writeToBuffer(),
          $0.Voucher.fromBuffer);
  static final _$updateVoucher =
      $grpc.ClientMethod<$0.UpdateVoucherRequest, $0.Voucher>(
          '/wedding.user.v1.VoucherService/UpdateVoucher',
          ($0.UpdateVoucherRequest value) => value.writeToBuffer(),
          $0.Voucher.fromBuffer);
  static final _$deleteVoucher =
      $grpc.ClientMethod<$0.DeleteVoucherRequest, $0.DeleteVoucherResponse>(
          '/wedding.user.v1.VoucherService/DeleteVoucher',
          ($0.DeleteVoucherRequest value) => value.writeToBuffer(),
          $0.DeleteVoucherResponse.fromBuffer);
  static final _$toggleVoucherStatus =
      $grpc.ClientMethod<$0.ToggleVoucherStatusRequest, $0.Voucher>(
          '/wedding.user.v1.VoucherService/ToggleVoucherStatus',
          ($0.ToggleVoucherStatusRequest value) => value.writeToBuffer(),
          $0.Voucher.fromBuffer);
  static final _$bulkCreateVouchers =
      $grpc.ClientMethod<$0.BulkCreateVouchersRequest, $0.VoucherListResponse>(
          '/wedding.user.v1.VoucherService/BulkCreateVouchers',
          ($0.BulkCreateVouchersRequest value) => value.writeToBuffer(),
          $0.VoucherListResponse.fromBuffer);
  static final _$exportVoucherCodes =
      $grpc.ClientMethod<$0.ExportVoucherCodesRequest, $0.VoucherExport>(
          '/wedding.user.v1.VoucherService/ExportVoucherCodes',
          ($0.ExportVoucherCodesRequest value) => value.writeToBuffer(),
          $0.VoucherExport.fromBuffer);
}

@$pb.GrpcServiceName('wedding.user.v1.VoucherService')
abstract class VoucherServiceBase extends $grpc.Service {
  $core.String get $name => 'wedding.user.v1.VoucherService';

  VoucherServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.GetMyVouchersRequest, $0.VoucherListResponse>(
            'GetMyVouchers',
            getMyVouchers_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetMyVouchersRequest.fromBuffer(value),
            ($0.VoucherListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetVoucherByCodeRequest, $0.Voucher>(
        'GetVoucherByCode',
        getVoucherByCode_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetVoucherByCodeRequest.fromBuffer(value),
        ($0.Voucher value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListVouchersRequest, $0.VoucherListResponse>(
            'ListVouchers',
            listVouchers_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListVouchersRequest.fromBuffer(value),
            ($0.VoucherListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetVoucherStatsRequest, $0.VoucherStats>(
        'GetVoucherStats',
        getVoucherStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetVoucherStatsRequest.fromBuffer(value),
        ($0.VoucherStats value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ValidateVoucherRequest, $0.VoucherValidation>(
            'ValidateVoucher',
            validateVoucher_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ValidateVoucherRequest.fromBuffer(value),
            ($0.VoucherValidation value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CreateVoucherRequest, $0.Voucher>(
        'CreateVoucher',
        createVoucher_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CreateVoucherRequest.fromBuffer(value),
        ($0.Voucher value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateVoucherRequest, $0.Voucher>(
        'UpdateVoucher',
        updateVoucher_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateVoucherRequest.fromBuffer(value),
        ($0.Voucher value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.DeleteVoucherRequest, $0.DeleteVoucherResponse>(
            'DeleteVoucher',
            deleteVoucher_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.DeleteVoucherRequest.fromBuffer(value),
            ($0.DeleteVoucherResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ToggleVoucherStatusRequest, $0.Voucher>(
        'ToggleVoucherStatus',
        toggleVoucherStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ToggleVoucherStatusRequest.fromBuffer(value),
        ($0.Voucher value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.BulkCreateVouchersRequest,
            $0.VoucherListResponse>(
        'BulkCreateVouchers',
        bulkCreateVouchers_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.BulkCreateVouchersRequest.fromBuffer(value),
        ($0.VoucherListResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ExportVoucherCodesRequest, $0.VoucherExport>(
            'ExportVoucherCodes',
            exportVoucherCodes_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ExportVoucherCodesRequest.fromBuffer(value),
            ($0.VoucherExport value) => value.writeToBuffer()));
  }

  $async.Future<$0.VoucherListResponse> getMyVouchers_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetMyVouchersRequest> $request) async {
    return getMyVouchers($call, await $request);
  }

  $async.Future<$0.VoucherListResponse> getMyVouchers(
      $grpc.ServiceCall call, $0.GetMyVouchersRequest request);

  $async.Future<$0.Voucher> getVoucherByCode_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetVoucherByCodeRequest> $request) async {
    return getVoucherByCode($call, await $request);
  }

  $async.Future<$0.Voucher> getVoucherByCode(
      $grpc.ServiceCall call, $0.GetVoucherByCodeRequest request);

  $async.Future<$0.VoucherListResponse> listVouchers_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListVouchersRequest> $request) async {
    return listVouchers($call, await $request);
  }

  $async.Future<$0.VoucherListResponse> listVouchers(
      $grpc.ServiceCall call, $0.ListVouchersRequest request);

  $async.Future<$0.VoucherStats> getVoucherStats_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetVoucherStatsRequest> $request) async {
    return getVoucherStats($call, await $request);
  }

  $async.Future<$0.VoucherStats> getVoucherStats(
      $grpc.ServiceCall call, $0.GetVoucherStatsRequest request);

  $async.Future<$0.VoucherValidation> validateVoucher_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ValidateVoucherRequest> $request) async {
    return validateVoucher($call, await $request);
  }

  $async.Future<$0.VoucherValidation> validateVoucher(
      $grpc.ServiceCall call, $0.ValidateVoucherRequest request);

  $async.Future<$0.Voucher> createVoucher_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CreateVoucherRequest> $request) async {
    return createVoucher($call, await $request);
  }

  $async.Future<$0.Voucher> createVoucher(
      $grpc.ServiceCall call, $0.CreateVoucherRequest request);

  $async.Future<$0.Voucher> updateVoucher_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateVoucherRequest> $request) async {
    return updateVoucher($call, await $request);
  }

  $async.Future<$0.Voucher> updateVoucher(
      $grpc.ServiceCall call, $0.UpdateVoucherRequest request);

  $async.Future<$0.DeleteVoucherResponse> deleteVoucher_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DeleteVoucherRequest> $request) async {
    return deleteVoucher($call, await $request);
  }

  $async.Future<$0.DeleteVoucherResponse> deleteVoucher(
      $grpc.ServiceCall call, $0.DeleteVoucherRequest request);

  $async.Future<$0.Voucher> toggleVoucherStatus_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ToggleVoucherStatusRequest> $request) async {
    return toggleVoucherStatus($call, await $request);
  }

  $async.Future<$0.Voucher> toggleVoucherStatus(
      $grpc.ServiceCall call, $0.ToggleVoucherStatusRequest request);

  $async.Future<$0.VoucherListResponse> bulkCreateVouchers_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.BulkCreateVouchersRequest> $request) async {
    return bulkCreateVouchers($call, await $request);
  }

  $async.Future<$0.VoucherListResponse> bulkCreateVouchers(
      $grpc.ServiceCall call, $0.BulkCreateVouchersRequest request);

  $async.Future<$0.VoucherExport> exportVoucherCodes_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ExportVoucherCodesRequest> $request) async {
    return exportVoucherCodes($call, await $request);
  }

  $async.Future<$0.VoucherExport> exportVoucherCodes(
      $grpc.ServiceCall call, $0.ExportVoucherCodesRequest request);
}
