import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final bitmapProjectToolOptionsProvider =
    NotifierProvider<BitmapProjectToolOptionsNotifier, Widget?>(() {
      return BitmapProjectToolOptionsNotifier();
    });

class BitmapProjectToolOptionsNotifier extends Notifier<Widget?> {
  @override
  Widget? build() {
    return null;
  }

  void set(Widget options) {
    state = options;
  }
}
