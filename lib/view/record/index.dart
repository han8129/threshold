import 'package:demo_app_2/database/records.dart';

import '../../model/exercise.dart';
import '../../model/record.dart';
import 'create.dart';
import 'package:flutter/material.dart';

class Index extends StatefulWidget {
  final Exercise exercise;
  const Index({super.key, required this.exercise});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  Future<List<Record>>? futureRecords;
  final recordsTable = RecordsTable();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getExercises();
  }

  void getExercises() {
    setState(() {
      futureRecords = recordsTable.getAll();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Exercises ${widget.exercise.name}"),
        ),
        body: FutureBuilder<List<Record>>(
          future: futureRecords,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final records = snapshot.data;

              if (records == null || records.isEmpty) {
                return const Center(
                  child: Text(
                    'No records...',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  ),
                );
              }

              return ListView.separated(
                  itemBuilder: (context, index) {
                    final Record record = records[index];
                    final String date = record.date.toString();
                    final duration = record.durationInSeconds.toString();
                    final note = record.note;

                    return ListTile(
                      title: Text(date),
                      subtitle: Row(
                        children: [
                          Text(
                            'Duration ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('$duration '),
                          (note == null) ? Text('') :
                            Text(
                              'Note ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),

                          (note == null) ? Text('') : Text('$note '),
                        ],
                      ),
                      trailing: IconButton(
                        onPressed: () async {
                          recordsTable.getAll();
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => CreateExerciseWidget(
                                    onSubmit: (exercise) async {
                                  await recordsTable.updateById(exercise.id);

                                  recordsTable.getAll();

                                  if (!mounted) return;
                                  Navigator.of(context).pop();
                                }));
                      },
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 12,
                      ),
                  itemCount: records.length);
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => CreateExerciseWidget(onSubmit: (exercise) async {
                await recordsTable.create(exercise as Record);

                if (!mounted) return;

                getExercises();

                Navigator.of(context).pop();
              }),
            );
          },
        ),
      );
}