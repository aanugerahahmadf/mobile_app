import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'L10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @actionAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get actionAdd;

  /// No description provided for @actionCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get actionCreate;

  /// No description provided for @actionPick.
  ///
  /// In en, this message translates to:
  /// **'Pick'**
  String get actionPick;

  /// No description provided for @actionScan.
  ///
  /// In en, this message translates to:
  /// **'Scans'**
  String get actionScan;

  /// No description provided for @actionUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get actionUpload;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @activeStatus.
  ///
  /// In en, this message translates to:
  /// **'Active Status'**
  String get activeStatus;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @addAccount.
  ///
  /// In en, this message translates to:
  /// **'Add Account'**
  String get addAccount;

  /// No description provided for @addActiveWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Add your active WhatsApp number'**
  String get addActiveWhatsapp;

  /// No description provided for @addAddress.
  ///
  /// In en, this message translates to:
  /// **'Add Address'**
  String get addAddress;

  /// No description provided for @addFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to add'**
  String get addFailed;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// No description provided for @addedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Added successfully'**
  String get addedSuccess;

  /// No description provided for @aiComputerVision.
  ///
  /// In en, this message translates to:
  /// **'AI & Computer Vision'**
  String get aiComputerVision;

  /// No description provided for @aiUnavailable.
  ///
  /// In en, this message translates to:
  /// **'AI service unavailable. Photo saved, but not AI-verified.'**
  String get aiUnavailable;

  /// No description provided for @aiVerified.
  ///
  /// In en, this message translates to:
  /// **'AI Verified'**
  String get aiVerified;

  /// No description provided for @aiVerifiedDocument.
  ///
  /// In en, this message translates to:
  /// **'AI verified document'**
  String get aiVerifiedDocument;

  /// No description provided for @aiVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'AI verification failed'**
  String get aiVerificationFailed;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @addressHint.
  ///
  /// In en, this message translates to:
  /// **'Fill in street name, house number, RT/RW, etc.'**
  String get addressHint;

  /// No description provided for @searchAddress.
  ///
  /// In en, this message translates to:
  /// **'Search Address'**
  String get searchAddress;

  /// No description provided for @searchAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Type to search for a location...'**
  String get searchAddressHint;

  /// No description provided for @addressDetail.
  ///
  /// In en, this message translates to:
  /// **'Address Detail'**
  String get addressDetail;

  /// No description provided for @addressDetailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter detailed address (street, building, number)'**
  String get addressDetailHint;

  /// No description provided for @additionalDetail.
  ///
  /// In en, this message translates to:
  /// **'Additional Details'**
  String get additionalDetail;

  /// No description provided for @additionalDetailHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. house number 16, near mosque'**
  String get additionalDetailHint;

  /// No description provided for @labelAddress.
  ///
  /// In en, this message translates to:
  /// **'Label Address'**
  String get labelAddress;

  /// No description provided for @labelHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get labelHome;

  /// No description provided for @labelOffice.
  ///
  /// In en, this message translates to:
  /// **'Office'**
  String get labelOffice;

  /// No description provided for @accountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get accountNumber;

  /// No description provided for @accountHolder.
  ///
  /// In en, this message translates to:
  /// **'Account Holder'**
  String get accountHolder;

  /// No description provided for @accountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Your account has been deleted'**
  String get accountDeleted;

  /// No description provided for @bankAccount.
  ///
  /// In en, this message translates to:
  /// **'Destination Account'**
  String get bankAccount;

  /// No description provided for @bankName.
  ///
  /// In en, this message translates to:
  /// **'Bank Name'**
  String get bankName;

  /// No description provided for @sendNotification.
  ///
  /// In en, this message translates to:
  /// **'Send Notification'**
  String get sendNotification;

  /// No description provided for @allUsers.
  ///
  /// In en, this message translates to:
  /// **'All Users'**
  String get allUsers;

  /// No description provided for @autoScanHint.
  ///
  /// In en, this message translates to:
  /// **'The camera will detect the document and capture it automatically'**
  String get autoScanHint;

  /// No description provided for @selectUser.
  ///
  /// In en, this message translates to:
  /// **'Select User'**
  String get selectUser;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'User Name'**
  String get userName;

  /// No description provided for @packageName.
  ///
  /// In en, this message translates to:
  /// **'Package Name'**
  String get packageName;

  /// No description provided for @catalogName.
  ///
  /// In en, this message translates to:
  /// **'Catalog Name'**
  String get catalogName;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'MAP'**
  String get map;

  /// No description provided for @mrr.
  ///
  /// In en, this message translates to:
  /// **'MRR'**
  String get mrr;

  /// No description provided for @precision.
  ///
  /// In en, this message translates to:
  /// **'Precision'**
  String get precision;

  /// No description provided for @firstRankAccuracy.
  ///
  /// In en, this message translates to:
  /// **'First Rank Accuracy'**
  String get firstRankAccuracy;

  /// No description provided for @queryTime.
  ///
  /// In en, this message translates to:
  /// **'Query Time'**
  String get queryTime;

  /// No description provided for @evaluationTime.
  ///
  /// In en, this message translates to:
  /// **'Evaluation Time'**
  String get evaluationTime;

  /// No description provided for @totalImages.
  ///
  /// In en, this message translates to:
  /// **'Total Images'**
  String get totalImages;

  /// No description provided for @totalQueries.
  ///
  /// In en, this message translates to:
  /// **'Total Queries'**
  String get totalQueries;

  /// No description provided for @evaluate.
  ///
  /// In en, this message translates to:
  /// **'Evaluate'**
  String get evaluate;

  /// No description provided for @evaluationResult.
  ///
  /// In en, this message translates to:
  /// **'Evaluation Result'**
  String get evaluationResult;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @agree.
  ///
  /// In en, this message translates to:
  /// **'Agree'**
  String get agree;

  /// No description provided for @agreeAnd.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get agreeAnd;

  /// No description provided for @agreeComma.
  ///
  /// In en, this message translates to:
  /// **','**
  String get agreeComma;

  /// No description provided for @agreeJoinText.
  ///
  /// In en, this message translates to:
  /// **'By checking Agree & Join or Continue, you agree to '**
  String get agreeJoinText;

  /// No description provided for @agreeSuffix.
  ///
  /// In en, this message translates to:
  /// **'Wedding Floral Decorations.'**
  String get agreeSuffix;

  /// No description provided for @agreeTerms.
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to the'**
  String get agreeTerms;

  /// No description provided for @agreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to the'**
  String get agreeToTerms;

  /// No description provided for @agreementPrefix.
  ///
  /// In en, this message translates to:
  /// **'By checking Agree & Join or Continue, you agree to the '**
  String get agreementPrefix;

  /// No description provided for @agreementSuffix.
  ///
  /// In en, this message translates to:
  /// **'Wedding Floral Decorations.'**
  String get agreementSuffix;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get allCategories;

  /// No description provided for @allRatings.
  ///
  /// In en, this message translates to:
  /// **'All Ratings'**
  String get allRatings;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @andWord.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get andWord;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'WeddingApp helps you find the perfect Wedding Flower Decorations. Explore packages, search by image, and order easily.'**
  String get appDescription;

  /// No description provided for @appLock.
  ///
  /// In en, this message translates to:
  /// **'App Lock'**
  String get appLock;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Wedding Flower Decorations'**
  String get appName;

  /// No description provided for @appPolicy.
  ///
  /// In en, this message translates to:
  /// **'App Policy'**
  String get appPolicy;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Wedding Flower Decorations'**
  String get appTitle;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'1.0.0'**
  String get appVersion;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Ã˜Â§Ã™â€žÃ˜Â¹Ã˜Â±Ã˜Â¨Ã™Å Ã˜Â©'**
  String get arabic;

  /// No description provided for @attachment.
  ///
  /// In en, this message translates to:
  /// **'Attachment'**
  String get attachment;

  /// No description provided for @awaitingConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Awaiting Confirmation'**
  String get awaitingConfirmation;

  /// No description provided for @awaitingPayment.
  ///
  /// In en, this message translates to:
  /// **'Awaiting Payment'**
  String get awaitingPayment;

  /// No description provided for @openPaymentApp.
  ///
  /// In en, this message translates to:
  /// **'Open the app'**
  String get openPaymentApp;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @beFirstReview.
  ///
  /// In en, this message translates to:
  /// **'Be the first to give a review'**
  String get beFirstReview;

  /// No description provided for @biometricLock.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint / Face Unlock'**
  String get biometricLock;

  /// No description provided for @biometricNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication is not available on this device'**
  String get biometricNotAvailable;

  /// No description provided for @biometricNotEnrolled.
  ///
  /// In en, this message translates to:
  /// **'No fingerprint or face is registered yet. Add one in your device\'s Settings, then try again.'**
  String get biometricNotEnrolled;

  /// No description provided for @bookingDate.
  ///
  /// In en, this message translates to:
  /// **'Booking Date'**
  String get bookingDate;

  /// No description provided for @bookingTime.
  ///
  /// In en, this message translates to:
  /// **'Booking Time'**
  String get bookingTime;

  /// No description provided for @buddha.
  ///
  /// In en, this message translates to:
  /// **'Buddha'**
  String get buddha;

  /// No description provided for @budgetLabel.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budgetLabel;

  /// No description provided for @business.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get business;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @cancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get cancelOrder;

  /// No description provided for @cancelPayment.
  ///
  /// In en, this message translates to:
  /// **'Cancel Payment?'**
  String get cancelPayment;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @cardExpiry.
  ///
  /// In en, this message translates to:
  /// **'Expiry'**
  String get cardExpiry;

  /// No description provided for @cardHolderName.
  ///
  /// In en, this message translates to:
  /// **'Cardholder Name'**
  String get cardHolderName;

  /// No description provided for @cardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get cardNumber;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @vaDescription.
  ///
  /// In en, this message translates to:
  /// **'Pay easily via your own BRI Virtual Account (BRIVA) number. Payment is confirmed automatically.'**
  String get vaDescription;

  /// No description provided for @createVirtualAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Virtual Account'**
  String get createVirtualAccount;

  /// No description provided for @vaExpiredAt.
  ///
  /// In en, this message translates to:
  /// **'Valid until'**
  String get vaExpiredAt;

  /// No description provided for @virtualAccountNo.
  ///
  /// In en, this message translates to:
  /// **'Virtual Account No.'**
  String get virtualAccountNo;

  /// No description provided for @qrisDynamicDescription.
  ///
  /// In en, this message translates to:
  /// **'Generate one dynamic QR for this order. It can be scanned from any bank or e-wallet app. Money is credited to our BRI account automatically.'**
  String get qrisDynamicDescription;

  /// No description provided for @createQris.
  ///
  /// In en, this message translates to:
  /// **'Create QRIS'**
  String get createQris;

  /// No description provided for @creditCardNote.
  ///
  /// In en, this message translates to:
  /// **'Credit/Debit card payments are coming soon after BRI merchant activation. For now please use Virtual Account or QRIS above.'**
  String get creditCardNote;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied!'**
  String get copied;

  /// No description provided for @creditCard.
  ///
  /// In en, this message translates to:
  /// **'Credit/Debit Card'**
  String get creditCard;

  /// No description provided for @cvv.
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get cvv;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @cartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartEmpty;

  /// No description provided for @cartEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'No items in your cart yet'**
  String get cartEmptyDesc;

  /// No description provided for @catalog.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get catalog;

  /// No description provided for @catalogEmpty.
  ///
  /// In en, this message translates to:
  /// **'No catalog yet'**
  String get catalogEmpty;

  /// No description provided for @catalogEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'No packages or flowers available'**
  String get catalogEmptyDesc;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @catholic.
  ///
  /// In en, this message translates to:
  /// **'Catholic'**
  String get catholic;

  /// No description provided for @chatNotifications.
  ///
  /// In en, this message translates to:
  /// **'Chat Notifications'**
  String get chatNotifications;

  /// No description provided for @chatNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive new message notifications'**
  String get chatNotificationsDesc;

  /// No description provided for @chatWithAdmin.
  ///
  /// In en, this message translates to:
  /// **'Chat with Admin'**
  String get chatWithAdmin;

  /// No description provided for @chatWithAdminDesc.
  ///
  /// In en, this message translates to:
  /// **'Contact admin for consultation and questions'**
  String get chatWithAdminDesc;

  /// No description provided for @cheapest.
  ///
  /// In en, this message translates to:
  /// **'Cheapest'**
  String get cheapest;

  /// No description provided for @check.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get check;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @chinese.
  ///
  /// In en, this message translates to:
  /// **'Ã¤Â¸Â­Ã¦â€“â€¡'**
  String get chinese;

  /// No description provided for @chooseCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get chooseCategory;

  /// No description provided for @chooseFromDrive.
  ///
  /// In en, this message translates to:
  /// **'Choose file from Drive'**
  String get chooseFromDrive;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @chooseFromStorage.
  ///
  /// In en, this message translates to:
  /// **'Choose from storage'**
  String get chooseFromStorage;

  /// No description provided for @chooseOrder.
  ///
  /// In en, this message translates to:
  /// **'Choose Order'**
  String get chooseOrder;

  /// No description provided for @choosePackage.
  ///
  /// In en, this message translates to:
  /// **'Choose Package'**
  String get choosePackage;

  /// No description provided for @chooseCatalog.
  ///
  /// In en, this message translates to:
  /// **'Choose Catalog'**
  String get chooseCatalog;

  /// No description provided for @chooseSource.
  ///
  /// In en, this message translates to:
  /// **'Choose Source'**
  String get chooseSource;

  /// No description provided for @christian.
  ///
  /// In en, this message translates to:
  /// **'Christian'**
  String get christian;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City / Regency'**
  String get city;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @colorPreference.
  ///
  /// In en, this message translates to:
  /// **'Color Preference'**
  String get colorPreference;

  /// No description provided for @comma.
  ///
  /// In en, this message translates to:
  /// **','**
  String get comma;

  /// No description provided for @completeAllDataForVerification.
  ///
  /// In en, this message translates to:
  /// **'Complete all data for account verification'**
  String get completeAllDataForVerification;

  /// No description provided for @completeProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete Profile'**
  String get completeProfile;

  /// No description provided for @completeYourProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile'**
  String get completeYourProfile;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @confirmAndPay.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Pay'**
  String get confirmAndPay;

  /// No description provided for @confirmCancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this order?'**
  String get confirmCancelOrder;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get confirmDelete;

  /// No description provided for @confirmLeavePayment.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave the payment page?'**
  String get confirmLeavePayment;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Confirm password is required'**
  String get confirmPasswordRequired;

  /// No description provided for @confirmSelfie.
  ///
  /// In en, this message translates to:
  /// **'Confirm Selfie'**
  String get confirmSelfie;

  /// No description provided for @confirmDocument.
  ///
  /// In en, this message translates to:
  /// **'Confirm Document'**
  String get confirmDocument;

  /// No description provided for @confirmSignOut.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get confirmSignOut;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// No description provided for @confucian.
  ///
  /// In en, this message translates to:
  /// **'Confucian'**
  String get confucian;

  /// No description provided for @contactInfo.
  ///
  /// In en, this message translates to:
  /// **'Contact Info'**
  String get contactInfo;

  /// No description provided for @contactInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Make sure your contact data is correct'**
  String get contactInfoSubtitle;

  /// No description provided for @contactInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformation;

  /// No description provided for @contactOptions.
  ///
  /// In en, this message translates to:
  /// **'Contact Options'**
  String get contactOptions;

  /// No description provided for @content.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// No description provided for @continuePayment.
  ///
  /// In en, this message translates to:
  /// **'Continue Payment'**
  String get continuePayment;

  /// No description provided for @convenienceStore.
  ///
  /// In en, this message translates to:
  /// **'Convenience Store'**
  String get convenienceStore;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @countryOfResidence.
  ///
  /// In en, this message translates to:
  /// **'Country of Residence'**
  String get countryOfResidence;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @createNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Please create a new password for your account.'**
  String get createNewPassword;

  /// No description provided for @createOrder.
  ///
  /// In en, this message translates to:
  /// **'Create Order'**
  String get createOrder;

  /// No description provided for @createUniqueUsername.
  ///
  /// In en, this message translates to:
  /// **'Create your unique username'**
  String get createUniqueUsername;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @dataNotFilled.
  ///
  /// In en, this message translates to:
  /// **'%s data not filled yet'**
  String get dataNotFilled;

  /// No description provided for @dataSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data saved successfully!'**
  String get dataSavedSuccess;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @dateOfBirthLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirthLabel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Type your email to confirm'**
  String get deleteAccountConfirm;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In en, this message translates to:
  /// **'This action is permanent. Your account, profile, and all related data will be deleted. This cannot be undone.'**
  String get deleteAccountWarning;

  /// No description provided for @deleteChatConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this conversation?'**
  String get deleteChatConfirm;

  /// No description provided for @deleteNotification.
  ///
  /// In en, this message translates to:
  /// **'Delete Notification'**
  String get deleteNotification;

  /// No description provided for @deleteNotificationConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this notification?'**
  String get deleteNotificationConfirm;

  /// No description provided for @deletePrompt.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove %s?'**
  String get deletePrompt;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @discountLabel.
  ///
  /// In en, this message translates to:
  /// **'Discount: %s'**
  String get discountLabel;

  /// No description provided for @discountPrice.
  ///
  /// In en, this message translates to:
  /// **'Discount Price'**
  String get discountPrice;

  /// No description provided for @discountType.
  ///
  /// In en, this message translates to:
  /// **'Discount Type'**
  String get discountType;

  /// No description provided for @discountVoucher.
  ///
  /// In en, this message translates to:
  /// **'Discount Voucher'**
  String get discountVoucher;

  /// No description provided for @district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// No description provided for @divorced.
  ///
  /// In en, this message translates to:
  /// **'Divorced'**
  String get divorced;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @documentScanInstruction.
  ///
  /// In en, this message translates to:
  /// **'Position the document inside the frame'**
  String get documentScanInstruction;

  /// No description provided for @documentTooFar.
  ///
  /// In en, this message translates to:
  /// **'Move the document closer to the camera'**
  String get documentTooFar;

  /// No description provided for @documentValidationFailed.
  ///
  /// In en, this message translates to:
  /// **'No identity document detected in this photo. Please retake with the camera.'**
  String get documentValidationFailed;

  /// No description provided for @downloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get downloadPdf;

  /// No description provided for @dreamVenue.
  ///
  /// In en, this message translates to:
  /// **'Dream Venue'**
  String get dreamVenue;

  /// No description provided for @easyQuickOrder.
  ///
  /// In en, this message translates to:
  /// **'Easy & Quick Ordering'**
  String get easyQuickOrder;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @editNameUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Edit name (unlocked)'**
  String get editNameUnlocked;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @eWallet.
  ///
  /// In en, this message translates to:
  /// **'E-Wallet'**
  String get eWallet;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @emailOrUsername.
  ///
  /// In en, this message translates to:
  /// **'Email / Username'**
  String get emailOrUsername;

  /// No description provided for @emailChangeRequiresOtp.
  ///
  /// In en, this message translates to:
  /// **'If email is changed, you need OTP verification'**
  String get emailChangeRequiresOtp;

  /// No description provided for @emailForVerification.
  ///
  /// In en, this message translates to:
  /// **'Email will be used for account verification and important notifications'**
  String get emailForVerification;

  /// No description provided for @emailMismatch.
  ///
  /// In en, this message translates to:
  /// **'Emails do not match'**
  String get emailMismatch;

  /// No description provided for @emailNotFilled.
  ///
  /// In en, this message translates to:
  /// **'Email not filled in profile'**
  String get emailNotFilled;

  /// No description provided for @emailNotRegistered.
  ///
  /// In en, this message translates to:
  /// **'Email not registered'**
  String get emailNotRegistered;

  /// No description provided for @employee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get employee;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @enter6DigitOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit OTP code'**
  String get enter6DigitOtp;

  /// No description provided for @enterEmailForResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address to receive an OTP verification code.'**
  String get enterEmailForResetPassword;

  /// No description provided for @enterOtpCode.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP code'**
  String get enterOtpCode;

  /// No description provided for @enterOtpSentTo.
  ///
  /// In en, this message translates to:
  /// **'Enter the OTP code sent to'**
  String get enterOtpSentTo;

  /// No description provided for @verifyOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP Code'**
  String get verifyOtpTitle;

  /// No description provided for @verifyOtpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code we sent to your email.'**
  String get verifyOtpSubtitle;

  /// No description provided for @verifyOtpAction.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyOtpAction;

  /// No description provided for @verifyEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Email'**
  String get verifyEmailTitle;

  /// No description provided for @verifyEmailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter the 6-digit verification code we sent to your email address.'**
  String get verifyEmailSubtitle;

  /// No description provided for @enterVoucherCode.
  ///
  /// In en, this message translates to:
  /// **'Enter voucher code to get discount'**
  String get enterVoucherCode;

  /// No description provided for @entrepreneur.
  ///
  /// In en, this message translates to:
  /// **'Entrepreneur'**
  String get entrepreneur;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @eventConcept.
  ///
  /// In en, this message translates to:
  /// **'Event Concept'**
  String get eventConcept;

  /// No description provided for @eventDate.
  ///
  /// In en, this message translates to:
  /// **'Event Date'**
  String get eventDate;

  /// No description provided for @eventDay.
  ///
  /// In en, this message translates to:
  /// **'Event Day'**
  String get eventDay;

  /// No description provided for @eventDetail.
  ///
  /// In en, this message translates to:
  /// **'Event Detail'**
  String get eventDetail;

  /// No description provided for @eventTime.
  ///
  /// In en, this message translates to:
  /// **'Event Time'**
  String get eventTime;

  /// No description provided for @existingPhotoHint.
  ///
  /// In en, this message translates to:
  /// **'A saved photo already exists. Choose a new photo if you want to replace it.'**
  String get existingPhotoHint;

  /// No description provided for @expiresAt.
  ///
  /// In en, this message translates to:
  /// **'Expires At'**
  String get expiresAt;

  /// No description provided for @exploreCatalog.
  ///
  /// In en, this message translates to:
  /// **'Explore Catalog'**
  String get exploreCatalog;

  /// No description provided for @faceDetectedLabel.
  ///
  /// In en, this message translates to:
  /// **'Face detected'**
  String get faceDetectedLabel;

  /// No description provided for @faceMatchPercent.
  ///
  /// In en, this message translates to:
  /// **'Face match: %s%'**
  String get faceMatchPercent;

  /// No description provided for @faceMismatch.
  ///
  /// In en, this message translates to:
  /// **'Face does not match'**
  String get faceMismatch;

  /// No description provided for @faceMismatchMessage.
  ///
  /// In en, this message translates to:
  /// **'The scanned face does not match the identity document. Please retry in a well-lit area.'**
  String get faceMismatchMessage;

  /// No description provided for @faceOpenEyesLabel.
  ///
  /// In en, this message translates to:
  /// **'Open your eyes to complete verification'**
  String get faceOpenEyesLabel;

  /// No description provided for @faceMultipleFacesLabel.
  ///
  /// In en, this message translates to:
  /// **'Only one face in the frame'**
  String get faceMultipleFacesLabel;

  /// No description provided for @faceScanInstruction.
  ///
  /// In en, this message translates to:
  /// **'Position your face in the frame'**
  String get faceScanInstruction;

  /// No description provided for @faceScanSuccess.
  ///
  /// In en, this message translates to:
  /// **'Face verified successfully'**
  String get faceScanSuccess;

  /// No description provided for @faceTooClose.
  ///
  /// In en, this message translates to:
  /// **'Move your face closer to the camera'**
  String get faceTooClose;

  /// No description provided for @faceVerification.
  ///
  /// In en, this message translates to:
  /// **'Face Verification'**
  String get faceVerification;

  /// No description provided for @faceVerified.
  ///
  /// In en, this message translates to:
  /// **'Face verified'**
  String get faceVerified;

  /// No description provided for @faceLookStraight.
  ///
  /// In en, this message translates to:
  /// **'Look straight at the camera'**
  String get faceLookStraight;

  /// No description provided for @faceLookUp.
  ///
  /// In en, this message translates to:
  /// **'Raise your head, look up'**
  String get faceLookUp;

  /// No description provided for @faceLookDown.
  ///
  /// In en, this message translates to:
  /// **'Lower your head, look down'**
  String get faceLookDown;

  /// No description provided for @faceTurnLeft.
  ///
  /// In en, this message translates to:
  /// **'Turn your head to the left'**
  String get faceTurnLeft;

  /// No description provided for @faceTurnRight.
  ///
  /// In en, this message translates to:
  /// **'Turn your head to the right'**
  String get faceTurnRight;

  /// No description provided for @faceRotateHead.
  ///
  /// In en, this message translates to:
  /// **'Rotate your head slightly'**
  String get faceRotateHead;

  /// No description provided for @faceVerifiedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your face has been verified successfully'**
  String get faceVerifiedMessage;

  /// No description provided for @livenessStep.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String livenessStep(int step, int total);

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @failedCancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel order'**
  String get failedCancelOrder;

  /// No description provided for @failedFetchFromDrive.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch from Drive: %s'**
  String get failedFetchFromDrive;

  /// No description provided for @failedLoadCatalog.
  ///
  /// In en, this message translates to:
  /// **'Failed to load catalog'**
  String get failedLoadCatalog;

  /// No description provided for @failedLoadItem.
  ///
  /// In en, this message translates to:
  /// **'Failed to load item data'**
  String get failedLoadItem;

  /// No description provided for @failedLoadOrders.
  ///
  /// In en, this message translates to:
  /// **'Failed to load orders'**
  String get failedLoadOrders;

  /// No description provided for @failedLoadPage.
  ///
  /// In en, this message translates to:
  /// **'Failed to load page'**
  String get failedLoadPage;

  /// No description provided for @failedRemoveItem.
  ///
  /// In en, this message translates to:
  /// **'Failed to remove item'**
  String get failedRemoveItem;

  /// No description provided for @failedSaveData.
  ///
  /// In en, this message translates to:
  /// **'Failed to save data. Try again.'**
  String get failedSaveData;

  /// No description provided for @failedSendMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to send message'**
  String get failedSendMessage;

  /// No description provided for @failedSendResetCode.
  ///
  /// In en, this message translates to:
  /// **'Failed to send reset code. Try again.'**
  String get failedSendResetCode;

  /// No description provided for @failedSendVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Failed to send verification code'**
  String get failedSendVerificationCode;

  /// No description provided for @failedStartConversation.
  ///
  /// In en, this message translates to:
  /// **'Failed to start conversation'**
  String get failedStartConversation;

  /// No description provided for @failedUpdateQuantity.
  ///
  /// In en, this message translates to:
  /// **'Failed to update quantity'**
  String get failedUpdateQuantity;

  /// No description provided for @failedUseVoucher.
  ///
  /// In en, this message translates to:
  /// **'Failed to use voucher'**
  String get failedUseVoucher;

  /// No description provided for @failedVerifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Failed to verify OTP'**
  String get failedVerifyOtp;

  /// No description provided for @failedWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed: %s'**
  String get failedWithMessage;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @favoritesEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your favorites are empty'**
  String get favoritesEmpty;

  /// No description provided for @features.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get features;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @fieldAddress.
  ///
  /// In en, this message translates to:
  /// **'Fill Full Address'**
  String get fieldAddress;

  /// No description provided for @fieldAvatar.
  ///
  /// In en, this message translates to:
  /// **'Upload Profile Photo'**
  String get fieldAvatar;

  /// No description provided for @fieldBirth.
  ///
  /// In en, this message translates to:
  /// **'Fill Birth Data'**
  String get fieldBirth;

  /// No description provided for @fieldCompleteData.
  ///
  /// In en, this message translates to:
  /// **'Complete Data'**
  String get fieldCompleteData;

  /// No description provided for @fieldCountry.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get fieldCountry;

  /// No description provided for @fieldEmail.
  ///
  /// In en, this message translates to:
  /// **'Fill Email'**
  String get fieldEmail;

  /// No description provided for @fieldFullName.
  ///
  /// In en, this message translates to:
  /// **'Fill Full Name'**
  String get fieldFullName;

  /// No description provided for @fieldGender.
  ///
  /// In en, this message translates to:
  /// **'Select Gender'**
  String get fieldGender;

  /// No description provided for @fieldIncomeRange.
  ///
  /// In en, this message translates to:
  /// **'Select Income Range'**
  String get fieldIncomeRange;

  /// No description provided for @fieldKtpPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload Identity Photo'**
  String get fieldKtpPhoto;

  /// No description provided for @fieldMaritalStatus.
  ///
  /// In en, this message translates to:
  /// **'Select Marital Status'**
  String get fieldMaritalStatus;

  /// No description provided for @fieldMotherName.
  ///
  /// In en, this message translates to:
  /// **'Fill Mother\'s Name'**
  String get fieldMotherName;

  /// No description provided for @fieldKtpNumber.
  ///
  /// In en, this message translates to:
  /// **'Fill Identity Number'**
  String get fieldKtpNumber;

  /// No description provided for @fieldOccupation.
  ///
  /// In en, this message translates to:
  /// **'Select Occupation'**
  String get fieldOccupation;

  /// No description provided for @fieldPostalCode.
  ///
  /// In en, this message translates to:
  /// **'Fill Postal Code'**
  String get fieldPostalCode;

  /// No description provided for @fieldRegion.
  ///
  /// In en, this message translates to:
  /// **'Select Region'**
  String get fieldRegion;

  /// No description provided for @fieldReligion.
  ///
  /// In en, this message translates to:
  /// **'Select Religion'**
  String get fieldReligion;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'is required'**
  String get fieldRequired;

  /// No description provided for @fieldSelfie.
  ///
  /// In en, this message translates to:
  /// **'Upload Selfie Photo'**
  String get fieldSelfie;

  /// No description provided for @fieldSourceOfFunds.
  ///
  /// In en, this message translates to:
  /// **'Select Source of Funds'**
  String get fieldSourceOfFunds;

  /// No description provided for @fieldUsername.
  ///
  /// In en, this message translates to:
  /// **'Create Username'**
  String get fieldUsername;

  /// No description provided for @fieldWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Add WhatsApp Number'**
  String get fieldWhatsapp;

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get file;

  /// No description provided for @fileManager.
  ///
  /// In en, this message translates to:
  /// **'File Manager'**
  String get fileManager;

  /// No description provided for @fillDataCorrectly.
  ///
  /// In en, this message translates to:
  /// **'Fill in your data correctly'**
  String get fillDataCorrectly;

  /// No description provided for @fillDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Fill in your date of birth'**
  String get fillDateOfBirth;

  /// No description provided for @fillFirstName.
  ///
  /// In en, this message translates to:
  /// **'Fill in your first, middle & last name'**
  String get fillFirstName;

  /// No description provided for @fillFullAddress.
  ///
  /// In en, this message translates to:
  /// **'Fill in your complete address'**
  String get fillFullAddress;

  /// No description provided for @fillLabel.
  ///
  /// In en, this message translates to:
  /// **'Fill'**
  String get fillLabel;

  /// No description provided for @fillMotherName.
  ///
  /// In en, this message translates to:
  /// **'Fill in your mother\'s maiden name'**
  String get fillMotherName;

  /// No description provided for @fillPlaceOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Fill in your place of birth'**
  String get fillPlaceOfBirth;

  /// No description provided for @fillPostalCode.
  ///
  /// In en, this message translates to:
  /// **'Fill in your postal code'**
  String get fillPostalCode;

  /// No description provided for @filterByRating.
  ///
  /// In en, this message translates to:
  /// **'Filter by Rating'**
  String get filterByRating;

  /// No description provided for @findBeautifulFlowers.
  ///
  /// In en, this message translates to:
  /// **'Find the most beautiful wedding flower arrangements for your special day'**
  String get findBeautifulFlowers;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @flowerCatalog.
  ///
  /// In en, this message translates to:
  /// **'Flower Catalog'**
  String get flowerCatalog;

  /// No description provided for @flowerPackageCatalog.
  ///
  /// In en, this message translates to:
  /// **'Flower Package Catalog'**
  String get flowerPackageCatalog;

  /// No description provided for @flowerPackages.
  ///
  /// In en, this message translates to:
  /// **'Flower Packages'**
  String get flowerPackages;

  /// No description provided for @flowers.
  ///
  /// In en, this message translates to:
  /// **'Flowers'**
  String get flowers;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Your Password?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordQuestion.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotPasswordQuestion;

  /// No description provided for @forgotPin.
  ///
  /// In en, this message translates to:
  /// **'Forgot PIN?'**
  String get forgotPin;

  /// No description provided for @forgotPinConfirm.
  ///
  /// In en, this message translates to:
  /// **'An OTP will be sent to your registered email to verify your identity before resetting the app lock. Continue?'**
  String get forgotPinConfirm;

  /// No description provided for @emailNotFound.
  ///
  /// In en, this message translates to:
  /// **'No registered email found on this device.'**
  String get emailNotFound;

  /// No description provided for @fullAddress.
  ///
  /// In en, this message translates to:
  /// **'Full Address'**
  String get fullAddress;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @fullNameValue.
  ///
  /// In en, this message translates to:
  /// **'Full Name: {name}'**
  String fullNameValue(String name);

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started Now'**
  String get getStarted;

  /// No description provided for @signInToAccount.
  ///
  /// In en, this message translates to:
  /// **'Sign In To Account'**
  String get signInToAccount;

  /// No description provided for @gift.
  ///
  /// In en, this message translates to:
  /// **'Gift/Inheritance'**
  String get gift;

  /// No description provided for @googleDrive.
  ///
  /// In en, this message translates to:
  /// **'Google Drive'**
  String get googleDrive;

  /// No description provided for @gopay.
  ///
  /// In en, this message translates to:
  /// **'GoPay'**
  String get gopay;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @highestPrice.
  ///
  /// In en, this message translates to:
  /// **'Highest Price'**
  String get highestPrice;

  /// No description provided for @highestRating.
  ///
  /// In en, this message translates to:
  /// **'Highest Rating'**
  String get highestRating;

  /// No description provided for @hindu.
  ///
  /// In en, this message translates to:
  /// **'Hindu'**
  String get hindu;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'Search history empty'**
  String get historyEmpty;

  /// No description provided for @holdSteady.
  ///
  /// In en, this message translates to:
  /// **'Hold your camera steady'**
  String get holdSteady;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @needMoreLight.
  ///
  /// In en, this message translates to:
  /// **'Move to a brighter area or turn on the light'**
  String get needMoreLight;

  /// No description provided for @housewife.
  ///
  /// In en, this message translates to:
  /// **'Housewife'**
  String get housewife;

  /// No description provided for @hubungiKami.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get hubungiKami;

  /// No description provided for @iUnderstandAndAgree.
  ///
  /// In en, this message translates to:
  /// **'I Understand & Agree'**
  String get iUnderstandAndAgree;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @idCardKtp.
  ///
  /// In en, this message translates to:
  /// **'ID Card (KTP)'**
  String get idCardKtp;

  /// No description provided for @idCardNpwp.
  ///
  /// In en, this message translates to:
  /// **'NPWP'**
  String get idCardNpwp;

  /// No description provided for @idCardSim.
  ///
  /// In en, this message translates to:
  /// **'Driver\'s License (SIM)'**
  String get idCardSim;

  /// No description provided for @idNumber.
  ///
  /// In en, this message translates to:
  /// **'ID Number (KTP / Passport / SIM / NPWP)'**
  String get idNumber;

  /// No description provided for @idNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'ID number is required'**
  String get idNumberRequired;

  /// No description provided for @idPhoto.
  ///
  /// In en, this message translates to:
  /// **'ID Card Photo'**
  String get idPhoto;

  /// No description provided for @idPhotoUploaded.
  ///
  /// In en, this message translates to:
  /// **'ID photo uploaded'**
  String get idPhotoUploaded;

  /// No description provided for @idSelfiePhoto.
  ///
  /// In en, this message translates to:
  /// **'Selfie with ID Card'**
  String get idSelfiePhoto;

  /// No description provided for @idType.
  ///
  /// In en, this message translates to:
  /// **'ID Type'**
  String get idType;

  /// No description provided for @identity.
  ///
  /// In en, this message translates to:
  /// **'Identity'**
  String get identity;

  /// No description provided for @identityAndAddress.
  ///
  /// In en, this message translates to:
  /// **'Identity & Address'**
  String get identityAndAddress;

  /// No description provided for @identityDocuments.
  ///
  /// In en, this message translates to:
  /// **'Identity Documents'**
  String get identityDocuments;

  /// No description provided for @identityNumber.
  ///
  /// In en, this message translates to:
  /// **'Identity Number'**
  String get identityNumber;

  /// No description provided for @identityNumberKtp.
  ///
  /// In en, this message translates to:
  /// **'KTP Identity Number'**
  String get identityNumberKtp;

  /// No description provided for @identityNumberPassport.
  ///
  /// In en, this message translates to:
  /// **'Passport Identity Number'**
  String get identityNumberPassport;

  /// No description provided for @identityNumberSim.
  ///
  /// In en, this message translates to:
  /// **'Driver\'s License (SIM) Identity Number'**
  String get identityNumberSim;

  /// No description provided for @identityNumberNpwp.
  ///
  /// In en, this message translates to:
  /// **'NPWP Identity Number'**
  String get identityNumberNpwp;

  /// No description provided for @identityNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'{label} is required'**
  String identityNumberRequired(String label);

  /// No description provided for @identityPhoto.
  ///
  /// In en, this message translates to:
  /// **'Identity Photo'**
  String get identityPhoto;

  /// No description provided for @identityShort.
  ///
  /// In en, this message translates to:
  /// **'Identity'**
  String get identityShort;

  /// No description provided for @identityType.
  ///
  /// In en, this message translates to:
  /// **'Identity Type'**
  String get identityType;

  /// No description provided for @identityVerification.
  ///
  /// In en, this message translates to:
  /// **'Identity Verification'**
  String get identityVerification;

  /// No description provided for @imageLabel.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get imageLabel;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @incomeRange.
  ///
  /// In en, this message translates to:
  /// **'Income Range'**
  String get incomeRange;

  /// No description provided for @incomeRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'Income Range'**
  String get incomeRangeLabel;

  /// No description provided for @incompleteData.
  ///
  /// In en, this message translates to:
  /// **'%s data not filled yet'**
  String get incompleteData;

  /// No description provided for @indonesian.
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get indonesian;

  /// No description provided for @invalidNpwpNumber.
  ///
  /// In en, this message translates to:
  /// **'NPWP must be 15 digits'**
  String get invalidNpwpNumber;

  /// No description provided for @invalidOtp.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP'**
  String get invalidOtp;

  /// No description provided for @invalidPassportFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid passport format (6-9 letters/numbers)'**
  String get invalidPassportFormat;

  /// No description provided for @invalidSimNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid SIM number (6-12 digits)'**
  String get invalidSimNumber;

  /// No description provided for @invalidVoucher.
  ///
  /// In en, this message translates to:
  /// **'Invalid voucher'**
  String get invalidVoucher;

  /// No description provided for @investment.
  ///
  /// In en, this message translates to:
  /// **'Investment'**
  String get investment;

  /// No description provided for @invoice.
  ///
  /// In en, this message translates to:
  /// **'Invoices'**
  String get invoice;

  /// No description provided for @isActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get isActive;

  /// No description provided for @isFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get isFeatured;

  /// No description provided for @isGlobal.
  ///
  /// In en, this message translates to:
  /// **'Global'**
  String get isGlobal;

  /// No description provided for @islam.
  ///
  /// In en, this message translates to:
  /// **'Islam'**
  String get islam;

  /// No description provided for @itemCount.
  ///
  /// In en, this message translates to:
  /// **'1 item'**
  String get itemCount;

  /// No description provided for @itemRemoved.
  ///
  /// In en, this message translates to:
  /// **'Item removed'**
  String get itemRemoved;

  /// No description provided for @japanese.
  ///
  /// In en, this message translates to:
  /// **'Ã¦—Â¥Ã¦Å“Â¬Ã¨ÂªÅ¾'**
  String get japanese;

  /// No description provided for @korean.
  ///
  /// In en, this message translates to:
  /// **'Ã­â€¢Å“ÃªÂµÂ­Ã¬â€“Â´'**
  String get korean;

  /// No description provided for @ktp.
  ///
  /// In en, this message translates to:
  /// **'ID Card (KTP)'**
  String get ktp;

  /// No description provided for @ktpPhoto.
  ///
  /// In en, this message translates to:
  /// **'KTP Photo'**
  String get ktpPhoto;

  /// No description provided for @labelSelected.
  ///
  /// In en, this message translates to:
  /// **'{label} selected successfully'**
  String labelSelected(String label);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated'**
  String get lastUpdated;

  /// No description provided for @lastUpdatedFormat.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {date}'**
  String lastUpdatedFormat(String date);

  /// No description provided for @lessThan1M.
  ///
  /// In en, this message translates to:
  /// **'< Rp 1 Million'**
  String get lessThan1M;

  /// No description provided for @loadCustomers.
  ///
  /// In en, this message translates to:
  /// **'Load customer list to start chat'**
  String get loadCustomers;

  /// No description provided for @loadCustomersAction.
  ///
  /// In en, this message translates to:
  /// **'Load Customers'**
  String get loadCustomersAction;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccess;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @lowestPrice.
  ///
  /// In en, this message translates to:
  /// **'Lowest Price'**
  String get lowestPrice;

  /// No description provided for @lowestRating.
  ///
  /// In en, this message translates to:
  /// **'Lowest Rating'**
  String get lowestRating;

  /// No description provided for @mission.
  ///
  /// In en, this message translates to:
  /// **'Mission'**
  String get mission;

  /// No description provided for @malay.
  ///
  /// In en, this message translates to:
  /// **'Malay language'**
  String get malay;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @mandiriBill.
  ///
  /// In en, this message translates to:
  /// **'Independent Bill'**
  String get mandiriBill;

  /// No description provided for @manualCapture.
  ///
  /// In en, this message translates to:
  /// **'Capture Manually'**
  String get manualCapture;

  /// No description provided for @maritalStatus.
  ///
  /// In en, this message translates to:
  /// **'Marital Status'**
  String get maritalStatus;

  /// No description provided for @maritalStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Marital Status'**
  String get maritalStatusLabel;

  /// No description provided for @markAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark as Read'**
  String get markAsRead;

  /// No description provided for @married.
  ///
  /// In en, this message translates to:
  /// **'Married'**
  String get married;

  /// No description provided for @maxCapacity.
  ///
  /// In en, this message translates to:
  /// **'Max Capacity'**
  String get maxCapacity;

  /// No description provided for @maxUses.
  ///
  /// In en, this message translates to:
  /// **'Max Uses'**
  String get maxUses;

  /// No description provided for @me.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get me;

  /// No description provided for @method.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get method;

  /// No description provided for @midNameOptional.
  ///
  /// In en, this message translates to:
  /// **'Middle Name (Optional)'**
  String get midNameOptional;

  /// No description provided for @middleName.
  ///
  /// In en, this message translates to:
  /// **'Middle Name'**
  String get middleName;

  /// No description provided for @minCapacity.
  ///
  /// In en, this message translates to:
  /// **'Min Capacity'**
  String get minCapacity;

  /// No description provided for @minPurchase.
  ///
  /// In en, this message translates to:
  /// **'Min. Purchase'**
  String get minPurchase;

  /// No description provided for @moreThan50M.
  ///
  /// In en, this message translates to:
  /// **'> Rp 50 Million'**
  String get moreThan50M;

  /// No description provided for @mostExpensive.
  ///
  /// In en, this message translates to:
  /// **'Most Expensive'**
  String get mostExpensive;

  /// No description provided for @motherName.
  ///
  /// In en, this message translates to:
  /// **'Mother\'s Maiden Name'**
  String get motherName;

  /// No description provided for @motherNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Mother\'s Full Name'**
  String get motherNameLabel;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrders;

  /// No description provided for @myCatalogRatingComments.
  ///
  /// In en, this message translates to:
  /// **'My Catalog Ratings & Comments'**
  String get myCatalogRatingComments;

  /// No description provided for @myVouchers.
  ///
  /// In en, this message translates to:
  /// **'My Vouchers'**
  String get myVouchers;

  /// No description provided for @nameNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Name does not match'**
  String get nameNotMatch;

  /// No description provided for @nameVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Name verification failed from'**
  String get nameVerificationFailed;

  /// No description provided for @navCart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get navCart;

  /// No description provided for @navCatalog.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get navCatalog;

  /// No description provided for @navChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get navChat;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get navOrders;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @newPasswordLeaveBlank.
  ///
  /// In en, this message translates to:
  /// **'New Password (leave blank if not changing)'**
  String get newPasswordLeaveBlank;

  /// No description provided for @newest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get newest;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @ktpNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'KTP Number'**
  String get ktpNumberLabel;

  /// No description provided for @idNumberMin6Chars.
  ///
  /// In en, this message translates to:
  /// **'ID Number minimum 6 characters'**
  String get idNumberMin6Chars;

  /// No description provided for @ktpNumberMustBe16Digits.
  ///
  /// In en, this message translates to:
  /// **'KTP must be 16 digits'**
  String get ktpNumberMustBe16Digits;

  /// No description provided for @ktpNumberShort.
  ///
  /// In en, this message translates to:
  /// **'KTP'**
  String get ktpNumberShort;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @noConversations.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get noConversations;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @noFavorites.
  ///
  /// In en, this message translates to:
  /// **'No favorite items yet'**
  String get noFavorites;

  /// No description provided for @noFlowersAvailable.
  ///
  /// In en, this message translates to:
  /// **'No flowers available'**
  String get noFlowersAvailable;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No search history yet'**
  String get noHistory;

  /// No description provided for @noImagesInGoogleDrive.
  ///
  /// In en, this message translates to:
  /// **'No images in Google Drive'**
  String get noImagesInGoogleDrive;

  /// No description provided for @noMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages'**
  String get noMessages;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @noOrders.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get noOrders;

  /// No description provided for @noOrdersDesc.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t placed any orders yet'**
  String get noOrdersDesc;

  /// No description provided for @noPackagesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No packages available'**
  String get noPackagesAvailable;

  /// No description provided for @noCatalogFound.
  ///
  /// In en, this message translates to:
  /// **'No catalog found'**
  String get noCatalogFound;

  /// No description provided for @noCatalogsFound.
  ///
  /// In en, this message translates to:
  /// **'No catalogs found'**
  String get noCatalogsFound;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @noReviews.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get noReviews;

  /// No description provided for @noReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t written any reviews yet'**
  String get noReviewsYet;

  /// No description provided for @noVouchers.
  ///
  /// In en, this message translates to:
  /// **'No vouchers yet'**
  String get noVouchers;

  /// No description provided for @notVerified.
  ///
  /// In en, this message translates to:
  /// **'Identity Not Verified'**
  String get notVerified;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @notificationDeleted.
  ///
  /// In en, this message translates to:
  /// **'Notification deleted'**
  String get notificationDeleted;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @npwp.
  ///
  /// In en, this message translates to:
  /// **'NPWP'**
  String get npwp;

  /// No description provided for @npwpLabel.
  ///
  /// In en, this message translates to:
  /// **'NPWP'**
  String get npwpLabel;

  /// No description provided for @npwpMin15Chars.
  ///
  /// In en, this message translates to:
  /// **'NPWP minimum 15 digits'**
  String get npwpMin15Chars;

  /// No description provided for @npwpNumber.
  ///
  /// In en, this message translates to:
  /// **'NPWP'**
  String get npwpNumber;

  /// No description provided for @npwpPhoto.
  ///
  /// In en, this message translates to:
  /// **'NPWP Photo'**
  String get npwpPhoto;

  /// No description provided for @npwpShort.
  ///
  /// In en, this message translates to:
  /// **'NPWP'**
  String get npwpShort;

  /// No description provided for @occupation.
  ///
  /// In en, this message translates to:
  /// **'Occupation'**
  String get occupation;

  /// No description provided for @occupationLabel.
  ///
  /// In en, this message translates to:
  /// **'Occupation'**
  String get occupationLabel;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'(optional)'**
  String get optional;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get or;

  /// No description provided for @orSignInWith.
  ///
  /// In en, this message translates to:
  /// **'or sign in with'**
  String get orSignInWith;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @orderCancelled.
  ///
  /// In en, this message translates to:
  /// **'Order cancelled'**
  String get orderCancelled;

  /// No description provided for @orderCreated.
  ///
  /// In en, this message translates to:
  /// **'Order created successfully'**
  String get orderCreated;

  /// No description provided for @orderCreatedDesc.
  ///
  /// In en, this message translates to:
  /// **'Your order has been created. Please complete the payment.'**
  String get orderCreatedDesc;

  /// No description provided for @redirectingToPayment.
  ///
  /// In en, this message translates to:
  /// **'Redirecting to payment...'**
  String get redirectingToPayment;

  /// No description provided for @orderDetail.
  ///
  /// In en, this message translates to:
  /// **'Order Detail'**
  String get orderDetail;

  /// No description provided for @orderFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to create order'**
  String get orderFailed;

  /// No description provided for @orderFavoritePackages.
  ///
  /// In en, this message translates to:
  /// **'Order your favorite flower packages in minutes'**
  String get orderFavoritePackages;

  /// No description provided for @orderHistory.
  ///
  /// In en, this message translates to:
  /// **'Order History'**
  String get orderHistory;

  /// No description provided for @orderItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get orderItems;

  /// No description provided for @orderNotifications.
  ///
  /// In en, this message translates to:
  /// **'Order Notifications'**
  String get orderNotifications;

  /// No description provided for @orderNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive order status notifications'**
  String get orderNotificationsDesc;

  /// No description provided for @orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order Number'**
  String get orderNumber;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @otpSentToEmail.
  ///
  /// In en, this message translates to:
  /// **'OTP has been sent to your email'**
  String get otpSentToEmail;

  /// No description provided for @paidInFull.
  ///
  /// In en, this message translates to:
  /// **'Paid In Full'**
  String get paidInFull;

  /// No description provided for @partiallyPaid.
  ///
  /// In en, this message translates to:
  /// **'Partially Paid'**
  String get partiallyPaid;

  /// No description provided for @passport.
  ///
  /// In en, this message translates to:
  /// **'Passport'**
  String get passport;

  /// No description provided for @passportLabel.
  ///
  /// In en, this message translates to:
  /// **'Passport Number'**
  String get passportLabel;

  /// No description provided for @passportMin6Chars.
  ///
  /// In en, this message translates to:
  /// **'Passport number min 6 characters'**
  String get passportMin6Chars;

  /// No description provided for @passportPhoto.
  ///
  /// In en, this message translates to:
  /// **'Passport Photo'**
  String get passportPhoto;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordAndConfirmMismatch.
  ///
  /// In en, this message translates to:
  /// **'Password and confirmation do not match'**
  String get passwordAndConfirmMismatch;

  /// No description provided for @passwordMin8Chars.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMin8Chars;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @passwordResetFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to reset password'**
  String get passwordResetFailed;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully'**
  String get passwordResetSuccess;

  /// No description provided for @passwordStrengthMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get passwordStrengthMedium;

  /// No description provided for @passwordStrengthStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get passwordStrengthStrong;

  /// No description provided for @passwordStrengthWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get passwordStrengthWeak;

  /// No description provided for @pasteOtp.
  ///
  /// In en, this message translates to:
  /// **'Paste OTP'**
  String get pasteOtp;

  /// No description provided for @pay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get pay;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get payNow;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @paymentConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Payment Confirmation'**
  String get paymentConfirmation;

  /// No description provided for @paymentCancelled.
  ///
  /// In en, this message translates to:
  /// **'Payment Cancelled'**
  String get paymentCancelled;

  /// No description provided for @paymentCancelledDesc.
  ///
  /// In en, this message translates to:
  /// **'You cancelled the payment. You can make the payment at any time.'**
  String get paymentCancelledDesc;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment Failed'**
  String get paymentFailed;

  /// No description provided for @paymentFailedDesc.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while processing payment. Please try again.'**
  String get paymentFailedDesc;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @paymentPending.
  ///
  /// In en, this message translates to:
  /// **'Payment Not Completed'**
  String get paymentPending;

  /// No description provided for @paymentPendingDesc.
  ///
  /// In en, this message translates to:
  /// **'Your payment is still awaiting confirmation. Please contact admin if you need assistance.'**
  String get paymentPendingDesc;

  /// No description provided for @paymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get paymentStatus;

  /// No description provided for @paymentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful'**
  String get paymentSuccess;

  /// No description provided for @paymentSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Payment confirmed. Please upload your payment proof.'**
  String get paymentSubmitted;

  /// No description provided for @paymentSuccessDesc.
  ///
  /// In en, this message translates to:
  /// **'Thank you! Your payment has been received. Your order is being processed.'**
  String get paymentSuccessDesc;

  /// No description provided for @paymentTime.
  ///
  /// In en, this message translates to:
  /// **'Payment Time'**
  String get paymentTime;

  /// No description provided for @paymentDeadline.
  ///
  /// In en, this message translates to:
  /// **'Payment Deadline'**
  String get paymentDeadline;

  /// No description provided for @paymentInstructions.
  ///
  /// In en, this message translates to:
  /// **'Payment Instructions'**
  String get paymentInstructions;

  /// No description provided for @confirmPayment.
  ///
  /// In en, this message translates to:
  /// **'Confirm Payment'**
  String get confirmPayment;

  /// No description provided for @paymentConfirmSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment has been confirmed'**
  String get paymentConfirmSuccess;

  /// No description provided for @iHaveTransferred.
  ///
  /// In en, this message translates to:
  /// **'I\'ve Transferred'**
  String get iHaveTransferred;

  /// No description provided for @confirmAfterTransferHint.
  ///
  /// In en, this message translates to:
  /// **'Complete the transfer first according to the instructions above, then tap \"I\'ve Transferred\" so our admin can verify your payment.'**
  String get confirmAfterTransferHint;

  /// No description provided for @uploadProof.
  ///
  /// In en, this message translates to:
  /// **'Upload Payment Proof'**
  String get uploadProof;

  /// No description provided for @sendProof.
  ///
  /// In en, this message translates to:
  /// **'Send Payment Proof'**
  String get sendProof;

  /// No description provided for @proofSent.
  ///
  /// In en, this message translates to:
  /// **'Payment proof sent successfully. Waiting for admin verification.'**
  String get proofSent;

  /// No description provided for @paymentProof.
  ///
  /// In en, this message translates to:
  /// **'Payment Proof'**
  String get paymentProof;

  /// No description provided for @waitingVerification.
  ///
  /// In en, this message translates to:
  /// **'Waiting for Verification'**
  String get waitingVerification;

  /// No description provided for @waitingVerificationDesc.
  ///
  /// In en, this message translates to:
  /// **'Payment proof is being verified by admin. This process usually takes 1x24 hours.'**
  String get waitingVerificationDesc;

  /// No description provided for @uploadProofDesc.
  ///
  /// In en, this message translates to:
  /// **'Transfer the exact amount and upload the payment proof for verification.'**
  String get uploadProofDesc;

  /// No description provided for @tapToUpload.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload payment proof photo'**
  String get tapToUpload;

  /// No description provided for @selectPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Select Payment Method'**
  String get selectPaymentMethod;

  /// No description provided for @payWithCreditCard.
  ///
  /// In en, this message translates to:
  /// **'Pay with credit/debit card'**
  String get payWithCreditCard;

  /// No description provided for @payWithEWallet.
  ///
  /// In en, this message translates to:
  /// **'Pay with {name}'**
  String payWithEWallet(Object name);

  /// No description provided for @payWithQris.
  ///
  /// In en, this message translates to:
  /// **'Scan and pay with your e-wallet app'**
  String get payWithQris;

  /// No description provided for @payWithin24h.
  ///
  /// In en, this message translates to:
  /// **'Pay within 24 hours'**
  String get payWithin24h;

  /// No description provided for @otherPaymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Other Methods'**
  String get otherPaymentMethods;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @photoAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Photo already exists (tap to change)'**
  String get photoAlreadyExists;

  /// No description provided for @photoGallery.
  ///
  /// In en, this message translates to:
  /// **'Photo Gallery'**
  String get photoGallery;

  /// No description provided for @photoSelected.
  ///
  /// In en, this message translates to:
  /// **'Photo selected. Click Save to upload.'**
  String get photoSelected;

  /// No description provided for @pickFromGoogleDrive.
  ///
  /// In en, this message translates to:
  /// **'Pick from Google Drive'**
  String get pickFromGoogleDrive;

  /// No description provided for @placeOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Place of Birth'**
  String get placeOfBirth;

  /// No description provided for @placeOfBirthLabel.
  ///
  /// In en, this message translates to:
  /// **'Place of Birth'**
  String get placeOfBirthLabel;

  /// No description provided for @placeAndDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Place and Date of Birth'**
  String get placeAndDateOfBirth;

  /// No description provided for @popularPackages.
  ///
  /// In en, this message translates to:
  /// **'Popular Packages'**
  String get popularPackages;

  /// No description provided for @postalCode.
  ///
  /// In en, this message translates to:
  /// **'Postal Code'**
  String get postalCode;

  /// No description provided for @postalCodeHint.
  ///
  /// In en, this message translates to:
  /// **'5-digit postal code according to your area'**
  String get postalCodeHint;

  /// No description provided for @postalCodeMin5.
  ///
  /// In en, this message translates to:
  /// **'Postal code must be at least 5 digits'**
  String get postalCodeMin5;

  /// No description provided for @postalCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Postal code is required'**
  String get postalCodeRequired;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @priceAsc.
  ///
  /// In en, this message translates to:
  /// **'Price â†‘'**
  String get priceAsc;

  /// No description provided for @priceDesc.
  ///
  /// In en, this message translates to:
  /// **'Price â†“'**
  String get priceDesc;

  /// No description provided for @privacyAndTerms.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Terms'**
  String get privacyAndTerms;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @proceed.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get proceed;

  /// No description provided for @proceedToCheckout.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Checkout'**
  String get proceedToCheckout;

  /// No description provided for @processed.
  ///
  /// In en, this message translates to:
  /// **'Processed'**
  String get processed;

  /// No description provided for @professional.
  ///
  /// In en, this message translates to:
  /// **'Professional'**
  String get professional;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @profileCompletion.
  ///
  /// In en, this message translates to:
  /// **'Profile Completion'**
  String get profileCompletion;

  /// No description provided for @profilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Profile Photo'**
  String get profilePhoto;

  /// No description provided for @profileSavedFailedSendOtp.
  ///
  /// In en, this message translates to:
  /// **'Profile saved. Failed to send email verification OTP.'**
  String get profileSavedFailedSendOtp;

  /// No description provided for @profileSavedVerifyEmail.
  ///
  /// In en, this message translates to:
  /// **'Profile saved. Verify your new email.'**
  String get profileSavedVerifyEmail;

  /// No description provided for @profileUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile'**
  String get profileUpdateFailed;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdated;

  /// No description provided for @promoNotifications.
  ///
  /// In en, this message translates to:
  /// **'Promo Notifications'**
  String get promoNotifications;

  /// No description provided for @promoNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive promo and discount information'**
  String get promoNotificationsDesc;

  /// No description provided for @province.
  ///
  /// In en, this message translates to:
  /// **'Province'**
  String get province;

  /// No description provided for @qris.
  ///
  /// In en, this message translates to:
  /// **'QRIS'**
  String get qris;

  /// No description provided for @qrisImageNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'QRIS image not available'**
  String get qrisImageNotAvailable;

  /// No description provided for @qrScanInstruction.
  ///
  /// In en, this message translates to:
  /// **'Scan this QRIS using your e-wallet app'**
  String get qrScanInstruction;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @quantityUpdated.
  ///
  /// In en, this message translates to:
  /// **'Quantity updated'**
  String get quantityUpdated;

  /// No description provided for @range10to50M.
  ///
  /// In en, this message translates to:
  /// **'Rp 10-50 Million'**
  String get range10to50M;

  /// No description provided for @range1to5M.
  ///
  /// In en, this message translates to:
  /// **'Rp 1-5 Million'**
  String get range1to5M;

  /// No description provided for @range5to10M.
  ///
  /// In en, this message translates to:
  /// **'Rp 5-10 Million'**
  String get range5to10M;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Ratings'**
  String get rating;

  /// No description provided for @reVerify.
  ///
  /// In en, this message translates to:
  /// **'Re-verify Face'**
  String get reVerify;

  /// No description provided for @receiverPhone.
  ///
  /// In en, this message translates to:
  /// **'Receiver Phone'**
  String get receiverPhone;

  /// No description provided for @recentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get recentSearches;

  /// No description provided for @recipientName.
  ///
  /// In en, this message translates to:
  /// **'Recipient Name'**
  String get recipientName;

  /// No description provided for @recommendation.
  ///
  /// In en, this message translates to:
  /// **'Recommendation'**
  String get recommendation;

  /// No description provided for @recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended For You'**
  String get recommended;

  /// No description provided for @refunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get refunded;

  /// No description provided for @registerNow.
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get registerNow;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration Successful'**
  String get registerSuccess;

  /// No description provided for @religion.
  ///
  /// In en, this message translates to:
  /// **'Religion'**
  String get religion;

  /// No description provided for @religionLabel.
  ///
  /// In en, this message translates to:
  /// **'Religion'**
  String get religionLabel;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberMe;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'*'**
  String get required;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @otpExpiresIn.
  ///
  /// In en, this message translates to:
  /// **'Code expires in {seconds}'**
  String otpExpiresIn(Object seconds);

  /// No description provided for @verifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying...'**
  String get verifying;

  /// No description provided for @resetCodeSent.
  ///
  /// In en, this message translates to:
  /// **'Reset code has been sent'**
  String get resetCodeSent;

  /// No description provided for @resetCodeSentToEmail.
  ///
  /// In en, this message translates to:
  /// **'Reset code has been sent to your email'**
  String get resetCodeSentToEmail;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @appLockReset.
  ///
  /// In en, this message translates to:
  /// **'App lock has been reset'**
  String get appLockReset;

  /// No description provided for @resultsFor.
  ///
  /// In en, this message translates to:
  /// **'{count} results for \"{query}\"'**
  String resultsFor(int count, String query);

  /// No description provided for @readyToCapture.
  ///
  /// In en, this message translates to:
  /// **'Hold steady... ready to capture'**
  String get readyToCapture;

  /// No description provided for @retake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get retake;

  /// No description provided for @reviewFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit review'**
  String get reviewFailed;

  /// No description provided for @reviewSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Review submitted successfully'**
  String get reviewSubmitted;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Ratings'**
  String get reviews;

  /// No description provided for @reviewUpdated.
  ///
  /// In en, this message translates to:
  /// **'Review updated successfully'**
  String get reviewUpdated;

  /// No description provided for @reviewDeleted.
  ///
  /// In en, this message translates to:
  /// **'Review deleted successfully'**
  String get reviewDeleted;

  /// No description provided for @failedUpdateReview.
  ///
  /// In en, this message translates to:
  /// **'Failed to update review'**
  String get failedUpdateReview;

  /// No description provided for @failedDeleteReview.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete review'**
  String get failedDeleteReview;

  /// No description provided for @editReview.
  ///
  /// In en, this message translates to:
  /// **'Edit Review'**
  String get editReview;

  /// No description provided for @deleteReviewConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this review?'**
  String get deleteReviewConfirm;

  /// No description provided for @salary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get salary;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Save & Continue'**
  String get saveAndContinue;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @scanFace.
  ///
  /// In en, this message translates to:
  /// **'Scan Face'**
  String get scanFace;

  /// No description provided for @scanIdCard.
  ///
  /// In en, this message translates to:
  /// **'Scan ID Card'**
  String get scanIdCard;

  /// No description provided for @scanAnalyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing image with AI...'**
  String get scanAnalyzing;

  /// No description provided for @scanDetected.
  ///
  /// In en, this message translates to:
  /// **'Detected automatically'**
  String get scanDetected;

  /// No description provided for @scanDetectedValuePrefix.
  ///
  /// In en, this message translates to:
  /// **'Detected: '**
  String get scanDetectedValuePrefix;

  /// No description provided for @scanIssueBlur.
  ///
  /// In en, this message translates to:
  /// **'Image is blurry — retake for a sharper photo'**
  String get scanIssueBlur;

  /// No description provided for @scanIssueDark.
  ///
  /// In en, this message translates to:
  /// **'Image is too dark — retake in better light'**
  String get scanIssueDark;

  /// No description provided for @scanIssueDocument.
  ///
  /// In en, this message translates to:
  /// **'No valid identity document detected — retake'**
  String get scanIssueDocument;

  /// No description provided for @scanIssueFace.
  ///
  /// In en, this message translates to:
  /// **'No single face detected — retake'**
  String get scanIssueFace;

  /// No description provided for @scanNotDetected.
  ///
  /// In en, this message translates to:
  /// **'Detection failed'**
  String get scanNotDetected;

  /// No description provided for @scanResult.
  ///
  /// In en, this message translates to:
  /// **'Scan Result'**
  String get scanResult;

  /// No description provided for @scanDocument.
  ///
  /// In en, this message translates to:
  /// **'Scan Document'**
  String get scanDocument;

  /// No description provided for @scanScore.
  ///
  /// In en, this message translates to:
  /// **'SCore'**
  String get scanScore;

  /// No description provided for @scanQrCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQrCode;

  /// No description provided for @scanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning...'**
  String get scanning;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchByImage.
  ///
  /// In en, this message translates to:
  /// **'Search by Image'**
  String get searchByImage;

  /// No description provided for @searchCountry.
  ///
  /// In en, this message translates to:
  /// **'Search country...'**
  String get searchCountry;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select your country'**
  String get selectCountry;

  /// No description provided for @searchEmpty.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get searchEmpty;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search anything...'**
  String get searchHint;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchPlaceholder;

  /// No description provided for @searchResults.
  ///
  /// In en, this message translates to:
  /// **'Search Results'**
  String get searchResults;

  /// No description provided for @searchWithImage.
  ///
  /// In en, this message translates to:
  /// **'Search with Image'**
  String get searchWithImage;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @seeAllCount.
  ///
  /// In en, this message translates to:
  /// **'See all {count} {label}'**
  String seeAllCount(int count, String label);

  /// No description provided for @selectAddress.
  ///
  /// In en, this message translates to:
  /// **'Select Address'**
  String get selectAddress;

  /// No description provided for @selectCity.
  ///
  /// In en, this message translates to:
  /// **'Select your city'**
  String get selectCity;

  /// No description provided for @selectCountryCode.
  ///
  /// In en, this message translates to:
  /// **'Select Country Code'**
  String get selectCountryCode;

  /// No description provided for @selectDistrict.
  ///
  /// In en, this message translates to:
  /// **'Select your district'**
  String get selectDistrict;

  /// No description provided for @selectEventDate.
  ///
  /// In en, this message translates to:
  /// **'Select event date'**
  String get selectEventDate;

  /// No description provided for @selectEventTime.
  ///
  /// In en, this message translates to:
  /// **'Select event time'**
  String get selectEventTime;

  /// No description provided for @selectEventDateTime.
  ///
  /// In en, this message translates to:
  /// **'Please select event date and time first'**
  String get selectEventDateTime;

  /// No description provided for @selectGender.
  ///
  /// In en, this message translates to:
  /// **'Select Gender'**
  String get selectGender;

  /// No description provided for @selectIdentityType.
  ///
  /// In en, this message translates to:
  /// **'Select Identity Type'**
  String get selectIdentityType;

  /// No description provided for @selectIncomeRange.
  ///
  /// In en, this message translates to:
  /// **'Select Income Range'**
  String get selectIncomeRange;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @selectMaritalStatus.
  ///
  /// In en, this message translates to:
  /// **'Select Marital Status'**
  String get selectMaritalStatus;

  /// No description provided for @selectOccupation.
  ///
  /// In en, this message translates to:
  /// **'Select Occupation'**
  String get selectOccupation;

  /// No description provided for @selectPhoto.
  ///
  /// In en, this message translates to:
  /// **'Select Photo'**
  String get selectPhoto;

  /// No description provided for @selectProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Select Profile Photo'**
  String get selectProfilePhoto;

  /// No description provided for @selectProvince.
  ///
  /// In en, this message translates to:
  /// **'Select your province'**
  String get selectProvince;

  /// No description provided for @selectReligion.
  ///
  /// In en, this message translates to:
  /// **'Select Religion'**
  String get selectReligion;

  /// No description provided for @selectSort.
  ///
  /// In en, this message translates to:
  /// **'Select Sort'**
  String get selectSort;

  /// No description provided for @selectSourceOfFunds.
  ///
  /// In en, this message translates to:
  /// **'Select Source of Funds'**
  String get selectSourceOfFunds;

  /// No description provided for @selectUsers.
  ///
  /// In en, this message translates to:
  /// **'Select Users'**
  String get selectUsers;

  /// No description provided for @selectVillage.
  ///
  /// In en, this message translates to:
  /// **'Select your village'**
  String get selectVillage;

  /// No description provided for @selfieIdentity.
  ///
  /// In en, this message translates to:
  /// **'Selfie Photo'**
  String get selfieIdentity;

  /// No description provided for @selfieImageTitle.
  ///
  /// In en, this message translates to:
  /// **'Selfie + Identity Photo'**
  String get selfieImageTitle;

  /// No description provided for @selfieKtp.
  ///
  /// In en, this message translates to:
  /// **'Selfie Photo'**
  String get selfieKtp;

  /// No description provided for @selfieNpwp.
  ///
  /// In en, this message translates to:
  /// **'Selfie Photo'**
  String get selfieNpwp;

  /// No description provided for @selfiePassport.
  ///
  /// In en, this message translates to:
  /// **'Selfie Photo'**
  String get selfiePassport;

  /// No description provided for @selfiePhoto.
  ///
  /// In en, this message translates to:
  /// **'Selfie Photo'**
  String get selfiePhoto;

  /// No description provided for @selfiePhotoUploaded.
  ///
  /// In en, this message translates to:
  /// **'Selfie photo uploaded'**
  String get selfiePhotoUploaded;

  /// No description provided for @selfieSim.
  ///
  /// In en, this message translates to:
  /// **'Selfie Photo'**
  String get selfieSim;

  /// No description provided for @selfieTips.
  ///
  /// In en, this message translates to:
  /// **'Tips: Make sure your face is clearly visible, well lit, and the photo is not blurry.'**
  String get selfieTips;

  /// No description provided for @selfieWithCard.
  ///
  /// In en, this message translates to:
  /// **'Selfie + ID Card'**
  String get selfieWithCard;

  /// No description provided for @selfieCardInstruction.
  ///
  /// In en, this message translates to:
  /// **'Align your face inside the top frame and your ID card inside the bottom frame'**
  String get selfieCardInstruction;

  /// No description provided for @selfieCardHoldCard.
  ///
  /// In en, this message translates to:
  /// **'Face detected — now hold your ID card inside the bottom frame'**
  String get selfieCardHoldCard;

  /// No description provided for @selfieCardValidationFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t detect your face and ID card together. Please retake.'**
  String get selfieCardValidationFailed;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @sendEmail.
  ///
  /// In en, this message translates to:
  /// **'Send Email'**
  String get sendEmail;

  /// No description provided for @sendFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send'**
  String get sendFailed;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @sendResetCode.
  ///
  /// In en, this message translates to:
  /// **'Send OTP Code'**
  String get sendResetCode;

  /// No description provided for @sendToWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Send to WhatsApp'**
  String get sendToWhatsapp;

  /// No description provided for @sendViaGmail.
  ///
  /// In en, this message translates to:
  /// **'Send via Gmail app'**
  String get sendViaGmail;

  /// No description provided for @sendViaSms.
  ///
  /// In en, this message translates to:
  /// **'Send via Messages (SMS)'**
  String get sendViaSms;

  /// No description provided for @sending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get sending;

  /// Services section label
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @shareInvoice.
  ///
  /// In en, this message translates to:
  /// **'Share Invoice'**
  String get shareInvoice;

  /// No description provided for @shareOrderDetail.
  ///
  /// In en, this message translates to:
  /// **'Share order detail'**
  String get shareOrderDetail;

  /// No description provided for @shareCatalog.
  ///
  /// In en, this message translates to:
  /// **'Share catalog'**
  String get shareCatalog;

  /// No description provided for @shippingAddress.
  ///
  /// In en, this message translates to:
  /// **'Shipping Address'**
  String get shippingAddress;

  /// No description provided for @packages.
  ///
  /// In en, this message translates to:
  /// **'Packages'**
  String get packages;

  /// No description provided for @catalogs.
  ///
  /// In en, this message translates to:
  /// **'Catalogs'**
  String get catalogs;

  /// No description provided for @selectPackage.
  ///
  /// In en, this message translates to:
  /// **'Select Package'**
  String get selectPackage;

  /// No description provided for @packageDescription.
  ///
  /// In en, this message translates to:
  /// **'What\'s Included'**
  String get packageDescription;

  /// No description provided for @noPackageAvailable.
  ///
  /// In en, this message translates to:
  /// **'This package is out of stock'**
  String get noPackageAvailable;

  /// No description provided for @choosePackageFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a package first'**
  String get choosePackageFirst;

  /// No description provided for @selectPackageDecoration.
  ///
  /// In en, this message translates to:
  /// **'Select Package Decoration'**
  String get selectPackageDecoration;

  /// No description provided for @startingFrom.
  ///
  /// In en, this message translates to:
  /// **'Starting from'**
  String get startingFrom;

  /// No description provided for @noMatchingItems.
  ///
  /// In en, this message translates to:
  /// **'No matching items found'**
  String get noMatchingItems;

  /// No description provided for @priceLowToHigh.
  ///
  /// In en, this message translates to:
  /// **'Price ↑'**
  String get priceLowToHigh;

  /// No description provided for @priceHighToLow.
  ///
  /// In en, this message translates to:
  /// **'Price ↓'**
  String get priceHighToLow;

  /// No description provided for @shippingCost.
  ///
  /// In en, this message translates to:
  /// **'Shipping Cost'**
  String get shippingCost;

  /// No description provided for @shopeepay.
  ///
  /// In en, this message translates to:
  /// **'ShopeePay'**
  String get shopeepay;

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get showLess;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get showMore;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @loginRequired.
  ///
  /// In en, this message translates to:
  /// **'Please sign in or create an account to continue checkout'**
  String get loginRequired;

  /// No description provided for @guestAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access this feature'**
  String get guestAccessTitle;

  /// No description provided for @guestAccessDescription.
  ///
  /// In en, this message translates to:
  /// **'Please sign in or create an account to use this account feature.'**
  String get guestAccessDescription;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account'**
  String get signInSubtitle;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signUpNow.
  ///
  /// In en, this message translates to:
  /// **'Sign Up Now'**
  String get signUpNow;

  /// No description provided for @sim.
  ///
  /// In en, this message translates to:
  /// **'Driver\'s License (SIM)'**
  String get sim;

  /// No description provided for @simLabel.
  ///
  /// In en, this message translates to:
  /// **'Driver\'s License Number (SIM)'**
  String get simLabel;

  /// No description provided for @simMin6Chars.
  ///
  /// In en, this message translates to:
  /// **'SIM minimum 6 characters'**
  String get simMin6Chars;

  /// No description provided for @simNumber.
  ///
  /// In en, this message translates to:
  /// **'SIM Number'**
  String get simNumber;

  /// No description provided for @simPhoto.
  ///
  /// In en, this message translates to:
  /// **'SIM Photo'**
  String get simPhoto;

  /// No description provided for @simShort.
  ///
  /// In en, this message translates to:
  /// **'driver\'s license'**
  String get simShort;

  /// No description provided for @similarPackages.
  ///
  /// In en, this message translates to:
  /// **'Similar Packages'**
  String get similarPackages;

  /// No description provided for @similarity.
  ///
  /// In en, this message translates to:
  /// **'Similarity'**
  String get similarity;

  /// No description provided for @single.
  ///
  /// In en, this message translates to:
  /// **'Single'**
  String get single;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @slug.
  ///
  /// In en, this message translates to:
  /// **'Slugs'**
  String get slug;

  /// No description provided for @sourceOfFunds.
  ///
  /// In en, this message translates to:
  /// **'Source of Funds'**
  String get sourceOfFunds;

  /// No description provided for @sourceOfFundsLabel.
  ///
  /// In en, this message translates to:
  /// **'Source of Funds'**
  String get sourceOfFundsLabel;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @specialPromo.
  ///
  /// In en, this message translates to:
  /// **'Special Promo'**
  String get specialPromo;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @stock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stock;

  /// No description provided for @strong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get strong;

  /// No description provided for @student.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get student;

  /// No description provided for @submitReview.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get submitReview;

  /// No description provided for @subtitle.
  ///
  /// In en, this message translates to:
  /// **'Subtitle'**
  String get subtitle;

  /// No description provided for @subtitleAddress.
  ///
  /// In en, this message translates to:
  /// **'Your complete residential address'**
  String get subtitleAddress;

  /// No description provided for @subtitleAvatar.
  ///
  /// In en, this message translates to:
  /// **'Clear and up-to-date profile photo'**
  String get subtitleAvatar;

  /// No description provided for @subtitleBirth.
  ///
  /// In en, this message translates to:
  /// **'Your place and date of birth'**
  String get subtitleBirth;

  /// No description provided for @subtitleCompleteData.
  ///
  /// In en, this message translates to:
  /// **'Complete this information to improve account security'**
  String get subtitleCompleteData;

  /// No description provided for @subtitleCountry.
  ///
  /// In en, this message translates to:
  /// **'Your current country of residence'**
  String get subtitleCountry;

  /// No description provided for @subtitleEmail.
  ///
  /// In en, this message translates to:
  /// **'Active email for account verification and notifications'**
  String get subtitleEmail;

  /// No description provided for @subtitleFullName.
  ///
  /// In en, this message translates to:
  /// **'Name according to your identity document'**
  String get subtitleFullName;

  /// No description provided for @subtitleGender.
  ///
  /// In en, this message translates to:
  /// **'Gender according to identity document'**
  String get subtitleGender;

  /// No description provided for @subtitleIncomeRange.
  ///
  /// In en, this message translates to:
  /// **'Monthly income range'**
  String get subtitleIncomeRange;

  /// No description provided for @subtitleKtpPhoto.
  ///
  /// In en, this message translates to:
  /// **'Clear photo of ID Card / Passport / SIM / NPWP'**
  String get subtitleKtpPhoto;

  /// No description provided for @subtitleMaritalStatus.
  ///
  /// In en, this message translates to:
  /// **'Current marital status'**
  String get subtitleMaritalStatus;

  /// No description provided for @subtitleMotherName.
  ///
  /// In en, this message translates to:
  /// **'Mother\'s maiden name for security verification'**
  String get subtitleMotherName;

  /// No description provided for @subtitleKtpNumber.
  ///
  /// In en, this message translates to:
  /// **'Identity number (ID Card / Passport / SIM / NPWP)'**
  String get subtitleKtpNumber;

  /// No description provided for @subtitleOccupation.
  ///
  /// In en, this message translates to:
  /// **'Your current main occupation'**
  String get subtitleOccupation;

  /// No description provided for @subtitlePostalCode.
  ///
  /// In en, this message translates to:
  /// **'Postal code of your area'**
  String get subtitlePostalCode;

  /// No description provided for @subtitleRegion.
  ///
  /// In en, this message translates to:
  /// **'Province, city, district, sub-district, and postal code'**
  String get subtitleRegion;

  /// No description provided for @subtitleReligion.
  ///
  /// In en, this message translates to:
  /// **'Your religion'**
  String get subtitleReligion;

  /// No description provided for @subtitleSelfie.
  ///
  /// In en, this message translates to:
  /// **'Clear selfie photo of your face'**
  String get subtitleSelfie;

  /// No description provided for @subtitleSourceOfFunds.
  ///
  /// In en, this message translates to:
  /// **'Source of funds for transactions'**
  String get subtitleSourceOfFunds;

  /// No description provided for @subtitleUsername.
  ///
  /// In en, this message translates to:
  /// **'Unique username for your profile'**
  String get subtitleUsername;

  /// No description provided for @subtitleWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Active WhatsApp number for communication'**
  String get subtitleWhatsapp;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Sub-Total'**
  String get subtotal;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @switchAccount.
  ///
  /// In en, this message translates to:
  /// **'Switch Account'**
  String get switchAccount;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @takePhotoDirect.
  ///
  /// In en, this message translates to:
  /// **'Take a photo directly'**
  String get takePhotoDirect;

  /// No description provided for @takeVideo.
  ///
  /// In en, this message translates to:
  /// **'Take Video'**
  String get takeVideo;

  /// No description provided for @takeVideoDirect.
  ///
  /// In en, this message translates to:
  /// **'Record a video directly'**
  String get takeVideoDirect;

  /// No description provided for @videoGallery.
  ///
  /// In en, this message translates to:
  /// **'Video from Gallery'**
  String get videoGallery;

  /// No description provided for @galleryMultiHint.
  ///
  /// In en, this message translates to:
  /// **'Select multiple photos & videos'**
  String get galleryMultiHint;

  /// No description provided for @selectFromFiles.
  ///
  /// In en, this message translates to:
  /// **'Select Photos, Videos & Documents'**
  String get selectFromFiles;

  /// No description provided for @selectedProofMedia.
  ///
  /// In en, this message translates to:
  /// **'{count} media selected'**
  String selectedProofMedia(Object count);

  /// No description provided for @tapPhotoToSelect.
  ///
  /// In en, this message translates to:
  /// **'Tap photo to select an image'**
  String get tapPhotoToSelect;

  /// No description provided for @tapToSelectImage.
  ///
  /// In en, this message translates to:
  /// **'Tap to select an image'**
  String get tapToSelectImage;

  /// No description provided for @tapToSelectPhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap to select photo from gallery or camera'**
  String get tapToSelectPhoto;

  /// No description provided for @tapToUploadProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload profile photo'**
  String get tapToUploadProfilePhoto;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @thai.
  ///
  /// In en, this message translates to:
  /// **'Ã Â¹â€žÃ Â¸—Ã Â¸Â¢'**
  String get thai;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themePreference.
  ///
  /// In en, this message translates to:
  /// **'Theme Preference'**
  String get themePreference;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @timeRemaining.
  ///
  /// In en, this message translates to:
  /// **'Time Remaining'**
  String get timeRemaining;

  /// No description provided for @timezoneWIB.
  ///
  /// In en, this message translates to:
  /// **'WIB'**
  String get timezoneWIB;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @totalPayment.
  ///
  /// In en, this message translates to:
  /// **'Total Payment'**
  String get totalPayment;

  /// No description provided for @totalItems.
  ///
  /// In en, this message translates to:
  /// **'Total Items'**
  String get totalItems;

  /// No description provided for @totalOrder.
  ///
  /// In en, this message translates to:
  /// **'Total Orders'**
  String get totalOrder;

  /// No description provided for @totalPrice.
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get totalPrice;

  /// No description provided for @transactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionHistory;

  /// No description provided for @transactionId.
  ///
  /// In en, this message translates to:
  /// **'Transaction ID'**
  String get transactionId;

  /// No description provided for @transferBank.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get transferBank;

  /// No description provided for @transferInstructions.
  ///
  /// In en, this message translates to:
  /// **'How to Transfer'**
  String get transferInstructions;

  /// No description provided for @transferTo.
  ///
  /// In en, this message translates to:
  /// **'Transfer to'**
  String get transferTo;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @tryDifferentImage.
  ///
  /// In en, this message translates to:
  /// **'Try a different image'**
  String get tryDifferentImage;

  /// No description provided for @tryDifferentKeyword.
  ///
  /// In en, this message translates to:
  /// **'Try a different keyword'**
  String get tryDifferentKeyword;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @typeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeMessage;

  /// No description provided for @unlockApp.
  ///
  /// In en, this message translates to:
  /// **'Unlock App'**
  String get unlockApp;

  /// No description provided for @unlockWith.
  ///
  /// In en, this message translates to:
  /// **'Unlock app with %s'**
  String get unlockWith;

  /// No description provided for @unlockWithFaceId.
  ///
  /// In en, this message translates to:
  /// **'Unlock with Face ID'**
  String get unlockWithFaceId;

  /// No description provided for @unlockWithFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Unlock with Fingerprint'**
  String get unlockWithFingerprint;

  /// No description provided for @unpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get unpaid;

  /// No description provided for @updateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update'**
  String get updateFailed;

  /// No description provided for @updatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Updated successfully'**
  String get updatedSuccess;

  /// No description provided for @uploadClearPhotoOf.
  ///
  /// In en, this message translates to:
  /// **'Upload a clear photo of {label}'**
  String uploadClearPhotoOf(String label);

  /// No description provided for @uploadFacePhotoAction.
  ///
  /// In en, this message translates to:
  /// **'Scan face with camera'**
  String get uploadFacePhotoAction;

  /// No description provided for @uploadIdPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload ID Card / Passport / SIM / NPWP photo'**
  String get uploadIdPhoto;

  /// No description provided for @uploadIdPhotoAction.
  ///
  /// In en, this message translates to:
  /// **'Upload ID photo'**
  String get uploadIdPhotoAction;

  /// No description provided for @uploadIdSelfie.
  ///
  /// In en, this message translates to:
  /// **'Upload Selfie Photo'**
  String get uploadIdSelfie;

  /// No description provided for @uploadImageToSearch.
  ///
  /// In en, this message translates to:
  /// **'Upload an image to search for similar catalogs'**
  String get uploadImageToSearch;

  /// No description provided for @uploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload Photo'**
  String get uploadPhoto;

  /// No description provided for @uploadProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload your profile photo'**
  String get uploadProfilePhoto;

  /// No description provided for @uploadSelfieHoldingPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload a selfie photo while holding {label}'**
  String uploadSelfieHoldingPhoto(String label);

  /// No description provided for @uploadSelfiePhotoAction.
  ///
  /// In en, this message translates to:
  /// **'Take a selfie'**
  String get uploadSelfiePhotoAction;

  /// No description provided for @use.
  ///
  /// In en, this message translates to:
  /// **'Use'**
  String get use;

  /// No description provided for @useBiometricToUnlock.
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint or Face ID to unlock'**
  String get useBiometricToUnlock;

  /// No description provided for @useDeviceFaceId.
  ///
  /// In en, this message translates to:
  /// **'Unlock app by scanning your face with the camera'**
  String get useDeviceFaceId;

  /// No description provided for @identityVerificationSection.
  ///
  /// In en, this message translates to:
  /// **'Identity Verification'**
  String get identityVerificationSection;

  /// No description provided for @faceVerificationDescription.
  ///
  /// In en, this message translates to:
  /// **'Scan your face with the AI camera to verify your identity'**
  String get faceVerificationDescription;

  /// No description provided for @usePinToUnlock.
  ///
  /// In en, this message translates to:
  /// **'Use PIN to unlock'**
  String get usePinToUnlock;

  /// No description provided for @faceId.
  ///
  /// In en, this message translates to:
  /// **'Face ID'**
  String get faceId;

  /// No description provided for @pinLock.
  ///
  /// In en, this message translates to:
  /// **'PIN Lock'**
  String get pinLock;

  /// No description provided for @setPin.
  ///
  /// In en, this message translates to:
  /// **'Set PIN'**
  String get setPin;

  /// No description provided for @changePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePin;

  /// No description provided for @changePinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your app lock PIN'**
  String get changePinSubtitle;

  /// No description provided for @enterPinToUnlock.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN to unlock'**
  String get enterPinToUnlock;

  /// No description provided for @enterCurrentPin.
  ///
  /// In en, this message translates to:
  /// **'Enter current PIN'**
  String get enterCurrentPin;

  /// No description provided for @enterCurrentPinToDisable.
  ///
  /// In en, this message translates to:
  /// **'Enter your current PIN to turn off PIN lock'**
  String get enterCurrentPinToDisable;

  /// No description provided for @enterNewPin.
  ///
  /// In en, this message translates to:
  /// **'Enter new PIN'**
  String get enterNewPin;

  /// No description provided for @confirmPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN'**
  String get confirmPin;

  /// No description provided for @wrongPin.
  ///
  /// In en, this message translates to:
  /// **'Wrong PIN. Try again.'**
  String get wrongPin;

  /// No description provided for @disablePin.
  ///
  /// In en, this message translates to:
  /// **'Turn off PIN lock'**
  String get disablePin;

  /// No description provided for @useCbirFeature.
  ///
  /// In en, this message translates to:
  /// **'Use the CBIR feature to find decorations just with a photo'**
  String get useCbirFeature;

  /// No description provided for @useDarkTheme.
  ///
  /// In en, this message translates to:
  /// **'Use dark theme'**
  String get useDarkTheme;

  /// No description provided for @useFaceId.
  ///
  /// In en, this message translates to:
  /// **'Use Face ID to unlock'**
  String get useFaceId;

  /// No description provided for @appLockFaceId.
  ///
  /// In en, this message translates to:
  /// **'App Lock Face (AI Core)'**
  String get appLockFaceId;

  /// No description provided for @useAppLockFaceId.
  ///
  /// In en, this message translates to:
  /// **'Enroll face to unlock the app (AI Core)'**
  String get useAppLockFaceId;

  /// No description provided for @useFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint to unlock'**
  String get useFingerprint;

  /// No description provided for @useLightTheme.
  ///
  /// In en, this message translates to:
  /// **'Use light theme'**
  String get useLightTheme;

  /// No description provided for @useNow.
  ///
  /// In en, this message translates to:
  /// **'Use Now'**
  String get useNow;

  /// No description provided for @userAgreement.
  ///
  /// In en, this message translates to:
  /// **'User Agreement'**
  String get userAgreement;

  /// No description provided for @userId.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get userId;

  /// No description provided for @userLabel.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get userLabel;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @usernameHint.
  ///
  /// In en, this message translates to:
  /// **'Username can only contain letters, numbers, dots, and undersCores'**
  String get usernameHint;

  /// No description provided for @vaNumber.
  ///
  /// In en, this message translates to:
  /// **'VA Number'**
  String get vaNumber;

  /// No description provided for @validUntil.
  ///
  /// In en, this message translates to:
  /// **'Valid Until'**
  String get validUntil;

  /// No description provided for @verificationCodeSent.
  ///
  /// In en, this message translates to:
  /// **'Verification code has been sent'**
  String get verificationCodeSent;

  /// No description provided for @verified100.
  ///
  /// In en, this message translates to:
  /// **'Identity Verified 100%'**
  String get verified100;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @verifyEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Verify your email address'**
  String get verifyEmailAddress;

  /// No description provided for @verifyNow.
  ///
  /// In en, this message translates to:
  /// **'Verify Now'**
  String get verifyNow;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @verifyWithCamera.
  ///
  /// In en, this message translates to:
  /// **'Verify face with camera'**
  String get verifyWithCamera;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @vietnamese.
  ///
  /// In en, this message translates to:
  /// **'TiÃ¡ÂºÂ¿ng ViÃ¡Â»â€¡t'**
  String get vietnamese;

  /// No description provided for @viewDetail.
  ///
  /// In en, this message translates to:
  /// **'View Detail'**
  String get viewDetail;

  /// No description provided for @viewOrder.
  ///
  /// In en, this message translates to:
  /// **'View Order'**
  String get viewOrder;

  /// No description provided for @village.
  ///
  /// In en, this message translates to:
  /// **'Village / Sub-district'**
  String get village;

  /// No description provided for @voucherAndDiscount.
  ///
  /// In en, this message translates to:
  /// **'Voucher & Discount'**
  String get voucherAndDiscount;

  /// No description provided for @voucherApplied.
  ///
  /// In en, this message translates to:
  /// **'Voucher applied successfully!'**
  String get voucherApplied;

  /// No description provided for @voucherCode.
  ///
  /// In en, this message translates to:
  /// **'Voucher Code'**
  String get voucherCode;

  /// No description provided for @voucherDetail.
  ///
  /// In en, this message translates to:
  /// **'Voucher Detail'**
  String get voucherDetail;

  /// No description provided for @voucherDiscount.
  ///
  /// In en, this message translates to:
  /// **'Voucher Discount'**
  String get voucherDiscount;

  /// No description provided for @voucherEmpty.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any vouchers yet'**
  String get voucherEmpty;

  /// No description provided for @voucherUsed.
  ///
  /// In en, this message translates to:
  /// **'Voucher used successfully'**
  String get voucherUsed;

  /// No description provided for @warningCheckRemember.
  ///
  /// In en, this message translates to:
  /// **'Check Remember Me first'**
  String get warningCheckRemember;

  /// No description provided for @warningMustAgree.
  ///
  /// In en, this message translates to:
  /// **'You must agree to the agreement to continue'**
  String get warningMustAgree;

  /// No description provided for @weak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get weak;

  /// No description provided for @weddingDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Wedding Date'**
  String get weddingDateLabel;

  /// No description provided for @weddingDecorationDreams.
  ///
  /// In en, this message translates to:
  /// **'Wedding Decoration Dreams'**
  String get weddingDecorationDreams;

  /// No description provided for @weddingPolicy.
  ///
  /// In en, this message translates to:
  /// **'Wedding Policy'**
  String get weddingPolicy;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// No description provided for @whatsappExample.
  ///
  /// In en, this message translates to:
  /// **'Example: 8123456789 (without leading zero)'**
  String get whatsappExample;

  /// No description provided for @whatsappNumber.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp Number'**
  String get whatsappNumber;

  /// No description provided for @whatsappUsedForNotification.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp number will be used for order notifications'**
  String get whatsappUsedForNotification;

  /// No description provided for @whatsappVerified.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp verified'**
  String get whatsappVerified;

  /// No description provided for @whatsappOtpSentTo.
  ///
  /// In en, this message translates to:
  /// **'Enter the WhatsApp OTP code sent to'**
  String get whatsappOtpSentTo;

  /// No description provided for @whatsappVerifyRequired.
  ///
  /// In en, this message translates to:
  /// **'Please verify your WhatsApp number first'**
  String get whatsappVerifyRequired;

  /// No description provided for @favoriteNotifications.
  ///
  /// In en, this message translates to:
  /// **'Favorite Notifications'**
  String get favoriteNotifications;

  /// No description provided for @favoriteNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive Favorite notifications'**
  String get favoriteNotificationsDesc;

  /// No description provided for @writeRatingComment.
  ///
  /// In en, this message translates to:
  /// **'Write a Rating & Comment'**
  String get writeRatingComment;

  /// No description provided for @writeYourReview.
  ///
  /// In en, this message translates to:
  /// **'Write your review...'**
  String get writeYourReview;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @yesCancel.
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get yesCancel;

  /// No description provided for @youMustAgree.
  ///
  /// In en, this message translates to:
  /// **'You must agree to the agreement to continue'**
  String get youMustAgree;

  /// No description provided for @yourNameAppearsHere.
  ///
  /// In en, this message translates to:
  /// **'Your name will appear here'**
  String get yourNameAppearsHere;

  /// No description provided for @voucherName.
  ///
  /// In en, this message translates to:
  /// **'Voucher Name'**
  String get voucherName;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @claim.
  ///
  /// In en, this message translates to:
  /// **'Claim'**
  String get claim;

  /// No description provided for @voucherClaimed.
  ///
  /// In en, this message translates to:
  /// **'Voucher claimed successfully'**
  String get voucherClaimed;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @invalidVoucherCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid voucher code'**
  String get invalidVoucherCode;

  /// No description provided for @period.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get period;

  /// No description provided for @selectItem.
  ///
  /// In en, this message translates to:
  /// **'Select Item'**
  String get selectItem;

  /// No description provided for @itemType.
  ///
  /// In en, this message translates to:
  /// **'Item Type'**
  String get itemType;

  /// No description provided for @itemName.
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get itemName;

  /// No description provided for @invalidValue.
  ///
  /// In en, this message translates to:
  /// **'Invalid value'**
  String get invalidValue;

  /// No description provided for @selectItemFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select an item type and item first'**
  String get selectItemFirst;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @deselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect All'**
  String get deselectAll;

  /// No description provided for @outOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get outOfStock;

  /// No description provided for @remainingStock.
  ///
  /// In en, this message translates to:
  /// **'{stock} left'**
  String remainingStock(Object stock);

  /// No description provided for @itemMovedToFavorite.
  ///
  /// In en, this message translates to:
  /// **'Item moved to Favorite'**
  String get itemMovedToFavorite;

  /// No description provided for @itemDeleted.
  ///
  /// In en, this message translates to:
  /// **'Item deleted'**
  String get itemDeleted;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @saveForLater.
  ///
  /// In en, this message translates to:
  /// **'Save for later'**
  String get saveForLater;

  /// No description provided for @itemsSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} item(s) selected'**
  String itemsSelected(Object count);

  /// No description provided for @deleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete all'**
  String get deleteAll;

  /// No description provided for @selectType.
  ///
  /// In en, this message translates to:
  /// **'Select Type'**
  String get selectType;

  /// No description provided for @whatToAdd.
  ///
  /// In en, this message translates to:
  /// **'What would you like to add?'**
  String get whatToAdd;

  /// No description provided for @percentageValue.
  ///
  /// In en, this message translates to:
  /// **'Value (%)'**
  String get percentageValue;

  /// No description provided for @currencyValue.
  ///
  /// In en, this message translates to:
  /// **'Value (Rp)'**
  String get currencyValue;

  /// No description provided for @invoiceDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Invoice downloaded successfully'**
  String get invoiceDownloaded;

  /// No description provided for @failedDownloadInvoice.
  ///
  /// In en, this message translates to:
  /// **'Failed to download invoice'**
  String get failedDownloadInvoice;

  /// No description provided for @invoiceSentToEmail.
  ///
  /// In en, this message translates to:
  /// **'Invoice sent to your email'**
  String get invoiceSentToEmail;

  /// No description provided for @failedSendEmail.
  ///
  /// In en, this message translates to:
  /// **'Failed to send email'**
  String get failedSendEmail;

  /// No description provided for @failedOpenWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Failed to open WhatsApp'**
  String get failedOpenWhatsApp;

  /// No description provided for @failedGetOrderId.
  ///
  /// In en, this message translates to:
  /// **'Failed to get order ID'**
  String get failedGetOrderId;

  /// No description provided for @failedGetPaymentToken.
  ///
  /// In en, this message translates to:
  /// **'Failed to get payment token'**
  String get failedGetPaymentToken;

  /// No description provided for @whatsappOrderTemplate.
  ///
  /// In en, this message translates to:
  /// **'Hi Admin, I would like to ask about order #{orderNumber}. Status: {status}. Total: {total}.'**
  String whatsappOrderTemplate(String orderNumber, String status, String total);

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithFacebook.
  ///
  /// In en, this message translates to:
  /// **'Continue with Facebook'**
  String get continueWithFacebook;

  /// No description provided for @continueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continueWithApple;

  /// No description provided for @catalogLabel.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get catalogLabel;

  /// No description provided for @packageLabel.
  ///
  /// In en, this message translates to:
  /// **'Package'**
  String get packageLabel;

  /// No description provided for @voucherSpecialOffer.
  ///
  /// In en, this message translates to:
  /// **'Special discount for you'**
  String get voucherSpecialOffer;

  /// No description provided for @searchUsersHint.
  ///
  /// In en, this message translates to:
  /// **'Search users...'**
  String get searchUsersHint;

  /// No description provided for @usersSelectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} user(s) selected'**
  String usersSelectedCount(int count);

  /// No description provided for @biometricFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint'**
  String get biometricFingerprint;

  /// No description provided for @biometricLoginLabel.
  ///
  /// In en, this message translates to:
  /// **'Biometric Login'**
  String get biometricLoginLabel;

  /// No description provided for @sectionVouchers.
  ///
  /// In en, this message translates to:
  /// **'Vouchers'**
  String get sectionVouchers;

  /// No description provided for @sectionUsers.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get sectionUsers;

  /// No description provided for @sectionTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get sectionTransactions;

  /// No description provided for @sectionPolicy.
  ///
  /// In en, this message translates to:
  /// **'Policy'**
  String get sectionPolicy;

  /// No description provided for @vouchers.
  ///
  /// In en, this message translates to:
  /// **'Vouchers'**
  String get vouchers;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @searchFailedTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Search failed. Please try again.'**
  String get searchFailedTryAgain;

  /// No description provided for @selectTwoImagesArithmetic.
  ///
  /// In en, this message translates to:
  /// **'Select 2 images and arithmetic operation'**
  String get selectTwoImagesArithmetic;

  /// No description provided for @imageSearchFailed.
  ///
  /// In en, this message translates to:
  /// **'Image search failed'**
  String get imageSearchFailed;

  /// No description provided for @arithmeticSearchFailedMsg.
  ///
  /// In en, this message translates to:
  /// **'Arithmetic search failed'**
  String get arithmeticSearchFailedMsg;

  /// No description provided for @failedLoadConversations.
  ///
  /// In en, this message translates to:
  /// **'Failed to load conversations'**
  String get failedLoadConversations;

  /// No description provided for @failedLoadMessages.
  ///
  /// In en, this message translates to:
  /// **'Failed to load messages'**
  String get failedLoadMessages;

  /// No description provided for @failedCreateOrder.
  ///
  /// In en, this message translates to:
  /// **'Failed to create order'**
  String get failedCreateOrder;

  /// No description provided for @failedProcessPayment.
  ///
  /// In en, this message translates to:
  /// **'Failed to process payment'**
  String get failedProcessPayment;

  /// No description provided for @failedLoadNotifications.
  ///
  /// In en, this message translates to:
  /// **'Failed to load notifications'**
  String get failedLoadNotifications;

  /// No description provided for @failedLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile'**
  String get failedLoadProfile;

  /// No description provided for @failedUpdateProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile'**
  String get failedUpdateProfile;

  /// No description provided for @failedUploadAvatar.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload avatar'**
  String get failedUploadAvatar;

  /// No description provided for @failedUpdateKtpNumber.
  ///
  /// In en, this message translates to:
  /// **'Failed to update KTP'**
  String get failedUpdateKtpNumber;

  /// No description provided for @failedUploadKtp.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload KTP'**
  String get failedUploadKtp;

  /// No description provided for @failedUploadSelfie.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload selfie'**
  String get failedUploadSelfie;

  /// No description provided for @failedUploadFaceScan.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload face scan'**
  String get failedUploadFaceScan;

  /// No description provided for @failedChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Failed to change password'**
  String get failedChangePassword;

  /// No description provided for @failedLoadCart.
  ///
  /// In en, this message translates to:
  /// **'Failed to load cart'**
  String get failedLoadCart;

  /// No description provided for @faqs.
  ///
  /// In en, this message translates to:
  /// **'FAQs'**
  String get faqs;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @failedGetGoogleToken.
  ///
  /// In en, this message translates to:
  /// **'Failed to get Google token'**
  String get failedGetGoogleToken;

  /// No description provided for @googleLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'Google login failed'**
  String get googleLoginFailed;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registrationFailed;

  /// No description provided for @registrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful'**
  String get registrationSuccess;

  /// No description provided for @anErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get anErrorOccurred;

  /// No description provided for @failedLoadItemData.
  ///
  /// In en, this message translates to:
  /// **'Failed to load item data'**
  String get failedLoadItemData;

  /// No description provided for @dataNotFound.
  ///
  /// In en, this message translates to:
  /// **'Data not found'**
  String get dataNotFound;

  /// No description provided for @failedGetFacebookToken.
  ///
  /// In en, this message translates to:
  /// **'Failed to get Facebook token'**
  String get failedGetFacebookToken;

  /// No description provided for @facebookLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'Facebook login failed'**
  String get facebookLoginFailed;

  /// No description provided for @failedGetAppleToken.
  ///
  /// In en, this message translates to:
  /// **'Failed to get Apple token'**
  String get failedGetAppleToken;

  /// No description provided for @appleLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'Apple login failed'**
  String get appleLoginFailed;

  /// No description provided for @appLockNote.
  ///
  /// In en, this message translates to:
  /// **'App Lock uses device fingerprint, AI Core face verification, or PIN to unlock the app. This is different from the Profile Face Verification (KYC) that verifies your identity.'**
  String get appLockNote;

  /// No description provided for @identityNumberAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'This identity number is already registered by another user'**
  String get identityNumberAlreadyRegistered;

  /// No description provided for @googleAccountAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'Your Google account is already registered. Please sign in with email and password.'**
  String get googleAccountAlreadyRegistered;

  /// No description provided for @facebookAccountAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'Your Facebook account is already registered. Please sign in with email and password.'**
  String get facebookAccountAlreadyRegistered;

  /// No description provided for @csTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer Service'**
  String get csTitle;

  /// No description provided for @csSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We are ready to help you'**
  String get csSubtitle;

  /// No description provided for @csWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Customer Service!'**
  String get csWelcomeTitle;

  /// No description provided for @csWelcomeDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose a topic below or send a message directly. Our team will help you as soon as possible.'**
  String get csWelcomeDesc;

  /// No description provided for @csQuickBugReport.
  ///
  /// In en, this message translates to:
  /// **'Report Bug'**
  String get csQuickBugReport;

  /// No description provided for @csQuickBugReportDesc.
  ///
  /// In en, this message translates to:
  /// **'Report an issue or bug'**
  String get csQuickBugReportDesc;

  /// No description provided for @csQuickAccountIssue.
  ///
  /// In en, this message translates to:
  /// **'Account Issue'**
  String get csQuickAccountIssue;

  /// No description provided for @csQuickAccountIssueDesc.
  ///
  /// In en, this message translates to:
  /// **'Problems with your account'**
  String get csQuickAccountIssueDesc;

  /// No description provided for @csQuickOrderHelp.
  ///
  /// In en, this message translates to:
  /// **'Order Help'**
  String get csQuickOrderHelp;

  /// No description provided for @csQuickOrderHelpDesc.
  ///
  /// In en, this message translates to:
  /// **'Help with your orders'**
  String get csQuickOrderHelpDesc;

  /// No description provided for @csQuickPaymentIssue.
  ///
  /// In en, this message translates to:
  /// **'Payment Issue'**
  String get csQuickPaymentIssue;

  /// No description provided for @csQuickPaymentIssueDesc.
  ///
  /// In en, this message translates to:
  /// **'Problems with payment'**
  String get csQuickPaymentIssueDesc;

  /// No description provided for @csQuickDecorConsult.
  ///
  /// In en, this message translates to:
  /// **'Decoration Consultation'**
  String get csQuickDecorConsult;

  /// No description provided for @csQuickDecorConsultDesc.
  ///
  /// In en, this message translates to:
  /// **'Consult about decoration'**
  String get csQuickDecorConsultDesc;

  /// No description provided for @csQuickGeneralQuestion.
  ///
  /// In en, this message translates to:
  /// **'General Question'**
  String get csQuickGeneralQuestion;

  /// No description provided for @csQuickGeneralQuestionDesc.
  ///
  /// In en, this message translates to:
  /// **'Ask anything'**
  String get csQuickGeneralQuestionDesc;

  /// No description provided for @csRequestHumanAgent.
  ///
  /// In en, this message translates to:
  /// **'Talk to Human Agent'**
  String get csRequestHumanAgent;

  /// No description provided for @csBotTyping.
  ///
  /// In en, this message translates to:
  /// **'Admin is typing...'**
  String get csBotTyping;

  /// No description provided for @csBotSenderName.
  ///
  /// In en, this message translates to:
  /// **'Customer Service Bot'**
  String get csBotSenderName;

  /// No description provided for @csHumanSenderName.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get csHumanSenderName;

  /// No description provided for @guestName.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guestName;

  /// No description provided for @csGuestNoAttachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments are not available in guest mode.'**
  String get csGuestNoAttachments;

  /// No description provided for @csTicketStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get csTicketStatus;

  /// No description provided for @csTicketOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get csTicketOpen;

  /// No description provided for @csTicketInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get csTicketInProgress;

  /// No description provided for @csTicketResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get csTicketResolved;

  /// No description provided for @csTicketClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get csTicketClosed;

  /// No description provided for @csNoConversations.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get csNoConversations;

  /// No description provided for @csNoConversationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Start a conversation with our team'**
  String get csNoConversationsDesc;

  /// No description provided for @csStartChat.
  ///
  /// In en, this message translates to:
  /// **'Start Chat'**
  String get csStartChat;

  /// No description provided for @csAttachScreenshot.
  ///
  /// In en, this message translates to:
  /// **'Attach Screenshot'**
  String get csAttachScreenshot;

  /// No description provided for @csAttachScreenshotDesc.
  ///
  /// In en, this message translates to:
  /// **'Help us understand the issue better'**
  String get csAttachScreenshotDesc;

  /// No description provided for @csSelectOrderFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select an order first'**
  String get csSelectOrderFirst;

  /// No description provided for @csConversationStarted.
  ///
  /// In en, this message translates to:
  /// **'Conversation started'**
  String get csConversationStarted;

  /// No description provided for @csHumanAgentJoined.
  ///
  /// In en, this message translates to:
  /// **'A human agent has joined the conversation'**
  String get csHumanAgentJoined;

  /// No description provided for @csOfflineMessage.
  ///
  /// In en, this message translates to:
  /// **'Our team is currently offline. Leave a message and we will reply as soon as possible.'**
  String get csOfflineMessage;

  /// No description provided for @csQuickFaq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get csQuickFaq;

  /// No description provided for @csQuickFaqDesc.
  ///
  /// In en, this message translates to:
  /// **'Frequently asked questions'**
  String get csQuickFaqDesc;

  /// No description provided for @csOrderStatusHelp.
  ///
  /// In en, this message translates to:
  /// **'Check order status'**
  String get csOrderStatusHelp;

  /// No description provided for @csPaymentHelp.
  ///
  /// In en, this message translates to:
  /// **'Payment help'**
  String get csPaymentHelp;

  /// No description provided for @csAccountHelp.
  ///
  /// In en, this message translates to:
  /// **'Account help'**
  String get csAccountHelp;

  /// No description provided for @csDeliveryHelp.
  ///
  /// In en, this message translates to:
  /// **'Delivery info'**
  String get csDeliveryHelp;

  /// No description provided for @csRefundHelp.
  ///
  /// In en, this message translates to:
  /// **'Refund request'**
  String get csRefundHelp;

  /// No description provided for @csConsultationHelp.
  ///
  /// In en, this message translates to:
  /// **'Decoration consultation'**
  String get csConsultationHelp;

  /// No description provided for @csSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search conversations...'**
  String get csSearchHint;

  /// No description provided for @csYourConversations.
  ///
  /// In en, this message translates to:
  /// **'Your Conversations'**
  String get csYourConversations;

  /// No description provided for @csEmptyConversations.
  ///
  /// In en, this message translates to:
  /// **'No matching conversations'**
  String get csEmptyConversations;

  /// No description provided for @csNewChat.
  ///
  /// In en, this message translates to:
  /// **'New Chat'**
  String get csNewChat;

  /// No description provided for @csAccountDataForm.
  ///
  /// In en, this message translates to:
  /// **'**Account Verification Form**\n\nPlease complete the data below for verification:\n\n1. **Email**\n2. **Username**\n3. **Full Name:**\n   - First Name\n   - Middle Name\n   - Last Name\n4. **Place of Birth**\n5. **Date of Birth**\n6. **Mother\'s Maiden Name**\n7. **WhatsApp Number**\n8. **Full Address**\n9. **Postal Code**\n\nPlease reply with the completed data above. If necessary, attach an identity document (ID card) for further verification.'**
  String get csAccountDataForm;

  /// No description provided for @csAccountFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Verification Form'**
  String get csAccountFormTitle;

  /// No description provided for @csAccountFormSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please complete all required fields below. Your data will be used only for account verification.'**
  String get csAccountFormSubtitle;

  /// No description provided for @dateOfBirthRequired.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth is required'**
  String get dateOfBirthRequired;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @replyTo.
  ///
  /// In en, this message translates to:
  /// **'Reply to {name}'**
  String replyTo(String name);

  /// No description provided for @replyingTo.
  ///
  /// In en, this message translates to:
  /// **'Replying to {name}...'**
  String replyingTo(String name);

  /// No description provided for @cancelReply.
  ///
  /// In en, this message translates to:
  /// **'Cancel reply'**
  String get cancelReply;

  /// No description provided for @copyMessage.
  ///
  /// In en, this message translates to:
  /// **'Copy message'**
  String get copyMessage;

  /// No description provided for @translateMessage.
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get translateMessage;

  /// No description provided for @deleteForMe.
  ///
  /// In en, this message translates to:
  /// **'Delete for me'**
  String get deleteForMe;

  /// No description provided for @deleteForEveryone.
  ///
  /// In en, this message translates to:
  /// **'Delete for everyone'**
  String get deleteForEveryone;

  /// No description provided for @messageDeleted.
  ///
  /// In en, this message translates to:
  /// **'Message deleted'**
  String get messageDeleted;

  /// No description provided for @failedDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete message'**
  String get failedDeleteMessage;

  /// No description provided for @translating.
  ///
  /// In en, this message translates to:
  /// **'Translating...'**
  String get translating;

  /// No description provided for @translatedResult.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get translatedResult;

  /// No description provided for @forwardMessage.
  ///
  /// In en, this message translates to:
  /// **'Forward'**
  String get forwardMessage;

  /// No description provided for @selectAction.
  ///
  /// In en, this message translates to:
  /// **'Select Action'**
  String get selectAction;

  /// No description provided for @messageCopied.
  ///
  /// In en, this message translates to:
  /// **'Message copied'**
  String get messageCopied;

  /// No description provided for @confirmDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete this message?'**
  String get confirmDeleteMessage;

  /// No description provided for @confirmDeleteForEveryone.
  ///
  /// In en, this message translates to:
  /// **'Delete for everyone? This cannot be undone.'**
  String get confirmDeleteForEveryone;

  /// No description provided for @searchInChat.
  ///
  /// In en, this message translates to:
  /// **'Search in chat'**
  String get searchInChat;

  /// No description provided for @searchMessages.
  ///
  /// In en, this message translates to:
  /// **'Search messages...'**
  String get searchMessages;

  /// No description provided for @noSearchResults.
  ///
  /// In en, this message translates to:
  /// **'No messages found'**
  String get noSearchResults;

  /// No description provided for @starMessage.
  ///
  /// In en, this message translates to:
  /// **'Star'**
  String get starMessage;

  /// No description provided for @unstarMessage.
  ///
  /// In en, this message translates to:
  /// **'Unstar'**
  String get unstarMessage;

  /// No description provided for @forwardTo.
  ///
  /// In en, this message translates to:
  /// **'Forward to...'**
  String get forwardTo;

  /// No description provided for @selectConversation.
  ///
  /// In en, this message translates to:
  /// **'Select conversation'**
  String get selectConversation;

  /// No description provided for @messageForwarded.
  ///
  /// In en, this message translates to:
  /// **'Forwarded message'**
  String get messageForwarded;

  /// No description provided for @messageInfo.
  ///
  /// In en, this message translates to:
  /// **'Message info'**
  String get messageInfo;

  /// No description provided for @sentAt.
  ///
  /// In en, this message translates to:
  /// **'Sent at'**
  String get sentAt;

  /// No description provided for @readBy.
  ///
  /// In en, this message translates to:
  /// **'Read by'**
  String get readBy;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @read.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get read;

  /// No description provided for @sent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get sent;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @rateExperience.
  ///
  /// In en, this message translates to:
  /// **'Rate your experience'**
  String get rateExperience;

  /// No description provided for @rateExperienceHint.
  ///
  /// In en, this message translates to:
  /// **'How was our service?'**
  String get rateExperienceHint;

  /// No description provided for @ratingSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback!'**
  String get ratingSubmitted;

  /// No description provided for @excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellent;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// No description provided for @poor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get poor;

  /// No description provided for @veryPoor.
  ///
  /// In en, this message translates to:
  /// **'Very Poor'**
  String get veryPoor;

  /// No description provided for @addReaction.
  ///
  /// In en, this message translates to:
  /// **'Add reaction'**
  String get addReaction;

  /// No description provided for @reactionAdded.
  ///
  /// In en, this message translates to:
  /// **'Reaction added'**
  String get reactionAdded;

  /// No description provided for @markedAsRead.
  ///
  /// In en, this message translates to:
  /// **'Marked as read'**
  String get markedAsRead;

  /// No description provided for @unread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get unread;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @linkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied'**
  String get linkCopied;

  /// No description provided for @openLink.
  ///
  /// In en, this message translates to:
  /// **'Open link'**
  String get openLink;

  /// No description provided for @copyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get copyLink;

  /// No description provided for @quickReplies.
  ///
  /// In en, this message translates to:
  /// **'Quick replies'**
  String get quickReplies;

  /// No description provided for @noMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet. Start the conversation!'**
  String get noMessagesYet;

  /// No description provided for @conversationWithAdmin.
  ///
  /// In en, this message translates to:
  /// **'Chat with Admin'**
  String get conversationWithAdmin;

  /// No description provided for @poweredByCS.
  ///
  /// In en, this message translates to:
  /// **'Powered by Customer Service'**
  String get poweredByCS;

  /// No description provided for @csOnlineNow.
  ///
  /// In en, this message translates to:
  /// **'Our team is online'**
  String get csOnlineNow;

  /// No description provided for @csOfflineNow.
  ///
  /// In en, this message translates to:
  /// **'Our team is offline. We\'ll reply soon.'**
  String get csOfflineNow;

  /// No description provided for @messageInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Message Details'**
  String get messageInfoTitle;

  /// No description provided for @voiceGreeting.
  ///
  /// In en, this message translates to:
  /// **'Position your face inside the oval'**
  String get voiceGreeting;

  /// No description provided for @voiceHoldStill.
  ///
  /// In en, this message translates to:
  /// **'Good, hold still'**
  String get voiceHoldStill;

  /// No description provided for @voiceVerificationComplete.
  ///
  /// In en, this message translates to:
  /// **'Verification complete'**
  String get voiceVerificationComplete;

  /// No description provided for @voiceMultipleFaces.
  ///
  /// In en, this message translates to:
  /// **'Please make sure only your face is visible'**
  String get voiceMultipleFaces;

  /// No description provided for @voiceEyesClosed.
  ///
  /// In en, this message translates to:
  /// **'Please open your eyes'**
  String get voiceEyesClosed;

  /// No description provided for @voiceTooClose.
  ///
  /// In en, this message translates to:
  /// **'Move your face a bit further from the camera'**
  String get voiceTooClose;

  /// No description provided for @voiceToggleMute.
  ///
  /// In en, this message translates to:
  /// **'Toggle voice'**
  String get voiceToggleMute;

  /// No description provided for @voiceDocumentGreeting.
  ///
  /// In en, this message translates to:
  /// **'Position your ID document inside the frame'**
  String get voiceDocumentGreeting;

  /// No description provided for @voiceDocumentDetected.
  ///
  /// In en, this message translates to:
  /// **'Document detected, hold still'**
  String get voiceDocumentDetected;

  /// No description provided for @voiceDocumentTooFar.
  ///
  /// In en, this message translates to:
  /// **'Move the document closer to the camera'**
  String get voiceDocumentTooFar;

  /// No description provided for @voiceDocumentCaptured.
  ///
  /// In en, this message translates to:
  /// **'Document captured successfully'**
  String get voiceDocumentCaptured;

  /// No description provided for @voiceDocumentValidationFailed.
  ///
  /// In en, this message translates to:
  /// **'Document not detected, please try again'**
  String get voiceDocumentValidationFailed;

  /// No description provided for @voiceSelfieDocGreeting.
  ///
  /// In en, this message translates to:
  /// **'Position your face above and show your ID document below'**
  String get voiceSelfieDocGreeting;

  /// No description provided for @voiceSelfieDocFaceDetected.
  ///
  /// In en, this message translates to:
  /// **'Face detected, now show your document'**
  String get voiceSelfieDocFaceDetected;

  /// No description provided for @voiceSelfieDocCardDetected.
  ///
  /// In en, this message translates to:
  /// **'Document detected, hold still'**
  String get voiceSelfieDocCardDetected;

  /// No description provided for @voiceSelfieDocCaptured.
  ///
  /// In en, this message translates to:
  /// **'Photo captured successfully'**
  String get voiceSelfieDocCaptured;

  /// No description provided for @voiceAutoCaptureGreeting.
  ///
  /// In en, this message translates to:
  /// **'Position the object you want to photograph inside the frame'**
  String get voiceAutoCaptureGreeting;

  /// No description provided for @voiceAutoCaptureTooDark.
  ///
  /// In en, this message translates to:
  /// **'Find a brighter location'**
  String get voiceAutoCaptureTooDark;

  /// No description provided for @voiceAutoCaptureBlurry.
  ///
  /// In en, this message translates to:
  /// **'Steady the camera to avoid blurry photos'**
  String get voiceAutoCaptureBlurry;

  /// No description provided for @voiceAutoCaptureDetected.
  ///
  /// In en, this message translates to:
  /// **'Ready to capture'**
  String get voiceAutoCaptureDetected;

  /// No description provided for @voiceAutoCaptureCaptured.
  ///
  /// In en, this message translates to:
  /// **'Photo captured successfully'**
  String get voiceAutoCaptureCaptured;

  /// No description provided for @catalogNotifications.
  ///
  /// In en, this message translates to:
  /// **'Catalog Notifications'**
  String get catalogNotifications;

  /// No description provided for @catalogNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive updates on new and featured catalogs'**
  String get catalogNotificationsDesc;

  /// No description provided for @packageNotifications.
  ///
  /// In en, this message translates to:
  /// **'Package Notifications'**
  String get packageNotifications;

  /// No description provided for @packageNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive updates on available wedding packages'**
  String get packageNotificationsDesc;

  /// No description provided for @voucherNotifications.
  ///
  /// In en, this message translates to:
  /// **'Voucher & Promo Notifications'**
  String get voucherNotifications;

  /// No description provided for @voucherNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive voucher, promo and discount notifications'**
  String get voucherNotificationsDesc;

  /// No description provided for @reviewNotifications.
  ///
  /// In en, this message translates to:
  /// **'Review Notifications'**
  String get reviewNotifications;

  /// No description provided for @reviewNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications about reviews and ratings'**
  String get reviewNotificationsDesc;

  /// No description provided for @securityNotifications.
  ///
  /// In en, this message translates to:
  /// **'Security Notifications'**
  String get securityNotifications;

  /// No description provided for @securityNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive login alerts and account security notifications'**
  String get securityNotificationsDesc;

  /// No description provided for @enableAllNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable All'**
  String get enableAllNotifications;

  /// No description provided for @disableAllNotifications.
  ///
  /// In en, this message translates to:
  /// **'Disable All'**
  String get disableAllNotifications;

  /// No description provided for @notificationSoundEnabled.
  ///
  /// In en, this message translates to:
  /// **'Notification Sound'**
  String get notificationSoundEnabled;

  /// No description provided for @notificationSoundEnabledDesc.
  ///
  /// In en, this message translates to:
  /// **'Play a sound when a notification arrives'**
  String get notificationSoundEnabledDesc;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @passwordAndSecurity.
  ///
  /// In en, this message translates to:
  /// **'Password and Security'**
  String get passwordAndSecurity;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @changePasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Update your password and protect your account.'**
  String get changePasswordDesc;

  /// No description provided for @changePasswordInfo.
  ///
  /// In en, this message translates to:
  /// **'For security, enter your current password before changing it.'**
  String get changePasswordInfo;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @currentPasswordIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Current password is incorrect'**
  String get currentPasswordIncorrect;

  /// No description provided for @passwordMin12Chars.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 12 characters'**
  String get passwordMin12Chars;

  /// No description provided for @newPasswordSameAsOld.
  ///
  /// In en, this message translates to:
  /// **'New password must not be the same as the old one'**
  String get newPasswordSameAsOld;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChanged;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @loginAndRecovery.
  ///
  /// In en, this message translates to:
  /// **'Sign In and Recovery'**
  String get loginAndRecovery;

  /// No description provided for @forgotPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Reset password if you forgot'**
  String get forgotPasswordDesc;

  /// No description provided for @twoFactorAuth.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get twoFactorAuth;

  /// No description provided for @loginCodeMethod.
  ///
  /// In en, this message translates to:
  /// **'Login Code Method'**
  String get loginCodeMethod;

  /// No description provided for @loginCodeMethodDesc.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp, Backup Codes'**
  String get loginCodeMethodDesc;

  /// No description provided for @backupCodes.
  ///
  /// In en, this message translates to:
  /// **'Backup Codes'**
  String get backupCodes;

  /// No description provided for @backupCodesDesc.
  ///
  /// In en, this message translates to:
  /// **'Add backup codes from authenticator app'**
  String get backupCodesDesc;

  /// No description provided for @whatsappCodeMethodDesc.
  ///
  /// In en, this message translates to:
  /// **'Login code sent via WhatsApp'**
  String get whatsappCodeMethodDesc;

  /// No description provided for @additionalMethods.
  ///
  /// In en, this message translates to:
  /// **'Additional Methods'**
  String get additionalMethods;

  /// No description provided for @additionalMethodsDesc.
  ///
  /// In en, this message translates to:
  /// **'Login requests and backup codes'**
  String get additionalMethodsDesc;

  /// No description provided for @loginRequests.
  ///
  /// In en, this message translates to:
  /// **'Login/Sign Requests'**
  String get loginRequests;

  /// No description provided for @loginRequestsDesc.
  ///
  /// In en, this message translates to:
  /// **'Approve sign-in requests from another device'**
  String get loginRequestsDesc;

  /// No description provided for @authenticatorApp.
  ///
  /// In en, this message translates to:
  /// **'Authenticator App'**
  String get authenticatorApp;

  /// No description provided for @authenticatorAppDesc.
  ///
  /// In en, this message translates to:
  /// **'Get codes from apps like Duo Mobile or Google Authenticator'**
  String get authenticatorAppDesc;

  /// No description provided for @trustedDevices.
  ///
  /// In en, this message translates to:
  /// **'Trusted Devices'**
  String get trustedDevices;

  /// No description provided for @trustedDevicesDesc.
  ///
  /// In en, this message translates to:
  /// **'View authorized devices'**
  String get trustedDevicesDesc;

  /// No description provided for @thisDevice.
  ///
  /// In en, this message translates to:
  /// **'This Device'**
  String get thisDevice;

  /// No description provided for @currentDevice.
  ///
  /// In en, this message translates to:
  /// **'Current Device'**
  String get currentDevice;

  /// No description provided for @currentlyActive.
  ///
  /// In en, this message translates to:
  /// **'Currently Active'**
  String get currentlyActive;

  /// No description provided for @otherDeviceLogins.
  ///
  /// In en, this message translates to:
  /// **'Other Device Logins'**
  String get otherDeviceLogins;

  /// No description provided for @noOtherLogins.
  ///
  /// In en, this message translates to:
  /// **'No logins from other devices'**
  String get noOtherLogins;

  /// No description provided for @noSecurityEmails.
  ///
  /// In en, this message translates to:
  /// **'No security emails yet'**
  String get noSecurityEmails;

  /// No description provided for @securityAllSecured.
  ///
  /// In en, this message translates to:
  /// **'Your account is secure'**
  String get securityAllSecured;

  /// No description provided for @securityNeedsAttention.
  ///
  /// In en, this message translates to:
  /// **'Some items need attention'**
  String get securityNeedsAttention;

  /// No description provided for @securedItems.
  ///
  /// In en, this message translates to:
  /// **'secured'**
  String get securedItems;

  /// No description provided for @checkupPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get checkupPassword;

  /// No description provided for @checkupPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Your account password'**
  String get checkupPasswordDesc;

  /// No description provided for @checkupEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get checkupEmail;

  /// No description provided for @checkupEmailVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified on'**
  String get checkupEmailVerified;

  /// No description provided for @checkupEmailNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Not verified'**
  String get checkupEmailNotVerified;

  /// No description provided for @checkupWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get checkupWhatsapp;

  /// No description provided for @checkupWhatsappVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get checkupWhatsappVerified;

  /// No description provided for @checkupWhatsappNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Not verified'**
  String get checkupWhatsappNotVerified;

  /// No description provided for @checkupTwoFactor.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get checkupTwoFactor;

  /// No description provided for @checkupTwoFactorDesc.
  ///
  /// In en, this message translates to:
  /// **'Additional security layer'**
  String get checkupTwoFactorDesc;

  /// No description provided for @checkupTwoFactorNotEnabled.
  ///
  /// In en, this message translates to:
  /// **'Not enabled'**
  String get checkupTwoFactorNotEnabled;

  /// No description provided for @checkupIdentity.
  ///
  /// In en, this message translates to:
  /// **'Identity Verification'**
  String get checkupIdentity;

  /// No description provided for @checkupIdentityDesc.
  ///
  /// In en, this message translates to:
  /// **'Identity verification (KYC)'**
  String get checkupIdentityDesc;

  /// No description provided for @checkupIdentityVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified on'**
  String get checkupIdentityVerified;

  /// No description provided for @checkupIdentityNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Not verified'**
  String get checkupIdentityNotVerified;

  /// No description provided for @securityEmailPasswordChange.
  ///
  /// In en, this message translates to:
  /// **'Account Password Changed'**
  String get securityEmailPasswordChange;

  /// No description provided for @securityEmailPasswordChangeBody.
  ///
  /// In en, this message translates to:
  /// **'Your account password was changed on'**
  String get securityEmailPasswordChangeBody;

  /// No description provided for @securityEmailEmailChange.
  ///
  /// In en, this message translates to:
  /// **'Account Email Changed'**
  String get securityEmailEmailChange;

  /// No description provided for @securityEmailEmailChangeBody.
  ///
  /// In en, this message translates to:
  /// **'Your account email was changed on'**
  String get securityEmailEmailChangeBody;

  /// No description provided for @securityEmailLoginAlert.
  ///
  /// In en, this message translates to:
  /// **'Account Login Alert'**
  String get securityEmailLoginAlert;

  /// No description provided for @securityEmailLoginAlertBody.
  ///
  /// In en, this message translates to:
  /// **'Login activity detected on'**
  String get securityEmailLoginAlertBody;

  /// No description provided for @securityEmailWhatsappChange.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp Number Changed'**
  String get securityEmailWhatsappChange;

  /// No description provided for @securityEmailWhatsappChangeBody.
  ///
  /// In en, this message translates to:
  /// **'Your WhatsApp number was changed on'**
  String get securityEmailWhatsappChangeBody;

  /// No description provided for @securityEmailAccountUpdate.
  ///
  /// In en, this message translates to:
  /// **'Account Updated'**
  String get securityEmailAccountUpdate;

  /// No description provided for @securityEmailAccountUpdateBody.
  ///
  /// In en, this message translates to:
  /// **'Your account was updated on'**
  String get securityEmailAccountUpdateBody;

  /// No description provided for @authorizedLogins.
  ///
  /// In en, this message translates to:
  /// **'Authorized Logins'**
  String get authorizedLogins;

  /// No description provided for @authorizedLoginsDesc.
  ///
  /// In en, this message translates to:
  /// **'Trusted devices'**
  String get authorizedLoginsDesc;

  /// No description provided for @savedLogins.
  ///
  /// In en, this message translates to:
  /// **'Saved Logins'**
  String get savedLogins;

  /// No description provided for @savedLoginInfo.
  ///
  /// In en, this message translates to:
  /// **'Saved Logins'**
  String get savedLoginInfo;

  /// No description provided for @savedLoginInfoDesc.
  ///
  /// In en, this message translates to:
  /// **'Enable saving login on this device'**
  String get savedLoginInfoDesc;

  /// No description provided for @savedLoginInfoDescShort.
  ///
  /// In en, this message translates to:
  /// **'Manage sign-in info saved on this device.'**
  String get savedLoginInfoDescShort;

  /// No description provided for @savedLoginDevices.
  ///
  /// In en, this message translates to:
  /// **'Devices Saving Sign-In Info'**
  String get savedLoginDevices;

  /// No description provided for @savedLoginDevicesDesc.
  ///
  /// In en, this message translates to:
  /// **'View and remove devices that store your account\'s sign-in info.'**
  String get savedLoginDevicesDesc;

  /// No description provided for @securityCheck.
  ///
  /// In en, this message translates to:
  /// **'Security Check'**
  String get securityCheck;

  /// No description provided for @whereYouLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Where You Signed In'**
  String get whereYouLoggedIn;

  /// No description provided for @whereYouLoggedInDesc.
  ///
  /// In en, this message translates to:
  /// **'Review and end active device sessions.'**
  String get whereYouLoggedInDesc;

  /// No description provided for @recentEmails.
  ///
  /// In en, this message translates to:
  /// **'Change Email'**
  String get recentEmails;

  /// No description provided for @recentEmailsDesc.
  ///
  /// In en, this message translates to:
  /// **'Change your account email with OTP verification.'**
  String get recentEmailsDesc;

  /// No description provided for @securityCheckup.
  ///
  /// In en, this message translates to:
  /// **'Security Checkup'**
  String get securityCheckup;

  /// No description provided for @securityCheckupDesc.
  ///
  /// In en, this message translates to:
  /// **'Review important protections for your account.'**
  String get securityCheckupDesc;

  /// No description provided for @logoutOtherDevices.
  ///
  /// In en, this message translates to:
  /// **'Log out from other devices'**
  String get logoutOtherDevices;

  /// No description provided for @logoutOtherDevicesDesc.
  ///
  /// In en, this message translates to:
  /// **'Select this if someone else is using your account'**
  String get logoutOtherDevicesDesc;

  /// No description provided for @otherDevicesLoggedOut.
  ///
  /// In en, this message translates to:
  /// **'other devices logged out.'**
  String get otherDevicesLoggedOut;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get sortNewest;

  /// No description provided for @sortOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest'**
  String get sortOldest;

  /// No description provided for @sortHighest.
  ///
  /// In en, this message translates to:
  /// **'Highest Rating'**
  String get sortHighest;

  /// No description provided for @sortLowest.
  ///
  /// In en, this message translates to:
  /// **'Lowest Rating'**
  String get sortLowest;

  /// No description provided for @sortMostHelpful.
  ///
  /// In en, this message translates to:
  /// **'Most Helpful'**
  String get sortMostHelpful;

  /// No description provided for @helpful.
  ///
  /// In en, this message translates to:
  /// **'Helpful'**
  String get helpful;

  /// No description provided for @replyToReview.
  ///
  /// In en, this message translates to:
  /// **'Reply to Review'**
  String get replyToReview;

  /// No description provided for @writeReply.
  ///
  /// In en, this message translates to:
  /// **'Write a reply...'**
  String get writeReply;

  /// No description provided for @replySent.
  ///
  /// In en, this message translates to:
  /// **'Reply sent successfully'**
  String get replySent;

  /// No description provided for @ratingSummary.
  ///
  /// In en, this message translates to:
  /// **'Rating Summary'**
  String get ratingSummary;

  /// No description provided for @withPhoto.
  ///
  /// In en, this message translates to:
  /// **'With Photo'**
  String get withPhoto;

  /// No description provided for @enableTwoFactor.
  ///
  /// In en, this message translates to:
  /// **'Enable Two-Factor Authentication'**
  String get enableTwoFactor;

  /// No description provided for @twoFactorEnabledDesc.
  ///
  /// In en, this message translates to:
  /// **'Additional security layer is active'**
  String get twoFactorEnabledDesc;

  /// No description provided for @twoFactorDisabledDesc.
  ///
  /// In en, this message translates to:
  /// **'Add an extra layer of security to your account'**
  String get twoFactorDisabledDesc;

  /// No description provided for @twoFactorEnabled.
  ///
  /// In en, this message translates to:
  /// **'Two-factor authentication enabled'**
  String get twoFactorEnabled;

  /// No description provided for @twoFactorDisabled.
  ///
  /// In en, this message translates to:
  /// **'Two-factor authentication disabled'**
  String get twoFactorDisabled;

  /// No description provided for @whatsappRequired2FA.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp number is required to enable 2FA'**
  String get whatsappRequired2FA;

  /// No description provided for @noNumberLinked.
  ///
  /// In en, this message translates to:
  /// **'No WhatsApp number linked'**
  String get noNumberLinked;

  /// No description provided for @backupCodesRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count} backup codes remaining'**
  String backupCodesRemaining(Object count);

  /// No description provided for @noBackupCodes.
  ///
  /// In en, this message translates to:
  /// **'No backup codes generated'**
  String get noBackupCodes;

  /// No description provided for @generateBackupCodesConfirm.
  ///
  /// In en, this message translates to:
  /// **'Generate new backup codes? Previous codes will be invalidated.'**
  String get generateBackupCodesConfirm;

  /// No description provided for @generate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @allCodesCopied.
  ///
  /// In en, this message translates to:
  /// **'All codes copied'**
  String get allCodesCopied;

  /// No description provided for @copyAllCodes.
  ///
  /// In en, this message translates to:
  /// **'Copy All Codes'**
  String get copyAllCodes;

  /// No description provided for @backupCodesWarning.
  ///
  /// In en, this message translates to:
  /// **'Save these codes in a safe place. Each code can only be used once.'**
  String get backupCodesWarning;

  /// No description provided for @trustedDevicesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} trusted device(s)'**
  String trustedDevicesCount(Object count);

  /// No description provided for @noTrustedDevices.
  ///
  /// In en, this message translates to:
  /// **'No trusted devices'**
  String get noTrustedDevices;

  /// No description provided for @trustedSince.
  ///
  /// In en, this message translates to:
  /// **'Trusted since'**
  String get trustedSince;

  /// No description provided for @removeTrustedDevice.
  ///
  /// In en, this message translates to:
  /// **'Remove Trusted Device'**
  String get removeTrustedDevice;

  /// No description provided for @removeTrustedDeviceConfirm.
  ///
  /// In en, this message translates to:
  /// **'This device will no longer be trusted for login verification.'**
  String get removeTrustedDeviceConfirm;

  /// No description provided for @deviceRemoved.
  ///
  /// In en, this message translates to:
  /// **'Device removed'**
  String get deviceRemoved;

  /// No description provided for @newDeviceQuestion.
  ///
  /// In en, this message translates to:
  /// **'New device — Is this you?'**
  String get newDeviceQuestion;

  /// No description provided for @yesItWasMe.
  ///
  /// In en, this message translates to:
  /// **'Yes, it was me'**
  String get yesItWasMe;

  /// No description provided for @noItWasNotMe.
  ///
  /// In en, this message translates to:
  /// **'No, it wasn\'t me'**
  String get noItWasNotMe;

  /// No description provided for @firstUsed.
  ///
  /// In en, this message translates to:
  /// **'First used:'**
  String get firstUsed;

  /// No description provided for @deviceTrustedMsg.
  ///
  /// In en, this message translates to:
  /// **'Device confirmed. It won\'t be flagged again.'**
  String get deviceTrustedMsg;

  /// No description provided for @deviceRejectedMsg.
  ///
  /// In en, this message translates to:
  /// **'Signed out from all other sessions. Change your password now.'**
  String get deviceRejectedMsg;

  /// No description provided for @removeDevice.
  ///
  /// In en, this message translates to:
  /// **'Remove Device'**
  String get removeDevice;

  /// No description provided for @removeDeviceConfirm.
  ///
  /// In en, this message translates to:
  /// **'This device will be logged out and removed from your account.'**
  String get removeDeviceConfirm;

  /// No description provided for @sessionRemoved.
  ///
  /// In en, this message translates to:
  /// **'Session removed'**
  String get sessionRemoved;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @noSessionData.
  ///
  /// In en, this message translates to:
  /// **'No session data available'**
  String get noSessionData;

  /// No description provided for @savedLoginInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved Login Info'**
  String get savedLoginInfoTitle;

  /// No description provided for @savedLoginOn.
  ///
  /// In en, this message translates to:
  /// **'Your login info is saved on this device'**
  String get savedLoginOn;

  /// No description provided for @savedLoginOff.
  ///
  /// In en, this message translates to:
  /// **'Login info is not saved'**
  String get savedLoginOff;

  /// No description provided for @savedLoginEnabled.
  ///
  /// In en, this message translates to:
  /// **'Login info saving enabled'**
  String get savedLoginEnabled;

  /// No description provided for @savedLoginDisabled.
  ///
  /// In en, this message translates to:
  /// **'Login info saving disabled'**
  String get savedLoginDisabled;

  /// No description provided for @saveLoginInfo.
  ///
  /// In en, this message translates to:
  /// **'Save Login Info'**
  String get saveLoginInfo;

  /// No description provided for @twoFactorAuthDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage WhatsApp, backup codes, and trusted devices.'**
  String get twoFactorAuthDesc;

  /// No description provided for @twoFactorPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage additional verification methods, the authenticator app, and trusted devices in one place.'**
  String get twoFactorPageSubtitle;

  /// No description provided for @savedLoginPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage devices that store your account sign-in info.'**
  String get savedLoginPageSubtitle;

  /// No description provided for @signInActivityPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review and end active device sessions.'**
  String get signInActivityPageSubtitle;

  /// No description provided for @changePasswordPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use a strong password to keep your account secure.'**
  String get changePasswordPageSubtitle;

  /// No description provided for @changeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change Email'**
  String get changeEmail;

  /// No description provided for @changeEmailDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter your new email, then verify the OTP code sent to it.'**
  String get changeEmailDesc;

  /// No description provided for @currentEmail.
  ///
  /// In en, this message translates to:
  /// **'Current Email'**
  String get currentEmail;

  /// No description provided for @currentEmailDesc.
  ///
  /// In en, this message translates to:
  /// **'The email currently linked to your account.'**
  String get currentEmailDesc;

  /// No description provided for @newEmail.
  ///
  /// In en, this message translates to:
  /// **'New Email'**
  String get newEmail;

  /// No description provided for @confirmNewEmail.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Email'**
  String get confirmNewEmail;

  /// No description provided for @confirmNewEmailDesc.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your new email to make sure there are no typos.'**
  String get confirmNewEmailDesc;

  /// No description provided for @sendEmailOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP Code'**
  String get sendEmailOtp;

  /// No description provided for @verifyEmailOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyEmailOtp;

  /// No description provided for @resendEmailOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendEmailOtp;

  /// No description provided for @emailOtpSent.
  ///
  /// In en, this message translates to:
  /// **'The OTP code has been sent to your new email.'**
  String get emailOtpSent;

  /// No description provided for @emailOtpInvalid.
  ///
  /// In en, this message translates to:
  /// **'The OTP code is invalid or has expired.'**
  String get emailOtpInvalid;

  /// No description provided for @emailChangedVerified.
  ///
  /// In en, this message translates to:
  /// **'Email successfully changed and verified.'**
  String get emailChangedVerified;

  /// No description provided for @emailOtpFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send the OTP code. Check your email settings and try again.'**
  String get emailOtpFailed;

  /// No description provided for @otpCode.
  ///
  /// In en, this message translates to:
  /// **'OTP Code'**
  String get otpCode;

  /// No description provided for @removeAll.
  ///
  /// In en, this message translates to:
  /// **'Remove All'**
  String get removeAll;

  /// No description provided for @removeAllTrustedDevices.
  ///
  /// In en, this message translates to:
  /// **'Remove All Devices'**
  String get removeAllTrustedDevices;

  /// No description provided for @removeAllTrustedDevicesConfirm.
  ///
  /// In en, this message translates to:
  /// **'All trusted devices will be removed and must be verified again.'**
  String get removeAllTrustedDevicesConfirm;

  /// No description provided for @allDevicesRemoved.
  ///
  /// In en, this message translates to:
  /// **'All trusted devices removed'**
  String get allDevicesRemoved;

  /// No description provided for @logoutAllOtherSessions.
  ///
  /// In en, this message translates to:
  /// **'Sign Out All Other Sessions'**
  String get logoutAllOtherSessions;

  /// No description provided for @logoutAllOtherSessionsConfirm.
  ///
  /// In en, this message translates to:
  /// **'All other device sessions will be signed out. Those devices must sign in again.'**
  String get logoutAllOtherSessionsConfirm;

  /// No description provided for @logoutAllOtherSessionsPasswordConfirm.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password to confirm that you want to sign out of other browser sessions on all your devices.'**
  String get logoutAllOtherSessionsPasswordConfirm;

  /// No description provided for @allSessionsRemoved.
  ///
  /// In en, this message translates to:
  /// **'All other device sessions signed out'**
  String get allSessionsRemoved;

  /// No description provided for @recentEmailsListTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent Emails'**
  String get recentEmailsListTitle;

  /// No description provided for @recentEmailsListDesc.
  ///
  /// In en, this message translates to:
  /// **'Showing emails from the last 30 days only.'**
  String get recentEmailsListDesc;

  /// No description provided for @emailCategorySecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get emailCategorySecurity;

  /// No description provided for @emailCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get emailCategoryOther;

  /// No description provided for @noEmailsInPeriod.
  ///
  /// In en, this message translates to:
  /// **'No emails in this period.'**
  String get noEmailsInPeriod;

  /// No description provided for @twoFactorSetupEnabled.
  ///
  /// In en, this message translates to:
  /// **'Two-factor authentication is now active'**
  String get twoFactorSetupEnabled;

  /// No description provided for @twoFactorSetupOtpResent.
  ///
  /// In en, this message translates to:
  /// **'A new OTP code has been sent.'**
  String get twoFactorSetupOtpResent;

  /// No description provided for @twoFactorSetupEmailDesc.
  ///
  /// In en, this message translates to:
  /// **'A 6-digit code is emailed to you on every sign-in.'**
  String get twoFactorSetupEmailDesc;

  /// No description provided for @twoFactorSetupAuthenticatorDesc.
  ///
  /// In en, this message translates to:
  /// **'A 6-digit code from an app like Google Authenticator or Duo Mobile.'**
  String get twoFactorSetupAuthenticatorDesc;

  /// No description provided for @twoFactorSetupNone.
  ///
  /// In en, this message translates to:
  /// **'Don\'t use 2FA'**
  String get twoFactorSetupNone;

  /// No description provided for @twoFactorSetupNoneDesc.
  ///
  /// In en, this message translates to:
  /// **'Turn off two-step verification for this account.'**
  String get twoFactorSetupNoneDesc;

  /// No description provided for @twoFactorSetupAlreadyUsed.
  ///
  /// In en, this message translates to:
  /// **'Already used by this account -- can\'t be selected again.'**
  String get twoFactorSetupAlreadyUsed;

  /// No description provided for @twoFactorSetupManualSecret.
  ///
  /// In en, this message translates to:
  /// **'Manual code (if the QR can\'t be scanned)'**
  String get twoFactorSetupManualSecret;

  /// No description provided for @copySecret.
  ///
  /// In en, this message translates to:
  /// **'Copy code'**
  String get copySecret;

  /// No description provided for @twoFactorAuthTitle.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get twoFactorAuthTitle;

  /// No description provided for @twoFactorAuthHeading.
  ///
  /// In en, this message translates to:
  /// **'Enable Authenticator App'**
  String get twoFactorAuthHeading;

  /// No description provided for @twoFactorAuthSubheading.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code with an app like Google Authenticator or Duo Mobile, then enter the 6-digit code to make sure everything is correct.'**
  String get twoFactorAuthSubheading;

  /// No description provided for @twoFactorSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Activate Two-Factor Authentication'**
  String get twoFactorSetupTitle;

  /// No description provided for @twoFactorSetupHeading.
  ///
  /// In en, this message translates to:
  /// **'Add Two-Factor Authentication'**
  String get twoFactorSetupHeading;

  /// No description provided for @twoFactorSetupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a second step when you sign in. Your login code is sent to your WhatsApp number, and you can also create one-time backup codes.'**
  String get twoFactorSetupSubtitle;

  /// No description provided for @twoFactorNeedCode.
  ///
  /// In en, this message translates to:
  /// **'Enter a code to continue'**
  String get twoFactorNeedCode;

  /// No description provided for @twoFactorActiveMethod.
  ///
  /// In en, this message translates to:
  /// **'Active Verification Method'**
  String get twoFactorActiveMethod;

  /// No description provided for @notActive.
  ///
  /// In en, this message translates to:
  /// **'Not active'**
  String get notActive;

  /// No description provided for @strengthenAccount.
  ///
  /// In en, this message translates to:
  /// **'Strengthen Your Account'**
  String get strengthenAccount;

  /// No description provided for @strengthenAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'With two-step verification, your account stays protected even if your password leaks.'**
  String get strengthenAccountSubtitle;

  /// No description provided for @strengthenAccountSkip.
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get strengthenAccountSkip;

  /// No description provided for @strengthenAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, Strengthen My Account'**
  String get strengthenAccountConfirm;

  /// No description provided for @strengthenAccountLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get strengthenAccountLater;

  /// No description provided for @twoFactorVerifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get twoFactorVerifyTitle;

  /// No description provided for @twoFactorRecoveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Recovery'**
  String get twoFactorRecoveryTitle;

  /// No description provided for @twoFactorAuthenticatorHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the code from your authenticator app below.'**
  String get twoFactorAuthenticatorHint;

  /// No description provided for @twoFactorEmailHint.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to your email. Enter it below.'**
  String get twoFactorEmailHint;

  /// No description provided for @twoFactorRecoveryHint.
  ///
  /// In en, this message translates to:
  /// **'If you cannot access your device or receive an authentication code, enter one of your recovery codes to verify your identity.'**
  String get twoFactorRecoveryHint;

  /// No description provided for @twoFactorCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'OTP Code'**
  String get twoFactorCodeLabel;

  /// No description provided for @twoFactorRecoveryCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Recovery Code'**
  String get twoFactorRecoveryCodeLabel;

  /// No description provided for @twoFactorOtherOptions.
  ///
  /// In en, this message translates to:
  /// **'Other options'**
  String get twoFactorOtherOptions;

  /// No description provided for @twoFactorMethodEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get twoFactorMethodEmail;

  /// No description provided for @twoFactorMethodAuthenticator.
  ///
  /// In en, this message translates to:
  /// **'Authenticator App'**
  String get twoFactorMethodAuthenticator;

  /// No description provided for @twoFactorMethodRecovery.
  ///
  /// In en, this message translates to:
  /// **'Recovery Code'**
  String get twoFactorMethodRecovery;

  /// No description provided for @twoFactorResendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get twoFactorResendCode;

  /// No description provided for @manageAuthenticatorApp.
  ///
  /// In en, this message translates to:
  /// **'Manage Authenticator App'**
  String get manageAuthenticatorApp;

  /// No description provided for @addAuthenticatorApp.
  ///
  /// In en, this message translates to:
  /// **'Add Authenticator App'**
  String get addAuthenticatorApp;

  /// No description provided for @authenticatorAppActiveDesc.
  ///
  /// In en, this message translates to:
  /// **'Authenticator app is active. A 6-digit code will be requested on every sign-in.'**
  String get authenticatorAppActiveDesc;

  /// No description provided for @authenticatorAppInactiveDesc.
  ///
  /// In en, this message translates to:
  /// **'Not active yet. Once enabled, a 6-digit code will be requested on every sign-in.'**
  String get authenticatorAppInactiveDesc;

  /// No description provided for @twoFactorWrongCode.
  ///
  /// In en, this message translates to:
  /// **'Wrong code'**
  String get twoFactorWrongCode;

  /// No description provided for @twoFactorWrongCodeBody.
  ///
  /// In en, this message translates to:
  /// **'The code you entered does not match or has expired.'**
  String get twoFactorWrongCodeBody;

  /// No description provided for @twoFactorSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'The verification session has expired. Please sign in again.'**
  String get twoFactorSessionExpired;

  /// No description provided for @twoFactorRequiredDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter your verification code to continue.'**
  String get twoFactorRequiredDesc;

  /// No description provided for @twoFactorSetupDone.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get twoFactorSetupDone;

  /// No description provided for @twoFactorAlreadySetUp.
  ///
  /// In en, this message translates to:
  /// **'Two-factor authentication is already active on this account.'**
  String get twoFactorAlreadySetUp;

  /// No description provided for @reviewStar1.
  ///
  /// In en, this message translates to:
  /// **'Terrible'**
  String get reviewStar1;

  /// No description provided for @reviewStar2.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get reviewStar2;

  /// No description provided for @reviewStar3.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get reviewStar3;

  /// No description provided for @reviewStar4.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get reviewStar4;

  /// No description provided for @reviewStar5.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get reviewStar5;

  /// No description provided for @reviewTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Review title (optional)'**
  String get reviewTitleHint;

  /// No description provided for @catalogRatingComments.
  ///
  /// In en, this message translates to:
  /// **'Catalog Ratings & Comments'**
  String get catalogRatingComments;

  /// No description provided for @ratingWithoutComment.
  ///
  /// In en, this message translates to:
  /// **'This customer rated the product but left no comment'**
  String get ratingWithoutComment;

  /// No description provided for @verifiedPurchase.
  ///
  /// In en, this message translates to:
  /// **'Verified Purchase'**
  String get verifiedPurchase;

  /// No description provided for @anonymous.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get anonymous;

  /// No description provided for @withComment.
  ///
  /// In en, this message translates to:
  /// **'With Comment'**
  String get withComment;

  /// No description provided for @storeReply.
  ///
  /// In en, this message translates to:
  /// **'Store Reply'**
  String get storeReply;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @reportItem.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get reportItem;

  /// No description provided for @reportDesc.
  ///
  /// In en, this message translates to:
  /// **'Report this item to our team'**
  String get reportDesc;

  /// No description provided for @reportTitle.
  ///
  /// In en, this message translates to:
  /// **'Report {name}'**
  String reportTitle(String name);

  /// No description provided for @reportChatIntro.
  ///
  /// In en, this message translates to:
  /// **'I would like to report this:\nType: {category}\nItem: {item}'**
  String reportChatIntro(String category, String item);

  /// No description provided for @reportChatPrompt.
  ///
  /// In en, this message translates to:
  /// **'\n\nPlease help me with this report, thank you.'**
  String get reportChatPrompt;

  /// No description provided for @reportCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get reportCategory;

  /// No description provided for @reportReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reportReason;

  /// No description provided for @reportReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Select a reason'**
  String get reportReasonHint;

  /// No description provided for @reportDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get reportDescription;

  /// No description provided for @reportDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Tell us more details (optional)'**
  String get reportDescriptionHint;

  /// No description provided for @reportSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit Report'**
  String get reportSubmit;

  /// No description provided for @reportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Report submitted successfully. Our team will review it.'**
  String get reportSuccess;

  /// No description provided for @reportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit report'**
  String get reportFailed;

  /// No description provided for @reportGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get reportGeneral;

  /// No description provided for @reportCatalog.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get reportCatalog;

  /// No description provided for @reportPackage.
  ///
  /// In en, this message translates to:
  /// **'Package'**
  String get reportPackage;

  /// No description provided for @reportOrder.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get reportOrder;

  /// No description provided for @reportReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get reportReview;

  /// No description provided for @reportReasonSpam.
  ///
  /// In en, this message translates to:
  /// **'Spam'**
  String get reportReasonSpam;

  /// No description provided for @reportReasonFraud.
  ///
  /// In en, this message translates to:
  /// **'Fraud or scam'**
  String get reportReasonFraud;

  /// No description provided for @reportReasonInappropriate.
  ///
  /// In en, this message translates to:
  /// **'Inappropriate content'**
  String get reportReasonInappropriate;

  /// No description provided for @reportReasonMisleading.
  ///
  /// In en, this message translates to:
  /// **'Misleading information'**
  String get reportReasonMisleading;

  /// No description provided for @reportReasonCopyright.
  ///
  /// In en, this message translates to:
  /// **'Copyright violation'**
  String get reportReasonCopyright;

  /// No description provided for @reportReasonOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get reportReasonOther;

  /// No description provided for @reportRequiresReason.
  ///
  /// In en, this message translates to:
  /// **'Please select a reason'**
  String get reportRequiresReason;

  /// No description provided for @reportContentTitle.
  ///
  /// In en, this message translates to:
  /// **'Reported Content'**
  String get reportContentTitle;

  /// No description provided for @csRecoveryDetected.
  ///
  /// In en, this message translates to:
  /// **'It looks like you need account help. Please fill in the verification form below so we can assist you:'**
  String get csRecoveryDetected;

  /// No description provided for @csFormDetected.
  ///
  /// In en, this message translates to:
  /// **'Thank you! We detected your verification form. Sending OTP to your email...'**
  String get csFormDetected;

  /// No description provided for @csOtpSentToEmailChat.
  ///
  /// In en, this message translates to:
  /// **'A 6-digit OTP code has been sent to {email}. Please enter it below.'**
  String csOtpSentToEmailChat(String email);

  /// No description provided for @csPasswordChangedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password has been changed successfully! Please login with your new password.'**
  String get csPasswordChangedSuccess;

  /// No description provided for @csPasswordChangeFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to change password. Please try again.'**
  String get csPasswordChangeFailed;

  /// No description provided for @csPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 12 characters'**
  String get csPasswordMinLength;

  /// No description provided for @csPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get csPasswordsDoNotMatch;

  /// No description provided for @csInvalidOtp.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP code. Please try again.'**
  String get csInvalidOtp;

  /// No description provided for @csResetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get csResetPasswordTitle;

  /// No description provided for @csNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get csNewPasswordHint;

  /// No description provided for @csConfirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your new password'**
  String get csConfirmPasswordHint;

  /// No description provided for @csResendOtpIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String csResendOtpIn(int seconds);

  /// No description provided for @csOtpResentToEmail.
  ///
  /// In en, this message translates to:
  /// **'A new OTP code has been sent to {email}'**
  String csOtpResentToEmail(String email);

  /// No description provided for @csEnterOtpToReset.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to your email to reset your password'**
  String get csEnterOtpToReset;

  /// No description provided for @csResettingPassword.
  ///
  /// In en, this message translates to:
  /// **'Resetting password...'**
  String get csResettingPassword;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCache;

  /// No description provided for @cacheSize.
  ///
  /// In en, this message translates to:
  /// **'Cache size'**
  String get cacheSize;

  /// No description provided for @clearCacheDesc.
  ///
  /// In en, this message translates to:
  /// **'Remove temporary files and cached images to free up storage'**
  String get clearCacheDesc;

  /// No description provided for @clearCacheConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear the app cache?'**
  String get clearCacheConfirm;

  /// No description provided for @cacheCleared.
  ///
  /// In en, this message translates to:
  /// **'Cache cleared successfully'**
  String get cacheCleared;

  /// No description provided for @cacheClearedBytes.
  ///
  /// In en, this message translates to:
  /// **'Cache cleared: {size} freed'**
  String cacheClearedBytes(String size);

  /// No description provided for @calendarSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get calendarSelectDate;

  /// No description provided for @calendarSelectMonth.
  ///
  /// In en, this message translates to:
  /// **'Select Month'**
  String get calendarSelectMonth;

  /// No description provided for @calendarSelectYear.
  ///
  /// In en, this message translates to:
  /// **'Select Year'**
  String get calendarSelectYear;

  /// No description provided for @calendarSelectTime.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get calendarSelectTime;

  /// No description provided for @calendarHour.
  ///
  /// In en, this message translates to:
  /// **'Hour'**
  String get calendarHour;

  /// No description provided for @calendarMinute.
  ///
  /// In en, this message translates to:
  /// **'Minute'**
  String get calendarMinute;

  /// No description provided for @calendarHourMinute.
  ///
  /// In en, this message translates to:
  /// **'Hour : Minute'**
  String get calendarHourMinute;

  /// No description provided for @calendarSearch.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get calendarSearch;

  /// No description provided for @calendarNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get calendarNoResults;

  /// No description provided for @mediaServerNote.
  ///
  /// In en, this message translates to:
  /// **'All media will remain on the server and can be downloaded again if needed.'**
  String get mediaServerNote;

  /// No description provided for @outgoing.
  ///
  /// In en, this message translates to:
  /// **'Outgoing'**
  String get outgoing;

  /// No description provided for @network.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get network;

  /// No description provided for @proxyWarning.
  ///
  /// In en, this message translates to:
  /// **'Only use a proxy if you cannot connect. Your IP address may be visible to the proxy provider.'**
  String get proxyWarning;

  /// No description provided for @addProxyServer.
  ///
  /// In en, this message translates to:
  /// **'Add a server to enable proxy'**
  String get addProxyServer;

  /// No description provided for @autoDownloadQuality.
  ///
  /// In en, this message translates to:
  /// **'Automatic download quality'**
  String get autoDownloadQuality;

  /// No description provided for @uploadQuality.
  ///
  /// In en, this message translates to:
  /// **'Upload quality'**
  String get uploadQuality;

  /// No description provided for @chooseMediaQuality.
  ///
  /// In en, this message translates to:
  /// **'Choose the quality of photos and videos sent to or automatically downloaded in chats.'**
  String get chooseMediaQuality;

  /// No description provided for @voiceMessagesAuto.
  ///
  /// In en, this message translates to:
  /// **'Voice messages are always downloaded automatically.'**
  String get voiceMessagesAuto;

  /// No description provided for @reduceCallData.
  ///
  /// In en, this message translates to:
  /// **'Use less data for calls'**
  String get reduceCallData;

  /// No description provided for @chatMedia.
  ///
  /// In en, this message translates to:
  /// **'Chat media'**
  String get chatMedia;

  /// No description provided for @resetAutoDownload.
  ///
  /// In en, this message translates to:
  /// **'Reset automatic download settings'**
  String get resetAutoDownload;

  /// No description provided for @wifi.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi'**
  String get wifi;

  /// No description provided for @never.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get never;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @mediaQuality.
  ///
  /// In en, this message translates to:
  /// **'Media quality'**
  String get mediaQuality;

  /// No description provided for @received.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get received;

  /// No description provided for @standard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get standard;

  /// No description provided for @incoming.
  ///
  /// In en, this message translates to:
  /// **'Incoming'**
  String get incoming;

  /// No description provided for @noCache.
  ///
  /// In en, this message translates to:
  /// **'No cache'**
  String get noCache;

  /// No description provided for @proxyHostPort.
  ///
  /// In en, this message translates to:
  /// **'host:port'**
  String get proxyHostPort;

  /// No description provided for @receivedBytes.
  ///
  /// In en, this message translates to:
  /// **'Bytes received'**
  String get receivedBytes;

  /// No description provided for @hdQualityDescription.
  ///
  /// In en, this message translates to:
  /// **'Slower to send, file may be up to 6 times larger'**
  String get hdQualityDescription;

  /// No description provided for @resetLast.
  ///
  /// In en, this message translates to:
  /// **'Last reset: {date}'**
  String resetLast(Object date);

  /// No description provided for @hd.
  ///
  /// In en, this message translates to:
  /// **'HD'**
  String get hd;

  /// No description provided for @automaticMediaDownload.
  ///
  /// In en, this message translates to:
  /// **'Automatic media download'**
  String get automaticMediaDownload;

  /// No description provided for @storage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storage;

  /// No description provided for @storageAndData.
  ///
  /// In en, this message translates to:
  /// **'Storage and data'**
  String get storageAndData;

  /// No description provided for @noProxyServer.
  ///
  /// In en, this message translates to:
  /// **'No proxy server'**
  String get noProxyServer;

  /// No description provided for @proxy.
  ///
  /// In en, this message translates to:
  /// **'Proxy'**
  String get proxy;

  /// No description provided for @standardQualityDescription.
  ///
  /// In en, this message translates to:
  /// **'Faster to send, smaller file size'**
  String get standardQualityDescription;

  /// No description provided for @storageUsage.
  ///
  /// In en, this message translates to:
  /// **'Storage usage'**
  String get storageUsage;

  /// No description provided for @statusMedia.
  ///
  /// In en, this message translates to:
  /// **'Status media'**
  String get statusMedia;

  /// No description provided for @disconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// No description provided for @sentBytes.
  ///
  /// In en, this message translates to:
  /// **'Bytes sent'**
  String get sentBytes;

  /// No description provided for @proxyServer.
  ///
  /// In en, this message translates to:
  /// **'Proxy server'**
  String get proxyServer;

  /// No description provided for @totalTime.
  ///
  /// In en, this message translates to:
  /// **'Total time'**
  String get totalTime;

  /// No description provided for @networkUsage.
  ///
  /// In en, this message translates to:
  /// **'Network usage'**
  String get networkUsage;

  /// No description provided for @calls.
  ///
  /// In en, this message translates to:
  /// **'Calls'**
  String get calls;

  /// No description provided for @wifiAndCellular.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi and cellular'**
  String get wifiAndCellular;

  /// No description provided for @clearAllCache.
  ///
  /// In en, this message translates to:
  /// **'Clear all cache'**
  String get clearAllCache;

  /// No description provided for @clearSomeStorage.
  ///
  /// In en, this message translates to:
  /// **'Clear some storage'**
  String get clearSomeStorage;

  /// No description provided for @deleteServer.
  ///
  /// In en, this message translates to:
  /// **'Delete server'**
  String get deleteServer;

  /// No description provided for @quality.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get quality;

  /// No description provided for @resetStatistics.
  ///
  /// In en, this message translates to:
  /// **'Reset statistics'**
  String get resetStatistics;

  /// No description provided for @useProxy.
  ///
  /// In en, this message translates to:
  /// **'Use proxy'**
  String get useProxy;

  /// No description provided for @totalBytes.
  ///
  /// In en, this message translates to:
  /// **'Total bytes'**
  String get totalBytes;

  /// No description provided for @appLockPassword.
  ///
  /// In en, this message translates to:
  /// **'App lock password'**
  String get appLockPassword;

  /// No description provided for @disablePassword.
  ///
  /// In en, this message translates to:
  /// **'Disable password'**
  String get disablePassword;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password'**
  String get wrongPassword;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @usePasswordToUnlock.
  ///
  /// In en, this message translates to:
  /// **'Use a password to unlock the app'**
  String get usePasswordToUnlock;

  /// No description provided for @startupTitle.
  ///
  /// In en, this message translates to:
  /// **'Please wait'**
  String get startupTitle;

  /// No description provided for @startupPreparingData.
  ///
  /// In en, this message translates to:
  /// **'Preparing app data...'**
  String get startupPreparingData;

  /// No description provided for @startupDownloadingData.
  ///
  /// In en, this message translates to:
  /// **'Downloading the latest data...'**
  String get startupDownloadingData;

  /// No description provided for @startupReady.
  ///
  /// In en, this message translates to:
  /// **'Optimizing data...'**
  String get startupReady;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @catalogDetail.
  ///
  /// In en, this message translates to:
  /// **'Catalog detail'**
  String get catalogDetail;

  /// No description provided for @flowerDecorationsCatalog.
  ///
  /// In en, this message translates to:
  /// **'Flower Decorations Catalog'**
  String get flowerDecorationsCatalog;

  /// No description provided for @editOrder.
  ///
  /// In en, this message translates to:
  /// **'Edit Order'**
  String get editOrder;

  /// No description provided for @orderUpdated.
  ///
  /// In en, this message translates to:
  /// **'Order updated'**
  String get orderUpdated;

  /// No description provided for @failedUpdateOrder.
  ///
  /// In en, this message translates to:
  /// **'Failed to update order'**
  String get failedUpdateOrder;

  /// No description provided for @confirmDeleteOrder.
  ///
  /// In en, this message translates to:
  /// **'Delete this order? It will be removed from your history.'**
  String get confirmDeleteOrder;

  /// No description provided for @orderDeleted.
  ///
  /// In en, this message translates to:
  /// **'Order deleted'**
  String get orderDeleted;

  /// No description provided for @failedDeleteOrder.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete order'**
  String get failedDeleteOrder;

  /// No description provided for @virtualAccount.
  ///
  /// In en, this message translates to:
  /// **'Virtual Account'**
  String get virtualAccount;

  /// No description provided for @customerName.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get customerName;

  /// No description provided for @editPaymentWarning.
  ///
  /// In en, this message translates to:
  /// **'Changing the payment method creates a new Virtual Account number or QRIS code.'**
  String get editPaymentWarning;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get networkError;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'A server error occurred'**
  String get serverError;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session has expired, please sign in again'**
  String get sessionExpired;

  /// No description provided for @validationFailed.
  ///
  /// In en, this message translates to:
  /// **'Validation failed'**
  String get validationFailed;

  /// No description provided for @accessDenied.
  ///
  /// In en, this message translates to:
  /// **'You do not have access'**
  String get accessDenied;

  /// No description provided for @graphqlSchemaError.
  ///
  /// In en, this message translates to:
  /// **'Service temporarily unavailable'**
  String get graphqlSchemaError;

  /// No description provided for @failedLoadReviews.
  ///
  /// In en, this message translates to:
  /// **'Failed to load reviews'**
  String get failedLoadReviews;

  /// No description provided for @failedProcessVote.
  ///
  /// In en, this message translates to:
  /// **'Failed to process vote'**
  String get failedProcessVote;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get locationPermissionDenied;

  /// No description provided for @locationPermissionPermanentlyDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are permanently denied'**
  String get locationPermissionPermanentlyDenied;

  /// No description provided for @failedGetLocation.
  ///
  /// In en, this message translates to:
  /// **'Failed to get location'**
  String get failedGetLocation;

  /// No description provided for @enterAddressDetails.
  ///
  /// In en, this message translates to:
  /// **'Please enter address details'**
  String get enterAddressDetails;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
