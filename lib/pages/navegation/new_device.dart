import 'package:flutter/material.dart';
import 'package:gasense/_core/constants.dart';
import 'package:gasense/home.dart';
import 'package:gasense/widgets/inputform.dart';

class NewDevicePage extends StatefulWidget {
  const NewDevicePage({super.key});

  @override
  State<NewDevicePage> createState() => _NewDevicePageState();
}

class _NewDevicePageState extends State<NewDevicePage> {
  final TextEditingController _codigoController = TextEditingController();

  void _adicionarDispositivo() {
    final codigo = _codigoController.text.trim();

    if (codigo.isNotEmpty) {
      Navigator.pop(context, {'codigo': codigo});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
        title: const Text(
          "Novo Dispositivo",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Image.asset('../assets/device.png', width: 200, height: 200),
            const SizedBox(height: 50),
            inputFormulario(
              controller: _codigoController,
              textoLabel: "Código",
              icone: Icons.numbers,
            ),
            const SizedBox(height: 30),
            Center(
              child: SizedBox(
                width: 220,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    final codigo = _codigoController.text.trim();
                    if (codigo.isNotEmpty) {
                      Navigator.pop(context, {'codigo': codigo});
                    }
                  },
                  child: Text(
                    "Adicionar dispositivo",
                    style: AppText.textoBranco,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
