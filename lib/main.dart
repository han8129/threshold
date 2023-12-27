import 'dart:convert';
import 'dart:io';

import 'view/record/index.dart';
import 'package:redis/redis.dart';
import 'package:flutter/material.dart';
import 'view/exercise/create.dart';
import 'repository/exercise_repository.dart';
import 'model/exercise.dart';
import 'repository/migration.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
     runApp(MaterialApp(
       title: 'My Next PR',
       theme: ThemeData(
         useMaterial3: true,
         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
       ),
       home: Index(exercise: Exercise('abc', 3, 3.0, 1)),
     ));
   }