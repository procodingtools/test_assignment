import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:test_assignment/app/constants.dart';
import 'package:test_assignment/models/category.dart';
import 'package:test_assignment/models/dataset.dart';
import 'package:test_assignment/services/base_service.dart';

/// {@category Datasets}
/// {@subCategory Services}
/// Service to handle http requests for datasets.
class DatasetService extends BaseService {
  DatasetService() {
    dio.options = BaseOptions(baseUrl: dotenv.get(datasetUrl));
  }

  /// Getting images list for a specific categories.
  Future<List<int>> getImagesByCats(List<CategoryModel> categories) async {
    final response = (await dio.post('coco-dataset-bigquery', data: {
      'category_ids': categories.map((e) => e.id).toList(),
      'querytype': 'getImagesByCats'
    }))
        .data;
    return List<int>.from(response);
  }

  /// Getting instances for each image id.
  Future<List<DatasetModel>> getInstances(List<int> imageIds) async {
    final response = (await dio.post('coco-dataset-bigquery',
            data: {'image_ids': imageIds, 'querytype': 'getInstances'}))
        .data;

    return List.of(response).map((e) => DatasetModel.fromJson(e)).toList();
  }

  /// Getting maps. used to objects from the api, such as 'getImages' and
  /// 'getCaptions' queries.
  Future<List<Map<String, dynamic>>> getMap(
      {required List<int> imageIds, required MapType type}) async {
    final response = (await dio.post('coco-dataset-bigquery', data: {
      'image_ids': imageIds,
      'querytype': type == MapType.images ? 'getImages' : 'getCaptions'
    }))
        .data;

    return List<Map<String, dynamic>>.from(response);
  }
}

enum MapType { images, captions }
