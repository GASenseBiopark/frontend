import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gasense/models/usuario.dart';

class UsuarioDAO {
  String baseUrl = 'http://15.229.0.216:8080';
  Future<int> adicionarEditar(Usuario usuario) async {
    final url = Uri.parse('$baseUrl/gravarUsuarios');

    // Monta o corpo da requisição
    Map<String, dynamic> dados = {
      'id_usuario': usuario.idUsuario,
      'nome': usuario.nome,
      'email': usuario.email,
      'senha':
          usuario
              .senhaHash, // aqui você envia a senha pura e o backend gera o hash
      'data_cadastro': usuario.dataCadastro,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dados),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['id_usuario'];
    } else if (response.statusCode == 409) {
      throw 'E-mail já cadastrado';
    } else {
      throw 'Erro ao adicionar/editar usuário: ${response.body}';
    }
  }

  Future<Usuario?> pesquisar(String email, String senha) async {
    final url = Uri.parse('$baseUrl/pesquisarUsuarios');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': senha}),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Usuario(
        idUsuario: json['id_usuario'],
        nome: json['nome'],
        email: json['email'],
        senhaHash: '', // não retorna o hash, por segurança
        dataCadastro: json['data_cadastro'],
        admin: false, // se quiser implementar admin, pode adaptar
      );
    } else if (response.statusCode == 403) {
      // usuário não encontrado ou senha inválida
      return null;
    } else {
      throw Exception('Erro ao pesquisar usuário: ${response.body}');
    }
  }

  Future<int> deletar(int idUsuario) async {
    final url = Uri.parse('$baseUrl/deletarUsuario');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_usuario': idUsuario}),
    );

    if (response.statusCode == 200) {
      return 1; // sucesso
    } else {
      throw Exception('Erro ao deletar usuário: ${response.body}');
    }
  }
}
