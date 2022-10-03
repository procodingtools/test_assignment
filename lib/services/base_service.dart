import 'package:dio/dio.dart';


class BaseService {
  late Dio dio;

  BaseService() {
    dio = Dio();
  }
}
