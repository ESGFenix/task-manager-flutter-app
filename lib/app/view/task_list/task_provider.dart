import 'package:flutter/material.dart';
import 'package:proyecto_final_domestika/app/model/task.dart';
import 'package:proyecto_final_domestika/app/model/task_category.dart';
import 'package:proyecto_final_domestika/app/repository/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _taskList = [];
  List<TaskCategory> _categories = [];

  final TaskRepository _taskRepository = TaskRepository();

  Future<void> initialize() async {
    await fetchCategories();
    await fetchTasks();
    await _ensureMockData();
  }

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

  Future<void> updateTask(Task originalTask, Task updatedTask) async {
    final index = _taskList.indexOf(originalTask);
    if(index == -1) return;
    _taskList[index] = updatedTask;
    await _taskRepository.saveTasks(_taskList);
    notifyListeners();
  }

  Future<void> deleteTask(Task task) async {
    _taskList.remove(task);
    await _taskRepository.saveTasks(_taskList);
    notifyListeners();
  }

  Future<void> _ensureMockData() async {
    if (_categories.any((category) => category.id == 'mock-category')) return;

    const mockCategory = TaskCategory(id: 'mock-category', name: 'Mock');
    await addNewCategory(mockCategory);

    if(_taskList.isEmpty){
      await addNewTask(
        Task(
          'Preparar demo de acordeones',
          'Esta tarea mock sirve para visualizar la UI inicial de categorías y tareas.',
          dueDate: DateTime.now().add(const Duration(days: 7)),
          taskState: TaskState.PENDING,
          categoryId: mockCategory.id,
        ),
      );
    }
  }
}