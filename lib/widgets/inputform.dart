import 'package:flutter/material.dart';
import 'package:gasense/constants/constants.dart';

class InputFormulario extends StatefulWidget {
  final TextEditingController controller;
  final String textoLabel;
  final IconData icone;
  final bool isEmail;
  final bool isSenha;
  final String? Function(String?)? validator; // <-- aqui
  final String? errorText;

  const InputFormulario({
    super.key,
    required this.controller,
    required this.textoLabel,
    this.icone = Icons.email,
    this.isEmail = false,
    this.isSenha = false,
    this.validator,
    this.errorText,
  });

  @override
  State<InputFormulario> createState() => _InputFormularioState();
}

class _InputFormularioState extends State<InputFormulario> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType:
          widget.isEmail ? TextInputType.emailAddress : TextInputType.text,
      obscureText: widget.isSenha ? obscure : false,
      validator: widget.validator, // <-- usa o validator
      style: const TextStyle(color: Colors.black87, fontSize: 16),
      decoration: InputDecoration(
        prefixIconColor: AppColors.grey,
        prefixIcon: Icon(widget.icone),
        labelText: widget.textoLabel,
        labelStyle: const TextStyle(color: AppColors.grey),
        filled: true,
        fillColor: const Color.fromARGB(255, 231, 231, 231),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        suffixIcon:
            widget.isSenha
                ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      obscure = !obscure;
                    });
                  },
                )
                : null,
        errorText: widget.errorText,
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
      ),
    );
  }
}
