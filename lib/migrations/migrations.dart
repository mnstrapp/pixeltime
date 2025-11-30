import 'package:sqflite/sqflite.dart';

import 'generated.dart';

Future<void> initialize(Database database) async {
  await database.execute(
    'CREATE TABLE IF NOT EXISTS migrations (version INTEGER PRIMARY KEY)',
  );
  final result = await database.query(
    'migrations',
    columns: ['version'],
    orderBy: 'version DESC',
    limit: 1,
  );
  if (result.isEmpty) {
    await database.execute('INSERT INTO migrations (version) VALUES (0)');
  }
}

Future<void> run(Database database) async {
  final result = await database.query(
    'migrations',
    columns: ['version'],
    orderBy: 'version DESC',
    limit: 1,
  );
  int lastVersion = 0;
  if (result.isNotEmpty) {
    lastVersion = result.first['version'] as int;
  }
  for (final migration in migrations) {
    if (migration.version > lastVersion) {
      await migration.run(database);
      await database.execute('INSERT INTO migrations (version) VALUES (?)', [
        migration.version,
      ]);
    }
  }
}
