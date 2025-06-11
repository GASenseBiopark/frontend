import 'package:flutter/material.dart';
import 'package:gasense/_core/constants.dart';
import 'package:gasense/pages/navegation/new_device.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> dispositivos = [];

  void _navegarParaAdicionarDispositivo() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewDevicePage()),
    );

    if (resultado != null && resultado is Map<String, String>) {
      setState(() {
        dispositivos.add(resultado);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        title: const Center(
          child: Text(
            "Dispositivos",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body:
          dispositivos.isEmpty
              ? const Center(
                child: Text(
                  'Nenhum dispositivo adicionado',
                  style: AppText.texto,
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: dispositivos.length,
                itemBuilder: (context, index) {
                  final item = dispositivos[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Image.asset(
                        'assets/device.png',
                        width: 50,
                        height: 22,
                      ),
                      title: Text('Dispositivo ${index + 1}'),
                      subtitle: Text(
                        "Código: ${item['codigo'] ?? 'Sem código'}",
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navegarParaAdicionarDispositivo,
        backgroundColor: AppColors.blue,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
