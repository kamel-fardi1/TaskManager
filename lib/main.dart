import 'package:flutter/material.dart';
import 'package:flutter_sc_2023/splash_screen.dart';
import 'add.dart';
import 'navigations/nav_bottom.dart';
import 'syncView.dart';
import 'home/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme:
              ColorScheme.fromSwatch().copyWith(primary: Colors.purple)),
      title: 'EXamen Flutter',
      routes: {
        "/": (context) {
          return const SplashScreen();
          //return const Home();
        },
        "/home": (context) {
          return const Home();
        },
        "/homeTab": (context) {
          return const NavigationBottom();
        },
        "/home/details": (context) {
          return const syncview();
        },
        "/add": (context) {
          return const add();
        },
      },
    );
  }
}
