import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class BitmapProject {
  final String? id;
  final String name;
  final String description;
  final String? createdAt;
  final String? updatedAt;

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

  Future<(bool, String?)> create(Database db) async {
    try {
      final id = const Uuid().v4();
      final createdAt = DateTime.now().toIso8601String();
      final updatedAt = DateTime.now().toIso8601String();
      final newProject = copyWith(
        id: id,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      final result = await db.insert('projects', newProject.toMap());
      if (result == 0) {
        return (false, 'Error creating project');
      }
      return (true, null);
    } catch (e) {
      return (false, 'Error creating project: $e');
    }
  }

  Future<(bool, String?)> update(Database db) async {
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

  Future<(bool, String?)> save(Database db) async {
    if (id == null) {
      return await create(db);
    } else {
      return await update(db);
    }
  }

  Future<(bool, String?)> delete(Database db) async {
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
}
