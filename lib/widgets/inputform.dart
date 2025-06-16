import 'package:flutter/material.dart';
import 'package:gasense/constants/constants.dart';

Widget inputFormulario({
  required TextEditingController controller,
  required String textoLabel,
  IconData icone = Icons.email,
  bool obscureText = false,
}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
    child: TextField(
      controller: controller,
      keyboardType:
          obscureText ? TextInputType.text : TextInputType.emailAddress,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.black87, fontSize: 16),
      decoration: InputDecoration(
        prefixIconColor: AppColors.grey,
        prefixIcon: Icon(icone),
        labelText: textoLabel,
        labelStyle: const TextStyle(color: AppColors.grey),
        filled: true,
        fillColor: const Color.fromARGB(255, 231, 231, 231),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ),
    ),
  );
}
