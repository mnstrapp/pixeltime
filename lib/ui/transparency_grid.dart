import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'grid_provider.dart';

class TransparencyGrid extends ConsumerWidget {
  static final Map<Size, ui.Image> _images = {};
  final Size size;

  const TransparencyGrid({super.key, required this.size});

  Future<ui.Image> _buildTransperancyGrid(WidgetRef ref, Size size) async {
    final pixelSize = ref.read(pixelSizeProvider);
    final scale = ref.read(pixelScaleProvider);
    final gridSize = pixelSize.toDouble() * scale;
    final gridWidth = size.width ~/ gridSize;
    final gridHeight = size.height ~/ gridSize;

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    canvas.scale(scale);

    bool alternate = true;
    final greyColor = Colors.grey[300] ?? Colors.grey;

    for (var i = 0; i < gridWidth + 1; i++) {
      alternate = !alternate;
      for (var j = 0; j < gridHeight + 1; j++) {
        canvas.drawRect(
          Rect.fromLTWH(i * gridSize, j * gridSize, gridSize, gridSize),
          Paint()
            ..color = j % 2 == 0
                ? alternate
                      ? Colors.white
                      : greyColor
                : alternate
                ? greyColor
                : Colors.white,
        );
      }
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(
      (size.width * scale).ceil(),
      (size.height * scale).ceil(),
    );
    return image;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (_images.containsKey(size)) {
      final image = _images[size]!;
      return CustomPaint(
        size: Size(
          image.width.toDouble(),
          image.height.toDouble(),
        ),
        painter: _TransparencyPainter(image: image),
      );
    }

    return FutureBuilder(
      future: _buildTransperancyGrid(ref, size),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }
        final image = snapshot.data!;
        _images[size] = image;
        return CustomPaint(
          size: Size(
            snapshot.data!.width.toDouble(),
            snapshot.data!.height.toDouble(),
          ),
          painter: _TransparencyPainter(image: snapshot.data!),
        );
      },
    );
  }
}

class _TransparencyPainter extends CustomPainter {
  final ui.Image image;

  _TransparencyPainter({required this.image});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(image, Offset.zero, Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
