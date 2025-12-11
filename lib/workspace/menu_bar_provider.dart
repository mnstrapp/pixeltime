import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ui/menu_bar.dart';

final workspaceMenuBarProvider =
    NotifierProvider<WorkspaceMenuBarNotifier, List<UIMenuBarItem>>(() {
      return WorkspaceMenuBarNotifier();
    });

class WorkspaceMenuBarNotifier extends Notifier<List<UIMenuBarItem>> {
  final prefix = <UIMenuBarItem>[];
  final suffix = <UIMenuBarItem>[];

  @override
  List<UIMenuBarItem> build() {
    return [];
  }

  (bool, String?) addPrefix({
    required UIMenuBarItem item,
  }) {
    prefix.add(item);
    state = [...prefix, ...suffix];
    return (true, null);
  }

  void addSuffix({
    required UIMenuBarItem item,
  }) {
    suffix.add(item);
    state = [...prefix, ...suffix];
  }

  void clear() {
    prefix.clear();
    suffix.clear();
    state = [...prefix, ...suffix];
  }

  void clearPrefix() {
    prefix.clear();
    state = [...prefix, ...suffix];
  }

  void clearSuffix() {
    suffix.clear();
    state = [...prefix, ...suffix];
  }
}
