import '../database/exercises.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const name = 'data.db';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    _database ??= await _initialize();

    return _database!;
  }

  Future<Database> _initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    var database = await openDatabase(
      name,
      version: 1,
      onCreate: create,
      singleInstance: true,
    );

    return database;
  }

  Future<void> create(Database database, int version) async {
    await ExercisesRepository().createTable();
  }
}
