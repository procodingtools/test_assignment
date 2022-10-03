import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:test_assignment/repositories/dataset_repository.dart';
import 'package:test_assignment/services/dataset_service.dart';

Future<void> main() async {
  late DatasetRepository repository;
  late DioAdapter dioAdapter;
  late DatasetService service;

  await dotenv.load();

  setUp(() {
    service = DatasetService();
    dioAdapter = DioAdapter(dio: service.dio);
    service.dio.httpClientAdapter = dioAdapter;
    repository = DatasetRepository(service: service);
  });
}