import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gasense/constants/constants.dart';
import 'package:gasense/controllers/controller_leituras.dart';
import 'package:gasense/models/leitura.dart';
import 'package:gasense/pages/navegation/home.dart';
import 'package:fl_chart/fl_chart.dart';

class TelaGraficos extends StatefulWidget {
  final String idDispositivo;
  const TelaGraficos({super.key, required this.idDispositivo});

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
    controller = LeituraController(widget.idDispositivo);
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

    bool alertaFogo = controller.leituras.any((e) => e.fogo == true);

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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildResumoAtual(controller.leituraAtual),
                if (alertaFogo) ...[
                  const SizedBox(height: 16),
                  buildAlertaFogo(),
                ],
                const SizedBox(height: 24),
                buildGraficoGases(),
                const SizedBox(height: 24),
                buildGraficoTempUmidade(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildResumoAtual(Leitura? leitura) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        buildCardValor(
          "Temperatura",
          leitura?.temperatura != null
              ? "${leitura!.temperatura!.toStringAsFixed(1)} °C"
              : "---",
          AppColors.red,
        ),
        buildCardValor(
          "Umidade",
          leitura?.umidade != null
              ? "${leitura!.umidade!.toStringAsFixed(1)} %"
              : "---",
          AppColors.green,
        ),
        buildCardValor(
          "GLP",
          leitura?.gasGlp != null
              ? "${leitura!.gasGlp!.toStringAsFixed(1)} ppm"
              : "---",
          AppColors.blue,
        ),
        buildCardValor(
          "Tóxicos",
          leitura?.compostosToxicos != null
              ? "${leitura!.compostosToxicos!.toStringAsFixed(1)} ppm"
              : "---",
          Colors.orange,
        ),
        buildCardValor(
          "Metano",
          leitura?.gasMetano != null
              ? "${leitura!.gasMetano!.toStringAsFixed(1)} ppm"
              : "---",
          Colors.purple,
        ),
      ],
    );
  }

  Widget buildCardValor(String label, String valor, Color color) {
    return Container(
      width: 160,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: AppText.textoPequeno.copyWith(color: color)),
            const SizedBox(height: 4),
            Text(valor, style: AppText.subtitulo),
          ],
        ),
      ),
    );
  }

  Widget buildAlertaFogo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
          Icon(Icons.warning_amber_rounded, color: Colors.white, size: 40),
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
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Gases - Última Hora", style: AppText.subtitulo),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
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
                    Colors.orange,
                  ),
                  buildLine(
                    controller.leituras,
                    (e) => e.gasMetano ?? 0,
                    Colors.purple,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              legenda("GLP", AppColors.blue),
              legenda("Tóxicos", Colors.orange),
              legenda("Metano", Colors.purple),
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
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Temperatura & Umidade", style: AppText.subtitulo),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 5,
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
                    AppColors.red,
                  ),
                  buildLine(
                    controller.leituras,
                    (e) => e.umidade ?? 0,
                    AppColors.green,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              legenda("Temperatura", AppColors.red),
              legenda("Umidade", AppColors.green),
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
      isCurved: false,
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
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: AppText.textoPequeno),
      ],
    );
  }
}
