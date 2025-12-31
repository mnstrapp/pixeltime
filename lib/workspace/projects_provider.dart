import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/bitmap_project.dart';
import 'index_provider.dart';

final workspaceProjectsProvider =
    NotifierProvider<WorkspaceProjectsNotifier, List<BitmapProject>>(() {
      return WorkspaceProjectsNotifier();
    });

class WorkspaceProjectsNotifier extends Notifier<List<BitmapProject>> {
  @override
  List<BitmapProject> build() {
    return [];
  }

  (BitmapProject, String?) add({
    required BitmapProject project,
  }) {
    state = [...state, project];
    return (project, null);
  }

  BitmapProject? get project {
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
