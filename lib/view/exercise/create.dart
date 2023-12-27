import '../../model/exercise.dart';
import 'package:flutter/material.dart';

class CreateExerciseWidget extends StatelessWidget {
  final Exercise? exercise;
  final ValueChanged<Exercise> onSubmit;
  final name = TextEditingController();
  final sets = TextEditingController();
  final restMinutes = TextEditingController();
  final reps = TextEditingController();
  final formKey = GlobalKey<FormState>();

  CreateExerciseWidget({
    Key? key,
    this.exercise,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isEditing = exercise != null;
    return AlertDialog(
      title: Text(isEditing ? 'Edit Exercise' : 'Add Exercise'),
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
                    onSubmit(Exercise(name.text, int.parse(sets.text),
                        double.parse(restMinutes.text), int.parse(reps.text)))
                },
            child: const Text('OK'))
      ],
    );
  }
}

Widget getTextField(TextEditingController controller, String label) {
  return               TextFormField(
      autofocus: true,
      controller: controller,
      decoration: InputDecoration(hintText: label),
  validator: (value) =>
      value != null && value.isEmpty ? '$label is required' : null,
  );
}
