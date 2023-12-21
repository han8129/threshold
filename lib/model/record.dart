import '/model/exercise.dart';

class Record {
  Exercise exercise;
  double durationInSeconds;
  DateTime date;
  String ?note;

  Record(this.exercise, this.durationInSeconds, this.date);

  setNote(String note)
  {
    this.note = note;
  }

}