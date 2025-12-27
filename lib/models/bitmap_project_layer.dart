import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../database/database.dart';

class BitmapProjectPixel {
  Color color;
  int x;
  int y;

  BitmapProjectPixel({
    required this.color,
    required this.x,
    required this.y,
  });

  Map<String, dynamic> toMap() {
    return {
      'color': color.toARGB32(),
      'x': x,
      'y': y,
    };
  }

  factory BitmapProjectPixel.fromMap(Map<String, dynamic> map) {
    return BitmapProjectPixel(
      color: Color(map['color']),
      x: map['x'],
      y: map['y'],
    );
  }

  BitmapProjectPixel copyWith({
    Color? color,
  }) {
    return BitmapProjectPixel(
      color: color ?? this.color,
      x: x,
      y: y,
    );
  }
}

class BitmapProjectLayer {
  String? id;
  String name;
  String projectId;
  int position;
  bool visible;
  int width;
  int height;
  int x;
  int y;
  List<BitmapProjectPixel> pixels;

  BitmapProjectLayer({
    this.id,
    required this.name,
    required this.projectId,
    required this.position,
    this.visible = true,
    this.width = 100,
    this.height = 100,
    this.x = 0,
    this.y = 0,
    this.pixels = const [],
  });

  @override
  String toString() {
    return toMap().toString();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'project_id': projectId,
      'position': position,
      'visible': visible ? 1 : 0,
      'width': width,
      'height': height,
      'x': x,
      'y': y,
      'data': json
          .encode(
            pixels.map((pixel) => pixel.toMap()).toList(),
          )
          .toString(),
    };
  }

  factory BitmapProjectLayer.fromMap(Map<String, dynamic> map) {
    final pixelsData = <Map<String, dynamic>>[];
    if (map['data'] != null) {
      for (var pixel in json.decode(map['data'])) {
        pixelsData.add(pixel);
      }
    }
    final pixels = pixelsData
        .map((pixel) => BitmapProjectPixel.fromMap(pixel))
        .toList();
    var layer = BitmapProjectLayer(
      id: map['id'],
      name: map['name'],
      projectId: map['project_id'],
      position: map['position'],
      visible: map['visible'] == 1 ? true : false,
      width: map['width'],
      height: map['height'],
      x: map['x'],
      y: map['y'],
      pixels: pixels,
    );
    return layer;
  }

  BitmapProjectLayer copyWith({
    String? name,
    int? position,
    bool? visible,
    int? width,
    int? height,
    int? x,
    int? y,
    List<BitmapProjectPixel>? pixels,
  }) {
    return BitmapProjectLayer(
      id: id,
      name: name ?? this.name,
      projectId: projectId,
      position: position ?? this.position,
      visible: visible ?? this.visible,
      width: width ?? this.width,
      height: height ?? this.height,
      x: x ?? this.x,
      y: y ?? this.y,
      pixels: pixels ?? this.pixels,
    );
  }

  Future<(bool, String?)> create() async {
    final db = await getDatabase();
    id ??= const Uuid().v4();
    try {
      final result = await db.insert('layers', toMap());
      if (result == 0) {
        return (false, 'Error creating layer');
      }
      return (true, null);
    } catch (e) {
      return (false, 'Error creating layer: $e');
    }
  }

  Future<(bool, String?)> update() async {
    final db = await getDatabase();
    try {
      final result = await db.update(
        'layers',
        toMap(),
        where: 'id = ?',
        whereArgs: [id],
      );
      if (result == 0) {
        return (false, 'Error updating layer');
      }
      return (true, null);
    } catch (e) {
      return (false, 'Error updating layer: $e');
    }
  }

  Future<(bool, String?)> save() async {
    if (id == null) {
      return await create();
    } else {
      return await update();
    }
  }

  Future<(bool, String?)> reorder(int newPosition) async {
    if (id == null) {
      return (false, 'Layer missing id');
    }

    try {
      var (layers, findError) = await findAllByProjectId(projectId);
      if (findError != null) {
        return (false, findError);
      }
      final currentIndex = layers.indexWhere(
        (layer) => layer.id == id,
      );
      if (currentIndex == -1) {
        return (false, 'Layer not found in project');
      }

      if (currentIndex == newPosition) {
        return (true, null);
      }

      layers.removeAt(currentIndex);
      layers.insert(newPosition, this);
      position = newPosition;

      for (var i = 0; i < layers.length; i++) {
        layers[i].position = i;
        final (result, updateError) = await layers[i].update();
        if (updateError != null) {
          return (false, updateError);
        }
      }
    } catch (e) {
      return (false, 'Error reordering layer: $e');
    }

    return (true, null);
  }

  Future<(bool, String?)> delete() async {
    if (id == null) {
      return (false, 'Layer not found in database');
    }
    final db = await getDatabase();
    try {
      await db.delete(
        'layers',
        where: 'id = ?',
        whereArgs: [id],
      );
      return (true, null);
    } catch (e) {
      return (false, 'Error deleting layer: $e');
    }
  }

  Future<(bool, String?)> toggleVisibility() async {
    visible = !visible;
    return await update();
  }

  static Future<(List<BitmapProjectLayer>, String?)> findAllByProjectId(
    String projectId,
  ) async {
    final db = await getDatabase();
    try {
      final result = await db.query(
        'layers',
        where: 'project_id = ?',
        whereArgs: [projectId],
        orderBy: 'position ASC',
      );
      final layers = result
          .map((layer) => BitmapProjectLayer.fromMap(layer))
          .toList();
      return (layers, null);
    } catch (e) {
      return (
        <BitmapProjectLayer>[],
        'Error finding all layers by project id: $e',
      );
    }
  }
}
