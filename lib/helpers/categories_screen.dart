import 'package:flutter/material.dart';
import 'package:todo_list/service/category_service.dart';
import 'package:todo_list/models/category.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final CategoryService _categoryService = CategoryService();
  final TextEditingController categoryNameController = TextEditingController();
  final TextEditingController categoryDescriptionController = TextEditingController();
  final TextEditingController editCategoryNameController = TextEditingController();
  final TextEditingController editCategoryDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: FutureBuilder(
        future: _categoryService.readCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          var categories = snapshot.data as List<Category>;
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              var category = categories[index];
              return ListTile(
                title: Text(category.name!),
                subtitle: Text(category.description!),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showEditFormDialog(context, category);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteCategory(context, category.id!);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showFormDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (param) {
        return AlertDialog(
          title: const Text('New Category'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: categoryNameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter category name',
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: categoryDescriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Enter category description',
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (categoryNameController.text.isEmpty ||
                    categoryDescriptionController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All fields are required.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                var category = Category();
                category.name = categoryNameController.text;
                category.description = categoryDescriptionController.text;

                var result = await _categoryService.saveCategory(category);
                if (result > 0) {
                  Navigator.pop(context);
                  getAllCategories();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Category saved successfully.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditFormDialog(BuildContext context, Category category) async {
    editCategoryNameController.text = category.name!;
    editCategoryDescriptionController.text = category.description!;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (param) {
        return AlertDialog(
          title: const Text('Edit Category'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: editCategoryNameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter category name',
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: editCategoryDescriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Enter category description',
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (editCategoryNameController.text.isEmpty ||
                    editCategoryDescriptionController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All fields are required.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                var updatedCategory = Category();
                updatedCategory.id = category.id;
                updatedCategory.name = editCategoryNameController.text;
                updatedCategory.description = editCategoryDescriptionController.text;

                var result = await _categoryService.updateCategory(updatedCategory);
                if (result > 0) {
                  Navigator.pop(context);
                  getAllCategories();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Category updated successfully.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to update category.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteCategory(BuildContext context, int categoryId) async {
    var result = await _categoryService.deleteCategory(categoryId);
    if (result > 0) {
      getAllCategories();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Category deleted successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete category.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void getAllCategories() {
    setState(() {
      // Refresh the categories list
    });
  }
}
