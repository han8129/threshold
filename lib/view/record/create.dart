import 'package:intl/intl.dart';

import '../../model/record.dart';

import '../../model/exercise.dart';
import 'package:flutter/material.dart';

class Create extends StatelessWidget {
  final ValueChanged<Record> onSubmit;
  final dateField = TextEditingController();
  final durationField = TextEditingController();
  final noteField = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final Exercise exercise;

  Create({
    Key? key,
    required this.exercise,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Record'),
      content: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                  autofocus: false,
                  controller: dateField,
                  decoration: InputDecoration(
                      hintText: DateFormat.yMd().format(DateTime.now())),
                  validator: (value) => (value == null)
                      ? null
                      : (DateTime.tryParse(value) != null)
                          ? 'Invalid Date'
                          : null),
              getTextField(durationField, 'Duration (eg: 1.1s)'),
              getTextField(noteField, 'Note'),
            ],
          )),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        TextButton(
            onPressed: () => onSubmit(getNewRecord()), child: const Text('OK'))
      ],
    );
  }

  Record getNewRecord() {
    DateTime date = (dateField.text.isEmpty)
        ? DateTime.now()
        : DateTime.parse(dateField.text);
    double duration = double.parse(durationField.text);

    return (noteField.text == '')
        ? Record(exercise, duration, date)
        : Record(exercise, duration, date, noteField.text);
  }
}

Widget getTextField(TextEditingController controller, String label) {
  return TextFormField(
    autofocus: true,
    controller: controller,
    decoration: InputDecoration(hintText: label),
    validator: (value) =>
        value != null && value.isEmpty ? '$label is required' : null,
  );
}
