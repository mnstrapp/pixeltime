import 'package:flutter/material.dart';

import '../options.dart';

class BitmapProjectToolPencilOptions extends StatelessWidget {
  const BitmapProjectToolPencilOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return BitmapProjectToolOptionsContainer(
      title: 'Pencil',
      child: Container(
        height: 100,
        color: Colors.red,
      ),
    );
  }
}
