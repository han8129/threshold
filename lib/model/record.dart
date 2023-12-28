import 'package:intl/intl.dart';

import '/model/exercise.dart';

const columnId = 'id';
const columnExerciseId = 'exercise_id';
const columnDate = 'date';
const columnDurationSeconds = 'duration_seconds';
const columnNote = 'note';

class Record {
  late String id;
  late Exercise exercise;
  late double durationInSeconds;
  late DateTime date;
  String? note;

  Record(this.exercise, this.durationInSeconds, this.date, [this.note]) {
    id = exercise.name + durationInSeconds.toString() + date.toString();
  }

  setNote(String note) {
    this.note = note;
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      columnId: id,
      columnExerciseId: exercise.id,
      columnDate: date.toString().substring(0, 10),
      columnDurationSeconds: durationInSeconds,
      columnNote: note,
    };
  }
}
