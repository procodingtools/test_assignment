import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_assignment/features/dataset/providers/dataset_item_header_change_notifier.dart';
import 'package:test_assignment/models/dataset.dart';
import 'package:test_assignment/ui/dataset/widgets/dataset_items_header.dart';
import 'package:test_assignment/ui/dataset/widgets/render_segment.dart';
import 'package:test_assignment/ui/common/widgets/image_view.dart';

/// {@category Datasets}
/// {@subCategory Widgets}
/// Widget to show [DatasetItemsHeader], image and overlays over the image basing
/// on selected categories to show.
class DatasetView extends StatelessWidget {
  const DatasetView({Key? key, required this.dataset}) : super(key: key);

  /// [DatasetModel] dataset.
   final DatasetModel dataset;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DatasetItemHeaderChangeNotifier>(
      create: (context) => DatasetItemHeaderChangeNotifier(),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DatasetItemsHeader(dataset: dataset),
            Stack(
              children: [
                ImageView(dataset.images.first, onRatioChanged: (ratio) => dataset.ratio = ratio,),
                Positioned.fill(
                    child: Consumer<DatasetItemHeaderChangeNotifier>(
                      builder: (context, items, _) => Stack(
                        children: [
                          if (items.selectedCategories.isNotEmpty)
                            ...items
                                .getSegments(dataset, context)
                                .map((e) => RenderSegments(
                              segments: e,
                              ratio: dataset.ratio!,
                            ))
                        ],
                      ),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
