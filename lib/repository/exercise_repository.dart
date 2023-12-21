import 'package:redis/redis.dart';
import '../model/exercise.dart';

class ExerciseRepository {
  Command connection;

  ExerciseRepository(this.connection);

  Future<bool> insert(Exercise exercise) async {
    var response = await connection.send_object([
            "hset",
            "exercise:${exercise.id}",
            "name", exercise.name,
            "sets", exercise.sets.toString(),
            "rest_minutes", exercise.restMinutes.toString()
            ,"reps", exercise.reps.toString()
          ]);

    if ( response > 0) {
      return true;
    }

    return false;
  }

  Future<Exercise> getById(String id) async
  {
    var attributes = await connection.send_object(["hgetall", "exercise:$id"]);
    String name = attributes[1];
    int sets = int.parse(attributes[3]);
    double restMinutes = double.parse(attributes[5]);
    int reps = int.parse(attributes[7]);
    return Exercise(name, sets, restMinutes, reps);
  }
}
