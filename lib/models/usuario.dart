class Usuario {
  int? idUsuario;
  String nome;
  String email;
  String senhaHash;
  String? dataCadastro;
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
      'data_cadastro': dataCadastro,
      'admin': admin ? 1 : 0, // SQLite armazena boolean como int
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      idUsuario: map['id_usuario'],
      nome: map['nome'],
      email: map['email'],
      senhaHash: map['senha_hash'],
      dataCadastro: map['data_cadastro'],
      admin: map['admin'] == 1,
    );
  }
}
