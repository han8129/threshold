import '/database/sync.dart';
import 'package:sqflite_common/sqlite_api.dart';

import '/database/remote/exercises.dart';
import 'database/local/database_service.dart';
import 'view/exercise/index.dart';
import 'package:redis/redis.dart';
import 'package:flutter/material.dart';
import 'view/exercise/create.dart';
import 'model/exercise.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: 'My Next PR',
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
    ),
    home: Index(),
  ));

 // sync();
}
