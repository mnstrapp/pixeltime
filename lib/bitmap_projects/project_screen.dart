import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/bitmap_project.dart';
import '../ui/theme.dart';
import 'layers/layers_widget.dart';
import 'tools/tools_widget.dart';

class BitmapProjectScreen extends ConsumerWidget {
  final BitmapProject project;
  const BitmapProjectScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Stack(
          children: [
            for (final layer in project.layers)
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
