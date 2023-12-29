import 'dart:convert';
import 'dart:io';
import '/model/exercise.dart';
import 'package:http/http.dart' as http;
import '/database/exercises.dart' as exercises_repository;

const String url = 'http://127.0.0.1:8000/exercises';
// when insert a new hash set if success redis respond with the number fields
// eg (integer) 4
const String success = '4';

Future<bool> post(Exercise exercise) async {
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(exercise.toMap()));

  return success == (jsonDecode(response.body) as Map)['integer'];
}

Future<bool> put(Exercise newExercise) async {
  try {

    final http.Response response = await http.put(Uri.parse('$url/${newExercise.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          exercises_repository.columnName : newExercise.name,
          exercises_repository.columnSets : newExercise.sets.toString(),
          exercises_repository.columnRestMinutes : newExercise.restMinutes.toString(),
          exercises_repository.columnReps : newExercise.reps.toString()
        }));

    return success == (jsonDecode(response.body) as Map)['integer'];
  } on HttpException {
    return false;
  }
}

Future<bool> delete(String id) async {
  try {
    final http.Response response = await http.delete(Uri.parse('$url$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });

    return success == (jsonDecode(response.body) as Map)['integer'];
  } on HttpException {
    return false;
  }
}
