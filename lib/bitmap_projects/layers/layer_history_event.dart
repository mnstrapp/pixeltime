import '../../models/bitmap_project_layer.dart';
import '../history.dart';

class LayerAddHistoryEvent implements HistoryEvent {
  @override
  final Future<(bool, String?)> Function() onExecute;
  @override
  final Future<(bool, String?)> Function() onUndo;
  final BitmapProjectLayer layer;

  LayerAddHistoryEvent({
    required this.layer,
    required this.onExecute,
    required this.onUndo,
  });

  @override
  Future<(bool, String?)> execute() async {
    final (_, saveError) = await layer.create();
    if (saveError != null) {
      return (false, saveError);
    }
    final (_, reorderError) = await layer.reorder(0);
    if (reorderError != null) {
      return (false, reorderError);
    }
    return await onExecute();
  }

  @override
  Future<(bool, String?)> undo() async {
    final (_, deleteError) = await layer.delete();
    if (deleteError != null) {
      return (false, deleteError);
    }
    return await onUndo();
  }

  @override
  String toString() {
    return {
      'type': 'LayerAddHistoryEvent',
      'layer': layer.toMap(),
    }.toString();
  }
}

class LayerDeleteHistoryEvent implements HistoryEvent {
  @override
  final Future<(bool, String?)> Function() onExecute;
  @override
  final Future<(bool, String?)> Function() onUndo;
  final BitmapProjectLayer layer;

  LayerDeleteHistoryEvent({
    required this.layer,
    required this.onExecute,
    required this.onUndo,
  });

  @override
  Future<(bool, String?)> execute() async {
    final (_, deleteError) = await layer.delete();
    if (deleteError != null) {
      return (false, deleteError);
    }
    return await onExecute();
  }

  @override
  Future<(bool, String?)> undo() async {
    final (_, createError) = await layer.create();
    if (createError != null) {
      return (false, createError);
    }
    return await onUndo();
  }

  @override
  String toString() {
    return {
      'type': 'LayerDeleteHistoryEvent',
      'layer': layer.toMap(),
    }.toString();
  }
}

class LayerToggleVisibilityHistoryEvent implements HistoryEvent {
  @override
  final Future<(bool, String?)> Function() onExecute;
  @override
  final Future<(bool, String?)> Function() onUndo;
  final BitmapProjectLayer layer;

  LayerToggleVisibilityHistoryEvent({
    required this.layer,
    required this.onExecute,
    required this.onUndo,
  });

  @override
  Future<(bool, String?)> execute() async {
    final (_, toggleVisibilityError) = await layer.toggleVisibility();
    if (toggleVisibilityError != null) {
      return (false, toggleVisibilityError);
    }
    return await onExecute();
  }

  @override
  Future<(bool, String?)> undo() async {
    final (_, toggleVisibilityError) = await layer.toggleVisibility();
    if (toggleVisibilityError != null) {
      return (false, toggleVisibilityError);
    }
    return await onUndo();
  }

  @override
  String toString() {
    return {
      'type': 'LayerToggleVisibilityHistoryEvent',
      'layer': layer.toMap(),
    }.toString();
  }
}

class LayerUpdateHistoryEvent implements HistoryEvent {
  @override
  final Future<(bool, String?)> Function() onExecute;
  @override
  final Future<(bool, String?)> Function() onUndo;
  final BitmapProjectLayer layer;
  final BitmapProjectLayer originalLayer;

  LayerUpdateHistoryEvent({
    required this.layer,
    required this.originalLayer,
    required this.onExecute,
    required this.onUndo,
  });

  @override
  Future<(bool, String?)> execute() async {
    final (_, updateError) = await layer.update();
    if (updateError != null) {
      return (false, updateError);
    }
    return await onExecute();
  }

  @override
  Future<(bool, String?)> undo() async {
    final (_, updateError) = await originalLayer.update();
    if (updateError != null) {
      return (false, updateError);
    }
    return await onUndo();
  }

  @override
  String toString() {
    return {
      'type': 'LayerUpdateHistoryEvent',
      'layer': layer.toMap(),
      'originalLayer': originalLayer.toMap(),
    }.toString();
  }
}

class LayerReorderHistoryEvent implements HistoryEvent {
  @override
  final Future<(bool, String?)> Function() onExecute;
  @override
  final Future<(bool, String?)> Function() onUndo;
  final BitmapProjectLayer layer;
  final BitmapProjectLayer oldLayer;
  final int newPosition;

  LayerReorderHistoryEvent({
    required this.layer,
    required this.newPosition,
    required this.onExecute,
    required this.onUndo,
  }) : oldLayer = layer.copyWith();

  @override
  Future<(bool, String?)> execute() async {
    final (_, reorderError) = await layer.reorder(newPosition);
    if (reorderError != null) {
      return (false, reorderError);
    }
    return await onExecute();
  }

  @override
  Future<(bool, String?)> undo() async {
    final (_, reorderError) = await layer.reorder(oldLayer.position);
    if (reorderError != null) {
      return (false, reorderError);
    }
    return await onUndo();
  }
}

class LayerAddPixelHistoryEvent implements HistoryEvent {
  @override
  final Future<(bool, String?)> Function() onExecute;
  @override
  final Future<(bool, String?)> Function() onUndo;
  final BitmapProjectLayer layer;
  final BitmapProjectPixel pixel;
  final int height;
  final int width;
  late int originalHeight;
  late int originalWidth;

  LayerAddPixelHistoryEvent({
    required this.layer,
    required this.pixel,
    required this.height,
    required this.width,
    required this.onExecute,
    required this.onUndo,
  });

  @override
  Future<(bool, String?)> execute() async {
    originalHeight = layer.height;
    originalWidth = layer.width;
    layer.height = height;
    layer.width = width;
    layer.pixels.add(pixel);
    final (_, saveError) = await layer.save();
    if (saveError != null) {
      return (false, saveError);
    }
    return await onExecute();
  }

  @override
  Future<(bool, String?)> undo() async {
    layer.height = originalHeight;
    layer.width = originalWidth;
    layer.pixels.remove(pixel);
    final (_, saveError) = await layer.save();
    if (saveError != null) {
      return (false, saveError);
    }
    return await onUndo();
  }

  @override
  String toString() {
    return {
      'type': 'LayerAddPixelHistoryEvent',
      'layer': layer.toMap(),
      'pixel': pixel.toMap(),
      'height': height,
      'width': width,
      'originalHeight': originalHeight,
      'originalWidth': originalWidth,
    }.toString();
  }
}
