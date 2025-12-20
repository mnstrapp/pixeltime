import 'package:flutter/material.dart';
import 'dart:ui' as ui;

Future<ui.Image> buildTransperancyGrid(Size size, double scale) async {
  final gridSize = 10 * scale;
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

class TransparencyGrid extends StatefulWidget {
  final Size size;
  final double scale;

  const TransparencyGrid({super.key, required this.size, this.scale = 1.0});

  @override
  State<TransparencyGrid> createState() => _TransparencyGridState();
}

class _TransparencyGridState extends State<TransparencyGrid> {
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final image = await buildTransperancyGrid(widget.size, widget.scale);
      setState(() {
        _image = image;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_image == null) {
      return const SizedBox.shrink();
    }
    return CustomPaint(
      size: widget.size,
      painter: _TransparencyPainter(image: _image!),
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
