import 'package:demo_app_2/database/exercises.dart';
import 'package:demo_app_2/model/exercise.dart';
import 'package:sqflite/sqflite.dart';
import 'database_service.dart';
import '../model/record.dart';

class RecordsTable {
  final tableName = 'records';
  late final ExercisesRepository exercisesRepository;

  RecordsTable() {
    exercisesRepository = ExercisesRepository();
  }

  Future<void> createTable(Database database) async {
    await database.execute('''
CREATE TABLE IF NOT EXISTS "$tableName" (
	"id"	TEXT NOT NULL UNIQUE,
	"exercise_id"	TEXT NOT NULL,
	"date"	TEXT NOT NULL,
	"duration_seconds"	REAL NOT NULL,
	"note"	TEXT,
	PRIMARY KEY("id"),
	FOREIGN KEY("exercise_id") REFERENCES "exercises"("id") ON DELETE CASCADE on UPDATE CASCADE
)
);
    ''');
  }

  Future<int> create(Record record) async {
    final database = await DatabaseService().database;

    return await database.insert(tableName, record.toMap());
  }

  Future<List<Record>> getAllByExerciseId(String id) async {
    final database = await DatabaseService().database;

    final records =
        await database.rawQuery('''select distinct * from $tableName where exercise_id = "$id"''');

    var list = <Record>[];
    Exercise exercise =
    await exercisesRepository.getById(id);
    records.forEach((element) async {

      list.add(Record(exercise, element[columnDurationSeconds] as double,
          DateTime.parse(element[columnDate] as String)));
    });

    return list;
  }

  Future<Record> getById(String id) async {
    final database = await DatabaseService().database;
    final records = await database.query(tableName, where: "id = $id");

    final record = records.last;
    Exercise exercise =
        await exercisesRepository.getById(record[columnExerciseId] as String);

    return Record(exercise, record[columnDurationSeconds] as double,
        record[columnDate] as DateTime);
  }

  // put
  Future<int> updateById(String id) async {
    final database = await DatabaseService().database;

    return 1;
  }

// delete
}
