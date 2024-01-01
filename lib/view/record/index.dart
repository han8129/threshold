import '/database/local/deleted_records.dart';
import '/view/record/update.dart';

import '/database/local/records.dart';
import 'package:intl/intl.dart';

import '/model/exercise.dart';
import '/model/record.dart';
import 'create.dart';
import 'package:flutter/material.dart';
import '/database/remote/records.dart' as remote_repository;

class Index extends StatefulWidget {
  final Exercise exercise;
  const Index({super.key, required this.exercise});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  Future<List<Record>>? futureRecords;
  final localRepository = RecordsTable();
  final deletedRepository = DeletedRecordsTable();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getRecords();
  }

  void getRecords() {
    setState(() {
      futureRecords = localRepository.getByExerciseId(widget.exercise.id);
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
                    final String date = DateFormat.yMd().format(record.date);
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
                          (note == '')
                              ? Text('')
                              : Text(
                                  'Note ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                          (note == '') ? Text('') : Text('$note '),
                          IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => Update(
                                          record: record,
                                          exerciseId: widget.exercise.id,
                                          onSubmit: (record) async =>
                                              update(record),
                                        ));
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.yellow,
                              )),
                        ],
                      ),
                      trailing: IconButton(
                        onPressed: delete(record),
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
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
              builder: (_) => Create(
                  exercise: widget.exercise,
                  onSubmit: (record) async => await create(record)),
            );
          },
        ),
      );

  create(Record record) async {
    record.isSynced = await remote_repository.post(record);

    await localRepository.create(record);

    if (!mounted) return;

    getRecords();

    Navigator.of(context).pop();
  }

  delete(Record record) async {
    if (1 > await localRepository.delete(record)) return;

    await deletedRepository.create(record);

    final bool isSynced = await remote_repository.delete(record.id);

    if (isSynced) deletedRepository.delete(record);

    getRecords();
  }

  update(Record record) async {
    await localRepository.update(record);

    if (!mounted) return;

    getRecords();

    Navigator.of(context).pop();
  }
}
