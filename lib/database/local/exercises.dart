import 'package:sqflite/sqflite.dart';
import 'package:demo_app_2/database/local/database_service.dart';
import 'package:demo_app_2/model/exercise.dart';
import '../remote/exercises.dart' as remote_exercises;

const tableName = 'exercises';
const columnId = 'id';
const columnName = 'name';
const columnSets = 'sets';
const columnRestMinutes = 'rest_minutes';
const columnReps = 'reps';
const columnIsSynced = 'is_synced';
const unSynced = 0;

class ExercisesRepository {

  Future<void> createTable(Database database) async {
    await database.execute('''
    CREATE TABLE IF NOT EXISTS $tableName (
      $columnId	TEXT NOT NULL UNIQUE,
      $columnName	TEXT NOT NULL,
      $columnSets	INTEGER NOT NULL,
      $columnRestMinutes	REAL NOT NULL,
      $columnReps INTEGER NOT NULL,
      $columnIsSynced INTEGER NOT NULL DEFAULT 0,
      PRIMARY KEY("id")
)
    ''');
  }

  Future<int> create(Exercise exercise) async {
    final database = await DatabaseService.database;

    return await database.insert(tableName, exercise.toMap());
  }

  Future<List<Exercise>> getAll() async {
    final database = await DatabaseService.database;
    final exercises =
    await database.query(tableName, distinct: true);

    return exercises.map((e) => Exercise.fromMap(e)).toList();
  }

  Future<List<Exercise>> getUnsynced() async {
    final database = await DatabaseService.database;
    final exercises =
    await database.query(tableName, distinct: true, where: "$columnIsSynced = $unSynced");

    return exercises.map((e) => Exercise.fromMap(e)).toList();
  }

  Future<Exercise> getById(String id) async {
    final database = await DatabaseService.database;
    final exercise = await database.query(tableName, where: "id = '$id'");

    return Exercise.fromMap(exercise.first);
  }

// put
  Future<int> update(Exercise exercise) async {
    final database = await DatabaseService.database;
    return await database.update(tableName, exercise.toMap(),
        where: 'id = ?', whereArgs: [exercise.id]);
  }

// delete
  Future<int> delete(Exercise exercise) async {
    final database = await DatabaseService.database;
    return await database
        .delete(tableName, where: 'id = ?', whereArgs: [exercise.id]);
  }
}

