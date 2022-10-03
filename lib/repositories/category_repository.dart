import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:test_assignment/app/constants.dart';
import 'package:test_assignment/models/category.dart';
import 'package:test_assignment/services/cateories.dart';

/// {@template category_repository}
/// Category repository handles fetching categories from the Metadata API
/// {@endtemplate}
class CategoryRepository {
  /// {@macro category_repository}
  CategoryRepository({CategoriesService? service})
      : service = service ?? CategoriesService();

  final CategoriesService service;

  /// Returns list of [CategoryModel] from the got js file from the official
  /// website. getting the `catToId` object and parse it to list
  Future<List<CategoryModel>> getCategories() async {
    String response = await service.getBaseJsFile();
    List<CategoryModel> categories = [];
    final start = response.indexOf('var catToId = {');
    response = response.substring(start);
    response = response.substring(0, response.indexOf('}') + 1);
    response = response.replaceAll('\'', '"');
    response = response.replaceAll('var catToId = ', '');
    Map.of(jsonDecode(response)).forEach((key, value) {
      categories.add(CategoryModel(
          id: value,
          name: key,
          icon: '${dotenv.get(cocoExplorer)}images/cocoicons/$value.jpg'));
    });
    return categories;
  }
}
