import 'package:sqflite/sqflite.dart';
import 'app_database.dart';
import '../models/usuario.dart'; // Você precisaria de um modelo Usuario

class UsuarioDAO {
  final AppDatabase _appDatabase = AppDatabase();

  Future<int> inserir(Usuario usuario) async {
    final db = await _appDatabase.database;
    return await db.insert(
      'usuarios',
      usuario.toMap(), // Método toMap() no seu modelo Usuario
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Usuario?> buscarPorEmail(String email) async {
    final db = await _appDatabase.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'usuarios',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return Usuario.fromMap(
        maps.first,
      ); // Método fromMap() no seu modelo Usuario
    }
    return null;
  }

  Future<int> deletar(int idUsuario) async {
    final db = await _appDatabase.database;
    return await db.delete(
      'usuarios',
      where: 'id_usuario = ?',
      whereArgs: [idUsuario],
    );
  }

  // Outros métodos CRUD...
}
