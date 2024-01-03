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
                validator: (value) => validateDate(value),
              ),
              TextFormField(
                autofocus: true,
                controller: durationField,
                decoration: InputDecoration(
                    labelText: 'Duration in Seconds', hintText: 'Eg: 1.1'),
                validator: (value) => validateDate(value),
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

  String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      dateField.text = DateFormat.yMd().format(DateTime.now());
      return 'Date is required';
    }

    if (DateTime.tryParse(value) == null) return 'Invalid Date';

    return null;
  }

  validateDuration(String? value) {
    if (null == value) {
      return 'Duration is required';
    }

    if (null == double.tryParse(value)) {
      return "Not a valid number";
    }

    return null;
  }

  Record getNewRecord() {
    DateTime date = DateFormat.yMd().parse(dateField.text);

    double duration = double.parse(durationField.text);

    return Record(Uuid().v1(), exercise.id, duration, date, noteField.text);
  }
}
