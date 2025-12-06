import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ui/menu_bar.dart';

final workspaceMenuBarProvider =
    NotifierProvider<WorkspaceMenuBarNotifier, List<UIMenuBarItem>>(() {
      return WorkspaceMenuBarNotifier();
    });

class WorkspaceMenuBarNotifier extends Notifier<List<UIMenuBarItem>> {
  @override
  List<UIMenuBarItem> build() {
    return [];
  }

  (bool, String?) add({
    required UIMenuBarItem item,
  }) {
    state = [...state, item];
    return (true, null);
  }

  void clear() {
    state = [];
  }

  void remove({required String label}) {
    print('remove $label');
    state = state.where((i) => i.label != label).toList();
  }
}
