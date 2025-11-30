import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database.dart';
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
    final db = await getDatabase();
    final result = await db.query('projects', orderBy: 'updated_at DESC');
    debugPrint('result: $result');
    final projects = result
        .map((project) => BitmapProject.fromMap(project))
        .toList();
    state = projects;
    return (projects, null);
  }
}
