import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/bitmap_project_layer.dart';
import '../../workspace/workspace_provider.dart';
import '../bitmap_projects_provider.dart';
import '../history_provider.dart';
import 'layer_history_event.dart';

final bitmapProjectLayersProvider =
    NotifierProvider<BitmapProjectLayersNotifier, List<BitmapProjectLayer>>(() {
      return BitmapProjectLayersNotifier();
    });

class BitmapProjectLayersNotifier extends Notifier<List<BitmapProjectLayer>> {
  @override
  List<BitmapProjectLayer> build() {
    return <BitmapProjectLayer>[];
  }

  Future<(bool, String?)> loadAll() async {
    final (project, projectError) = ref
        .read(workspaceProvider.notifier)
        .currentProject();
    if (projectError != null) {
      return (false, projectError);
    }
    if (project == null) {
      return (false, 'Project not found');
    }
    final (layers, findError) = await BitmapProjectLayer.findAllByProjectId(
      project.id!,
    );
    if (findError != null) {
      return (false, findError);
    }
    debugPrint('loadAll layers: ${layers.map((l) => l.name).join(', ')}');
    state = layers;
    return (true, null);
  }

  Future<(bool, String?)> refresh() async {
    final (loadSuccess, loadError) = await loadAll();
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
    return ref.read(bitmapProjectHistoryProvider.notifier).add(event: event);
  }

  void updateLayer({
    required BitmapProjectLayer layer,
  }) {
    final (project, projectError) = ref
        .read(workspaceProvider.notifier)
        .currentProject();
    if (projectError != null) {
      return;
    }
    if (project == null) {
      return;
    }
    state = state.map((l) => l.id == layer.id ? layer : l).toList();
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
    return ref.read(bitmapProjectHistoryProvider.notifier).add(event: event);
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
    return ref.read(bitmapProjectHistoryProvider.notifier).add(event: event);
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
    return ref.read(bitmapProjectHistoryProvider.notifier).add(event: event);
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
    return ref.read(bitmapProjectHistoryProvider.notifier).add(event: event);
  }

  BitmapProjectLayer? topVisibleLayer() {
    BitmapProjectLayer? layer;
    for (var i = 0; i < state.length; i++) {
      if (state[i].visible) {
        layer = state[i];
        break;
      }
    }
    return layer;
  }
}

final bitmapProjectLayerPixelsProvider =
    NotifierProvider<
      BitmapProjectLayerPixelsNotifier,
      List<BitmapProjectPixel>
    >(() {
      return BitmapProjectLayerPixelsNotifier();
    });

class BitmapProjectLayerPixelsNotifier
    extends Notifier<List<BitmapProjectPixel>> {
  @override
  List<BitmapProjectPixel> build() {
    return <BitmapProjectPixel>[];
  }

  void set({required BitmapProjectLayer layer}) {
    state = layer.pixels;
  }

  void add({
    required BitmapProjectPixel pixel,
  }) async {
    state = [...state, pixel];
  }

  void remove({
    required BitmapProjectPixel pixel,
  }) async {
    state = state.where((p) => p.x != pixel.x || p.y != pixel.y).toList();
  }

  void clear() {
    state = [];
  }
}
