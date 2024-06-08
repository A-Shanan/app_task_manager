import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;

  const AppTextField({
    Key? key,
    required this.controller,
    this.hintText,
    this.labelText,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Color(0xff909193),
        ),
        suffixIcon: suffixIcon,
        prefixIcon: Icon(
          icon,
          color: const Color(0xff909193),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color(0xff37393C),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 94, 99, 107), width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Color(0xff37393C), width: 2.0),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xff909193),
        ),
      ),
    );
  }
}
