class Dispositivo {
  final String idDispositivo;
  final String nome;
  final int? localizacao;
  final DateTime dataCadastro;
  final int? idUsuario;
  final String? cep;
  final String? estado;
  final String? cidade;
  final String? pais;
  final String? rua;
  final String? numero;
  final String? complemento;
  final DateTime? dataCadastroLocalizacao;

  Dispositivo({
    required this.idDispositivo,
    required this.nome,
    this.localizacao,
    required this.dataCadastro,
    this.idUsuario,
    this.cep,
    this.estado,
    this.cidade,
    this.pais,
    this.rua,
    this.numero,
    this.complemento,
    this.dataCadastroLocalizacao,
  });

  factory Dispositivo.fromMap(Map<String, dynamic> map) {
    return Dispositivo(
      idDispositivo: map['id_dispositivo'] as String,
      nome: map['nome'] as String,
      localizacao: map['localizacao'],
      dataCadastro: DateTime.parse(map['data_cadastro']),
      idUsuario: map['id_usuario'],
      cep: map['cep'],
      estado: map['estado'],
      cidade: map['cidade'],
      pais: map['pais'],
      rua: map['rua'],
      numero: map['numero'],
      complemento: map['complemento'],
      dataCadastroLocalizacao:
          map['data_cadastro_localizacao'] != null
              ? DateTime.parse(map['data_cadastro_localizacao'])
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_dispositivo': idDispositivo,
      'nome': nome,
      'localizacao': localizacao,
      'data_cadastro': dataCadastro.toIso8601String(),
      'id_usuario': idUsuario,
      'cep': cep,
      'estado': estado,
      'cidade': cidade,
      'pais': pais,
      'rua': rua,
      'numero': numero,
      'complemento': complemento,
      'data_cadastro_localizacao': dataCadastroLocalizacao?.toIso8601String(),
    };
  }
}
