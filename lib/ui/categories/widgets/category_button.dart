import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:test_assignment/models/category.dart';

/// Category button.
class CategoryButton extends StatelessWidget {
  const CategoryButton(
      {Key? key,
      required this.category,
      required this.onTap,
      this.selected = false})
      : super(key: key);

  /// [CategoryModel]
  final CategoryModel category;

  /// Callback when button pressed
  final VoidCallback? onTap;

  /// Selected status.
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: category.name,
      child: IconButton(
          onPressed: onTap,
          iconSize: 40,
          icon: CachedNetworkImage(
            imageUrl: category.icon,
            fit: BoxFit.fill,
            color: selected ? Colors.green : null,
            colorBlendMode: selected ? BlendMode.multiply : null,
          )),
    );
  }
}
