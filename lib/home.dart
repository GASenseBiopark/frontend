import 'package:flutter/material.dart';
import 'package:gasense/constants/constants.dart';
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
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.blue,
        title: Center(
          child: Text(
            "Dispositivos",
            style: TextStyle(
              fontWeight: FontWeight.w400,
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
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.grey, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Card(
                      color: AppColors.grey200,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        tileColor: AppColors.grey200,
                        leading: Image.asset(
                          'assets/device.png',
                          width: 50,
                          height: 22,
                        ),
                        title: Text(
                          'Dispositivo ${index + 1}',
                          style: AppText.textoBranco,
                        ),
                        subtitle: Text(
                          "Código: ${item['codigo'] ?? 'Sem código'}",
                          style: AppText.textoBranco,
                        ),
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
