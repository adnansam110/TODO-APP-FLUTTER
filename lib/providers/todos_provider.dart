import 'package:flutter/cupertino.dart';

class TodosList extends ChangeNotifier {
  final List _todos = [];

  List get todos => _todos;

  void addTodos(todo) {
    _todos.add({"title": todo, "isSelected": false});
    notifyListeners();
  }

  void deleteTodos() {
    _todos.removeWhere((todo) => todo["isSelected"]);
    notifyListeners();
  }

  void setTodosSelected(index) {
    _todos[index]["isSelected"] = !_todos[index]["isSelected"];
    notifyListeners();
  }
}
