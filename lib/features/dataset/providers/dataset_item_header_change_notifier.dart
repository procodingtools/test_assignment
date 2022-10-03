import 'package:flutter/material.dart';
import 'package:test_assignment/models/category.dart';
import 'package:test_assignment/models/dataset.dart';
import 'package:test_assignment/models/segmentation.dart';
import 'package:test_assignment/ui/dataset/dataset_view.dart';

/// {@subCategory Notifiers}
/// {@category Datasets}
/// Notifying [DatasetView] and [DatasetItemHeader] by selected items.
class DatasetItemHeaderChangeNotifier extends ChangeNotifier {
  List<CategoryModel> selectedCategories = [];
  bool showUrls = false;
  bool showCaptions = false;

  void toggleShowUrl() {
    showUrls = !showUrls;
    showCaptions = false;
    notifyListeners();
  }

  void toggleShowCaptions() {
    showCaptions = !showCaptions;
    showUrls = false;
    notifyListeners();
  }

  toggleCategory(CategoryModel category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }

    notifyListeners();
  }

  void clearSelected() {
    selectedCategories.clear();
    notifyListeners();
  }

  /// Getting all selected categories segmentation to show the overlay over the
  /// image.
  List<SegmentationModel> getSegments(
      DatasetModel dataset, BuildContext context) {
    List<SegmentationModel> segments = [];
    for (var selectedCategory in selectedCategories) {
      dataset.segmentations
          .where(
              (segmentation) => segmentation.category.id == selectedCategory.id)
          .forEach((selectedSegments) {
        segments.add(selectedSegments);
      });
    }

    return segments;
  }
}