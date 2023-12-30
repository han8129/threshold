import 'dart:io';

import 'package:demo_app_2/model/exercise.dart';
import 'package:demo_app_2/model/record.dart';

import './local/records.dart';
import './local/exercises.dart';
import './remote/exercises.dart' as remote_exercises;
import './remote/records.dart' as remote_records;

const success = 1;

Future<void> sync() async {
  while (true) {
    print('New loop');
    final List<Record> unsyncedRecords = await RecordsTable().getUnsynced();

    if (unsyncedRecords.isNotEmpty) {
      for (var record in unsyncedRecords) {
        print(record.toMap());
        if (success == remote_records.post(record)) {
          record.isSynced = true;
          RecordsTable().update(record);
        }
      }
    }

    final unsyncedExercises = await ExercisesRepository().getUnsynced();
    if (unsyncedExercises.isNotEmpty) {
      for (Exercise exercise in unsyncedExercises) {
        print(exercise.toMap());
        if (success == remote_exercises.post(exercise)) {
          exercise.isSynced = true;
          ExercisesRepository().update(exercise);
        }
      }
    }

    // deleting unsynced row

    await Future.delayed(Duration(seconds: 17));
  }
}
