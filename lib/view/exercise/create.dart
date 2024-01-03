import '../../model/exercise.dart';
import 'package:flutter/material.dart';
import "package:uuid/uuid.dart";

class Create extends StatelessWidget {
  final ValueChanged<Exercise> onSubmit;
  final name = TextEditingController();
  final sets = TextEditingController();
  final restMinutes = TextEditingController();
  final reps = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Create({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('New Exercise'),
      content: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                autofocus: true,
                controller: name,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Name is required'
                    : null,
              ),
              TextFormField(
                controller: sets,
                decoration: InputDecoration(labelText: 'Sets'),
                validator: (value) => validateSets(value),
              ),
              TextFormField(
                controller: restMinutes,
                decoration: InputDecoration(labelText: 'Rest Minutes'),
                validator: (value) => validateRestMinutes(value),
              ),
              TextFormField(
                  controller: reps,
                  decoration: InputDecoration(labelText: 'Reps'),
                  validator: (value) => validateReps(value)),
            ],
          )),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        TextButton(
            onPressed: () => {
                  if (_formKey.currentState!.validate())
                    onSubmit(Exercise(
                        Uuid().v1(),
                        name.text,
                        int.parse(sets.text),
                        double.parse(restMinutes.text),
                        int.parse(reps.text)))
                },
            child: const Text('OK'))
      ],
    );
  }
}

String? validateSets(String? value) {
  if (value == null || value.isEmpty) {
    return 'Sets is required';
  }

  if (int.tryParse(value) == null) {
    return 'Not a valid number';
  }

  return null;
}

String? validateRestMinutes(String? value) {
  if (value == null || value.isEmpty) {
    return 'Sets is required';
  }

  if (double.tryParse(value) == null) {
    return 'Not a valid number';
  }

  return null;
}

String? validateReps(String? value) {
  if (value == null || value.isEmpty) {
    return 'Sets is required';
  }

  if (int.tryParse(value) == null) {
    return 'Not a valid number';
  }

  return null;
}
