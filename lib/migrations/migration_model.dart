import 'package:sqflite/sqflite.dart';

class Migration {
  final int version;
  final String upData;
  final String downData;

  const Migration({
    required this.version,
    required this.upData,
    required this.downData,
  });

  Future<void> run(Database database) async {
    await database.execute(upData);
  }

  Future<void> rollback(Database database) async {
    await database.execute(downData);
  }
}
