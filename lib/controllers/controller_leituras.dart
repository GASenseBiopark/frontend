import 'package:gasense/models/leitura.dart';
import 'package:gasense/dao/leitura_dao.dart';

class LeituraController {
  final LeituraDAO dao = LeituraDAO();
  final String idDispositivo;

  List<Leitura> leituras = [];
  DateTime? ultimaData;

  LeituraController(this.idDispositivo);

  // Busca o histórico inicial
  Future<void> inicializar() async {
    leituras = await dao.buscarHistorico(idDispositivo, limite: 100);
    if (leituras.isNotEmpty) {
      ultimaData = leituras.first.dataHora;
    }
  }

  // Atualiza com as novas leituras
  Future<void> atualizar() async {
    if (ultimaData == null) return;

    final novas = await dao.buscarNovasLeituras(
      idDispositivo: idDispositivo,
      ultimaData: ultimaData!,
    );

    if (novas.isNotEmpty) {
      leituras.insertAll(0, novas);
      ultimaData = novas.first.dataHora;
    }
  }

  // Última leitura (para mostrar no card principal)
  Leitura? get leituraAtual => leituras.isNotEmpty ? leituras.first : null;
}
