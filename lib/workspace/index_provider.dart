import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final workspaceIndexProvider = NotifierProvider<WorkspaceIndexNotifier, int>(
  () {
    return WorkspaceIndexNotifier();
  },
);

class WorkspaceIndexNotifier extends Notifier<int> {
  @override
  int build() => -1;

  int index(int index) {
    debugPrint('[workspaceIndexNotifier] index: $index');
    state = index;
    return index;
  }
}
