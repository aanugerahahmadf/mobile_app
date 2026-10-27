// This is a generated file - do not edit.
//
// Generated from wedding/user/v1/common.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class SortDirection extends $pb.ProtobufEnum {
  static const SortDirection SORT_DIRECTION_UNSPECIFIED =
      SortDirection._(0, _omitEnumNames ? '' : 'SORT_DIRECTION_UNSPECIFIED');
  static const SortDirection SORT_DIRECTION_ASC =
      SortDirection._(1, _omitEnumNames ? '' : 'SORT_DIRECTION_ASC');
  static const SortDirection SORT_DIRECTION_DESC =
      SortDirection._(2, _omitEnumNames ? '' : 'SORT_DIRECTION_DESC');

  static const $core.List<SortDirection> values = <SortDirection>[
    SORT_DIRECTION_UNSPECIFIED,
    SORT_DIRECTION_ASC,
    SORT_DIRECTION_DESC,
  ];

  static final $core.List<SortDirection?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static SortDirection? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SortDirection._(super.value, super.name);
}

class Gender extends $pb.ProtobufEnum {
  static const Gender GENDER_UNSPECIFIED =
      Gender._(0, _omitEnumNames ? '' : 'GENDER_UNSPECIFIED');
  static const Gender GENDER_MALE =
      Gender._(1, _omitEnumNames ? '' : 'GENDER_MALE');
  static const Gender GENDER_FEMALE =
      Gender._(2, _omitEnumNames ? '' : 'GENDER_FEMALE');
  static const Gender GENDER_OTHER =
      Gender._(3, _omitEnumNames ? '' : 'GENDER_OTHER');
  static const Gender GENDER_PREFER_NOT_TO_SAY =
      Gender._(4, _omitEnumNames ? '' : 'GENDER_PREFER_NOT_TO_SAY');

  static const $core.List<Gender> values = <Gender>[
    GENDER_UNSPECIFIED,
    GENDER_MALE,
    GENDER_FEMALE,
    GENDER_OTHER,
    GENDER_PREFER_NOT_TO_SAY,
  ];

  static final $core.List<Gender?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static Gender? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Gender._(super.value, super.name);
}

class AddressType extends $pb.ProtobufEnum {
  static const AddressType ADDRESS_TYPE_UNSPECIFIED =
      AddressType._(0, _omitEnumNames ? '' : 'ADDRESS_TYPE_UNSPECIFIED');
  static const AddressType ADDRESS_TYPE_HOME =
      AddressType._(1, _omitEnumNames ? '' : 'ADDRESS_TYPE_HOME');
  static const AddressType ADDRESS_TYPE_WORK =
      AddressType._(2, _omitEnumNames ? '' : 'ADDRESS_TYPE_WORK');
  static const AddressType ADDRESS_TYPE_OTHER =
      AddressType._(3, _omitEnumNames ? '' : 'ADDRESS_TYPE_OTHER');

  static const $core.List<AddressType> values = <AddressType>[
    ADDRESS_TYPE_UNSPECIFIED,
    ADDRESS_TYPE_HOME,
    ADDRESS_TYPE_WORK,
    ADDRESS_TYPE_OTHER,
  ];

  static final $core.List<AddressType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static AddressType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AddressType._(super.value, super.name);
}

class PaymentMethod extends $pb.ProtobufEnum {
  static const PaymentMethod PAYMENT_METHOD_UNSPECIFIED =
      PaymentMethod._(0, _omitEnumNames ? '' : 'PAYMENT_METHOD_UNSPECIFIED');
  static const PaymentMethod PAYMENT_METHOD_MIDTRANS =
      PaymentMethod._(1, _omitEnumNames ? '' : 'PAYMENT_METHOD_MIDTRANS');
  static const PaymentMethod PAYMENT_METHOD_BANK_TRANSFER =
      PaymentMethod._(2, _omitEnumNames ? '' : 'PAYMENT_METHOD_BANK_TRANSFER');
  static const PaymentMethod PAYMENT_METHOD_CASH_ON_DELIVERY = PaymentMethod._(
      3, _omitEnumNames ? '' : 'PAYMENT_METHOD_CASH_ON_DELIVERY');
  static const PaymentMethod PAYMENT_METHOD_E_WALLET =
      PaymentMethod._(4, _omitEnumNames ? '' : 'PAYMENT_METHOD_E_WALLET');
  static const PaymentMethod PAYMENT_METHOD_CREDIT_CARD =
      PaymentMethod._(5, _omitEnumNames ? '' : 'PAYMENT_METHOD_CREDIT_CARD');

  static const $core.List<PaymentMethod> values = <PaymentMethod>[
    PAYMENT_METHOD_UNSPECIFIED,
    PAYMENT_METHOD_MIDTRANS,
    PAYMENT_METHOD_BANK_TRANSFER,
    PAYMENT_METHOD_CASH_ON_DELIVERY,
    PAYMENT_METHOD_E_WALLET,
    PAYMENT_METHOD_CREDIT_CARD,
  ];

  static final $core.List<PaymentMethod?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static PaymentMethod? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PaymentMethod._(super.value, super.name);
}

class OrderStatus extends $pb.ProtobufEnum {
  static const OrderStatus ORDER_STATUS_UNSPECIFIED =
      OrderStatus._(0, _omitEnumNames ? '' : 'ORDER_STATUS_UNSPECIFIED');
  static const OrderStatus ORDER_STATUS_PENDING =
      OrderStatus._(1, _omitEnumNames ? '' : 'ORDER_STATUS_PENDING');
  static const OrderStatus ORDER_STATUS_CONFIRMED =
      OrderStatus._(2, _omitEnumNames ? '' : 'ORDER_STATUS_CONFIRMED');
  static const OrderStatus ORDER_STATUS_PROCESSING =
      OrderStatus._(3, _omitEnumNames ? '' : 'ORDER_STATUS_PROCESSING');
  static const OrderStatus ORDER_STATUS_SHIPPED =
      OrderStatus._(4, _omitEnumNames ? '' : 'ORDER_STATUS_SHIPPED');
  static const OrderStatus ORDER_STATUS_DELIVERED =
      OrderStatus._(5, _omitEnumNames ? '' : 'ORDER_STATUS_DELIVERED');
  static const OrderStatus ORDER_STATUS_CANCELLED =
      OrderStatus._(6, _omitEnumNames ? '' : 'ORDER_STATUS_CANCELLED');
  static const OrderStatus ORDER_STATUS_REFUNDED =
      OrderStatus._(7, _omitEnumNames ? '' : 'ORDER_STATUS_REFUNDED');

  static const $core.List<OrderStatus> values = <OrderStatus>[
    ORDER_STATUS_UNSPECIFIED,
    ORDER_STATUS_PENDING,
    ORDER_STATUS_CONFIRMED,
    ORDER_STATUS_PROCESSING,
    ORDER_STATUS_SHIPPED,
    ORDER_STATUS_DELIVERED,
    ORDER_STATUS_CANCELLED,
    ORDER_STATUS_REFUNDED,
  ];

  static final $core.List<OrderStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static OrderStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const OrderStatus._(super.value, super.name);
}

class PaymentStatus extends $pb.ProtobufEnum {
  static const PaymentStatus PAYMENT_STATUS_UNSPECIFIED =
      PaymentStatus._(0, _omitEnumNames ? '' : 'PAYMENT_STATUS_UNSPECIFIED');
  static const PaymentStatus PAYMENT_STATUS_PENDING =
      PaymentStatus._(1, _omitEnumNames ? '' : 'PAYMENT_STATUS_PENDING');
  static const PaymentStatus PAYMENT_STATUS_PAID =
      PaymentStatus._(2, _omitEnumNames ? '' : 'PAYMENT_STATUS_PAID');
  static const PaymentStatus PAYMENT_STATUS_FAILED =
      PaymentStatus._(3, _omitEnumNames ? '' : 'PAYMENT_STATUS_FAILED');
  static const PaymentStatus PAYMENT_STATUS_REFUNDED =
      PaymentStatus._(4, _omitEnumNames ? '' : 'PAYMENT_STATUS_REFUNDED');
  static const PaymentStatus PAYMENT_STATUS_PARTIALLY_REFUNDED =
      PaymentStatus._(
          5, _omitEnumNames ? '' : 'PAYMENT_STATUS_PARTIALLY_REFUNDED');

  static const $core.List<PaymentStatus> values = <PaymentStatus>[
    PAYMENT_STATUS_UNSPECIFIED,
    PAYMENT_STATUS_PENDING,
    PAYMENT_STATUS_PAID,
    PAYMENT_STATUS_FAILED,
    PAYMENT_STATUS_REFUNDED,
    PAYMENT_STATUS_PARTIALLY_REFUNDED,
  ];

  static final $core.List<PaymentStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static PaymentStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PaymentStatus._(super.value, super.name);
}

class ReviewStatus extends $pb.ProtobufEnum {
  static const ReviewStatus REVIEW_STATUS_UNSPECIFIED =
      ReviewStatus._(0, _omitEnumNames ? '' : 'REVIEW_STATUS_UNSPECIFIED');
  static const ReviewStatus REVIEW_STATUS_PENDING =
      ReviewStatus._(1, _omitEnumNames ? '' : 'REVIEW_STATUS_PENDING');
  static const ReviewStatus REVIEW_STATUS_APPROVED =
      ReviewStatus._(2, _omitEnumNames ? '' : 'REVIEW_STATUS_APPROVED');
  static const ReviewStatus REVIEW_STATUS_REJECTED =
      ReviewStatus._(3, _omitEnumNames ? '' : 'REVIEW_STATUS_REJECTED');
  static const ReviewStatus REVIEW_STATUS_HIDDEN =
      ReviewStatus._(4, _omitEnumNames ? '' : 'REVIEW_STATUS_HIDDEN');

  static const $core.List<ReviewStatus> values = <ReviewStatus>[
    REVIEW_STATUS_UNSPECIFIED,
    REVIEW_STATUS_PENDING,
    REVIEW_STATUS_APPROVED,
    REVIEW_STATUS_REJECTED,
    REVIEW_STATUS_HIDDEN,
  ];

  static final $core.List<ReviewStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static ReviewStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ReviewStatus._(super.value, super.name);
}

class DiscountType extends $pb.ProtobufEnum {
  static const DiscountType DISCOUNT_TYPE_UNSPECIFIED =
      DiscountType._(0, _omitEnumNames ? '' : 'DISCOUNT_TYPE_UNSPECIFIED');
  static const DiscountType DISCOUNT_TYPE_PERCENTAGE =
      DiscountType._(1, _omitEnumNames ? '' : 'DISCOUNT_TYPE_PERCENTAGE');
  static const DiscountType DISCOUNT_TYPE_FIXED_AMOUNT =
      DiscountType._(2, _omitEnumNames ? '' : 'DISCOUNT_TYPE_FIXED_AMOUNT');
  static const DiscountType DISCOUNT_TYPE_FREE_SHIPPING =
      DiscountType._(3, _omitEnumNames ? '' : 'DISCOUNT_TYPE_FREE_SHIPPING');

  static const $core.List<DiscountType> values = <DiscountType>[
    DISCOUNT_TYPE_UNSPECIFIED,
    DISCOUNT_TYPE_PERCENTAGE,
    DISCOUNT_TYPE_FIXED_AMOUNT,
    DISCOUNT_TYPE_FREE_SHIPPING,
  ];

  static final $core.List<DiscountType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static DiscountType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DiscountType._(super.value, super.name);
}

class ReportReason extends $pb.ProtobufEnum {
  static const ReportReason REPORT_REASON_UNSPECIFIED =
      ReportReason._(0, _omitEnumNames ? '' : 'REPORT_REASON_UNSPECIFIED');
  static const ReportReason REPORT_REASON_SPAM =
      ReportReason._(1, _omitEnumNames ? '' : 'REPORT_REASON_SPAM');
  static const ReportReason REPORT_REASON_INAPPROPRIATE =
      ReportReason._(2, _omitEnumNames ? '' : 'REPORT_REASON_INAPPROPRIATE');
  static const ReportReason REPORT_REASON_FAKE =
      ReportReason._(3, _omitEnumNames ? '' : 'REPORT_REASON_FAKE');
  static const ReportReason REPORT_REASON_OFFENSIVE =
      ReportReason._(4, _omitEnumNames ? '' : 'REPORT_REASON_OFFENSIVE');
  static const ReportReason REPORT_REASON_IRRELEVANT =
      ReportReason._(5, _omitEnumNames ? '' : 'REPORT_REASON_IRRELEVANT');
  static const ReportReason REPORT_REASON_OTHER =
      ReportReason._(6, _omitEnumNames ? '' : 'REPORT_REASON_OTHER');

  static const $core.List<ReportReason> values = <ReportReason>[
    REPORT_REASON_UNSPECIFIED,
    REPORT_REASON_SPAM,
    REPORT_REASON_INAPPROPRIATE,
    REPORT_REASON_FAKE,
    REPORT_REASON_OFFENSIVE,
    REPORT_REASON_IRRELEVANT,
    REPORT_REASON_OTHER,
  ];

  static final $core.List<ReportReason?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static ReportReason? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ReportReason._(super.value, super.name);
}

class ReportStatus extends $pb.ProtobufEnum {
  static const ReportStatus REPORT_STATUS_UNSPECIFIED =
      ReportStatus._(0, _omitEnumNames ? '' : 'REPORT_STATUS_UNSPECIFIED');
  static const ReportStatus REPORT_STATUS_PENDING =
      ReportStatus._(1, _omitEnumNames ? '' : 'REPORT_STATUS_PENDING');
  static const ReportStatus REPORT_STATUS_REVIEWED =
      ReportStatus._(2, _omitEnumNames ? '' : 'REPORT_STATUS_REVIEWED');
  static const ReportStatus REPORT_STATUS_RESOLVED =
      ReportStatus._(3, _omitEnumNames ? '' : 'REPORT_STATUS_RESOLVED');
  static const ReportStatus REPORT_STATUS_DISMISSED =
      ReportStatus._(4, _omitEnumNames ? '' : 'REPORT_STATUS_DISMISSED');

  static const $core.List<ReportStatus> values = <ReportStatus>[
    REPORT_STATUS_UNSPECIFIED,
    REPORT_STATUS_PENDING,
    REPORT_STATUS_REVIEWED,
    REPORT_STATUS_RESOLVED,
    REPORT_STATUS_DISMISSED,
  ];

  static final $core.List<ReportStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static ReportStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ReportStatus._(super.value, super.name);
}

class SearchType extends $pb.ProtobufEnum {
  static const SearchType SEARCH_TYPE_UNSPECIFIED =
      SearchType._(0, _omitEnumNames ? '' : 'SEARCH_TYPE_UNSPECIFIED');
  static const SearchType SEARCH_TYPE_CATALOG =
      SearchType._(1, _omitEnumNames ? '' : 'SEARCH_TYPE_CATALOG');
  static const SearchType SEARCH_TYPE_PACKAGE =
      SearchType._(2, _omitEnumNames ? '' : 'SEARCH_TYPE_PACKAGE');
  static const SearchType SEARCH_TYPE_BOTH =
      SearchType._(3, _omitEnumNames ? '' : 'SEARCH_TYPE_BOTH');

  static const $core.List<SearchType> values = <SearchType>[
    SEARCH_TYPE_UNSPECIFIED,
    SEARCH_TYPE_CATALOG,
    SEARCH_TYPE_PACKAGE,
    SEARCH_TYPE_BOTH,
  ];

  static final $core.List<SearchType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static SearchType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SearchType._(super.value, super.name);
}

class WishlistActionType extends $pb.ProtobufEnum {
  static const WishlistActionType WISHLIST_ACTION_TYPE_UNSPECIFIED =
      WishlistActionType._(
          0, _omitEnumNames ? '' : 'WISHLIST_ACTION_TYPE_UNSPECIFIED');
  static const WishlistActionType WISHLIST_ACTION_TYPE_ADDED =
      WishlistActionType._(
          1, _omitEnumNames ? '' : 'WISHLIST_ACTION_TYPE_ADDED');
  static const WishlistActionType WISHLIST_ACTION_TYPE_REMOVED =
      WishlistActionType._(
          2, _omitEnumNames ? '' : 'WISHLIST_ACTION_TYPE_REMOVED');

  static const $core.List<WishlistActionType> values = <WishlistActionType>[
    WISHLIST_ACTION_TYPE_UNSPECIFIED,
    WISHLIST_ACTION_TYPE_ADDED,
    WISHLIST_ACTION_TYPE_REMOVED,
  ];

  static final $core.List<WishlistActionType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static WishlistActionType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const WishlistActionType._(super.value, super.name);
}

class SearchSuggestionType extends $pb.ProtobufEnum {
  static const SearchSuggestionType SEARCH_SUGGESTION_TYPE_UNSPECIFIED =
      SearchSuggestionType._(
          0, _omitEnumNames ? '' : 'SEARCH_SUGGESTION_TYPE_UNSPECIFIED');
  static const SearchSuggestionType SEARCH_SUGGESTION_TYPE_CATALOG =
      SearchSuggestionType._(
          1, _omitEnumNames ? '' : 'SEARCH_SUGGESTION_TYPE_CATALOG');
  static const SearchSuggestionType SEARCH_SUGGESTION_TYPE_PACKAGE =
      SearchSuggestionType._(
          2, _omitEnumNames ? '' : 'SEARCH_SUGGESTION_TYPE_PACKAGE');
  static const SearchSuggestionType SEARCH_SUGGESTION_TYPE_CATEGORY =
      SearchSuggestionType._(
          3, _omitEnumNames ? '' : 'SEARCH_SUGGESTION_TYPE_CATEGORY');
  static const SearchSuggestionType SEARCH_SUGGESTION_TYPE_KEYWORD =
      SearchSuggestionType._(
          4, _omitEnumNames ? '' : 'SEARCH_SUGGESTION_TYPE_KEYWORD');

  static const $core.List<SearchSuggestionType> values = <SearchSuggestionType>[
    SEARCH_SUGGESTION_TYPE_UNSPECIFIED,
    SEARCH_SUGGESTION_TYPE_CATALOG,
    SEARCH_SUGGESTION_TYPE_PACKAGE,
    SEARCH_SUGGESTION_TYPE_CATEGORY,
    SEARCH_SUGGESTION_TYPE_KEYWORD,
  ];

  static final $core.List<SearchSuggestionType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static SearchSuggestionType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SearchSuggestionType._(super.value, super.name);
}

class RefundStatus extends $pb.ProtobufEnum {
  static const RefundStatus REFUND_STATUS_UNSPECIFIED =
      RefundStatus._(0, _omitEnumNames ? '' : 'REFUND_STATUS_UNSPECIFIED');
  static const RefundStatus REFUND_STATUS_PENDING =
      RefundStatus._(1, _omitEnumNames ? '' : 'REFUND_STATUS_PENDING');
  static const RefundStatus REFUND_STATUS_APPROVED =
      RefundStatus._(2, _omitEnumNames ? '' : 'REFUND_STATUS_APPROVED');
  static const RefundStatus REFUND_STATUS_REJECTED =
      RefundStatus._(3, _omitEnumNames ? '' : 'REFUND_STATUS_REJECTED');
  static const RefundStatus REFUND_STATUS_PROCESSED =
      RefundStatus._(4, _omitEnumNames ? '' : 'REFUND_STATUS_PROCESSED');

  static const $core.List<RefundStatus> values = <RefundStatus>[
    REFUND_STATUS_UNSPECIFIED,
    REFUND_STATUS_PENDING,
    REFUND_STATUS_APPROVED,
    REFUND_STATUS_REJECTED,
    REFUND_STATUS_PROCESSED,
  ];

  static final $core.List<RefundStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static RefundStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RefundStatus._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
