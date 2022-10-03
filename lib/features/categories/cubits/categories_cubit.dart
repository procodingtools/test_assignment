import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_assignment/models/category.dart';
import 'package:test_assignment/repositories/category.dart';

part 'categories_state.dart';
part 'categories_cubit.freezed.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit({
    CategoryRepository? repository
}): repository = repository ?? CategoryRepository(),
  super(const _Initial());

  CategoryRepository repository;

  Future<void> getCategories() async {
    emit(_Loading(categories: state.categories, searchCategories: state.searchCategories));
    try {
      final categories = await repository.getCategories();
      emit(_Loaded(categories: categories, searchCategories: state.searchCategories));
    } on Exception catch (e) {
      emit(_Error(exception: e, categories: state.categories, searchCategories: state.searchCategories));
    }
  }

  void toggleSearchCategory(CategoryModel category) {
    final list = List<CategoryModel>.from(state.searchCategories);
    if (list.contains(category)) {
      list.remove(category);
    } else {
      list.add(category);
    }
    emit(CategoriesState.changedSearch(categories: state.categories, searchCategories: list
    ));
    print(state.searchCategories.length);
  }

}