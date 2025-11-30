import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bitmap_projects/project.dart';
import '../models/bitmap_project.dart';
import '../database/database.dart';
import 'index_provider.dart';
import 'projects_provider.dart';
import 'tabs_provider.dart';

final workspaceProvider = NotifierProvider<WorkspaceNotifier, bool>(() {
  return WorkspaceNotifier();
});

class WorkspaceNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  (bool, String?) add(BitmapProject project) {
    final (projectScreen, projectError) = ref
        .read(workspaceProjectsProvider.notifier)
        .add(projectScreen: BitmapProjectScreen(project: project));
    if (projectError != null) {
      return (false, projectError);
    }

    final (tab, tabError) = ref
        .read(workspaceTabsProvider.notifier)
        .add(label: project.name);
    if (tabError != null) {
      return (false, tabError);
    }

    final projectScreenIndex = ref.read(workspaceProjectsProvider).length - 1;
    final _ = ref
        .read(workspaceIndexProvider.notifier)
        .index(projectScreenIndex);

    state = true;
    return (true, null);
  }

  (bool, String?) remove(int index) {
    ref.read(workspaceTabsProvider.notifier).remove(index);
    ref.read(workspaceProjectsProvider.notifier).remove(index);
    final tabs = ref.read(workspaceTabsProvider);
    ref
        .read(workspaceIndexProvider.notifier)
        .index(
          tabs.isNotEmpty
              ? index <= tabs.length - 1
                    ? index
                    : tabs.length - 1
              : -1,
        );

    return (true, null);
  }

  Future<(bool, String?)> save() async {
    final projectScreen = ref
        .read(workspaceProjectsProvider.notifier)
        .projectScreen;
    if (projectScreen == null) {
      return (false, 'No project opened');
    }

    final project = projectScreen.project;
    final db = await getDatabase();
    return await project.save(db);
  }

  Future<(bool, String?)> saveAll() async {
    final db = await getDatabase();
    for (final projectScreen in ref.read(workspaceProjectsProvider)) {
      final project = projectScreen.project;
      final (success, error) = await project.save(db);
      if (error != null) {
        return (false, error);
      }
    }
    return (true, null);
  }
}
