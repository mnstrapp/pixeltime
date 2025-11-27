import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'index_provider.dart';

final workspacePagesProvider =
    NotifierProvider<WorkspacePagesNotifier, List<Widget>>(() {
      return WorkspacePagesNotifier();
    });

class WorkspacePagesNotifier extends Notifier<List<Widget>> {
  @override
  List<Widget> build() {
    return [];
  }

  (Widget, String?) add({
    required Widget page,
  }) {
    state = [...state, page];
    return (page, null);
  }

  Widget? get page => ref.read(workspaceIndexProvider) >= 0
      ? state[ref.read(workspaceIndexProvider)]
      : null;
}
