import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import '../models/bitmap_project.dart';
import '../models/bitmap_project_layer.dart';
import '../ui/grid_provider.dart';
import '../ui/theme.dart';
import 'bitmap_projects_provider.dart';
import 'layers/layers_provider.dart';
import 'layers/layers_widget.dart';
import 'tools/color_provider.dart';
import 'tools/tool.dart';
import 'tools/tools_provider.dart';
import 'tools/tools_widget.dart';
import '../ui/transparency_grid.dart';

class BitmapProjectScreen extends ConsumerStatefulWidget {
  final String projectId;
  const BitmapProjectScreen({super.key, required this.projectId});

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
    return _LayerCanvas(id: layer.id!);
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

    final projects = ref.watch(bitmapProjectsProvider);
    if (projects.isEmpty) {
      return const SizedBox.shrink();
    }

    BitmapProject? project;
    if (projects.any((project) => project.id == widget.projectId)) {
      project = projects.firstWhere(
        (project) => project.id == widget.projectId,
      );
    }
    if (project == null) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        TransparencyGrid(size: _size),
        Stack(
          children: [
            for (final layer in project!.layers.reversed)
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
            child: BitmapProjectToolsWidget(project: project),
          ),
        ),
        Positioned(
          right: BaseTheme.borderRadiusMedium,
          top: 0,
          bottom: 0,
          child: Center(
            child: BitmapProjectLayersWidget(project: project),
          ),
        ),
      ],
    );
  }
}

class _LayerCanvas extends ConsumerStatefulWidget {
  final String id;
  const _LayerCanvas({required this.id});

  @override
  ConsumerState<_LayerCanvas> createState() => _LayerCanvasState();
}

class _LayerCanvasState extends ConsumerState<_LayerCanvas> {
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _buildImage().then((image) {
        setState(() {
          _image = image;
        });
      });
    });
  }

  Future<ui.Image> _buildImage() async {
    final layer = ref
        .watch(bitmapProjectLayersProvider)
        .firstWhere((layer) => layer.id == widget.id);
    final pixelSize = ref.read(pixelSizeProvider);
    final scale = ref.read(pixelScaleProvider);
    final gridSize = pixelSize.toDouble() * scale;

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    canvas.scale(scale);

    int maxX = 0;
    int maxY = 0;
    for (var pixel in layer.pixels) {
      if (pixel.x > maxX) {
        maxX = pixel.x;
      }
      if (pixel.y > maxY) {
        maxY = pixel.y;
      }
    }

    for (var pixel in layer.pixels) {
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
      (layer.width.toDouble() * scale).ceil(),
      (layer.height.toDouble() * scale).ceil(),
    );
    picture.dispose();
    return image;
  }

  Future<void> _paint(Offset offset) async {
    final layer = ref
        .read(bitmapProjectLayersProvider.notifier)
        .topVisibleLayer();
    if (layer == null) {
      return;
    }

    final pixelSize = ref.read(pixelSizeProvider);
    final scale = ref.read(pixelScaleProvider);
    final gridSize = pixelSize.toDouble() * scale;
    final dx = offset.dx.toInt();
    final dy = offset.dy.toInt();

    int xDiff = 0;
    int yDiff = 0;

    if (dx < layer.x) {
      xDiff = layer.x - dx;
    } else if (dx >= layer.x + layer.width) {
      xDiff = dx - (layer.x + layer.width);
    }

    if (dy < layer.y) {
      yDiff = layer.y - dy;
    } else if (dy >= layer.y + layer.height) {
      yDiff = dy - (layer.y + layer.height);
    }

    final color = ref.read(bitmapProjectToolColorProvider);
    final height = (layer.height + yDiff).toInt() + gridSize.toInt();
    final width = (layer.width + xDiff).toInt() + gridSize.toInt();
    final (_, addError) = await ref
        .read(bitmapProjectLayerPixelsProvider.notifier)
        .add(BitmapProjectPixel(color: color, x: dx, y: dy), height, width);
    if (addError != null) {
      debugPrint('addError: $addError');
    }
    _buildImage().then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  void _useSelectedTool(Offset offset) {
    final selectedTool = ref.watch(bitmapProjectToolSelectedProvider);
    switch (selectedTool) {
      case BitmapProjectToolType.pencil:
        _paint(offset);
        break;
      case BitmapProjectToolType.eraser:
        break;
      case BitmapProjectToolType.fill:
        break;
      case BitmapProjectToolType.move:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final layers = ref.watch(bitmapProjectLayersProvider);
    if (layers.isEmpty) {
      return const SizedBox.shrink();
    }

    BitmapProjectLayer? layer;
    if (layers.any((layer) => layer.id == widget.id)) {
      layer = layers.firstWhere((layer) => layer.id == widget.id);
    }

    if (layer == null || layer.visible == false) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        if (_image != null)
          CustomPaint(
            size: Size(
              _image!.width.toDouble(),
              _image!.height.toDouble(),
            ),
            painter: _LayerPainter(image: _image!),
          ),
        GestureDetector(
          onPanDown: (details) => _useSelectedTool(details.globalPosition),
          onPanUpdate: (details) => _useSelectedTool(details.globalPosition),
          child: Container(
            width: size.width,
            height: size.height,
            color: Colors.transparent,
          ),
        ),
      ],
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
