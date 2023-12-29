import '../../database/exercises.dart';
import '../../model/exercise.dart';
import 'create.dart';
import '../record/index.dart' as record;
import 'package:flutter/material.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  Future<List<Exercise>>? futureExercises;
  final exercisesRepository = ExercisesRepository();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getExercises();
  }

  void getExercises() {
    setState(() {
      futureExercises = exercisesRepository.getAll();
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
                          Row(
                            children: [
                              Text(
                                'Sets ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('$sets ')
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Rest Minutes ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('$restMinutes ')
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Reps ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("$reps ")
                            ],
                          )
                        ],
                      ),
                      trailing: IconButton(
                        onPressed: () async {
                          exercisesRepository.getAll();
                        },
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
              builder: (_) => CreateExerciseWidget(onSubmit: (exercise) async {
                await exercisesRepository.create(exercise);

                if (!mounted) return;

                getExercises();

                Navigator.of(context).pop();
              }),
            );
          },
        ),
      );
}
