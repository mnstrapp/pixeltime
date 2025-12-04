import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/bitmap_project.dart';
import '../../models/bitmap_project_layer.dart';

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

  (bool, String?) add({
    required BitmapProjectLayer layer,
  }) {
    state = [...state, layer];
    return (true, null);
  }

  Future<(bool, String?)> toggleVisibility({
    required BitmapProjectLayer layer,
  }) async {
    final (_, error) = await layer.toggleVisibility();
    if (error != null) {
      return (false, error);
    }
    state = state
        .map(
          (l) => l.id == layer.id ? layer.copyWith(visible: !layer.visible) : l,
        )
        .toList();
    return (true, null);
  }

  Future<(bool, String?)> drag({
    required BitmapProjectLayer layer,
    required int newPosition,
  }) async {
    return await layer.reorder(newPosition);
  }

  Future<(bool, String?)> delete({
    required BitmapProjectLayer layer,
  }) async {
    final (_, error) = await layer.delete();
    if (error != null) {
      return (false, error);
    }
    state = state.where((l) => l.id != layer.id).toList();
    return refreshOrder();
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
}
