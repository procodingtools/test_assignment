import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_assignment/models/category.dart';
import 'package:test_assignment/models/dataset.dart';
import 'package:test_assignment/repositories/dataset.dart';

part 'dataset_cubit.freezed.dart';

part 'dataset_state.dart';

class DatasetCubit extends Cubit<DatasetState> {
  DatasetCubit({DatasetRepository? repository})
      : repository = repository ?? DatasetRepository(),
        super(const _Initial());

  final DatasetRepository repository;

  Future<void> search(List<CategoryModel> categories) async {
      emit(const DatasetState.loading(datasets: <DatasetModel>[]));
    List<DatasetModel> datasets = List<DatasetModel>.from(state.datasets);
    try {
      final response = await repository.searchDataset(categories);
      datasets.addAll(response);
      if (response.length < 5) {
        emit(DatasetState.finished(datasets: state.copyWith(datasets: [...state.datasets, ...response]).datasets));
      } else {
        emit(DatasetState.loaded(datasets: state.copyWith(datasets: [...state.datasets, ...response]).datasets));
      }
    } on Exception catch (e) {
      emit(DatasetState.error(datasets: state.datasets, exception: e));
    }
  }

  Future<void> nextPage() async {
    List<DatasetModel> datasets = List<DatasetModel>.from(state.datasets);
    try {
      final response = await repository.getNextDatasets();
      datasets.addAll(response);
      if (response.length < 5) {
        emit(DatasetState.finished(datasets: state.copyWith(datasets: [...state.datasets, ...response]).datasets));
      } else {
        emit(DatasetState.loaded(datasets: state.copyWith(datasets: [...state.datasets, ...response]).datasets));
      }
    } on Exception catch (e) {
      emit(DatasetState.error(datasets: state.datasets, exception: e));
    }
  }
}
