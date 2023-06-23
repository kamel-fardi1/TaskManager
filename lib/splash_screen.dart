import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'navigations/nav_bottom.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Future<bool> sessionFetched;
  late String route;

  Future<bool> fetchSession() async {
    Database database =
        await openDatabase(join(await getDatabasesPath(), "TaskManager.db"),
            onCreate: (Database db, int version) {
      db.transaction(
        (Transaction txn) async {
          await db.execute(
              "CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, description TEXT, deadline TEXT, status BOOLEAN)");
        },
      );
    }, version: 1);

    return true;
  }

  @override
  void initState() {
    sessionFetched = fetchSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: sessionFetched,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const NavigationBottom();
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
