import 'dart:math';

import 'package:flutter/material.dart';

/// Paints captured signature strokes. [fitToBounds] scales the ink to fit
/// preview thumbnails; live pads pass [fitToBounds: false].
class OpenAccountSignaturePainter extends CustomPainter {
  OpenAccountSignaturePainter({
    required this.strokes,
    required this.color,
    this.fitToBounds = false,
  });

  final List<List<Offset?>> strokes;
  final Color color;
  final bool fitToBounds;

  Rect? _computeBounds() {
    double? minX;
    double? minY;
    double? maxX;
    double? maxY;

    for (final stroke in strokes) {
      for (final point in stroke) {
        if (point == null) continue;
        minX = minX == null ? point.dx : min(minX, point.dx);
        minY = minY == null ? point.dy : min(minY, point.dy);
        maxX = maxX == null ? point.dx : max(maxX, point.dx);
        maxY = maxY == null ? point.dy : max(maxY, point.dy);
      }
    }

    if (minX == null || minY == null || maxX == null || maxY == null) {
      return null;
    }

    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  void _drawStrokes(Canvas canvas, Paint paint) {
    for (final stroke in strokes) {
      final points = <Offset>[];
      for (final point in stroke) {
        if (point != null) points.add(point);
      }
      if (points.isEmpty) continue;

      if (points.length == 1) {
        canvas.drawCircle(points.first, paint.strokeWidth / 2, paint);
        continue;
      }

      final path = Path()..moveTo(points.first.dx, points.first.dy);
      for (var i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    if (!fitToBounds) {
      _drawStrokes(canvas, paint);
      return;
    }

    final bounds = _computeBounds();
    if (bounds == null) return;

    const padding = 12.0;
    final contentWidth = max(bounds.width, 1.0);
    final contentHeight = max(bounds.height, 1.0);
    final availableWidth = max(size.width - padding * 2, 1.0);
    final availableHeight = max(size.height - padding * 2, 1.0);
    final scale = min(
      availableWidth / contentWidth,
      availableHeight / contentHeight,
    );

    canvas.save();
    canvas.translate(
      padding + (availableWidth - contentWidth * scale) / 2 - bounds.left * scale,
      padding + (availableHeight - contentHeight * scale) / 2 - bounds.top * scale,
    );
    canvas.scale(scale);
    _drawStrokes(canvas, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
