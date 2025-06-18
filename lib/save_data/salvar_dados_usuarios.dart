import 'package:gasense/models/usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> salvarDadosUsuario(Usuario usuario) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('id_usuario', usuario.idUsuario ?? 0);
  await prefs.setString('nome', usuario.nome);
  await prefs.setString('email', usuario.email);
}
