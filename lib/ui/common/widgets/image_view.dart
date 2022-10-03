import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:test_assignment/app/constants.dart';

/// Fetching and resizing image from given [url]. When finished, will call
/// [onRatioChanged] callback to send the new image ratio after resize.
class ImageView extends StatefulWidget {
  const ImageView(this.url, {super.key, this.onRatioChanged});

  final String url;
  final Function(double ratio)? onRatioChanged;

  @override
  createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  Uint8List? _image;

  @override
  void initState() {
    super.initState();
    _getImage().then((value) {
      setState(() {
        _image = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _image == null
        ? const SizedBox(
            height: 100,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Image.memory(
            _image!,
          );
  }

  /// returning [Uint8List] contains the got and resized image and calling
  /// [onRatioChanged] callback if not null.
  Future<Uint8List> _getImage() async {
    Dio dio = Dio(BaseOptions(responseType: ResponseType.bytes));
    final image = (await dio.get(widget.url)).data;

    final resized = await compute(
      resizeImage,
      {
        'image': image as List<int>,
        'size': MediaQuery.of(context).size.width * maxImageRatio
      },
    );
    if (widget.onRatioChanged != null) {
      widget.onRatioChanged!(resized['ratio']);
    }
    return resized['image'];
  }
}

/// Setting resizing image as isolate to prevent main thread from being blocked
/// returning [Map] contains the resized image bytes and ratio
Future<Map<String, dynamic>> resizeImage(Map<String, dynamic> data) async {
  final image = data['image'];
  final maxRatio = data['size'] as double;
  final original = Uint8List.fromList(image);
  final originalImage = img.decodeImage(original)!;

  final ratio =
      min(maxRatio / originalImage.width, maxRatio / originalImage.height);

  final resizedImage = img.copyResize(originalImage,
      width: (originalImage.width * ratio).toInt(),
      height: (originalImage.height * ratio).toInt());

  return {
    'image': Uint8List.fromList(img.encodeJpg(resizedImage)),
    'ratio': ratio
  };
}
