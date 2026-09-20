import 'package:mobile_app/l10n/app_localizations.dart';
import '../app_error_codes/app_error_codes.dart';

abstract final class LocalizedError {
  static String of(AppLocalizations l, String errorCode) {
    final code = errorCode.startsWith('Exception: ') ? errorCode.substring(11) : errorCode;
    switch (code) {
      case AppErrorCodes.anErrorOccurred:
        return l.anErrorOccurred;
      case AppErrorCodes.failedLoadProfile:
        return l.failedLoadProfile;
      case AppErrorCodes.failedUpdateProfile:
        return l.failedUpdateProfile;
      case AppErrorCodes.failedUploadAvatar:
        return l.failedUploadAvatar;
      case AppErrorCodes.failedUpdateKtpNumber:
        return l.failedUpdateKtpNumber;
      case AppErrorCodes.failedUploadKtp:
        return l.failedUploadKtp;
      case AppErrorCodes.failedUploadSelfie:
        return l.failedUploadSelfie;
      case AppErrorCodes.failedUploadFaceScan:
        return l.failedUploadFaceScan;
      case AppErrorCodes.failedChangePassword:
        return l.failedChangePassword;
      case AppErrorCodes.failedLoadOrders:
        return l.failedLoadOrders;
      case AppErrorCodes.failedCreateOrder:
        return l.failedCreateOrder;
      case AppErrorCodes.failedProcessPayment:
        return l.failedProcessPayment;
      case AppErrorCodes.failedLoadNotifications:
        return l.failedLoadNotifications;
      case AppErrorCodes.failedLoadConversations:
        return l.failedLoadConversations;
      case AppErrorCodes.failedLoadMessages:
        return l.failedLoadMessages;
      case AppErrorCodes.failedSendMessage:
        return l.failedSendMessage;
      case AppErrorCodes.failedLoadCart:
        return l.failedLoadCart;
      case AppErrorCodes.failedRemoveCartItem:
        return l.failedRemoveItem;
      case AppErrorCodes.loginFailed:
        return l.loginFailed;
      case AppErrorCodes.failedGetGoogleToken:
        return l.failedGetGoogleToken;
      case AppErrorCodes.googleLoginFailed:
        return l.googleLoginFailed;
      case AppErrorCodes.registrationFailed:
        return l.registrationFailed;
      case AppErrorCodes.failedLoadItemData:
        return l.failedLoadItemData;
      case AppErrorCodes.failedGetOrderId:
        return l.failedGetOrderId;
      case AppErrorCodes.failedGetPaymentToken:
        return l.failedGetPaymentToken;
      case AppErrorCodes.searchFailedTryAgain:
        return l.searchFailedTryAgain;
      case AppErrorCodes.selectTwoImagesArithmetic:
        return l.selectTwoImagesArithmetic;
      case AppErrorCodes.imageSearchFailed:
        return l.imageSearchFailed;
      case AppErrorCodes.arithmeticSearchFailed:
        return l.arithmeticSearchFailedMsg;
      case AppErrorCodes.failedCancelOrder:
        return l.failedCancelOrder;
      case AppErrorCodes.failedGetFacebookToken:
        return l.failedGetFacebookToken;
      case AppErrorCodes.facebookLoginFailed:
        return l.facebookLoginFailed;
      case AppErrorCodes.failedGetAppleToken:
        return l.failedGetAppleToken;
      case AppErrorCodes.appleLoginFailed:
        return l.appleLoginFailed;
      case AppErrorCodes.identityNumberAlreadyRegistered:
        return l.identityNumberAlreadyRegistered;
      case AppErrorCodes.googleAccountAlreadyRegistered:
        return l.googleAccountAlreadyRegistered;
      case AppErrorCodes.facebookAccountAlreadyRegistered:
        return l.facebookAccountAlreadyRegistered;
      default:
        return code;
    }
  }
}
