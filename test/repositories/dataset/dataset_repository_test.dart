import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:test_assignment/models/category.dart';
import 'package:test_assignment/models/dataset.dart';
import 'package:test_assignment/models/segmentation.dart';
import 'package:test_assignment/repositories/dataset_repository.dart';
import 'package:test_assignment/services/dataset_service.dart';

Future<void> main() async {
  late DatasetRepository repository;
  late DioAdapter dioAdapter;
  late DatasetService service;

  await dotenv.load();

  setUp(() {
    service = DatasetService();
    dioAdapter = DioAdapter(dio: service.dio);
    service.dio.httpClientAdapter = dioAdapter;
    repository = DatasetRepository(service: service);
  });

  const categories = [
    CategoryModel(id: 1, name: 'test1', icon: 'http://icons.com/1.jpg'),
    CategoryModel(id: 2, name: 'test2', icon: 'http://icons.com/2.jpg')
  ];

  final searchCategories = [categories[0]];

  const imagesIds = [571334, 26190];

  const images = [
    {
      "id": 571334,
      "coco_url": "http://images.cocodataset.org/train2017/000000571334.jpg",
      "flickr_url":
      "http://farm2.staticflickr.com/1219/1198665807_119b20d754_z.jpg"
    },
    {
      "id": 26190,
      "coco_url": "http://images.cocodataset.org/train2017/000000026190.jpg",
      "flickr_url":
      "http://farm5.staticflickr.com/4101/4898075349_070ef6175c_z.jpg"
    }
  ];

  const instances = [
    {
      "image_id": 571334,
      "segmentation": "[[398.38, 540.76, 372.49, 523.51]]",
      "category_id": 1
    },
    {
      "image_id": 26190,
      "segmentation": "[[398.38, 540.76, 372.49, 523.51]]",
      "category_id": 2
    },
  ];

  const captions = [
    {
      "caption": "An old black and white photograph of a woman and children.",
      "image_id": 26190
    },
    {
      "caption":
      "A woman standing near a fence with several children gathered around her.",
      "image_id": 571334
    },
  ];

  group('Search dataset by categories', () {
    late List<DatasetModel> datasets;
    setUp(() async {
      dioAdapter.onPost(
          'coco-dataset-bigquery',
          data: {
            'category_ids': searchCategories.map((e) => e.id).toList(),
            'querytype': 'getImagesByCats',
          },
              (server) => server.reply(200, imagesIds));

      dioAdapter.onPost('coco-dataset-bigquery', data: {
        'image_ids': imagesIds, 'querytype': 'getInstances'
      }, (server) => server.reply(200, instances));
      dioAdapter.onPost('coco-dataset-bigquery', data: {
        'image_ids': imagesIds,
        'querytype': 'getImages'
      }, (server) => server.reply(200, images));
      dioAdapter.onPost('coco-dataset-bigquery', data: {
        'image_ids': imagesIds,
        'querytype': 'getCaptions'
      }, (server) => server.reply(200, captions));


      /// Trying with reversed list. the repository using random to randomize images
      dioAdapter.onPost('coco-dataset-bigquery', data: {
        'image_ids': imagesIds.reversed.toList(), 'querytype': 'getInstances'
      }, (server) => server.reply(200, instances));
      dioAdapter.onPost('coco-dataset-bigquery', data: {
        'image_ids': imagesIds.reversed.toList(),
        'querytype': 'getImages'
      }, (server) => server.reply(200, images));
      dioAdapter.onPost('coco-dataset-bigquery', data: {
        'image_ids': imagesIds.reversed.toList(),
        'querytype': 'getCaptions'
      }, (server) => server.reply(200, captions));

      datasets = await repository.searchDataset(searchCategories, categories);
    });
    test('Testing if response is DatasetModel list', () =>
        expect(datasets, isA<List<DatasetModel>>()));
    test('Testing if the list has length == 2', () =>
        expect(datasets, hasLength(2)));
    test('Testing Segmentations', () =>
        expect(datasets.first.segmentations, isA<List<SegmentationModel>>()));
    test('testing if color is ganarated successfully', () =>
        expect(datasets.first.segmentations.first.color,
            isNot(equals(Colors.transparent))));
  });
}
