import 'package:todo_list/models/todo.dart';
import 'package:todo_list/repository/repository.dart';

class Todoservice {
  late Repository _repository;

  Todoservice() {
    _repository = Repository();
  }

  Future saveTodo(Todo todo) async {
    return await _repository.insertData('todos', todo.todoMap());
  }

  Future readTodos() async {
    return await _repository.readData('todos');
  }

  Future updateTodo(Todo todo) async {
    return await _repository.updateData('todos', todo.todoMap(), todo.id!);
  }

  Future deleteTodoById(int id) async {
    return await _repository.deleteData('todos', id);
  }
}
