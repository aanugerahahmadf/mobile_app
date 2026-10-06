import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/errors/app_error_codes/app_error_codes.dart';

void main() {
  group('AppErrorCodes - Authentication Errors', () {
    test('has loginFailed constant', () {
      expect(AppErrorCodes.loginFailed, equals('login_failed'));
    });

    test('has googleLoginFailed constant', () {
      expect(AppErrorCodes.googleLoginFailed, equals('google_login_failed'));
    });

    test('has facebookLoginFailed constant', () {
      expect(AppErrorCodes.facebookLoginFailed, equals('facebook_login_failed'));
    });

    test('has appleLoginFailed constant', () {
      expect(AppErrorCodes.appleLoginFailed, equals('apple_login_failed'));
    });

    test('has failedGetGoogleToken constant', () {
      expect(AppErrorCodes.failedGetGoogleToken, equals('failed_get_google_token'));
    });

    test('has failedGetFacebookToken constant', () {
      expect(AppErrorCodes.failedGetFacebookToken, equals('failed_get_facebook_token'));
    });

    test('has failedGetAppleToken constant', () {
      expect(AppErrorCodes.failedGetAppleToken, equals('failed_get_apple_token'));
    });

    test('has registrationFailed constant', () {
      expect(AppErrorCodes.registrationFailed, isNotEmpty);
    });
  });

  group('AppErrorCodes - Profile Errors', () {
    test('has failedLoadProfile constant', () {
      expect(AppErrorCodes.failedLoadProfile, isNotEmpty);
    });

    test('has failedUpdateProfile constant', () {
      expect(AppErrorCodes.failedUpdateProfile, isNotEmpty);
    });

    test('has failedUploadAvatar constant', () {
      expect(AppErrorCodes.failedUploadAvatar, isNotEmpty);
    });

    test('has failedUpdateKtpNumber constant', () {
      expect(AppErrorCodes.failedUpdateKtpNumber, isNotEmpty);
    });

    test('has failedUploadKtp constant', () {
      expect(AppErrorCodes.failedUploadKtp, isNotEmpty);
    });

    test('has failedUploadSelfie constant', () {
      expect(AppErrorCodes.failedUploadSelfie, isNotEmpty);
    });

    test('has failedUploadFaceScan constant', () {
      expect(AppErrorCodes.failedUploadFaceScan, isNotEmpty);
    });

    test('has failedChangePassword constant', () {
      expect(AppErrorCodes.failedChangePassword, isNotEmpty);
    });
  });

  group('AppErrorCodes - Order & Payment Errors', () {
    test('has failedLoadOrders constant', () {
      expect(AppErrorCodes.failedLoadOrders, isNotEmpty);
    });

    test('has failedCreateOrder constant', () {
      expect(AppErrorCodes.failedCreateOrder, isNotEmpty);
    });

    test('has failedProcessPayment constant', () {
      expect(AppErrorCodes.failedProcessPayment, isNotEmpty);
    });

    test('has failedGetOrderId constant', () {
      expect(AppErrorCodes.failedGetOrderId, isNotEmpty);
    });

    test('has failedGetPaymentToken constant', () {
      expect(AppErrorCodes.failedGetPaymentToken, isNotEmpty);
    });

    test('has failedCancelOrder constant', () {
      expect(AppErrorCodes.failedCancelOrder, isNotEmpty);
    });
  });

  group('AppErrorCodes - Notification Errors', () {
    test('has failedLoadNotifications constant', () {
      expect(AppErrorCodes.failedLoadNotifications, isNotEmpty);
    });
  });

  group('AppErrorCodes - Chat Errors', () {
    test('has failedLoadConversations constant', () {
      expect(AppErrorCodes.failedLoadConversations, isNotEmpty);
    });

    test('has failedLoadMessages constant', () {
      expect(AppErrorCodes.failedLoadMessages, isNotEmpty);
    });

    test('has failedSendMessage constant', () {
      expect(AppErrorCodes.failedSendMessage, isNotEmpty);
    });
  });

  group('AppErrorCodes - Cart Errors', () {
    test('has failedLoadCart constant', () {
      expect(AppErrorCodes.failedLoadCart, isNotEmpty);
    });

    test('has failedRemoveCartItem constant', () {
      expect(AppErrorCodes.failedRemoveCartItem, isNotEmpty);
    });
  });

  group('AppErrorCodes - Search Errors', () {
    test('has searchFailedTryAgain constant', () {
      expect(AppErrorCodes.searchFailedTryAgain, isNotEmpty);
    });

    test('has selectTwoImagesArithmetic constant', () {
      expect(AppErrorCodes.selectTwoImagesArithmetic, isNotEmpty);
    });

    test('has imageSearchFailed constant', () {
      expect(AppErrorCodes.imageSearchFailed, isNotEmpty);
    });

    test('has arithmeticSearchFailed constant', () {
      expect(AppErrorCodes.arithmeticSearchFailed, isNotEmpty);
    });
  });

  group('AppErrorCodes - General Errors', () {
    test('has anErrorOccurred constant', () {
      expect(AppErrorCodes.anErrorOccurred, isNotEmpty);
    });

    test('has failedLoadItemData constant', () {
      expect(AppErrorCodes.failedLoadItemData, isNotEmpty);
    });
  });

  group('AppErrorCodes - All Constants Validation', () {
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

    test('all constants are unique', () {
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
      final uniqueConstants = constants.toSet();
      expect(uniqueConstants.length, constants.length,
          reason: 'All constants should be unique');
    });

    test('error codes follow snake_case convention', () {
      final constants = <String>[
        AppErrorCodes.loginFailed,
        AppErrorCodes.googleLoginFailed,
        AppErrorCodes.facebookLoginFailed,
        AppErrorCodes.appleLoginFailed,
        AppErrorCodes.failedGetGoogleToken,
        AppErrorCodes.failedGetFacebookToken,
        AppErrorCodes.failedGetAppleToken,
        AppErrorCodes.registrationFailed,
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
        AppErrorCodes.failedLoadItemData,
        AppErrorCodes.failedGetOrderId,
        AppErrorCodes.failedGetPaymentToken,
        AppErrorCodes.searchFailedTryAgain,
        AppErrorCodes.selectTwoImagesArithmetic,
        AppErrorCodes.imageSearchFailed,
        AppErrorCodes.arithmeticSearchFailed,
        AppErrorCodes.failedCancelOrder,
      ];
      final snakeCaseRegex = RegExp(r'^[a-z][a-z0-9_]*$');
      for (final c in constants) {
        expect(snakeCaseRegex.hasMatch(c), isTrue,
            reason: 'Constant $c should follow snake_case convention');
      }
    });
  });
}
