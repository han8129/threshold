import 'dart:ffi';
import 'dart:io';

import 'package:flutter/animation.dart';
const String columnId = 'id';
const columnName = 'name' ;
const columnSets = 'sets';
const columnRestMinutes = 'rest_minutes';
const columnReps = 'reps';

class Exercise {
  late String id;
  late String name;
  late int sets;
  late double restMinutes;
  late int reps;

  Map<String, Object?> toMap() {
    return <String, Object?>{
      columnId : id,
      columnName : name,
      columnSets : sets,
      columnRestMinutes : restMinutes,
      columnReps : reps,
    };
  }

  Exercise( this.name, this.sets, this.restMinutes, this.reps ) {
    id = name.hashCode.toString()
        + sets.toString()
        + restMinutes.toString()
        + reps.toString();
  }

  Exercise.fromMap(Map<String, Object?> map) {
    name = map[columnName] as String;
    sets = map[columnSets] as int;
    restMinutes = map[columnRestMinutes] as double;
    reps = map[columnReps] as int;

    id = name
        + sets.toString()
        + restMinutes.toString()
        + reps.toString();

  }
}