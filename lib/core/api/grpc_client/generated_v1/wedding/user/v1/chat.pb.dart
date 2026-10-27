// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/chat.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'auth.pb.dart' as $2;
import 'common.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GetConversationsRequest extends $pb.GeneratedMessage {
  factory GetConversationsRequest({
    $1.PaginationRequest? pagination,
  }) {
    final result = GetConversationsRequest._();
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  GetConversationsRequest._();

  factory GetConversationsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetConversationsRequest()..mergeFromBuffer(data, registry);
  factory GetConversationsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetConversationsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetConversationsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetConversationsRequest.$_createMessage)
    ..aOM<$1.PaginationRequest>(1, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginationRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetConversationsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetConversationsRequest copyWith(
          void Function(GetConversationsRequest) updates) =>
      super.copyWith((message) => updates(message as GetConversationsRequest))
          as GetConversationsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetConversationsRequest() / GetConversationsRequest.new instead')
  static GetConversationsRequest create() => GetConversationsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetConversationsRequest._();
  @$core.override
  GetConversationsRequest createEmptyInstance() => GetConversationsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetConversationsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetConversationsRequest>(
          GetConversationsRequest.$_createMessage);
  static GetConversationsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.PaginationRequest get pagination => $_getN(0);
  @$pb.TagNumber(1)
  set pagination($1.PaginationRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPagination() => $_has(0);
  @$pb.TagNumber(1)
  void clearPagination() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.PaginationRequest ensurePagination() => $_ensure(0);
}

class ConversationListResponse extends $pb.GeneratedMessage {
  factory ConversationListResponse({
    $core.Iterable<Conversation>? conversations,
    $1.PaginationResponse? pagination,
  }) {
    final result = ConversationListResponse._();
    if (conversations != null) result.conversations.addAll(conversations);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ConversationListResponse._();

  factory ConversationListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConversationListResponse()..mergeFromBuffer(data, registry);
  factory ConversationListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConversationListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConversationListResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ConversationListResponse.$_createMessage)
    ..pPM<Conversation>(1, _omitFieldNames ? '' : 'conversations',
        subBuilder: Conversation.$_createMessage)
    ..aOM<$1.PaginationResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginationResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConversationListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConversationListResponse copyWith(
          void Function(ConversationListResponse) updates) =>
      super.copyWith((message) => updates(message as ConversationListResponse))
          as ConversationListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ConversationListResponse() / ConversationListResponse.new instead')
  static ConversationListResponse create() => ConversationListResponse._();
  static $pb.GeneratedMessage $_createMessage() => ConversationListResponse._();
  @$core.override
  ConversationListResponse createEmptyInstance() =>
      ConversationListResponse._();
  @$core.pragma('dart2js:noInline')
  static ConversationListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConversationListResponse>(
          ConversationListResponse.$_createMessage);
  static ConversationListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Conversation> get conversations => $_getList(0);

  @$pb.TagNumber(2)
  $1.PaginationResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.PaginationResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.PaginationResponse ensurePagination() => $_ensure(1);
}

class GetConversationRequest extends $pb.GeneratedMessage {
  factory GetConversationRequest({
    $core.String? conversationId,
  }) {
    final result = GetConversationRequest._();
    if (conversationId != null) result.conversationId = conversationId;
    return result;
  }

  GetConversationRequest._();

  factory GetConversationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetConversationRequest()..mergeFromBuffer(data, registry);
  factory GetConversationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetConversationRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetConversationRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetConversationRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'conversationId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetConversationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetConversationRequest copyWith(
          void Function(GetConversationRequest) updates) =>
      super.copyWith((message) => updates(message as GetConversationRequest))
          as GetConversationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetConversationRequest() / GetConversationRequest.new instead')
  static GetConversationRequest create() => GetConversationRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetConversationRequest._();
  @$core.override
  GetConversationRequest createEmptyInstance() => GetConversationRequest._();
  @$core.pragma('dart2js:noInline')
  static GetConversationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetConversationRequest>(
          GetConversationRequest.$_createMessage);
  static GetConversationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get conversationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set conversationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConversationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearConversationId() => $_clearField(1);
}

class GetMessagesRequest extends $pb.GeneratedMessage {
  factory GetMessagesRequest({
    $core.String? conversationId,
    $1.PaginationRequest? pagination,
  }) {
    final result = GetMessagesRequest._();
    if (conversationId != null) result.conversationId = conversationId;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  GetMessagesRequest._();

  factory GetMessagesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMessagesRequest()..mergeFromBuffer(data, registry);
  factory GetMessagesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMessagesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMessagesRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: GetMessagesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'conversationId')
    ..aOM<$1.PaginationRequest>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginationRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMessagesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMessagesRequest copyWith(void Function(GetMessagesRequest) updates) =>
      super.copyWith((message) => updates(message as GetMessagesRequest))
          as GetMessagesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetMessagesRequest() / GetMessagesRequest.new instead')
  static GetMessagesRequest create() => GetMessagesRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetMessagesRequest._();
  @$core.override
  GetMessagesRequest createEmptyInstance() => GetMessagesRequest._();
  @$core.pragma('dart2js:noInline')
  static GetMessagesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMessagesRequest>(
          GetMessagesRequest.$_createMessage);
  static GetMessagesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get conversationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set conversationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConversationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearConversationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.PaginationRequest get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.PaginationRequest value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.PaginationRequest ensurePagination() => $_ensure(1);
}

class MessageListResponse extends $pb.GeneratedMessage {
  factory MessageListResponse({
    $core.Iterable<Message>? messages,
    $1.PaginationResponse? pagination,
  }) {
    final result = MessageListResponse._();
    if (messages != null) result.messages.addAll(messages);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  MessageListResponse._();

  factory MessageListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MessageListResponse()..mergeFromBuffer(data, registry);
  factory MessageListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MessageListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MessageListResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: MessageListResponse.$_createMessage)
    ..pPM<Message>(1, _omitFieldNames ? '' : 'messages',
        subBuilder: Message.$_createMessage)
    ..aOM<$1.PaginationResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginationResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageListResponse copyWith(void Function(MessageListResponse) updates) =>
      super.copyWith((message) => updates(message as MessageListResponse))
          as MessageListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use MessageListResponse() / MessageListResponse.new instead')
  static MessageListResponse create() => MessageListResponse._();
  static $pb.GeneratedMessage $_createMessage() => MessageListResponse._();
  @$core.override
  MessageListResponse createEmptyInstance() => MessageListResponse._();
  @$core.pragma('dart2js:noInline')
  static MessageListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MessageListResponse>(
          MessageListResponse.$_createMessage);
  static MessageListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Message> get messages => $_getList(0);

  @$pb.TagNumber(2)
  $1.PaginationResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.PaginationResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.PaginationResponse ensurePagination() => $_ensure(1);
}

class SendMessageRequest extends $pb.GeneratedMessage {
  factory SendMessageRequest({
    $core.String? conversationId,
    $core.String? content,
    $1.MetaData? metadata,
  }) {
    final result = SendMessageRequest._();
    if (conversationId != null) result.conversationId = conversationId;
    if (content != null) result.content = content;
    if (metadata != null) result.metadata = metadata;
    return result;
  }

  SendMessageRequest._();

  factory SendMessageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SendMessageRequest()..mergeFromBuffer(data, registry);
  factory SendMessageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SendMessageRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendMessageRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: SendMessageRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'conversationId')
    ..aOS(2, _omitFieldNames ? '' : 'content')
    ..aOM<$1.MetaData>(3, _omitFieldNames ? '' : 'metadata',
        subBuilder: $1.MetaData.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendMessageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendMessageRequest copyWith(void Function(SendMessageRequest) updates) =>
      super.copyWith((message) => updates(message as SendMessageRequest))
          as SendMessageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SendMessageRequest() / SendMessageRequest.new instead')
  static SendMessageRequest create() => SendMessageRequest._();
  static $pb.GeneratedMessage $_createMessage() => SendMessageRequest._();
  @$core.override
  SendMessageRequest createEmptyInstance() => SendMessageRequest._();
  @$core.pragma('dart2js:noInline')
  static SendMessageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SendMessageRequest>(
          SendMessageRequest.$_createMessage);
  static SendMessageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get conversationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set conversationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConversationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearConversationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get content => $_getSZ(1);
  @$pb.TagNumber(2)
  set content($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasContent() => $_has(1);
  @$pb.TagNumber(2)
  void clearContent() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.MetaData get metadata => $_getN(2);
  @$pb.TagNumber(3)
  set metadata($1.MetaData value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasMetadata() => $_has(2);
  @$pb.TagNumber(3)
  void clearMetadata() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.MetaData ensureMetadata() => $_ensure(2);
}

class MarkMessageAsReadRequest extends $pb.GeneratedMessage {
  factory MarkMessageAsReadRequest({
    $core.String? conversationId,
    $core.String? messageId,
  }) {
    final result = MarkMessageAsReadRequest._();
    if (conversationId != null) result.conversationId = conversationId;
    if (messageId != null) result.messageId = messageId;
    return result;
  }

  MarkMessageAsReadRequest._();

  factory MarkMessageAsReadRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkMessageAsReadRequest()..mergeFromBuffer(data, registry);
  factory MarkMessageAsReadRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkMessageAsReadRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkMessageAsReadRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: MarkMessageAsReadRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'conversationId')
    ..aOS(2, _omitFieldNames ? '' : 'messageId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkMessageAsReadRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkMessageAsReadRequest copyWith(
          void Function(MarkMessageAsReadRequest) updates) =>
      super.copyWith((message) => updates(message as MarkMessageAsReadRequest))
          as MarkMessageAsReadRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MarkMessageAsReadRequest() / MarkMessageAsReadRequest.new instead')
  static MarkMessageAsReadRequest create() => MarkMessageAsReadRequest._();
  static $pb.GeneratedMessage $_createMessage() => MarkMessageAsReadRequest._();
  @$core.override
  MarkMessageAsReadRequest createEmptyInstance() =>
      MarkMessageAsReadRequest._();
  @$core.pragma('dart2js:noInline')
  static MarkMessageAsReadRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MarkMessageAsReadRequest>(
          MarkMessageAsReadRequest.$_createMessage);
  static MarkMessageAsReadRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get conversationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set conversationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConversationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearConversationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get messageId => $_getSZ(1);
  @$pb.TagNumber(2)
  set messageId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessageId() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessageId() => $_clearField(2);
}

class MarkMessageAsReadResponse extends $pb.GeneratedMessage {
  factory MarkMessageAsReadResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = MarkMessageAsReadResponse._();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  MarkMessageAsReadResponse._();

  factory MarkMessageAsReadResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkMessageAsReadResponse()..mergeFromBuffer(data, registry);
  factory MarkMessageAsReadResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkMessageAsReadResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkMessageAsReadResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: MarkMessageAsReadResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkMessageAsReadResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkMessageAsReadResponse copyWith(
          void Function(MarkMessageAsReadResponse) updates) =>
      super.copyWith((message) => updates(message as MarkMessageAsReadResponse))
          as MarkMessageAsReadResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MarkMessageAsReadResponse() / MarkMessageAsReadResponse.new instead')
  static MarkMessageAsReadResponse create() => MarkMessageAsReadResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      MarkMessageAsReadResponse._();
  @$core.override
  MarkMessageAsReadResponse createEmptyInstance() =>
      MarkMessageAsReadResponse._();
  @$core.pragma('dart2js:noInline')
  static MarkMessageAsReadResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MarkMessageAsReadResponse>(
          MarkMessageAsReadResponse.$_createMessage);
  static MarkMessageAsReadResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

class CreateConversationRequest extends $pb.GeneratedMessage {
  factory CreateConversationRequest({
    $core.Iterable<$core.String>? participantIds,
    $core.String? initialMessage,
  }) {
    final result = CreateConversationRequest._();
    if (participantIds != null) result.participantIds.addAll(participantIds);
    if (initialMessage != null) result.initialMessage = initialMessage;
    return result;
  }

  CreateConversationRequest._();

  factory CreateConversationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateConversationRequest()..mergeFromBuffer(data, registry);
  factory CreateConversationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateConversationRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateConversationRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: CreateConversationRequest.$_createMessage)
    ..pPS(1, _omitFieldNames ? '' : 'participantIds')
    ..aOS(2, _omitFieldNames ? '' : 'initialMessage')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateConversationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateConversationRequest copyWith(
          void Function(CreateConversationRequest) updates) =>
      super.copyWith((message) => updates(message as CreateConversationRequest))
          as CreateConversationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateConversationRequest() / CreateConversationRequest.new instead')
  static CreateConversationRequest create() => CreateConversationRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CreateConversationRequest._();
  @$core.override
  CreateConversationRequest createEmptyInstance() =>
      CreateConversationRequest._();
  @$core.pragma('dart2js:noInline')
  static CreateConversationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateConversationRequest>(
          CreateConversationRequest.$_createMessage);
  static CreateConversationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get participantIds => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get initialMessage => $_getSZ(1);
  @$pb.TagNumber(2)
  set initialMessage($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasInitialMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearInitialMessage() => $_clearField(2);
}

class WatchMessagesRequest extends $pb.GeneratedMessage {
  factory WatchMessagesRequest({
    $core.String? conversationId,
  }) {
    final result = WatchMessagesRequest._();
    if (conversationId != null) result.conversationId = conversationId;
    return result;
  }

  WatchMessagesRequest._();

  factory WatchMessagesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchMessagesRequest()..mergeFromBuffer(data, registry);
  factory WatchMessagesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchMessagesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchMessagesRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: WatchMessagesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'conversationId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchMessagesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchMessagesRequest copyWith(void Function(WatchMessagesRequest) updates) =>
      super.copyWith((message) => updates(message as WatchMessagesRequest))
          as WatchMessagesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WatchMessagesRequest() / WatchMessagesRequest.new instead')
  static WatchMessagesRequest create() => WatchMessagesRequest._();
  static $pb.GeneratedMessage $_createMessage() => WatchMessagesRequest._();
  @$core.override
  WatchMessagesRequest createEmptyInstance() => WatchMessagesRequest._();
  @$core.pragma('dart2js:noInline')
  static WatchMessagesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchMessagesRequest>(
          WatchMessagesRequest.$_createMessage);
  static WatchMessagesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get conversationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set conversationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConversationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearConversationId() => $_clearField(1);
}

class WatchConversationsRequest extends $pb.GeneratedMessage {
  factory WatchConversationsRequest({
    $core.String? userId,
  }) {
    final result = WatchConversationsRequest._();
    if (userId != null) result.userId = userId;
    return result;
  }

  WatchConversationsRequest._();

  factory WatchConversationsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchConversationsRequest()..mergeFromBuffer(data, registry);
  factory WatchConversationsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchConversationsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchConversationsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: WatchConversationsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchConversationsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchConversationsRequest copyWith(
          void Function(WatchConversationsRequest) updates) =>
      super.copyWith((message) => updates(message as WatchConversationsRequest))
          as WatchConversationsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WatchConversationsRequest() / WatchConversationsRequest.new instead')
  static WatchConversationsRequest create() => WatchConversationsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      WatchConversationsRequest._();
  @$core.override
  WatchConversationsRequest createEmptyInstance() =>
      WatchConversationsRequest._();
  @$core.pragma('dart2js:noInline')
  static WatchConversationsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchConversationsRequest>(
          WatchConversationsRequest.$_createMessage);
  static WatchConversationsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);
}

class Conversation extends $pb.GeneratedMessage {
  factory Conversation({
    $core.String? id,
    $core.Iterable<ConversationParticipant>? participants,
    Message? lastMessage,
    $core.int? unreadCount,
    $core.String? createdAt,
    $core.String? updatedAt,
  }) {
    final result = Conversation._();
    if (id != null) result.id = id;
    if (participants != null) result.participants.addAll(participants);
    if (lastMessage != null) result.lastMessage = lastMessage;
    if (unreadCount != null) result.unreadCount = unreadCount;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  Conversation._();

  factory Conversation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Conversation()..mergeFromBuffer(data, registry);
  factory Conversation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Conversation()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Conversation',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: Conversation.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..pPM<ConversationParticipant>(2, _omitFieldNames ? '' : 'participants',
        subBuilder: ConversationParticipant.$_createMessage)
    ..aOM<Message>(3, _omitFieldNames ? '' : 'lastMessage',
        subBuilder: Message.$_createMessage)
    ..aI(4, _omitFieldNames ? '' : 'unreadCount')
    ..aOS(5, _omitFieldNames ? '' : 'createdAt')
    ..aOS(6, _omitFieldNames ? '' : 'updatedAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Conversation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Conversation copyWith(void Function(Conversation) updates) =>
      super.copyWith((message) => updates(message as Conversation))
          as Conversation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Conversation() / Conversation.new instead')
  static Conversation create() => Conversation._();
  static $pb.GeneratedMessage $_createMessage() => Conversation._();
  @$core.override
  Conversation createEmptyInstance() => Conversation._();
  @$core.pragma('dart2js:noInline')
  static Conversation getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Conversation>(
          Conversation.$_createMessage);
  static Conversation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<ConversationParticipant> get participants => $_getList(1);

  @$pb.TagNumber(3)
  Message get lastMessage => $_getN(2);
  @$pb.TagNumber(3)
  set lastMessage(Message value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasLastMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearLastMessage() => $_clearField(3);
  @$pb.TagNumber(3)
  Message ensureLastMessage() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.int get unreadCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set unreadCount($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUnreadCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnreadCount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get createdAt => $_getSZ(4);
  @$pb.TagNumber(5)
  set createdAt($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCreatedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreatedAt() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get updatedAt => $_getSZ(5);
  @$pb.TagNumber(6)
  set updatedAt($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUpdatedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearUpdatedAt() => $_clearField(6);
}

class ConversationParticipant extends $pb.GeneratedMessage {
  factory ConversationParticipant({
    $core.String? userId,
    $2.User? user,
    $core.bool? isAdmin,
    $core.String? joinedAt,
  }) {
    final result = ConversationParticipant._();
    if (userId != null) result.userId = userId;
    if (user != null) result.user = user;
    if (isAdmin != null) result.isAdmin = isAdmin;
    if (joinedAt != null) result.joinedAt = joinedAt;
    return result;
  }

  ConversationParticipant._();

  factory ConversationParticipant.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConversationParticipant()..mergeFromBuffer(data, registry);
  factory ConversationParticipant.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConversationParticipant()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConversationParticipant',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: ConversationParticipant.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOM<$2.User>(2, _omitFieldNames ? '' : 'user',
        subBuilder: $2.User.$_createMessage)
    ..aOB(3, _omitFieldNames ? '' : 'isAdmin')
    ..aOS(4, _omitFieldNames ? '' : 'joinedAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConversationParticipant clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConversationParticipant copyWith(
          void Function(ConversationParticipant) updates) =>
      super.copyWith((message) => updates(message as ConversationParticipant))
          as ConversationParticipant;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ConversationParticipant() / ConversationParticipant.new instead')
  static ConversationParticipant create() => ConversationParticipant._();
  static $pb.GeneratedMessage $_createMessage() => ConversationParticipant._();
  @$core.override
  ConversationParticipant createEmptyInstance() => ConversationParticipant._();
  @$core.pragma('dart2js:noInline')
  static ConversationParticipant getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConversationParticipant>(
          ConversationParticipant.$_createMessage);
  static ConversationParticipant? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $2.User get user => $_getN(1);
  @$pb.TagNumber(2)
  set user($2.User value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearUser() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.User ensureUser() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get isAdmin => $_getBF(2);
  @$pb.TagNumber(3)
  set isAdmin($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsAdmin() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsAdmin() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get joinedAt => $_getSZ(3);
  @$pb.TagNumber(4)
  set joinedAt($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasJoinedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearJoinedAt() => $_clearField(4);
}

class Message extends $pb.GeneratedMessage {
  factory Message({
    $core.String? id,
    $core.String? conversationId,
    $core.String? senderId,
    $2.User? sender,
    $core.String? content,
    $1.MetaData? metadata,
    $core.bool? isRead,
    $core.String? readAt,
    $core.String? createdAt,
  }) {
    final result = Message._();
    if (id != null) result.id = id;
    if (conversationId != null) result.conversationId = conversationId;
    if (senderId != null) result.senderId = senderId;
    if (sender != null) result.sender = sender;
    if (content != null) result.content = content;
    if (metadata != null) result.metadata = metadata;
    if (isRead != null) result.isRead = isRead;
    if (readAt != null) result.readAt = readAt;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  Message._();

  factory Message.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Message()..mergeFromBuffer(data, registry);
  factory Message.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Message()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Message',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'wedding.user.v1'),
      createEmptyInstance: Message.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'conversationId')
    ..aOS(3, _omitFieldNames ? '' : 'senderId')
    ..aOM<$2.User>(4, _omitFieldNames ? '' : 'sender',
        subBuilder: $2.User.$_createMessage)
    ..aOS(5, _omitFieldNames ? '' : 'content')
    ..aOM<$1.MetaData>(6, _omitFieldNames ? '' : 'metadata',
        subBuilder: $1.MetaData.$_createMessage)
    ..aOB(7, _omitFieldNames ? '' : 'isRead')
    ..aOS(8, _omitFieldNames ? '' : 'readAt')
    ..aOS(9, _omitFieldNames ? '' : 'createdAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Message clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Message copyWith(void Function(Message) updates) =>
      super.copyWith((message) => updates(message as Message)) as Message;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Message() / Message.new instead')
  static Message create() => Message._();
  static $pb.GeneratedMessage $_createMessage() => Message._();
  @$core.override
  Message createEmptyInstance() => Message._();
  @$core.pragma('dart2js:noInline')
  static Message getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Message>(Message.$_createMessage);
  static Message? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get conversationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set conversationId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasConversationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearConversationId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get senderId => $_getSZ(2);
  @$pb.TagNumber(3)
  set senderId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSenderId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSenderId() => $_clearField(3);

  @$pb.TagNumber(4)
  $2.User get sender => $_getN(3);
  @$pb.TagNumber(4)
  set sender($2.User value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSender() => $_has(3);
  @$pb.TagNumber(4)
  void clearSender() => $_clearField(4);
  @$pb.TagNumber(4)
  $2.User ensureSender() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get content => $_getSZ(4);
  @$pb.TagNumber(5)
  set content($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasContent() => $_has(4);
  @$pb.TagNumber(5)
  void clearContent() => $_clearField(5);

  @$pb.TagNumber(6)
  $1.MetaData get metadata => $_getN(5);
  @$pb.TagNumber(6)
  set metadata($1.MetaData value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasMetadata() => $_has(5);
  @$pb.TagNumber(6)
  void clearMetadata() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.MetaData ensureMetadata() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.bool get isRead => $_getBF(6);
  @$pb.TagNumber(7)
  set isRead($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIsRead() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsRead() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get readAt => $_getSZ(7);
  @$pb.TagNumber(8)
  set readAt($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasReadAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearReadAt() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get createdAt => $_getSZ(8);
  @$pb.TagNumber(9)
  set createdAt($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCreatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreatedAt() => $_clearField(9);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
