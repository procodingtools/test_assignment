// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';

part 'category.g.dart';

@freezed
class CategoryModel with _$CategoryModel {
  @JsonSerializable()
  const factory CategoryModel({
    @JsonKey(name: 'id') @Default(0) int id,
    @JsonKey(name: 'name') @Default('N/A') String name,
    @JsonKey(name: 'icon') @Default('') String icon,
  }) = _CategoryModel;


  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}
