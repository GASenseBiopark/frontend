import 'dart:convert';
import 'package:gasense/models/leitura.dart';
import 'package:http/http.dart' as http;

class LeituraDAO {
  String baseUrl = 'http://15.229.0.216:8080';

  /// Busca as leituras recentes.
  /// Se passar o idDispositivo, busca apenas daquele dispositivo.
  Future<List<Leitura>> buscarLeiturasRecentes(
    String idDispositivo, {
    int limite = 10,
  }) async {
    // Monta a URL com os parâmetros
    final queryParams = {
      'id_dispositivo': idDispositivo,
      'limite': limite.toString(),
    };

    final uri = Uri.parse(
      '$baseUrl/leituras',
    ).replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Leitura.fromMap(json)).toList();
    } else {
      throw 'Erro ao buscar leituras: ${response.statusCode} ${response.body}';
    }
  }

  Future<List<Leitura>> buscarHistorico(
    String idDispositivo, {
    int limite = 100,
  }) async {
    return await buscarLeiturasRecentes(idDispositivo, limite: limite);
  }

  Future<Leitura?> buscarUltimaLeitura(String idDispositivo) async {
    final leituras = await buscarLeiturasRecentes(idDispositivo, limite: 1);
    return leituras.isNotEmpty ? leituras.first : null;
  }

  Future<List<Leitura>> buscarNovasLeituras({
    required String idDispositivo,
    required DateTime ultimaData,
  }) async {
    final url = Uri.parse('$baseUrl/buscarNovasLeituras');

    Map<String, dynamic> dados = {
      'id_dispositivo': idDispositivo,
      'ultima_data': ultimaData.toIso8601String(),
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dados),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Leitura.fromMap(json)).toList();
    } else {
      throw 'Erro ao buscar novas leituras: ${response.body}';
    }
  }
}
