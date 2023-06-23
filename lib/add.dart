import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'home/home.dart';

// ignore: camel_case_types
class add extends StatefulWidget {
  const add({super.key});

  @override
  State<add> createState() => _addState();
}

// ignore: camel_case_types
class _addState extends State<add> {
  late Task task = Task();
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _keyForm,
      child: ListView(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10, 50, 10, 10),
            child: TextFormField(
              decoration: const InputDecoration(labelText: "Title"),
              onSaved: (String? value) {
                task.title = value;
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "title can't be empty";
                } else {
                  return null;
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: TextFormField(
              obscureText: false,
              decoration: const InputDecoration(labelText: "Description"),
              onSaved: (String? value) {
                task.description = value;
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Description can't be empty";
                } else {
                  return null;
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: TextFormField(
              obscureText: false,
              decoration: const InputDecoration(labelText: "Deadline"),
              onSaved: (String? value) {
                task.deadline = value;
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Dedline can't be empty";
                } else {
                  return null;
                }
              },
            ),
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                ),
                child: const Text("Save"),
                onPressed: () async {
                  if (_keyForm.currentState!.validate()) {
                    _keyForm.currentState!.save();
                    Database database = await openDatabase(
                        join(await getDatabasesPath(), "TaskManager.db"));

                    Map<String, dynamic> taskToDo = {
                      "title": task.title,
                      "description": task.description,
                      "deadline": task.deadline,
                      "status": false
                    };

                    database.insert("tasks", taskToDo,
                        conflictAlgorithm: ConflictAlgorithm.replace);

                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Row(children: const [
                              Icon(Icons.info_outline),
                              SizedBox(width: 10),
                              Text("Info"),
                            ]),
                            content: const Text("Task added successfully"),
                          );
                        });
                  }
                },
              )),
        ],
      ),
    );
  }
}
