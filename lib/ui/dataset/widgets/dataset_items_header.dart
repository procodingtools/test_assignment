import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_assignment/features/dataset/providers/dataset_item_header_change_notifier.dart';
import 'package:test_assignment/models/dataset.dart';
import 'package:test_assignment/ui/categories/widgets/category_button.dart';
import 'package:url_launcher/url_launcher.dart';

/// {@category Datasets}
/// {@subCategory Widgets}
/// Widget to select which items/segments to show.
class DatasetItemsHeader extends StatelessWidget {
  const DatasetItemsHeader({Key? key, required this.dataset}) : super(key: key);

  /// [DatasetModel] dataset
  final DatasetModel dataset;

  @override
  Widget build(BuildContext context) {
    return Consumer<DatasetItemHeaderChangeNotifier>(
        builder: (context, items, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                InkWell(
                  onTap: () => items.toggleShowUrl(),
                  child: Container(
                    height: 39,
                    width: 39,
                    decoration: BoxDecoration(
                      border:
                      Border.all(color: Colors.black, width: 2),
                      color: items.showUrls ? Colors.green : null,
                    ),
                    child: const Center(
                        child: Text(
                          'URL',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        )),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () => items.toggleShowCaptions(),
                  child: Container(
                    height: 39,
                    width: 39,
                    decoration: BoxDecoration(
                      border:
                      Border.all(color: Colors.black, width: 2),
                      color:
                      items.showCaptions ? Colors.green : null,
                    ),
                    child: const Center(
                        child: Icon(
                          Icons.list,
                          size: 30,
                        )),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ...dataset.segmentations
                    .map((e) => CategoryButton(
                  category: e.category,
                  onTap: () {
                    if (dataset.ratio != null) {
                      items.toggleCategory(e.category);
                    }
                  },
                  selected: items.selectedCategories
                      .contains(e.category),
                ))
                    .toList(),
              ],
            ),
            if (items.showUrls) ...[
              const SizedBox(
                height: 15,
              ),
              ...dataset.images
                  .map((e) => InkWell(
                onTap: () => launchUrl(Uri.parse(e)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    e,
                    style: const TextStyle(
                        color: Colors.blue,
                        decoration:
                        TextDecoration.underline),
                  ),
                ),
              ))
                  .toList(),
              const SizedBox(
                height: 15,
              ),
            ],
            if (items.showCaptions) ...[
              const SizedBox(
                height: 15,
              ),
              ...dataset.captions
                  .map((e) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: SelectableText(
                  e,
                  style:
                  const TextStyle(color: Colors.black),
                ),
              ))
                  .toList(),
              const SizedBox(
                height: 15,
              ),
            ],
          ],
        ));
  }
}
