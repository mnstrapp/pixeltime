import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import '../models/bitmap_project.dart';
import '../ui/theme.dart';
import 'layers/layers_widget.dart';
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
                child: Container(
                  width: layer.width.toDouble(),
                  height: layer.height.toDouble(),
                  color: layer.data.first.first,
                ),
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
