import 'package:flutter/material.dart';

Widget inputBox(
    {required String hint,
    required TextEditingController textController,
    bool isSecured = false}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: Colors.grey,
      ),
    ),
    child: TextField(
      obscureText: isSecured,
      controller: textController,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hint,
      ),
    ),
  );
}
