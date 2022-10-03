part of 'categories_cubit.dart';

@freezed
class CategoriesState with _$CategoriesState {
  const factory CategoriesState.initial({
    @Default(<CategoryModel>[]) List<CategoryModel> categories,
    @Default(<CategoryModel>[]) List<CategoryModel> searchCategories,
  }) = _Initial;

  const factory CategoriesState.loading({
    required List<CategoryModel> categories,
    required List<CategoryModel> searchCategories,
  }) = _Loading;

  const factory CategoriesState.loaded({
    required List<CategoryModel> categories,
    required List<CategoryModel> searchCategories,
  }) = _Loaded;

  const factory CategoriesState.changedSearch({
    required List<CategoryModel> categories,
    required List<CategoryModel> searchCategories,
  }) = _ChangedSearch;

  const factory CategoriesState.error({
    required List<CategoryModel> categories,
    required List<CategoryModel> searchCategories,
    required Exception exception,
  }) = _Error;
}
