import 'package:flutter/material.dart';
import 'package:todo_list/helpers/navigation_file.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/service/todoservice.dart';
import 'package:todo_list/todo_screen.dart';

class TodolistScreen extends StatefulWidget {
  const TodolistScreen({super.key});

  @override
  State<TodolistScreen> createState() => _TodolistScreenState();
}

class _TodolistScreenState extends State<TodolistScreen> {
  late Todoservice _todoService;
  List<Todo> _todoList = [];

  @override
  void initState() {
    super.initState();
    getAllTodos();
  }

  Future<void> getAllTodos() async {
    _todoService = Todoservice();
    List<Todo> tempTodoList = [];

    var todos = await _todoService.readTodos();

    for (var todo in todos) {
      var model = Todo();
      model.id = todo['id'];
      model.title = todo['title'];
      model.description = todo['description'];
      model.category = todo['category'];
      model.todoDate = todo['tododate'];
      model.isFinished = todo['isFinished'];
      tempTodoList.add(model);
    }

    setState(() {
      _todoList = tempTodoList;
    });
  }

  Future<void> updateTodoStatus(int id, int isFinished) async {
    var todo = _todoList.firstWhere((todo) => todo.id == id);
    todo.isFinished = isFinished;
    await _todoService.updateTodo(todo);
    getAllTodos();
  }

  Future<void> deleteTodoById(int id) async {
    await _todoService.deleteTodoById(id);
    getAllTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 10.0,
        title: const Text(
          'To-Do List',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pinkAccent, Colors.orangeAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      drawer: const DrawerNavigation(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: _todoList.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 8,
              margin: const EdgeInsets.symmetric(vertical: 6.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _todoList[index].title ?? 'No Title',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      _todoList[index].category ?? 'No Category',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          _todoList[index].isFinished == 1
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          updateTodoStatus(_todoList[index].id!,
                              _todoList[index].isFinished == 1 ? 0 : 1);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          deleteTodoById(_todoList[index].id!);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => TodoScreen()));
        },
        backgroundColor: Colors.pink[300],
        elevation: 6.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
