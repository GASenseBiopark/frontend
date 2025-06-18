import 'dart:convert';
import 'package:gasense/models/dispositivo.dart';
import 'package:http/http.dart' as http;

class DispositivoDAO {
  String baseUrl = 'http://15.229.0.216:8080';

  Future<Dispositivo> buscarDispositoPorId(String idDispositivo) async {
    final url = Uri.parse('$baseUrl/buscarDispositivoPorId');

    Map<String, dynamic> dados = {'id_dispositivo': idDispositivo};

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dados),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Dispositivo.fromMap(json);
    } else if (response.statusCode == 404) {
      throw 'Dispositivo não encontrado';
    } else {
      throw 'Erro ao buscar dispositivo: ${response.body}';
    }
  }
}
