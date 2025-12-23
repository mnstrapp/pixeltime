import 'package:flutter_riverpod/flutter_riverpod.dart';

final pixelSizeProvider = NotifierProvider<PixelSizeNotifier, int>(() {
  return PixelSizeNotifier();
});

class PixelSizeNotifier extends Notifier<int> {
  @override
  int build() {
    return 10;
  }

  void set(int size) {
    state = size;
  }
}

final pixelScaleProvider = NotifierProvider<PixelScaleNotifier, double>(() {
  return PixelScaleNotifier();
});

class PixelScaleNotifier extends Notifier<double> {
  @override
  double build() {
    return 1.0;
  }

  void set(double scale) {
    state = scale;
  }
}
