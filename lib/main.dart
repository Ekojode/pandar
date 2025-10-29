import 'package:flutter/material.dart';

import 'screens/add_task.dart';
import 'screens/edit_task.dart';
import 'screens/home.dart';
import 'screens/settings_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pandar To Do',
      initialRoute: 'home',
      debugShowCheckedModeBanner: false,
      routes: {
        'home': (context) => const HomePage(),
        'add_task': (context) => const AddTaskPage(),
        'edit_task': (context) => const EditTaskPage(),
        'settings': (context) => const SettingsPage(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomePage(),
    );
  }
}
