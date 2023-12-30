import 'package:demo_app_2/database/local/deleted_exercises.dart';
import 'package:demo_app_2/database/local/deleted_records.dart';
import 'package:demo_app_2/database/local/records.dart';

import 'exercises.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const name = 'data.db';

class DatabaseService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database == null) {
      await _initialize();
    }

    return _database!;
  }

  static Future<void> _initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    final String path = "${await getDatabasesPath()}/$name";

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: DatabaseService.create,
      singleInstance: true,
    );

    _database = database;
  }

  static Future<void> create(Database database, int version) async {
    await ExercisesRepository().createTable(database);
    await RecordsTable().createTable(database);
    await DeletedExercisesRepository().createTable(database);
    await DeletedRecordsTable().createTable(database);
  }

  static Future<bool> exists() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    final path = await getDatabasesPath();

    return await databaseExists(path);
  }
}
