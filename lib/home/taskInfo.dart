import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../syncView.dart';
import 'home.dart';

class TaskInfo extends StatelessWidget {
  final Task task;

  const TaskInfo(this.task);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Container(
          height: 110,
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title!, textScaleFactor: 1.5),
                  Text(task.description!),
                  Text(task.deadline!),
                ],
              ),
              const Spacer(),
              Container(
                  margin: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                  child: Icon(Icons.circle,
                      color: task.status! ? Colors.green : Colors.red,
                      size: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
