import 'package:flutter/material.dart';
import 'package:percistent/screens/home_screen.dart';

void main() {
  runApp(const SqliteApp());
}

class SqliteApp extends StatelessWidget {
  const SqliteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SQLite Example',
        initialRoute: 'home',
        routes: {'home': (context) => const HomeScreen()});
  }
}
