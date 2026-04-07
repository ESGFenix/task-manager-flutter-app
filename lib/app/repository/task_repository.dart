import 'dart:convert';

import 'package:proyecto_final_domestika/app/model/task_category.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/task.dart';

class TaskRepository {
  static const String _tasksStorageKey = 'tasks';
  static const String _categoriesStorageKey = 'task_categories';

  Future<bool> addTask(Task task) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonTasks = prefs.getStringList(_tasksStorageKey) ?? [];
    jsonTasks.add(jsonEncode(task.toJson()));
    return prefs.setStringList(_tasksStorageKey, jsonTasks);
  }

  Future<List<Task>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonTasks = prefs.getStringList(_tasksStorageKey) ?? [];
    return jsonTasks
        .map((jsonTask) => Task.fromJson(jsonDecode(jsonTask)))
        .toList();
  }

  Future<bool> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonTasks = tasks.map((e) => jsonEncode(e.toJson())).toList();
    return prefs.setStringList(_tasksStorageKey, jsonTasks);
  }

  Future<List<TaskCategory>> getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonCategories = prefs.getStringList(_categoriesStorageKey) ?? [];
    final categories = jsonCategories
        .map((jsonCategory) => TaskCategory.fromJson(jsonDecode(jsonCategory)))
        .toList();

    if (categories.isEmpty) {
      return [TaskCategory(id: 'uncategorized', name: 'Sin categoría')];
    }

    return categories;
  }

  Future<bool> addCategory(TaskCategory category) async {
    final categories = await getCategories();
    final exists = categories.any(
        (e) => e.name.toLowerCase().trim() == category.name.toLowerCase().trim(),
    );

    if(exists){
      return true;
    }

    return saveCategories([...categories, category]);
  }

  Future<bool> saveCategories(List<TaskCategory> categories) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonCategories = categories.map((e) => jsonEncode(e.toJson())).toList();
    return prefs.setStringList(_categoriesStorageKey, jsonCategories);
  }
}