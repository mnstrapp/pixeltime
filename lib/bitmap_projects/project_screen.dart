import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import '../models/bitmap_project.dart';
import '../models/bitmap_project_layer.dart';
import '../ui/grid_provider.dart';
import '../ui/theme.dart';
import 'layers/layers_widget.dart';
import 'tools/color_provider.dart';
import 'tools/tools_widget.dart';
import '../ui/transparency_grid.dart';

class BitmapProjectScreen extends ConsumerStatefulWidget {
  final BitmapProject project;
  const BitmapProjectScreen({super.key, required this.project});

  @override
  ConsumerState<BitmapProjectScreen> createState() =>
      _BitmapProjectScreenState();
}

class _BitmapProjectScreenState extends ConsumerState<BitmapProjectScreen>
    with WindowListener {
  Size _size = Size.zero;

  Future<void> _resize() async {
    final size = await windowManager.getSize();
    setState(() {
      _size = size;
    });
  }

  Widget _buildLayer(BitmapProjectLayer layer) {
    return _LayerCanvas(layer: layer);
  }

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _resize();
    });
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowResize() {
    _resize();
  }

  @override
  Widget build(BuildContext context) {
    if (_size == Size.zero) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        TransparencyGrid(size: _size),
        Stack(
          children: [
            for (final layer in widget.project.layers)
              Positioned(
                left: layer.x.toDouble(),
                top: layer.y.toDouble(),
                child: _buildLayer(layer),
              ),
          ],
        ),
        Positioned(
          left: BaseTheme.borderRadiusMedium,
          top: 0,
          bottom: 0,
          child: Center(
            child: BitmapProjectToolsWidget(project: widget.project),
          ),
        ),
        Positioned(
          right: BaseTheme.borderRadiusMedium,
          top: 0,
          bottom: 0,
          child: Center(
            child: BitmapProjectLayersWidget(project: widget.project),
          ),
        ),
      ],
    );
  }
}

class _LayerCanvas extends ConsumerStatefulWidget {
  final BitmapProjectLayer layer;
  const _LayerCanvas({required this.layer});

  @override
  ConsumerState<_LayerCanvas> createState() => _LayerCanvasState();
}

class _LayerCanvasState extends ConsumerState<_LayerCanvas> {
  BitmapProjectLayer? _layer;

  @override
  void initState() {
    super.initState();
    _layer = widget.layer.copyWith(
      x: widget.layer.x,
      y: widget.layer.y,
      width: widget.layer.width,
      height: widget.layer.height,
      pixels: widget.layer.pixels,
    );
  }

  Future<ui.Image> _buildImage(WidgetRef ref) async {
    final pixelSize = ref.read(pixelSizeProvider);
    final scale = ref.read(pixelScaleProvider);
    final gridSize = pixelSize.toDouble() * scale;

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    canvas.scale(scale);

    int maxX = 0;
    int maxY = 0;
    for (var pixel in _layer!.pixels) {
      if (pixel.x > maxX) {
        maxX = pixel.x;
      }
      if (pixel.y > maxY) {
        maxY = pixel.y;
      }
    }

    for (var pixel in _layer!.pixels) {
      canvas.drawRect(
        Rect.fromLTWH(
          (pixel.x.toDouble() ~/ gridSize) * gridSize,
          (pixel.y.toDouble() ~/ gridSize) * gridSize,
          gridSize,
          gridSize,
        ),
        Paint()..color = pixel.color,
      );
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(
      (_layer!.width.toDouble() * scale).ceil(),
      (_layer!.height.toDouble() * scale).ceil(),
    );
    picture.dispose();
    return image;
  }

  Future<void> _paint(DragDownDetails details) async {
    final pixelSize = ref.read(pixelSizeProvider);
    final scale = ref.read(pixelScaleProvider);
    final gridSize = pixelSize.toDouble() * scale;
    final dx = details.globalPosition.dx.toInt();
    final dy = details.globalPosition.dy.toInt();

    int xDiff = 0;
    int yDiff = 0;

    if (dx < _layer!.x) {
      xDiff = _layer!.x - dx;
    } else if (dx >= _layer!.x + _layer!.width) {
      xDiff = dx - (_layer!.x + _layer!.width);
    }

    if (dy < _layer!.y) {
      yDiff = _layer!.y - dy;
    } else if (dy >= _layer!.y + _layer!.height) {
      yDiff = dy - (_layer!.y + _layer!.height);
    }

    final color = ref.read(bitmapProjectToolColorProvider);
    setState(() {
      _layer!.height = (_layer!.height + yDiff).toInt() + gridSize.toInt();
      _layer!.width = (_layer!.width + xDiff).toInt() + gridSize.toInt();
      _layer!.pixels.add(BitmapProjectPixel(color: color, x: dx, y: dy));
    });
    final (_, saveError) = await _layer!.save();
    if (saveError != null) {
      debugPrint('saveError: $saveError');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return FutureBuilder(
      future: _buildImage(ref),
      builder: (context, snapshot) {
        Widget? child;
        if (snapshot.connectionState == ConnectionState.done) {
          child = CustomPaint(
            size: Size(
              snapshot.data!.width.toDouble(),
              snapshot.data!.height.toDouble(),
            ),
            painter: _LayerPainter(image: snapshot.data!),
          );
        }
        return Stack(
          children: [
            if (child != null) child,
            GestureDetector(
              onPanDown: (details) => _paint(details),
              child: Container(
                width: size.width,
                height: size.height,
                color: Colors.transparent,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LayerPainter extends CustomPainter {
  final ui.Image image;
  const _LayerPainter({required this.image});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(image, Offset.zero, Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
