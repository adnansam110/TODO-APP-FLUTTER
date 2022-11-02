import 'package:flutter/material.dart';
import 'package:todo_app/providers/todos_provider.dart';
import 'package:todo_app/screens/todos.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (context) => TodosList())],
    child: MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Todos(),
      },
    ),
  ));
}
