import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'dart:convert';

import 'taskInfo.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Task> tasks = [];
  late Future<bool> fetchedTasks;

  Future<bool> fetchTasks() async {
    Database database =
        await openDatabase(join(await getDatabasesPath(), "TaskManager.db"));

    List<Map<String, dynamic>> tasksfromDB = await database.query("tasks");

    for (var task in tasksfromDB) {
      tasks.add(Task(
          id: int.parse(task["id"].toString()),
          title: task["title"],
          description: task["description"],
          deadline: task["deadline"],
          status: task["status"] == 1 ? true : false));
    }

    return true;
  }

  @override
  void initState() {
    fetchedTasks = fetchTasks();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchedTasks,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          if (tasks.length == 0) {
            return const Center(
              child: Text("No tasks"),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (BuildContext context, int index) {
                    return TaskInfo(tasks[index]);
                  },
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: Text("No tasks"),
          );
        }
      },
    );
  }
}

class Task {
  int? id;
  String? title;
  String? description;
  String? deadline;
  bool? status;

  Task({
    this.id,
    this.title,
    this.description,
    this.deadline,
    this.status,
  });
}
