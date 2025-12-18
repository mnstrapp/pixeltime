import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class BitmapProjectToolColorNotifier extends Notifier<Color> {
  @override
  Color build() {
    return Colors.black;
  }

  void set(Color color) {
    state = color;
  }
}

final bitmapProjectToolColorProvider =
    NotifierProvider<BitmapProjectToolColorNotifier, Color>(
      () {
        return BitmapProjectToolColorNotifier();
      },
    );
