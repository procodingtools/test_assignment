import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:test_assignment/app/constants.dart';
import 'package:test_assignment/services/base_service.dart';


/// {@template services}
/// Service to handle http requests for categories.
/// {@endtemplate}
class CategoriesService extends BaseService {

  /// {@macro services}
  CategoriesService() {
    dio.options = BaseOptions(baseUrl: dotenv.get(cocoExplorer));
  }

  /// Getting the base JS file to extract all available categories from the
  /// website.
  Future<String> getBaseJsFile() async {
    final response = (await dio.get('other/cocoexplorer.js', options: Options(
      contentType: 'text'
    ))).data;

    return response;
  }
}