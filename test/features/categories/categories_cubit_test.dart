
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_assignment/features/categories/cubits/categories_cubit.dart';
import 'package:test_assignment/models/category.dart';
import 'package:test_assignment/repositories/category_repository.dart';

class MockCategoriesRepository extends Mock implements CategoryRepository{}
Future<void> main() async {
  late MockCategoriesRepository repository;
  late CategoriesCubit cubit;

  await dotenv.load();

  setUp(() {
    repository = MockCategoriesRepository();
    cubit = CategoriesCubit(repository: repository);
  });

  const category = CategoryModel(id: 1, name: 'test');

  final categories = [
    category
  ];

  group('Testing Categories', () {
    blocTest<CategoriesCubit, CategoriesState>(
        'Get categories',
        build: () {
          when(() => repository.getCategories()).thenAnswer((_) async => categories);
          return cubit;
        },
      act: (cubit) => cubit.getCategories(),
      expect: () => [
        const CategoriesState.loading(categories: [], searchCategories: []),
        CategoriesState.loaded(categories: categories, searchCategories: [])
      ]
    );

    blocTest<CategoriesCubit, CategoriesState>('Changing categories to search', build: () {
      return cubit;
    },
      act: (cubit) => cubit.toggleSearchCategory(category),
      expect: () => [
        CategoriesState.changedSearch(categories: [], searchCategories: categories)
      ]
    );
  });
}