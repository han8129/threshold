import 'dart:io';

import 'package:redis/redis.dart';
import 'package:flutter/material.dart';
import 'view/exercise/create.dart';
import 'repository/exercise_repository.dart';
import 'model/exercise.dart';

void main() {
      RedisConnection().connect("localhost", 6379).then((command) async {
       ExerciseRepository exerciseRepository = ExerciseRepository(command);
       Exercise exercise = Exercise("squad", 3, 1, 3);
       await exerciseRepository.insert(exercise);
       Exercise result = await exerciseRepository.getById(exercise.id);
       print(result.id);
     });


     runApp(MaterialApp(
       title: 'My Next PR',
       theme: ThemeData(
         useMaterial3: true,
         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
       ),
       home: RegisterView(),
     ));
   }
