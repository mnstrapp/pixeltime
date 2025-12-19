import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class BitmapProjectToolColorNotifier extends Notifier<Color> {
  @override
  Color build() {
    return Colors.transparent;
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

class BitmapProjectToolPreviousColorsNotifier extends Notifier<List<Color>> {
  @override
  List<Color> build() {
    return [];
  }

  void add(Color color) {
    if (color == Colors.transparent) {
      return;
    }
    if (state.contains(color)) {
      return;
    }
    state = [...state, color];
  }
}

final bitmapProjectToolPreviousColorsProvider =
    NotifierProvider<BitmapProjectToolPreviousColorsNotifier, List<Color>>(
      () {
        return BitmapProjectToolPreviousColorsNotifier();
      },
    );
