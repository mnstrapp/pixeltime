import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bitmap_projects/project.dart';
import '../models/bitmap_project.dart';
import 'index_provider.dart';
import 'pages_provider.dart';
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
    final (page, pageError) = ref
        .read(workspacePagesProvider.notifier)
        .add(page: BitmapProjectScreen(project: project));
    if (pageError != null) {
      return (false, pageError);
    }

    final (tab, tabError) = ref
        .read(workspaceTabsProvider.notifier)
        .add(label: project.name);
    if (tabError != null) {
      return (false, tabError);
    }

    final pagesIndex = ref.read(workspacePagesProvider).length - 1;
    final _ = ref.read(workspaceIndexProvider.notifier).index(pagesIndex);

    state = true;
    return (true, null);
  }
}
