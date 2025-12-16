import 'package:flutter/material.dart';

import '../options.dart';

class BitmapProjectToolEraserOptions extends StatelessWidget {
  const BitmapProjectToolEraserOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return BitmapProjectToolOptionsContainer(
      title: 'Eraser',
      child: Container(
        height: 100,
        color: Colors.red,
      ),
    );
  }
}
