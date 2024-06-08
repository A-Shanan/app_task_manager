import 'package:app_task_manager/widgets/app_elevatedbutton.dart';
import 'package:app_task_manager/widgets/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_task_manager/providers/auth_provider.dart';
import 'package:app_task_manager/providers/task_provider.dart';
import 'package:app_task_manager/screens/login_screen.dart';
import 'package:app_task_manager/screens/task_edit_screen.dart';

class TaskScreen extends StatelessWidget {
  final TextEditingController taskController = TextEditingController();

  TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xff202326),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xff202326),
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                    child: AppTextField(
                  controller: taskController,
                  hintText: 'New Task',
                  icon: Icons.note_add,
                )),
                const SizedBox(width: 8),
                AppElevatedButton(
                    onPressed: () {
                      final title = taskController.text;
                      taskProvider.addTask(title);
                      taskController.clear();
                    },
                    text: 'Add')
              ],
            ),
          ),
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, provider, child) {
                if (provider.tasks.isEmpty) {
                  return const Center(
                    child: Text(
                      'No tasks available',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: provider.tasks.length,
                    itemBuilder: (context, index) {
                      final task = provider.tasks[index];
                      return Dismissible(
                        key: Key(task.id.toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          provider.deleteTask(task.id);
                        },
                        background: Container(
                          color: const Color.fromARGB(255, 145, 73, 67),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            task.title,
                            style: const TextStyle(color: Color(0xffEEEEEE)),
                          ),
                          trailing: Checkbox(
                            activeColor: const Color(0xffEEEEEE),
                            checkColor: const Color(0xff202326),
                            side: const BorderSide(
                                color: Color(0xffEEEEEE), width: 1.5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            value: task.completed,
                            onChanged: (value) {
                              provider.updateTask(task.id, task.title, value!);
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TaskEditScreen(task: task),
                              ),
                            );
                          },
                        ),
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
                  AppElevatedButton(
                      onPressed: taskProvider.previousPage, text: 'Previous'),
                Text(
                  'Page ${taskProvider.currentPage} of ${taskProvider.totalPages}',
                  style:
                      const TextStyle(color: Color(0xffEEEEEE), fontSize: 20),
                ),
                if (taskProvider.currentPage < taskProvider.totalPages)
                  AppElevatedButton(
                      onPressed: taskProvider.nextPage, text: 'Next')
              ],
            ),
          ),
        ],
      ),
    );
  }
}
