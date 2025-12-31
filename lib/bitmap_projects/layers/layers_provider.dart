import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/bitmap_project.dart';
import '../../models/bitmap_project_layer.dart';
import '../../workspace/workspace_provider.dart';
import '../bitmap_projects_provider.dart';
import '../history_provider.dart';
import 'layer_history_event.dart';

final bitmapProjectLayersProvider =
    NotifierProvider<
      BitmapProjectLayersNotifier,
      List<List<BitmapProjectLayer>>
    >(() {
      return BitmapProjectLayersNotifier();
    });

class BitmapProjectLayersNotifier
    extends Notifier<List<List<BitmapProjectLayer>>> {
  @override
  List<List<BitmapProjectLayer>> build() {
    return <List<BitmapProjectLayer>>[];
  }

  Future<(bool, String?)> loadAll({
    required int projectIndex,
    required BitmapProject project,
  }) async {
    final (layers, findError) = await BitmapProjectLayer.findAllByProjectId(
      project.id!,
    );
    if (findError != null) {
      return (false, findError);
    }
    state[projectIndex] = layers;
    return (true, null);
  }

  Future<(bool, String?)> refresh(int projectIndex) async {
    final (project, currentProjectError) = ref
        .read(workspaceProvider.notifier)
        .currentProject();
    if (currentProjectError != null) {
      return (false, currentProjectError);
    }
    final (loadSuccess, loadError) = await loadAll(
      projectIndex: projectIndex,
      project: project!,
    );
    if (loadError != null) {
      return (false, loadError);
    }
    final (projects, projectsError) = await ref
        .read(bitmapProjectsProvider.notifier)
        .loadAll();
    if (projectsError != null) {
      return (false, projectsError);
    }
    return (true, null);
  }

  Future<(bool, String?)> create({
    required int projectIndex,
    required BitmapProjectLayer layer,
  }) async {
    final event = LayerAddHistoryEvent(
      layer: layer,
      onExecute: () async {
        return refresh(projectIndex);
      },
      onUndo: () async {
        return refresh(projectIndex);
      },
    );
    return ref
        .read(bitmapProjectHistoryProvider.notifier)
        .add(projectIndex: projectIndex, event: event);
  }

  void updateLayer({
    required int projectIndex,
    required BitmapProjectLayer layer,
  }) {
    state[projectIndex] = state[projectIndex]
        .map((l) => l.id == layer.id ? layer : l)
        .toList();
  }

  Future<(bool, String?)> update({
    required int projectIndex,
    required BitmapProjectLayer layer,
    required BitmapProjectLayer originalLayer,
  }) async {
    final event = LayerUpdateHistoryEvent(
      layer: layer,
      originalLayer: originalLayer,
      onExecute: () async {
        return refresh(projectIndex);
      },
      onUndo: () async {
        return refresh(projectIndex);
      },
    );
    return ref
        .read(bitmapProjectHistoryProvider.notifier)
        .add(projectIndex: projectIndex, event: event);
  }

  Future<(bool, String?)> delete({
    required int projectIndex,
    required BitmapProjectLayer layer,
  }) async {
    final event = LayerDeleteHistoryEvent(
      layer: layer,
      onExecute: () async {
        return refresh(projectIndex);
      },
      onUndo: () async {
        return refresh(projectIndex);
      },
    );
    return ref
        .read(bitmapProjectHistoryProvider.notifier)
        .add(projectIndex: projectIndex, event: event);
  }

  Future<(bool, String?)> toggleVisibility({
    required int projectIndex,
    required BitmapProjectLayer layer,
  }) async {
    final event = LayerToggleVisibilityHistoryEvent(
      layer: layer,
      onExecute: () async {
        return refresh(projectIndex);
      },
      onUndo: () async {
        return refresh(projectIndex);
      },
    );
    return ref
        .read(bitmapProjectHistoryProvider.notifier)
        .add(projectIndex: projectIndex, event: event);
  }

  Future<(bool, String?)> reorder({
    required int projectIndex,
    required BitmapProjectLayer layer,
    required int newPosition,
  }) async {
    final event = LayerReorderHistoryEvent(
      layer: layer,
      newPosition: newPosition,
      onExecute: () async {
        return refresh(projectIndex);
      },
      onUndo: () async {
        return refresh(projectIndex);
      },
    );
    return ref
        .read(bitmapProjectHistoryProvider.notifier)
        .add(projectIndex: projectIndex, event: event);
  }

  BitmapProjectLayer? topVisibleLayer({required int projectIndex}) {
    BitmapProjectLayer? layer;
    for (var i = 0; i < state[projectIndex].length; i++) {
      if (state[projectIndex][i].visible) {
        layer = state[projectIndex][i];
        break;
      }
    }
    return layer;
  }
}

final bitmapProjectLayerPixelsProvider =
    NotifierProvider<
      BitmapProjectLayerPixelsNotifier,
      List<List<BitmapProjectPixel>>
    >(() {
      return BitmapProjectLayerPixelsNotifier();
    });

class BitmapProjectLayerPixelsNotifier
    extends Notifier<List<List<BitmapProjectPixel>>> {
  @override
  List<List<BitmapProjectPixel>> build() {
    return <List<BitmapProjectPixel>>[];
  }

  void set({required int projectIndex, required BitmapProjectLayer layer}) {
    state[projectIndex] = layer.pixels;
  }

  Future<(bool, String?)> add({
    required int projectIndex,
    required BitmapProjectPixel pixel,
    required int height,
    required int width,
  }) async {
    final layer = ref
        .read(bitmapProjectLayersProvider.notifier)
        .topVisibleLayer(projectIndex: projectIndex);
    if (layer == null) {
      return (false, 'Layer not found');
    }
    final event = LayerAddPixelHistoryEvent(
      layer: layer,
      pixel: pixel,
      height: height,
      width: width,
      onExecute: () async {
        ref
            .read(bitmapProjectLayersProvider.notifier)
            .updateLayer(projectIndex: projectIndex, layer: layer);
        return (true, null);
      },
      onUndo: () async {
        ref
            .read(bitmapProjectLayersProvider.notifier)
            .updateLayer(
              projectIndex: projectIndex,
              layer: layer,
            );
        return (true, null);
      },
    );
    return ref
        .read(bitmapProjectHistoryProvider.notifier)
        .add(projectIndex: projectIndex, event: event);
  }
}
