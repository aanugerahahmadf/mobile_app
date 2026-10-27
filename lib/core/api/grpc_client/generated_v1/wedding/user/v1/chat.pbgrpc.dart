// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/chat.proto.

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

import 'chat.pb.dart' as $0;

export 'chat.pb.dart';

/// Chat Service
@$pb.GrpcServiceName('wedding.user.v1.ChatService')
class ChatServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ChatServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.ConversationListResponse> getConversations(
    $0.GetConversationsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getConversations, request, options: options);
  }

  $grpc.ResponseFuture<$0.Conversation> getConversation(
    $0.GetConversationRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getConversation, request, options: options);
  }

  $grpc.ResponseFuture<$0.MessageListResponse> getMessages(
    $0.GetMessagesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getMessages, request, options: options);
  }

  $grpc.ResponseFuture<$0.Message> sendMessage(
    $0.SendMessageRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$sendMessage, request, options: options);
  }

  $grpc.ResponseFuture<$0.MarkMessageAsReadResponse> markAsRead(
    $0.MarkMessageAsReadRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$markAsRead, request, options: options);
  }

  $grpc.ResponseFuture<$0.Conversation> createConversation(
    $0.CreateConversationRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createConversation, request, options: options);
  }

  /// Real-time messaging
  $grpc.ResponseStream<$0.Message> watchMessages(
    $0.WatchMessagesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$watchMessages, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseStream<$0.Conversation> watchConversations(
    $0.WatchConversationsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$watchConversations, $async.Stream.fromIterable([request]),
        options: options);
  }

  // method descriptors

  static final _$getConversations = $grpc.ClientMethod<
          $0.GetConversationsRequest, $0.ConversationListResponse>(
      '/wedding.user.v1.ChatService/GetConversations',
      ($0.GetConversationsRequest value) => value.writeToBuffer(),
      $0.ConversationListResponse.fromBuffer);
  static final _$getConversation =
      $grpc.ClientMethod<$0.GetConversationRequest, $0.Conversation>(
          '/wedding.user.v1.ChatService/GetConversation',
          ($0.GetConversationRequest value) => value.writeToBuffer(),
          $0.Conversation.fromBuffer);
  static final _$getMessages =
      $grpc.ClientMethod<$0.GetMessagesRequest, $0.MessageListResponse>(
          '/wedding.user.v1.ChatService/GetMessages',
          ($0.GetMessagesRequest value) => value.writeToBuffer(),
          $0.MessageListResponse.fromBuffer);
  static final _$sendMessage =
      $grpc.ClientMethod<$0.SendMessageRequest, $0.Message>(
          '/wedding.user.v1.ChatService/SendMessage',
          ($0.SendMessageRequest value) => value.writeToBuffer(),
          $0.Message.fromBuffer);
  static final _$markAsRead = $grpc.ClientMethod<$0.MarkMessageAsReadRequest,
          $0.MarkMessageAsReadResponse>(
      '/wedding.user.v1.ChatService/MarkAsRead',
      ($0.MarkMessageAsReadRequest value) => value.writeToBuffer(),
      $0.MarkMessageAsReadResponse.fromBuffer);
  static final _$createConversation =
      $grpc.ClientMethod<$0.CreateConversationRequest, $0.Conversation>(
          '/wedding.user.v1.ChatService/CreateConversation',
          ($0.CreateConversationRequest value) => value.writeToBuffer(),
          $0.Conversation.fromBuffer);
  static final _$watchMessages =
      $grpc.ClientMethod<$0.WatchMessagesRequest, $0.Message>(
          '/wedding.user.v1.ChatService/WatchMessages',
          ($0.WatchMessagesRequest value) => value.writeToBuffer(),
          $0.Message.fromBuffer);
  static final _$watchConversations =
      $grpc.ClientMethod<$0.WatchConversationsRequest, $0.Conversation>(
          '/wedding.user.v1.ChatService/WatchConversations',
          ($0.WatchConversationsRequest value) => value.writeToBuffer(),
          $0.Conversation.fromBuffer);
}

@$pb.GrpcServiceName('wedding.user.v1.ChatService')
abstract class ChatServiceBase extends $grpc.Service {
  $core.String get $name => 'wedding.user.v1.ChatService';

  ChatServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetConversationsRequest,
            $0.ConversationListResponse>(
        'GetConversations',
        getConversations_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetConversationsRequest.fromBuffer(value),
        ($0.ConversationListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetConversationRequest, $0.Conversation>(
        'GetConversation',
        getConversation_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetConversationRequest.fromBuffer(value),
        ($0.Conversation value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetMessagesRequest, $0.MessageListResponse>(
            'GetMessages',
            getMessages_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetMessagesRequest.fromBuffer(value),
            ($0.MessageListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SendMessageRequest, $0.Message>(
        'SendMessage',
        sendMessage_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SendMessageRequest.fromBuffer(value),
        ($0.Message value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.MarkMessageAsReadRequest,
            $0.MarkMessageAsReadResponse>(
        'MarkAsRead',
        markAsRead_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.MarkMessageAsReadRequest.fromBuffer(value),
        ($0.MarkMessageAsReadResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.CreateConversationRequest, $0.Conversation>(
            'CreateConversation',
            createConversation_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.CreateConversationRequest.fromBuffer(value),
            ($0.Conversation value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WatchMessagesRequest, $0.Message>(
        'WatchMessages',
        watchMessages_Pre,
        false,
        true,
        ($core.List<$core.int> value) =>
            $0.WatchMessagesRequest.fromBuffer(value),
        ($0.Message value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.WatchConversationsRequest, $0.Conversation>(
            'WatchConversations',
            watchConversations_Pre,
            false,
            true,
            ($core.List<$core.int> value) =>
                $0.WatchConversationsRequest.fromBuffer(value),
            ($0.Conversation value) => value.writeToBuffer()));
  }

  $async.Future<$0.ConversationListResponse> getConversations_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetConversationsRequest> $request) async {
    return getConversations($call, await $request);
  }

  $async.Future<$0.ConversationListResponse> getConversations(
      $grpc.ServiceCall call, $0.GetConversationsRequest request);

  $async.Future<$0.Conversation> getConversation_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetConversationRequest> $request) async {
    return getConversation($call, await $request);
  }

  $async.Future<$0.Conversation> getConversation(
      $grpc.ServiceCall call, $0.GetConversationRequest request);

  $async.Future<$0.MessageListResponse> getMessages_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetMessagesRequest> $request) async {
    return getMessages($call, await $request);
  }

  $async.Future<$0.MessageListResponse> getMessages(
      $grpc.ServiceCall call, $0.GetMessagesRequest request);

  $async.Future<$0.Message> sendMessage_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SendMessageRequest> $request) async {
    return sendMessage($call, await $request);
  }

  $async.Future<$0.Message> sendMessage(
      $grpc.ServiceCall call, $0.SendMessageRequest request);

  $async.Future<$0.MarkMessageAsReadResponse> markAsRead_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.MarkMessageAsReadRequest> $request) async {
    return markAsRead($call, await $request);
  }

  $async.Future<$0.MarkMessageAsReadResponse> markAsRead(
      $grpc.ServiceCall call, $0.MarkMessageAsReadRequest request);

  $async.Future<$0.Conversation> createConversation_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CreateConversationRequest> $request) async {
    return createConversation($call, await $request);
  }

  $async.Future<$0.Conversation> createConversation(
      $grpc.ServiceCall call, $0.CreateConversationRequest request);

  $async.Stream<$0.Message> watchMessages_Pre($grpc.ServiceCall $call,
      $async.Future<$0.WatchMessagesRequest> $request) async* {
    yield* watchMessages($call, await $request);
  }

  $async.Stream<$0.Message> watchMessages(
      $grpc.ServiceCall call, $0.WatchMessagesRequest request);

  $async.Stream<$0.Conversation> watchConversations_Pre($grpc.ServiceCall $call,
      $async.Future<$0.WatchConversationsRequest> $request) async* {
    yield* watchConversations($call, await $request);
  }

  $async.Stream<$0.Conversation> watchConversations(
      $grpc.ServiceCall call, $0.WatchConversationsRequest request);
}
