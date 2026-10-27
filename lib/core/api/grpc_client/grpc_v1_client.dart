import 'package:grpc/grpc.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;

import '../../config/app_config/app_config.dart';
import 'generated_v1/wedding/user/v1/auth.pbgrpc.dart';
import 'generated_v1/wedding/user/v1/catalog.pbgrpc.dart';
import 'generated_v1/wedding/user/v1/cart.pbgrpc.dart';
import 'generated_v1/wedding/user/v1/category.pbgrpc.dart';
import 'generated_v1/wedding/user/v1/cbir.pbgrpc.dart';
import 'generated_v1/wedding/user/v1/chat.pbgrpc.dart';
import 'generated_v1/wedding/user/v1/home.pbgrpc.dart';
import 'generated_v1/wedding/user/v1/notification.pbgrpc.dart';
import 'generated_v1/wedding/user/v1/order.pbgrpc.dart';
import 'generated_v1/wedding/user/v1/package.pbgrpc.dart';
import 'generated_v1/wedding/user/v1/profile.pbgrpc.dart';
import 'generated_v1/wedding/user/v1/review.pbgrpc.dart';
import 'generated_v1/wedding/user/v1/search.pbgrpc.dart';
import 'generated_v1/wedding/user/v1/voucher.pbgrpc.dart';
import 'generated_v1/wedding/user/v1/wishlist.pbgrpc.dart';

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
