import 'dart:ffi';

class Exercise {
  String ?id;
  String name;
  int sets;
  Float restMinutes;
  int reps;

  Exercise( this.name, this.sets, this.reps, this.restMinutes) {
    id = name.hashCode.toString()
        + sets.toString()
        + restMinutes.toString()
        + reps.toString();
  }
}

Exercise exercise = Exercise("squad", 3, 1, 3.0 as Float);