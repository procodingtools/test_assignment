// ignore_for_file: invalid_annotation_target

import 'dart:core';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_assignment/models/segmentation.dart';

part 'dataset.freezed.dart';
part 'dataset.g.dart';

@unfreezed
class DatasetModel with _$DatasetModel {
  @JsonSerializable()
   factory DatasetModel({
    @JsonKey(name: 'image_id') required int id,
    @JsonKey() required String segmentation,
    @JsonKey(name: 'category_id') required int categoryId,
    @JsonKey() @Default(<String>[]) List<String> images,
    @JsonKey() double? ratio,
    @JsonKey() @Default(<String>[]) List<String> captions,
    @JsonKey() @Default([]) List<SegmentationModel> segmentations,
  }) = _DatasetModel;


  factory DatasetModel.fromJson(Map<String, dynamic> json) => _$DatasetModelFromJson(json);
}