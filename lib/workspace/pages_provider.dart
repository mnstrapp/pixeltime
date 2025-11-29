import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bitmap_projects/project.dart';
import 'index_provider.dart';

final workspacePagesProvider =
    NotifierProvider<WorkspacePagesNotifier, List<BitmapProjectScreen>>(() {
      return WorkspacePagesNotifier();
    });

class WorkspacePagesNotifier extends Notifier<List<BitmapProjectScreen>> {
  @override
  List<BitmapProjectScreen> build() {
    return [];
  }

  (BitmapProjectScreen, String?) add({
    required BitmapProjectScreen page,
  }) {
    state = [...state, page];
    return (page, null);
  }

  BitmapProjectScreen? get page => ref.read(workspaceIndexProvider) >= 0
      ? state[ref.read(workspaceIndexProvider)]
      : null;

  void remove(int index) {
    state = state.where((page) => state.indexOf(page) != index).toList();
  }
}
