import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home/home.dart';
import 'syncView.dart';

class could extends StatefulWidget {
  const could({super.key});

  @override
  State<could> createState() => _couldState();
}

class _couldState extends State<could> {
  final String _baseUrl = "10.0.2.2:9090";
  List<Task> tasks = [];
  List<Map<String, dynamic>> tasksfromDB = [];
  List<Map<String, dynamic>> tasksToserver = [];
  void fetchTasks() async {
    Database database =
        await openDatabase(join(await getDatabasesPath(), "TaskManager.db"));

    tasksfromDB = await database.query("tasks");

    for (var task in tasksfromDB) {
      tasks.add(Task(
          id: int.parse(task["id"].toString()),
          title: task["title"],
          description: task["description"],
          deadline: task["deadline"],
          status: task["status"] == 1 ? true : false));
    }
  }

  @override
  void initState() {
    fetchTasks();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: syncview(),
      floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.sync),
          label: const Text("Sync with cloud"),
          backgroundColor: Colors.purple,
          onPressed: () {
            tasksToserver = tasks
                .map((task) => {
                      'id': task.id,
                      'title': task.title,
                      'description': task.description,
                      'deadline': task.deadline,
                      'status': task.status,
                    })
                .toList();
            Map<String, List<Map<String, dynamic>>> Data = {
              "data": tasksToserver,
            };
            Map<String, String> headers = {
              "Content-Type": "application/json; charset=UTF-8"
            };

            http
                .post(Uri.http(_baseUrl, "/tasks"),
                    body: json.encode(Data), headers: headers)
                .then((http.Response response) async {
              if (response.statusCode == 201) {
                Database database = await openDatabase(
                    join(await getDatabasesPath(), "TaskManager.db"));
                await database.delete("tasks");
              }
            });
          }),
    );
  }
}
