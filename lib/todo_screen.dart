import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/service/category_service.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/service/todoservice.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  var todoTitleController = TextEditingController();
  var todoDescriptionController = TextEditingController();
  var todoDateController = TextEditingController();
  // ignore: prefer_typing_uninitialized_variables
  var _selectedValue;
  final List<DropdownMenuItem<String>> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  _loadCategories() async {
    var categoryService = CategoryService();
    var categories = await categoryService.readCategories();
    for (var category in categories) {
      setState(() {
        _categories.add(DropdownMenuItem<String>(
          value: category['name'],
          child: Text(
            category['name'],
            style: const TextStyle(fontSize: 16),
          ),
        ));
      });
    }
  }

  DateTime _dateTime = DateTime.now();
  _selectedTodoDate(BuildContext context) async {
    var pickdate = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickdate != null) {
      setState(() {
        _dateTime = pickdate;
        todoDateController.text = DateFormat('yyyy-MM-dd').format(pickdate);
      });
    }
  }

  Future<void> _saveOrUpdateTodo() async {
    if (_selectedValue == null ||
        todoTitleController.text.isEmpty ||
        todoDescriptionController.text.isEmpty ||
        todoDateController.text.isEmpty) {
      // Show an error or handle empty fields
      return;
    }

    var todoObject = Todo();
    todoObject.title = todoTitleController.text;
    todoObject.description = todoDescriptionController.text;
    todoObject.isFinished = 0;
    todoObject.category = _selectedValue ?? 'Default'; // Default if null
    todoObject.todoDate = todoDateController.text;

    var todoService = Todoservice();
    if (todoObject.id == null) {
      var result = await todoService.saveTodo(todoObject);
      print(result); // Handle the result (success/failure)
    } else {
      var result = await todoService.updateTodo(todoObject);
      print(result); // Handle the result (success/failure)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add To-Do',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create a new To-Do',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: todoTitleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Write To-Do title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: todoDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Write To-Do Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: todoDateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                  hintText: 'Pick a Date',
                  prefixIcon: InkWell(
                    onTap: () {
                      _selectedTodoDate(context);
                    },
                    child: const Icon(Icons.calendar_today, color: Colors.pinkAccent),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 15),
              _categories.isEmpty
                  ? const CircularProgressIndicator() // Show loading until categories are fetched
                  : DropdownButtonFormField<String>(
                      value: _selectedValue,
                      hint: const Text('Category'),
                      items: _categories,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedValue = value;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await _saveOrUpdateTodo();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    backgroundColor: Colors.pinkAccent,
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}