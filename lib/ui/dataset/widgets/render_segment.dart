
import 'package:flutter/material.dart';
import 'package:test_assignment/models/segmentation.dart';

/// {@category Datasets}
/// {@subCategory Widgets}
/// Widget to draw segments.
class RenderSegments extends StatelessWidget {
  const RenderSegments({
    Key? key,
    required this.segments, required this.ratio,
  }) : super(key: key);

  /// [SegmentationModel] list
  final SegmentationModel segments;

  /// ratio
  final double ratio;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _SegmentPath(segments, ratio),
          child: Container(),
        ),
      ),
    );
  }
}

class _SegmentPath extends CustomPainter {
  SegmentationModel segmentation;
  final double ratio;

  _SegmentPath(this.segmentation, this.ratio);

  @override
  void paint(Canvas canvas, Size size) {
    final segments = segmentation.segmentations;
    Path path = Path();
    Paint paint = Paint();
    for (final segment in segments) {
      path.moveTo(segment[0] * ratio, segment[1] * ratio);
      for (int i = 0; i < segment.length - 2; i += 2) {
        path.lineTo(segment[i + 2] * ratio, segment[i + 3] * ratio);
      }
      path.moveTo(segment[0] * ratio, segment[1] * ratio);
    }
    path.close();

    paint.color = segmentation.color;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
