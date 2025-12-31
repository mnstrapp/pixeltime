import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../workspace/index_provider.dart';
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
    required HistoryEvent event,
  }) async {
    final projectIndex = ref.read(workspaceIndexProvider);
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

  Future<(bool, String?)> undo() async {
    final projectIndex = ref.read(workspaceIndexProvider);
    final history = state[projectIndex] ?? History();
    final (_, error) = await history.undo();
    if (error != null) {
      return (false, error);
    }
    return (true, null);
  }

  Future<(bool, String?)> redo() async {
    final projectIndex = ref.read(workspaceIndexProvider);
    final history = state[projectIndex] ?? History();
    final (_, error) = await history.redo();
    if (error != null) {
      return (false, error);
    }
    return (true, null);
  }

  void clear() {
    final projectIndex = ref.read(workspaceIndexProvider);
    state[projectIndex] = History();
  }
}
