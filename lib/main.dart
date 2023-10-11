import 'package:flutter/material.dart';
import 'package:to_do_app/models/Todo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // themeMode: ThemeMode.dark,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  // final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Todo> todos = [];
  List<Todo> completedTodos = [];
  bool showCompletedTodos = false;

  void _addTodo(String title, String description) {
    setState(() {
      todos.add(Todo(
        title: title,
        description: description,
        isDone: false,
      ));
    });
  }

  void _finishTodo(int index, Todo todo) {
    setState(() {
      todos.removeAt(index);
      completedTodos.add(todo);
    });
  }

  void _unfinishedTodo(int index, Todo todo) {
    setState(() {
      completedTodos.removeAt(index);
      todos.add(todo);
    });
  }

  void _showTodoDialogue() {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Todo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _addTodo(titleController.text, descriptionController.text);
                Navigator.of(context).pop();
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            title: Text("Todo"),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (index == todos.length) {
                  // if (todos.isEmpty) return Container();
                
                  if (showCompletedTodos) {
                    return TextButton(
                      child: const Text("Hide Completed Todos"),
                      onPressed: () => setState(() {
                        showCompletedTodos = false;
                      }),
                    );
                  } else {
                    return TextButton(
                      child: const Text(" Show Completed Todos"),
                      onPressed: () => setState(() {
                        showCompletedTodos = true;
                      }),
                    );
                  }
                 
                }
                return ListTile(
                    title: Text(todos[index].title),
                    subtitle: Text(todos[index].description),
                    trailing: Checkbox(
                      value: todos[index].isDone,
                      onChanged: (value) {
                        _finishTodo(
                          index,
                          todos[index].copyWith(
                            isDone: value,
                          ),
                        );
                      },
                    ));
              },
              childCount: todos.length + 1,
            ),
          ),
          if (showCompletedTodos)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                
                  return ListTile(
                      title: Text(completedTodos[index].title),
                      subtitle: Text(completedTodos[index].description),
                      trailing: Checkbox(
                        value: completedTodos[index].isDone,
                        onChanged: (value) {
                          _unfinishedTodo(
                            index,
                            completedTodos[index].copyWith(
                              isDone: value,
                            ),
                          );
                        },
                      ));
                },
                childCount: completedTodos.length,
              ),
            ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _showTodoDialogue,
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
