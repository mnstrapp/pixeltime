import 'package:flutter/material.dart';
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

  (UIMenuBarItem, String?) add({
    required String label,
    IconData? icon,
    VoidCallback? onPressed,
    List<UIMenuBarItem> children = const [],
  }) {
    final item = UIMenuBarItem(
      label: label,
      icon: icon,
      onPressed: onPressed,
      children: children,
    );
    state = [...state, item];
    return (item, null);
  }
}
