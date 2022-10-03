import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_assignment/features/categories/cubits/categories_cubit.dart';
import 'package:test_assignment/features/dataset/cubits/dataset_cubit.dart';
import 'package:test_assignment/models/category.dart';
import 'package:test_assignment/models/dataset.dart';
import 'package:test_assignment/repositories/category_repository.dart';
import 'package:test_assignment/repositories/dataset_repository.dart';

class MockDatasetRepository extends Mock implements DatasetRepository {}

class MockCategoriesRepository extends Mock implements CategoryRepository {}

Future<void> main() async {
  late MockDatasetRepository datasetRepository;
  late MockCategoriesRepository categoriesRepository;
  late CategoriesCubit categoriesCubit;
  late DatasetCubit datasetCubit;

  await dotenv.load();

  setUp(() {
    datasetRepository = MockDatasetRepository();
    categoriesRepository = MockCategoriesRepository();
    categoriesCubit = CategoriesCubit(repository: categoriesRepository);
    datasetCubit = DatasetCubit(
        categoryCubit: categoriesCubit, repository: datasetRepository);
  });

  final dataset = DatasetModel(
      id: 1, segmentation: '[[10.2, 12.3, 13.52, 14.0]]', categoryId: 1);
  const category = CategoryModel(id: 1, name: 'test');
  final datasets = [dataset];

  group('Testing Datasets', () {
    blocTest<DatasetCubit, DatasetState>('Search by categories', build: () {
      categoriesCubit.toggleSearchCategory(category);
      when(() => datasetRepository.searchDataset(datasetCubit))
          .thenAnswer((_) async => datasets);
      return datasetCubit;
    },
      act: (cubit) => cubit.search(),
      expect: () => [
        const DatasetState.loading(datasets: []),
        DatasetState.finished(datasets: datasets),
      ]
    );
  });

}
