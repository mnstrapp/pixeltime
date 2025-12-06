import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bitmap_projects/bitmap_projects_provider.dart';
import '../bitmap_projects/project_screen.dart';
import '../models/bitmap_project.dart';
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

  Future<(bool, String?)> remove(int index) async {
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

    if (tabs.isEmpty) {
      final (_, error) = await ref
          .read(bitmapProjectsProvider.notifier)
          .loadAll();
      if (error != null) {
        return (false, error);
      }
    }

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
    final (_, saveError) = await project.save();
    if (saveError != null) {
      if (saveError.contains('UNIQUE')) {
        return (false, 'Project name must be unique');
      }
      return (false, saveError);
    }
    final (_, loadError) = await ref
        .read(bitmapProjectsProvider.notifier)
        .loadAll();
    if (loadError != null) {
      return (false, loadError);
    }
    state = true;
    return (true, null);
  }

  Future<(bool, String?)> saveAll() async {
    for (final projectScreen in ref.read(workspaceProjectsProvider)) {
      final project = projectScreen.project;
      final (_, saveError) = await project.save();
      if (saveError != null) {
        if (saveError.contains('UNIQUE')) {
          return (false, 'Project name must be unique');
        }
        return (false, saveError);
      }
    }
    final (_, loadError) = await ref
        .read(bitmapProjectsProvider.notifier)
        .loadAll();
    if (loadError != null) {
      return (false, loadError);
    }
    state = true;
    return (true, null);
  }

  Future<(bool, String?)> update(BitmapProject project) async {
    final (_, updateError) = await project.update();
    if (updateError != null) {
      if (updateError.contains('UNIQUE')) {
        return (false, 'Project name must be unique');
      }
      return (false, updateError);
    }
    final (_, loadError) = await ref
        .read(bitmapProjectsProvider.notifier)
        .loadAll();
    if (loadError != null) {
      return (false, loadError);
    }
    return (true, null);
  }

  Future<(bool, String?)> delete(BitmapProject project) async {
    final (_, deleteError) = await project.delete();
    if (deleteError != null) {
      return (false, deleteError);
    }
    final (_, loadError) = await ref
        .read(bitmapProjectsProvider.notifier)
        .loadAll();
    if (loadError != null) {
      return (false, loadError);
    }
    return (true, null);
  }

  (BitmapProject?, String?) currentProject() {
    final index = ref.read(workspaceIndexProvider);
    if (index < 0) {
      return (null, 'No project opened');
    }
    final project = ref.read(workspaceProjectsProvider)[index].project;
    return (project, null);
  }
}
