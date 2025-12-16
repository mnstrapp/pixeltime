import 'package:uuid/uuid.dart';

import '../database/database.dart';
import 'bitmap_project_layer.dart';

class BitmapProject {
  String? id;
  String name;
  String description;
  String? createdAt;
  String? updatedAt;
  List<BitmapProjectLayer> layers = [];

  BitmapProject({
    this.id,
    required this.name,
    required this.description,
    this.createdAt,
    this.updatedAt,
  });

  BitmapProject copyWith({
    String? id,
    String? name,
    String? description,
    String? createdAt,
    String? updatedAt,
  }) {
    return BitmapProject(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory BitmapProject.fromMap(Map<String, dynamic> map) {
    return BitmapProject(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  Future<(bool, String?)> create() async {
    final db = await getDatabase();
    try {
      id = const Uuid().v4();
      createdAt = DateTime.now().toIso8601String();
      updatedAt = DateTime.now().toIso8601String();

      final result = await db.insert('projects', toMap());
      if (result == 0) {
        return (false, 'Error creating project');
      }

      return (true, null);
    } catch (e) {
      return (false, 'Error creating project: $e');
    }
  }

  Future<(bool, String?)> update() async {
    final db = await getDatabase();
    try {
      final updatedAt = DateTime.now().toIso8601String();
      final newProject = copyWith(updatedAt: updatedAt);
      final result = await db.update(
        'projects',
        newProject.toMap(),
        where: 'id = ?',
        whereArgs: [id],
      );
      if (result == 0) {
        return (false, 'Error updating project');
      }
      return (true, null);
    } catch (e) {
      return (false, 'Error updating project: $e');
    }
  }

  Future<(bool, String?)> save() async {
    if (id == null) {
      return await create();
    } else {
      return await update();
    }
  }

  Future<(bool, String?)> delete() async {
    final db = await getDatabase();
    try {
      final result = await db.delete(
        'projects',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (result == 0) {
        return (false, 'Error deleting project');
      }
      return (true, null);
    } catch (e) {
      return (false, 'Error deleting project: $e');
    }
  }

  static Future<(List<BitmapProject>, String?)> findAll() async {
    final db = await getDatabase();
    try {
      final result = await db.query('projects', orderBy: 'updated_at DESC');
      final projects = result
          .map((project) => BitmapProject.fromMap(project))
          .toList();
      for (final project in projects) {
        final findLayersError = await project.loadAllLayers();
        if (findLayersError != null) {
          return (<BitmapProject>[], findLayersError);
        }
      }
      return (projects, null);
    } catch (e) {
      return (<BitmapProject>[], 'Error finding all projects: $e');
    }
  }

  Future<String?> loadAllLayers() async {
    final db = await getDatabase();
    try {
      final result = await db.query(
        'layers',
        where: 'project_id = ?',
        whereArgs: [id],
        orderBy: 'position ASC',
      );
      final foundLayers = result
          .map((layer) => BitmapProjectLayer.fromMap(layer))
          .toList();
      layers = foundLayers;
      return null;
    } catch (e) {
      return 'Error finding all layers: $e';
    }
  }
}
