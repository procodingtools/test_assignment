part of 'dataset_cubit.dart';

@freezed
class DatasetState with _$DatasetState {
  const factory DatasetState.initial({
    @Default(<DatasetModel>[]) List<DatasetModel> datasets,
  }) = _Initial;

  const factory DatasetState.loading({
    required List<DatasetModel> datasets,
  }) = _Loading;

  const factory DatasetState.loaded({
    required List<DatasetModel> datasets,
  }) = _Loaded;

  const factory DatasetState.finished({
    required List<DatasetModel> datasets,
  }) = _Finished;

  const factory DatasetState.error({
    required List<DatasetModel> datasets,
    required Exception exception,
  }) = _Error;

}