import 'package:sqflite/sqflite.dart';

class Migration {
  final int version;
  final String data;

  const Migration({
    required this.version,
    required this.data,
  });

  Future<void> run(Database database) async {
    await database.execute(data);
  }
}
