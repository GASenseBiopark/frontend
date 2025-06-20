import 'package:gasense/models/dispositivo.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> salvarDispositivo(Dispositivo dispositivo) async {
  final prefs = await SharedPreferences.getInstance();

  // Salva o dispositivo individualmente
  await prefs.setString(
    'dispositivo_${dispositivo.idDispositivo}',
    dispositivo.toJson(),
  );

  // Atualiza a lista de IDs
  List<String> listaIds = prefs.getStringList('lista_dispositivos') ?? [];

  if (!listaIds.contains(dispositivo.idDispositivo)) {
    listaIds.add(dispositivo.idDispositivo);
    await prefs.setStringList('lista_dispositivos', listaIds);
  }
}

Future<List<Dispositivo>> carregarDispositivos() async {
  final prefs = await SharedPreferences.getInstance();
  final listaIds = prefs.getStringList('lista_dispositivos') ?? [];

  List<Dispositivo> dispositivos = [];

  for (var id in listaIds) {
    final jsonString = prefs.getString('dispositivo_$id');
    if (jsonString != null) {
      dispositivos.add(Dispositivo.fromJson(jsonString));
    }
  }

  return dispositivos;
}