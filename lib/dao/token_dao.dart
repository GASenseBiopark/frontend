import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TokenDAO {
  Future<void> cadastrarTokenPush(String idUsuario, String token) async {
    await http
        .post(
          Uri.parse('http://15.229.0.216:8080/cadastrarTokenPush'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'id_usuario': idUsuario, // Você já tem no app
            'token': token,
          }),
        )
        .then(
          (response) => debugPrint(response.body),
        ); // Imprime o corpo da resposta
  }
}
