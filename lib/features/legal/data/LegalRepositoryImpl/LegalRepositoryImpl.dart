import 'package:dio/dio.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../Core/Api/ApiEndpoints/ApiEndpoints.dart';
import '../../../../Core/Api/DioClient/DioClient.dart';
import '../../../../Core/Api/GraphqlClient/GraphqlClient.dart';
import '../../../../Core/Api/GraphqlClient/GraphqlQueries.dart';
import '../../../../Core/Api/GrpcClient/GrpcV1Client.dart';
import '../../../../Core/Api/GrpcClient/GeneratedV1/Wedding/User/V1/Legal.pb.dart'
    as legal_pb;
import '../../Domain/LegalRepository/LegalRepository.dart';
import '../Models/LegalModel/LegalModel.dart';

/// Source type for legal data fetching
enum LegalDataSource {
  grpc,
  graphql,
  rest,
}

class LegalRepositoryImpl implements LegalRepository {
  final Dio _dio = DioClient.instance;

  /// Try to fetch LegalContent via gRPC → GraphQL → REST (cascading fallback)
  Future<LegalContent> _fetchLegalContent({
    required String graphqlQuery,
    required String graphqlFieldName,
    required Future<String> Function() restEndpoint,
    required Future<legal_pb.LegalContent> Function(WeddingUserV1GrpcClient) grpcCall,
    String? locale,
  }) async {
    // 1. Try gRPC first (fastest, most efficient)
    try {
      final grpcClient = WeddingUserV1GrpcClient.connect();
      try {
        final response = await grpcCall(grpcClient);
        return LegalContent.fromGrpc(
          id: response.id,
          title: response.title,
          content: response.content,
          updatedAt: response.updatedAt,
        );
      } finally {
        await grpcClient.shutdown();
      }
    } catch (e) {
      // gRPC failed, try GraphQL
    }

    // 2. Try GraphQL second
    try {
      final client = await GraphQLClientHelper.buildClient();

      final result = await client.query(
        QueryOptions(
          document: gql(graphqlQuery),
          fetchPolicy: FetchPolicy.noCache,
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      final data = result.data?[graphqlFieldName] as Map<String, dynamic>?;
      if (data != null) {
        return LegalContent.fromGraphQl(data, locale: locale ?? 'id');
      }
    } catch (e) {
      // GraphQL failed, fallback to REST
    }

    // 3. Fallback to REST (most compatible)
    final endpoint = await restEndpoint();
    final res = await _dio.get(endpoint);
    return LegalContent.fromJson(res.data, locale: locale ?? 'id');
  }

  @override
  Future<LegalContent> getPrivacyPolicy({String locale = 'id'}) async {
    return DioClient.safeCall(() async {
      return _fetchLegalContent(
        graphqlQuery: privacyPolicyQuery,
        graphqlFieldName: 'privacyPolicy',
        restEndpoint: () async => ApiEndpoints.legalPrivacy,
        grpcCall: (client) =>
            client.legal.getPrivacyPolicy(legal_pb.GetPrivacyPolicyRequest()),
        locale: locale,
      );
    });
  }

  @override
  Future<LegalContent> getTermsOfService({String locale = 'id'}) async {
    return DioClient.safeCall(() async {
      return _fetchLegalContent(
        graphqlQuery: termsOfServiceQuery,
        graphqlFieldName: 'termsOfService',
        restEndpoint: () async => ApiEndpoints.legalTerms,
        grpcCall: (client) =>
            client.legal.getTermsOfService(legal_pb.GetTermsOfServiceRequest()),
        locale: locale,
      );
    });
  }

  @override
  Future<LegalContent> getWeddingDecorationPolicy({
    String locale = 'id',
  }) async {
    return DioClient.safeCall(() async {
      return _fetchLegalContent(
        graphqlQuery: weddingDecorationPolicyQuery,
        graphqlFieldName: 'weddingDecorationPolicy',
        restEndpoint: () async => ApiEndpoints.legalWeddingPolicy,
        grpcCall: (client) => client.legal.getWeddingDecorationPolicy(
            legal_pb.GetWeddingDecorationPolicyRequest()),
        locale: locale,
      );
    });
  }

  @override
  Future<HelpModel> getHelpCenter({String locale = 'id'}) async {
    return DioClient.safeCall(() async {
      // 1. Try gRPC first
      try {
        final grpcClient = WeddingUserV1GrpcClient.connect();
        try {
          final response =
              await grpcClient.legal.getHelpCenter(legal_pb.GetHelpCenterRequest());
          final faqsData = response.faqs
              .map((faq) => {'question': faq.question, 'answer': faq.answer})
              .toList();
          return HelpModel.fromGrpc(
            title: response.title,
            subtitle: response.subtitle,
            faqs: faqsData.cast<Map<String, String>>(),
            contactOptions: response.contactOptions,
          );
        } finally {
          await grpcClient.shutdown();
        }
      } catch (e) {
        // gRPC failed, try GraphQL
      }

      // 2. Try GraphQL second
      try {
        final client = await GraphQLClientHelper.buildClient();

        final result = await client.query(
          QueryOptions(
            document: gql(helpCenterQuery),
            fetchPolicy: FetchPolicy.noCache,
          ),
        );

        if (!result.hasException) {
          final data = result.data?['helpCenter'] as Map<String, dynamic>?;
          if (data != null) {
            return HelpModel.fromGraphQl(data, locale: locale);
          }
        }
      } catch (e) {
        // GraphQL failed, fallback to REST
      }

      // 3. Fallback to REST
      final res = await _dio.get(ApiEndpoints.legalHelp);
      return HelpModel.fromJson(res.data, locale: locale);
    });
  }

  @override
  Future<AboutModel> getAbout({String locale = 'id'}) async {
    return DioClient.safeCall(() async {
      // 1. Try gRPC first
      try {
        final grpcClient = WeddingUserV1GrpcClient.connect();
        try {
          final response =
              await grpcClient.legal.getAbout(legal_pb.GetAboutRequest());
          return AboutModel.fromGrpc(
            title: response.title,
            content: response.content,
            mission: response.mission,
            owner: response.owner,
          );
        } finally {
          await grpcClient.shutdown();
        }
      } catch (e) {
        // gRPC failed, try GraphQL
      }

      // 2. Try GraphQL second
      try {
        final client = await GraphQLClientHelper.buildClient();

        final result = await client.query(
          QueryOptions(
            document: gql(aboutQuery),
            fetchPolicy: FetchPolicy.noCache,
          ),
        );

        if (!result.hasException) {
          final data = result.data?['about'] as Map<String, dynamic>?;
          if (data != null) {
            return AboutModel.fromGraphQl(data, locale: locale);
          }
        }
      } catch (e) {
        // GraphQL failed, fallback to REST
      }

      // 3. Fallback to REST
      final res = await _dio.get(ApiEndpoints.legalAbout);
      return AboutModel.fromJson(res.data, locale: locale);
    });
  }
}
