import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'options.dart';

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
    NotifierProvider<
      BitmapProjectToolSelectedNotifier,
      BitmapProjectToolOptions
    >(() {
      return BitmapProjectToolSelectedNotifier();
    });

class BitmapProjectToolSelectedNotifier
    extends Notifier<BitmapProjectToolOptions> {
  @override
  BitmapProjectToolOptions build() {
    return BitmapProjectToolOptions.select;
  }

  void set(BitmapProjectToolOptions options) {
    state = options;
  }
}
