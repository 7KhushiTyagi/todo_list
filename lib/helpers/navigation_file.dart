import 'package:flutter/material.dart';
import 'package:todo_list/service/category_service.dart';
import 'package:todo_list/todolist_screen.dart';
import 'package:todo_list/helpers/categories_screen.dart';

class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({super.key});

  @override
  State<DrawerNavigation> createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  List<Widget> _categoryList = [];

  final CategoryService _categoryService = CategoryService();

  @override
  initState() {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    try {
      var categories = await _categoryService.readCategories();
      setState(() {
        _categoryList = categories.map<Widget>((category) => ListTile(
          title: Text(category['name']),
        )).toList();
      });
    } catch (e) {
      // Handle error (e.g., no network)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load categories')),
      );
    }
  }

  Widget _buildDrawerItem(IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(icon, color: Colors.pinkAccent),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text(
              'Khushi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            accountEmail: Text(
              'khushi@example.com',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink, Colors.orange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          _buildDrawerItem(Icons.home, 'Home', const TodolistScreen()),
          const Divider(thickness: 1.0),
          _buildDrawerItem(Icons.category, 'Categories',  CategoriesScreen()),
          const Divider(thickness: 1.0),
          // If categories list is empty, show a placeholder
          if (_categoryList.isEmpty)
            const ListTile(
              title: Text('No categories available'),
            ),
          // Display category items
          Column(children: _categoryList),
          const Divider(thickness: 1.0),
        ],
      ),
    );
  }
}
