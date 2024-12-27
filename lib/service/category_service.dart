import 'package:todo_list/models/category.dart';
import 'package:todo_list/repository/repository.dart';

class CategoryService {
  late Repository _repository;

  CategoryService() {
    _repository = Repository();
  }

  Future saveCategory(Category category) async {
    return await _repository.insertData('categories', category.categoryMap());
  }

  Future readCategories() async {
    return await _repository.readData('categories');
  }

  Future readCategoryById(int categoryId) async {
    return await _repository.readDataById('categories', categoryId);
  }

  Future<int> deleteAllCategories() async {
    return await _repository.deleteAllData('categories');
  }

  Future<int> updateCategory(Category category) async {
    return await _repository.updateData('categories', category.categoryMap(), category.id!);
  }

  Future<int> deleteCategory(int categoryId) async {
    return await _repository.deleteData('categories', categoryId);
  }
}