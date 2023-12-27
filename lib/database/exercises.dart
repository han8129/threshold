import 'package:sqflite/sqflite.dart';
import 'package:demo_app_2/database/database_service.dart';
import 'package:demo_app_2/model/exercise.dart';

class ExerciseTable {
  final tableName = 'exercises';

  Future<void> createTable(Database database) async {
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

    return await database.insert(tableName, exercise.toMap());
  }

  Future<List<Exercise>> getAll() async {
    final database = await DatabaseService().database;

    final exercises = await database.rawQuery(
      '''select distinct * from $tableName;'''
    );

    return exercises.map((e) => Exercise.fromMap(e)).toList();
  }

  Future<Exercise> getById(String id) async {
    final database = await DatabaseService().database;
    final exercise = await database.query(tableName, where: "id = '$id'");

    return Exercise.fromMap(exercise.first);
  }

  // put
  Future<int> updateById(String id) async {
    final database = await DatabaseService().database;

    return 1;
  }

// delete
}
