import 'package:sqflite/sqflite.dart';
import 'package:demo_app_2/database/database_service.dart';
import 'package:demo_app_2/model/exercise.dart';
import './remote/exercises.dart' as remote_exercises;

const tableName = 'exercises';
const columnId = 'id';
const columnName = 'name';
const columnSets = 'sets';
const columnRestMinutes = 'rest_minutes';
const columnReps = 'reps';
const columnIsSynced = 'is_synced';

class ExercisesRepository {

  Future<void> createTable() async {
    final database = await DatabaseService().database;
    await database.execute('''
    CREATE TABLE IF NOT EXISTS $tableName (
      "id"	TEXT NOT NULL UNIQUE,
      "name"	TEXT NOT NULL,
      "rest_minutes"	REAL NOT NULL,
      "sets"	INTEGER NOT NULL,
      "reps"	INTEGER NOT NULL,
      PRIMARY KEY("id")
);
    ''');
  }

  Future<int> create(Exercise exercise) async {
    final database = await DatabaseService().database;
    exercise.isSynced = await remote_exercises.post(exercise);

    return await database.insert(tableName, exercise.toMap());
  }

  Future<List<Exercise>> getAll() async {
    final database = await DatabaseService().database;
    final exercises =
    await database.rawQuery('''select distinct * from $tableName;''');

    return exercises.map((e) => Exercise.fromMap(e)).toList();
  }

  Future<Exercise> getById(String id) async {
    final database = await DatabaseService().database;
    final exercise = await database.query(tableName, where: "id = '$id'");

    return Exercise.fromMap(exercise.first);
  }

// put
  Future<int> update(Exercise exercise) async {
    final database = await DatabaseService().database;
    return await database.update(tableName, exercise.toMap(),
        where: 'id = ?', whereArgs: [exercise.id]);
  }

// delete
  Future<int> delete(Exercise exercise) async {
    final database = await DatabaseService().database;
    return await database
        .delete(tableName, where: 'id = ?', whereArgs: [exercise.id]);
  }
}

