import 'dart:async';
import 'package:gasense/save_data/salvar_dados_dispositivos.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:gasense/constants/constants.dart';
import 'package:gasense/controllers/controller_leituras.dart';
import 'package:gasense/models/dispositivo.dart';
import 'package:gasense/models/leitura.dart';
import 'package:gasense/pages/navegation/home.dart';
import 'package:fl_chart/fl_chart.dart';

class TelaGraficos extends StatefulWidget {
  final Dispositivo dispositivo;
  const TelaGraficos({super.key, required this.dispositivo});

  @override
  State<TelaGraficos> createState() => _TelaGraficosState();
}

class _TelaGraficosState extends State<TelaGraficos> {
  late LeituraController controller;
  bool carregando = true;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    controller = LeituraController(widget.dispositivo.idDispositivo);
    _carregarDados();

    // Atualização automática a cada 10 segundos:
    timer = Timer.periodic(Duration(seconds: 10), (_) => atualizar());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> _carregarDados() async {
    await controller.inicializar();
    setState(() {
      carregando = false;
    });
  }

  Future<void> atualizar() async {
    await controller.atualizar();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    bool alertaFogo = controller.leituras.take(10).any((e) => e.fogo == true);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: AppColors.black700),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever_rounded, color: AppColors.black700),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      backgroundColor: AppColors.white,
                      title: Text(
                        "Remover dispositivo",
                        style: AppText.textoGrande,
                      ),
                      content: Text(
                        "Deseja remover este dispositivo apenas deste celular?",
                        style: AppText.texto,
                      ),
                      actions: [
                        TextButton(
                          child: Text("Cancelar", style: AppText.texto),
                          onPressed: () => Navigator.pop(context, false),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Colors.red[400],
                            ),
                          ),
                          child: Text(
                            "Remover",
                            style: AppText.texto.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                          onPressed: () => Navigator.pop(context, true),
                        ),
                      ],
                    ),
              );

              if (confirm == true) {
                await removerDispositivo(widget.dispositivo.idDispositivo);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              }
            },
          ),
        ],
        title: const Text(
          "Leituras",
          style: TextStyle(color: AppColors.black700, fontSize: 22),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            transform: GradientRotation(1),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFFFFF), Color(0xFFECECEC)],
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildDispositivoHeader(widget.dispositivo),
                if (alertaFogo) ...[
                  buildAlertaFogo(),
                  const SizedBox(height: 16),
                ],
                buildResumoAtual(controller.leituraAtual),
                const SizedBox(height: 16),
                buildGraficoGases(),
                const SizedBox(height: 16),
                buildGraficoTempUmidade(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDispositivoHeader(Dispositivo dispositivo) {
    return Container(
      width: double.infinity,
      height: 130,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(dispositivo.nome, style: AppText.titulo.copyWith(fontSize: 24)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                color: AppColors.black700,
                size: 20,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  "${dispositivo.cidade ?? '---'}, ${dispositivo.estado ?? ''}, ${dispositivo.pais ?? ''}",
                  style: AppText.textoPequeno.copyWith(color: Colors.black54),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                color: AppColors.black700,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                "Cadastro: ${formatarData(dispositivo.dataCadastro)}",
                style: AppText.textoPequeno.copyWith(color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String formatarData(DateTime data) {
    final formatador = DateFormat('dd/MM/yyyy');
    return formatador.format(data);
  }

  Widget buildResumoAtual(Leitura? leitura) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = (constraints.maxWidth - 8 * 2) / 2;

        // Se tiver bastante espaço (tablet, desktop), coloca 3 por linha
        if (constraints.maxWidth > 600) {
          cardWidth = (constraints.maxWidth - 8 * 3) / 3;
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: Wrap(
            key: ValueKey(
              leitura,
            ), // Importante para o AnimatedSwitcher funcionar
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              buildCardValor(
                "Temperatura",
                leitura?.temperatura != null
                    ? "${leitura!.temperatura!.toStringAsFixed(1)} °C"
                    : "---",
                Icons.thermostat_rounded, // ícone de termômetro
                Colors.deepOrangeAccent,
                cardWidth,
              ),
              buildCardValor(
                "Umidade",
                leitura?.umidade != null
                    ? "${leitura!.umidade!.toStringAsFixed(1)} %"
                    : "---",
                Icons.water_drop_rounded, // ícone de gota
                Colors.lightBlueAccent,
                cardWidth,
              ),

              buildCardValor(
                "GLP",
                leitura?.gasGlp != null
                    ? "${leitura!.gasGlp!.toStringAsFixed(1)} ppm"
                    : "---",
                Icons.local_fire_department_rounded,
                AppColors.blue,
                cardWidth,
              ),

              buildCardValor(
                "Tóxicos",
                leitura?.compostosToxicos != null
                    ? "${leitura!.compostosToxicos!.toStringAsFixed(1)} ppm"
                    : "---",
                Icons.warning_amber_rounded,
                Colors.redAccent,
                cardWidth,
              ),

              buildCardValor(
                "Metano",
                leitura?.gasMetano != null
                    ? "${leitura!.gasMetano!.toStringAsFixed(1)} ppm"
                    : "---",
                Icons.bubble_chart_rounded,
                Colors.greenAccent,
                cardWidth,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildCardValor(
    String label,
    String valor,
    IconData icon,
    Color color,
    double width,
  ) {
    return Container(
      width: width,
      height: 130,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.9), color.withValues(alpha: 0.5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: Colors.white),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppText.textoPequeno.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  valor,
                  style: AppText.subtitulo.copyWith(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAlertaFogo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[400],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.white, size: 48),
          const SizedBox(height: 12),
          const Text(
            "ALERTA DE FOGO DETECTADO!",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildGraficoGases() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Gases - Última Hora", style: AppText.subtitulo),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                minY: 0,
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 50,
                  getDrawingHorizontalLine:
                      (_) =>
                          FlLine(strokeWidth: 0.5, color: Colors.grey.shade300),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 50,
                      reservedSize: 40,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  buildLine(
                    controller.leituras,
                    (e) => e.gasGlp ?? 0,
                    AppColors.blue,
                  ),
                  buildLine(
                    controller.leituras,
                    (e) => e.compostosToxicos ?? 0,
                    Colors.red,
                  ),
                  buildLine(
                    controller.leituras,
                    (e) => e.gasMetano ?? 0,
                    Colors.green,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              legenda("GLP", AppColors.blue),
              legenda("Tóxicos", Colors.red),
              legenda("Metano", Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildGraficoTempUmidade() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Temperatura & Umidade - Última Hora", style: AppText.subtitulo),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 2.5,
                  getDrawingHorizontalLine:
                      (_) =>
                          FlLine(strokeWidth: 0.5, color: Colors.grey.shade300),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 5,
                      reservedSize: 40,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  buildLine(
                    controller.leituras,
                    (e) => e.temperatura ?? 0,
                    AppColors.orange,
                  ),
                  buildLine(
                    controller.leituras,
                    (e) => e.umidade ?? 0,
                    AppColors.lightblue,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              legenda("Temperatura", AppColors.orange),
              legenda("Umidade", AppColors.lightblue),
            ],
          ),
        ],
      ),
    );
  }

  LineChartBarData buildLine(
    List<Leitura> data,
    double Function(Leitura) getY,
    Color color,
  ) {
    if (data.isEmpty) {
      return LineChartBarData(
        spots: [FlSpot(0, 0)],
        isCurved: true,
        color: color.withValues(alpha: 0.2),
        barWidth: 2.5,
        dotData: FlDotData(show: false),
      );
    }

    return LineChartBarData(
      spots:
          data
              .asMap()
              .entries
              .map((e) => FlSpot(e.key.toDouble(), getY(e.value)))
              .toList(),
      isCurved: true,
      color: color,
      barWidth: 2.5,
      dotData: FlDotData(show: false),
    );
  }

  Widget legenda(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: AppText.textoPequeno),
      ],
    );
  }
}
