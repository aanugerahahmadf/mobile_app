import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/errors/app_error_codes.dart';

void main() {
  group('AppErrorCodes', () {
    test('has anErrorOccurred constant', () {
      expect(AppErrorCodes.anErrorOccurred, isNotEmpty);
    });

    test('has loginFailed constant', () {
      expect(AppErrorCodes.loginFailed, equals('login_failed'));
    });

    test('has facebookLoginFailed constant', () {
      expect(AppErrorCodes.facebookLoginFailed, equals('facebook_login_failed'));
    });

    test('has appleLoginFailed constant', () {
      expect(AppErrorCodes.appleLoginFailed, equals('apple_login_failed'));
    });

    test('has failedGetFacebookToken constant', () {
      expect(AppErrorCodes.failedGetFacebookToken, equals('failed_get_facebook_token'));
    });

    test('has failedGetAppleToken constant', () {
      expect(AppErrorCodes.failedGetAppleToken, equals('failed_get_apple_token'));
    });

    test('has googleLoginFailed constant', () {
      expect(AppErrorCodes.googleLoginFailed, equals('google_login_failed'));
    });

    test('all constants are non-empty strings', () {
      final constants = <String>[
        AppErrorCodes.anErrorOccurred,
        AppErrorCodes.failedLoadProfile,
        AppErrorCodes.failedUpdateProfile,
        AppErrorCodes.failedUploadAvatar,
        AppErrorCodes.failedUpdateKtpNumber,
        AppErrorCodes.failedUploadKtp,
        AppErrorCodes.failedUploadSelfie,
        AppErrorCodes.failedUploadFaceScan,
        AppErrorCodes.failedChangePassword,
        AppErrorCodes.failedLoadOrders,
        AppErrorCodes.failedCreateOrder,
        AppErrorCodes.failedProcessPayment,
        AppErrorCodes.failedLoadNotifications,
        AppErrorCodes.failedLoadConversations,
        AppErrorCodes.failedLoadMessages,
        AppErrorCodes.failedSendMessage,
        AppErrorCodes.failedLoadCart,
        AppErrorCodes.failedRemoveCartItem,
        AppErrorCodes.loginFailed,
        AppErrorCodes.failedGetGoogleToken,
        AppErrorCodes.googleLoginFailed,
        AppErrorCodes.registrationFailed,
        AppErrorCodes.failedLoadItemData,
        AppErrorCodes.failedGetOrderId,
        AppErrorCodes.failedGetPaymentToken,
        AppErrorCodes.searchFailedTryAgain,
        AppErrorCodes.selectTwoImagesArithmetic,
        AppErrorCodes.imageSearchFailed,
        AppErrorCodes.arithmeticSearchFailed,
        AppErrorCodes.failedCancelOrder,
        AppErrorCodes.failedGetFacebookToken,
        AppErrorCodes.facebookLoginFailed,
        AppErrorCodes.failedGetAppleToken,
        AppErrorCodes.appleLoginFailed,
      ];
      for (final c in constants) {
        expect(c.isNotEmpty, isTrue, reason: 'Constant $c should not be empty');
      }
    });
  });
}
