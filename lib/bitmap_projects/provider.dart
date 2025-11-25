import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

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

  Future<(BitmapProject, String?)> create({
    required String name,
    String? description,
  }) async {
    final project = BitmapProject(
      id: const Uuid().v4(),
      name: name,
      description: description ?? '',
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );
    state = [...state, project];
    return (project, null);
  }
}

final bitmapProjectProvider =
    NotifierProvider<BitmapProjectNotifier, BitmapProject?>(() {
      return BitmapProjectNotifier();
    });

class BitmapProjectNotifier extends Notifier<BitmapProject?> {
  @override
  BitmapProject? build() {
    return null;
  }

  set project(BitmapProject? project) {
    state = project;
  }
}
