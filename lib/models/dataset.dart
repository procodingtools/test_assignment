import 'package:freezed_annotation/freezed_annotation.dart';

part 'dataset.freezed.dart';
part 'dataset.g.dart';

@freezed
class DatasetModel with _$DatasetModel {
  @JsonSerializable()
   const factory DatasetModel({
    @JsonKey(name: 'image_id') required int id,
    @JsonKey() required String segmentation,
    @JsonKey() @Default(<String>[]) segmentations,
    @JsonKey(name: 'category_id') required int categoryId,
    @JsonKey() @Default(<String>[]) List<String> images,
    @JsonKey() @Default(<String>[]) List<String> captions,

  }) = _DatasetModel;

  factory DatasetModel.fromJson(Map<String, dynamic> json) => _$DatasetModelFromJson(json);
}