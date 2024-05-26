// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_task_manager/providers/task_provider.dart';
import 'package:app_task_manager/screens/task_edit_screen.dart';

class TaskScreen extends StatelessWidget {
  final TextEditingController _taskController = TextEditingController();

  TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(labelText: 'New Task'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final title = _taskController.text;
                    taskProvider.addTask(title);
                    _taskController.clear();
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, provider, child) {
                if (provider.tasks.isEmpty) {
                  return const Center(child: Text('No tasks available'));
                } else {
                  return ListView.builder(
                    itemCount: provider.tasks.length,
                    itemBuilder: (context, index) {
                      final task = provider.tasks[index];
                      return ListTile(
                        title: Text(task.title),
                        trailing: Checkbox(
                          value: task.completed,
                          onChanged: (value) {
                            provider.updateTask(task.id, task.title, value!);
                          },
                        ),
                        onLongPress: () {
                          provider.deleteTask(task.id);
                        },
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskEditScreen(task: task),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (taskProvider.currentPage > 1)
                  ElevatedButton(
                    onPressed: taskProvider.previousPage,
                    child: const Text('Previous'),
                  ),
                Text(
                    'Page ${taskProvider.currentPage} of ${taskProvider.totalPages}'),
                if (taskProvider.currentPage < taskProvider.totalPages)
                  ElevatedButton(
                    onPressed: taskProvider.nextPage,
                    child: const Text('Next'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
