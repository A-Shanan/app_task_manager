import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'package:app_task_manager/models/task.dart';

class TaskEditScreen extends StatelessWidget {
  final Task task;

  const TaskEditScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: task.title);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            CheckboxListTile(
              title: const Text('Completed'),
              value: task.completed,
              onChanged: (bool? value) {
                Provider.of<TaskProvider>(context, listen: false).updateTask(
                  task.id,
                  titleController.text,
                  value ?? false,
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<TaskProvider>(context, listen: false).updateTask(
                  task.id,
                  titleController.text,
                  task.completed,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
