import 'package:dio/dio.dart';

/// {@category Datasets, Category}
/// {@subCategory Services}
/// Initializing [Dio] object to work on it in several service in the app.
class BaseService {
  late Dio dio;

  BaseService() {
    dio = Dio();
  }
}
