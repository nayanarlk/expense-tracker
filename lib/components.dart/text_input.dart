import 'package:flutter/material.dart';

class NewTextInput extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final TextEditingController controller;

  const NewTextInput({super.key, required this.labelText, this.obscureText = false, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}
