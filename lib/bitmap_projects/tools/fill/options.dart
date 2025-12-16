import 'package:flutter/material.dart';

import '../options.dart';

class BitmapProjectToolFillOptions extends StatelessWidget {
  const BitmapProjectToolFillOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return BitmapProjectToolOptionsContainer(
      title: 'Fill',
      child: Container(
        height: 100,
        color: Colors.red,
      ),
    );
  }
}
