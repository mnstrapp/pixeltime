import 'package:universal_platform/universal_platform.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqflite_ffi;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart' as sqflite_ffi_web;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../migrations/migrations.dart' as migrations;

const databaseName = 'pixeltime.db';
Database? databaseInstance;

Future<String> getDatabasePath() async {
  String directory = './';
  if (!UniversalPlatform.isWeb) {
    directory = (await getApplicationSupportDirectory()).path;
  }
  return path.join(directory, databaseName);
}

Future<Database> getDatabase() async {
  if (databaseInstance != null) {
    return databaseInstance!;
  }
  if (UniversalPlatform.isWeb) {
    databaseFactory = sqflite_ffi_web.databaseFactoryFfiWeb;
  }
  if (UniversalPlatform.isWindows ||
      UniversalPlatform.isMacOS ||
      UniversalPlatform.isLinux) {
    databaseFactory = sqflite_ffi.databaseFactoryFfi;
  }
  databaseInstance = await openDatabase(await getDatabasePath());
  return databaseInstance!;
}

Future<void> migrateDatabase() async {
  final db = await getDatabase();
  await migrations.initialize(db);
  await migrations.run(db);
}
