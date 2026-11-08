import 'dart:io';
import '../../Data/Models/CbirResultModel/CbirResultModel.dart';

abstract class CbirRepository {
  Future<List<CbirResultItem>> searchByImage(File imageFile);

  Future<List<CbirResultItem>> arithmeticSearch({
    required File image1,
    required File image2,
    required String operation,
    List<double>? weights,
  });
}
