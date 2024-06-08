// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:app_task_manager/models/task.dart';
import 'package:app_task_manager/models/user.dart';

class ApiService {
  final String baseUrl = "https://dummyjson.com";

  Future<User?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  Future<List<Task>> getTasks(int userId, int limit, int skip) async {
    final response = await http.get(
      Uri.parse('$baseUrl/todos?limit=$limit&skip=$skip&userId=$userId'),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      List<dynamic> data = responseBody['todos'];
      try {
        return data.map((json) => Task.fromJson(json)).toList();
      } catch (e) {
        print('Error parsing tasks: $e');
        throw Exception('Failed to parse tasks');
      }
    } else {
      print('Failed to load tasks with status code: ${response.statusCode}');
      throw Exception('Failed to load tasks');
    }
  }

  Future<int> getTotalTasks(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/todos?userId=$userId'),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody['total'];
    } else {
      print(
          'Failed to load total tasks with status code: ${response.statusCode}');
      throw Exception('Failed to load total tasks');
    }
  }

  Future<Task> addTask(String title, int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/todos/add'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'todo': title, 'completed': false, 'userId': userId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Task.fromJson(jsonDecode(response.body));
    } else {
      print('Failed to add task with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to add task');
    }
  }

  Future<void> updateTask(int id, String title, bool completed) async {
    await http.put(
      Uri.parse('$baseUrl/todos/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'todo': title, 'completed': completed}),
    );
  }

  Future<void> deleteTask(int id) async {
    await http.delete(
      Uri.parse('$baseUrl/todos/$id'),
    );
  }
}
