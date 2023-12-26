import 'package:flutter/material.dart';
import 'package:redis/redis.dart';

final class RecordView extends StatefulWidget {
  const RecordView({Key? key}) : super(key: key);

  @override
  State<RecordView> createState() => _RecordViewState();
}

class _RecordViewState extends State<RecordView> {
  final TextEditingController _exercise_name = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    this._exercise_name.dispose();
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
                ElevatedButton(
                  onPressed: () async {
                    final String name = this._exercise_name.text;
                    print("Pressed");
                    if (name.isEmpty) {
                      return;
                    }
                    switch (snapshot.connectionState) {
                      case ConnectionState.done:
                        // TODO: Handle this case.
                        snapshot.data
                            ?.send_object(["SMEMBERS", "movements"]).then(
                                (var response) => print(response.runtimeType));
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
