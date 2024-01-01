import '/database/local/deleted_exercises.dart';

import '../../database/local/exercises.dart';
import '../../model/exercise.dart';
import 'create.dart';
import '../record/index.dart' as record;
import 'package:flutter/material.dart';
import '/database/remote/exercises.dart' as remote_repository;
import 'update.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  Future<List<Exercise>>? futureExercises;
  final localExercisesRepository = ExercisesRepository();
  final deletedExercises = DeletedExercisesRepository();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getExercises();
  }

  void getExercises() {
    setState(() {
      futureExercises = localExercisesRepository.getAll();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Exercises"),
        ),
        body: FutureBuilder<List<Exercise>>(
          future: futureExercises,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final exercises = snapshot.data;

              if (exercises == null || exercises.isEmpty) {
                return const Center(
                  child: Text(
                    'No exercises...',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  ),
                );
              }

              return ListView.separated(
                  itemBuilder: (context, index) {
                    final Exercise exercise = exercises[index];
                    final name = exercise.name;
                    final sets = exercise.sets;
                    final restMinutes = exercise.restMinutes;
                    final reps = exercise.reps;

                    return ListTile(
                      title: Text(name),
                      subtitle: Row(
                        children: [
                          Text(
                            'Sets ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('$sets '),
                          Text(
                            'Rest Minutes ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('$restMinutes '),
                          Text(
                            'Reps ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text("$reps "),
                          IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => Update(
                                          exercise: exercise,
                                          onSubmit: (updatedExercise) async =>
                                              update(updatedExercise),
                                        ));
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.yellow,
                              )),
                        ],
                      ),
                      trailing: IconButton(
                        onPressed: () async => delete(exercise),
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    record.Index(exercise: exercise)));
                      },
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 12,
                      ),
                  itemCount: exercises.length);
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) =>
                  Create(onSubmit: (exercise) async => await create(exercise)),
            );
          },
        ),
      );

  create(Exercise exercise) async {
    final bool isSynced = await remote_repository.post(exercise);
    exercise.isSynced = isSynced;

    await localExercisesRepository.create(exercise);

    if (!mounted) return;

    getExercises();

    Navigator.pop(context);
  }

  update(Exercise exercise) async {
    exercise.isSynced = await remote_repository.put(exercise);

    await localExercisesRepository.update(exercise);

    if (!mounted) return;

    Navigator.of(context).pop();

    getExercises();
  }

  delete(Exercise exercise) async {
    if (0 > await localExercisesRepository.delete(exercise)) return;

    await deletedExercises.create(exercise);

    final bool isSynced = await remote_repository.delete(exercise.id);

    if (isSynced) {
      await deletedExercises.delete(exercise);
    }

    getExercises();
  }
}
