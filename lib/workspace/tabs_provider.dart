import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ui/tab_bar.dart';
import 'index_provider.dart';

final workspaceTabsProvider =
    NotifierProvider<WorkspaceTabsNotifier, List<UITabBarItem>>(() {
      return WorkspaceTabsNotifier();
    });

class WorkspaceTabsNotifier extends Notifier<List<UITabBarItem>> {
  @override
  List<UITabBarItem> build() {
    return [];
  }

  (UITabBarItem, String?) add({
    required String label,
    VoidCallback? onPressed,
  }) {
    final tab = UITabBarItem(label: label, onPressed: onPressed);
    state = [...state, tab];
    return (tab, null);
  }

  UITabBarItem? get tab => ref.read(workspaceIndexProvider) >= 0
      ? state[ref.read(workspaceIndexProvider)]
      : null;

  void remove(int index) {
    state = state.where((tab) => state.indexOf(tab) != index).toList();
  }
}
