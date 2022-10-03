import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_assignment/models/category.dart';
import 'package:test_assignment/repositories/category_repository.dart';
import 'package:test_assignment/ui/categories/widgets/categories_search_box.dart';
import 'package:test_assignment/ui/categories/widgets/category_button.dart';

part 'categories_state.dart';
part 'categories_cubit.freezed.dart';

/// {@category Category}
/// {@subCategory Cubits}
/// [Cubit] to manage and handle categories changes.
class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit({
    CategoryRepository? repository
}): repository = repository ?? CategoryRepository(),
  super(const _Initial());

  CategoryRepository repository;

  /// getting categories
  Future<void> getCategories() async {
    emit(_Loading(categories: state.categories, searchCategories: state.searchCategories));
    try {
      final categories = await repository.getCategories();
      emit(_Loaded(categories: categories, searchCategories: state.searchCategories));
    } on Exception catch (e) {
      emit(_Error(exception: e, categories: state.categories, searchCategories: state.searchCategories));
    }
  }

  /// Toggling categories to search. This method will add/remove selected
  /// categories from [CategoryButton] and [CategoriesSearchBox].
  void toggleSearchCategory(CategoryModel category) {
    final list = List<CategoryModel>.from(state.searchCategories);
    if (list.contains(category)) {
      list.remove(category);
    } else {
      list.add(category);
    }
    emit(CategoriesState.changedSearch(categories: state.categories, searchCategories: list
    ));
  }

}