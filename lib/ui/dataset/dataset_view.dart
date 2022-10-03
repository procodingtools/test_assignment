import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';
import 'package:test_assignment/app/constants.dart';
import 'package:test_assignment/features/dataset/cubits/dataset_cubit.dart';
import 'package:test_assignment/models/category.dart';
import 'package:test_assignment/models/dataset.dart';
import 'package:test_assignment/models/segmentation.dart';
import 'package:test_assignment/ui/categorties/widgets/category_button.dart';
import 'package:test_assignment/ui/dataset/widgets/render_segment.dart';
import 'package:url_launcher/url_launcher.dart';

class DatasetView extends StatelessWidget {

  DatasetView({Key? key, required this.dataset}) : super(key: key);

   late DatasetModel dataset;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_ItemsToShow>(
      create: (context) => _ItemsToShow(),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<_ItemsToShow>(
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
                          onTap: dataset.ratio == null ? null : () {
                            items.toggleCategory(e.category);
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
                )),
            Stack(
              children: [
                _ImageView(dataset: dataset,),
                Positioned.fill(
                    child: Consumer<_ItemsToShow>(
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


class _ImageView extends StatefulWidget {

  const _ImageView({super.key, required this.dataset});

  final DatasetModel dataset;

  @override
  createState() => _ImageViewState();
}

class _ImageViewState extends State<_ImageView> {
  final ValueNotifier<Uint8List?> _image = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _getImage(widget.dataset).then((value) {
      _image.value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Uint8List?>(
        valueListenable: _image,
        builder: (context, image, _) {
          return image == null
              ? const SizedBox(
            height: 100,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
              : Image.memory(image);
        });
  }

  Future<Uint8List?> _getImage(DatasetModel dataset) async {
    Dio dio = Dio(BaseOptions(responseType: ResponseType.bytes));
    print('called');
    final image = (await dio.get(dataset.images.first)).data;

    final resized = await compute(resizeImage, image as List<int>);
    dataset.ratio = resized['ratio'];
    return resized['image'];
  }
}


class _ItemsToShow extends ChangeNotifier {
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

/// Setting resizing image as isolate to prevent main thread from being blocked
Future<Map<String, dynamic>> resizeImage(List<int> image) async {
  final original = Uint8List.fromList(image);
  final originalImage = img.decodeImage(original)!;


  final ratio = min(maxImageSize / originalImage.width, maxImageSize / originalImage.height);

  final resizedImage = img.copyResize(originalImage,
      width: (originalImage.width * ratio).toInt(),
      height: (originalImage.height * ratio).toInt());

  return {
    'image': Uint8List.fromList(img.encodeJpg(resizedImage)),
    'ratio': ratio
  };
}
