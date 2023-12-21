import 'dart:ffi';

class Exercise {
  late String id;
  String name;
  int sets;
  double restMinutes;
  int reps;

  Exercise( this.name, this.sets, this.restMinutes, this.reps) {
    id = name.hashCode.toString()
        + sets.toString()
        + restMinutes.toString()
        + reps.toString();
  }
}