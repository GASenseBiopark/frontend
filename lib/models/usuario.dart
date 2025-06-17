class Usuario {
  int? idUsuario;
  String nome;
  String email;
  String senhaHash;
  DateTime? dataCadastro;
  bool admin;

  Usuario({
    this.idUsuario,
    required this.nome,
    required this.email,
    required this.senhaHash,
    this.dataCadastro,
    this.admin = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_usuario': idUsuario,
      'nome': nome,
      'email': email,
      'senha_hash': senhaHash,
      'data_cadastro': dataCadastro?.toIso8601String(),
      'admin': admin ? 1 : 0, // SQLite armazena boolean como int
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      idUsuario: map['id_usuario'],
      nome: map['nome'],
      email: map['email'],
      senhaHash: map['senha_hash'],
      dataCadastro:
          map['data_cadastro'] is String
              ? DateTime.parse(map['data_cadastro'])
              : map['data_cadastro'] is int
              ? DateTime.fromMillisecondsSinceEpoch(map['data_cadastro'])
              : map['data_cadastro'] as DateTime?,
      admin: map['admin'] == 1,
    );
  }
}
