import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_assignment/features/categories/cubits/categories_cubit.dart';
import 'package:test_assignment/models/category.dart';
import 'package:test_assignment/models/dataset.dart';
import 'package:test_assignment/repositories/dataset_repository.dart';

part 'dataset_cubit.freezed.dart';

part 'dataset_state.dart';

/// {@category Datasets}
/// {@subCategory Cubits}
/// [Cubit] to manage and handle dataset changes. Interacting with
/// [CategoriesCubit] to all got [CategoryModel] list.
class DatasetCubit extends Cubit<DatasetState> {
  DatasetCubit({DatasetRepository? repository, required this.categoryCubit})
      : repository = repository ?? DatasetRepository(),
        super(const _Initial());

  final DatasetRepository repository;
  final CategoriesCubit categoryCubit;

  /// Searching for categories.
  Future<void> search() async {
      emit(const DatasetState.loading(datasets: <DatasetModel>[]));
    List<DatasetModel> datasets = List<DatasetModel>.from(state.datasets);
    try {
      final response = await repository.searchDataset(categoryCubit.state.searchCategories, categoryCubit.state.categories);
      datasets.addAll(response);
      if (response.length < 5) {
        emit(DatasetState.finished(datasets: response));
      } else {
        emit(DatasetState.loaded(datasets: response));
      }
    } on Exception catch (e) {
      emit(DatasetState.error(datasets: state.datasets, exception: e));
    }
  }

  /// Getting next 5 results.
  Future<void> nextPage() async {
    List<DatasetModel> datasets = List<DatasetModel>.from(state.datasets);
    try {
      final response = await repository.getNextDatasets(categoryCubit.state.categories);
      datasets.addAll(response);
      if (response.length < 5) {
        emit(DatasetState.finished(datasets: datasets));
      } else {
        emit(DatasetState.loaded(datasets: datasets));
      }
    } on Exception catch (e) {
      emit(DatasetState.error(datasets: datasets, exception: e));
    }
  }
}
