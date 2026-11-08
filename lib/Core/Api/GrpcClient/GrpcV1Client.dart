import 'package:grpc/grpc.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;

import '../../Config/AppConfig/AppConfig.dart';
import 'GeneratedV1/Wedding/User/V1/Auth.pbgrpc.dart';
import 'GeneratedV1/Wedding/User/V1/Catalog.pbgrpc.dart';
import 'GeneratedV1/Wedding/User/V1/Cart.pbgrpc.dart';
import 'GeneratedV1/Wedding/User/V1/Category.pbgrpc.dart';
import 'GeneratedV1/Wedding/User/V1/Cbir.pbgrpc.dart';
import 'GeneratedV1/Wedding/User/V1/Chat.pbgrpc.dart';
import 'GeneratedV1/Wedding/User/V1/Home.pbgrpc.dart';
import 'GeneratedV1/Wedding/User/V1/Notification.pbgrpc.dart';
import 'GeneratedV1/Wedding/User/V1/Order.pbgrpc.dart';
import 'GeneratedV1/Wedding/User/V1/Package.pbgrpc.dart';
import 'GeneratedV1/Wedding/User/V1/Profile.pbgrpc.dart';
import 'GeneratedV1/Wedding/User/V1/Review.pbgrpc.dart';
import 'GeneratedV1/Wedding/User/V1/Search.pbgrpc.dart';
import 'GeneratedV1/Wedding/User/V1/Voucher.pbgrpc.dart';
import 'GeneratedV1/Wedding/User/V1/Wishlist.pbgrpc.dart';

/// Typed clients generated from the active `wedding.user.v1` contract.
///
/// This is deliberately separate from the retired handwritten wrappers. New
/// application code must use these generated clients so request/response
/// names cannot drift from the Laravel protobuf contract again.
class WeddingUserV1GrpcClient {
  WeddingUserV1GrpcClient._(this.channel)
      : auth = AuthServiceClient(channel),
        catalog = CatalogServiceClient(channel),
        cart = CartServiceClient(channel),
        category = CategoryServiceClient(channel),
        cbir = CbirServiceClient(channel),
        chat = ChatServiceClient(channel),
        home = HomeServiceClient(channel),
        notification = NotificationServiceClient(channel),
        order = OrderServiceClient(channel),
        package = PackageServiceClient(channel),
        profile = ProfileServiceClient(channel),
        review = ReviewServiceClient(channel),
        search = SearchServiceClient(channel),
        voucher = VoucherServiceClient(channel),
        wishlist = WishlistServiceClient(channel);

  final ClientChannel channel;
  final AuthServiceClient auth;
  final CatalogServiceClient catalog;
  final CartServiceClient cart;
  final CategoryServiceClient category;
  final CbirServiceClient cbir;
  final ChatServiceClient chat;
  final HomeServiceClient home;
  final NotificationServiceClient notification;
  final OrderServiceClient order;
  final PackageServiceClient package;
  final ProfileServiceClient profile;
  final ReviewServiceClient review;
  final SearchServiceClient search;
  final VoucherServiceClient voucher;
  final WishlistServiceClient wishlist;

  static WeddingUserV1GrpcClient connect() {
    final base = Uri.parse(AppConfig.grpcBaseUrl);
    final secure = base.scheme == 'https';
    final port = base.hasPort ? base.port : (secure ? 443 : 50051);

    if (kReleaseMode && !secure) {
      throw StateError('Release gRPC wajib menggunakan TLS.');
    }

    final channel = ClientChannel(
      base.host,
      port: port,
      options: ChannelOptions(
        credentials: secure
            ? const ChannelCredentials.secure()
            : const ChannelCredentials.insecure(),
        codecRegistry: CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
      ),
    );

    return WeddingUserV1GrpcClient._(channel);
  }

  Future<void> shutdown() => channel.shutdown();

  CallOptions authenticatedOptions(String token) => CallOptions(
        metadata: <String, String>{
          'authorization': 'Bearer $token',
          'content-type': 'application/grpc',
        },
      );
}
