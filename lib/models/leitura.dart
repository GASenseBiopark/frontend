import 'dart:convert';

class Leitura {
  final int? idLeitura;
  final String idDispositivo;
  final DateTime dataHora;
  final double? temperatura;
  final double? umidade;
  final bool? fogo;
  final double? gasGlp;
  final double? compostosToxicos;
  final double? gasMetano;

  Leitura({
    this.idLeitura,
    required this.idDispositivo,
    required this.dataHora,
    this.temperatura,
    this.umidade,
    this.fogo,
    this.gasGlp,
    this.compostosToxicos,
    this.gasMetano,
  });

  factory Leitura.fromMap(Map<String, dynamic> map) {
    return Leitura(
      idLeitura: map['id_leitura'],
      idDispositivo: map['id_dispositivo'],
      dataHora: DateTime.parse(map['data_hora']),
      temperatura: map['temperatura']?.toDouble(),
      umidade: map['umidade']?.toDouble(),
      fogo: map['fogo'],
      gasGlp: map['gas_glp']?.toDouble(),
      compostosToxicos: map['compostos_toxicos']?.toDouble(),
      gasMetano: map['gas_metano']?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_leitura': idLeitura,
      'id_dispositivo': idDispositivo,
      'data_hora': dataHora.toIso8601String(),
      'temperatura': temperatura,
      'umidade': umidade,
      'fogo': fogo,
      'gas_glp': gasGlp,
      'compostos_toxicos': compostosToxicos,
      'gas_metano': gasMetano,
    };
  }

  String toJson() => jsonEncode(toMap());
}
