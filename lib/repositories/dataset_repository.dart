import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:test_assignment/features/dataset/cubits/dataset_cubit.dart';
import 'package:test_assignment/models/dataset.dart';
import 'package:test_assignment/models/segmentation.dart';
import 'package:test_assignment/services/dataset.dart';

class DatasetRepository {
  DatasetRepository({DatasetService? service})
      : service = service ?? DatasetService();
  final DatasetService service;

  final List<int> _allIds = [];

  Future<List<DatasetModel>> searchDataset(DatasetCubit datasetCubit) async {
    final categories = datasetCubit.categoryCubit.state.searchCategories;
    if (categories.isEmpty) {
      return <DatasetModel>[];
    }
    _allIds.clear();
    _allIds.addAll(await service.getImagesByCats(categories));
    return await getNextDatasets(datasetCubit);
  }

  Future<List<DatasetModel>> getNextDatasets(DatasetCubit datasetCubit) async {
    List<int> ids = [];
    List<DatasetModel> datasets = [];
    for (int i = 0; i < 5 && _allIds.isNotEmpty; i++) {
      int index = Random().nextInt(_allIds.length);
      index = index % _allIds.length;
      ids.add(_allIds[index]);
      _allIds.removeAt(index);
    }
    if (ids.isEmpty) {
      return datasets;
    }

    final results = await Future.wait([
      service.getInstances(ids),
      service.getMap(imageIds: ids, type: MapType.images),
      service.getMap(imageIds: ids, type: MapType.captions),
    ]);

    datasets.addAll(results[0] as List<DatasetModel>);

    for (int i = 0; i < datasets.length; i++) {
      try {
        List<SegmentationModel> segmentations = [];

        final segmentationsMap = datasets
            .where((element) => element.id == datasets[i].id)
            .map((e) =>
                {'category_id': e.categoryId, 'segmentation': e.segmentation});

        for (final map in segmentationsMap) {
          final list = segmentations
              .where((element) => element.category.id == map['category_id']);
          SegmentationModel segmentation;
          if (list.isEmpty) {
            segmentation = SegmentationModel.empty();
            segmentation.category = datasetCubit.categoryCubit.state.categories
                .firstWhere((element) => element.id == map['category_id']);
            segmentations.add(segmentation);
          } else {
            segmentation = list.first;
          }
          try {
            final segments = List.of(jsonDecode(map['segmentation'].toString()));
            for (List segment in segments) {
              segmentation.segmentations.add(segment.cast<double>());
            }
          } catch (e) {
            print(e);
          }

          segmentation.color =
              Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(.5);
        }

        datasets[i] = datasets[i].copyWith(segmentations: segmentations);
        datasets.removeWhere((element) =>
            element != datasets[i] && element.id == datasets[i].id);
      } on RangeError {
        break;
      }
    }

    for (int i = 0; i < datasets.length; i++) {
      List<String> captions = List.from(datasets[i].captions);
      List<String> images = List.from(datasets[i].images);
      captions.addAll(List.of(results[2] as List<Map<String, dynamic>>)
          .where((e) => e['image_id'] == datasets[i].id)
          .map((e) => e['caption']));

      final urls = List.of(results[1] as List<Map<String, dynamic>>)
          .firstWhere((element) => element['id'] == datasets[i].id);

      images.addAll([urls['coco_url'], urls['flickr_url']]);

      datasets[i] = datasets[i].copyWith(images: images, captions: captions);
    }
    return datasets;
  }
}
