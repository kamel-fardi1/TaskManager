// ignore: file_names
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home/home.dart';
import 'home/taskInfo.dart';

// ignore: camel_case_types
class syncview extends StatefulWidget {
  const syncview({super.key});

  @override
  State<syncview> createState() => _syncviewState();
}

// ignore: camel_case_types
class _syncviewState extends State<syncview> {
  final String _baseUrl = "10.0.2.2:9090";

  // ignore: non_constant_identifier_names
  late Future<bool> TasksFetched;
  late final List<Task> _tasks = [];

  Future<bool> fetchTasks() async {
    http.Response response = await http.get(Uri.http(_baseUrl, "/tasks"));
    // ignore: non_constant_identifier_names
    List<dynamic> TasksFromServer = json.decode(response.body);

    for (var task in TasksFromServer) {
      _tasks.add(Task(
          id: int.parse(task["id"].toString()),
          title: task["title"],
          description: task["description"],
          deadline: task["deadline"],
          status: task["status"]));
    }

    return true;
  }

  @override
  void initState() {
    TasksFetched = fetchTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: TasksFetched,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          if (_tasks.length == 0) {
            return const Center(
              child: Text("No tasks"),
            );
          }
          return ListView.builder(
            itemCount: _tasks.length,
            itemBuilder: (BuildContext context, int index) {
              return TaskInfo(_tasks[index]);
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
