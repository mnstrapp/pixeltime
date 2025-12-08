import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/bitmap_project.dart';
import '../../models/bitmap_project_layer.dart';
import '../../workspace/workspace_provider.dart';
import '../history_provider.dart';
import 'layer_history_event.dart';

final bitmapProjectLayersProvider =
    NotifierProvider<BitmapProjectLayersNotifier, List<BitmapProjectLayer>>(() {
      return BitmapProjectLayersNotifier();
    });

class BitmapProjectLayersNotifier extends Notifier<List<BitmapProjectLayer>> {
  @override
  List<BitmapProjectLayer> build() {
    return [];
  }

  Future<(bool, String?)> loadAll({
    required BitmapProject project,
  }) async {
    final (layers, findError) = await BitmapProjectLayer.findAllByProjectId(
      project.id!,
    );
    if (findError != null) {
      return (false, findError);
    }
    state = layers;
    return (true, null);
  }

  Future<(bool, String?)> refresh() async {
    final (project, currentProjectError) = ref
        .read(workspaceProvider.notifier)
        .currentProject();
    if (currentProjectError != null) {
      return (false, currentProjectError);
    }
    return loadAll(project: project!);
  }

  Future<(bool, String?)> create({
    required BitmapProjectLayer layer,
  }) async {
    final event = LayerAddHistoryEvent(
      layer: layer,
      onExecute: () async {
        return refresh();
      },
      onUndo: () async {
        return refresh();
      },
    );
    return ref.read(bitmapProjectHistoryProvider.notifier).add(event);
  }

  Future<(bool, String?)> update({
    required BitmapProjectLayer layer,
    required BitmapProjectLayer originalLayer,
  }) async {
    final event = LayerUpdateHistoryEvent(
      layer: layer,
      originalLayer: originalLayer,
      onExecute: () async {
        return refresh();
      },
      onUndo: () async {
        return refresh();
      },
    );
    return ref.read(bitmapProjectHistoryProvider.notifier).add(event);
  }

  Future<(bool, String?)> delete({
    required BitmapProjectLayer layer,
  }) async {
    final event = LayerDeleteHistoryEvent(
      layer: layer,
      onExecute: () async {
        return refresh();
      },
      onUndo: () async {
        return refresh();
      },
    );
    return ref.read(bitmapProjectHistoryProvider.notifier).add(event);
  }

  Future<(bool, String?)> toggleVisibility({
    required BitmapProjectLayer layer,
  }) async {
    final event = LayerToggleVisibilityHistoryEvent(
      layer: layer,
      onExecute: () async {
        return refresh();
      },
      onUndo: () async {
        return refresh();
      },
    );
    return ref.read(bitmapProjectHistoryProvider.notifier).add(event);
  }

  Future<(bool, String?)> refreshOrder() async {
    for (var i = 0; i < state.length; i++) {
      final layer = state[i];
      final (_, error) = await layer.reorder(i);
      if (error != null) {
        return (false, error);
      }
    }
    return (true, null);
  }

  Future<(bool, String?)> reorder({
    required BitmapProjectLayer layer,
    required int newPosition,
  }) async {
    final event = LayerReorderHistoryEvent(
      layer: layer,
      newPosition: newPosition,
      onExecute: () async {
        return refresh();
      },
      onUndo: () async {
        return refresh();
      },
    );
    return ref.read(bitmapProjectHistoryProvider.notifier).add(event);
  }
}
