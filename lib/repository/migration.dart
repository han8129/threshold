import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common/sqlite_api.dart';

var databaseFactory = databaseFactoryFfi;

var migration = databaseFactory.openDatabase('data.db')
    .then((Database value) async => {
  await value.execute('''
CREATE TABLE IF NOT EXISTS `exercises` (
  `id` TEXT UNIQUE PRIMARY KEY NOT NULL,
  `name` TEXT NOT NULL,
    `rest_minutes` REAL,
  `sets` INTEGER,
  `reps` INTEGER
);

CREATE TABLE IF NOT EXISTS `records` (
`id` TEXT PRIMARY KEY,
  `exercises_id` TEXT NOT NULL
      REFERENCES `exercises` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  `date` TEXT,
  `duration_seconds` REAL,
  `note` TEXT
);
  ''')
});
