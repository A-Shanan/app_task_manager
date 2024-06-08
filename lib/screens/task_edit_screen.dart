import 'package:app_task_manager/widgets/app_elevatedbutton.dart';
import 'package:app_task_manager/widgets/app_textfield.dart';
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
      backgroundColor: const Color(0xff202326),
      appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: const Color(0xff202326),
          title: const Text('Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AppTextField(
              controller: titleController,
              labelText: 'Title',
              icon: Icons.note,
            ),
            CheckboxListTile(
              activeColor: const Color(0xffEEEEEE),
              checkColor: const Color(0xff202326),
              side: const BorderSide(color: Color(0xffEEEEEE), width: 1.5),
              checkboxShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              title: const Text(
                'Completed',
                style: TextStyle(color: Color(0xffEEEEEE)),
              ),
              value: task.completed,
              onChanged: (bool? value) {
                Provider.of<TaskProvider>(context, listen: false).updateTask(
                  task.id,
                  titleController.text,
                  value ?? false,
                );
              },
            ),
            AppElevatedButton(
                onPressed: () {
                  Provider.of<TaskProvider>(context, listen: false).updateTask(
                    task.id,
                    titleController.text,
                    task.completed,
                  );
                  Navigator.of(context).pop();
                },
                text: 'Save'),
          ],
        ),
      ),
    );
  }
}
