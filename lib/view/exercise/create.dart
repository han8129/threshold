import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redis/redis.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _exercise_name = TextEditingController();
  final TextEditingController _rest_minutes = TextEditingController();
  final TextEditingController _sets = TextEditingController();
  final TextEditingController _reps = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    this._exercise_name.dispose();
    this._rest_minutes.dispose();
    this._sets.dispose();
    this._reps.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: FutureBuilder(
          future: RedisConnection().connect('localhost', 6379),
          builder: (context, snapshot) {
            return Column(
              children: [
                TextField(
                  controller: _exercise_name,
                  decoration: const InputDecoration(
                    hintText: "Enter exercise.dart's name",
                  ),
                  maxLength: 50,
                ),
                TextField(
                  controller: _rest_minutes,
                  decoration: const InputDecoration(
                    hintText: "Minutes of Rest",
                  ),
                  maxLength: 50,
                ),
                TextField(
                  controller: _sets,
                  decoration: const InputDecoration(
                    hintText: "Number of Sets",
                  ),
                  maxLength: 50,
                ),
                TextField(
                  controller: _reps,
                  decoration: const InputDecoration(
                    hintText: "Number of Reps",
                  ),
                  maxLength: 50,
                ),
                TextButton(
                  onPressed: () async {
                    final String name = this._exercise_name.text;
                    final String rest_minutes = this._rest_minutes.text;
                    final String sets = this._sets.text;
                    final String reps = this._reps.text;

                    if (name.isEmpty ||
                        reps.isEmpty ||
                        sets.isEmpty ||
                        rest_minutes.isEmpty) {
                      return;
                    }

                    final String id = (name +
                        rest_minutes +
                        sets +
                        reps)
                        .hashCode
                        .toString();

                    switch (snapshot.connectionState) {
                      case ConnectionState.done:
                      // TODO: Handle this case.
                        snapshot.data?.send_object([
                          "hset",
                          "movements:$id",
                          "name",
                          name,
                          "rest_minutes",
                          rest_minutes,
                          "sets",
                          sets,
                          "reps",
                          reps
                        ]).then((var response) => {
                          if (response > 0)
                            {
                              setState(() {
                                dispose();
                              })
                            }
                          else
                            {print("failed")}
                        });
                      default:
                    }
                  },
                  child: const Text("Show user"),
                ),
              ],
            );
          }),
    );
  }
}
