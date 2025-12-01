import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/bitmap_project.dart';

final bitmapProjectsProvider =
    NotifierProvider<BitmapProjectsNotifier, List<BitmapProject>>(() {
      return BitmapProjectsNotifier();
    });

class BitmapProjectsNotifier extends Notifier<List<BitmapProject>> {
  @override
  List<BitmapProject> build() {
    return [];
  }

  Future<(List<BitmapProject>, String?)> loadAll() async {
    final (projects, error) = await BitmapProject.findAll();
    if (error != null) {
      return (projects, error);
    }
    state = projects;
    return (projects, null);
  }
}
