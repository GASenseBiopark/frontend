import 'package:flutter/material.dart';

class GaSenseDataCard extends StatefulWidget {
  const GaSenseDataCard({super.key});

  @override
  State<GaSenseDataCard> createState() => _GaSenseDataCardState();
}

class _GaSenseDataCardState extends State<GaSenseDataCard> {
  late Map<String, dynamic> data;
  late TimeOfDay hora;

  @override
  void initState() {
    super.initState();
    data = mockarDados();
    hora = TimeOfDay.now();
  }

  Map<String, dynamic> mockarDados() {
    return {
      'temperatura': 24.5,
      'umidade': 65,
      'sensoresAtivos': 5,
      'ch4': {'valor': 450, 'percent': 25},
      'co2': {'valor': 850, 'percent': 65},
      'glp': {'valor': 120, 'percent': 15},
      'chama': {'detectado': false},
    };
  }

  Widget sensorCard(
    String nome,
    String sensor,
    int valor,
    int percent,
    Color cor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFf8fafc),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            nome,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            sensor,
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
          const SizedBox(height: 12),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: percent / 100,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(cor),
                  strokeWidth: 8,
                ),
              ),
              Text(
                "$percent%",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "$valor ppm",
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget chamaCard(bool detectada) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFf8fafc),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Detecção de Chama",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          const Text(
            "Sensor KY-026",
            style: TextStyle(color: Colors.black54, fontSize: 12),
          ),
          const SizedBox(height: 20),
          Icon(
            detectada
                ? Icons.warning_amber_rounded
                : Icons.check_circle_outline,
            color: detectada ? Colors.red : Colors.blue,
            size: 40,
          ),
          const SizedBox(height: 10),
          Text(
            detectada ? "Detectada" : "Não Detectada",
            style: TextStyle(
              color: detectada ? Colors.red : Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            detectada ? "Status: Perigo" : "Status: Seguro",
            style: TextStyle(
              color: detectada ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final horaFormatada = hora.format(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BioLab Monitor'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: const [
                Icon(Icons.circle, color: Colors.green, size: 12),
                SizedBox(width: 6),
                Text("Conectado", style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  "Última atualização: $horaFormatada",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 1;
                if (constraints.maxWidth > 600) {
                  crossAxisCount = 3;
                }
                if (constraints.maxWidth > 1000) {
                  crossAxisCount = 4;
                }

                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.9,
                  children: [
                    sensorCard(
                      "Metano (CH₄)",
                      "Sensor MG4",
                      data['ch4']['valor'],
                      data['ch4']['percent'],
                      Colors.green,
                    ),
                    sensorCard(
                      "Dióxido de Carbono (CO₂)",
                      "Sensor MG135",
                      data['co2']['valor'],
                      data['co2']['percent'],
                      Colors.orange,
                    ),
                    sensorCard(
                      "Gás Liquefeito de Petróleo (GLP)",
                      "Sensor MQ2",
                      data['glp']['valor'],
                      data['glp']['percent'],
                      Colors.blue,
                    ),
                    chamaCard(data['chama']['detectado']),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
