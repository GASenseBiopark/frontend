class Usuario {
  int? idUsuario;
  String nome;
  String email;
  String senhaHash;
  String? dataCadastro;

  Usuario({
    this.idUsuario,
    required this.nome,
    required this.email,
    required this.senhaHash,
    this.dataCadastro,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_usuario': idUsuario,
      'nome': nome,
      'email': email,
      'senha_hash': senhaHash,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      idUsuario: map['id_usuario'],
      nome: map['nome'],
      email: map['email'],
      senhaHash: map['senha_hash'],
    );
  }
}
