// ignore_for_file: invalid_annotation_target

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_assignment/models/category.dart';
import 'package:test_assignment/models/overrides/color_serializer.dart';

part 'segmentation.freezed.dart';

part 'segmentation.g.dart';

@unfreezed
class SegmentationModel with _$SegmentationModel {
  @JsonSerializable()
  factory SegmentationModel({
    @JsonKey() required CategoryModel category,
    @JsonKey() required List<List<double>> segmentations,
    @JsonKey() @ColorSerializer() @Default(Colors.transparent) Color color,
  }) = _SegmentationModel;

  factory SegmentationModel.empty() {
    return SegmentationModel(
        category: const CategoryModel(), segmentations: [], color: Colors.transparent);
  }

  factory SegmentationModel.fromJson(Map<String, dynamic> json) =>
      _$SegmentationModelFromJson(json);
}
