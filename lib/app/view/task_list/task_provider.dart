import 'package:flutter/material.dart';
import 'package:proyecto_final_domestika/app/model/task.dart';
import 'package:proyecto_final_domestika/app/model/task_category.dart';
import 'package:proyecto_final_domestika/app/repository/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _taskList = [];
  List<TaskCategory> _categories = [];

  final TaskRepository _taskRepository = TaskRepository();

  Future<void> fetchTasks() async {
    _taskList = await _taskRepository.getTasks();
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    _categories = await _taskRepository.getCategories();
    notifyListeners();
  }

  List<Task> get taskList => _taskList;
  List<TaskCategory> get categories => _categories;

  Future<void> onTaskDoneChange(Task task) async {
    task.done = !task.done;
    task.taskState = task.done ? TaskState.DONE : TaskState.PENDING;
    await _taskRepository.saveTasks(_taskList);
    notifyListeners();
  }

  Future<void> addNewTask(Task task) async {
    await _taskRepository.addTask(task);
    await fetchTasks();
  }

  Future<void> addNewCategory(TaskCategory category) async {
    await _taskRepository.addCategory(category);
    await fetchCategories();
  }
}