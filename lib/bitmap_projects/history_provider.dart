import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'history.dart';

final bitmapProjectHistoryProvider =
    NotifierProvider<BitmapProjectHistoryNotifier, List<History?>>(() {
      return BitmapProjectHistoryNotifier();
    });

class BitmapProjectHistoryNotifier extends Notifier<List<History?>> {
  @override
  List<History?> build() {
    return [];
  }

  Future<(bool, String?)> add({
    required int projectIndex,
    required HistoryEvent event,
  }) async {
    if (projectIndex >= state.length) {
      state = List.generate(projectIndex + 1, (index) => History());
    }
    final history = state[projectIndex] ?? History();
    final (_, error) = await history.add(event);
    if (error != null) {
      return (false, error);
    }
    return (true, null);
  }

  Future<(bool, String?)> undo({required int projectIndex}) async {
    final history = state[projectIndex] ?? History();
    final (_, error) = await history.undo();
    if (error != null) {
      return (false, error);
    }
    return (true, null);
  }

  Future<(bool, String?)> redo({required int projectIndex}) async {
    final history = state[projectIndex] ?? History();
    final (_, error) = await history.redo();
    if (error != null) {
      return (false, error);
    }
    return (true, null);
  }

  void clear({required int projectIndex}) {
    state[projectIndex] = History();
  }
}
