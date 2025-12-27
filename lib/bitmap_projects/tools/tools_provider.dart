import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'tool.dart';

final bitmapProjectToolOptionsProvider =
    NotifierProvider<BitmapProjectToolOptionsNotifier, Widget?>(() {
      return BitmapProjectToolOptionsNotifier();
    });

class BitmapProjectToolOptionsNotifier extends Notifier<Widget?> {
  @override
  Widget? build() {
    return null;
  }

  void set(Widget? options) {
    state = options;
  }
}

final bitmapProjectToolSelectedProvider =
    NotifierProvider<BitmapProjectToolSelectedNotifier, BitmapProjectToolType>(
      () {
        return BitmapProjectToolSelectedNotifier();
      },
    );

class BitmapProjectToolSelectedNotifier
    extends Notifier<BitmapProjectToolType> {
  @override
  BitmapProjectToolType build() {
    return BitmapProjectToolType.move;
  }

  void set(BitmapProjectToolType type) {
    state = type;
  }
}
