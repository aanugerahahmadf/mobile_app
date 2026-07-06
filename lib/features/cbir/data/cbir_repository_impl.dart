import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/dio_client.dart';
import '../domain/cbir_repository.dart';
import 'models/cbir_result_model.dart';

class CbirRepositoryImpl implements CbirRepository {
  @override
  Future<List<CbirResultItem>> searchByImage(File imageFile, {bool isAdmin = false}) async {
    final dir = await getTemporaryDirectory();
    final targetPath =
        '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    final compressed = await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      targetPath,
      quality: 70,
      minWidth: 800,
      minHeight: 800,
    );

    final imagePath = compressed?.path ?? imageFile.path;

    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        imagePath,
        filename: 'search.jpg',
      ),
    });

    final endpoint = isAdmin ? ApiEndpoints.adminSearchImage : ApiEndpoints.searchImage;
    final response = await DioClient.instance.post(
      endpoint,
      data: formData,
    );

    final raw = response.data;
    if (raw is Map && raw['status'] == 'error') {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: raw['message'] as String? ?? 'Pencarian gambar gagal',
      );
    }

    final data = (raw is Map ? (raw['results'] ?? raw['data']) : raw);
    if (data is List) {
      return data
          .map((e) => CbirResultItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<List<CbirResultItem>> arithmeticSearch({
    required File image1,
    required File image2,
    required String operation,
    int topK = 20,
    List<double>? weights,
    bool isAdmin = false,
  }) async {
    final dir = await getTemporaryDirectory();
    final ts = DateTime.now().millisecondsSinceEpoch;

    final compressed1 = await FlutterImageCompress.compressAndGetFile(
      image1.absolute.path,
      '${dir.path}/${ts}_1.jpg',
      quality: 70, minWidth: 800, minHeight: 800,
    );
    final compressed2 = await FlutterImageCompress.compressAndGetFile(
      image2.absolute.path,
      '${dir.path}/${ts}_2.jpg',
      quality: 70, minWidth: 800, minHeight: 800,
    );

    final formData = FormData.fromMap({
      'image_1': await MultipartFile.fromFile(
        compressed1?.path ?? image1.path,
        filename: 'image_1.jpg',
      ),
      'image_2': await MultipartFile.fromFile(
        compressed2?.path ?? image2.path,
        filename: 'image_2.jpg',
      ),
      'operation': operation,
      'top_k': topK,
    });

    if (weights != null && weights.length >= 2) {
      formData.fields.add(MapEntry('weights[0]', weights[0].toString()));
      formData.fields.add(MapEntry('weights[1]', weights[1].toString()));
    }

    final arithmeticEndpoint = isAdmin ? ApiEndpoints.adminCbirArithmetic : ApiEndpoints.cbirArithmetic;
    final response = await DioClient.instance.post(
      arithmeticEndpoint,
      data: formData,
    );

    final raw = response.data;
    if (raw is Map && raw['status'] == 'error') {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: raw['message'] as String? ?? 'Pencarian aritmetika gagal',
      );
    }

    final data = (raw is Map ? (raw['results'] ?? raw['data']) : raw);
    if (data is List) {
      return data
          .map((e) => CbirResultItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
