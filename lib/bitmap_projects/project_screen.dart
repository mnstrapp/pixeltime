import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/bitmap_project.dart';
import '../ui/theme.dart';
import 'layers/layers_widget.dart';

class BitmapProjectScreen extends ConsumerWidget {
  final BitmapProject project;
  const BitmapProjectScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);

    return Stack(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              width: size.width,
              height: size.height,
              color: Colors.white,
              child: Center(child: Text(project.name)),
            ),
          ),
        ),
        Positioned(
          right: BaseTheme.borderRadiusMedium,
          top: 0,
          bottom: 0,
          child: Center(child: BitmapProjectLayersWidget(project: project)),
        ),
      ],
    );
  }
}
