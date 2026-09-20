import 'dart:io';
import '../../data/models/cbir_result_model/cbir_result_model.dart';

abstract class CbirRepository {
  Future<List<CbirResultItem>> searchByImage(File imageFile);

  Future<List<CbirResultItem>> arithmeticSearch({
    required File image1,
    required File image2,
    required String operation,
    List<double>? weights,
  });
}
