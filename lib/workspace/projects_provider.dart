import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bitmap_projects/project_screen.dart';
import 'index_provider.dart';

final workspaceProjectsProvider =
    NotifierProvider<WorkspaceProjectsNotifier, List<BitmapProjectScreen>>(() {
      return WorkspaceProjectsNotifier();
    });

class WorkspaceProjectsNotifier extends Notifier<List<BitmapProjectScreen>> {
  @override
  List<BitmapProjectScreen> build() {
    return [];
  }

  (BitmapProjectScreen, String?) add({
    required BitmapProjectScreen projectScreen,
  }) {
    state = [...state, projectScreen];
    return (projectScreen, null);
  }

  BitmapProjectScreen? get projectScreen {
    if (state.isEmpty) {
      return null;
    }
    final index = ref.read(workspaceIndexProvider);
    if (index < 0) {
      return null;
    }
    if (index > state.length - 1) {
      return null;
    }
    return (index >= 0 && state.isNotEmpty) ? state[index] : null;
  }

  void remove(int index) {
    state = state
        .where((projectScreen) => state.indexOf(projectScreen) != index)
        .toList();
  }
}
