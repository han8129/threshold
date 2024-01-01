import '/database/local/exercises.dart';
import '/model/exercise.dart';
import 'package:sqflite/sqflite.dart';
import 'database_service.dart';
import '../../model/record.dart';

const columnId = 'id';
const columnExerciseId = 'exercise_id';
const columnDate = 'date';
const columnDurationSeconds = 'duration_seconds';
const columnNote = 'note';
const columnIsSynced = 'is_synced';
const int unSynced = 0;
const tableName = 'deleted_records';

class DeletedRecordsTable {
  Future<void> createTable(Database database) async {
    await database.execute('''
CREATE TABLE IF NOT EXISTS "$tableName" (
	$columnId	TEXT NOT NULL UNIQUE,
	$columnExerciseId	TEXT NOT NULL,
	$columnDate	TEXT NOT NULL,
	$columnDurationSeconds	REAL NOT NULL,
	$columnNote	TEXT,
	$columnIsSynced INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY("id"),
	FOREIGN KEY("exercise_id") REFERENCES "exercises"("id") ON DELETE CASCADE on UPDATE CASCADE
)
    ''');
  }

  Future<int> create(Record record) async {
    final database = await DatabaseService.database;

    return await database.insert(tableName, record.toMap());
  }

  Future<List<Record>> getAll() async {
    final database = await DatabaseService.database;
    final records = await database.query(tableName, distinct: true);

    return records.map((record) => Record.fromMap(record)).toList();
  }

  Future<List<Record>> getByExerciseId(String id) async {
    final database = await DatabaseService.database;

    final records =
        await database.query(tableName, where: '$columnExerciseId = $id');

    return records
        .map((element) => Record(
            element[columnId] as String,
            element[columnExerciseId] as String,
            element[columnDurationSeconds] as double,
            DateTime.parse(element[columnDate] as String)))
        .toList();
  }

  Future<Record> getById(String id) async {
    final database = await DatabaseService.database;
    final records = await database.query(tableName, where: "id = $id");

    final record = records.last;

    return Record(
        id,
        record[columnExerciseId] as String,
        record[columnDurationSeconds] as double,
        record[columnDate] as DateTime);
  }

// delete
  Future<int> delete(Record record) async {
    final database = await DatabaseService.database;
    return await database
        .delete(tableName, where: 'id = ?', whereArgs: [record.id]);
  }
}
