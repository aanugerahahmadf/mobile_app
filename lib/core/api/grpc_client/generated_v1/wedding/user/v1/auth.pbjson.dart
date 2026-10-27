// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/auth.proto.

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

@$core.Deprecated('Use loginRequestDescriptor instead')
const LoginRequest$json = {
  '1': 'LoginRequest',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
    {'1': 'device_token', '3': 3, '4': 1, '5': 9, '10': 'deviceToken'},
    {'1': 'device_type', '3': 4, '4': 1, '5': 9, '10': 'deviceType'},
    {'1': 'remember_me', '3': 5, '4': 1, '5': 8, '10': 'rememberMe'},
  ],
};

/// Descriptor for `LoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginRequestDescriptor = $convert.base64Decode(
    'CgxMb2dpblJlcXVlc3QSFAoFZW1haWwYASABKAlSBWVtYWlsEhoKCHBhc3N3b3JkGAIgASgJUg'
    'hwYXNzd29yZBIhCgxkZXZpY2VfdG9rZW4YAyABKAlSC2RldmljZVRva2VuEh8KC2RldmljZV90'
    'eXBlGAQgASgJUgpkZXZpY2VUeXBlEh8KC3JlbWVtYmVyX21lGAUgASgIUgpyZW1lbWJlck1l');

@$core.Deprecated('Use registerRequestDescriptor instead')
const RegisterRequest$json = {
  '1': 'RegisterRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '10': 'email'},
    {'1': 'password', '3': 3, '4': 1, '5': 9, '10': 'password'},
    {
      '1': 'password_confirmation',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'passwordConfirmation'
    },
    {'1': 'phone', '3': 5, '4': 1, '5': 9, '10': 'phone'},
    {'1': 'accept_terms', '3': 6, '4': 1, '5': 8, '10': 'acceptTerms'},
    {
      '1': 'marketing_consent',
      '3': 7,
      '4': 1,
      '5': 8,
      '10': 'marketingConsent'
    },
  ],
};

/// Descriptor for `RegisterRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerRequestDescriptor = $convert.base64Decode(
    'Cg9SZWdpc3RlclJlcXVlc3QSEgoEbmFtZRgBIAEoCVIEbmFtZRIUCgVlbWFpbBgCIAEoCVIFZW'
    '1haWwSGgoIcGFzc3dvcmQYAyABKAlSCHBhc3N3b3JkEjMKFXBhc3N3b3JkX2NvbmZpcm1hdGlv'
    'bhgEIAEoCVIUcGFzc3dvcmRDb25maXJtYXRpb24SFAoFcGhvbmUYBSABKAlSBXBob25lEiEKDG'
    'FjY2VwdF90ZXJtcxgGIAEoCFILYWNjZXB0VGVybXMSKwoRbWFya2V0aW5nX2NvbnNlbnQYByAB'
    'KAhSEG1hcmtldGluZ0NvbnNlbnQ=');

@$core.Deprecated('Use logoutRequestDescriptor instead')
const LogoutRequest$json = {
  '1': 'LogoutRequest',
  '2': [
    {'1': 'refresh_token', '3': 1, '4': 1, '5': 9, '10': 'refreshToken'},
  ],
};

/// Descriptor for `LogoutRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutRequestDescriptor = $convert.base64Decode(
    'Cg1Mb2dvdXRSZXF1ZXN0EiMKDXJlZnJlc2hfdG9rZW4YASABKAlSDHJlZnJlc2hUb2tlbg==');

@$core.Deprecated('Use logoutResponseDescriptor instead')
const LogoutResponse$json = {
  '1': 'LogoutResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `LogoutResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutResponseDescriptor = $convert.base64Decode(
    'Cg5Mb2dvdXRSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEhgKB21lc3NhZ2UYAi'
    'ABKAlSB21lc3NhZ2U=');

@$core.Deprecated('Use refreshTokenRequestDescriptor instead')
const RefreshTokenRequest$json = {
  '1': 'RefreshTokenRequest',
  '2': [
    {'1': 'refresh_token', '3': 1, '4': 1, '5': 9, '10': 'refreshToken'},
  ],
};

/// Descriptor for `RefreshTokenRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refreshTokenRequestDescriptor = $convert.base64Decode(
    'ChNSZWZyZXNoVG9rZW5SZXF1ZXN0EiMKDXJlZnJlc2hfdG9rZW4YASABKAlSDHJlZnJlc2hUb2'
    'tlbg==');

@$core.Deprecated('Use forgotPasswordRequestDescriptor instead')
const ForgotPasswordRequest$json = {
  '1': 'ForgotPasswordRequest',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
  ],
};

/// Descriptor for `ForgotPasswordRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List forgotPasswordRequestDescriptor =
    $convert.base64Decode(
        'ChVGb3Jnb3RQYXNzd29yZFJlcXVlc3QSFAoFZW1haWwYASABKAlSBWVtYWls');

@$core.Deprecated('Use forgotPasswordResponseDescriptor instead')
const ForgotPasswordResponse$json = {
  '1': 'ForgotPasswordResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `ForgotPasswordResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List forgotPasswordResponseDescriptor =
    $convert.base64Decode(
        'ChZGb3Jnb3RQYXNzd29yZFJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSGAoHbW'
        'Vzc2FnZRgCIAEoCVIHbWVzc2FnZQ==');

@$core.Deprecated('Use resetPasswordRequestDescriptor instead')
const ResetPasswordRequest$json = {
  '1': 'ResetPasswordRequest',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '10': 'email'},
    {'1': 'password', '3': 3, '4': 1, '5': 9, '10': 'password'},
    {
      '1': 'password_confirmation',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'passwordConfirmation'
    },
  ],
};

/// Descriptor for `ResetPasswordRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resetPasswordRequestDescriptor = $convert.base64Decode(
    'ChRSZXNldFBhc3N3b3JkUmVxdWVzdBIUCgV0b2tlbhgBIAEoCVIFdG9rZW4SFAoFZW1haWwYAi'
    'ABKAlSBWVtYWlsEhoKCHBhc3N3b3JkGAMgASgJUghwYXNzd29yZBIzChVwYXNzd29yZF9jb25m'
    'aXJtYXRpb24YBCABKAlSFHBhc3N3b3JkQ29uZmlybWF0aW9u');

@$core.Deprecated('Use resetPasswordResponseDescriptor instead')
const ResetPasswordResponse$json = {
  '1': 'ResetPasswordResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `ResetPasswordResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resetPasswordResponseDescriptor = $convert.base64Decode(
    'ChVSZXNldFBhc3N3b3JkUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIYCgdtZX'
    'NzYWdlGAIgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use verifyEmailRequestDescriptor instead')
const VerifyEmailRequest$json = {
  '1': 'VerifyEmailRequest',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '10': 'email'},
  ],
};

/// Descriptor for `VerifyEmailRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyEmailRequestDescriptor = $convert.base64Decode(
    'ChJWZXJpZnlFbWFpbFJlcXVlc3QSFAoFdG9rZW4YASABKAlSBXRva2VuEhQKBWVtYWlsGAIgAS'
    'gJUgVlbWFpbA==');

@$core.Deprecated('Use verifyEmailResponseDescriptor instead')
const VerifyEmailResponse$json = {
  '1': 'VerifyEmailResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `VerifyEmailResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyEmailResponseDescriptor = $convert.base64Decode(
    'ChNWZXJpZnlFbWFpbFJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSGAoHbWVzc2'
    'FnZRgCIAEoCVIHbWVzc2FnZQ==');

@$core.Deprecated('Use resendVerificationRequestDescriptor instead')
const ResendVerificationRequest$json = {
  '1': 'ResendVerificationRequest',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
  ],
};

/// Descriptor for `ResendVerificationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resendVerificationRequestDescriptor =
    $convert.base64Decode(
        'ChlSZXNlbmRWZXJpZmljYXRpb25SZXF1ZXN0EhQKBWVtYWlsGAEgASgJUgVlbWFpbA==');

@$core.Deprecated('Use resendVerificationResponseDescriptor instead')
const ResendVerificationResponse$json = {
  '1': 'ResendVerificationResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `ResendVerificationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resendVerificationResponseDescriptor =
    $convert.base64Decode(
        'ChpSZXNlbmRWZXJpZmljYXRpb25SZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEh'
        'gKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2U=');

@$core.Deprecated('Use meRequestDescriptor instead')
const MeRequest$json = {
  '1': 'MeRequest',
};

/// Descriptor for `MeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List meRequestDescriptor =
    $convert.base64Decode('CglNZVJlcXVlc3Q=');

@$core.Deprecated('Use authResponseDescriptor instead')
const AuthResponse$json = {
  '1': 'AuthResponse',
  '2': [
    {
      '1': 'user',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.wedding.user.v1.User',
      '10': 'user'
    },
    {'1': 'access_token', '3': 2, '4': 1, '5': 9, '10': 'accessToken'},
    {'1': 'token_type', '3': 3, '4': 1, '5': 9, '10': 'tokenType'},
    {'1': 'expires_in', '3': 4, '4': 1, '5': 5, '10': 'expiresIn'},
    {'1': 'refresh_token', '3': 5, '4': 1, '5': 9, '10': 'refreshToken'},
    {
      '1': 'refresh_expires_in',
      '3': 6,
      '4': 1,
      '5': 5,
      '10': 'refreshExpiresIn'
    },
  ],
};

/// Descriptor for `AuthResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authResponseDescriptor = $convert.base64Decode(
    'CgxBdXRoUmVzcG9uc2USKQoEdXNlchgBIAEoCzIVLndlZGRpbmcudXNlci52MS5Vc2VyUgR1c2'
    'VyEiEKDGFjY2Vzc190b2tlbhgCIAEoCVILYWNjZXNzVG9rZW4SHQoKdG9rZW5fdHlwZRgDIAEo'
    'CVIJdG9rZW5UeXBlEh0KCmV4cGlyZXNfaW4YBCABKAVSCWV4cGlyZXNJbhIjCg1yZWZyZXNoX3'
    'Rva2VuGAUgASgJUgxyZWZyZXNoVG9rZW4SLAoScmVmcmVzaF9leHBpcmVzX2luGAYgASgFUhBy'
    'ZWZyZXNoRXhwaXJlc0lu');

@$core.Deprecated('Use userDescriptor instead')
const User$json = {
  '1': 'User',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'email', '3': 3, '4': 1, '5': 9, '10': 'email'},
    {'1': 'phone', '3': 4, '4': 1, '5': 9, '10': 'phone'},
    {'1': 'avatar', '3': 5, '4': 1, '5': 9, '10': 'avatar'},
    {'1': 'email_verified_at', '3': 6, '4': 1, '5': 9, '10': 'emailVerifiedAt'},
    {'1': 'address', '3': 7, '4': 1, '5': 9, '10': 'address'},
    {'1': 'city', '3': 8, '4': 1, '5': 9, '10': 'city'},
    {'1': 'province', '3': 9, '4': 1, '5': 9, '10': 'province'},
    {'1': 'postal_code', '3': 10, '4': 1, '5': 9, '10': 'postalCode'},
    {'1': 'date_of_birth', '3': 11, '4': 1, '5': 9, '10': 'dateOfBirth'},
    {
      '1': 'gender',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.wedding.user.v1.Gender',
      '10': 'gender'
    },
    {
      '1': 'notification_email',
      '3': 13,
      '4': 1,
      '5': 8,
      '10': 'notificationEmail'
    },
    {'1': 'notification_sms', '3': 14, '4': 1, '5': 8, '10': 'notificationSms'},
    {
      '1': 'notification_push',
      '3': 15,
      '4': 1,
      '5': 8,
      '10': 'notificationPush'
    },
    {'1': 'language', '3': 16, '4': 1, '5': 9, '10': 'language'},
    {'1': 'currency', '3': 17, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'timezone', '3': 18, '4': 1, '5': 9, '10': 'timezone'},
    {'1': 'roles', '3': 19, '4': 3, '5': 9, '10': 'roles'},
    {'1': 'created_at', '3': 20, '4': 1, '5': 9, '10': 'createdAt'},
    {'1': 'updated_at', '3': 21, '4': 1, '5': 9, '10': 'updatedAt'},
    {
      '1': 'profile_completion',
      '3': 22,
      '4': 1,
      '5': 1,
      '10': 'profileCompletion'
    },
  ],
};

/// Descriptor for `User`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userDescriptor = $convert.base64Decode(
    'CgRVc2VyEg4KAmlkGAEgASgJUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEhQKBWVtYWlsGAMgAS'
    'gJUgVlbWFpbBIUCgVwaG9uZRgEIAEoCVIFcGhvbmUSFgoGYXZhdGFyGAUgASgJUgZhdmF0YXIS'
    'KgoRZW1haWxfdmVyaWZpZWRfYXQYBiABKAlSD2VtYWlsVmVyaWZpZWRBdBIYCgdhZGRyZXNzGA'
    'cgASgJUgdhZGRyZXNzEhIKBGNpdHkYCCABKAlSBGNpdHkSGgoIcHJvdmluY2UYCSABKAlSCHBy'
    'b3ZpbmNlEh8KC3Bvc3RhbF9jb2RlGAogASgJUgpwb3N0YWxDb2RlEiIKDWRhdGVfb2ZfYmlydG'
    'gYCyABKAlSC2RhdGVPZkJpcnRoEi8KBmdlbmRlchgMIAEoDjIXLndlZGRpbmcudXNlci52MS5H'
    'ZW5kZXJSBmdlbmRlchItChJub3RpZmljYXRpb25fZW1haWwYDSABKAhSEW5vdGlmaWNhdGlvbk'
    'VtYWlsEikKEG5vdGlmaWNhdGlvbl9zbXMYDiABKAhSD25vdGlmaWNhdGlvblNtcxIrChFub3Rp'
    'ZmljYXRpb25fcHVzaBgPIAEoCFIQbm90aWZpY2F0aW9uUHVzaBIaCghsYW5ndWFnZRgQIAEoCV'
    'IIbGFuZ3VhZ2USGgoIY3VycmVuY3kYESABKAlSCGN1cnJlbmN5EhoKCHRpbWV6b25lGBIgASgJ'
    'Ugh0aW1lem9uZRIUCgVyb2xlcxgTIAMoCVIFcm9sZXMSHQoKY3JlYXRlZF9hdBgUIAEoCVIJY3'
    'JlYXRlZEF0Eh0KCnVwZGF0ZWRfYXQYFSABKAlSCXVwZGF0ZWRBdBItChJwcm9maWxlX2NvbXBs'
    'ZXRpb24YFiABKAFSEXByb2ZpbGVDb21wbGV0aW9u');
