import 'package:intl/intl.dart';

import '/model/exercise.dart';
import '/database/local/records.dart';

class Record {
  late String id;
  late String exerciseId;
  late double durationInSeconds;
  late DateTime date;
  late String note;
  bool isSynced = false;

  Record(this.id, this.exerciseId, this.durationInSeconds, this.date, [this.note = '']) ;

  setNote(String note) {
    this.note = note;
  }

  Map<String, String> toMap() {
    return <String, String>{
      columnId: id,
      columnExerciseId: exerciseId,
      columnDate: date.toString().substring(0, 10),
      columnDurationSeconds: durationInSeconds.toString(),
      columnNote: note,
    };
  }

  Record.fromMap(Map<String, Object?> map) {
    date = DateTime.parse(map[columnDate] as String);
    durationInSeconds = map[columnDurationSeconds] as double;
    exerciseId = map[columnExerciseId] as String;
    note = (map[columnNote] as String);
    id = map[columnId] as String;
  }

  set setIsSynced(bool value){
    isSynced = value;
  }
}
