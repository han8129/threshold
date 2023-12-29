import 'dart:ffi';
import 'dart:io';

import 'package:demo_app_2/database/exercises.dart' as Exercises;
import 'package:flutter/animation.dart';
class Exercise {
  late String id;
  late String name;
  late int sets;
  late double restMinutes;
  late int reps;
  bool isSynced = false;

  Map<String, Object?> toMap() {
    return <String, Object?>{
      Exercises.columnId : id,
      Exercises.columnName : name,
      Exercises.columnSets : sets.toString(),
      Exercises.columnRestMinutes : restMinutes.toString(),
      Exercises.columnReps : reps.toString(),
    };
  }

  Exercise( this.name, this.sets, this.restMinutes, this.reps ) {
    id = name
        + sets.toString()
        + restMinutes.toString()
        + reps.toString();
  }

  Exercise.fromMap(Map<String, Object?> map) {
    name = map[Exercises.columnName] as String;
    sets = map[Exercises.columnSets] as int;
    restMinutes = map[Exercises.columnRestMinutes] as double;
    reps = map[Exercises.columnReps] as int;
    id = map[Exercises.columnId] as String;
    isSynced = (map[Exercises.columnIsSynced] as int == 1);
  }

  set setIsSynced(bool value){
    isSynced = value;
  }
}