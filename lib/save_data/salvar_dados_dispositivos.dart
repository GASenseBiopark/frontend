import 'package:gasense/models/dispositivo.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> salvarDadosDispositivos(List<Dispositivo> dispositivos) async {
  final prefs = await SharedPreferences.getInstance();

  for (var dispositivo in dispositivos) {
    await prefs.setString(
      'dispositivo_${dispositivo.idDispositivo}',
      dispositivo.toJson(),
    );
  }
}
