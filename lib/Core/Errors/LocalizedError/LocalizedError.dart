import 'package:mobile_app/L10n/AppLocalizations.dart';
import '../AppErrorCodes/AppErrorCodes.dart';

abstract final class LocalizedError {
  static String of(AppLocalizations l, String errorCode) {
    var code = errorCode.trim();
    if (code.startsWith('Exception: ')) {
      code = code.substring(11).trim();
    }
    if (code.startsWith('StateError: ')) {
      code = code.substring(12).trim();
    }
    if (code.isEmpty ||
        code == 'Failed' ||
        code == 'failed' ||
        code == 'Error' ||
        code == 'error' ||
        code == 'Unexpected response') {
      return l.anErrorOccurred;
    }
    if (code.contains('SocketException') ||
        code.contains('connectionTimeout') ||
        code.contains('sendTimeout') ||
        code.contains('receiveTimeout')) {
      return l.networkError;
    }

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
      case AppErrorCodes.failedUpdateOrder:
        return l.failedUpdateOrder;
      case AppErrorCodes.failedDeleteOrder:
        return l.failedDeleteOrder;
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
      case AppErrorCodes.networkError:
        return l.networkError;
      case AppErrorCodes.serverError:
        return l.serverError;
      case AppErrorCodes.sessionExpired:
        return l.sessionExpired;
      case AppErrorCodes.validationFailed:
        return l.validationFailed;
      case AppErrorCodes.dataNotFound:
        return l.dataNotFound;
      case AppErrorCodes.accessDenied:
        return l.accessDenied;
      case AppErrorCodes.graphqlSchemaError:
        return l.graphqlSchemaError;
      case AppErrorCodes.reviewFailed:
        return l.reviewFailed;
      case AppErrorCodes.failedUpdateReview:
        return l.failedUpdateReview;
      case AppErrorCodes.failedDeleteReview:
        return l.failedDeleteReview;
      case AppErrorCodes.failedLoadReviews:
        return l.failedLoadReviews;
      case AppErrorCodes.failedProcessVote:
        return l.failedProcessVote;
      case AppErrorCodes.locationPermissionDenied:
        return l.locationPermissionDenied;
      case AppErrorCodes.locationPermissionPermanentlyDenied:
        return l.locationPermissionPermanentlyDenied;
      case AppErrorCodes.failedGetLocation:
        return l.failedGetLocation;
      case AppErrorCodes.enterAddressDetails:
        return l.enterAddressDetails;
      default:
        return code;
    }
  }
}
