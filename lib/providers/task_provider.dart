// ignore_for_file: avoid_print, prefer_final_fields
import 'package:flutter/material.dart';

import 'package:app_task_manager/models/task.dart';
import 'package:app_task_manager/services/api_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  int _limit = 10;
  int _currentPage = 1;
  int _totalTasks = 0;
  int _userId = 0;

  List<Task> get tasks => _tasks;
  int get currentPage => _currentPage;
  int get totalTasks => _totalTasks;
  int get totalPages => (_totalTasks / _limit).ceil();

  void setUserId(int userId) {
    _userId = userId;
    fetchTasks();
    notifyListeners();
  }

  Future<void> fetchTasks() async {
    try {
      _tasks = await ApiService()
          .getTasks(_userId, _limit, (_currentPage - 1) * _limit);
      _totalTasks = await ApiService().getTotalTasks(_userId);
      notifyListeners();
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

  void nextPage() {
    if (_currentPage < totalPages) {
      _currentPage++;
      fetchTasks();
    }
  }

  void previousPage() {
    if (_currentPage > 1) {
      _currentPage--;
      fetchTasks();
    }
  }

  Future<void> addTask(String title) async {
    try {
      final newTask = await ApiService().addTask(title, _userId);
      _tasks.insert(0, newTask);
      notifyListeners();
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  Future<void> updateTask(int id, String title, bool completed) async {
    try {
      await ApiService().updateTask(id, title, completed);
      final index = _tasks.indexWhere((task) => task.id == id);
      if (index != -1) {
        _tasks[index] = Task(
            id: id,
            title: title,
            completed: completed,
            userId: _tasks[index].userId);
        notifyListeners();
      }
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await ApiService().deleteTask(id);
      _tasks.removeWhere((task) => task.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting task: $e');
    }
  }
}
