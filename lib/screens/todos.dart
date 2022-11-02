import 'package:flutter/material.dart';
import 'package:todo_app/providers/todos_provider.dart';
import 'package:provider/provider.dart';

class Todos extends StatefulWidget {
  const Todos({super.key});

  @override
  State<Todos> createState() => _TodosState();
}

class _TodosState extends State<Todos> {
  @override
  Widget build(BuildContext context) {
    List todos = context.watch<TodosList>().todos;
    todos = Set.from(todos).toList();
    double width = MediaQuery.of(context).size.width;
    String inputValue = '';
    bool todosSelected = todos.any((todo) => todo["isSelected"]);
    print("Todo is selected $todosSelected");
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return const Color(0xFF9E7676);
      }
      return Colors.grey;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EA),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                  child: AlertDialog(
                    title: Center(
                        child: Text(
                            todosSelected ? "Delete Todo" : 'Add A New Todo!')),
                    content: Text(
                      todosSelected
                          ? "Are you sure you want to delete this Todo?"
                          : 'Enter the todo you wish to add to your list',
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      if (!todosSelected)
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              inputValue = value;
                            });
                          },
                          decoration: const InputDecoration(
                            constraints: BoxConstraints.tightFor(height: 50),
                            border: OutlineInputBorder(),
                            hintText: 'Enter a Todo...',
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(todosSelected ? "No" : 'Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              if (!todosSelected) {
                                if (inputValue.isEmpty) return;
                                context.read<TodosList>().addTodos(inputValue);
                              } else {
                                context.read<TodosList>().deleteTodos();
                              }
                              Navigator.pop(context);
                            },
                            child: Text(todosSelected ? "Yes" : "Add"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            icon: Icon(todosSelected ? Icons.delete : Icons.add),
            tooltip: todosSelected ? "Delete Todos" : "Add Todos",
          ),
        ],
        title: const Text("TODOS"),
        backgroundColor: const Color(0xFF9E7676),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        titleTextStyle: const TextStyle(
          fontFamily: "Ubuntu",
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
      body: todos.isEmpty
          ? const Center(
              child: Text(
                "You donot have any todos please add some!",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
              child: Column(
                  children: todos.map((todo) {
                int index = todos.indexOf(todo);
                return Card(
                  color: const Color(0xFFFAF7F0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                  ),
                  child: SizedBox(
                    width: width * 0.9,
                    height: 70,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                              checkColor: Colors.white,
                              fillColor:
                                  MaterialStateProperty.resolveWith(getColor),
                              value: todo["isSelected"],
                              onChanged: (bool? value) {
                                context
                                    .read<TodosList>()
                                    .setTodosSelected(index);
                              },
                            ),
                            Text(
                              todo["title"],
                              style: const TextStyle(
                                fontFamily: "Ubuntu",
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                letterSpacing: 1.0,
                                color: Color(0xFF3C4048),
                              ),
                            )
                          ]),
                    ),
                  ),
                );
              }).toList()),
            ),
    );
  }
}
