import 'package:demo_app_2/model/exercise.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redis/redis.dart';

class CreateExerciseWidget extends StatefulWidget {
  final Exercise? exercise;
  final ValueChanged<Exercise> onSubmit;

  const CreateExerciseWidget({
    Key? key,
    this.exercise,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<CreateExerciseWidget> createState() => _CreateExerciseWidgetState();
}

class _CreateExerciseWidgetState extends State<CreateExerciseWidget> {
  final name = TextEditingController();
  final sets = TextEditingController();
  final restMinutes = TextEditingController();
  final reps = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.exercise != null)
    {
      name.text = widget.exercise!.name;
      sets.text = widget.exercise!.sets.toString();
      reps.text = widget.exercise!.reps.toString();
      restMinutes.text = widget.exercise!.restMinutes.toString();

      return;
    }

  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.exercise != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Exercise' : 'Add Exercise'),
      content: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                autofocus: true,
                controller: name,
                decoration: const InputDecoration(hintText: 'Name'),
                validator: (value) =>
                value != null && value.isEmpty ? 'Name is required' : null,
              ),
              TextFormField(
                autofocus: true,
                controller: sets,
                decoration: const InputDecoration(hintText: 'Sets'),
                validator: (value) =>
                value != null && value.isEmpty ? 'Sets is required' : null,
              ),
              TextFormField(
                autofocus: true,
                controller: restMinutes,
                decoration: const InputDecoration(hintText: 'Rest Minutes'),
                validator: (value) => value != null && value.isEmpty
                    ? 'Rest Minutes is required'
                    : null,
              ),
              TextFormField(
                autofocus: true,
                controller: reps,
                decoration: const InputDecoration(hintText: 'Reps'),
                validator: (value) =>
                value != null && value.isEmpty ? 'Reps is required' : null,
              ),
            ],
          )),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        TextButton(
            onPressed: () => {
              if (formKey.currentState!.validate())
                widget.onSubmit(Exercise(name.text, int.parse(sets.text),
                    double.parse(restMinutes.text), int.parse(reps.text)))
            },
            child: const Text('OK'))
      ],
    );
  }
}
