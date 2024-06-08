// ignore_for_file: avoid_print, use_build_context_synchronously, library_private_types_in_public_api

import 'package:app_task_manager/widgets/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_task_manager/providers/task_provider.dart';
import 'package:app_task_manager/screens/task_screen.dart';
import 'package:app_task_manager/services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscureText = true;

  void toggleObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  void _login(BuildContext context) async {
    final username = usernameController.text;
    final password = passwordController.text;

    final user = await ApiService().login(username, password);

    if (user != null) {
      Provider.of<TaskProvider>(context, listen: false).setUserId(user.id);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TaskScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username or password are incorrect')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff202326),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppTextField(
              controller: usernameController,
              hintText: 'Username',
              icon: Icons.person,
            ),
            const SizedBox(
              height: 15,
            ),
            AppTextField(
              controller: passwordController,
              hintText: 'Password',
              icon: Icons.lock,
              obscureText: obscureText,
              suffixIcon: IconButton(
                onPressed: toggleObscureText,
                icon: Icon(
                  obscureText
                      ? Icons.remove_red_eye_outlined
                      : Icons.remove_red_eye,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffCB16ED),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              onPressed: () => _login(context),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
