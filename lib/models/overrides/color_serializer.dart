import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

/// Used by [JsonSerializable] to serialize/deserialize [Color] object.
class ColorSerializer implements JsonConverter<Color, int> {
  const ColorSerializer();

  @override
  Color fromJson(int json) => Color(json);

  @override
  int toJson(Color color) => color.value;
}
