import 'package:intl/intl.dart';

import '../../model/record.dart';

import '../../model/exercise.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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
    dateField.text = DateFormat.yMd().format(DateTime.now());

    return AlertDialog(
      title: Text('Add Record'),
      content: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                  autofocus: false,
                  controller: dateField,
                  decoration: InputDecoration(labelText: 'Date'),
                  validator: (value) => (value == null)
                      ? null
                      : (DateTime.tryParse(value) != null)
                          ? 'Invalid Date'
                          : null),
              TextFormField(
                autofocus: true,
                controller: durationField,
                decoration: InputDecoration(
                    labelText: 'Duration in Seconds', hintText: 'Eg: 1.1'),
                validator: (number) {
                  if (null == number) {
                    return 'Duration is required';
                  }
                  if (null == double.tryParse(number)) {
                    return "Not a valid number";
                  }

                  return null;
                },
              ),
              TextFormField(
                  controller: noteField,
                  decoration: InputDecoration(labelText: 'Note')),
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
    DateTime date = (DateFormat.yMd().format(DateTime.now()) == dateField.text)
        ? DateTime.now()
        : DateTime.parse(dateField.text);
    double duration = double.parse(durationField.text);

    return (noteField.text == '')
        ? Record(Uuid().v1(), exercise.id, duration, date)
        : Record(Uuid().v1(), exercise.id, duration, date, noteField.text);
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
