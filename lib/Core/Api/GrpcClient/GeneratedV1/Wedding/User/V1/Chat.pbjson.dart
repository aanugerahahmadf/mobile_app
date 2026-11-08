// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/chat.proto.

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

@$core.Deprecated('Use getConversationsRequestDescriptor instead')
const GetConversationsRequest$json = {
  '1': 'GetConversationsRequest',
  '2': [
    {
      '1': 'pagination',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.PaginationRequest',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `GetConversationsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getConversationsRequestDescriptor =
    $convert.base64Decode(
        'ChdHZXRDb252ZXJzYXRpb25zUmVxdWVzdBJCCgpwYWdpbmF0aW9uGAEgASgLMiIud2VkZGluZy'
        '51c2VyLnYxLlBhZ2luYXRpb25SZXF1ZXN0UgpwYWdpbmF0aW9u');

@$core.Deprecated('Use conversationListResponseDescriptor instead')
const ConversationListResponse$json = {
  '1': 'ConversationListResponse',
  '2': [
    {
      '1': 'conversations',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.Conversation',
      '10': 'conversations'
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

/// Descriptor for `ConversationListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List conversationListResponseDescriptor = $convert.base64Decode(
    'ChhDb252ZXJzYXRpb25MaXN0UmVzcG9uc2USQwoNY29udmVyc2F0aW9ucxgBIAMoCzIdLndlZG'
    'RpbmcudXNlci52MS5Db252ZXJzYXRpb25SDWNvbnZlcnNhdGlvbnMSQwoKcGFnaW5hdGlvbhgC'
    'IAEoCzIjLndlZGRpbmcudXNlci52MS5QYWdpbmF0aW9uUmVzcG9uc2VSCnBhZ2luYXRpb24=');

@$core.Deprecated('Use getConversationRequestDescriptor instead')
const GetConversationRequest$json = {
  '1': 'GetConversationRequest',
  '2': [
    {'1': 'conversation_id', '3': 1, '4': 1, '5': 9, '10': 'conversationId'},
  ],
};

/// Descriptor for `GetConversationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getConversationRequestDescriptor =
    $convert.base64Decode(
        'ChZHZXRDb252ZXJzYXRpb25SZXF1ZXN0EicKD2NvbnZlcnNhdGlvbl9pZBgBIAEoCVIOY29udm'
        'Vyc2F0aW9uSWQ=');

@$core.Deprecated('Use getMessagesRequestDescriptor instead')
const GetMessagesRequest$json = {
  '1': 'GetMessagesRequest',
  '2': [
    {'1': 'conversation_id', '3': 1, '4': 1, '5': 9, '10': 'conversationId'},
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.PaginationRequest',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `GetMessagesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMessagesRequestDescriptor = $convert.base64Decode(
    'ChJHZXRNZXNzYWdlc1JlcXVlc3QSJwoPY29udmVyc2F0aW9uX2lkGAEgASgJUg5jb252ZXJzYX'
    'Rpb25JZBJCCgpwYWdpbmF0aW9uGAIgASgLMiIud2VkZGluZy51c2VyLnYxLlBhZ2luYXRpb25S'
    'ZXF1ZXN0UgpwYWdpbmF0aW9u');

@$core.Deprecated('Use messageListResponseDescriptor instead')
const MessageListResponse$json = {
  '1': 'MessageListResponse',
  '2': [
    {
      '1': 'messages',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.Message',
      '10': 'messages'
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

/// Descriptor for `MessageListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageListResponseDescriptor = $convert.base64Decode(
    'ChNNZXNzYWdlTGlzdFJlc3BvbnNlEjQKCG1lc3NhZ2VzGAEgAygLMhgud2VkZGluZy51c2VyLn'
    'YxLk1lc3NhZ2VSCG1lc3NhZ2VzEkMKCnBhZ2luYXRpb24YAiABKAsyIy53ZWRkaW5nLnVzZXIu'
    'djEuUGFnaW5hdGlvblJlc3BvbnNlUgpwYWdpbmF0aW9u');

@$core.Deprecated('Use sendMessageRequestDescriptor instead')
const SendMessageRequest$json = {
  '1': 'SendMessageRequest',
  '2': [
    {'1': 'conversation_id', '3': 1, '4': 1, '5': 9, '10': 'conversationId'},
    {'1': 'content', '3': 2, '4': 1, '5': 9, '10': 'content'},
    {
      '1': 'metadata',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.MetaData',
      '10': 'metadata'
    },
  ],
};

/// Descriptor for `SendMessageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendMessageRequestDescriptor = $convert.base64Decode(
    'ChJTZW5kTWVzc2FnZVJlcXVlc3QSJwoPY29udmVyc2F0aW9uX2lkGAEgASgJUg5jb252ZXJzYX'
    'Rpb25JZBIYCgdjb250ZW50GAIgASgJUgdjb250ZW50EjUKCG1ldGFkYXRhGAMgASgLMhkud2Vk'
    'ZGluZy51c2VyLnYxLk1ldGFEYXRhUghtZXRhZGF0YQ==');

@$core.Deprecated('Use markMessageAsReadRequestDescriptor instead')
const MarkMessageAsReadRequest$json = {
  '1': 'MarkMessageAsReadRequest',
  '2': [
    {'1': 'conversation_id', '3': 1, '4': 1, '5': 9, '10': 'conversationId'},
    {'1': 'message_id', '3': 2, '4': 1, '5': 9, '10': 'messageId'},
  ],
};

/// Descriptor for `MarkMessageAsReadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markMessageAsReadRequestDescriptor =
    $convert.base64Decode(
        'ChhNYXJrTWVzc2FnZUFzUmVhZFJlcXVlc3QSJwoPY29udmVyc2F0aW9uX2lkGAEgASgJUg5jb2'
        '52ZXJzYXRpb25JZBIdCgptZXNzYWdlX2lkGAIgASgJUgltZXNzYWdlSWQ=');

@$core.Deprecated('Use markMessageAsReadResponseDescriptor instead')
const MarkMessageAsReadResponse$json = {
  '1': 'MarkMessageAsReadResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `MarkMessageAsReadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markMessageAsReadResponseDescriptor =
    $convert.base64Decode(
        'ChlNYXJrTWVzc2FnZUFzUmVhZFJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSGA'
        'oHbWVzc2FnZRgCIAEoCVIHbWVzc2FnZQ==');

@$core.Deprecated('Use createConversationRequestDescriptor instead')
const CreateConversationRequest$json = {
  '1': 'CreateConversationRequest',
  '2': [
    {'1': 'participant_ids', '3': 1, '4': 3, '5': 9, '10': 'participantIds'},
    {'1': 'initial_message', '3': 2, '4': 1, '5': 9, '10': 'initialMessage'},
  ],
};

/// Descriptor for `CreateConversationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createConversationRequestDescriptor = $convert.base64Decode(
    'ChlDcmVhdGVDb252ZXJzYXRpb25SZXF1ZXN0EicKD3BhcnRpY2lwYW50X2lkcxgBIAMoCVIOcG'
    'FydGljaXBhbnRJZHMSJwoPaW5pdGlhbF9tZXNzYWdlGAIgASgJUg5pbml0aWFsTWVzc2FnZQ==');

@$core.Deprecated('Use watchMessagesRequestDescriptor instead')
const WatchMessagesRequest$json = {
  '1': 'WatchMessagesRequest',
  '2': [
    {'1': 'conversation_id', '3': 1, '4': 1, '5': 9, '10': 'conversationId'},
  ],
};

/// Descriptor for `WatchMessagesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchMessagesRequestDescriptor = $convert.base64Decode(
    'ChRXYXRjaE1lc3NhZ2VzUmVxdWVzdBInCg9jb252ZXJzYXRpb25faWQYASABKAlSDmNvbnZlcn'
    'NhdGlvbklk');

@$core.Deprecated('Use watchConversationsRequestDescriptor instead')
const WatchConversationsRequest$json = {
  '1': 'WatchConversationsRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `WatchConversationsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchConversationsRequestDescriptor =
    $convert.base64Decode(
        'ChlXYXRjaENvbnZlcnNhdGlvbnNSZXF1ZXN0EhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZA==');

@$core.Deprecated('Use conversationDescriptor instead')
const Conversation$json = {
  '1': 'Conversation',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {
      '1': 'participants',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.wedding.user.v1.ConversationParticipant',
      '10': 'participants'
    },
    {
      '1': 'last_message',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.Message',
      '10': 'lastMessage'
    },
    {'1': 'unread_count', '3': 4, '4': 1, '5': 5, '10': 'unreadCount'},
    {'1': 'created_at', '3': 5, '4': 1, '5': 9, '10': 'createdAt'},
    {'1': 'updated_at', '3': 6, '4': 1, '5': 9, '10': 'updatedAt'},
  ],
};

/// Descriptor for `Conversation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List conversationDescriptor = $convert.base64Decode(
    'CgxDb252ZXJzYXRpb24SDgoCaWQYASABKAlSAmlkEkwKDHBhcnRpY2lwYW50cxgCIAMoCzIoLn'
    'dlZGRpbmcudXNlci52MS5Db252ZXJzYXRpb25QYXJ0aWNpcGFudFIMcGFydGljaXBhbnRzEjsK'
    'DGxhc3RfbWVzc2FnZRgDIAEoCzIYLndlZGRpbmcudXNlci52MS5NZXNzYWdlUgtsYXN0TWVzc2'
    'FnZRIhCgx1bnJlYWRfY291bnQYBCABKAVSC3VucmVhZENvdW50Eh0KCmNyZWF0ZWRfYXQYBSAB'
    'KAlSCWNyZWF0ZWRBdBIdCgp1cGRhdGVkX2F0GAYgASgJUgl1cGRhdGVkQXQ=');

@$core.Deprecated('Use conversationParticipantDescriptor instead')
const ConversationParticipant$json = {
  '1': 'ConversationParticipant',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {
      '1': 'user',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.User',
      '10': 'user'
    },
    {'1': 'is_admin', '3': 3, '4': 1, '5': 8, '10': 'isAdmin'},
    {'1': 'joined_at', '3': 4, '4': 1, '5': 9, '10': 'joinedAt'},
  ],
};

/// Descriptor for `ConversationParticipant`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List conversationParticipantDescriptor = $convert.base64Decode(
    'ChdDb252ZXJzYXRpb25QYXJ0aWNpcGFudBIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQSKQoEdX'
    'NlchgCIAEoCzIVLndlZGRpbmcudXNlci52MS5Vc2VyUgR1c2VyEhkKCGlzX2FkbWluGAMgASgI'
    'Ugdpc0FkbWluEhsKCWpvaW5lZF9hdBgEIAEoCVIIam9pbmVkQXQ=');

@$core.Deprecated('Use messageDescriptor instead')
const Message$json = {
  '1': 'Message',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'conversation_id', '3': 2, '4': 1, '5': 9, '10': 'conversationId'},
    {'1': 'sender_id', '3': 3, '4': 1, '5': 9, '10': 'senderId'},
    {
      '1': 'sender',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.User',
      '10': 'sender'
    },
    {'1': 'content', '3': 5, '4': 1, '5': 9, '10': 'content'},
    {
      '1': 'metadata',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.MetaData',
      '10': 'metadata'
    },
    {'1': 'is_read', '3': 7, '4': 1, '5': 8, '10': 'isRead'},
    {'1': 'read_at', '3': 8, '4': 1, '5': 9, '10': 'readAt'},
    {'1': 'created_at', '3': 9, '4': 1, '5': 9, '10': 'createdAt'},
  ],
};

/// Descriptor for `Message`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageDescriptor = $convert.base64Decode(
    'CgdNZXNzYWdlEg4KAmlkGAEgASgJUgJpZBInCg9jb252ZXJzYXRpb25faWQYAiABKAlSDmNvbn'
    'ZlcnNhdGlvbklkEhsKCXNlbmRlcl9pZBgDIAEoCVIIc2VuZGVySWQSLQoGc2VuZGVyGAQgASgL'
    'MhUud2VkZGluZy51c2VyLnYxLlVzZXJSBnNlbmRlchIYCgdjb250ZW50GAUgASgJUgdjb250ZW'
    '50EjUKCG1ldGFkYXRhGAYgASgLMhkud2VkZGluZy51c2VyLnYxLk1ldGFEYXRhUghtZXRhZGF0'
    'YRIXCgdpc19yZWFkGAcgASgIUgZpc1JlYWQSFwoHcmVhZF9hdBgIIAEoCVIGcmVhZEF0Eh0KCm'
    'NyZWF0ZWRfYXQYCSABKAlSCWNyZWF0ZWRBdA==');
