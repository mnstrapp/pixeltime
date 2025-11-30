import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bitmap_projects/project.dart';
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

  BitmapProjectScreen? get projectScreen =>
      ref.read(workspaceIndexProvider) >= 0
      ? state[ref.read(workspaceIndexProvider)]
      : null;

  void remove(int index) {
    state = state
        .where((projectScreen) => state.indexOf(projectScreen) != index)
        .toList();
  }
}
