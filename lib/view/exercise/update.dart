import '../../model/exercise.dart';
import 'package:flutter/material.dart';

class Update extends StatelessWidget {
  final Exercise exercise;
  final ValueChanged<Exercise> onSubmit;
  final formKey = GlobalKey<FormState>();

  Update({
    Key? key,
    required this.exercise,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = TextEditingController(text: exercise.name);
    final sets = TextEditingController(text: exercise.sets.toString());
    final restMinutes =
        TextEditingController(text: exercise.restMinutes.toString());
    final reps = TextEditingController(text: exercise.reps.toString());

    return AlertDialog(
      title: Text('Edit Exercise'),
      content: Form(
          key: formKey,
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
                  if (formKey.currentState!.validate())
                    onSubmit(Exercise(
                        exercise.id,
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
