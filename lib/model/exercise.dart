import '/database/local/exercises.dart';

class Exercise {
  late String id;
  late String name;
  late int sets;
  late double restMinutes;
  late int reps;
  bool isSynced = false;

  Map<String, String> toMap() {
    return <String, String>{
      columnId: id,
      columnName: name,
      columnSets: sets.toString(),
      columnRestMinutes: restMinutes.toString(),
      columnReps: reps.toString(),
      columnIsSynced: (isSynced) ? '1' : '0',
    };
  }

  Map<String, String> toMapNoId() {
    return <String, String>{
      columnName: name,
      columnSets: sets.toString(),
      columnRestMinutes: restMinutes.toString(),
      columnReps: reps.toString(),
    };
  }

  Exercise(this.id, this.name, this.sets, this.restMinutes, this.reps);

  Exercise.fromMap(Map<String, Object?> map) {
    name = map[columnName] as String;
    sets = map[columnSets] as int;
    restMinutes = map[columnRestMinutes] as double;
    reps = map[columnReps] as int;
    id = map[columnId] as String;
    isSynced = (map[columnIsSynced] as int == 1);
  }

  set setIsSynced(bool value) {
    isSynced = value;
  }
}

