import 'package:demo_app_2/database/local/database_service.dart';
import 'package:demo_app_2/model/exercise.dart';
import 'package:sqflite/sqflite.dart';

const tableName = 'deleted_exercises';
const columnId = 'id';
const columnName = 'name';
const columnSets = 'sets';
const columnRestMinutes = 'rest_minutes';
const columnReps = 'reps';
const columnIsSynced = 'is_synced';
const unSynced = 0;

class DeletedExercisesRepository {
  Future<void> createTable(Database database) async {
    await database.execute('''
    CREATE TABLE IF NOT EXISTS $tableName (
      $columnId	TEXT NOT NULL UNIQUE,
      $columnName	TEXT NOT NULL,
      $columnSets	INTEGER NOT NULL,
      $columnRestMinutes	REAL NOT NULL,
      $columnReps INTEGER NOT NULL,
      PRIMARY KEY("id")
);
    ''');
  }

  Future<int> create(Exercise exercise) async {
    final database = await DatabaseService.database;
    final Map<String, String> mapping = exercise.toMap();
    mapping.remove(columnIsSynced);

    return await database.insert(tableName, mapping);
  }

  Future<List<Exercise>> getAll() async {
    final database = await DatabaseService.database;
    final exercises = await database.query(tableName, distinct: true);

    return exercises.map((e) => Exercise.fromMap(e)).toList();
  }

  Future<Exercise> getById(String id) async {
    final database = await DatabaseService.database;
    final exercise = await database.query(tableName, where: "id = '$id'");

    return Exercise.fromMap(exercise.first);
  }

// delete
  Future<int> delete(Exercise exercise) async {
    final database = await DatabaseService.database;
    return await database
        .delete(tableName, where: 'id = "${exercise.id}"');
  }
}
