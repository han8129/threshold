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
              getTextField(name, 'Name'),
              getTextField(sets, 'Sets'),
              getTextField(restMinutes, 'Rest minutes'),
              getTextField(reps, 'Reps'),
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

Widget getTextField(TextEditingController controller, String label) {
  return TextFormField(
    autofocus: true,
    controller: controller,
    decoration: InputDecoration(labelText: label),
    validator: (value) =>
        value != null && value.isEmpty ? '$label is required' : null,
  );
}
