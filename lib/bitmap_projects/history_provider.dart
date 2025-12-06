import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'history.dart';

final bitmapProjectHistoryProvider =
    NotifierProvider<BitmapProjectHistoryNotifier, History>(() {
      return BitmapProjectHistoryNotifier();
    });

class BitmapProjectHistoryNotifier extends Notifier<History> {
  @override
  History build() {
    return History();
  }

  Future<(bool, String?)> add(HistoryEvent event) async {
    final (_, error) = await state.add(event);
    if (error != null) {
      return (false, error);
    }
    return (true, null);
  }

  Future<(bool, String?)> undo() async {
    final (_, error) = await state.undo();
    if (error != null) {
      return (false, error);
    }
    return (true, null);
  }

  Future<(bool, String?)> redo() async {
    final (_, error) = await state.redo();
    if (error != null) {
      return (false, error);
    }
    return (true, null);
  }

  void clear() {
    state = History();
  }
}
