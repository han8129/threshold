import 'package:intl/intl.dart';

import '../../model/record.dart';

import '../../model/exercise.dart';
import 'package:flutter/material.dart';

class Update extends StatelessWidget {
  final ValueChanged<Record> onSubmit;
  final dateField = TextEditingController();
  final durationField = TextEditingController();
  final noteField = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final Exercise exercise;
  final Record record;

  Update(
      {Key? key,
      required this.exercise,
      required this.onSubmit,
      required this.record})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    dateField.text = DateFormat.yMd().format(record.date);
    durationField.text = record.durationInSeconds.toString();
    noteField.text = record.note;

    return AlertDialog(
      title: Text('Add Record'),
      content: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                  controller: dateField,
                  decoration: InputDecoration(
                      labelText: 'Date', helperText: 'DD/MM/YYYY'),
                  validator: (value) {
                    return (value == null)
                        ? null
                        : (DateTime.tryParse(value) != null)
                            ? 'Invalid Date'
                            : null;
                  }),
              TextFormField(
                controller: durationField,
                validator: (value) {
                  if (value == '') return 'Duration is required';

                  if (null == double.tryParse(value!)) {
                    return "Invalid Number";
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: noteField,
                decoration: InputDecoration(
                  labelText: 'Note',
                ),
              )
            ],
          )),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        TextButton(
            onPressed: () => {
              if (formKey.currentState!.validate()) onSubmit(getNewRecord())
    } , child: const Text('OK'))
      ],
    );
  }

  Record getNewRecord() {
    DateTime date = (dateField.text.isEmpty)
        ? DateTime.now()
        : DateTime.parse(dateField.text);
    double duration = double.parse(durationField.text);

    return (noteField.text == '')
        ? Record(record.id, exercise.id, duration, date)
        : Record(record.id, exercise.id, duration, date, noteField.text);
  }
}

Widget getTextField(
    TextEditingController controller, String label, String initialValue) {
  return TextFormField(
    autofocus: true,
    controller: controller,
    initialValue: initialValue,
    decoration: InputDecoration(labelText: label),
    validator: (value) =>
        value != null && value.isEmpty ? '$label is required' : null,
  );
}
